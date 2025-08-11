
local M = {}

--- Pyright가 제안하는 "Add missing imports" 코드를 자동 적용
function M.add_missing_imports()
  -- 현재 버퍼 범위에 해당하는 파라미터 생성
  local params = vim.lsp.util.make_range_params()
  -- Pyright의 "quickfix" 종류(Code Action)만 필터링
  -- (Add missing imports, Remove unused imports 등)
  params.context = { only = { "quickfix" } }

  -- LSP 서버에 textDocument/codeAction 요청
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
  if not result or vim.tbl_isempty(result) then
    return
  end

  for _, res in pairs(result) do
    for _, action in pairs(res.result or {}) do
      -- 편집(edit) 객체가 있으면 워크스페이스 편집 적용
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
      -- edit 없이 command만 있는 경우에는 execute_command 호출
      elseif type(action.command) == "table" then
        vim.lsp.buf.execute_command(action.command)
      end
    end
  end
end

return M

