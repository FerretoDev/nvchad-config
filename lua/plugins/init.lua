return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre',
    config = function()
      require "configs.conform"
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },

  { "mfussenegger/nvim-dap" },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
    config = function()
      local path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    opts = {
      ensure_installed = {
        "lua", "html", "css", "javascript", "typescript", "c",
        "markdown", "markdown_inline", "python", "vim", "vimdoc"
      },
      indent = { enable = true },
    },
  },

  {
    'lewis6991/hover.nvim',
    keys = {
      { "K", function() require("hover").hover() end, desc = "hover.nvim" },
      { "gK", function() require("hover").hover_select() end, desc = "hover.nvim (select)" },
    },
    config = function()
      require('hover').setup {
        init = function()
          require('hover.providers.lsp')
          require('hover.providers.gh')
          require('hover.providers.man')
          require('hover.providers.dictionary')
        end,
        preview_opts = { border = 'rounded' },
        title = true,
      }
    end
  },

  { "nvchad/volt", lazy = true },
  { "nvchad/menu", lazy = true },

  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    opts = {
      name = { "venv", ".venv" },
      auto_refresh = true,
    },
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Seleccionar Entorno Virtual" },
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
        },
      })
    end,
    keys = {
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Correr Test Cercano" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Correr Test Archivo" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Alternar Resumen Tests" },
    },
  },

  -- Importar plugins modulares
  require "plugins.carbon",
  require "plugins.supermaven",
  require "plugins.which-key",
  require "plugins.obsidian",
  require "plugins.cmp",
  require "plugins.vimtex",
  require "plugins.copilot",
  require "plugins.lspkind",
  require "plugins.render-markdown",
}
