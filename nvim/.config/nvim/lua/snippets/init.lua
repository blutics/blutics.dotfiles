local ls = require("luasnip")
ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
})

require("snippets.common")
require("snippets.languages.vim_lua")
require("snippets.languages.markdown")
