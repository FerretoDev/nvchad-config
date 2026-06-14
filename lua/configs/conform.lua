local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    python = { "ruff_organize_imports", "ruff_format" },
    jinja = { "djlint" },

    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    
    css = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    
    c = { "clang-format" },
    cpp = { "clang-format" },
    cs = { "csharpier" },
    
    cmake = { "cmakelang" },
    sh = { "shfmt" },
  },

  format_on_save = {
    timeout_ms = 2000,
    lsp_fallback = true,
  },
}

require("conform").setup(options)
