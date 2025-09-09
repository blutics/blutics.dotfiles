-- npm으로 global로 bash-langauge-server 설치함
return {
	cmd = { "bash-language-server", "start" }, -- npm i -g bash-language-server
	filetypes = { "sh", "bash" },
	single_file_support = true,
}
