return {
	"mrjones2014/smart-splits.nvim",
	config = function()
		require("smart-splits").setup({
			-- 테두리 하이라이팅 설정
			cursor_follows_swapped_bufs = true,
			highlight = {
				enabled = true,
				border = "single", -- "single", "double", "rounded" 등
				border_on_enter = true, -- 창 진입 시 테두리 표시
				border_on_leave = false, -- 창 이탈 시 테두리 숨김
				fg = "#89b4fa", -- 테두리 색상
			},
		})
	end,
}
