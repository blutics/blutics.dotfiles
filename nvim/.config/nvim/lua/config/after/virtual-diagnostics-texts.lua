vim.diagnostic.config({
	virtual_text = {
		spacing = 2,
		format = function(d)
			local src = d.source or "?"
			-- ruff라면 규칙코드(F401 등)도 함께
			local code = (type(d.code) == "string" or type(d.code) == "number") and ("(" .. d.code .. ")") or ""
			return string.format("[%s]%s %s", src, code, d.message)
		end,
	},
	float = {
		border = "rounded",
		format = function(d)
			local src = d.source or "?"
			local code = (type(d.code) == "string" or type(d.code) == "number") and (" (" .. d.code .. ")") or ""
			return string.format("[%s]%s %s", src, code, d.message)
		end,
	},
})

-- ~/.config/nvim/lua/diagnostic-toggle.lua (어디든 OK)
local saved_vtext = vim.diagnostic.config().virtual_text -- bool 또는 table일 수 있음
local function is_vtext_on()
	local vt = vim.diagnostic.config().virtual_text
	return vt ~= false -- table이든 true든 "켜짐"으로 간주
end

local function toggle_virtual_text_global()
	if is_vtext_on() then
		vim.diagnostic.config({ virtual_text = false })
		vim.notify("Virtual text: OFF", vim.log.levels.INFO)
	else
		vim.diagnostic.config({ virtual_text = saved_vtext == nil and true or saved_vtext })
		vim.notify("Virtual text: ON", vim.log.levels.INFO)
	end
end

toggle_virtual_text_global()
vim.api.nvim_create_user_command("DiagVTextToggle", toggle_virtual_text_global, {})
vim.keymap.set("n", "<leader>jj", toggle_virtual_text_global, { desc = "Toggle diagnostics virtual text (global)" })
vim.keymap.set("n", "<leader>e", function()
	vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
end, { desc = "Show diagnostic (with source)" })
