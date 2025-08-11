return {
  "echasnovski/mini.move",
  version = false, -- 최신 버전 사용
  config = function()
    require("mini.move").setup({
      -- 매핑 설정
      mappings = {
        -- 비주얼 모드
        left = "<M-h>",
        right = "<M-l>",
        down = "<M-j>",
        up = "<M-k>",

        -- 일반 모드
        line_left = "<M-h>",
        line_right = "<M-l>",
        line_down = "<M-j>",
        line_up = "<M-k>",
      },

      -- 옵션
      options = {
        -- 커서 위치 유지
        reindent_linewise = true,

        -- 다른 윈도우의 끝에서 이동 제한
        respect_scrolloff = true,

        -- 창 경계를 넘어선 이동 허용
        allow_multiline = true,
      },
    })
  end,
  keys = {
    { "<M-h>", mode = { "n", "v" } },
    { "<M-j>", mode = { "n", "v" } },
    { "<M-k>", mode = { "n", "v" } },
    { "<M-l>", mode = { "n", "v" } },
  },
  -- 선택적 의존성 설정
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
}
