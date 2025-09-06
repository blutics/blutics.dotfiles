-- 와! markdown 포멧lsp를 prettier에서 dprint로 바꾸니까.
-- 굉장히 쾌적해지고 여기서 render-markdown을 적용시키니 굉장히 이쁘게 나오네....
return {
	"MeanderingProgrammer/render-markdown.nvim",
	-- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
	-- enabled = false,
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	config = function()
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
				icons = { "●   ", "○   ", "◆   ", "◇   " },
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
        icon = '▋',
        left_pad = 3,
      }
		})
		local c = "#67C090" -- 원하는 색으로
		vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = c, bold = true })
		pcall(vim.api.nvim_set_hl, 0, "@markup.list.unordered.markdown", { fg = c })
		pcall(vim.api.nvim_set_hl, 0, "@markup.list.markdown", { fg = c })
		pcall(vim.api.nvim_set_hl, 0, "@punctuation.special.markdown", { fg = c })
	end,
}
