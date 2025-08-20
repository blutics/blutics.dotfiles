return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "javascript",
    "javascriptreact",
    "javascript.jsx",
  },
  root_dir = (function()
    local root = require("custom.root")
    local current_file = vim.fn.expand("%:p")
    local result = root.get_root_detail(current_file)
    -- print(result)
    return result and result[1] or vim.loop.cwd()
  end)(),
  settings = {
    typescript = {
      format = { enable = false }, -- Prettier/ESLint 쓰면 보통 끔
      preferences = { includeCompletionsForModuleExports = true },
      suggest = { completeFunctionCalls = true },
    },
    javascript = { format = { enable = false } },
  },
  init_options = { hostInfo = "neovim" },

  on_attach = function(client, bufnr)
    -- 포맷 기능 끄기(Prettier 전담)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  handlers = {
    -- 진단 비활성 (ESLint만 쓰기 위함)
    ["textDocument/publishDiagnostics"] = function() end,
  },
  -- 필요시 tsserver 최적화 옵션들 추가 가능
}
