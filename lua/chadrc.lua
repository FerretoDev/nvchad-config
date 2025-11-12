-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "ayu_dark",
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },

}



M.mason = {
  pkgs = {
    --lua-
    "lua-language-server",
    "stylua",

    --javascript-
    "typescript-language-server", -- LSP
    "prettierd", -- Formateador
    "eslint_d", -- Linter
    "js-debug-adapter", -- DAP


    -- Python
    --"black",
    "ruff",
    "pyright",
    --"mypy",
    "debugpy",
    --"pyrefly", -- no existe en mason
    --"pyright",
    --"pylint",
    --"isort",

    -- Jinja
    --"curlylint",
    --"djlint",
    --"jinja-lsp",

    -- C/C++
    "clangd",
    "clang-format",
    "ast-grep",

    --C#
    "omnisharp",
    "csharpier",
    "netcoredbg",
    
    --LaTex
    "texlab",

    --Bash
    "bash-language-server",
    "shellcheck",
    "shfmt",

  },
}

M.nvdash = {
  load_on_startup = true,
}

-- require('custom.commands')
return M
