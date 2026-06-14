-- Atajos de teclado para la navegación de proyectos
local map = vim.keymap.set

map("n", "<leader>fp", "<cmd>TelescopeProjects<cr>", { desc = "Buscar Proyecto (~/Dev)" })
