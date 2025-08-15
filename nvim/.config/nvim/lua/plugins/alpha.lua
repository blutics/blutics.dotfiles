local headers = {
  "██████╗ ██╗     ██╗   ██╗████████╗██╗ ██████╗███████╗",
  "██╔══██╗██║     ██║   ██║╚══██╔══╝██║██╔════╝██╔════╝",
  "██████╔╝██║     ██║   ██║   ██║   ██║██║     ███████╗",
  "██╔══██╗██║     ██║   ██║   ██║   ██║██║     ╚════██║",
  "██████╔╝███████╗╚██████╔╝   ██║   ██║╚██████╗███████║",
  "╚═════╝ ╚══════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝╚══════╝",
}

local hl_colors = { "#89b4fa", "#b4befe", "#cba6f7", "#94e2d5", "#c6a0f6", "#89dceb" }

return {
  {
    "goolord/alpha-nvim",
    enabled=false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- 하이라이트 그룹 설정
      for i, v in ipairs(hl_colors) do
        vim.api.nvim_set_hl(0, ("AlphaHeader%d"):format(i), { fg = v })
      end

      -- 헤더 설정
      dashboard.section.header.val = {}
      for index, value in ipairs(headers) do
        table.insert(dashboard.section.header.val, string.format("   %s", value))
      end

      -- 헤더 하이라이트 설정
      local hl = {}
      for i = 1, 6 do
        table.insert(hl, { ("AlphaHeader%d"):format(i), 0, -1 })
      end
      dashboard.section.header.opts.hl = hl

      -- 버튼 설정
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
        dashboard.button("l", "  Lazy package manager", ":Lazy <CR>"),
        dashboard.button("m", "  Mason manager", ":Mason <CR>"),
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
        { type = "padding", val = 15 },
        dashboard.section.header,
        { type = "padding", val = 5 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      -- Alpha 설정 적용
      alpha.setup(dashboard.config)
    end,
  },
}
