vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- Python import 문의 일반적인 highlight 그룹 -> 파이썬 from, import, 모듈명이 모두 같이 색이라서 변경
    vim.api.nvim_set_hl(0, "@keyword.import", { fg = "#F7768E", bold = true })
    vim.api.nvim_set_hl(0, "@module", { fg = "#7dcfff" })
    vim.api.nvim_set_hl(0, "@namespace", { fg = "#7dcfff" })
    vim.api.nvim_set_hl(0, "@variable.builtin", { fg = "#c0caf5" })
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects", -- 텍스트 오브젝트
      "nvim-treesitter/nvim-treesitter-refactor", -- 리팩토링 지원
      "windwp/nvim-ts-autotag",                   -- HTML/JSX 태그 자동완성
    },
    config = function()
      -- 2. treesitter 설정
      require("nvim-treesitter.configs").setup({
        -- 설치할 언어들
        ensure_installed = {
          "python",
          "rust",
          "javascript", -- Node.js, React(JSX) 등을 위한 JS
          "typescript",
          "tsx",   -- React TSX (혹은 JS용 jsx)
          "html",
          "css",
          "json",
          "yaml",
          "lua",
          "markdown", "markdown_inline"
          -- 필요하다면 "css", "json", "lua" 등도 추가
        },
        -- treesitter 하이라이팅 기능
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        -- (선택) 인덴트 기능
        indent = {
          enable = true,
        },
        -- (선택) incremental selection
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        -- (선택) textobjects
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ae"] = "@call.outer",
              ["ie"] = "@call.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["a/"] = "@comment.outer",
              ["i/"] = "@comment.inner",
              ["ar"] = "@return.outer",
              ["ir"] = "@return.inner",
            },
          },
        },
      })
    end,
  },
}
