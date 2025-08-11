local M = {}

--  TODO: 안녕하세요 여기서 입력하시면 됩니다. 그래잇!!! 

function M.get_comment_format()
  local ft = vim.bo.filetype

  local commentstring = vim.bo.commentstring

  if commentstring and commentstring ~= "" then
    local single_line = commentstring:gsub("%%s.*$", "")

    -- comments 문자열을 안전하게 파싱
    local multi_line = nil
    if vim.bo.comments then
      local comments_parts = vim.fn.split(vim.bo.comments, ",")
      -- 모든 필요한 부분이 있는지 확인
      local start_pattern, middle_pattern, end_pattern

      -- comments 문자열에서 각 부분을 찾습니다
      for _, part in ipairs(comments_parts) do
        if part:match("^s:") then
          start_pattern = part:match("^s:(.+)")
        elseif part:match("^m:") then
          middle_pattern = part:match("^m:(.+)")
        elseif part:match("^e:") then
          end_pattern = part:match("^e:(.+)")
        end
      end

      -- 모든 필요한 부분이 있다면 multi_line 테이블을 생성
      if start_pattern and end_pattern then
        multi_line = {
          start = start_pattern,
          middle = middle_pattern or " ", -- middle이 없으면 기본값 사용
          ending = end_pattern,
        }
      end
    end

    return {
      single_line = single_line,
      multi_line = multi_line,
    }
  end

  -- 나머지 Treesitter 관련 코드는 동일...
end

-- TODO 주석을 추가하는 함수입니다
function M.add_todo_comment(comment_type)
  local comment_info = M.get_comment_format()
  if not comment_info then
    return
  end

  local templates = {
    todo = "TODO: ",
    fix = "FIX: ",
    hack = "HACK: ",
    note = "NOTE: ",
    warning = "WARNING: ",
  }

  local template = templates[comment_type]
  if not template then
    return
  end

  -- 현재 라인 위치를 가져옵니다
  local line = vim.api.nvim_win_get_cursor(0)[1]

  -- 한 줄 주석 추가
  if comment_info.single_line then
    local comment_text = comment_info.single_line .. " " .. template
    vim.api.nvim_buf_set_lines(0, line - 1, line, false, { comment_text })
    vim.api.nvim_win_set_cursor(0, { line, #comment_text })
  end
end

-- 여러 줄 TODO 주석을 추가하는 함수입니다
function M.add_multiline_todo_comment(comment_type)
  local comment_info = M.get_comment_format()
  if not comment_info or not comment_info.multi_line then
    return
  end

  local template = comment_info.multi_line
  local curr_line = vim.api.nvim_win_get_cursor(0)[1]

  -- 여러 줄 주석 구조를 만듭니다
  local lines = {
    template.start .. " " .. comment_type:upper() .. ":",
    template.middle,
    template.ending,
  }

  -- 주석을 삽입합니다
  vim.api.nvim_buf_set_lines(0, curr_line - 1, curr_line - 1, false, lines)
  vim.api.nvim_win_set_cursor(0, { curr_line + 1, #template.middle })
  vim.cmd("startinsert!")
end

-- TODO 주석을 삭제하는 함수입니다
function M.delete_todo_comment()
  local comment_info = M.get_comment_format()
  if not comment_info then
    return
  end

  local curr_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- 주석의 시작과 끝을 찾습니다
  local start_line = curr_line
  local end_line = curr_line

  local single_pattern = comment_info.single_line and vim.pesc(comment_info.single_line) .. "%s*[A-Z]+:" or nil
  local multi_start = comment_info.multi_line and vim.pesc(comment_info.multi_line.start) or nil
  local multi_end = comment_info.multi_line and vim.pesc(comment_info.multi_line.ending) or nil

  -- 주석 영역을 찾아서 삭제합니다
  if single_pattern and lines[curr_line]:match(single_pattern) then
    vim.api.nvim_buf_set_lines(0, curr_line - 1, curr_line, false, {})
  elseif multi_start and multi_end then
    while start_line > 0 and not lines[start_line]:match(multi_start) do
      start_line = start_line - 1
    end
    while end_line <= #lines and not lines[end_line]:match(multi_end) do
      end_line = end_line + 1
    end
    if start_line > 0 and end_line <= #lines then
      vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {})
    end
  end
end

return M
