vim.keymap.set("n", "<leader>T", "", {desc = "Tab"})
vim.keymap.set("n", "<leader>Tn", ":tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>Tc", ":tabclose<CR>", { desc = "Close Tab" })

-- 탭 이동
vim.keymap.set("n", "<leader>Th", ":tabprevious<CR>", { desc = "Go to Previous Tab" })
vim.keymap.set("n", "<leader>Tl", ":tabnext<CR>", { desc = "Go to Next Tab" })

-- 특정 위치로 탭 이동
vim.keymap.set("n", "<leader>Tmh", ":-tabmove<CR>", { desc = "Move Tab Left" })
vim.keymap.set("n", "<leader>Tml", ":+tabmove<CR>", { desc = "Move Tab Right" })

-- 다른 탭 모두 닫기
vim.keymap.set("n", "<leader>To", ":tabonly<CR>", { desc = "Close Other Tabs" })
