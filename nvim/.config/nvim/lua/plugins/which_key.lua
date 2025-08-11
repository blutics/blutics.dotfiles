return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	config = function()
		local wk = require("which-key")

		wk.setup({
			window = {
				border = "single", -- 창 테두리 스타일
				position = "bottom", -- 위치 ("bottom", "top")
			},
			layout = {
				height = { min = 4, max = 25 }, -- 최소/최대 높이
				width = { min = 20, max = 50 }, -- 최소/최대 너비
				spacing = 3, -- 항목 간 간격
				align = "left", -- 정렬 ("left", "center", "right")
			},
			icons = {
				breadcrumb = "»", -- 탐색 표시
				separator = "➜", -- 구분자
				group = "+", -- 그룹 표시
			},
			show_help = true, -- 도움말 표시 여부
			show_keys = true, -- 키 바인딩 표시 여부
		})

		-- 키 매핑 등록 예시
		wk.register({
			-- 일반적인 매핑
			["<leader>"] = {
				x = {
					name = "Trouble",
					icon = "🖨️",
				},
				t = {
					name = "NeoTest",
					icon = "🧪",
				},
				O = {
					name = "Overseer",
					icon = "🛠️",
				},
				["<leader>"] = {
					name = "Leader",
					icon = "👾",
				},
			},

			-- 비주얼 모드 매핑
			-- ["<leader>"] = {
			-- 	mode = "v",
			-- 	y = { '"+y', "Yank to Clipboard" },
			-- },
		})
	end,
}
