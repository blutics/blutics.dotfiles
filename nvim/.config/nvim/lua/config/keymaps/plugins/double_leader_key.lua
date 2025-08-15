local telescope_custom = require("custom.telescope_custom")

vim.keymap.set("n", "<leader><leader>d", ":Alpha<CR>", { noremap = true, silent = true, desc = "Alpha Dashboard" })
vim.keymap.set("n", "<leader><leader>s", "<Cmd>ShowkeysToggle<Cr>", { desc = "Showkeys" })
vim.keymap.set("n", "<leader><leader>/", "<Cmd>noh<Cr>", { desc = "Unlight highlight!" })
vim.keymap.set(
  "n",
  "<leader><leader>h",
  telescope_custom.custom_telescope_notification,
  { desc = "Telescope Notification History" }
)
vim.keymap.set(
  "n",
  "<leader><leader>cd",
  telescope_custom.custom_show_current_directory,
  { desc = "Show current working directories" }
)
