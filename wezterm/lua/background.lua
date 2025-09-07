local wezterm = require("wezterm")

return function(config)
	local CONFIG_DIR = wezterm.config_dir
	local bg = CONFIG_DIR .. "/assets/purple_3.jpg"
	local blur = CONFIG_DIR .. "/assets/blurred_3.jpg"

	config.background = {
		{
			source = { File = blur },
			hsb = { hue = 1.0, saturation = 1.02, brightness = 0.25 },
		},
		{
			source = { File = bg },
			width = "100%",
			height = "100%",
			opacity = 0.05,
		},
		{
			source = { Color = "#000000" },
			width = "100%",
			height = "100%",
			opacity = 0.35,
		},
	}
end
