-- 0.11+: 서버 “정의/확장”
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".git", "stylua.toml" },
  single_file_support = true,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,   -- nvim 런타임
          "${3rd}/luv/library", -- luv 타입
        },
      },
    },
  },
}
