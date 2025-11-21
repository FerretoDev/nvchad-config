return {
  "folke/which-key.nvim",
  dependencies = { "echasnovski/mini.icons" },
  lazy = false,
  opts = {},
  config = function(_, opts)
    local wk = require "which-key"
    wk.setup(opts)
    -- No registramos grupos aquí para evitar duplicados con los prefijos declarados en mappings.lua
  end,
}
