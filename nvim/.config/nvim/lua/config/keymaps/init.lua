require("config.keymaps.plugins.telescope_key")
require("config.keymaps.plugins.git_key")
require("config.keymaps.plugins.overseer_key")
require("config.keymaps.plugins.smartsplit_key")
require("config.keymaps.plugins.lsp_key")
require("config.keymaps.plugins.window_key")
require("config.keymaps.plugins.tab_key")
require("config.keymaps.plugins.neotest_key")
require("config.keymaps.plugins.obsidian_key")
require("config.keymaps.plugins.treesitter_key")
require("config.keymaps.plugins.double_leader_key")
require("config.keymaps.plugins.trouble_key")

-- ToggleTerm
-- 기본 키 매핑

vim.keymap.set("n", "<C-\\>", "<Cmd>ToggleTerm<CR>", { noremap = true, silent = true })
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "To Normal Mode" })

vim.keymap.set("n", "<leader>o", "<Cmd>Portal jumplist backward<Cr>", { desc = "Portal backward" })
vim.keymap.set("n", "<leader>i", "<Cmd>Portal jumplist forward<Cr>", { desc = "Portal forward" })

local todo_custom = require("custom.todo_custom_comment")

vim.keymap.set("n", "<leader>/t", function()
	todo_custom.add_todo_comment("todo")
end, { desc = "Add todo" })

local aaat = require("custom.obsidian_custom_add_aliases_and_tags")

vim.keymap.set("n", "<leader>bya", aaat.modify_aliases, { desc = "Modify aliases in frontmatter" })
vim.keymap.set("n", "<leader>byt", aaat.modify_tags, { desc = "Append Yaml Tags" })

vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true, noremap = ture }) -- Primeagen의 Tip!
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, noremap = ture })
