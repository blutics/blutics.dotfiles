-- plugins/zk.lua
return {
  "zk-org/zk-nvim",
  enabled=true,
  ft = "markdown",
  config = function()
    require("zk").setup({
      -- Telescope/fzf 등 쓰면 지정 가능. 없으면 기본 selector 사용
      picker = "telescope",
      lsp = {
        -- zk LSP는 zk CLI가 있으면 자동으로 동작
        config = {
          name = "zk",
          cmd = { "zk", "lsp" },
          filetypes = { "markdown" },
        },
        auto_attach = {
          enabled = true, -- 노트북 내부 버퍼에 자동 부착
        },
      },
    })
  end,
}

