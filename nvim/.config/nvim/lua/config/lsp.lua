-- vim.lsp.enable("lua_ls")
-- vim.lsp.enable("pyright")
-- vim.lsp.enable("pylsp_rope")
-- vim.lsp.enable("nil_ls")
-- vim.lsp.enable("ts_ls")
-- vim.lsp.enable("html")
-- vim.lsp.enable("cssls")
-- vim.lsp.enable("eslint")

vim.diagnostic.config({
	float = { border = "rounded" },
})

local orig = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "rounded"
	return orig(contents, syntax, opts, ...)
end

