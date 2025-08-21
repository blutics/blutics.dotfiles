-- 테일윈드 설치시 버젼3으로 진행해야지 language server와 호환이 된다.
-- v4는 현재 지원해주지 않는듯하다.가 아니네
-- v3로 맞추고 혹시나 해서 들어가봤는데 아까 reddit에서 config파일 뭐라고 하더니
-- 그대로 적혀있음. v3에서는 configFile이 tailwind.config.js파일이었는데
-- v4에서는 루트css파일을 넣어주어야한다고 한다.....ㅅㅂ
local caps = require("blink.cmp").get_lsp_capabilities()
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
	capabilities = caps,
	-- LSP 서버가 반응할 파일 타입
	settings = {
		tailwindCSS = {
			validate = true,
			classAttributes = { "class", "className", "ngClass" },
			experimental = {
        configFile = "src/styles/index.scss",
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
			-- includeLanguages = {
			-- 	typescript = "javascript",
			-- 	typescriptreact = "javascript",
			-- 	javascriptreact = "javascript",
			-- },
		},
	},
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
