return {
  "rcarriga/nvim-notify",
  priority = 1000,
  lazy = false,

  keys = {
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss all Notifications",
    },
  },
  opts = {
    timeout = 3000,
    render = "compact",
    top_down = false,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { zindex = 100 })
    end,
  },
  init = function()
    -- 기본 알림 핸들러를 nvim-notify로 설정
    --
    -- 기본 print 함수 저장
    local original_print = print

    -- print 함수 재정의
    _G.print = function(...)
      -- 원래 print 기능 유지
      original_print(...)

      -- notify로도 출력
      local args = { ... }
      local print_string = ""
      for i = 1, select("#", ...) do
        print_string = print_string .. tostring(args[i]) .. " "
      end
      require("notify")(print_string, "info", {
        title = "Print",
        timeout = 2000,
      })
    end
    vim.notify = require("notify")
    require("telescope").load_extension("notify")
  end,
}
