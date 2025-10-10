-- lspkind.lua


return {
  "onsails/lspkind-nvim",
  -- lazy = false, -- Puedes cambiar esto a true si quieres que se cargue de forma diferida
  config = function()
    require("lspkind").init({
      symbol_map = {
        Supermaven = "",
      },
    })

    vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#6CC644" })
  end,
}
