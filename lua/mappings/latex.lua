-- Atajos de teclado para edición científica y LaTeX (Vimtex)
local map = vim.keymap.set

-- Snippets y entornos
map("n", "<leader>lb", "<cmd>VimtexToggleMain<cr>", { desc = "Cambiar archivo principal" })
map("n", "<leader>lm", "<Nop>", { desc = "Insertar modo matemático" })
map("n", "<leader>lmi", "i$$<ESC>i", { desc = "Ecuación en línea" })
map("n", "<leader>lmb", "i$$<ESC>i$$<ESC>i", { desc = "Ecuación en bloque" })
map("n", "<leader>ln", "o\\begin{}<cr>\\end{}<ESC>k$i", { desc = "Nuevo entorno" })

-- Comandos principales de Vimtex
map("n", "<leader>l", "<Nop>", { desc = "LaTeX" })
map("n", "<leader>lc", "<cmd>VimtexCompile<cr>", { desc = "Compilar" })
map("n", "<leader>lv", "<cmd>VimtexView<cr>", { desc = "Ver PDF" })
map("n", "<leader>le", "<cmd>VimtexErrors<cr>", { desc = "Ver errores" })
map("n", "<leader>ls", "<cmd>VimtexStop<cr>", { desc = "Detener compilación" })
map("n", "<leader>li", "<cmd>VimtexInfo<cr>", { desc = "Info del documento" })
map("n", "<leader>lt", "<cmd>VimtexTocOpen<cr>", { desc = "Abrir índice" })
map("n", "<leader>lk", "<cmd>VimtexClean<cr>", { desc = "Limpiar archivos" })
map("n", "<leader>lg", "<cmd>VimtexLog<cr>", { desc = "Ver log" })
map("n", "<leader>lr", "<cmd>VimtexReload<cr>", { desc = "Recargar" })
