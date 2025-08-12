return {
	"gelguy/wilder.nvim",
	config = function()
		-- config goes here
		--

		local wilder = require("wilder")
		wilder.setup({ modes = { ":", "/", "?" } })
		wilder.set_option(
			"renderer",
			wilder.popupmenu_renderer({
				pumblend = 20,
			})
		)
	end,
}
