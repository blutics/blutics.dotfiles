return {
	"numToStr/Comment.nvim",
	opts = {
		-- 기본 매퍼 설정
		toggler = {
			line = "gcc", -- 현재 줄 주석 토글
			block = "gbc", -- 블록 주석 토글
		},
		-- 조작 키 설정 (visual mode와 normal mode에서 작동)
		opleader = {
			line = "gc", -- 라인 주석
			block = "gb", -- 블록 주석
		},

		-- 추가 설정
		padding = true, -- 주석 앞뒤로 공백 추가
		sticky = true, -- 빈 줄 주석 처리시 커서 위치 유지
		ignore = nil, -- 주석 처리 무시할 라인 패턴

		-- 매핑 설정
		mappings = {
			basic = true, -- gcc, gc, gbc 등 기본 매핑
			extra = true, -- gco, gcO, gcA 등 추가 매핑
		},

		-- 사전/사후 후크 함수
		pre_hook = nil, -- 주석 처리 전 실행할 함수
		post_hook = nil, -- 주석 처리 후 실행할 함수
	},
}
