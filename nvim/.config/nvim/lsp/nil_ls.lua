local function nix_root()
  local f = vim.fs.find({ "flake.nix", "shell.nix", "default.nix", ".git" }, { upward = true })[1]
  return f and vim.fs.dirname(f) or vim.loop.cwd()
end

return {
  cmd = { "nil" }, -- PATH에 nil 있어야 함 (Nix 또는 :MasonInstall nil)
  filetypes = { "nix" },
  root_dir = nix_root(),
  settings = {
    ["nil"] = {
      formatting = { command = { "alejandra" } }, -- 빠르고 일관된 포매터
      -- flake 편의 옵션이 필요하면:
      nix = { flake = { autoArchive = true, autoEvalInputs = false } },
    },
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentHighlightProvider = false
    client.server_capabilities.semanticTokensProvider = nil
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end,
}
