local wezterm = require("wezterm")

return function(config)
	config.initial_cols = 120
	config.initial_rows = 28

	config.font_size = 13
	config.line_height = 1
	config.font = wezterm.font("D2CodingLigature Nerd Font Mono")

	config.enable_tab_bar = false
	config.window_decorations = "RESIZE"

	config.max_fps = 120
	config.animation_fps = 30
	config.prefer_egl = true

	config.window_padding = { left = 10, right = 10, top = 0, bottom = 0 }

	-- (선택) 컬러 스킴 로드: colors/my_dark.lua 가 있으면
	local ok_scheme, my_dark = pcall(require, "my_dark")
	if ok_scheme and type(my_dark) == "table" then
		config.colors = my_dark
	end
end
