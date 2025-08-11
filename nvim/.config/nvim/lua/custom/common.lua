local M = {}

function M.get_project_root()
  -- 현재 파일의 절대 경로 (버퍼가 저장된 파일이 없다면 현재 작업 디렉토리)
  local util = require("lspconfig.util")
  local current_file = vim.fn.expand("%:p")
  if current_file == "" then
    current_file = vim.fn.getcwd()
  end
  local patterns = {
    ".git",
    "_darcs",
    ".hg",
    ".bzr",
    ".svn",
    "Makefile",
    "package.json",
    "requirements.txt",
    ".obsidian",
    "README.md",
  }
  local root = util.root_pattern(unpack(patterns))(current_file)
  return root or vim.fn.getcwd()
end

function M.get_project_directories(callback)
  -- 루트 디렉토리 아래의  폴더를 선택 후 해당 디렉토리를 바탕으로 callback으로 특정 작업 진행하기
  --
  local root_dir = vim.fn.getcwd()
  print("selected path ->", root_dir)
  require("telescope").extensions.file_browser.file_browser({
    prompt_title = "Create Note in Current Vault",
    cwd = root_dir,
    hidden = false,
    respect_gitignore = false,
    previewer = false,
    select_buffer = true,
    only_dirs = true,
    files = false, -- 파일 표시 비활성화
    depth = 1, -- 한 번에 한 레벨만 표시
    dir_icon = "📁", -- 디렉토리 아이콘
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local create_note = function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        local relative_path = string.sub(selection.path, #root_dir + 2) -- string.sub -> (a, b) 문자열 a를 index b부터 잘라서 리턴한다.
        local abs_path = root_dir .. "/" .. relative_path
        print(abs_path)
        callback(abs_path)
      end
      map("i", "<CR>", create_note)
      map("n", "<CR>", create_note)
      return true
    end,
    layout_strategy = "vertical", -- 'horizontal', 'center' 등
    layout_config = {
      width = 0.4,
      height = 0.6,
    },
    sorting_strategy = "descending",
    prompt_title = "🌟 Recently 🌟", -- 커스텀 제목 설정
  })
end

function M.select_a_subdir(root_dir, title, callback)
  require("telescope").extensions.file_browser.file_browser({
    cwd = root_dir,
    hidden = false,
    respect_gitignore = false,
    previewer = false,
    select_buffer = true,
    hide_parent_dir = true,
    only_dirs = true,
    -- files = false, -- 파일 표시 비활성화
    depth = 1, -- 한 번에 한 레벨만 표시
    dir_icon = "📁", -- 디렉토리 아이콘
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local create_note = function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        local relative_path = string.sub(selection.path, #root_dir + 2) -- string.sub -> (a, b) 문자열 a를 index b부터 잘라서 리턴한다.
        callback(relative_path)
      end
      map("i", "<CR>", create_note)
      map("n", "<CR>", create_note)
      return true
    end,
    layout_strategy = "vertical", -- 'horizontal', 'center' 등
    layout_config = {
      width = 0.4,
      height = 0.6,
    },
    sorting_strategy = "descending",
    prompt_title = string.format("🌟 %s 🌟", title), -- 커스텀 제목 설정
  })
end

return M
