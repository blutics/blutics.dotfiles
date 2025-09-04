return {
	{
		"williamboman/mason.nvim",
		lazy = false, -- ★ 가장 먼저
		build = ":MasonUpdate",
		config = true, -- 기본 setup()
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {},
		opts = {
			automatic_installation = true,
      -- 시발 typescript-language-server와 pyright는 그냥 글로벌로 설치하면 간단히 사용가능하다.
			ensure_installed = {
				"lua-language-server",

				-- "typescript-language-server", -- TypeScript/JavaScript
				"html-lsp",
				"css-lsp",
				"tailwindcss-language-server",

				-- "pyright",
				"black",
				"isort",
				"ruff",

				"yaml-language-server",
				"marksman",
				-- "nil",
				"eslint_d",

				-- "prettier",
				-- "prettierd",

				"stylua",
				"alejandra",
			},
		},
	},
}
