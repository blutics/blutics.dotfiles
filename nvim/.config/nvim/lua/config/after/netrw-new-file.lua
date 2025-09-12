vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		local join = (vim.fs and vim.fs.joinpath)
			or function(...)
				return table.concat({ ... }, package.config:sub(1, 1))
			end

		vim.keymap.set("n", "g%", function()
			local name = vim.fn.input("New file/path: ")
			if name == "" then
				return
			end

			local dir = vim.b.netrw_curdir or vim.fn.expand("%:p:h")
			local path = join(dir, name)

			-- 상위 폴더 준비
			local parent = vim.fn.fnamemodify(path, ":h")
			if vim.fn.isdirectory(parent) == 0 then
				vim.fn.mkdir(parent, "p")
			end

			-- 파일만 생성(열지 않음)
			if vim.fn.filereadable(path) == 0 and vim.fn.isdirectory(path) == 0 then
				vim.fn.writefile({}, path)
			else
				vim.notify("exists: " .. path, vim.log.levels.WARN)
				return
			end

			-- ★ 핵심: ‘.’ 대신 netrw의 현재 디렉터리로 다시 연다
      local dir_esc = vim.fn.fnameescape(dir)
			vim.cmd("keepjumps edit " .. dir_esc)
		end, { buffer = true, desc = "Create file (no open) & reopen netrw at current dir" })
	end,
})
