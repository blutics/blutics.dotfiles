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
  enabled = false,
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
				self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
				local cwd = vim.fn.getcwd(0)
				self.cwd = vim.fn.fnamemodify(cwd, ":~")
			end,
			hl = { fg = "blue", bold = true },

			flexible = 1,

			{
				-- evaluates to the full-lenth path
				provider = function(self)
          local path = require("..custom.common").get_relative_path()
					return self.icon .. path .. " "
				end,
			},
			{
				-- evaluates to the shortened path
				provider = function(self)
					local cwd = vim.fn.pathshorten(self.cwd)
          local path = require("..custom.common").get_relative_path()
					return self.icon .. path .. " "
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
		local File = {
			provider = function()
				local name = vim.fn.expand("%:t")
				return (name == "" and "[No Name]" or name)
			end,
			hl = { bg = nil },
		}

		local Ruler = { provider = "%7(%l:%c%)", hl = { bg = nil } }

		local StatusLine = {
			Space,
			ViMode,
			Space,
			Git,
      Space,
      WorkDir,
			Space,
			File,
			Align,
			Ruler,
			Space,
		}

		require("heirline").setup({ statusline = StatusLine, opts = { colors = colors } })
	end,
}
