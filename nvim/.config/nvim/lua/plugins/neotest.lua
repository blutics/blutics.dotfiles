-- lua/plugins/neotest.lua
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/nvim-nio",
    -- 언어별 어댑터 (원하는 것만 남겨도 됩니다)
    "nvim-neotest/neotest-python",
    "haydenmeade/neotest-jest",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-go",
    "rouge8/neotest-rust",
  },
  keys = {
    {
      "<leader>tn",
      function()
        require("neotest").run.run()
      end,
      desc = "Test: 가장 가까운 테스트",
    },
    {
      "<leader>tN",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Test: DAP 디버그로 실행",
    },
    {
      "<leader>tF",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Test: 현재 파일 전체",
    },
    {
      "<leader>tS",
      function()
        require("neotest").run.run({ suite = true })
      end,
      desc = "Test: 워크스페이스 스위트",
    },
    {
      "<leader>tl",
      function()
        require("neotest").run.run_last()
      end,
      desc = "Test: 마지막 다시",
    },
    {
      "<leader>ts",
      function()
        require("neotest").run.stop()
      end,
      desc = "Test: 중지",
    },
    {
      "<leader>to",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Test: 출력 패널",
    },
    {
      "<leader>tt",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Test: 요약 토글",
    },
    {
      "<leader>tp",
      function()
        require("neotest").jump.prev({ status = "failed" })
      end,
      desc = "이전 실패로",
    },
    {
      "<leader>tq",
      function()
        require("neotest").quickfix.open()
      end,
      desc = "Quickfix 열기",
    },
  },
  opts = function()
    local fs = vim.loop
    local function exists(p)
      return p and fs.fs_stat(p) ~= nil
    end
    local function in_cwd(p)
      return exists((vim.loop.cwd() or ".") .. "/" .. p)
    end

    -- Python 인터프리터 탐색: VIRTUAL_ENV → .venv → 기본 python
    local function detect_python()
      local venv = vim.env.VIRTUAL_ENV
      if venv and #venv > 0 and exists(venv .. "/bin/python") then
        return venv .. "/bin/python"
      end
      for _, rel in ipairs({ ".venv/bin/python", "venv/bin/python" }) do
        local p = (vim.loop.cwd() or ".") .. "/" .. rel
        if exists(p) then
          return p
        end
      end
      return "python"
    end

    -- JS 패키지 매니저별 테스트 커맨드
    local function pkg_test(cmd)
      local cwd = vim.loop.cwd() or "."
      local function has(f)
        return exists(cwd .. "/" .. f)
      end
      if has("pnpm-lock.yaml") then
        return "pnpm " .. cmd
      end
      if has("yarn.lock") then
        return "yarn " .. cmd
      end
      return "npm run " .. cmd
    end

    -- 프로젝트 구조를 보고 필요한 어댑터만 활성화
    local adapters = {}

    -- Python (pytest)
    if in_cwd("pyproject.toml") or in_cwd("pytest.ini") or in_cwd("tests") then
      table.insert(
        adapters,
        require("neotest-python")({
          python = detect_python(),
          runner = "pytest",
          pytest_discover_instances = true,
          args = { "-q" },         -- 출력 노이즈 줄이기
          dap = { justMyCode = false }, -- 디버깅 시 외부코드 스텝인 허용
        })
      )
    end

    -- Jest
    if
        in_cwd("jest.config.js")
        or in_cwd("jest.config.ts")
        or in_cwd("jest.config.cjs")
        or in_cwd("jest.config.mjs")
        or in_cwd("package.json")
    then
      table.insert(
        adapters,
        require("neotest-jest")({
          jestCommand = pkg_test("test --"),
          env = { CI = "1" },
          cwd = function(_)
            return vim.loop.cwd()
          end,
        })
      )
    end

    -- Vitest
    if in_cwd("vitest.config.ts") or in_cwd("vitest.config.js") or in_cwd("vitest.config.mjs") then
      table.insert(
        adapters,
        require("neotest-vitest")({
          vitestCommand = pkg_test("vitest"),
          -- run = true 는 파일 단위 실행 시 유용
        })
      )
    end

    -- Go
    if in_cwd("go.mod") then
      table.insert(adapters, require("neotest-go")({}))
    end

    -- Rust
    if in_cwd("Cargo.toml") then
      table.insert(
        adapters,
        require("neotest-rust")({
          args = { "--quiet" },
        })
      )
    end

    return {
      adapters = adapters,
      discovery = { enabled = true }, -- 트리/요약 자동 스캔
      running = { concurrent = true }, -- 가능한 병렬 실행
      diagnostic = { enabled = true },
      quickfix = { enabled = true, open = false },
      summary = { animated = true, follow = true },
      output = { open_on_run = "short" }, -- 실패·요약만 자동 오픈
      icons = {
        running = "",
        passed = "",
        failed = "",
        skipped = "",
        unknown = "",
      },
      highlights = { -- 눈에 잘 띄는 기본값
        adapter_name = "Title",
        passed = "DiagnosticOk",
        failed = "DiagnosticError",
        running = "DiagnosticWarn",
        skipped = "DiagnosticInfo",
      },
    }
  end,
  config = function(_, opts)
    require("neotest").setup(opts)
  end,
}
