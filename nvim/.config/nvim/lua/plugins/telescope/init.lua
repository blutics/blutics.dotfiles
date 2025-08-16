-- ~/.config/nvim/lua/plugins.lua 등 lazy.nvim 설정 파일에서:
local buffer_delete_force = function(prompt_bufnr)
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local current_picker = action_state.get_current_picker(prompt_bufnr)
	local multi_selections = current_picker:get_multi_selection()

	if next(multi_selections) then
		for _, selection in ipairs(multi_selections) do
			vim.api.nvim_buf_delete(selection.bufnr, { force = true })
		end
	else
		local selection = action_state.get_selected_entry()
		vim.api.nvim_buf_delete(selection.bufnr, { force = true })
	end
	-- Telescope 창 닫기
	actions.close(prompt_bufnr)

	-- 버퍼 목록 다시 열기
	vim.schedule(function()
		local tc = require("custom.telescope_custom")
		tc.custom_telescope_buffer()
	end)
end

return {
	{
		"nvim-telescope/telescope.nvim",
		-- version = "0.1.4", -- 특정 버전 사용
		lazy = false,
		priority = 700,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "ahmedkhalf/project.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			{ "nvim-telescope/telescope-file-browser.nvim" },
			{ "nvim-tree/nvim-web-devicons" },
			{ "folke/trouble.nvim" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				pickers = {
					buffers = {
						mappings = {
							i = {
								["<C-d>"] = buffer_delete_force,
							},

							n = {
								["<C-d>"] = buffer_delete_force,
							},
						},
					},
				},
				defaults = {
					file_ignore_patterns = {
						"node_modules/",
						"__pycache__",
					},

					-- 스피너 설정 (내부 작업용)
					spinner = {
						frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
						interval = 80,
					},
					mappings = {
						n = {
							["<Tab>"] = actions.toggle_selection,
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_file_sorter = true,
						override_generic_sorter = true,
						case_mode = "smart_case",
					},
					projects = {
						layout_strategy = "horizontal",
						layout_config = {
							width = 0.8, -- 전체 창의 80%
							height = 0.8, -- 전체 창의 80%
							preview_width = 0.6, -- 프리뷰 창이 차지하는 비율
							prompt_position = "top",
						},
						theme = "dropdown", -- dropdown 테마 사용
						hidden_files = false, -- 숨김 파일 표시 여부
					},
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("projects")
			-- telescope.load_extension("fidget")
			-- telescope.load_extension("noice")
		end,
	},
	{
		"LukasPietzschmann/telescope-tabs",
		config = function()
			require("telescope").load_extension("telescope-tabs")
			require("telescope-tabs").setup({
				-- Your custom config :^)
			})
		end,
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
}

-- Telescope.Import
