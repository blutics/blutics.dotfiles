-- lua/utils/root.lua
local M = {}
local uv = vim.uv or vim.loop
local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

-- 패턴: 여기만 고치면 전 구성요소가 따라옴
local PATTERNS = {
  -- JS/TS
  "package.json",
  "pnpm-lock.yaml",
  "yarn.lock",
  ".eslintrc",
  ".eslintrc.json",
  ".eslintrc.js",
  ".prettierrc",
  ".prettierrc.*",
  "prettier.config.*",
  -- Python
  "pyproject.toml",
  "setup.cfg",
  "setup.py",
  -- Lua
  ".stylua.toml",
  "stylua.toml",
  -- nix
  "flake.nix",
  "default.nix",
  -- 공통
  ".editorconfig",
  ".git",
}

function M.patterns()
  return vim.deepcopy(PATTERNS)
end

function M.set_patterns(list)
  PATTERNS = vim.deepcopy(list or PATTERNS)
end

local function real(p)
  return p and (uv.fs_realpath(p) or p):gsub("\\", "/") or nil
end

local function under(root, path)
  root, path = real(root), real(path)
  return root and path and (path == root or (path:sub(1, #root) == root and path:sub(#root + 1, #root + 1) == "/"))
end

-- 실경로 + 구분자 정규화 -> vim.fs.normalize
local function norm(p)
  if not p or p == "" then
    return nil
  end
  local rp = uv.fs_realpath(p) or p
  return rp:gsub("\\", "/")
end

-- p: 입력 경로 문자열
-- opts.expand   (기본 true)  : "~", "$VAR" 확장
-- opts.absolute (기본 true)  : 창/탭/전역 CWD(lcd>tcd>cd) 기준 절대화
-- opts.real     (기본 true)  : 존재하면 fs_realpath 적용(심링크/.. 해소)
-- opts.lower    (기본 true)  : Windows에서 소문자화
local function canonical(p, opts)
  opts = opts or {}
  if not p or p == "" then return nil end

  if opts.expand ~= false   then p = vim.fn.expand(p) end
  if opts.absolute ~= false then p = vim.fn.fnamemodify(p, ":p") end  -- lcd/tcd 적용
  local r = (opts.real == false) and p or (uv.fs_realpath(p) or p)

  r = r:gsub("\\", "/")
  if is_windows and (opts.lower ~= false) then r = r:lower() end
  return r
end

local function is_ancestor(parent, child)
  parent, child = norm(parent), norm(child)
  if not parent or not child then
    return false
  end
  if parent == child then
    return true
  end

  -- 경계 보장: parent가 슬래시로 끝나지 않으면 하나 붙임
  local prefix = parent:sub(-1) == "/" and parent or (parent .. "/")
  return child:sub(1, #prefix) == prefix
end

-- base가 path의 조상일 때 상대경로, 아니면 nil
local function relpath(base, path)
  base, path = norm(base), norm(path)

  -- print("@@", base, path)
  if not base or not path then return nil end
  if base == path then return "" end
  -- 경계 보장: base/ 로 접두사 검사
  local prefix = base:sub(-1) == "/" and base or (base .. "/")
  if path:sub(1, #prefix) == prefix then
    return path:sub(#prefix + 1)  -- prefix 뒤부터 끝까지
  end
  return nil
end

-- 세그먼트(조각) 개수 세기: "a/b/c" -> 3, "" -> 0
local function norm_length(rel)
  if not rel or rel == "" then return 0 end
  local n = 0
  for _ in rel:gmatch("[^/]+") do n = n + 1 end
  return n
end

-- 상대경로를 축약: N(기본 2)개 꼬리만 남기고 앞은 ".."
local function shorten_relpath(rel, keep_last)
  keep_last = keep_last or 2
  if type(rel) ~= "string" or rel == "" then return rel end

  -- 가볍게 표준화: 선행 "./", 중복/선행 슬래시 제거
  rel = rel:gsub("^%./+", ""):gsub("/+", "/"):gsub("^/+", "")

  -- 세그먼트 분해
  local segs = {}
  for s in rel:gmatch("[^/]+") do
    if s ~= "" then table.insert(segs, s) end
  end
  local n = #segs

  -- 세그먼트가 (keep_last + 1) 이상이면 앞을 ".."로 치환
  if n >= keep_last + 1 then
    local tail = table.concat(segs, "/", n - keep_last + 1, n)
    return ("../%s"):format(tail)
  else
    return rel
  end
end

local function filename_only(path)
  if not path or path == "" then return nil end
  local st = uv.fs_stat(path)           -- 존재하면 타입 확인 가능
  if st and st.type == "file" then
    return vim.fs.basename(path)        -- 파일명만
  end
  -- 디렉토리이거나 존재하지 않음 → 파일명 취급하지 않음
  return ""
end

local function directory_first(path)
  -- print("99", path)
  local st = uv.fs_stat(path)
  if st and st.type == "file" then
    return vim.fn.fnamemodify(path, ":h")
  end
  return path 
end


-- 에디터용: LSP(붙어있으면) > 패턴 > 파일 폴더
function M.find(buf)
  buf = buf or 0
  local f = real(vim.api.nvim_buf_get_name(buf))
  if f then
    local best
    for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
      local r = c and c.config and c.config.root_dir
      if r and under(r, f) then
        r = real(r)
        if not best or #r > #best then
          best = r
        end
      end
    end
    if best then
      return best
    end
  end
  return real(vim.fs.root(buf, PATTERNS)) or (f and real(vim.fs.dirname(f)) or nil)
end

-- LSP용(root_dir): LSP 미부착 전제 → 패턴 > 파일 폴더
function M.find_for_lsp(fname)
  fname = real(fname)
  local root_from_patterns = (fname and real(vim.fs.root(fname, PATTERNS)))
  local root_from_filepath = (fname and real(vim.fs.dirname(fname)) or nil)
  return root_from_patterns or root_from_filepath
end

function M.get_root_detail(fname)
  -- print("ggg")
  -- print("before : ", fname)
  fname = canonical(fname)
  -- print("after : " .. fname)
  local root_path = M.find_for_lsp(fname)
  local root_name = vim.fs.basename(root_path)
  local file_name = filename_only(fname) -- 디렉토리 네임이 들어오기도 한다.
  local file_path = directory_first(fname)
  -- print(root_path, file_path)
  local relative_path = relpath(root_path, file_path)
  local relative_length = norm_length(relative_path)
  -- print('!!', relative_path)
  local shorten_relative = shorten_relpath(relative_path)
  -- print("1", shorten_relative)
  return {
    root_name=root_name,
    root_path=root_path,
    file_name=file_name,
    file_path=file_path,
    relative_path=relative_path,
    relative_length=relative_length,
    shorten_relative=shorten_relative,
  }
end

return M
