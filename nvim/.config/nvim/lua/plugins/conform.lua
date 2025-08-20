return {
	{
		"zapling/mason-conform.nvim",
		enabled = true,
		dependencies = { "williamboman/mason.nvim", "stevearc/conform.nvim" },
		opts = {
			automatic_installation = true,
			-- ensure_installed = { "stylua", "prettierd", "shfmt", "black", "isort", "jq" },
		},
	},
	{
		"stevearc/conform.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
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
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				nix = { "alejandra" },
			},
			formatters = {
				isort = {
					prepend_args = { "--profile", "black" },
				},
				prettierd = {
					env = {
						PRETTIERD_LOCAL_PRETTIER_ONLY = "1",
					},
				},
			},
		},
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}
