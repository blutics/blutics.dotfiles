return {
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      enable = true,
      filetypes = {
          'html', 'xml', 'javascript', 'javascriptreact',
          'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx',
          'rescript', 'php', 'markdown'
      },
      enable_rename = true,
      enable_close = true,
      enable_close_on_slash = true,
    },
    config = function(_, opts)
      require('nvim-ts-autotag').setup(opts)
    end,
  },     -- HTML 태그 자동 닫기
  {
    "windwp/nvim-autopairs",
    opts = {
      disable_filetype = { "TelescopePrompt" },
      disable_in_macro = false,       -- 매크로 실행 중 비활성화
      disable_in_visualblock = false, -- 비주얼 블록 모드에서 비활성화
      ignored_next_char = [=[[%w%%%'%[%"%.]]=],
      enable_moveright = true,
      enable_afterquote = true, -- 따옴표 뒤에 괄호 추가
      enable_check_bracket_line = true,
      enable_bracket_in_quote = true,
    },
  },
}
