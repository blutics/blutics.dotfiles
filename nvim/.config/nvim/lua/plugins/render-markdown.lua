-- 와! markdown 포멧lsp를 prettier에서 dprint로 바꾸니까.
-- 굉장히 쾌적해지고 여기서 render-markdown을 적용시키니 굉장히 이쁘게 나오네....
return {
	"MeanderingProgrammer/render-markdown.nvim",
	-- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
	-- enabled = false,
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	config = function()
		local p = function(target, before, after)
			if before == nil then
				before = ""
			end
			if after == nil then
				after = ""
			end
			return before .. target .. after
		end
		local bullet_icons = { "●", "○", "◆", "◇" }
		local padded_bullet_icons = {}
		for i, value in ipairs(bullet_icons) do
			table.insert(padded_bullet_icons, p(value, "", "   "))
		end
		require("render-markdown").setup({
			render_modes = { "n", "i" },
			heading = {
				enabled = true,
				sign = true,
				border = true,
				left_margin = 0,
				left_pad = 2,
				icons = {
					"󰬺. ",
					"󰬻. ",
					"󰬼. ",
					"󰬽. ",
					"󰬾. ",
					"󰬿. ",
				},
				signs = {
					"󰫵",
				},
			},
			paragraph = {
				enabled = true,
				render_modes = false,
			},
			indent = {
				enabled = true, -- 다른 설정 바꿀 것 없이 indent enabled만 false로 설정하면 모든 indent가 싹 사라진다.
				render_modes = false,
				skip_heading = true,
				skip_level = 0,
				per_level = 4,
			},
			bullet = {
				enbled = true,
				ordered_icons = function(ctx)
					local value = vim.trim(ctx.value)
					local index = tonumber(value:sub(1, #value - 1))
					return ("%d.  "):format(index > 1 and index or ctx.index)
				end,
				icons = padded_bullet_icons,
				right_pad = 2,
			},
			checkbox = {
				enabled = true,
				render_modes = false,
				bullet = false,
				right_pad = 2,
				unchecked = {
					icon = "✘ ",
					highlight = "RenderMarkdownUnchecked",
				},
				checked = {
					icon = "✔ ",
					scope_highlight = "@markup.strikethrough",
					highlight = "RenderMarkdownChecked",
				},
				custom = { todo = { rendered = "◯ " } },
			},
			quote = {
				enabled = true,
				render_modes = false,
				icon = "▋",
				left_pad = 3,
			},
		})
		-- 원하는 색으로
		-- 에메랄드 "#67C090"|연한주황색 "#FAA533"|노란색 "#FFD93D"|연보라 "#C5B0CD"
		-- 연보라색이 가장 적절해보인다.
		-- 다른 색도 이쁘지만 이 색은 다른 텍스트와 구분되면서도
		-- 헤더들보다 덜 눈에 띄어야한다.
		-- 그러면서도 이쁜 색이어야한다.
		-- 이러한 색으로 연보라가 딱인듯하다.

		local c = "#C5B0CD"
		vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = c, bold = true })
		vim.api.nvim_set_hl(0, "@markup.list.unordered.markdown", { fg = c })
		vim.api.nvim_set_hl(0, "@markup.list.markdown", { fg = c })
		vim.api.nvim_set_hl(0, "@punctuation.special.markdown", { fg = c })
	end,
}
