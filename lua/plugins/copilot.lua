return {
    "github/copilot.vim",
    lazy = false,
    config = function()
        -- Habilitar Copilot en tipos de archivo de texto/Markdown
        vim.g.copilot_filetypes = {
            markdown = true,
            ["markdown.mdx"] = true,
            gitcommit = true,
            text = true,
            TelescopePrompt = false,
        }

        -- Navegar sugerencias de Copilot (opcional): Alt-[ y Alt-]
        vim.api.nvim_set_keymap("i", "<M-]>", "copilot#Next()", { silent = true, expr = true })
        vim.api.nvim_set_keymap("i", "<M-[>", "copilot#Previous()", { silent = true, expr = true })
        -- Desplegar panel (opcional): <M-p>
        vim.api.nvim_set_keymap("i", "<M-p>", "copilot#Panel()", { silent = true, expr = true })
    end,
}
