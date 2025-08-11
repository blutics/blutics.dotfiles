vim.keymap.set("n", "<leader>x", "", { desc = "Trouble" })
vim.keymap.set(
  "n",
  "<leader>xx",
  "<Cmd>Trouble diagnostics toggle filter.buf=0<Cr>",
  { desc = "Buffer Diagnostics (Trouble)" }
)
vim.keymap.set("n", "<leader>xX", "<Cmd>Trouble diagnostics toggle<Cr>", { desc = "Workspace Diagnostics (Trouble)" })
