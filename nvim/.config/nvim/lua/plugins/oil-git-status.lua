return {
  "refractalize/oil-git-status.nvim",
  cond = function()
    local P = require("lazy.core.config").plugins
    local oil = P["stevearc/oil.nvim"]
    return oil and oil.enabled ~= false
  end,
  -- dependencies = {
  --   "stevearc/oil.nvim",
  -- },
  config = true,
}
