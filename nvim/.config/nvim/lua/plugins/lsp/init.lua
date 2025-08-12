return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",           -- LSP 패키지 매니저
    "williamboman/mason-lspconfig.nvim", -- mason과 lspconfig 연동
    "hrsh7th/cmp-nvim-lsp",              -- LSP 자동완성
    "glepnir/lspsaga.nvim",
    "antosha417/nvim-lsp-file-operations",
  },
  config = function()
    -- mason 설정
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",  -- Lua
        "pyright", -- Python
        "ts_ls",   -- TypeScript
        "yamlls",
        -- "pylsp",
      },
      automatic_enable = false,
      -- automatic_installation = true,
    })

    -- LSP 기능 설정
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- 키매핑 설정
    local on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, desc = "Code Action" }
      vim.keymap.set("n", "<leader>ga", vim.lsp.buf.code_action, opts)
    end

    vim.keymap.set("n", "<leader>g", "", { desc = "Go To" })
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
    vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find References" })

    vim.keymap.set("n", "<leader>d", function()
      require('telescope.builtin').lsp_document_symbols({
        symbols = { 'function', 'class' }
      })
    end, { desc = "Move in Doc to Func and Cls" })



    local lspconfig = require("lspconfig")

    -- Lua
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })

    lspconfig.pyright.setup({
      on_new_config = function(new_config, new_root_dir)
        local util = require("lspconfig.util")
        local root_dir = util.find_git_ancestor(vim.fn.getcwd()) or vim.fn.getcwd()
        new_config.settings.python.pythonPath = vim.fn.exepath('python')
        -- PYTHONPATH에 프로젝트 루트 추가
        vim.env.PYTHONPATH = table.concat({
          root_dir,
          root_dir .. '/src', -- src 디렉토리 추가
          vim.env.PYTHONPATH or ''
        }, ':')
        new_config.settings.python.pythonPath = vim.fn.exepath('python')
        -- poetry 환경 감지
        local poetry_path = vim.fn.trim(vim.fn.system('poetry env info -p'))
        if vim.v.shell_error == 0 then
          new_config.settings.python.pythonPath = poetry_path .. '/bin/python'
          new_config.settings.python.venvPath = poetry_path
        end
      end,
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            diagnosticMode = "workspace",
            autoImportCompletions = true,
            typeCheckingMode = "basic",
            autoSerchPaths = true,
            useLibraryCodeForTypes = true
          }
        }
      },
    })
    -- rope를 위한 Python LSP 설정
    lspconfig.pylsp.setup({
      capabilities = capabilities,
      root_dir = function()
        local util = require("lspconfig.util")
        local root_dir = util.find_git_ancestor(vim.fn.getcwd()) or vim.fn.getcwd()
        return root_dir
      end,
      settings = {
        pylsp = {
          plugins = {
            -- 다른 기능은 비활성화하고 rope만 사용
            pycodestyle = { enabled = false },
            pyflakes = { enabled = false },
            mccabe = { enabled = false },
            -- rope 관련 기능 활성화
            rope_autoimport = {
              enabled = true,
              memory = true -- 메모리에 import 정보 캐시
            },
            rope_completion = {
              enabled = true -- rope 기반 자동완성 활성화
            }
          }
        }
      },
      on_attach = function(client, bufnr)
        -- Code Action 단축키 설정
        local opts = { silent = true, buffer = bufnr }
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code Action 실행
      end,
    })

    lspconfig.nil_ls.setup({
settings = {
    ["nil"] = {
      formatting = {
        command = { "alejandra" } -- nixfmt 대신 alejandra 사용
      }
    }
  },
    })

    -- TypeScript
    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.yamlls.setup({
      settings = {
        yaml = {
          -- editor = {
          --   tabSize = 4,
          --   insertSpaces = false,
          -- },
          format = {
            enable = true,         -- 포맷팅 활성화
            singleQuote = true,    -- 작은따옴표 사용
            bracketSpacing = true, -- 괄호 주변 공백
          },
          validate = true,         -- 실시간 유효성 검사
          completion = true,       -- 자동 완성
          hover = true,            -- 호버 정보 표시
          -- schemas = {
          --   ["https://json.schemastore.org/markdownlint"] = "/*.md",
          -- }
        }
      }
    })

    -- LSP 상태 표시 설정
    vim.diagnostic.config({
      virtual_text = true,      -- 인라인 에러 메시지
      signs = true,             -- 사인칼럼 아이콘
      underline = true,         -- 에러 밑줄
      update_in_insert = false, -- 인서트 모드에서 업데이트 안함
      severity_sort = true,     -- 심각도 순으로 정렬
      float = {
        focusable = false,
        -- style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = "rounded", -- 테두리 스타일 설정
        -- 다른 border 옵션들: "none", "single", "double", "rounded", "solid", "shadow"

        -- 창 크기와 여백 설정 (선택사항)
        max_width = 80,
        max_height = 20,
        -- 각 방향의 여백 설정
        padding = { top = 1, left = 2, bottom = 1, right = 2 },
      }
    )

    -- 추가로 signature help 창도 같은 스타일로 설정하고 싶다면:
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = "rounded",
        max_width = 80,
        max_height = 20,
        padding = { top = 1, left = 2, bottom = 1, right = 2 },
      }
    )
  end,
}
