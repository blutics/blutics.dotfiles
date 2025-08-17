return {
  {
    "williamboman/mason.nvim",
    lazy = false, -- ★ 가장 먼저
    build = ":MasonUpdate",
    config = true, -- 기본 setup()
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
        "lua-language-server",
        "pyright",
        "python-lsp-server",


        "black", -- 포매터
        "isort", -- import 정렬
        "ruff", -- 린터
        "mypy",
        "rope",
        "yamllint",
        "prettier",
        "stylua",
        "eslint",

        "nil", -- nix = nil
        "alejandra", -- nix formatter
        -- 필요하다면 "mypy" 등도 추가 가능 (CLI가 존재하는 도구)
        "markdownlint",
      },

      automatic_installation = true, -- 원하면
    },
    config = function()
      -- mason 설정 직후 어딘가에 배치
      local mr = require("mason-registry")
      local ensure_rope_in_pylsp = require("custom.pylsp_rope_install").ensure_rope_in_pylsp

      -- 1) 이미 설치되어 있으면 즉시 보정
      if mr.is_installed("python-lsp-server") then
        ensure_rope_in_pylsp()
      else
        -- 2) 아직이면 설치 요청 + 콜백에서 보정(신규 mason에서 지원)
        local pkg = mr.get_package("python-lsp-server")
        pkg:install({}, function(success, _)
          if success then
            ensure_rope_in_pylsp()
          end
        end)
      end
    end,
  },
}
