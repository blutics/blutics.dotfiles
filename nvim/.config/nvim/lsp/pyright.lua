local function set_python_path(path)
	local clients = vim.lsp.get_clients({
		bufnr = vim.api.nvim_get_current_buf(),
		name = "pyright",
	})
	for _, client in ipairs(clients) do
		if client.settings then
			client.settings.python = vim.tbl_deep_extend("force", client.settings.python, { pythonPath = path })
		else
			client.config.settings =
				vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
		end
		client.notify("workspace/didChangeConfiguration", { settings = nil })
	end
end

-- 프로젝트의 루트를 잡고 venv 혹은 .venv를 잡는 방법
--    이전에 lspconfig로 이거 잡는다고 지랄을 했는데
--    알고보니 설정파일하나면 모두 해결이 되는 거였어
--    pyproject.toml파일에서 tool.pyright섹션에
--    venvPath와 venv를 설정할 수 있었네
--    이러면 lsp가 알아서 잡아주는거였어...
--    lsp가 루트를 잡음과 동시에 이 파일에서 venv를 찾아서 사용하는거지...
--    아무튼, 점점 더 프로젝트 구조들이 눈에 잡히기 시작한다
--    이거는 nvim이나 emacs 안쓰면 알 수가 없는거
--    프로젝트 루트에 덕지덕지 발리는게 이런 개발환경을 최적화하는 파일들
return {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				autoImportCompletions = true,
				useLibraryCodeForTypes = true,
				-- diagnosticMode = "openFilesOnly",
				typeCheckingMode = "basic",
				reportUnusedImport = "none",
				reportUnusedVariable = "none",
			},
		},
	},
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
		vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
			desc = "Reconfigure pyright with the provided python path",
			nargs = 1,
			complete = "file",
		})
	end,
}
