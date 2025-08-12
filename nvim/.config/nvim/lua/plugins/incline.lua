return {
	"b0o/incline.nvim",
	event = "VeryLazy",
	config = function()
		-- catppuccin 팔레트가 있으면 사용, 없으면 기본값
		local palette = (function()
			local ok, cat = pcall(require, "catppuccin.palettes")
			if ok then
				local p = cat.get_palette("mocha")
				return {
					bg_active = p.base, -- #1e1e2e
					bg_inactive = p.mantle, -- #181825
					fg_active = p.text, -- #cdd6f4
					fg_inactive = p.overlay2, -- #6c7086
					accent = p.pink, -- #f5c2e7
				}
			else
				return {
					bg_active = "#1e1e2e",
					bg_inactive = "#181825",
					fg_active = "#cdd6f4",
					fg_inactive = "#6c7086",
					accent = "#f38ba8",
				}
			end
		end)()

		require("incline").setup({
			debounce_threshold = { falling = 50, rising = 10 },
			hide = {
				cursorline = false,
				focused_win = false,
				only_win = false,
			},
			window = {
				margin = { vertical = 0, horizontal = 1 },
				padding = 1,
				placement = { horizontal = "right", vertical = "top" },
				winhighlight = {
					Normal = "InclineNormal",
					NormalNC = "InclineNormalNC",
				},
				zindex = 60,
			},
			highlight = {
				groups = {
					InclineNormal = { guibg = palette.bg_active, guifg = palette.fg_active, gui = "bold" },
					InclineNormalNC = { guibg = palette.bg_inactive, guifg = palette.fg_inactive },
				},
			},
			render = function(props)
				local buf = props.buf
				local name = vim.api.nvim_buf_get_name(buf)
				local filename = (name == "" and "[No Name]") or vim.fn.fnamemodify(name, ":t")
				local modified = vim.bo[buf].modified and "⭕ " or "   "
				local readonly = (vim.bo[buf].readonly or not vim.bo[buf].modifiable) and " " or ""
				local icon, icon_hl = require("nvim-web-devicons").get_icon(filename, nil, { default = true })
				local color = props.focused and "#00ff00" or "#888888"
				return {
					{ modified .. (icon or "") .. " ", group = icon_hl or "Normal" },
					{ filename, guifg = color, gui = "bold" },
					{ readonly .. "  " },
				}
			end,
		})
	end,
}
