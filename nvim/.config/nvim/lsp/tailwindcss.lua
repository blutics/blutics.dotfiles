local caps = require("blink.cmp").get_lsp_capabilities()
print("qqq")
return {
	name = "tailwindcss",
	cmd = { "tailwindcss-language-server", "--stdio" },
	root_dir = vim.fs.root(0, {
		"tailwind.config.js",
		"tailwind.config.cjs",
		"tailwind.config.ts",
		"postcss.config.js",
		"postcss.config.cjs",
		"package.json",
	}),
  filetypes = {
    "html","css","scss","sass","less","postcss","stylus","sugarss",
    "javascript","javascriptreact","typescript","typescriptreact",
    "svelte","vue","astro","markdown","mdx","templ","php","blade",
    -- 필요시 더 추가
  },
	-- root_dir = require("custom.root").get_current_root(),
	capabilities = caps,
	-- LSP 서버가 반응할 파일 타입
	settings = {
		tailwindCSS = {
			validate = true,
			classAttributes = { "class", "className", "ngClass" },
			experimental = {
				classRegex = {
					"tw`([^`]*)`",
					"tw\\(([^)]*)\\)",
					"tw\\.[^`]+`([^`]*)`",
					"cva\\(([^)]*)\\)",
					"clsx\\(([^)]*)\\)",
					"cx\\(([^)]*)\\)",
					"cn\\(([^)]*)\\)",
					"tv\\(([^)]*)\\)",
				},
			},
			-- (필요시) TSX 매핑이 약하면 아래도 추가
			includeLanguages = {
				typescript = "javascript",
				typescriptreact = "javascript",
				javascriptreact = "javascript",
			},
		},
	},
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
