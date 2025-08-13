return {
  -- DB 클라이언트
  {
    "tpope/vim-dadbod",
    cmd = { "DB", "DBUI", "DBUIToggle" }, -- 필요할 때만 로드
    dependencies = {
      { "kristijanhusak/vim-dadbod-ui" },
      { "kristijanhusak/vim-dadbod-completion" },
    },
    config = function()
      -- DB 연결 정보 예시
      vim.g.db_ui_save_location = "~/.config/nvim/db_ui"
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
}

