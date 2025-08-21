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
			ensure_installed = {
				"lua-language-server",

				"typescript-language-server", -- TypeScript/JavaScript
				"html-lsp",
				"css-lsp",
				"tailwindcss-language-server",

				"pyright",
        "black",
        "isort",
        "ruff",

				"yaml-language-server",
				"marksman",
				"nil",
				"eslint_d",

        "prettier",
        "prettierd",

        "stylua",
        "alejandra",
			},
		},
	},
}
