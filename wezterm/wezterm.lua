local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- wezterm.log_info("config run")
-- 1) config 디렉터리 경로 확보
-- wezterm.config -> .wezterm.lua가 있는 위치!
-- local CONFIG_DIR = wezterm.config_dir or (debug.getinfo(1, "S").source:match("^@(.+)[/\\].-$") or ".")
local CONFIG_DIR = _G.WEZTERM_ROOT

-- 2) 모듈 require 경로 추가
-- require을 사용할 때 검색 경로 목록을 추가하는 작업
package.path = table.concat({
	package.path,
	CONFIG_DIR .. "/lua/?.lua",
	CONFIG_DIR .. "/lua/?/init.lua",
	CONFIG_DIR .. "/colors/?.lua",
}, ";")

-- 3) 공통 모듈 조립
require("appearance")(config)
require("background")(config)

-- (선택) 키맵 모듈
local ok_keys, keys = pcall(require, "keys")
if ok_keys then
	keys(config)
end

-- 4) 플랫폼별 옵션
local is_windows = wezterm.target_triple:find("windows") ~= nil
if is_windows then
	require("platform.windows")(config)
else
	require("platform.linux")(config)
end

-- 5) 호스트별 오버레이(있을 때만)
-- local ok_local, local_overlay = pcall(require, "local")
-- if ok_local and type(local_overlay) == "function" then
-- 	local_overlay(config)
-- end

return config
