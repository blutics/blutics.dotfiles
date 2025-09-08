return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "1.*",
	opts = {
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = { preset = "default" },
		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = {
				auto_show = true,
				window = {
					border = "single",
				},
			},
			menu = { border = "rounded" },
		},
		signature = {
			enabled = true,
			window = { border = "single" },
		},

		sources = {
			default = { "lsp", "path", "snippets", },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
	init = function()
		local ok, cmp = pcall(require, "blink.cmp")

		-- 문서: <leader>gK
		vim.keymap.set({ "i", "n" }, "<leader>gK", function()
			if ok and vim.fn.mode() == "i" then
				print("-----")
				cmp.show_documentation() -- blink 문서창
			else
				vim.lsp.buf.hover() -- LSP hover
			end
		end, { desc = "Docs (blink in insert; otherwise LSP)" })

		-- 시그니처: <leader>gk
		vim.keymap.set({ "i", "n" }, "<leader>gk", function()
			if ok and vim.fn.mode() == "i" then
				cmp.show_signature() -- blink 시그니처
			else
				vim.lsp.buf.signature_help() -- LSP signature
			end
		end, { desc = "Signature (blink in insert; otherwise LSP)" })
	end,
}
