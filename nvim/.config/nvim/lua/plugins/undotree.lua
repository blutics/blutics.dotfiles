-- lua/config/plugins/undotree.lua
return {
  "mbbill/undotree",
  keys = {
    { "<leader><leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" }
  },
  config = function()
    vim.g.undotree_WindowLayout = 2  -- 레이아웃 스타일 (1-4)
    vim.g.undotree_SplitWidth = 30   -- undotree 창 너비
    vim.g.undotree_DiffpanelHeight = 10  -- diff 패널 높이
    vim.g.undotree_DiffCommand = "git diff --no-index" -- 윈도우용 -> 윈도우에서는 diff를 chocolate으로 설치하는게 최선이다.

    vim.g.undotree_SetFocusWhenToggle = 1  -- 토글시 포커스 이동
    vim.g.undotree_ShortIndicators = 1  -- 짧은 타임스탬프 표시
    vim.g.undotree_HelpLine = 0  -- 도움말 라인 숨기기
    vim.g.undotree_TreeNodeShape = "🔄" -- "●"  -- 트리 노드 모양
    vim.g.undotree_TreeVertShape = "│"  -- 수직 선 모양
    vim.g.undotree_TreeSplitShape = "╱"  -- 분할 모양
    vim.g.undotree_TreeReturnShape = "╲"  -- 리턴 모양
    vim.g.undotree_DiffCommand = "diff"
    vim.g.undotree_RelativeTimestamp = 1  -- 상대적 시간 표시
    vim.g.undotree_HighlightChangedText = 1  -- 변경된 텍스트 하이라이트
    vim.g.undotree_HighlightSyntaxAdd = "DiffAdd"  -- 추가된 텍스트 하이라이트 스타일
    vim.g.undotree_HighlightSyntaxChange = "DiffChange"  -- 변경된 텍스트 하이라이트 스타일
    vim.g.undotree_HighlightSyntaxDel = "DiffDelete"  -- 삭제된 텍스트 하이라이트 스타일
  end,
}
