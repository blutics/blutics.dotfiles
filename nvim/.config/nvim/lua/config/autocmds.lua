
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = true          -- 현재 줄 번호 표시
    vim.opt_local.relativenumber = true  -- relative 줄 번호 표시
  end,
})
