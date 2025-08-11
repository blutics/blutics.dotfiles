-- lua/snippets/init.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("all", {
	-- 모든 파일타입에서 사용 가능한 스니펫
	s("date", {
		t(os.date("%Y-%m-%d")),
	}),
})
