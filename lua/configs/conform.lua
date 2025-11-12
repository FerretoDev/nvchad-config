local options = {
  formatters_by_ft = {

    -- Conform will run multiple formatters sequentially
    python = { "isort","ruff_format" },
    jinja = { "djlint" },
    --bash = { "shfmt" },
    --python = { "isort", "black"  },
    -- To fix auto-fixable lint errors.
    --"ruff_fix",
    -- To run the Ruff formatter.
    -- "ruff_format",
    -- To organize the imports.
    -- "ruff_organize_imports",
    --
    -- Use a sub-list to run only the first available formatter
  -- Ejecutar el primero disponible: usar una lista plana y Conform probará en orden
  javascript = { "prettierd", "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascriptreact = { "prettier" },
    markdown = { "prettier" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    cs = { "csharpier" },
    --cs = { "clang-format" },
    cmake = { "cmakelang" }

  },
  linters_by_ft = {
    python = { "ruff_fix", "pyrefly" },
    -- python = { "pylint", "mypy" },
    jinja = { "jinja-lsp" },
    c = { "ast-grep" },
    cpp = { "ast-grep" },
    cs = { "ast-grep" },
    cmake = { "cmakelint" },
    --bash = { "shellcheck" }
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
    -- lsp_fallback = true,
  },
}
require("conform").setup(options)

