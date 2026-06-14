-- Plugin para embellecer la visualización de Markdown (tablas, checkbox, headers, callouts)
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  opts = {
    heading = {
      sign = false, -- Desactiva marcas en la columna de signos
      icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎰 ", "󰎳 " }, -- Iconos estéticos de cabecera
    },
    checkbox = {
      enabled = true,
      unchecked = { icon = "󰄱 " },
      checked = { icon = "󰄵 " },
    },
    pipe_table = {
      preset = "round", -- Bordes redondeados para tablas
    },
    callout = {
      -- Soporte para callouts tipo Obsidian [!NOTE], [!WARNING], etc.
      note = { raw = "[!NOTE]", rendered = "󰋽 Nota", highlight = "RenderMarkdownInfo" },
      tip = { raw = "[!TIP]", rendered = "󰌶 Consejo", highlight = "RenderMarkdownSuccess" },
      important = { raw = "[!IMPORTANT]", rendered = "󰅃 Importante", highlight = "RenderMarkdownWarn" },
      warning = { raw = "[!WARNING]", rendered = "󰀪 Advertencia", highlight = "RenderMarkdownWarn" },
      caution = { raw = "[!CAUTION]", rendered = "󰳦 Precaución", highlight = "RenderMarkdownError" },
    },
  },
}
