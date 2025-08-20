vim.keymap.set("n", "<leader>g", "", { desc = "Go To" })
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "<leader>gi", ":Telescope lsp_implementations<Cr>", { desc = "Go to implementation" })
vim.keymap.set("n", "<leader>gr", ":Telescope lsp_references<Cr>", { desc = "Find References" })
vim.keymap.set("n", "<leader>gt", ":Telescope lsp_type_definitions<Cr>", { desc = "Find Types" })


-- vim.keymap.set("n", "<leader>gK", vim.lsp.buf.hover, { desc = "Help Document!" })
-- vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, { desc = "Signature Help" })

vim.keymap.set("n", "<leader>gn", vim.lsp.buf.rename, { desc = "Rename" })



-- 현재 파일의 심볼
vim.keymap.set("n", "<leader>gs", "", { desc = "Symbols" })
vim.keymap.set("n", "<leader>gss", ":Telescope lsp_document_symbols<CR>", { desc = "Current File Symbols" })
-- 전체 workspace의 심볼
vim.keymap.set("n", "<leader>gsS", ":Telescope lsp_workspace_symbols<CR>", { desc = "Current Project Symbols" })

vim.keymap.set("n", "<leader>gso", ":SymbolsOutline<CR>", {desc = "Toggle Symbol Outline"})

-- 동적 workspace 심볼 검색
vim.keymap.set(
  "n",
  "<leader>gsd",
  ":Telescope lsp_dynamic_workspace_symbols<CR>",
  { desc = "Dynamic Workspace Symbols" }
)


