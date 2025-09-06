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
			preset = "classic", -- classic 하단 여백 없음 | modern 하단여백 | helix 우측아래
			-- 커서가 하단에 있으면 which-key가 짜부라진다.
			-- 이때 다음페이지로 넘어가서 보면 되는데 이 때 키는?
			-- C-u와 C-d 이다. 이게 창에서 ^U ^D 로 표현되는데....이게 맞어?
			-- 원래 Ctrl을 ^로 표현하는게 컨벤션 같은건가?
			--
			-- 배경이 없을 때는 modern이 괜찮지 않을까 싶었지만 사용해보니 옆에 뚫린게 눈에 거슬린다.
			-- 배경이 없을 때, helix도 괜찮아 보이기는 하는데
			-- 뭔가 이상하다. 어차피 자주 포지는 않음.
			-- 하단에서는 사용하지 않을 때 별로 인식되지 않는데
			-- 우측하단에 나오게 되면 왠지 모르게 계속 눈에 들어오게 된다.
			--
			win = {
				border = "none", -- none | single
				padding = {
					2, -- top/bottom
					8, -- right/left
				},
			},
			layout = {
				height = { min = 7, max = 25 }, -- 최소/최대 높이
				width = { min = 20, max = 50 }, -- 최소/최대 너비
				spacing = 8, -- 항목 간 간격
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
		wk.add({
			--{ 일반적인 매핑

			{ "<leader>", group = "Leader", icon = "" },
			{ "<leader>O", group = "Overseer", icon = "" },
			{ "<leader>t", group = "NeoTest", icon = "" },
			{ "<leader>x", group = "Trouble", icon = "" },
		})
		pcall(vim.api.nvim_set_hl, 0, "WhichKeyNormal", { bg = "NONE" })
		-- 와! 터미널 배경만 잘 세팅해놓으면 which-key 배경이 없을 때 유려하게 나온다.
	end,
}
