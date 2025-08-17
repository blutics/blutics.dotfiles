local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_s = require("telescope.actions.state")

local function normalize(it)
  local msg = it.msg or it.message or it.text or ""
  if type(msg) ~= "string" then
    msg = vim.inspect(msg)
  end
  local title = it.title or ""
  local level = it.level or it.severity or "INFO"
  local ts = tonumber(it.ts or it.time or it.timestamp or 0) or 0
  local when = ts > 0 and os.date("%H:%M:%S", ts) or "--:--:--"
  local onel = (title ~= "" and (title .. " — ") or "") .. msg:gsub("\n.*", "")
  return {
    value = it,
    ordinal = string.format("[%s] %s %s", level, when, onel),
    display = function()
      local ed = require("telescope.pickers.entry_display").create({
        separator = " ",
        items = { { width = 6 }, { width = 8 }, { remaining = true } },
      })
      return ed({ level, when, onel })
    end,
  }
end

local function open_float(text)
  local lines = vim.split(text, "\n", { plain = true })
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local ui = vim.api.nvim_list_uis()[1] or { width = 120, height = 40 }
  local w = math.min(math.max(60, math.floor(ui.width * 0.6)), ui.width - 4)
  local h = math.min(math.max(18, math.floor(ui.height * 0.5)), ui.height - 4)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = 1,
    col = 2,
    width = w,
    height = h,
    border = "rounded",
    style = "minimal",
  })
end

local function picker(opts)
  opts = opts or {}
  local notify = require("mini.notify")
  local items = notify.get_all() or {} -- ← mini.notify가 제공하는 히스토리 API :contentReference[oaicite:1]{index=1}
  local results = {}
  for i = #items, 1, -1 do
    results[#results + 1] = normalize(items[i])
  end

  pickers
      .new(opts, {
        prompt_title = "mini.notify history",
        finder = finders.new_table({
          results = results,
          entry_maker = function(e)
            return e
          end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(bufnr, map)
          map("i", "<CR>", function()
            local entry = action_s.get_selected_entry()
            actions.close(bufnr)
            local msg = entry.value.msg or entry.value.message or ""
            if type(msg) ~= "string" then
              msg = vim.inspect(msg)
            end
            open_float(msg)
          end)
          return true
        end,
      })
      :find()
end

return require("telescope").register_extension({
  exports = { history = picker },
})
