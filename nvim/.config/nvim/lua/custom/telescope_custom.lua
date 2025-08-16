local M = {}

local custom_common = require("custom.common")

function M.custom_telescope_maker()
  -- 디렉토리를 선택하고 그 아래에 파일 혹은 디렉토리를 만든다.
  custom_common.get_project_directories(function(path)
    vim.ui.input({
      prompt = "🔥 Enter file or directory name: ",
    }, function(input)
      if input then
        local is_directory = input:sub(-1) == "/"
        if is_directory then
          -- 디렉토리 생성 (마지막 '/' 제거)
          local dir_path = input:sub(1, -2)
          local escaped = vim.fn.fnameescape(dir_path)
          local fullpath = path .. "/" .. escaped
          -- print("Created directory: " .. fullpath)
          vim.fn.mkdir(fullpath, "p")
        else
          -- print("Created File: " .. input)
          vim.cmd("edit " .. path .. "/" .. vim.fn.fnameescape(input))
        end
      end
    end)
  end)
end

function M.custom_telescope_workspace() end

function M.custom_show_current_directory()
  local global_cwd = vim.fn.getcwd(-1) -- 전역 (-1)
  local tab_cwd = vim.fn.getcwd(-1, 0) -- 현재 탭
  local win_cwd = vim.fn.getcwd()     -- 현재 창

  -- 각 경로를 프로젝트 이름만 표시하도록 변환
  local function get_project_name(path)
    return vim.fn.fnamemodify(path, ":t")
  end

  local msg = string.format(
    "Global(cd): %s\nTab(tcd): %s\nWindow(lcd): %s",
    get_project_name(global_cwd),
    get_project_name(tab_cwd),
    get_project_name(win_cwd)
  )

  vim.notify(msg, vim.log.levels.INFO, {
    title = "Current Working Directories",
    timeout = 3000, -- 3초간 표시
  })
end

function M.custom_telescope_notification()
  require("telescope").extensions.notify.notify({
    layout_strategy = "vertical",
    layout_config = {
      width = 0.6,
      preview_height = 0.6,
    },
  })
end

function M.custom_telescope_buffer()
  require("telescope.builtin").buffers({
    layout_strategy = "vertical", -- 'horizontal', 'center' 등
    layout_config = {
      width = 0.4,
      height = 0.6,
    },
    sorting_strategy = "descending",
    prompt_title = "🌟 Buffers 🌟", -- 커스텀 제목 설정
  })
end

function M.custom_telescope_command_history()
  require("telescope.builtin").command_history({
    layout_strategy = "vertical", -- 'horizontal', 'center' 등
    layout_config = {
      width = 0.4,
      height = 0.8,
    },
    sorting_strategy = "descending",
    prompt_title = "🌟 Command History 🌟", -- 커스텀 제목 설정
  })
end

function M.custom_telescope_oldfiles()
  require("telescope.builtin").oldfiles({
    layout_strategy = "vertical", -- 'horizontal', 'center' 등
    layout_config = {
      width = 0.4,
      height = 0.6,
    },
    sorting_strategy = "descending",
    prompt_title = "🌟 Recently 🌟", -- 커스텀 제목 설정
  })
end

function M.custom_telescope_diagnostics()
  require("telescope.builtin").diagnostics({
    bufnr = 0,
    layout_strategy = "vertical",
  })
end

function M.custom_telescope_projects()
  require("telescope").extensions.projects.projects({
    layout_strategy = "vertical", -- 'horizontal', 'center' 등
    layout_config = {
      width = 0.4,
      height = 0.6,
    },
    sorting_strategy = "descending",
    prompt_title = "🌟 My Projects 🌟", -- 커스텀 제목 설정
    previewer = false, -- 미리보기 비활성화
    -- winblend = 15, -- 창 투명도 조정
  })
end

function M.custom_telescope_jumplist()
  require("telescope.builtin").jumplist({
    show_line = true,
    fname_width = 50,
    include_current_position = true,
  })
end

return M
