return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    { 'kkharji/sqlite.lua',           module = 'sqlite' },
    -- you'll need at least one of these
    { 'nvim-telescope/telescope.nvim' },
    -- {'ibhagwan/fzf-lua'},
  },
  config = function()
    require('neoclip').setup()
    require('telescope').load_extension('neoclip')
    vim.keymap.set("n", "<leader><leader>p", "<Cmd>Telescope neoclip<Cr>", { desc = "NeoClip" })
    vim.keymap.set('n', '<leader><leader>y', function()
      local system_clip = vim.fn.getreg('+')
      print("system_clip -> neoclip")
      vim.fn.setreg('"', system_clip)
    end)
  end,
}



