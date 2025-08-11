print("hello world")

local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

local workspace = vim.fn.getcwd()
print(workspace)
local result = util.root_pattern("pyproject.toml", ".git", ".python-version")()
print(result)
