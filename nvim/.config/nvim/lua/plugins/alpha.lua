return {
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- 하이라이트 그룹 설정
      vim.api.nvim_set_hl(0, "AlphaHeader1", { fg = "#89b4fa" })
      vim.api.nvim_set_hl(0, "AlphaHeader2", { fg = "#b4befe" })
      vim.api.nvim_set_hl(0, "AlphaHeader3", { fg = "#cba6f7" })
      vim.api.nvim_set_hl(0, "AlphaHeader4", { fg = "#94e2d5" })
      vim.api.nvim_set_hl(0, "AlphaHeader5", { fg = "#c6a0f6" })
      vim.api.nvim_set_hl(0, "AlphaHeader6", { fg = "#89dceb" })

      -- 헤더 설정
      dashboard.section.header.val = {
        string.format(
          "%s",
          "██████╗ ██╗     ██╗   ██╗████████╗██╗ ██████╗███████╗"
        ),
        string.format(
          "%s",
          "██╔══██╗██║     ██║   ██║╚══██╔══╝██║██╔════╝██╔════╝"
        ),
        string.format(
          "%s",
          "██████╔╝██║     ██║   ██║   ██║   ██║██║     ███████╗"
        ),
        string.format(
          "%s",
          "██╔══██╗██║     ██║   ██║   ██║   ██║██║     ╚════██║"
        ),
        string.format(
          "%s",
          "██████╔╝███████╗╚██████╔╝   ██║   ██║╚██████╗███████║"
        ),
        string.format(
          "%s",
          "╚═════╝ ╚══════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝╚══════╝"
        ),
      }

      -- 헤더 하이라이트 설정
      dashboard.section.header.opts.hl = {
        { "AlphaHeader1", 0, -1 },
        { "AlphaHeader2", 0, -1 },
        { "AlphaHeader3", 0, -1 },
        { "AlphaHeader4", 0, -1 },
        { "AlphaHeader5", 0, -1 },
        { "AlphaHeader6", 0, -1 },
      }

      -- 버튼 설정
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
        dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
        dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
      }

      -- 푸터 설정
      local function footer()
        local total_plugins = #vim.tbl_keys(require("lazy").plugins())
        return "Loaded " .. total_plugins .. " plugins"
      end

      dashboard.section.footer.val = footer()

      -- 레이아웃 설정 (더 큰 패딩 값 사용)
      dashboard.config.layout = {
        { type = "padding", val = 10 },
        dashboard.section.header,
        { type = "padding", val = 5 },
        dashboard.section.buttons,
        { type = "padding", val = 5 },
        dashboard.section.footer,
      }
      
      -- Alpha 설정 적용
      alpha.setup(dashboard.config)
    end,
  },
}
