return {
  "folke/which-key.nvim",
  "echasnovski/mini.icons",

  lazy = false,
  opts = {
  },



  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Agregar mapeos personalizados
    wk.register({
      l = {
        name = "LaTeX",
        l = { "<cmd>VimtexCompile<CR>", "Compile LaTeX" },
        v = { "<cmd>VimtexView<CR>", "View PDF" },
      },

    }, { prefix = "<leader>" })
  end,
}
