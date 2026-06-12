local lint = require "lint"

lint.linters_by_ft = {
  python = {}, -- Ruff via LSP se encarga de todo lo rápido.
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  sh = { "shellcheck" },
  cmake = { "cmakelint" },
  jinja = { "djlint" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

-- Activar traducción de Ruff si el archivo existe
local ok, ruff_spanish = pcall(require, "configs.ruff-spanish")
if ok then
  ruff_spanish.setup()
end
