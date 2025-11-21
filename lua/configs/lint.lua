local lint = require("lint")

lint.linters_by_ft = {
  python = { "ruff", "mypy" }, -- o {"ruff", "pyrefly"} si preferís pyrefly
  c = { "ast-grep" },
  cpp = { "ast-grep" },
  cs = { "ast-grep" },
  cmake = { "cmakelint" },
  jinja = { "djlint" },
}

-- Corre los linters al guardar o abrir archivos
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
  callback = function()
    lint.try_lint()
  end,
})
