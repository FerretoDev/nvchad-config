return {
  "ellisonleao/carbon-now.nvim",
  lazy = false,
  cmd = "CarbonNow",
  opts = {
    options = {
      bg = "rgba(30,30,30,100)",        -- Fondo oscuro tipo terminal
      font_family = "Cascadia Code",    -- Fuente monoespaciada popular en VS Code:
      font_size = "18px",               -- Tamaño de fuente adecuado para terminal
      theme = "one-dark",
      titlebar = "",                    -- Sin título personalizado
      watermark = false,                -- Sin marca de agua
      window_controls = true,           -- Activa los controles de ventana
      window_control_style = "custom",  -- Estilo personalizado para simular el control
      window_control_color = "#ffffff", -- Color de los íconos de control (blanco minimalista)
      line_numbers = true,              -- Números de línea como en terminal
      drop_shadow = false,              -- Sin sombras
      padding_vertical = "30px",        -- Padding vertical
      padding_horizontal = "30px",      -- Padding horizontal
    },
  },
}
