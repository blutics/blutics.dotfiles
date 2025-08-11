-- Overseer
--
--
--

local keymap_utils = require("config.keymaps.utils")
-- 키매핑 설정
local mainChar = "s"

vim.keymap.set("n", keymap_utils.make_leader_keymap_string(mainChar, ""), "", { desc = "Overseer" })
vim.keymap.set("n", keymap_utils.make_leader_keymap_string(mainChar, "o"), ":OverseerOpen<CR>")
vim.keymap.set("n", keymap_utils.make_leader_keymap_string(mainChar, "t"), ":OverseerToggle<CR>")
vim.keymap.set("n", keymap_utils.make_leader_keymap_string(mainChar, "r"), ":OverseerRun<CR>")
vim.keymap.set("n", keymap_utils.make_leader_keymap_string(mainChar, "c"), ":OverseerRunCmd<CR>")
vim.keymap.set("n", keymap_utils.make_leader_keymap_string(mainChar, "l"), ":OverseerLoadBundle<CR>")
vim.keymap.set("n", keymap_utils.make_leader_keymap_string(mainChar, "b"), ":OverseerBuild<CR>")
vim.keymap.set("n", keymap_utils.make_leader_keymap_string(mainChar, "s"), ":OverseerSaveBundle<CR>")
