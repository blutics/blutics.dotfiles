-- local util = require("lspconfig.util")

-- 로컬 → mason → 전역 순으로 바이너리 찾기 (이미 있으시면 그대로 사용)
local function npm_cmd(bin)
  local cwd = vim.loop.cwd() or vim.fn.getcwd()
  local local_bin = cwd .. "/node_modules/.bin/" .. bin
  if vim.loop.fs_stat(local_bin) then
    return local_bin
  end
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/" .. bin
  if vim.loop.fs_stat(mason_bin) then
    return mason_bin
  end
  local global = vim.fn.exepath(bin)
  return (global ~= "" and global) or bin
end

return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  settings = {
    -- monorepo에서 eslintrc / eslint.config.js 를 자동 탐지
    -- 문제가 있으면 (B) 절처럼 디렉터리 배열로 명시하세요.
    workingDirectories = { mode = "auto" },
    -- eslint가 포맷터로도 등록되도록
    -- format = true,

    -- Flat Config(ESLint 9) 사용 시 필요할 수 있음
    experimental = { useFlatConfig = true },
    single_file_support = false,

    -- 저장 시 FixAll을 좋아한다면 LSP만으로도 가능(자동 적용 로직은 아래 오토커맨드에서 처리)
    codeActionOnSave = { enable = true, mode = "all" },
  },
  on_new_config = function(config, root)
    config.settings = config.settings or {}
    config.settings.workingDirectories = { { directory = root, changeProcessCWD = true } }
  end,
}
