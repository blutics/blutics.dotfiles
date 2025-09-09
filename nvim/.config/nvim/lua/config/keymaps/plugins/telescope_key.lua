local telescope_custom = require("custom.telescope_custom")

vim.keymap.set("n", "<leader>f", "<Nop>", { desc = "Telescope!" })
vim.keymap.set("n", "<leader>ff", function()
	local builtin = require("telescope.builtin")
	local themes = require("telescope.themes")
	local current_root = require("custom.root").get_current_root()
	builtin.find_files(themes.get_dropdown({
		cwd = current_root,
		previewer = false,
		layout_config = { height = 30 },
	}))
end, { desc = "Find files in Root", noremap = true, silent = true })
vim.keymap.set("n", "<leader>fF", "<Cmd>Telescope find_files<Cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<Cmd>Telescope current_buffer_fuzzy_find<Cr>", { desc = "Current buffer fuzzy" })
vim.keymap.set("n", "<leader>fG", function()
	local builtin = require("telescope.builtin")
	local current_root = require("custom.root").get_current_root()
	builtin.live_grep({ cwd = current_root })
end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fh", "<Cmd>Telescope help_tags<Cr>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>fz", "<Cmd>Telescope commands<Cr>", { desc = "Commands List" })
vim.keymap.set("n", "<leader>fk", "<Cmd>Telescope keymaps<Cr>", { desc = "Search keymaps" })
vim.keymap.set("n", "<leader>ft", "<Cmd>Telescope telescope-tabs list_tabs<Cr>", { desc = "Tabs" })
vim.keymap.set("n", "<leader>fb", telescope_custom.custom_telescope_buffer, { desc = "Buffers list" })
vim.keymap.set("n", "<leader>fr", telescope_custom.custom_telescope_oldfiles, { desc = "Recently opened files" })
vim.keymap.set("n", "<leader>fd", telescope_custom.custom_telescope_diagnostics, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fD", "<Cmd>TodoTelescope<Cr>", { desc = "TODOs" })
vim.keymap.set("n", "<leader>fj", telescope_custom.custom_telescope_jumplist, { desc = "Jumplist" })
vim.keymap.set("n", "<leader>fe", telescope_custom.custom_telescope_maker, { desc = "Make file or directory" })
vim.keymap.set("n", "<leader>fc", telescope_custom.custom_telescope_command_history, { desc = "Command history" })
vim.keymap.set("n", "<leader>fp", "<Cmd>Fav<Cr>", { noremap = true, silent = true, desc = "Find projects" })
vim.keymap.set("n", "<leader>fP", function()
	local path = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
	local custom_common = require("custom.common")
	custom_common.select_a_subdir(path, "Select a nvim plugin as a Project", function(dirname)
		local target_path = path .. "/" .. dirname
		vim.cmd("cd " .. target_path)
		require("telescope.builtin").find_files({
			cwd = target_path,
		})
	end)
end, { desc = "Vim Plugins" })
