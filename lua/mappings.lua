require "nvchad.mappings"
-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")





-- Obsidian mappings with which-key descriptions
map("n", "<leader>o", "", { desc = "Obsidian" })
--map("n", "<leader>of", "<cmd>ObsidianSearch<cr>", { desc = "Buscar archivo" })
map("n", "<leader>on", "", { desc = "Nueva nota" })
map("n", "<leader>onn", "<cmd>ObsidianNew<cr>", { desc = "Nueva nota (sin template)" })
map("n", "<leader>ont", "<cmd>ObsidianNewFromTemplate<cr>", { desc = "Nueva nota de plantilla" })
map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Ver backlinks" })
map("n", "<leader>ot", "<cmd>ObsidianToday<cr>", { desc = "Nota diaria" })
map("n", "<leader>ol", "<cmd>ObsidianLinks<cr>", { desc = "Ver enlaces" })
map("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "abrir en obsidian" })
--map("n", "<leader>os", "<cmd>obsidianquickswitch<cr>", { desc = "cambiar nota rápido" })
map("n", "<leader>oi", "<cmd>ObsidianTemplate<cr>", { desc = "insertar plantilla" })

-- Snippets y entornos
map("n", "<leader>lb", "<cmd>VimtexToggleMain<cr>", { desc = "Cambiar archivo principal" })
map("n", "<leader>lm", "", { desc = "Insertar modo matemático" })
map("n", "<leader>lmi", "i$$<ESC>i", { desc = "Ecuación en línea" })
map("n", "<leader>lmb", "i$$<ESC>i$$<ESC>i", { desc = "Ecuación en bloque" })
map("n", "<leader>ln", "o\\begin{}<cr>\\end{}<ESC>k$i", { desc = "Nuevo entorno" })


-- LaTeX mappings with which-key descriptions
map("n", "<leader>l", "", { desc = "LaTeX" })
map("n", "<leader>lc", "<cmd>VimtexCompile<cr>", { desc = "Compilar" })
map("n", "<leader>lv", "<cmd>VimtexView<cr>", { desc = "Ver PDF" })
map("n", "<leader>le", "<cmd>VimtexErrors<cr>", { desc = "Ver errores" })
map("n", "<leader>ls", "<cmd>VimtexStop<cr>", { desc = "Detener compilación" })
map("n", "<leader>li", "<cmd>VimtexInfo<cr>", { desc = "Info del documento" })
map("n", "<leader>lt", "<cmd>VimtexTocOpen<cr>", { desc = "Abrir índice" })
map("n", "<leader>lk", "<cmd>VimtexClean<cr>", { desc = "Limpiar archivos" })
map("n", "<leader>lg", "<cmd>VimtexLog<cr>", { desc = "Ver log" })
map("n", "<leader>lr", "<cmd>VimtexReload<cr>", { desc = "Recargar" })





-- Keyboard users
--map("n", "<C-b>", function()
--  local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
--  require("menu").open(options)
--end, {})

-- mouse users + nvimtree users!
map({ "n", "v" }, "<RightMouse>", function()
  vim.cmd.exec '"normal! \\<RightMouse>"'

  local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
  require("menu").open(options, { mouse = true, border = true })
end, {})
