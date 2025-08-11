local make_builtin_theme = function()
  return {
    border = "rounded",
    relative = "editor",
    width = 60,
    height = 20,
    row = 2,
    col = 2,
    mappings = {
      ["q"] = "Close",
      ["<Esc>"] = "Close",
      ["<CR>"] = "Confirm",
    },
  }
end

local make_telescope_theme = function()
  require("telescope.themes").get_dropdown({
    border = true,
    preview = true,
    layout_config = {
      width = 0.5,
      height = 0.6,
    },
  })
end
return {
  -- "stevearc/dressing.nvim",
  -- opts = {
  --   select = {
  --     enabled = true,
  --     backend = { "builtin" }, -- telescope나 fzf 대신 builtin 사용
  --     get_config = function(opts)
  --       if opts.kind == "overseer_template" then
  --         return {
  --           backend = { "telescope" },
  --           telescope = make_telescope_theme(),
  --         }
  --       end
  --       return {
  --         backend = { "builtin" },
  --         builtin = make_builtin_theme(),
  --       }
  --     end,
  --   },
  --   input = {
  --     enabled = true,
  --     border = "rounded",
  --     relative = "editor",
  --   },
  -- },
}
