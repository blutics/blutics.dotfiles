return {
  "MeanderingProgrammer/render-markdown.nvim",
  -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- enabled = false,
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  config = function()
    require("render-markdown").setup({
      heading = {
        -- enabled = false,
        left_margin = 0,
        left_pad = 0,
        icons = {
          "HEADER 󰬺. ",
          "HEADER 󰬻. ",
          "HEADER 󰬼. ",
          "HEADER 󰬽. ",
          "HEADER 󰬾. ",
          "HEADER 󰬿. ",
        },
        signs = {
          '󰫵',
        }
      },

      indent = {
        enabled = false,
        render_modes = true,
        skip_heading = true,
        skip_level = 0,
      },
    })
  end,
}
