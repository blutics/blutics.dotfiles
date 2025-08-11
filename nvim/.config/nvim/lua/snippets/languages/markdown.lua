-- lua/snippets/init.lua

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("markdown", {
  -- markdown 스니펫
  s(
    "url_input",
    fmt("[{}]({})", {
      i(1, "title"),
      i(2, "url"),
    })
  ),
})
-- 필요한 파일타입별로 스니펫 추가
