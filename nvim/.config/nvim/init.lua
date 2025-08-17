require("config.options") -- 기본 옵션 및 설정

-- 플러그인 등록 후
-- Vim에 대한 설정 혹은 플러그인에 대한 추가 설정


require("config.autocmds")
require("config.commands")


require("config.keymaps") -- 키맵 등록

require("config.lazy") -- 플러그인 등록
require("config.lsp")


require("config.after.options")

