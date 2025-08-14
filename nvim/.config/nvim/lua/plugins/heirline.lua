local ViMode = {
	-- get vim current mode, this information will be required by the provider
	-- and the highlight functions, so we compute it only once per component
	-- evaluation and store it as a component attribute
	init = function(self)
		self.mode = vim.fn.mode(1) -- :h mode()
	end,
	-- Now we define some dictionaries to map the output of mode() to the
	-- corresponding string and color. We can put these into `static` to compute
	-- them at initialisation time.
	static = {
		mode_names = { -- change the strings if you like it vvvvverbose!
			n = "N",
			no = "N?",
			nov = "N?",
			noV = "N?",
			["no\22"] = "N?",
			niI = "Ni",
			niR = "Nr",
			niV = "Nv",
			nt = "Nt",
			v = "V",
			vs = "Vs",
			V = "V_",
			Vs = "Vs",
			["\22"] = "^V",
			["\22s"] = "^V",
			s = "S",
			S = "S_",
			["\19"] = "^S",
			i = "I",
			ic = "Ic",
			ix = "Ix",
			R = "R",
			Rc = "Rc",
			Rx = "Rx",
			Rv = "Rv",
			Rvc = "Rv",
			Rvx = "Rv",
			c = "C",
			cv = "Ex",
			r = "...",
			rm = "M",
			["r?"] = "?",
			["!"] = "!",
			t = "T",
		},
		mode_colors = {
			n = "red",
			i = "green",
			v = "cyan",
			V = "cyan",
			["\22"] = "cyan",
			c = "orange",
			s = "purple",
			S = "purple",
			["\19"] = "purple",
			R = "orange",
			r = "orange",
			["!"] = "red",
			t = "red",
		},
	},
	-- We can now access the value of mode() that, by now, would have been
	-- computed by `init()` and use it to index our strings dictionary.
	-- note how `static` fields become just regular attributes once the
	-- component is instantiated.
	-- To be extra meticulous, we can also add some vim statusline syntax to
	-- control the padding and make sure our string is always at least 2
	-- characters long. Plus a nice Icon.
	provider = function(self)
		return " %2(" .. self.mode_names[self.mode] .. "%)"
	end,
	-- Same goes for the highlight. Now the foreground will change according to the current mode.
	hl = function(self)
		local mode = self.mode:sub(1, 1) -- get only the first mode character
		return { fg = self.mode_colors[mode], bold = true }
	end,
	-- Re-evaluate the component only on ModeChanged event!
	-- Also allows the statusline to be re-evaluated when entering operator-pending mode
	update = {
		"ModeChanged",
		pattern = "*:*",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
}

return {
	"rebelot/heirline.nvim",
	enabled = true,
	event = "VeryLazy",
	config = function()
		local conditions = require("heirline.conditions")
		local utils = require("heirline.utils")

		-- 팔레트(현재 colorscheme 색을 재사용)
		local colors = {
			bright_bg = utils.get_highlight("Folded").bg,
			bright_fg = utils.get_highlight("Folded").fg,
			red = utils.get_highlight("DiagnosticError").fg,
			dark_red = utils.get_highlight("DiffDelete").bg,
			green = utils.get_highlight("String").fg,
			blue = utils.get_highlight("Function").fg,
			gray = utils.get_highlight("NonText").fg,
			orange = utils.get_highlight("Constant").fg,
			purple = utils.get_highlight("Statement").fg,
			cyan = utils.get_highlight("Special").fg,
			diag_warn = utils.get_highlight("DiagnosticWarn").fg,
			diag_error = utils.get_highlight("DiagnosticError").fg,
			diag_hint = utils.get_highlight("DiagnosticHint").fg,
			diag_info = utils.get_highlight("DiagnosticInfo").fg,
			git_del = utils.get_highlight("diffDeleted").fg,
			git_add = utils.get_highlight("diffAdded").fg,
			git_change = utils.get_highlight("diffChanged").fg,
		}

		-- 전역 상태라인 배경 투명(선택)
		vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

		-- 공백/정렬 헬퍼
		local Space = { provider = " " }
		local Align = { provider = "%=" }

		--------------------------------------------------------------------------
		-- Git 블록 (gitsigns 연동: 브랜치 + 수치)
		--------------------------------------------------------------------------
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "󰋇",
					[vim.diagnostic.severity.HINT] = "󰌵",
				},
			},
		})
		local Diagnostics = {
			condition = conditions.has_diagnostics,
			-- Example of defining custom LSP diagnostic icons, you can copypaste in your config
			-- Fetching custom diagnostic icons
			-- error_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.ERROR],
			-- warn_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.WARN],
			-- info_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.INFO],
			-- hint_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.HINT],

			-- If you defined custom LSP diagnostics with vim.fn.sign_define(), use this instead
			-- Note defining custom LSP diagnostic this way its deprecated, though
			--static = {
			--    error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
			--    warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
			--    info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
			--    hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
			--},

			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

				self.error_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.ERROR]
				self.warn_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.WARN]
				self.info_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.INFO]
				self.hint_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.HINT]
			end,

			update = { "DiagnosticChanged", "BufEnter" },

			{
				provider = "",
			},
			{
				provider = function(self)
					-- 0 is just another output, we can decide to print it or not!
					if self.errors > 0 then
						return self.error_icon .. " " .. self.errors .. " "
					end
					return ""
				end,
				hl = { fg = colors.diag_error },
			},
			{
				provider = function(self)
					if self.warnings > 0 then
						return self.warn_icon .. " " .. self.warnings .. " "
					end
					return ""
				end,
				hl = { fg = colors.diag_warn },
			},
			{
				provider = function(self)
					if self.info > 0 then
						return self.info_icon .. " " .. self.info .. " "
					end
					return ""
				end,
				hl = { fg = colors.diag_info },
			},
			{
				provider = function(self)
					if self.hints > 0 then
						return self.hint_icon .. " " .. self.hints
					end
					return ""
				end,
				hl = { fg = colors.diag_hint },
			},
			{
				provider = "",
			},
		}
		local Git = {
			condition = conditions.is_git_repo,

			init = function(self)
				self.status_dict = vim.b.gitsigns_status_dict
				self.has_changes = self.status_dict.added ~= 0
					or self.status_dict.removed ~= 0
					or self.status_dict.changed ~= 0
			end,

			hl = { fg = colors.orange },

			{ -- git branch name
				provider = function(self)
					return " " .. self.status_dict.head
				end,
				hl = { bold = true },
			},
			-- You could handle delimiters, icons and counts similar to Diagnostics
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = "(",
			},
			{
				provider = function(self)
					local count = self.status_dict.added or 0
					return count > 0 and ("+" .. count)
				end,
				hl = { fg = colors.git_add },
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and ("-" .. count)
				end,
				hl = { fg = colors.git_del },
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and ("~" .. count)
				end,
				hl = { fg = colors.git_change },
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = ")",
			},
		}
		local WorkDir = {
			init = function(self)
				self.icon = "  "
				local cwd = vim.fn.getcwd(0)
				self.cwd = vim.fn.fnamemodify(cwd, "~")
				self.fname = vim.api.nvim_buf_get_name(0)
				self.file_dir = (self.fname ~= "" and vim.fn.fnamemodify(self.fname, ":h")) or nil
				self.file_dir = (self.file_dir == nil and self.cwd) or self.file_dir
				-- print("kk", self.file_dir)
			end,
			hl = { fg = "blue", bold = true },
			flexible = 1,
			{
				-- evaluates to the full-lenth path
				provider = function(self)
					-- print("1" .. self.cwd)
					local path = require("custom.root").get_root_detail(self.file_dir)
					-- vim.notify("x :", path.shorten_relative)
					-- print(path.root_path, path.file_path)
					return self.icon .. path.root_name .. " * " .. path.shorten_relative .. " *"
				end,
			},
			{
				-- evaluates to the shortened path
				provider = function(self)
					-- print("2")
					local path = require("custom.root").get_root_detail(self.cwd)
					return self.icon .. path.shorten_relative .. " "
				end,
			},
			{
				-- evaluates to "", hiding the component
				provider = "",
			},
		}

		--------------------------------------------------------------------------
		-- 최소 예시 StatusLine 조합 (원하는 컴포넌트를 좌/우에 추가하세요)
		--------------------------------------------------------------------------
		local FileNameBlock = {
			-- let's first set up some attributes needed by this component and it's children
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(0)
			end,
		}

		local FileIcon = {
			init = function(self)
				local has, devicons = pcall(require, "nvim-web-devicons")
				local filename = self.filename or ""
				if not has or filename == "" then
					-- 폴백 아이콘/색
					self.icon = ""
					self.icon_color = utils.get_highlight("Directory").fg
					return
				end
				-- local filename = self.filename
				local extension = vim.fn.fnamemodify(filename, ":e")
				self.icon, self.icon_color =
					require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
			end,
			provider = function(self)
				return self.icon and (self.icon .. " ")
			end,
			hl = function(self)
				return { fg = self.icon_color }
			end,
		}
		local File = {
			provider = function()
				local name = vim.fn.expand("%:t")
				return (name == "" and "[No Name]" or name)
			end,
			hl = { bg = nil },
		}

		FileNameBlock = utils.insert(
			FileNameBlock,
			FileIcon,
			{ provider = "%<" } -- this means that the statusline is cut here when there's not enough space
		)
		local FileSize = {
			provider = function()
				-- stackoverflow, compute human readable file size
				local suffix = { "b", "k", "M", "G", "T", "P", "E" }
				local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
				fsize = (fsize < 0 and 0) or fsize
				if fsize < 1024 then
					return fsize .. suffix[1]
				end
				local i = math.floor((math.log(fsize) / math.log(1024)))
				return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
			end,
		}
		-- local Ruler = { provider = "%7(%l:%c%)", hl = { bg = nil } }
		local Ruler = {
			-- %l = current line number
			-- %L = number of lines in the buffer
			-- %c = column number
			-- %P = percentage through file of displayed window
			provider = "%7(%l/%3L%):%2c %P",
		}
		local ScrollBar = {
			static = {
				sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
				-- Another variant, because the more choice the better.
				-- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
			},
			provider = function(self)
				local curr_line = vim.api.nvim_win_get_cursor(0)[1]
				local lines = vim.api.nvim_buf_line_count(0)
				local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
				return string.rep(self.sbar[i], 2)
			end,
			hl = { fg = "blue", bg = "bright_bg" },
		}

		local StatusLine = {
			Space,
			ViMode,
			Space,
			Git,
			Space,
			Diagnostics,
			Space,
			WorkDir,
			Space,
			File,
			Space,
			FileNameBlock,
			Space,
			FileSize,
			Space,
			Align,
			Ruler,
			Space,
			ScrollBar,
		}

		require("heirline").setup({ statusline = StatusLine, opts = { colors = colors } })
	end,
}
