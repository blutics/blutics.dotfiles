-- lua/plugins/wilder.lua (예시)
-- nvim-cmp는 insert모드에서
-- wilder는 cmdline과 / 검색에서!
return {
	-- 1) fzy 가속기
	{
		"romgrk/fzy-lua-native",
		build = "make", -- Linux/macOS
		-- Windows라면 미설치 가능: 없으면 자동으로 기본 경로 사용
		optional = true,
	},
	-- 2) Wilder (Lua 전용 구성)
	{
		"gelguy/wilder.nvim",
		event = "CmdlineEnter",
		enabled = true,
		dependencies = {
			"romgrk/fzy-lua-native",
			{ "nvim-tree/nvim-web-devicons", optional = true },
		},
		config = function()
			local wilder = require("wilder")
			wilder.setup({ modes = { ":", "/", "?" }, use_python_remote_plugin = 0 })

			-- fzy 네이티브가 있으면 가속, 없으면 기본으로 폴백
			local ok = pcall(require, "fzy_lua_native")
			local highlighter = ok and wilder.lua_fzy_highlighter() or wilder.basic_highlighter()

			-- 파이썬 의존 전부 제거: lua_fzy_filter만 사용
			wilder.set_option("pipeline", {
				wilder.branch(
					wilder.cmdline_pipeline({
						language = "vim",
						fuzzy = 1,
						fuzzy_filter = wilder.lua_fzy_filter(),
					}),
					-- wilder.search_pipeline()
          wilder.vim_search_pipeline()
				),
			})

			-- 보기
			local renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
				border = "rounded",
				highlighter = highlighter,
				left = { " ", wilder.popupmenu_devicons() },
				right = { " ", wilder.popupmenu_scrollbar() },
			}))

			wilder.set_option(
				"renderer",
				wilder.renderer_mux({
					[":"] = renderer,
					["/"] = renderer,
					["?"] = renderer,
				})
			)

			-- 매치 강조색(테마에서 살짝 가져오기)
			local t = vim.api.nvim_get_hl(0, { name = "Type" })
			if t and t.fg then
				vim.api.nvim_set_hl(0, "WilderAccent", { fg = t.fg })
			end
		end,
	},
}
