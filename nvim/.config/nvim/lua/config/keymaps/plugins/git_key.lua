
-- Git 관련
vim.keymap.set("n", "<leader>G", "", { desc = "Git" })
vim.keymap.set("n", "<leader>Gc", ":Telescope git_commits<Cr>", { desc = "Git commits" })
vim.keymap.set("n", "<leader>Gb", ":Telescope git_branches<Cr>", { desc = "Git branches" })
vim.keymap.set("n", "<leader>Gs", ":Telescope get_status<Cr>", { desc = "Git status" })


