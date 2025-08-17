-- nvim-notify를 사용하지 않는 이유
--    일단 사용하면 좋은 이유는 telescope으로 깔끔하게 노티에 재접근이 가능하다
--    이게 차곡차곡 이쁘게 쌓이고 검색도 너무 편리하다
--    그런데 버벅임이 조금 있음. 그리고 많이 쌓이면 버벅임도 심해짐.
--    그리고 공간을 너무 많이 차지해버려서 거슬린다.
--    마지막으로 nvim을 종료할 때 너무 끊긴다.
return {
  "rcarriga/nvim-notify",
  priority = 1000,
  lazy = false,
  enabled = false,

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
    render = "wrapped-compact",
    top_down = false,
    max_height = function()
      -- return math.floor(vim.o.lines * 0.75)
      return 6
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.5)
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
