-- Desactivar avisos de deprecación que causan errores en Neovim 0.11/0.12
local function silence_warnings()
  local old_notify = vim.notify
  vim.notify = function(msg, level, opts)
    if type(msg) == "string" and (msg:match "lspconfig" or msg:match "deprecated") then
      return
    end
    return old_notify(msg, level, opts)
  end
  vim.deprecate = function() end
end

silence_warnings()

-- Cargar defaults de NvChad
local ok_defaults, _ = pcall(function()
  require("nvchad.configs.lspconfig").defaults()
end)

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Servidores con configuración estándar
local servers = { "html", "cssls", "ts_ls", "marksman", "clangd", "texlab", "bashls", "omnisharp" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Python: Ruff (LSP Principal para Linting y Formateo)
-- Astral.sh - Proporciona diagnósticos rápidos y precisos.
lspconfig.ruff.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

-- Python: Pyright (Restaurado para Navegación e Imports)
-- Configurado como servidor SILENCIOSO para evitar duplicidad.
lspconfig.pyright.setup {
  on_attach = function(client, bufnr)
    -- BLOQUEO DE DIAGNÓSTICOS: Pyright solo sirve para navegación e inteligencia.
    client.server_capabilities.diagnosticProvider = false
    nvlsp.on_attach(client, bufnr)
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        typeCheckingMode = "off", -- Desactivar diagnósticos de tipos
        diagnosticMode = "openFilesOnly",
        autoImportCompletions = true, -- Importaciones inteligentes habilitadas
      },
    },
  },
}

-- FILTRO GLOBAL DE SEGURIDAD (Doble capa de protección contra duplicados)
local original_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  -- Si el mensaje viene de Pyright, lo descartamos para que solo Ruff hable.
  if client and client.name == "pyright" then
    return
  end
  return original_publish_diagnostics(err, result, ctx, config)
end
