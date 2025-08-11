return {
  "dkarter/bullets.vim",
  ft = {
    "markdown",
  },
  init = function()
    -- 기본 설정
    vim.g.bullets_enabled_file_types = {
      "markdown",
      "text",
      "gitcommit",
    }

    -- bullets 설정
    vim.g.bullets_outline_levels = { "num", "abc", "std-", "std*", "std+" }
    vim.g.bullets_checkbox_markers = " .oOX"
    vim.g.bullets_mapping_leader = "<leader>m" -- 원하는 리더 키로 변경

    -- 자동 renumbering 활성화
    vim.g.bullets_auto_indent_after_colon = 1
    vim.g.bullets_renumber_on_change = 1
  end,
}
