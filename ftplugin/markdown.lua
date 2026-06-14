-- Opciones específicas para archivos Markdown (Obsidian / Notas)

-- Ocultar sintaxis de enlaces para mostrar el alias limpio: [[enlace|alias]] -> alias
vim.opt_local.conceallevel = 2

-- Activar ajuste de línea automático para prosa
vim.opt_local.wrap = true

-- Activar corrector ortográfico en español e inglés
vim.opt_local.spell = true
vim.opt_local.spelllang = { "es", "en" }
