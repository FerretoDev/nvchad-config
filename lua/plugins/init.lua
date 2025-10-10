return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
    lazy = false,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  {
    "mfussenegger/nvim-dap",
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
  },

  { "nvim-neotest/nvim-nio" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- "vim",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "c",
        "markdown",
        "markdown_inline",
        "python",
        -- "go",
        -- "rust",
      },
      indent = {
        enable = true,
      },
    },
  },

  {
    'lewis6991/hover.nvim',
    config = function()
      require('hover').setup {
        init = function()
          -- Habilita varias fuentes de documentación
          require('hover.providers.lsp')
          require('hover.providers.gh')
          require('hover.providers.man')
          require('hover.providers.dictionary')
        end,
        preview_opts = {
          border = 'rounded'
        },
        title = true,
      }

      -- Nota: los mapeos ahora se cargan desde el archivo `mappings.lua`
    end
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',     -- Fuente para autocompletado de LSP
      'hrsh7th/cmp-buffer',       -- Fuente para autocompletado de buffer
      'hrsh7th/cmp-path',         -- Fuente para autocompletado de ruta de archivos
      'hrsh7th/cmp-cmdline',      -- Fuente para autocompletado en la línea de comandos
      'saadparwaiz1/cmp_luasnip', -- Fuente para autocompletado de snippets (LuSnip)
      'L3MON4D3/LuaSnip',         -- Snippet Engine
      'onsails/lspkind.nvim',     -- Añade iconos a los elementos completados
    },
    config = function()
      local cmp = require('cmp')
      local lspkind = require('lspkind')

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = "supermaven" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text', -- Show both symbol and text
            maxwidth = 50,        -- Limit the width of the completion item
          })
        }
      })
    end
  },
  {
    "nvchad/volt",
    lazy = true
  },
  {
    "nvchad/menu",
    lazy = true,
  },
  require "plugins.carbon",
  require "plugins.supermaven",
  require "plugins.which-key",
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
