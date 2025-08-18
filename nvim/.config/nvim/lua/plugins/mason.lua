return {
  {
    "williamboman/mason.nvim",
    lazy = false, -- ★ 가장 먼저
    build = ":MasonUpdate",
    config = true, -- 기본 setup()
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    -- LSP “서버 키”를 나열합니다 (패키지명이 아님)
    opts = function()
      return {
        ensure_installed = {
          "lua_ls",
          "ts_ls", -- TypeScript/JavaScript
          "pyright",
          "pylsp",
          "yamlls",
          "marksman",
          "nil_ls",
        },
        automatic_installation = true, -- 누락 시 자동 설치
        handlers = {},             -- lspconfig 자동 setup 방지 (설치만)
      }
    end,
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      -- (선택) pylsp venv에 rope 주입
      vim.defer_fn(function()
        local ok, mr = pcall(require, "mason-registry")
        if ok and mr.is_installed("python-lsp-server") then
          pcall(function()
            require("custom.pylsp_rope_install").ensure_rope_in_pylsp()
          end)
        end
      end, 1500)
    end,
  },
  -- Mason-Null-LS (Mason/none-ls 의존)
  {
    "jay-babu/mason-null-ls.nvim",
    -- event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    opts = {
      ensure_installed = {
        "black", -- 포매터
        "isort", -- import 정렬
        "ruff", -- 린터
        "pylint",
        "mypy",
        "yamllint",
        -- "prettier",
        "stylua",
        "eslint",
        "alejandra", -- nix formatter
        "markdownlint",
        -- 필요하다면 "mypy" 등도 추가 가능 (CLI가 존재하는 도구)
      },

      automatic_installation = true, -- 원하면
    },
  },
}
