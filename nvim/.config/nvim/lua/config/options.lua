-- vim.o.guifont = "JetBrainsMono Nerd Font:h10"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local indentDepth = 2

vim.opt.smartindent = true        -- 스마트 들여쓰기
vim.opt.tabstop = indentDepth     -- 탭 너비를 4로 설정
vim.opt.expandtab = true          -- 탭을 스페이스로 변환
vim.opt.shiftwidth = indentDepth  -- 자동 들여쓰기 너비를 4로 설정

vim.opt.autoindent = true         -- 자동 들여쓰기
vim.opt.softtabstop = indentDepth -- 편집할 때 탭 크기
vim.opt.wrap = false              -- 긴 줄 줄바꿈 비활성화

-- 기본 인코딩 설정
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.scriptencoding = "utf-8"

-- 라인 넘버 표시
vim.opt.number = true
vim.opt.relativenumber = true -- 상대적 라인 넘버

-- 시스템 클립보드 사용
vim.opt.clipboard = "unnamedplus"

-- UI 설정
vim.opt.termguicolors = true -- TrueColor 지원
vim.opt.cursorline = true    -- 현재 라인 하이라이트
vim.opt.signcolumn = "yes"   -- 사인 컬럼 표시 (git 변경사항 등)
vim.opt.showmatch = true     -- 괄호 매칭 보여주기

-- 스플릿 설정
vim.opt.splitbelow = true -- 수평 분할 시 아래로
vim.opt.splitright = true -- 수직 분할 시 오른쪽으로

-- 현재 라인 하이라이트 활성화
vim.opt.cursorline = true

-- init.lua 또는 다른 설정 파일에 추가
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    -- 모든 LSP 클라이언트 종료
    vim.lsp.stop_client(vim.lsp.get_active_clients())

    -- 추가적인 백그라운드 작업 종료
    vim.cmd([[
      silent! wa  -- 모든 버퍼 저장
      silent! qa! -- 강제 종료
    ]])
  end,
  group = vim.api.nvim_create_augroup("CleanupOnExit", { clear = true }),
})
