return {
  "echasnovski/mini.notify",
  enabled = false,
  init = function()
    local notify = require("mini.notify")
    notify.setup()
    vim.notify = notify.make_notify()

    local function to_text(...)
      local out = {}
      for i = 1, select("#", ...) do
        local v = select(i, ...)
        out[#out + 1] = (type(v) == "string") and v or vim.inspect(v)
      end
      return table.concat(out, " ")
    end

    _G.print = function(...)
      return vim.notify(to_text(...), vim.log.levels.INFO, { title = "print" })
    end

    vim.print = function(...)
      return vim.notify(to_text(...), vim.log.levels.INFO, { title = "print" })
    end

    -- 4) :echo / :echomsg → notify 로 라우팅
    --    (원본 nvim_echo를 래핑. REPLACE_ECHO=true면 기본 메시지창 출력은 차단)
    local orig_echo = vim.api.nvim_echo
    local IN_ECHO = false
    local REPLACE_ECHO = true -- false로 두면 '미러링'(기본 메시지창에도 출력)

    vim.api.nvim_echo = function(chunks, history, opts)
      if IN_ECHO then
        return orig_echo(chunks, history, opts)
      end
      IN_ECHO = true
      local ok = pcall(function()
        local text = table.concat(
          vim.tbl_map(function(c)
            return c[1]
          end, chunks),
          ""
        )
        vim.notify(text, vim.log.levels.INFO, { title = "echo" })
      end)
      IN_ECHO = false
      if not ok or not REPLACE_ECHO then
        return orig_echo(chunks, history, opts)
      end
      -- REPLACE_ECHO=true → 기본 echo는 건너뛰어 화면은 조용, mini.notify 히스토리로만 남김
    end

    -- 5) 히스토리 뷰 단축키(원할 때 전부 열람)
    vim.keymap.set("n", "<leader>un", function()
      MiniNotify.show_history()
    end, { desc = "Notify history" })
  end,
}
