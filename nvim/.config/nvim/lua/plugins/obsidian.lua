return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  enabled = false,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    ui = { enable = false },
    note_id_func = function(title)
      -- 타임스탬프 생성: YYMMDDHHMMSS.sss
      local timestamp = tostring(os.time())
      -- 4자리 알파벳 대문자 해시 생성
      local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      local hash = ""
      for i = 1, 4 do
        local random_index = math.random(1, #chars)
        hash = hash .. string.sub(chars, random_index, random_index)
      end

      if title ~= nil and title ~= "" then
        -- 한글 허용 버전
        local cleaned_title = title:gsub("%s+", "_"):gsub("[^%w_ㄱ-ㅎ가-힣]", "")
        return string.format("%s-%s-%s", timestamp, hash, cleaned_title)
      else
        return string.format("%s-%s", timestamp, hash)
      end
    end,
    templates = {
      folder = "templates",
      substitutions = {
        -- aliases = "\n  - "
      },
    },
    workspaces = {
      {
        name = "personal",
        path = "/mnt/d/obsidian/personal_vault/",
        templates = {
          subdir = "templates",
          default_template = "default", -- 기본 템플릿 파일 이름 (확장자 제외)
        },
      },
      {
        name = "tech",
        path = "/mnt/d/obsidian/tech_vault/",
      },
    },

    notes_subdir = "notes/inbox",
    daily_notes = {
      folder = "notes/dailies",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily-notes" },
      template = nil,
    },
    completion = {
      nvim_cmp = true,
    },

    -- see below for full list of options 👇
  },
}
