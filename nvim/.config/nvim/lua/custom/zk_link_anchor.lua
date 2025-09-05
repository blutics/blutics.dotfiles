-- ZkInsertLink + marksman로 헤더 앵커까지 붙여넣기 (타이틀은 Zk 결과 사용)
local M = {}

M.opts = {
	link_style = "markdown", -- "markdown" | "wiki"
	keep_md_extension = true, -- markdown 링크에 .md 유지(앵커/호환 ↑)
	timeout_ms = 1200,
}

-- ── 유틸 ────────────────────────────────────────────────────────────────────
local function rel_to_current(path)
	local curdir = vim.fn.expand("%:p:h")
	local ok, rel = pcall(vim.fs.relpath, path, curdir)
	return ok and rel or path
end

local function slugify_gfm(s)
	s = (s or ""):lower()
	s = s:gsub("[%[%]%(%):\"'`.,!?/\\<>~@#$%%^&*+=|{};]", "")
	s = s:gsub("%s+", "-")
	s = s:gsub("-+", "-"):gsub("^%-", ""):gsub("%-$", "")
	return s
end

-- marksman만으로 헤더 수집(필요 시 해당 버퍼에만 임시로 붙임)
-- 단일 파일만 대상으로 marksman에서 헤더(문서 심볼) 가져오기
-- (A) 이미 떠 있는 marksman 중 "root가 abs_path를 포함"하는 클라이언트 찾기
local function find_covering_marksman(abs_path)
	local function is_ancestor(root, path)
		if not root or root == "" then
			return false
		end
		root = root:gsub("/+$", "")
		return path:sub(1, #root) == root
	end

	for _, c in ipairs(vim.lsp.get_clients()) do
		if c.name == "marksman" or c.name:match("^marksman") then
			-- 후보 루트들: workspace_folders + config.root_dir
			local roots = {}
			if c.workspace_folders then
				for _, wf in ipairs(c.workspace_folders) do
					table.insert(roots, vim.uri_to_fname(wf.uri))
				end
			end
			if c.config and c.config.root_dir then
				table.insert(roots, c.config.root_dir)
			end
			for _, r in ipairs(roots) do
				if is_ancestor(r, abs_path) then
					return c, r
				end
			end
		end
	end
	return nil, nil
end

-- (B) "붙이지 않고" 기존 marksman에 documentSymbol 요청해 헤더 목록 얻기
local function headers_via_existing_marksman(abs_path, timeout_ms, opts)
	timeout_ms = timeout_ms or 1000
	opts = opts or { open_if_needed = true } -- didOpen/didClose 임시 전송 허용 여부

	-- 버퍼는 읽어오되 attach는 하지 않음(요청은 client.request_sync로 직접)
	local uri = vim.uri_from_fname(abs_path)
	local client, root = find_covering_marksman(abs_path)
	if not client then
		-- 기존 클라이언트가 아예 없으면 비워서 반환(요구사항대로 새로 띄우지 않음)
		return {}
	end

	local function collect()
		local res = client.request_sync("textDocument/documentSymbol", { textDocument = { uri = uri } }, timeout_ms)
		local out = {}
		if res and res.result then
			local function walk(nodes, depth)
				if not nodes then
					return
				end
				for _, n in ipairs(nodes) do
					local sr = (n.selectionRange or n.range or {}).start
					out[#out + 1] = {
						name = n.name or "",
						depth = depth or 1,
						lnum = sr and (sr.line + 1) or 1,
					}
					walk(n.children, (depth or 1) + 1)
				end
			end
			walk(res.result, 1)
		end
		return out
	end

	-- 1차: 그냥 요청(대부분은 이걸로 충분)
	local items = collect()
	if #items > 0 or not opts.open_if_needed then
		return items
	end

	-- 2차(선택): 버퍼를 "열었다고" 통지만 하고(attach 없이), 다시 요청 → 끝나면 닫기 통지
	--  *attach 아님*  client.notify로 didOpen/Close만 보냄
	local ok, text = pcall(function()
		return table.concat(vim.fn.readfile(abs_path), "\n")
	end)
	if ok and text then
		client.notify("textDocument/didOpen", {
			textDocument = { uri = uri, languageId = "markdown", version = 1, text = text },
		})
		items = collect()
		client.notify("textDocument/didClose", { textDocument = { uri = uri } })
	end

	return items
end

-- 링크 생성(위키는 alias=title, 없으면 파일명)
local function make_link(target_abs, header, link_style, keep_ext, display_title)
	local rel = rel_to_current(target_abs)
	local filename_base = vim.fn.fnamemodify(target_abs, ":t:r")
	local display = (display_title and display_title ~= "" and display_title) or filename_base
	local anchor = header and ("#" .. slugify_gfm(header.name)) or ""
	vim.print(anchor)

	if link_style == "wiki" then
		if rel:sub(-3) == ".md" then
			rel = rel:sub(1, -4)
		end
		return ("[[%s%s]]"):format(display, anchor) -- [[path#slug|title]]
	else
		if not keep_ext and rel:sub(-3) == ".md" then
			rel = rel:sub(1, -4)
		end
		return ("[%s](%s%s)"):format(display, rel, anchor) -- [title](path#slug)
	end
end

-- ── ① ZkInsertLink와 동일한 피커로 “노트 선택” ─────────────────────────────
local function pick_note(cb)
	require("zk").pick_notes({}, { title = "Zk Insert Link · pick note" }, function(note)
		cb(note) -- note.path / note.title 제공됨(title 없을 수 있음)
	end)
end

-- ── ② 헤더 선택: vim.ui.select (telescope-ui-select 있으면 텔레스코프 UI) ──
local function pick_header(abs_path, headers, cb)
	if #headers == 0 then
		return cb(nil)
	end
	local display, map = {}, {}
	for _, h in ipairs(headers) do
		local indent = string.rep("  ", math.max(0, (h.depth or 1) - 1))
		local line = indent .. h.name
		display[#display + 1] = line
		map[line] = h
	end
	vim.ui.select(display, { prompt = ("Pick header · %s"):format(rel_to_current(abs_path)) }, function(choice)
		cb(choice and map[choice] or nil)
	end)
end

-- ── 메인 명령 ───────────────────────────────────────────────────────────────
function M.insert_link_with_header(opts)
	opts = vim.tbl_deep_extend("force", M.opts, opts or {})

	pick_note(function(notes)
		if not notes then
			return
		end
		local note = notes[1]
		local display_title = (note.title and note.title ~= "" and note.title) or vim.fn.fnamemodify(note.path, ":t:r")
		local headers = headers_via_existing_marksman(note.absPath, opts.timeout_ms, {
			open_if_needed = true, -- 필요 없다면 false
		}) or {}
		vim.print(headers)

		pick_header(note.absPath, headers, function(header)
			local link = make_link(note.absPath, header, opts.link_style, opts.keep_md_extension, display_title)
			vim.api.nvim_put({ link }, "", true, true)
		end)
	end)
end

return M
