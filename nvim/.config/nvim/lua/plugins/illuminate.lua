return {
  "RRethy/vim-illuminate",
  config = function()
    require('illuminate').configure({
      providers = { 'lsp', 'treesitter', 'regex' },
      delay = 100,
      filetype_overrides = {},
    })
    vim.cmd [[hi IlluminatedWordText guibg=purple ]] -- 커서가 포함된 특수문자 영역, 괄호, 타입, 문자열 등등
    vim.cmd [[hi IlluminatedWordRead guibg=#FFA500 guifg=black ]] -- 변수 등, 같은 값을 가지는 단어들에 대해서
    -- vim.cmd [[hi IlluminatedWordWrite guibg=#000000 ]]
  end
}
