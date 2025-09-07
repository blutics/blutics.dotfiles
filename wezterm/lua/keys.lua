local wezterm = require("wezterm")

return function(config)
	-- 기본 단축키는 유지하고 일부만 추가/수정하고 싶다면:
	config.disable_default_key_bindings = false

	config.keys = config.keys or {}
	-- 예시: Ctrl+Shift+R = 설정 재로드
  -- 재로드는 내장기능으로 단순한 예시
	table.insert(config.keys, {
		key = "R",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ReloadConfiguration,
	})
end
