-- Atajos de teclado para depuración con nvim-dap
local map = vim.keymap.set

map("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", { desc = "Alternar Breakpoint" })
map("n", "<leader>dc", "<cmd>DapContinue<cr>", { desc = "Continuar Depuración" })
map("n", "<leader>di", "<cmd>DapStepInto<cr>", { desc = "Paso Adentro (Step Into)" })
map("n", "<leader>do", "<cmd>DapStepOver<cr>", { desc = "Paso Sobre (Step Over)" })
map("n", "<leader>dt", "<cmd>DapTerminate<cr>", { desc = "Terminar Depuración" })
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Alternar UI de Depuración" })
