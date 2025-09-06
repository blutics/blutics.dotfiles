return {
	"bullets-vim/bullets.vim",
	ft = "markdown",
	init = function()
		-- 동작 범위
		vim.g.bullets_enabled_file_types = { "markdown" }

		-- (기본값이 1) 들여쓰기/새 항목 추가 시 자동 재번호
		vim.g.bullets_renumber_on_change = 1

		-- 기본 맵핑 그대로 써도 되지만, 선호 키로 고치려면 아래처럼:
		vim.g.bullets_set_mappings = 0
		vim.g.bullets_outline_levels = { "num" }

		vim.g.bullets_custom_mappings = {
			-- 새 항목
			-- { "imap", "<CR>", "<Plug>(bullets-newline)" },
			{ "nmap", "o", "<Plug>(bullets-newline)" },

			-- 들여/내어쓰기 (번호 자동 갱신 포함)
			{ "nmap", ">>", "<Plug>(bullets-demote)" },
			{ "nmap", "<<", "<Plug>(bullets-promote)" },

			-- 수동 재번호(선택 영역/현재 목록)
			{ "nmap", "gN", "<Plug>(bullets-renumber)" },
			{ "xmap", "gN", "<Plug>(bullets-renumber)" },

			-- 체크박스 토글
			{ "nmap", "<leader>x", "<Plug>(bullets-toggle-checkbox)" },
		}
	end,
}
