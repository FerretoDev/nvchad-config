return {
  {
    "lervag/vimtex",
    lazy = false,
    ft = "tex",
    dependencies = {
      -- Required.
      "kdheepak/cmp-latex-symbols",

      -- see below for full list of optional dependencies 👇
    },
    config = function()
      vim.g.vimtex_view_method = "zathura" -- Usa el visor que prefieras
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_quickfix_mode = 0
    end
  }
}
