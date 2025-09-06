local M = {}

function M.make_custom_float_setting()
	return {
		max_width = 0,
		win_options = {
			winblend = 0,
			cursorline = true,
		},
		margin = {
			top = 2,
			right = 3,
			bottom = 2,
			left = 3,
		},
		override = function()
			-- 화면 크기의 80%를 사용
			local width = math.floor(vim.o.columns * 0.5)
			local height = math.floor(vim.o.lines * 0.6)

			-- 중앙 정렬을 위한 위치 계산
			local row = math.floor((vim.o.lines - height) / 2)
			local col = math.floor((vim.o.columns - width) / 2)
			vim.api.nvim_create_autocmd("WinEnter", {
				callback = function()
					vim.wo.foldcolumn = "1"
					vim.wo.signcolumn = "no"
					vim.wo.numberwidth = 3
				end,
				once = true,
			})

			return {
				border = "rounded",
				row = row,
				col = col,
				width = width,
				height = height,
				relative = "editor",
				style = "minimal",
			}
		end,
	}
end

return M
