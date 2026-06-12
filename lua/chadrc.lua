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
    -- Lua
    "lua-language-server",
    "stylua",

    -- Web
    "typescript-language-server",
    "prettierd",
    "eslint_d",
    "css-lsp",
    "tailwindcss-language-server",
    "html-lsp",

    -- Python
    "pyright",
    "ruff",
    "debugpy",

    -- C/C++
    "clangd",
    "clang-format",

    -- C#
    "omnisharp",
    "csharpier",
    "netcoredbg",

    -- Bash
    "bash-language-server",
    "shellcheck",
    "shfmt",

    -- Markdown & Others
    "marksman",
    "texlab",
    "cmake-language-server",
    "cmakelang",
    "cmakelint",
  },
}

M.nvdash = {
  load_on_startup = true,
}

M.ui = {
  cmp = {
    icons_left = true,
    style = "default", -- default/atom/atom_colored
  },

  statusline = {
    theme = "default", -- default/vscode/vscode_colored/minimal
  },
}

return M
