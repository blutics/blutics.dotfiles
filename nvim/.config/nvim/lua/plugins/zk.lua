-- ★ .zk가 있는 프로젝트에서만 zk LSP attach
local function zk_root_for(bufnr)
	bufnr = bufnr or 0
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == nil or name == "" then
		return nil
	end
	local start = vim.fs.dirname(name)
	-- 현재 디렉터리부터 위로 .zk 디렉터리를 찾음
	local root = vim.fs.root(start, { ".zk" })
	if not root then
		return nil
	end
	-- .zk 실제 존재 확인(안전)
	if vim.fn.isdirectory(root .. "/.zk") ~= 1 then
		return nil
	end
	return root
end

local function zk_try_attach(bufnr)
	local root = zk_root_for(bufnr)

  vim.print("--> "..root)
	if not root then
		return
	end
	if vim.fn.executable("zk") ~= 1 then
		vim.notify("zk CLI not found in PATH", vim.log.levels.WARN)
		return
	end
	-- 이미 붙어있으면 중복 attach 방지
	for _, client in pairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
		if client.name == "zk" then
			return
		end
	end
	vim.lsp.start({
		name = "zk",
		cmd = { "zk", "lsp" },
		root_dir = root,
		single_file_support = false,
		filetypes = { "markdown" },
	})
end
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
					enabled = false, -- 노트북 내부 버퍼에 자동 부착
				},
			},
		})
		vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
			group = vim.api.nvim_create_augroup("ZkAttachWhenHasDotZk", { clear = true }),
			pattern = "*.md",
			callback = function(args)
				zk_try_attach(args.buf)
			end,
		})
		local opts = { noremap = true, silent = false }
		vim.keymap.set("n", "<leader>zn", function()
			require("custom.zk_new_dir_telescope").new_in_dir({})
		end, { desc = "ZkNew in picked directory (Telescope)" })
		vim.api.nvim_set_keymap("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>zO",
			"<Cmd>ZkNotes { hrefs = {'00-inbox'}, sort = { 'modified' } }<CR>",
			opts
		)
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
