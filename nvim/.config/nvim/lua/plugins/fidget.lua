return {
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      -- 1) 일반 알림(vim.notify)도 Fidget 창에 태우기
      notification = {
        override_vim_notify = true,           -- vim.notify → Fidget로 라우팅
        view = {
          stack_upwards = true,               -- 아래→위로 누적(동시 다중 표시)
        },
        window = {
          relative = "editor",                -- 에디터 기준 고정
          align = "bottom",                   -- "top"이면 우상단, "bottom"이면 우하단
          x_padding = 1,                      -- 오른쪽 가장자리에서 여백
          y_padding = 1,                      -- 아래(또는 위) 가장자리에서 여백
          -- border = "rounded",
          winblend = 0,
        },
      },

      -- 2) LSP 진행 메시지도 여러 개 동시 렌더
      progress = {
        display = {
          render_limit = 16,                  -- 동시에 보여줄 진행 메시지 개수
          progress_ttl = math.huge,           -- 진행 중일 땐 사라지지 않도록
          done_ttl = 2,                       -- 완료 후 잔상 유지 시간(초)
          skip_history = false,               -- 히스토리에도 남기기(선택)
        },
      },

      -- 3) (선택) 파일트리와 겹침 방지
      integration = {
        ["nvim-tree"] = { enable = true },
      },
    },
  },
}

