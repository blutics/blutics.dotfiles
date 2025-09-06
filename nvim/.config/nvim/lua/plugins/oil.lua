function make_custom_float_setting()
	return {
		max_width = 0,
		win_options = {
			winblend = 0,
			cursorline = true,
		},
		margin = {
			top = 2,
			right = 3,
			bottom = 2,
			left = 3,
		},
		override = function()
			-- 화면 크기의 80%를 사용
			local width = math.floor(vim.o.columns * 0.8)
			local height = math.floor(vim.o.lines * 0.8)

			-- 중앙 정렬을 위한 위치 계산
			local row = math.floor((vim.o.lines - height) / 2)
			local col = math.floor((vim.o.columns - width) / 2)
			vim.api.nvim_create_autocmd("WinEnter", {
				callback = function()
					vim.wo.foldcolumn = "1"
					vim.wo.signcolumn = "no"
					vim.wo.numberwidth = 3
				end,
				once = true,
			})

			return {
				border = "rounded",
				row = row,
				col = col,
				width = width,
				height = height,
				relative = "editor",
				style = "minimal",
			}
		end,
	}
end

return {
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
				default_file_explorer = true,
				-- Id is automatically added at the beginning, and name at the end
				-- See :help oil-columns
				columns = {
					"icon",
					"permissions",
					"size",
					"mtime",
				},
				-- Buffer-local options to use for oil buffers
				buf_options = {
					buflisted = false,
					bufhidden = "hide",
				},
				-- Window-local options to use for oil buffers
				win_options = {
					wrap = false,
					signcolumn = "yes:2",
					cursorcolumn = false,
					foldcolumn = "0",
					spell = false,
					list = false,
					conceallevel = 3,
					concealcursor = "nvic",
				},
				-- 파일 시스템 작업 후 자동으로 LSP 새로고침
				lsp_file_methods = {
					autosave_changes = true,
					rename = true,
				},
				-- 기본 키매핑
				keymaps = {
					["g?"] = "actions.show_help",
					["<C-l>"] = "actions.select",
					["<C-v>"] = "actions.select_vsplit",
					["<C-s>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["q"] = "actions.close",
					["f"] = "actions.refresh",
					["<C-h>"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
					["n"] = {
						["y"] = "actions.copy",
						["x"] = "actions.cut",
						["p"] = "actions.paste",
					},
				},
				-- 파일 아이콘 설정
				use_default_keymaps = true,
				view_options = {
					-- 숨김 파일 표시 여부
					show_hidden = false,
					-- 이 확장자를 가진 파일은 보이지 않게 함
					is_hidden_file = function(name, bufnr)
						return vim.startswith(name, ".")
					end,
					-- 이 확장자를 가진 파일은 항상 보이게 함
					is_always_hidden = function(name, bufnr)
						return false
					end,
				},
				-- 플로팅 창 설정
				float = make_custom_float_setting(),
			})

			-- 단축키 설정
			-- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
			vim.keymap.set("n", "<leader><leader>-", function()
				require("oil").open_float()
			end, { desc = "Open Oil in float" })
		end,
	},
}
