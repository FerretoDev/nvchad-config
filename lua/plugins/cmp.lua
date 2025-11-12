return {
    "hrsh7th/nvim-cmp",
    lazy = false,
    config = function()
        local cmp = require("cmp")

        -- Definir mapeos en una tabla separada
        local mappings = {
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }

        -- Configurar nvim-cmp
        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- Usa LuaSnip como motor de snippets
                end,
            },
            mapping = cmp.mapping.preset.insert(mappings),
            sources = cmp.config.sources({
                { name = "nvim_lsp",     priority = 1000 }, -- Completado de LSP (máxima prioridad)
                { name = "luasnip",      priority = 750 },  -- Snippets con LuaSnip
                { name = "buffer",       priority = 500 },  -- Texto en el buffer actual
                { name = "path",         priority = 250 },  -- Rutas de archivos
            }),

            sorting = {
                priority_weight = 2,
                comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    cmp.config.compare.recently_used,
                    cmp.config.compare.kind,
                    cmp.config.compare.locality,
                    cmp.config.compare.order,
                },
            },
        })
    end,
}
