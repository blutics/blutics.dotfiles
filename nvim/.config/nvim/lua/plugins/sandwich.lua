return {
  "machakann/vim-sandwich",
  event = "VeryLazy",
  config = function()
    -- vim-sandwich가 기본 키맵을 덮어쓰지 않도록 설정
    -- vim.g.sandwich_no_default_key_mappings = 1

    -- 사용자 정의 키맵 설정
    -- vim.keymap.set('n', 'sa', '<Plug>(sandwich-add)')

    -- 자동으로 스페이스를 추가하는 설정
    vim.g["operator#sandwich#recipes"] = {
      {
        buns = { '{ ', ' }' },
        nesting = 1,
        match_syntax = 1,
        kind = { 'add', 'replace' },
        action = { 'add' },
        input = { '{' }
      },
      {
        buns = { '[ ', ' ]' },
        nesting = 1,
        match_syntax = 1,
        kind = { 'add', 'replace' },
        action = { 'add' },
        input = { '[' }
      }
    }
  end
}
