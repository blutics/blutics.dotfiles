return {
	"vim-test/vim-test",
	-- dependencies = { "preservim/vimux" }, -- 선택적: tmux 통합
	config = function()
		-- 테스트 실행 전략 설정
		vim.g["test#strategy"] = "neovim" -- 또는 "toggleterm", "vimux"

		-- Python 테스트 설정
		vim.g["test#python#runner"] = "unittest"
		-- unittest 파일 패턴 설정
		vim.g["test#python#unittest#file_pattern"] = "test_.*\\.py$" -- test_로 시작하는 .py 파일

		-- 키맵 설정
		vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>") -- 가장 가까운 테스트
		vim.keymap.set("n", "<leader>tf", ":TestFile<CR>") -- 현재 파일
		vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>") -- 전체 테스트
		vim.keymap.set("n", "<leader>tl", ":TestLast<CR>") -- 마지막 테스트
		vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>") -- 마지막 테스트 파일로 이동
	end,
}
