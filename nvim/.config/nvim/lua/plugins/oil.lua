-- 따로 which-key로 키매핑 알려주는 창 만드려고 했는데 g?로
-- 개발자가 만들어 놓은게 있다. ? 단독으로 바꾸는게 좋을까?
-- 어차피 g.는 자주 사용하니까. g?도 자연스럽게 익혀질듯한데.
--
-- 요즘 파일 탐색 플러그인을 쓰면 보통 netrw를 끈다고 하네
-- :Ex명령어가 안먹혀서 설정이 잘 못된건가 했는데 아니네
return {
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local make_custom_float_setting = require("custom.oil_float_window").make_custom_float_setting
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
					winblend = 0,
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

			vim.cmd.hi("NormalFloat guibg=NONE")
			vim.cmd.hi("FloatBorder guibg=NONE")
			local base = vim.api.nvim_get_hl(0, { name = "FloatTitle", link = false }) or {}
			vim.api.nvim_set_hl(0, "FloatTitle", {
				fg = base.fg, -- 기존 전경색 유지 (GUI)
				ctermfg = base.ctermfg, -- TUI(16/256컬러)도 쓰신다면 같이 유지
				bg = "NONE", -- 배경 제거
				bold = true, -- 필요 시 굵게(기존 값 따르려면 base.bold)
			})
		end,
	},
}
