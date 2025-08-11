local M = {}

function M.search_by_aliases_in_vautl_dir_path(vault_dir_path)
	-- aliases를 검색한다. vault 내부의 dir이 입력값으로 들어온다.
	local vault_path = tostring(vault_dir_path)

	-- ripgrep으로 aliases를 포함한 파일 찾기
	local cmd = string.format([[rg -U -l "aliases:\s*(\n\s*[-*]\s*[^\n]*)*" %s]], vault_path)
	local files = vim.fn.systemlist(cmd)

	-- 각 파일의 aliases 추출
	local entries = {}
	for _, file in ipairs(files) do
		local content = vim.fn.readfile(file)
		local mtime = vim.fn.getftime(file) -- Unix timestamp 반환
		local mtime_str = vim.fn.strftime("%Y-%m-%d %H:%M:%S", mtime)
		local in_aliases = false
		local aliases = {}

		for _, line in ipairs(content) do
			if line:match("^aliases:") then
				in_aliases = true
			elseif in_aliases then
				local alias = line:match("^%s*[-*]%s*(.+)")
				if alias then
					table.insert(aliases, vim.trim(alias))
				else
					if line:match("^%s*[a-zA-Z]+:") then
						in_aliases = false
					end
				end
			end
		end

		if #aliases > 0 then
			local title = file:match("([^/]+)%.md$")
			for index, alias in pairs(aliases) do
				table.insert(entries, {
					index = index,
					length = #aliases,
					title = title,
					file = file,
					alias = alias,
					mtime = mtime_str,
				})
			end
		end
	end

	-- Telescope로 결과 표시
	require("telescope.pickers")
		.new({}, {
			prompt_title = "Obsidian Aliases",
			finder = require("telescope.finders").new_table({
				results = entries,
				entry_maker = function(entry)
					return {
						value = entry,
						display = string.format(
							"%15s | %19s | %2d | %2d | %s",
							entry.title,
							entry.mtime,
							entry.length,
							entry.index,
							entry.alias
						),
						ordinal = entry.title .. " " .. entry.alias,
					}
				end,
			}),
			sorter = require("telescope.config").values.generic_sorter({}),
			attach_mappings = function(prompt_bufnr)
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")

				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					-- 선택한 노트의 링크 삽입
					vim.api.nvim_put(
						{ "[[" .. selection.value.title .. "|" .. selection.value.alias .. "]]" },
						"",
						true,
						true
					)
				end)
				return true
			end,
		})
		:find()
end

function M.search_by_aliases()
	-- aliases를 검색한다. vault의 루트로 부터.
	local client = require("obsidian").get_client()
	local vault_path = tostring(client.dir)
	print(vault_path)
	M.search_by_aliases_in_vautl_dir_path(vault_path)
end

function M.search_by_aliases_within_a_directory()
	M.get_obsidian_directories(function(relative_path)
		print(relative_path)
		local obsidian = require("obsidian")
		local client = obsidian.get_client()

		local vault_path = client.current_workspace.path.filename
		local abs_path = vault_path .. "/" .. relative_path
		search_by_aliases_in_vautl_dir_path(abs_path)
	end)
end

function M.get_obsidian_directories(callback)
	-- 옵시디언 볼트의 폭더들을 선택 후 해당 디렉토리를 바탕으로 callback으로 특정 작업 진행하기
	local obsidian = require("obsidian")
	local client = obsidian.get_client()
	local vault_path = client.current_workspace.path.filename

	require("telescope").extensions.file_browser.file_browser({
		prompt_title = "Create Note in Current Vault",
		cwd = vault_path,
		hidden = false,
		respect_gitignore = false,
		previewer = false,
		select_buffer = true,
		only_dirs = true,
		hide_parent_dir = true,
		files = false, -- 파일 표시 비활성화
		depth = 1, -- 한 번에 한 레벨만 표시
		dir_icon = "📁", -- 디렉토리 아이콘
		attach_mappings = function(prompt_bufnr, map)
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			local create_note = function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)

				local relative_path = string.sub(selection.path, #vault_path + 2) -- string.sub -> (a, b) 문자열 a를 index b부터 잘라서 리턴한다.
				callback(relative_path)
			end
			map("i", "<CR>", create_note)
			map("n", "<CR>", create_note)
			return true
		end,
		layout_strategy = "vertical", -- 'horizontal', 'center' 등
		layout_config = {
			width = 0.4,
			height = 0.6,
		},
		sorting_strategy = "descending",
		prompt_title = "🌟 Recently 🌟", -- 커스텀 제목 설정
	})
end

function M.remove_checkbox()
	-- markdown에서 checkbox로 변형된 줄을 원상복귀시킨다.
	local line = vim.api.nvim_get_current_line()
	-- "- [ ]" 또는 "- [x]"를 "-"로 변경
	local new_line = line:gsub("^(%s*)%-%s%[.?%]%s(.*)", "%1%2 ")
	vim.api.nvim_set_current_line(new_line)
end

function M.make_note_in_any_directory()
	M.get_obsidian_directories(function(relative_path)
		vim.ui.input({
			prompt = "🎵 Enter note name: ",
		}, function(input)
			if input then
				-- vim.cmd("ObsidianNew " .. relative_path .. "/" .. input .. ".md")
				vim.cmd("ObsidianNew " .. relative_path .. "/" .. vim.fn.fnameescape(input))
			end
		end)
	end)
end

function M.make_note_in_inbox()
	vim.ui.input({
		prompt = "🔥 Enter note name: ",
	}, function(input)
		if input then
			-- vim.cmd("ObsidianNew " .. relative_path .. "/" .. input .. ".md")
			vim.cmd("ObsidianNew " .. vim.fn.fnameescape(input))
		end
	end)
end

return M
