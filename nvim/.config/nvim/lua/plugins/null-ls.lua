-- none-ls를 그냥 쓰려는데 사실 크게 문제는 없었다.
-- 찾아보니 상세한 설정이 없어서 별로라는 사람들도 있기는 한데
-- 나한테는 크게 문제는 없었다.
-- 근데 eslint에서 문제가 발생하네....
-- 사실 이것도 none-ls의 문제는 아님
-- 문제라면 문제일까?? none-ls가 eslint를 지원하지 않는다는 문제??
-- 그럼에도 불구하고 null-ls에서 메인테이너가 포기한 repo
-- 그리고 vim계의 아이돌 folke가 confirm + nvim-lint로 간다고 하네
-- 찾아보니 confirm은 포맷팅을 nvim-lint는 린팅을 지원해주는 것 같음.
return {
  "nvimtools/none-ls.nvim",
  enabled=false,
  dependencies = {
    "nvim-lua/plenary.nvim", -- null-ls 실행에 필요한 라이브러리
  },
  config = function()
    -- null-ls에서 사용할 포매터, 린터, 코드액션 등 등록
    local null_ls = require("null-ls")
    require("mason-null-ls").setup()

    local sources = {
      -- Formatting
      null_ls.builtins.formatting.prettier.with({
        extra_filetypes = { "svelte", "astro", "yaml", "yml", "markdown" }, -- 필요하다면 추가 확장
        extra_args = {
          "--single-quote",
          "--no-semi",
          "--use-tabs", -- 탭 사용
          "--tab-width",
          "2",     -- 탭 크기
          "--yaml-parser",
          "yaml",  -- YAML 파서 명시적 지정
        },
      }),

      -- Linting
      -- null_ls.builtins.diagnostics.eslint, -- JS/TS

      -- YAML 린터
      null_ls.builtins.diagnostics.yamllint.with({
        -- yamllint 설정 커스터마이징
        extra_args = {
          "-d",
          "{extends: default, rules: {line-length: {max: 120}}}",
        },
      }),

      null_ls.builtins.formatting.black, -- Python

      -- isort 설정 -> 파이썬 ipmort 정렬을 위해서
      -- 글로벌 환경의 파이썬에 isort가 설치되어 있어야한다.
      -- pip install isort
      null_ls.builtins.formatting.isort.with({
        extra_args = { "--profile", "black" },
      }),

      -- Python 린터
      null_ls.builtins.diagnostics.pylint.with({
        cwd = require("custom.root").find_for_lsp,
        -- prefer_local = ".venv/bin",
        -- 필요 시 인자 추가: extra_args = { "--jobs=0" }, -- 코어수 병렬
      }),

      null_ls.builtins.formatting.stylua, -- Lua

      -- Code actions
      -- Python 코드 액션
      -- null_ls.builtins.diagnostics.ruff,

      -- 추가 진단
      -- null_ls.builtins.diagnostics.mypy, -- 타입 체크
      null_ls.builtins.formatting.alejandra,
      null_ls.builtins.diagnostics.markdownlint,
    }

    null_ls.setup({
      sources = sources,
      root_dir = require("custom.root").find_for_lsp,
      on_attach = function(client, bufnr)
        -- 포매팅 단축키 예시
        if client.supports_method("textDocument/formatting") then
          vim.keymap.set("n", "<leader><leader>k", function()
            vim.lsp.buf.format({
              async = true,
              bufnr = bufnr,
            })
          end, { buffer = bufnr, desc = "Formatting with null-ls" })
        end

        -- (선택) 저장 시 자동 포매팅
        -- vim.api.nvim_create_autocmd("BufWritePre", {
        --   buffer = bufnr,
        --   callback = function()
        --     vim.lsp.buf.format({ bufnr = bufnr })
        --   end,
        -- })
      end,
    })
  end,
}
