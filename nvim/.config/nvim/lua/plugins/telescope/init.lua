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
    -- version = "0.1.4", -- 특정 버전 사용
    lazy = false,
    priority = 700,
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- { "ahmedkhalf/project.nvim" },
      -- {
      --   "nvim-telescope/telescope-fzf-native.nvim",
      --   puild = "make",
      -- },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-tree/nvim-web-devicons" },
      { "folke/trouble.nvim" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")

      -- 텔레스콥의 테마색이 에디터의 테마와 같게
      local function link(name, target)
        vim.api.nvim_set_hl(0, name, { link = target })
      end
      local function match_telescope_to(group) -- "Normal" = 편집창 배경, "NormalFloat" = 플로팅 배경
        for _, g in ipairs({
          "TelescopeNormal",
          "TelescopeBorder",
          "TelescopePromptNormal",
          "TelescopePromptBorder",
          "TelescopeResultsNormal",
          "TelescopeResultsBorder",
          "TelescopePreviewNormal",
          "TelescopePreviewBorder",
          "TelescopePromptTitle",
          "TelescopeResultsTitle",
          "TelescopePreviewTitle",
        }) do
          link(g, group)
        end
      end

      -- 편집창 배경과 동일하게
      match_telescope_to("Normal")
      -- 플로팅 배경과 동일하게 하려면 위 줄을 주석 처리하고 아래 줄 사용
      match_telescope_to("NormalFloat")

      -- colorscheme이 바뀌어도 유지
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          match_telescope_to("Normal")
        end, -- 필요시 "NormalFloat"로
      })
      -- 색상정의 마지막
      --
      -- vim.keymap.set("n", "<leader>ff", function()
      --   builtin.find_files(themes.get_dropdown({
      --     previewer = false,
      --     layout_config = { height = 30 },
      --   }))
      -- end)

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
          -- winblend = 10,
          file_ignore_patterns = {
            "node_modules/",
            "__pycache__",
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--ignore-case", -- ← 항상 대소문자 무시 (대신 "--smart-case"도 선택 가능)
          },

          -- 스피너 설정 (내부 작업용)
          spinner = {
            frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
            interval = 80,
          },
          mappings = {
            n = {
              ["<Tab>"] = actions.toggle_selection,
            },
          },
        },
        extensions = {
          fzf = {
            -- fuzzy = false,
            override_file_sorter = true,
            override_generic_sorter = true,
            case_mode = "smart_case",
          },
          -- projects = {
          --   layout_strategy = "horizontal",
          --   layout_config = {
          --     width = 0.8,  -- 전체 창의 80%
          --     height = 0.8, -- 전체 창의 80%
          --     preview_width = 0.6, -- 프리뷰 창이 차지하는 비율
          --     prompt_position = "top",
          --   },
          --   theme = "dropdown", -- dropdown 테마 사용
          --   hidden_files = false, -- 숨김 파일 표시 여부
          -- },
        },
      })

      -- telescope.load_extension("projects")
      -- telescope.load_extension("fzf")
      -- telescope.load_extension("fidget")
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
