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
                -- { name = "supermaven",   priority = 1000 }, -- SuperMaven como fuente
                { name = "copilot",      priority = 1000 }, -- Copilot como fuente
                { name = "buffer",       priority = 800 },  -- Texto en el buffer actual
                { name = "path",         priority = 800 },  -- Rutas de archivos
                { name = "luasnip",      priority = 750 },  -- Snippets con LuaSnip
                { name = "nvim_lsp",     priority = 900 },  -- Completado de LSP
                { name = "latex_symbols" },                 -- Autocompletado de símbolos LaTeX
            }),

            sorting = {
                priority_weight = 2,
                comparators = {
                    function(entry1, entry2)
                        local kind_priority = {
                            Variable = 1,
                            Method = 2,
                            Function = 2,
                            Class = 3,
                        }

                        local kind1 = kind_priority[entry1:get_kind()] or 100
                        local kind2 = kind_priority[entry2:get_kind()] or 100

                        if kind1 ~= kind2 then
                            return kind1 < kind2
                        end
                    end,
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    cmp.config.compare.recently_used,
                    cmp.config.compare.locality,
                    cmp.config.compare.order,
                },
            },
        })
    end,
}
