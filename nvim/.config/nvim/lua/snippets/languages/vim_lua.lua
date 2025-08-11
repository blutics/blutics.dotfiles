-- lua/snippets/init.lua

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt


ls.add_snippets("lua", {
  -- Lua 스니펫
  s("req", fmt("local {} = require('{}')", { i(1, "module"), i(0) })),
  s("leader", fmt("<leader>{}", { i(1, "keys") })),
  s("command", fmt('"<Cmd>{}<Cr>"', { i(1, "command") })),
  s(
    "keymap",
    fmt([[vim.keymap.set("{}", "{}", {}, {{ desc = "{}"}})]], {
      i(1, "mode"),
      i(2, "key"),
      i(3, "command"),
      i(4, "description"),
    })
  ),
})
-- 필요한 파일타입별로 스니펫 추가
