-- plugins/zk.lua
return {
	"zk-org/zk-nvim",
	enabled = true,
	ft = "markdown",
	config = function()
		require("zk").setup({
			-- Telescope/fzf 등 쓰면 지정 가능. 없으면 기본 selector 사용
			picker = "telescope",
			lsp = {
				-- zk LSP는 zk CLI가 있으면 자동으로 동작
				config = {
					name = "zk",
					cmd = { "zk", "lsp" },
					filetypes = { "markdown" },
				},
				auto_attach = {
					enabled = true, -- 노트북 내부 버퍼에 자동 부착
				},
			},
		})
		local opts = { noremap = true, silent = false }
		vim.keymap.set("n", "<leader>zn", function()
			require("custom.zk_new_dir_telescope").new_in_dir({})
		end, { desc = "ZkNew in picked directory (Telescope)" })
		vim.api.nvim_set_keymap("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
		vim.api.nvim_set_keymap("n", "<leader>zO", "<Cmd>ZkNotes { hrefs = {'00-inbox'}, sort = { 'modified' } }<CR>", opts)
		-- Open notes associated with the selected tags.
		vim.api.nvim_set_keymap("n", "<leader>zt", "<Cmd>ZkTags<CR>", opts)
		vim.api.nvim_set_keymap("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", opts)
		-- Search for the notes matching a given query.
		vim.api.nvim_set_keymap(
			"n",
			"<leader>zf",
			"<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
			opts
		)
		vim.keymap.set("n", "<leader>zc", function()
			local root = vim.fs.root(0, { ".zk" }) or vim.loop.cwd()
			local cfg = root .. "/.zk/config.toml"
			vim.fn.mkdir(root .. "/.zk", "p")
			if vim.fn.filereadable(cfg) == 0 then
				vim.fn.writefile({ "# zk config", "" }, cfg)
			end
			vim.cmd("edit " .. vim.fn.fnameescape(cfg))
		end, { desc = "Open .zk/config.toml" })
	end,
}
