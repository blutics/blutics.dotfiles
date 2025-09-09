local function bash_root(bufnr)
  -- 현재 버퍼 기준으로 루트 탐색 (.git 없으면 버퍼 디렉터리)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local start = (name ~= "" and vim.fs.dirname(name)) or vim.fn.getcwd()
  local root = vim.fs.root(start, { ".bashrc" }) or start
  return root
end

vim.print("bash language server --> !!")

-- npm으로 global로 bash-langauge-server 설치함
return {
	cmd = { "bash-language-server", "start" }, -- npm i -g bash-language-server
	filetypes = { "sh", "bash" },
	single_file_support = true,
}
