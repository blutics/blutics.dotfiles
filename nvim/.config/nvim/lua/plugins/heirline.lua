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
		local m = (self.mode_names or {})[self.mode]
		if not m then
			m = ""
		end
		return " %2(" .. m .. "%)"
	end,
	-- Same goes for the highlight. Now the foreground will change according to the current mode.
	hl = function(self)
		local mode = self.mode:sub(1, 1) -- get only the first mode character
		return {
			fg = self.mode_colors[mode],
			bold = true,
		}
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

-- 한번 search하고 나서 nvim을 껐다 켜야지 heirline이 그때부터 작동한다.
-- 이것도 lsp들을 자동으로 설치하지 않아서 발생하는 문제 아닌가?
return {
	"rebelot/heirline.nvim",
	enabled = true,
	event = "VeryLazy",
	init = function() end,
	config = function()
		vim.o.laststatus = 3
		vim.o.cmdheight = 0

		local conditions = require("heirline.conditions")
		local heirline = require("heirline")
		local utils = require("heirline.utils")

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
			git_del = utils.get_highlight("GitSignsDelete").fg,
			git_add = utils.get_highlight("GitSignsAdd").fg,
			git_change = utils.get_highlight("GitSignsChange").fg,
			metal_gold = "#D4AF37",
			lavender = "#967bb6",
		}
		heirline.load_colors(colors)

		-- 팔레트(현재 colorscheme 색을 재사용)

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
				hl = { fg = "diag_error" },
			},
			{
				provider = function(self)
					if self.warnings > 0 then
						return self.warn_icon .. " " .. self.warnings .. " "
					end
					return ""
				end,
				hl = { fg = "diag_warn" },
			},
			{
				provider = function(self)
					if self.info > 0 then
						return self.info_icon .. " " .. self.info .. " "
					end
					return ""
				end,
				hl = { fg = "diag_info" },
			},
			{
				provider = function(self)
					if self.hints > 0 then
						return self.hint_icon .. " " .. self.hints
					end
					return ""
				end,
				hl = { fg = "diag_hint" },
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

			hl = { fg = "orange" },

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
				hl = { fg = "git_add" },
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and ("-" .. count)
				end,
				hl = { fg = "git_del" },
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and ("~" .. count)
				end,
				hl = { fg = "git_change" },
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
					-- local path = require("custom.root").get_root_detail(self.file_dir)
					local path = require("custom.root").get_root_detail(self.file_dir)
					-- vim.print(self.fname)
					-- vim.notify("x :", path.shorten_relative)
					-- print(path.root_path, path.file_path)
					if path.shorten_relative == nil then
						path.shorten_relative = ""
					end
					local shortened = path.shorten_relative ~= "" and " * " .. path.shorten_relative or ""
					return self.icon .. path.root_name .. shortened
				end,
				hl = { fg = "lavender" },
			},
			{
				-- evaluates to the shortened path
				provider = function(self)
					-- print("2")
					local path = require("custom.root").get_root_detail(self.cwd)
					return self.icon .. " !!! "
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
				return (name == "" and "[No Name]" or "* " .. name)
			end,
			hl = { fg = "gray", bg = nil },
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
		local SearchCount = {
			condition = function()
				-- vim.o.cmdheight -> command라인의 줄 수!
				-- 이 값이 0이면 평소에는 statusline만 보이고
				-- :입력시에 statusline이 없어지고 cmdline만 보인다
				-- 이게 세팅이 되어야지 아래의 세팅이 작동한다
				-- 그게 아니라면 vim.o.cmdheight ~= 0을 없애면 된다
				-- 안되는데? 그냥 vim.o.cmdheight ~= 0이 없어야 작동....
				-- vim.o.cmdheight = 0 -> 세팅이 좋네. 한번씩 검색하고 있는지 아닌지 구분이 안가는 경우가 많은데
				-- 검색을 입력할 때는 완전히 statusline이 안보이니 확실히 구분이 된다.
				return vim.v.hlsearch ~= 0
			end,
			init = function(self)
				local ok, search = pcall(vim.fn.searchcount)
				if ok and search.total then
					self.search = search
				end
			end,
			provider = function(self)
				local search = self.search
				if not search then
					return ""
				end
				return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
			end,
		}

		local MacroRec = {
			condition = function()
				return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
			end,
			provider = " ",
			hl = { fg = "orange", bold = true },
			utils.surround({ "[", "]" }, nil, {
				provider = function()
					return vim.fn.reg_recording()
				end,
				hl = { fg = "green", bold = true },
			}),
			update = {
				"RecordingEnter",
				"RecordingLeave",
			},
		}

		local LSPActive = {
			condition = conditions.lsp_attached,
			update = { "LspAttach", "LspDetach", "BufEnter", "BufWinEnter", "BufDelete" },
			provider = function()
				local names = {}
				for i, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
					table.insert(names, server.name)
				end
				return "[" .. table.concat(names, " ") .. "]"
			end,
			hl = { fg = "green", bold = true },
		}
		--  ConformActive ─ 지금 버퍼에서 "실제로 실행될" 포매터 체인(+LSP 여부)
		local ConformActive = {
			condition = function()
				local ok, conform = pcall(require, "conform")
				if not ok then
					return false
				end
				local avail = conform.list_formatters and conform.list_formatters(0) or {}
				return avail and #avail > 0
			end,
			-- 파일타입/버퍼 전환, 저장 직전 등에 갱신
			update = { "BufEnter", "FileType", "BufWritePre", "LspAttach", "LspDetach" },
			provider = function()
				local conform = require("conform")
				local infos, use_lsp = conform.list_formatters_to_run(0) -- 정확히 무엇이 돌지
				local names = {}
				for _, it in ipairs(infos or {}) do
					table.insert(names, it.name or "?")
				end
				-- 아이콘은 취향대로: "" (가위) / "" (붓) 등
				return ("[%s%s]"):format((#names > 0) and table.concat(names, " ") or "none", use_lsp and " +LSP" or "")
			end,
			hl = { fg = "#FFA673", bold = true },
		}

		--  LintActive ─ nvim-lint: "지금 돌고 있는" 린터가 있으면 그걸, 없으면 구성된 린터를
		local LintActive = {
			condition = function()
				local ok, lint = pcall(require, "lint")
				if not ok then
					return false
				end
				local ft = vim.bo.filetype
				local configured = (lint.linters_by_ft and lint.linters_by_ft[ft]) or {}
				local running = (type(lint.get_running) == "function") and (lint.get_running(0) or {}) or {}
				return (#configured > 0) or (#running > 0)
			end,
			-- nvim-lint는 보통 저장/입력종료/버퍼진입에서 돌리니 그 타이밍에 갱신
			update = { "BufEnter", "FileType", "BufWritePre", "LspAttach", "LspDetach" },
			provider = function()
				local lint = require("lint")
				local running = (type(lint.get_running) == "function") and (lint.get_running(0) or {}) or {}
				local names, icon
				if #running > 0 then
					names, icon = running, "󱉶" -- running
				else
					names, icon = (lint.linters_by_ft[vim.bo.filetype] or {}), "󰦕" -- idle
				end
				return ("[%s]"):format((#names > 0) and table.concat(names, " ") or "none")
			end,
			hl = { fg = "#FFCB61", bold = true },
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
			SearchCount,
			Space,
			MacroRec,
			Align,

			LSPActive,
			ConformActive,
			LintActive,
			Space,
			Ruler,
			Space,
			ScrollBar,
		}

		heirline.setup({ statusline = StatusLine })
	end,
}
