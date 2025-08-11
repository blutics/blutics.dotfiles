return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 999,
		opts = {},
		config = function()
			require("tokyonight").setup({
				style = "moon",
				transparent = false,
				terminal_color = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
				},
			})

			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}
