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

    --CSS
    "css-lsp", -- LSP
    "tailwindcss-language-server", -- LSP
    "stylelint", -- Linter
    -- #"prettierd", -- Formateador

    -- HTML
    "html-lsp", -- LSP
    "htmlhint", -- Linter
    -- #"prettierd", -- Formateador


    -- Python
    "pyright", -- LSP principal (autocompletado, imports, análisis)
    "ruff", -- Linter + Formateador + Organizador de imports (via none-ls)
    "mypy", -- Type checker (alternativa 1, via none-ls)
    -- "pyrefly", -- Type checker AI (alternativa 2, via none-ls) - Descomentar si lo usas
    "debugpy", -- DAP
    -- "black", -- DESACTIVADO - Ruff lo reemplaza
    -- "isort", -- DESACTIVADO - Ruff lo reemplaza

    -- Jinja
    --"curlylint",
    --"djlint",
    --"jinja-lsp",

    -- C/C++
    "clangd",
    "clang-format",
    "ast-grep", 

    -- CMake
    "cmake-language-server", --LSP


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

    -- Markdown
    "marksman", -- LSP

  },
}

M.nvdash = {
  load_on_startup = true,
}

-- require('custom.commands')
return M
