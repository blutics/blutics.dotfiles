-- lua/status/null_ls_names.lua
local M = {}

function M.list(bufnr)
  bufnr = bufnr or 0
  -- null-ls가 붙어 있지 않으면 표시는 비움
  if #vim.lsp.get_clients({ bufnr = bufnr, name = "null-ls" }) == 0 then
    return ""
  end

  local ok, sources_mod = pcall(require, "null-ls.sources")
  if not ok then return "null-ls" end

  local ft = vim.bo[bufnr].filetype
  local sources = sources_mod.get_available(ft) or {}

  -- 이름만 수집(진단/포맷/액션 중복 제거)
  local seen, names = {}, {}
  for _, src in ipairs(sources) do
    if not seen[src.name] then
      seen[src.name] = true
      table.insert(names, src.name)
    end
  end
  table.sort(names)

  if #names == 0 then return "null-ls[]" end
  return "[" .. table.concat(names, " ") .. "]"
end

return M

