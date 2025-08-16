-- fidget을 쓰지 않는 이유 :
--    노티가 우하단에 이쁘게 뜬다.
--    끌때도 깔끔하게 꺼진다
--    가장 큰 단점이 내려간 노티들을 다시 보기가 어렵다.
--    Telescope으로 검색 가능하다지만 작동하지 않음
--    Fidget history로 다시 올려볼 수 있긴하지만 내용이 많아진다면 거의 찾기 불가능 하지 않을까?
--    그래서 그냥 nvim-notify도 안쓰고 베어하게 쓰면서 노티가 많이 떴을 때는 readonly buffer하나 받아서 쓰려고 한다
return {
	{
		"j-hui/fidget.nvim",
		enabled = false,
		event = "VeryLazy",
		opts = {
			-- 1) 일반 알림(vim.notify)도 Fidget 창에 태우기
			notification = {
				override_vim_notify = true, -- vim.notify → Fidget로 라우팅
				view = {
					stack_upwards = true, -- 아래→위로 누적(동시 다중 표시)
				},
				window = {
					relative = "editor", -- 에디터 기준 고정
					align = "bottom", -- "top"이면 우상단, "bottom"이면 우하단
					x_padding = 1, -- 오른쪽 가장자리에서 여백
					y_padding = 1, -- 아래(또는 위) 가장자리에서 여백
					border = "rounded",
					winblend = 0,
				},
			},

			-- 2) LSP 진행 메시지도 여러 개 동시 렌더
			progress = {
				display = {
					render_limit = 16, -- 동시에 보여줄 진행 메시지 개수
					progress_ttl = math.huge, -- 진행 중일 땐 사라지지 않도록
					done_ttl = 2, -- 완료 후 잔상 유지 시간(초)
					skip_history = false, -- 히스토리에도 남기기(선택)
				},
			},

			-- 3) (선택) 파일트리와 겹침 방지
			integration = {
				["nvim-tree"] = { enable = true },
			},
		},
	},
}
