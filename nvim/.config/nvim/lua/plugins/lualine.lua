local make_lualine_c = function()
  return {
    {
      function()
        local function find_git_root()
          local git_cmd = io.popen("git rev-parse --show-toplevel 2> /dev/null")
          if git_cmd == nil then
            return nil
          end
          local git_root = git_cmd:read("*l")
          git_cmd:close()
          return git_root
        end

        local function get_relative_path()
          local current_file = vim.fn.expand("%:p")
          if current_file == "" then
            return ""
          end

          local git_root = find_git_root()
          if git_root then
            -- Git 루트로부터의 상대 경로 계산
            local relative_path = vim.fn.fnamemodify(current_file, ":~:.")
            local project_name = vim.fn.fnamemodify(git_root, ":t")
            -- 프로젝트 이름과 상대 경로 결합
            return string.format(" %s ⟫ %s", project_name, relative_path)
          else
            -- Git 루트가 없을 경우 현재 디렉토리 기준
            local cwd = vim.fn.getcwd()
            local cwd_name = vim.fn.fnamemodify(cwd, ":t")
            local relative_path = vim.fn.fnamemodify(current_file, ":~:.")
            return string.format(" %s ⟫ %s", cwd_name, relative_path)
          end
        end

        return get_relative_path()
      end,
      color = { fg = "#a9a1e1" },
    },
  }
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- 아이콘 플러그인
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "auto", -- 테마를 자동으로 설정
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {}, -- 비활성화할 파일 유형
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = make_lualine_c(),

        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    })
  end,
}
