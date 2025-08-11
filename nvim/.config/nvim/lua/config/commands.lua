-- Lua 코드: init.lua 또는 별도 모듈로 작성

-- URL을 받아 해당 페이지의 타이틀과 링크를 마크다운 형식으로 버퍼에 입력하는 함수
local function fetch_url_and_insert_markdown(url)
	-- curl을 사용해 URL의 HTML을 가져옵니다.
	local cmd = { "curl", "-s", url }
	vim.fn.jobstart(cmd, {
		stdout_buffered = true, -- 모든 출력이 버퍼에 모일 때까지 대기
		on_stdout = function(_, data, _)
			if data then
				-- data는 문자열 배열이므로 하나의 문자열로 합칩니다.
				local html = table.concat(data, "\n")
				-- HTML에서 <title> 태그 내용을 추출합니다.
				local title = html:match("<title>(.-)</title>")
				if not title or title == "" then
					title = "No Title Found"
				end
				-- 마크다운 링크 형식: [타이틀](URL)
				local markdown_link = string.format("[%s](%s)", title, url)
				-- 현재 커서 위치에 마크다운 링크를 입력합니다.
				vim.schedule(function()
					vim.api.nvim_put({ markdown_link }, "", true, true)
				end)
			end
		end,
		on_stderr = function(_, data, _)
			if data then
				vim.schedule(function()
					vim.notify("Error fetching URL:\n" .. table.concat(data, "\n"), vim.log.levels.ERROR)
				end)
			end
		end,
		on_exit = function(_, exit_code, _)
			if exit_code ~= 0 then
				vim.schedule(function()
					vim.notify("Curl exited with code " .. exit_code, vim.log.levels.ERROR)
				end)
			end
		end,
	})
end

-- Neovim 커맨드로 호출할 수 있도록 사용자 명령어를 등록합니다.
vim.api.nvim_create_user_command("InsertMarkdownLink", function(opts)
	local url = opts.args
	if url == nil or url == "" then
		vim.notify("URL을 입력하세요.", vim.log.levels.WARN)
		return
	end
	fetch_url_and_insert_markdown(url)
end, { nargs = 1 })

-- 사용법:
-- :InsertMarkdownLink https://example.com
--
--




