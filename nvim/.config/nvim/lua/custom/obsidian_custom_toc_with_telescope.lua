-- 📝 현재 열린 Markdown 파일에서 헤더(`#`)를 찾는 함수
local function parse_markdown_headers()
  local headers = {}
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  if filepath == "" then
    vim.notify("No file found!", vim.log.levels.WARN)
    return headers
  end

  -- 파일을 한 줄씩 읽어서 헤더(#) 찾기
  local line_num = 0
  for line in io.lines(filepath) do
    line_num = line_num + 1
    local level, header = line:match("^(#+)%s*(.-)$")
    if level and header then
      table.insert(headers, {
        display = string.rep("#", #level) .. " " .. header,
        value = header,
        lnum = line_num,
        filename = filepath,
        level = #level,
      })
    end
  end

  return headers
end

-- 🎨 선택된 헤더를 프리뷰에서 하이라이팅하는 함수
local function highlight_selected_line(bufnr, lnum)
  -- 기존 하이라이팅 삭제
  vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)

  -- 새로운 하이라이팅 추가
  local ns_id = vim.api.nvim_create_namespace("telescope_highlight")
  vim.api.nvim_buf_add_highlight(bufnr, ns_id, "Search", lnum - 1, 0, -1)
end

-- 🧐 Telescope에서 Markdown TOC를 표시하는 함수 (함수 이름 변경됨)

local markdown_toc_in_telescope = function()
  local headers = parse_markdown_headers()
  if #headers == 0 then
    vim.notify("No headers found in the file!", vim.log.levels.WARN)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local previewers = require("telescope.previewers")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  pickers
      .new({}, {
        prompt_title = "📖 Markdown Table of Contents",
        finder = finders.new_table({
          results = headers,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.display,
              ordinal = entry.display,
              lnum = entry.lnum,
              filename = entry.filename,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        sorting_strategy = "ascending",
        previewer = previewers.new_buffer_previewer({
          title = "Preview",
          define_preview = function(self, entry, status)
            local filepath = entry.filename
            if vim.fn.filereadable(filepath) == 1 then
              local file = io.open(filepath, "r")
              if not file then
                vim.notify("Failed to open file: " .. filepath, vim.log.levels.ERROR)
                return
              end

              local lines = {}
              for line in file:lines() do
                table.insert(lines, line)
              end
              file:close()

              -- 버퍼에 내용 설정
              vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
              vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "markdown")

              -- vim.schedule를 사용하여 창이 준비된 후 커서 설정
              vim.schedule(function()
                if status.preview_win and vim.api.nvim_win_is_valid(status.preview_win) then
                  local line_count = vim.api.nvim_buf_line_count(self.state.bufnr)
                  if line_count > 1 and entry.lnum <= line_count then
                    vim.api.nvim_win_set_cursor(status.preview_win, { entry.lnum, 0 })
                    highlight_selected_line(self.state.bufnr, entry.lnum)
                  else
                    vim.notify("Cursor position outside buffer: " .. entry.lnum, vim.log.levels.WARN)
                  end
                end
              end)
            else
              vim.notify("File not found: " .. filepath, vim.log.levels.ERROR)
            end
          end,
        }),
        attach_mappings = function(prompt_bufnr, map)
          -- Results 창에 relative numbers 설정
          vim.schedule(function()
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            local results_win = picker.results_win -- Results 창의 Window ID 가져오기
            if results_win and vim.api.nvim_win_is_valid(results_win) then
              vim.api.nvim_win_set_option(results_win, "number", true)
              vim.api.nvim_win_set_option(results_win, "relativenumber", true)
            end
          end)
          map("i", "<CR>", function(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            vim.api.nvim_win_set_cursor(0, { selection.value.lnum, 0 })
          end)
          return true
        end,
      })
      :find()
end

return {
  markdown_toc_in_telescope = markdown_toc_in_telescope,
}
