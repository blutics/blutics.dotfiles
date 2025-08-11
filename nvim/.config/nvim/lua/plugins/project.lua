return {
	"ahmedkhalf/project.nvim",
	config = function()
		require("project_nvim").setup({
			-- 프로젝트 감지 패턴
			patterns = {
				".git",
				"_darcs",
				".hg",
				".bzr",
				".svn",
				"Makefile",
				"package.json",
				"requirements.txt",
        ".obsidian",
        "README.md"
			},

			-- 프로젝트가 감지되면 해당 디렉토리로 자동 변경
			detection_method = "pattern",
			-- 최근 프로젝트 저장 갯수
			recent_projects_number = 10,
			-- telescope 통합 활성화
			show_hidden = false,
			-- 무시할 디렉토리
			ignore_lsp = {},
			-- 자동으로 CD 실행 --> 중요! 이거 설정 true로 안하면 아무리 cd로 루트 경로 바꾸더라도 다시 돌아간다. 아직, 이걸 true한다고 제대로 된다는걸 확인하지는 않음
			manual_mode = true,
			-- datapath 설정
			datapath = vim.fn.stdpath("data"),
		})
		-- telescope 확장 로드
		local telescope = require("telescope")
		telescope.load_extension("projects")

		-- 키매핑 (선택사항)
	end,
	dependencies = { "nvim-telescope/telescope.nvim" },
}
