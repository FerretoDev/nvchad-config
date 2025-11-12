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

  -- none-ls: integración de herramientas externas (formatters, linters)
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require "configs.none-ls"
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
    config = function()
      local python_path = vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python"
      -- Intento opcional de usar debugpy si ya está instalado vía Mason
      local ok_mason, registry = pcall(require, "mason-registry")
      if ok_mason then
        local ok_pkg, pkg = pcall(registry.get_package, "debugpy")
        if ok_pkg then
          local ok_installed, is_installed = pcall(function() return pkg:is_installed() end)
          if ok_installed and is_installed then
            local ok_path, install_path = pcall(function() return pkg:get_install_path() end)
            if ok_path and install_path then
              local dbg = install_path .. "/venv/bin/python"
              if vim.loop.fs_stat(dbg) then
                python_path = dbg
              end
            end
          end
        end
      end
      require("dap-python").setup(python_path)
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

  -- nvim-cmp se configura en `lua/plugins/cmp.lua` para evitar duplicados
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
