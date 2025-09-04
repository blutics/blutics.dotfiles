vim.lsp.config("marksman", {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "markdown.mdx" },
	-- 루트 탐색: .marksman.toml 또는 .git
	root_markers = { ".marksman.toml", },
})
