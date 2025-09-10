-- Telescope로 디렉터리 선택 → 타이틀 입력 → 해당 폴더에 :ZkNew
local M = {}

M.opts = {
	root = vim.env.ZK_NOTEBOOK_DIR or vim.loop.cwd(), -- 스캔 시작 루트
	depth = 4, -- 하위 깊이
	show_hidden = false, -- 숨김 폴더 포함 여부
	ignore = { ".git", "node_modules", ".venv", ".obsidian", ".zk", "dist", "build", "target", ".cache" },
}

-- 견고한 상대경로 계산기
local function path_rel(path, base)
	local uv = vim.uv or vim.loop

	local function real(p)
		if not p or p == "" then
			return nil
		end
		-- 실경로(심볼릭 해제) → 정규화 → 끝 슬래시 제거
		local r = uv.fs_realpath(p) or p
		r = vim.fs.normalize(r):gsub("[/\\]+$", "")
		return r
	end

	local p = real(path)
	local b = real(base) or real(uv.cwd()) -- base 없으면 CWD
	if not p or not b then
		return path -- 원본 반환(최소 악화)
	end

	if p == b then
		return "." -- 루트 자기 자신이면 점으로
	end

	-- 1차: 표준 relpath
	local rel = vim.fs.relpath(p, b)
	if rel and rel ~= "" then
		return rel
	end

	-- 2차: 수동 접두사 스트립(플랫폼 독립)
	local prefix = b .. "/"
	if p:sub(1, #prefix) == prefix then
		local s = p:sub(#prefix + 1)
		return (s == "" and ".") or s
	end

	-- 3차: 공통 조상 없으면 절대경로 그대로
	return p
end

local function should_ignore(path, ignore_list)
	for _, seg in ipairs(ignore_list or {}) do
		if path:find("/" .. vim.pesc(seg) .. "/") or path:match("/" .. vim.pesc(seg) .. "$") then
			return true
		end
	end
	return false
end

local function list_dirs(root, depth, show_hidden, ignore_list)
	local scan = require("plenary.scandir").scan_dir
	local dirs = { root }
	local found = scan(root, {
		depth = depth or 3,
		add_dirs = true,
		only_dirs = true,
		hidden = show_hidden or false,
		respect_gitignore = true,
	}) or {}
	for _, d in ipairs(found) do
		if not should_ignore(d, ignore_list) then
			table.insert(dirs, d)
		end
	end
	table.sort(dirs)
	return dirs
end

local function build_cmd(tbl)
	local parts = {}
	for k, v in pairs(tbl) do
		if type(v) == "string" then
			parts[#parts + 1] = (("%s = %q"):format(k, v))
		elseif type(v) == "boolean" then
			parts[#parts + 1] = (("%s = %s"):format(k, v and "true" or "false"))
		end
	end
	return ("ZkNew { %s }"):format(table.concat(parts, ", "))
end

-- ★ .zk가 있는 프로젝트에서만 zk LSP attach
function M.zk_root_for(bufnr)
	bufnr = bufnr or 0
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == nil or name == "" then
		return nil
	end
	local start = vim.fs.dirname(name)
	-- 현재 디렉터리부터 위로 .zk 디렉터리를 찾음
	local root = vim.fs.root(start, { ".zk" })
	if not root then
		return nil
	end
	-- .zk 실제 존재 확인(안전)
	if vim.fn.isdirectory(root .. "/.zk") ~= 1 then
		return nil
	end
	return root
end

function M.new_in_dir(opts)
	opts = vim.tbl_deep_extend("force", M.opts, opts or {})

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

  local cb = vim.api.nvim_get_current_buf()
  local root = M.zk_root_for(cb)

	local dirs = list_dirs(root, opts.depth, opts.show_hidden, opts.ignore)

	local function do_create(dir)
		if not dir or dir == "" then
			return
		end
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
		local title = vim.fn.input("Title: ")
		if not title or title == "" then
			return
		end
		local _cmd = build_cmd({ title = title, dir = dir })
		vim.cmd(_cmd)
	end

	local theme = require("telescope.themes").get_dropdown({
		width = 0.5, -- 화면의 50%
		results_height = 20, -- 결과창 높이(줄 수)
		previewer = false,
	})

	pickers
		.new(theme, {
			prompt_title = ("Pick directory · %s"):format(opts.root),
			finder = finders.new_table({
				results = dirs,
				entry_maker = function(p)
					return {
						value = p,
						display = path_rel(p, opts.root),
						ordinal = p,
						path = p,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = false,
			attach_mappings = function(prompt_bufnr, map)
				local function select_current()
					local entry = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					do_create(entry and entry.value or nil)
				end
				map("i", "<CR>", select_current)
				map("n", "<CR>", select_current)

				return true
			end,
		})
		:find()
end

return M
