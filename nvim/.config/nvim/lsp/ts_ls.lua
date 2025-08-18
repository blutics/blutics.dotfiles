return {
  cmd = { "typescript-language-server" },
  filetypes = {
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "javascript",
    "javascriptreact",
    "javascript.jsx",
  },
  root_dir = (function()
    local f = vim.fs.find({ "tsconfig.json", "jsconfig.json", "package.json", ".git" }, { upward = true })[1]
    return f and vim.fs.dirname(f) or vim.loop.cwd()
  end)(),
  init_options = {
    hostInfo = "neovim",
    preferences = {
      includeCompletionsForModuleExports = true,
      includeCompletionsWithSnippetText = true,
      importModuleSpecifierPreference = "non-relative", -- 취향: "shortest"/"project-relative" 등
      quotePreference = "single",
    },
  },
}
