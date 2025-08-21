local make_prettier_related_options = function()
	return { "prettier", stop_after_first = true }
end
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
					env = {
						PRETTIERD_LOCAL_PRETTIER_ONLY = "1",
					},
				},
				prettier = {
					prepend_args = function(ctx)
						-- local ft = vim.bo[ctx.bufnr].filetype
						local args = { "--single-quote", "--no-semi", "--use-tabs", "--tab-width", "2" , "--yaml-parser", "yaml"}
						-- if ft == "yaml" or ft == "yml" then
						-- 	vim.list_extend(args, { "--parser", "yaml" }) -- (--yaml-parser 아님)
						-- end
						return args
					end,
				},
			},
		},
		-- init = function()
		-- 	-- If you want the formatexpr, here is the place to set it
		-- 	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		-- end,
	},
}
