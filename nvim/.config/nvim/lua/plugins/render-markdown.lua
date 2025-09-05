-- 와! markdown 포멧lsp를 prettier에서 dprint로 바꾸니까. 
-- 굉장히 쾌적해지고 여기서 render-markdown을 적용시키니 굉장히 이쁘게 나오네....
return {
  "MeanderingProgrammer/render-markdown.nvim",
  -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- enabled = false,
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  config = function()
    require("render-markdown").setup({
      heading = {
        enabled = true,
        sign = true,
        border = true,
        
        left_margin = 0,
        left_pad = 2,
        icons = {
          "󰬺. ",
          "󰬻. ",
          "󰬼. ",
          "󰬽. ",
          "󰬾. ",
          "󰬿. ",
        },
        signs = {
          '󰫵',
        }
      },

      indent = {
        enabled = true,
        render_modes = true,
        skip_heading = true,
        skip_level = 0,
      },
      
    })
  end,
}
