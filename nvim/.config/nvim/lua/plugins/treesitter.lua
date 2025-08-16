vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		-- Python import 문의 일반적인 highlight 그룹 -> 파이썬 from, import, 모듈명이 모두 같이 색이라서 변경
		vim.api.nvim_set_hl(0, "@keyword.import", { fg = "#F7768E", bold = true })
		vim.api.nvim_set_hl(0, "@module", { fg = "#7dcfff" })
		vim.api.nvim_set_hl(0, "@namespace", { fg = "#7dcfff" })
		vim.api.nvim_set_hl(0, "@variable.builtin", { fg = "#c0caf5" })
	end,
})

-- 괄호들 사이의 점프
--    treesitter나 flash들이 좋아보이기는 하는데
--    너무 한번에 축약해서 리듬감을 줄이고 생각을 하게 만들어버린다.
--    괄호들 사이의 경우에는
--    1. 번호 + 라인이동
--    2. :라인
--    3. %
--    4. $0 라인에서 앞뒤로 이동
--    -> 이들을 조합을 통해서 리듬감 있는 타이핑으로 이동하는게 오히려 낫다
--
--  treesitter가 좋을 때는
--  파이썬 같이 함수나 클래스들이 괄호로 엮여 있지 않을 때
--  한꺼번에 묶는게 편해진다.
--  하지만, 파이썬에서 자료구조는 {}로 묶이기에 거의 대부분의 자료구조를 다룰 때는
--  플러그인 없이 가는게 좋다.
--  그리고 결국 bare하게 사용할 수 있다면 그게 베스트
return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/nvim-treesitter-textobjects", -- 텍스트 오브젝트
			"nvim-treesitter/nvim-treesitter-refactor", -- 리팩토링 지원
			"windwp/nvim-ts-autotag", -- HTML/JSX 태그 자동완성
		},
		config = function()
			-- 2. treesitter 설정
			require("nvim-treesitter.configs").setup({
				-- 설치할 언어들
				ensure_installed = {
					"python",
					"rust",
					"javascript", -- Node.js, React(JSX) 등을 위한 JS
					"typescript",
					"tsx", -- React TSX (혹은 JS용 jsx)
					"html",
					"css",
					"json",
					"yaml",
					"lua",
					"markdown",
					"markdown_inline",
					-- 필요하다면 "css", "json", "lua" 등도 추가
				},
				-- treesitter 하이라이팅 기능
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				-- (선택) 인덴트 기능
				indent = {
					enable = true,
				},
				-- (선택) incremental selection
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				-- (선택) textobjects
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ae"] = "@call.outer",
							["ie"] = "@call.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["a/"] = "@comment.outer",
							["i/"] = "@comment.inner",
							["ar"] = "@return.outer",
							["ir"] = "@return.inner",
						},
					},
				},
			})
		end,
	},
}
