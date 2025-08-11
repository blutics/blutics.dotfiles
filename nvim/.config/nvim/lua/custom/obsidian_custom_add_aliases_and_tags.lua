local M = {}

local function modify_targets(target)
  local value = vim.fn.input(string.format("Enter %s : ", target))
  if value == "" then
    print("No value entered, cancelled")
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local start_line, end_line

  for i, line in ipairs(lines) do
    if line == "---" then
      if not start_line then
        start_line = i
      else
        end_line = i
        break
      end
    end
  end

  if not start_line or not end_line then
    return
  end

  -- aliases의 마지막 라인을 찾기 위한 변수들
  local aliases_start_line
  local aliases_end_line
  local has_empty_array = false

  for i = start_line, end_line do
    local line = lines[i]
    if line:match("^" .. target .. ":%s*$") or line:match("^" .. target .. ":%s*%[%]%s*$") then
      aliases_start_line = i
      if line:match("%[%]") then
        has_empty_array = true
      end
    elseif aliases_start_line and not line:match("^%s+-") then
      -- aliases 항목이 끝나는 지점 찾기
      aliases_end_line = i
      break
    end
  end

  -- aliases의 끝을 못찾았다면 다음 속성까지가 끝
  if not aliases_end_line and aliases_start_line then
    for i = aliases_start_line + 1, end_line do
      local line = lines[i]
      if not line:match("^%s+-") then
        aliases_end_line = i
        break
      end
    end
  end

  if not aliases_start_line then
    return
  end
  if not aliases_end_line then
    aliases_end_line = aliases_start_line + 1
  end

  if has_empty_array then
    -- []를 지우고 새 라인에 입력받은 값 추가
    vim.api.nvim_buf_set_lines(0, aliases_start_line - 1, aliases_start_line, false, { target .. ":" })
    vim.api.nvim_buf_set_lines(0, aliases_end_line - 1, aliases_end_line - 1, false, { "  - " .. value })
  else
    -- aliases의 마지막 위치에 입력받은 값 추가
    vim.api.nvim_buf_set_lines(0, aliases_end_line - 1, aliases_end_line - 1, false, { "  - " .. value })
  end

  vim.cmd("redraw")
end

M.modify_aliases = function()
  return modify_targets("aliases")
end

M.modify_tags = function()
  return modify_targets("tags")
end

return M
