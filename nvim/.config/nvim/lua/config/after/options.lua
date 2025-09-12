vim.cmd([[ 
  hi Normal guibg=None ctermbg=None
  hi EndOfBuffer guibg=None ctermbg=None
  hi NormalNC guibg=NONE ctermbg=NONE
  hi NormalFloat guibg=NONE ctermbg=NONE
  hi WinSeparator guibg=NONE ctermbg=NONE
]])

vim.cmd([[
  hi LineNr guifg=white ctermfg=white
  hi CursorLineNr guifg=yellow ctermfg=yellow
  hi LineNrAbove guifg=grey ctermfg=grey
  hi LineNrBelow guifg=grey ctermfg=grey
  hi SignColumn guibg=None
]])

-- hi CursorLineNr guifg=white ctermfg=white
-- hi LineNrAbove guifg=#F8B1CE ctermfg=red
-- hi LineNrBelow guifg=#93C47D ctermfg=green

-- 기타 --> Illuminated
vim.cmd([[hi CursorLine guibg=#2a2a3a]]) -- 기본적으로 커서가 있는 라인
vim.cmd([[hi Visual guifg=#000000 guibg=#ffffff]])
-- vim.cmd [[hi VisualBlock guifg=white guibg=black ]] -- 블럭이 잡혔을 때
vim.cmd([[hi VM_Extend guifg=#ffffff guibg=green]]) -- 멀티커서가 잡혔을때

vim.cmd([[set guicursor=n-v-c:block-Cursor ]])
vim.cmd([[set guicursor+=i-ci-ve:block-iCursor/lCursor]]) -- 왜 이걸 설정해야지만 색이 바뀌는거지?

vim.cmd([[hi VM_Cursor guibg=black guifg=white]]) -- 커서의 색 같음
vim.cmd([[hi Cursor guibg=white  guifg=black]])
vim.cmd([[hi iCursor guibg=#e69138  guifg=black]])
vim.cmd([[hi vCursor guibg=black guifg=white]])

vim.cmd([[hi TelescopeSelection guibg=#2F3A40]]) -- 텔레스콥에서 현재 커서가 있는 라인의 색

-- vim.cmd([[ShowkeysToggle]])
