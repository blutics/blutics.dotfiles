-- lua/favdirs.lua
local M = {}

local json = vim.json or vim.json_decode -- nvim>=0.9: vim.json
local DATA = (vim.fn.stdpath("data") .. "/favdirs.json")

local function read_file(path)
	local fd = io.open(path, "r")
	if not fd then
		return nil
	end
	local s = fd:read("*a")
	fd:close()
	return s
end

local function write_file(path, s)
	vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
	local fd, err = io.open(path, "w")
	assert(fd, err)
	fd:write(s)
	fd:close()
end

local function norm(p)
	-- 확장 + 정규화 + 실제경로(가능하면)
	p = vim.fn.expand(p)
	p = vim.fs.normalize(p)
	local ok, real = pcall(vim.loop.fs_realpath, p)
	return (ok and real) or p
end

local function load()
	local s = read_file(DATA)
	if not s or s == "" then
		return {}
	end
	local ok, t = pcall(vim.json.decode, s)
	return (ok and t) or {}
end

local function save(t)
	write_file(DATA, vim.json.encode(t))
end

-- 중복 방지(경로 기준)
local function upsert(favs, path, name)
	path = norm(path)
	for i, it in ipairs(favs) do
		if it.path == path then
			it.name = name or it.name
			return favs
		end
	end
	table.insert(favs, { name = name or vim.fn.fnamemodify(path, ":t"), path = path })
	return favs
end

-- 공개 API --------------------------------------------------------------

local layout_config = {
	width = 0.6,
	height = 0.4,
}

function M.add(path, name)
	path = path or vim.fn.getcwd()
	local favs = load()
	save(upsert(favs, path, name))
	vim.notify(("Fav added: %s"):format(norm(path)))
end

function M.delete_picker()
	local favs = load()
	if #favs == 0 then
		return vim.notify("No favorites", vim.log.levels.INFO)
	end
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = "Delete Favorite",
      layout_config = layout_config,
			finder = finders.new_table({
				results = favs,
				entry_maker = function(it)
					return {
						value = it,
						display = string.format("%-20s", it.name) .. "  " .. it.path,
						ordinal = it.name .. " " .. it.path,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(bufnr, map)
				local function del_current()
					local e = state.get_selected_entry()
					if not e then
						return
					end
					-- remove
					local out = {}
					for _, it in ipairs(favs) do
						if it.path ~= e.value.path then
							table.insert(out, it)
						end
					end
					save(out)
					actions.close(bufnr)
					vim.notify(("Fav deleted: %s"):format(e.value.path))
				end
				map("i", "<CR>", del_current)
				map("n", "<CR>", del_current)
				return true
			end,
		})
		:find()
end

function M.pick()
	local favs = load()
	if #favs == 0 then
		return vim.notify("No favorites", vim.log.levels.INFO)
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local state = require("telescope.actions.state")
	local builtin = require("telescope.builtin")

	pickers
		.new({}, {
			prompt_title = "Favorite Directories",
      layout_config = layout_config,
			finder = finders.new_table({
				results = favs,
				entry_maker = function(it)
					return {
						value = it.path,
						display = string.format("%-20s", it.name) .. "  " .. it.path,
						ordinal = it.name .. " " .. it.path,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(bufnr, map)
				local function open_with(fn)
					local e = state.get_selected_entry()
					if not e then
						return
					end
					actions.close(bufnr)
					fn({ cwd = e.value })
				end
				-- Enter: find_files / Ctrl-g: live_grep
				map("i", "<CR>", function()
					open_with(builtin.find_files)
				end)
				map("n", "<CR>", function()
					open_with(builtin.find_files)
				end)
				map("i", "<C-g>", function()
					open_with(builtin.live_grep)
				end)
				map("n", "<C-g>", function()
					open_with(builtin.live_grep)
				end)
				return true
			end,
		})
		:find()
end

return M
