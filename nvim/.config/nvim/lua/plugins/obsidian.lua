-- plugins/obsidian.lua 또는 유사 파일

return {
	"epwalsh/obsidian.nvim",
	version = "*", -- 최신 버전을 사용하도록 권장
  enabled=false,
	lazy = true,
	event = {
		-- Vault 안의 마크다운 파일을 열 때 플러그인을 로드합니다.
		"BufReadPre "
			.. vim.fn.expand("~")
			.. "/ZK/**.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/ZK/**.md",
		-- 위 경로는 자신의 Vault가 위치한 대략적인 상위 경로로 수정하면 성능에 도움이 됩니다.
		-- 예: "~/Documents/Obsidian/**.md"
		-- 잘 모르겠다면 그냥 "BufReadPre *.md"로 해도 되지만, 모든 마크다운 파일에서 검사를 수행합니다.
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	opts = function()
		-- 현재 파일의 경로에서부터 상위로 올라가며 '.obsidian' 디렉토리를 찾습니다.
		local vault_dir = vim.fs.find({ ".obsidian" }, {
			upward = true,
			type = "directory",
			path = vim.api.nvim_buf_get_name(0), -- 현재 버퍼의 경로를 시작점으로 지정
		})[1] -- vim.fs.find는 결과를 테이블로 반환하므로 첫 번째 요소를 가져옵니다.

		-- '.obsidian'을 찾았다면, 그 부모 디렉토리가 바로 Vault의 루트입니다.
		local vault_root = vault_dir and vim.fn.fnamemodify(vault_dir, ":h")

		-- 만약 Vault를 찾지 못했다면, 플러그인이 로드되지 않도록 빈 설정을 반환합니다.
		-- 이렇게 하지 않으면 일반 마크다운 파일을 열 때 에러가 발생할 수 있습니다.
		if not vault_root then
			return {}
		end

		print("Obsidian vault found at: " .. vault_root) -- 확인용 메시지 (나중에 지워도 됨)

		-- 찾은 Vault 루트 경로를 사용하여 obsidian.nvim 설정을 반환합니다.
		return {
			dir = vault_root,

			-- 여기에 다른 모든 obsidian.nvim 설정을 추가합니다.
			notes_subdir = "notes",
			daily_notes = {
				folder = "daily",
				date_format = "%Y-%m-%d",
			},
			completion = {
        blink_cmp = true,
				min_chars = 2,
			},
			-- 등등...
		}
	end,
}
