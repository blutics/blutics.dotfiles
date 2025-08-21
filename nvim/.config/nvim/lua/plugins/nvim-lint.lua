--
return {
	{
		"mfussenegger/nvim-lint",
		dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local lint = require("lint")

			-- 파일타입별 린터 매핑
			lint.linters_by_ft = {
				-- Python
				python = { "ruff" }, -- 빠른 ruff + 타입체커 mypy
				-- JS/TS
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				-- Lua
				-- lua = { "luacheck" },
				-- 쉘/마크다운/기타
				-- sh = { "shellcheck" },
				-- markdown = { "markdownlint" },
				-- yaml = { "yamllint" },
				-- dockerfile = { "hadolint" },
			}

			-- 저장/입력 종료/버퍼 진입 시 자동 린팅
			local au = vim.api.nvim_create_autocmd
			au({ "BufWritePost", "InsertLeave", "BufReadPost" }, {
				callback = function()
					lint.try_lint() -- 파일타입에 맞는 린터 자동 실행
				end,
			})

			-- 수동 실행 단축키
			-- vim.keymap.set("n", "<leader>ll", function()
			-- 	lint.try_lint()
			-- end, { desc = "Run linters" })
		end,
	},
}
