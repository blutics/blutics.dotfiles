-- 미친 플러그인이다.
-- 반드시 사용해야한다.
-- 마크다운과 결합했을때 진짜 미친 효율성이 나온다.
-- 진짜, 제일 중요한 플러그인 중에 하나다.
-- 이 플러그인의 키는 필히 숙지해야한다.
-- 이전에 symbol-outline이라는 플러그인 사용했는데 이놈이 설정파일이 깨져서 확인하는 도중에
-- 해당 플러그인이 아카이브 됬고 우연히 찾았는데 대박이다.
-- 아이콘도 너무 깔끔한 것들 잘 선택되어있고 설정에서 건들 필요도 없다.
return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = {
		{ "<leader>gso", "<cmd>Outline<CR>", desc = "Toggle outline" },
	},
	opts = {},
	init = function()
		-- plugin/outline_hydra.lua (init.lua에 넣어도 됨)
		
	end,
}
