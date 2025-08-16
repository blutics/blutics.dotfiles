-- ~/.config/nvim/lua/plugins.lua 등 lazy.nvim 설정 파일에서:
local buffer_delete_force = function(prompt_bufnr)
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local multi_selections = current_picker:get_multi_selection()

  if next(multi_selections) then
    for _, selection in ipairs(multi_selections) do
      vim.api.nvim_buf_delete(selection.bufnr, { force = true })
    end
  else
    local selection = action_state.get_selected_entry()
    vim.api.nvim_buf_delete(selection.bufnr, { force = true })
  end
  -- Telescope 창 닫기
  actions.close(prompt_bufnr)

  -- 버퍼 목록 다시 열기
  vim.schedule(function()
    local tc = require("custom.telescope_custom")
    tc.custom_telescope_buffer()
  end)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.4", -- 특정 버전 사용
    lazy = false,
    priority = 700,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "j-hui/fidget.nvim",
      { "ahmedkhalf/project.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = function() return vim.fn.executable("make") == 1 end, },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-tree/nvim-web-devicons" },
      { "folke/trouble.nvim" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<C-d>"] = buffer_delete_force,
              },

              n = {
                ["<C-d>"] = buffer_delete_force,
              },
            },
          },
        },
        defaults = {
          file_ignore_patterns = {
            "node_modules/",
            "__pycache__",
          },
          prompt_prefix = " 🔥 ",
          selection_caret = "» ",

          -- 스피너 설정 (내부 작업용)
          spinner = {
            frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
            interval = 80,
          },
          mappings = {
            n = {
              ["<Tab>"] = actions.toggle_selection,
            }

          }
        },
        extensions = {
          projects = {
            layout_strategy = "horizontal",
            layout_config = {
              width = 0.8,  -- 전체 창의 80%
              height = 0.8, -- 전체 창의 80%
              preview_width = 0.6, -- 프리뷰 창이 차지하는 비율
              prompt_position = "top",
            },
            theme = "dropdown", -- dropdown 테마 사용
            hidden_files = false, -- 숨김 파일 표시 여부
          },
          noice = {
            -- 기본 테마 수정
            theme = "ivy", -- dropdown, cursor, ivy 중 선택

            -- 결과 포맷 수정
            format = {
              -- 각 항목의 포맷 지정
              entry = function(entry)
                local time = os.date("%H:%M:%S", entry.value.timestamp / 1000)
                local level = entry.value.level
                local message = entry.value.message

                -- 레벨별 아이콘 설정
                local icons = {
                  ERROR = " ",
                  WARN = " ",
                  INFO = " ",
                  DEBUG = " ",
                  TRACE = "✎ ",
                }

                -- 포맷팅된 문자열 반환
                return string.format(
                  "%s %s %s %s",
                  time, -- 시간
                  icons[level] or "󰋼 ", -- 레벨 아이콘
                  level:sub(1, 4), -- 레벨 (4글자로 제한)
                  message -- 메시지
                )
              end,
            },

            -- 정렬 설정
            sort = {
              ascending = false, -- 최신 항목이 위로 오도록
            },

            -- 결과창 레이아웃
            layout_config = {
              width = 0.8,  -- 창 너비
              height = 0.6, -- 창 높이
              preview_width = 0.5, -- 미리보기 창 너비
            },
          },
        },
      })

      -- telescope.load_extension("fzf")telescope
      telescope.load_extension("projects")
      telescope.load_extension("fidget")
      -- telescope.load_extension("noice")
    end,
  },
  {
    "LukasPietzschmann/telescope-tabs",
    config = function()
      require("telescope").load_extension("telescope-tabs")
      require("telescope-tabs").setup({
        -- Your custom config :^)
      })
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
}

-- Telescope.Import
