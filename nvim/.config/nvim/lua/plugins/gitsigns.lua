return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = { -- 필요시 원하는 옵션 추가
    signs_staged_enable = false,
  },
}
