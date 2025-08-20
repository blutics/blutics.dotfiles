vim.keymap.set("n", "<leader>fm", "<Cmd>Telescope toggleterm_manager<Cr>", { desc = "Toggleterm Manager" })
return {
  "ryanmsnyder/toggleterm-manager.nvim",
  dependencies = {
    "akinsho/nvim-toggleterm.lua",
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
  },
  init = function()
    local toggleterm_manager = require("toggleterm-manager")
    local actions = toggleterm_manager.actions

    toggleterm_manager.setup({
      mappings = {
        i = {
          ["<CR>"] = { action = actions.toggle_term, exit_on_action = true },
          ["<C-i>"] = { action = actions.create_term, exit_on_action = false },
        },
        n = {
          ["<CR>"] = { action = actions.toggle_term, exit_on_action = true },
          ["<C-i>"] = { action = actions.create_term, exit_on_action = false },
        },
      },
    })
  end,
  config = true,
}
