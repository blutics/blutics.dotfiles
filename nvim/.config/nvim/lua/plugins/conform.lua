-- prettierd와 prettier의 차이
-- prettierd는 자체적으로 prettier를 가지는게 아니라
-- 프로젝트에 설치되어 있는 prettier를 사용하기 위한 백그라운드 프로세스!
-- 이를 이용해서 prettier-plugin-tailwindcss를 추가해서 사용할 수 있는데
-- 이를 이용하면 클래스 내일은 정렬할 수 있다
-- 
-- 여기에서 이를 사용하기 위해서는 프로젝트 루트에 prettier 설정파일이 있어야한다
-- 근데 이 prettierd를 하나만 띄워놓고 사용
-- 그래서 만약에 프로젝트에서 prettier 설정파일 이 바뀌면 이를 바로 반영해주지 못한다.
-- 그래서 만약에 이게 바뀐다면 프로세스를 직접 꺼줘야한다.
-- # 모든 프로젝트의 데몬 중지
-- prettierd stop
-- # (안 되면) 프로세스 강제 종료
-- pkill -f prettierd
--
-- 그런데 단순히 설정내용만 바뀌는건 문제가 안될 수도 있기는함
-- 내가 겪었던 상황은 prettier.config.ts -> .prettierrc로의 변경이어서
-- 파일을 바꾸었는데도 prettier.config.ts를 찾았음
--
-- ---------------------------------
-- 이러면 궂이 mason이 필요한가....
-- 중요 서버들은 대부분 직접설치하고 있는데....
local make_prettier_related_options = function()
	return { "prettierd", "prettier", stop_after_first = true }
end
local make_prettier_args = function(ctx)
	local args = { "--single-quote", "--no-semi", "--use-tabs", "--tab-width", "2", "--yaml-parser", "yaml" }
	return args
end
return {
	{
		"stevearc/conform.nvim",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader><leader>k",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},

		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				typescript = make_prettier_related_options(),
				typescriptreact = make_prettier_related_options(),
				javascript = make_prettier_related_options(),
				javascriptreact = make_prettier_related_options(),
				json = make_prettier_related_options(),
				css = make_prettier_related_options(),
				html = make_prettier_related_options(),
				markdown = make_prettier_related_options(),
				nix = { "alejandra" },
			},
			formatters = {
				isort = {
					prepend_args = { "--profile", "black" },
				},
				prettierd = {
					inherit = false, -- 내장 정의와 병합 금지(중복 인자 예방)
					command = "prettierd",
					args = { "$FILENAME" }, -- 위치 인자 "한 개"만 전달
					stdin = true,
					prepend_args = make_prettier_args,
					env = {
						PRETTIERD_LOCAL_PRETTIER_ONLY = "1",
					},
				},
				prettier = {
					prepend_args = make_prettier_args,
				},
			},
		},
		-- init = function()
		-- 	-- If you want the formatexpr, here is the place to set it
		-- 	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		-- end,
	},
}
