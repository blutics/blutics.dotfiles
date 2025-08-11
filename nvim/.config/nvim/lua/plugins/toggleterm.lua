return {
	"akinsho/toggleterm.nvim",
	version = "*", -- 최신 버전 사용
	config = function()
		require("toggleterm").setup({
			size = 20, -- 터미널 창의 높이 또는 너비
			open_mapping = [[<C-\>]], -- 터미널을 열고 닫는 키 매핑
			hide_numbers = true, -- 터미널 창에 줄 번호 숨기기
			shade_filetypes = {},
			shade_terminals = true, -- 터미널 배경을 어둡게 처리
			shading_factor = 2, -- 배경 어둡기 정도 (1~3)
			start_in_insert = true, -- 터미널을 열 때 삽입 모드로 시작
			insert_mappings = true, -- 삽입 모드에서 키 매핑 사용
			terminal_mappings = true, -- 터미널 모드에서 키 매핑 사용
			persist_size = true, -- 터미널 크기 유지
			direction = "float", -- 터미널 방향 (horizontal, vertical, float, tab 중 선택)
			close_on_exit = true, -- 프로세스 종료 시 터미널 닫기
			shell = vim.o.shell, -- 기본 쉘
			-- shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
			float_opts = {
				border = "curved", -- 테두리 스타일 (single, double, shadow, curved 등)
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		})
	end,
}
