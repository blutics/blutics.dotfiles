local M = {}

-- 현재 버퍼 컨텍스트 생성
function M.ctx(bufnr)
	bufnr = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
	local filename = vim.api.nvim_buf_get_name(bufnr)
	return { bufnr = bufnr, filename = filename, dirname = vim.fn.fnamemodify(filename, ":h") }
end

-- nvim-lint 불러오기(안 떠 있으면 nil)
local function _lint()
	local ok, l = pcall(require, "lint")
	if not ok then
		return nil
	end
	return l
end

-- (A) “현재 버퍼에 설정된” 린터 이름들
--  - linters_by_ft[ft] 만 쓰고 있었다면 그대로 유지
--  - 필요하면 '*'/'_' 규칙까지 합치고 싶을 때를 대비해 옵션 제공
function M.configured_names(bufnr, opts)
	opts = opts or {}
	local l = _lint()
	if not l then
		return {}
	end
	bufnr = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
	local ft = vim.bo[bufnr].filetype
	local names = {}

	-- 기본: 해당 ft에 등록된 린터
	if l.linters_by_ft and l.linters_by_ft[ft] then
		vim.list_extend(names, l.linters_by_ft[ft])
	end

	-- 선택: fallback('_')/global('*')까지 포함하고 싶다면
	if opts.include_fallback then
		vim.list_extend(names, l.linters_by_ft["_"] or {})
	end
	if opts.include_global then
		vim.list_extend(names, l.linters_by_ft["*"] or {})
	end

	return names
end

-- (B) “지금 실제로 돌고 있는” 린터 이름들
function M.running_names(bufnr)
	local l = _lint()
	if not l or type(l.get_running) ~= "function" then
		return {}
	end
	-- bufnr 생략/0 → 현재 버퍼
	return l.get_running(bufnr or 0)
end
-- 상태줄/Winbar 등에 쓰기 좋은 표시 문자열
function M.running_status(bufnr)
	local names = M.running_names(bufnr)
	if #names == 0 then
		return "󰦕" -- idle
	end
	return "󱉶 " .. table.concat(names, ", ")
end

-- (C) linter 정의를 “사람이 읽기 좋은” 형태로 풀어쓰기
--     - cmd/args 가 함수일 수도 있으니 안전 호출 + 문자열만 출력
local function _resolve_cmd(def, ctx)
	local cmd = def.cmd or def.name
	if type(cmd) == "function" then
		local ok, res = pcall(cmd, ctx)
		cmd = ok and res or "<fn>"
	end
	return cmd
end

local function _resolve_args(def, ctx)
	local args = def.args
	if type(args) == "function" then
		local ok, res = pcall(args, ctx)
		args = (ok and type(res) == "table") and res or nil
	end
	if type(args) == "table" then
		local printable = {}
		for i, v in ipairs(args) do
			printable[i] = (type(v) == "string") and v or "<fn>"
		end
		return printable
	elseif type(args) == "string" then
		return { args }
	end
	return {}
end

-- 단일 린터를 설명으로 변환
function M.describe_linter(name, ctx)
	local l = _lint()
	if not l then
		return nil
	end
	local def = l.linters[name] or {}
	def.name = name
	local cmd = _resolve_cmd(def, ctx)
	local ok_exec = (type(cmd) == "string") and (vim.fn.executable(cmd) == 1)
	local args = _resolve_args(def, ctx)
	return {
		name = name,
		cmd = cmd,
		ok = ok_exec,
		args = args, -- 문자열 배열
		argstr = (#args > 0) and (" " .. table.concat(args, " ")) or "",
	}
end

-- (D) LintInfo용 줄 배열 생성(재사용 가능)
function M.build_lines(bufnr, opts)
	local l = _lint()
	bufnr = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
	if not l then
		return { "nvim-lint is not loaded yet." }
	end
	local ft = vim.bo[bufnr].filetype
	local lines = { ("filetype: %s"):format(ft) }

	-- Running
	local running = M.running_names(bufnr)
	table.insert(lines, ("running: %s"):format((#running > 0) and table.concat(running, ", ") or "<none>"))

	local names = M.configured_names(bufnr, opts)
	if #names == 0 then
		table.insert(lines, "No linters configured for this filetype.")
		return lines
	end

	table.insert(lines, "Linters:")
	local ctx = M.ctx(bufnr)
	for _, name in ipairs(names) do
		local d = M.describe_linter(name, ctx) or { name = name, cmd = "n/a", ok = false, argstr = "" }
		table.insert(
			lines,
			string.format(
				"  - %s : %s (%s%s)",
				d.name,
				d.ok and "OK" or "MISSING",
				tostring(d.cmd or "n/a"),
				d.argstr or ""
			)
		)
	end
	return lines
end

return M
