-- Silenciar advertencia de deprecación de lspconfig
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg and msg:match("lspconfig.*deprecated") then
    return
  end
  original_notify(msg, level, opts)
end

local original_deprecate = vim.deprecate
vim.deprecate = function(...)
  -- Silenciar completamente vim.deprecate para lspconfig
  local info = debug.getinfo(2, "S")
  if info and info.source and info.source:match("lspconfig") then
    return
  end
  original_deprecate(...)
end

-- Agregar Mason bin al PATH
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Lista de servidores básicos (lua_ls ya está configurado por NvChad defaults)
local servers = { "html", "cssls", "ts_ls", "marksman", "clangd", "texlab" }

-- Configurar servidores con config por defecto
for _, lsp in ipairs(servers) do
  local ok, err = pcall(function()
    lspconfig[lsp].setup {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }
  end)
  if not ok then
    vim.schedule(function()
      vim.notify("Error configurando LSP '" .. lsp .. "': " .. tostring(err), vim.log.levels.ERROR)
    end)
  end
end

-- Python: pyright - Solo para LSP (autocompletado, importaciones inteligentes)
-- Diagnósticos, formateo y linting delegados a none-ls (ruff + mypy/pyrefly)
lspconfig.pyright.setup {
  on_attach = function(client, bufnr)
    -- Desactivar completamente diagnósticos de pyright
    -- Ruff y mypy/pyrefly manejan esto via none-ls
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.diagnosticProvider = false
    
    nvlsp.on_attach(client, bufnr)
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "python" },
  settings = {
    python = {
      analysis = {
        -- Configuración optimizada para LSP (no para diagnósticos)
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly", -- Solo archivos abiertos, no todo el workspace
        typeCheckingMode = "off", -- Delegado a mypy/pyrefly via none-ls
        
        -- Mejorar sugerencias de imports
        autoImportCompletions = true,
        completeFunctionParens = true,
        
        -- Desactivar diagnósticos redundantes
        diagnosticSeverityOverrides = {
          reportUnusedImport = "none",
          reportUnusedVariable = "none",
          reportMissingTypeStubs = "none",
        },
      },
    },
  },
}

-- Python: ruff LSP - Para linting y formateo
-- Ruff funciona mejor como LSP que via none-ls
lspconfig.ruff.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "python" },
  init_options = {
    settings = {
      -- Configuración por defecto de ruff para evitar errores
      -- Puedes sobrescribirla creando ruff.toml o pyproject.toml en tu proyecto
      args = {},
      logLevel = "error",
    }
  },
}

-- CMake (comentado - instalar con :MasonInstall cmake-language-server si lo necesitas)
-- lspconfig.cmake.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
--   cmd = { "cmake-language-server" },
--   filetypes = { "cmake" },
--   init_options = {
--     buildDirectory = "build",
--   },
-- }

-- C# (omnisharp)
lspconfig.omnisharp.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "omnisharp" },
  filetypes = { "cs" },
  root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln", ".git"),
}
