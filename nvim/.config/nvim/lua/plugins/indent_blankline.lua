return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = function()
    return {
      -- 들여쓰기 가이드라인 설정
      indent = {
        char = "│", -- 사용할 문자
        highlight = "IndentBlanklineChar", -- 하이라이트 설정
      },
      -- 빈 줄에도 들여쓰기 표시
      whitespace = {
        remove_blankline_trail = false,
      },

      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        highlight = "IndentBlanklineContextChar",
      },
    }
  end,
}
