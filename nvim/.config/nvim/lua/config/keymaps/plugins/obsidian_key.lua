local custom_obsidian = require("custom.obsidian_custom")
local toc_telescope = require("custom.obsidian_custom_toc_with_telescope")

vim.keymap.set("n", "<leader>b", "", { desc = "Obsidian" })
vim.keymap.set("n", "<leader>bw", "<Cmd>ObsidianWorkspace<Cr>", { desc = "Change Obsidian Workspace" })
vim.keymap.set("n", "<leader>bb", "<Cmd>ObsidianBacklinks<Cr>", { desc = "Telescope BackLinks" })
vim.keymap.set("n", "<leader>bt", "<Cmd>ObsidianTags<Cr>", { desc = "Telescope Tags in this Vault" })
vim.keymap.set("n", "<leader>br", "<Cmd>ObsidianRename<Cr>", { desc = "Rename!" })
vim.keymap.set("n", "<leader>bd", "<Cmd>ObsidianDailies<Cr>", { desc = "Dailies" })
vim.keymap.set("n", "<leader>bf", "<Cmd>ObsidianQuickSwitch<Cr>", { desc = "Quick Switch to another note" })
vim.keymap.set("n", "<leader>bg", "<Cmd>ObsidianSearch<Cr>", { desc = "Find Notes" })

vim.keymap.set("n", "<leader>bc", toc_telescope.markdown_toc_in_telescope, { desc = "TOC with Telescope" })
vim.keymap.set("n", "<leader>bh", custom_obsidian.remove_checkbox, { desc = "Release Checkbox" }) -- 체크박스 제거 함수
vim.keymap.set("n", "<leader>bn", custom_obsidian.make_note_in_any_directory, { desc = "Make note in any directory" })
vim.keymap.set("n", "<leader>bN", custom_obsidian.make_note_in_inbox, { desc = "Make note in inbox" })
vim.keymap.set("n", "<leader>ba", custom_obsidian.search_by_aliases, { desc = "Find by aliases" })
vim.keymap.set("n", "<leader>bA", custom_obsidian.search_by_aliases_within_a_directory, { desc = "Find by aliases within a directory" })
