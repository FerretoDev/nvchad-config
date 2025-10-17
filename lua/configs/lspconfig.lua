-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "ts_ls", "pyright", "ruff","marksman", "clangd", "omnisharp", "texlab" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
--lspconfig.ruff.setup {
--    on_attach = nvlsp.on_attach,
--    on_init = nvlsp.on_init,
--    capabilities = nvlsp.capabilities,
--}
-- configuring single server, example: typescript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

--  typescript
lspconfig.ts_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

-- C/C++
lspconfig.clangd.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

-- Configuración para CMake
lspconfig.cmake.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "cmake-language-server" }, -- Comando para iniciar el servidor
  filetypes = { "cmake" },           -- Tipos de archivos que usará el servidor
  init_options = {
    buildDirectory = "build"         -- Directorio de build, puedes modificarlo según tu estructura
  },
  flags = {
    debounce_text_changes = 150, -- Ajuste de cambios de texto
  },
}



-- C#
lspconfig.omnisharp.setup {
  cmd = { "omnisharp" },
  filetypes = { "cs" },
  root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln", ".git"),
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,

}

--  LaTex

lspconfig.texlab.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

--  Bash
--lspconfig.bash_language_server.setup {
--cmd = { 'bash-language-server' },
--on_attach = nvlsp.on_attach,
--on_init = nvlsp.on_init,
--capabilities = nvlsp.capabilities,
--}




--pythonff
--lspconfig.pyright.setup {
--  on_attach = nvlsp.on_attach,
--  on_init = nvlsp.on_init,
--  capabilities = nvlsp.capabilities,
--  filetypes = { "python" },
--  settings = {
--    organizeImports = true,
--    pylint = {
--      plugins = {
--        -- formatter options
--        black = { enabled = false },
--        ruff = { enabled = false },
--        -- autopep8 = { enabled = false },
--        -- yapf = { enabled = false },
--        --
--        -- linter options
--        pylint = { enabled = true }, -- executable = "pylint" },
--        pyright = { enabled = true },
--        -- ruff = { enabled = false },
--        -- pyflakes = { enabled = false },
--        -- pycodestyle = { enabled = false },
--        --
--        -- type checker
--        mypy = {
--          enabled = true,
--          report_progress = true,
--          live_mode = false,
--        },
--        -- auto-completion options
--        -- jedi_completion = { fuzzy = true },
--        --
--        -- import sorting
--        isort = { enabled = true },
--      },
--    },
--    python = {
--      pythonPath = ".venv/bin/python", -- Añade el pythonPath aquí
--    },
--  },
--  flags = {
--    debounce_text_changes = 200,
--  },
--}

-- PYRIGHT - solo para autocompletado y navegación
lspconfig.pyright.setup {
  on_attach = function(client, bufnr)
    -- Desactivar diagnósticos y análisis de pyright
    client.server_capabilities.diagnosticProvider = false
    client.server_capabilities.hoverProvider = true
    client.server_capabilities.completionProvider = true
    nvlsp.on_attach(client, bufnr)
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
        typeCheckingMode = "off",
      },
    },
  },
}


-- RUFF LSP (Rust) - linter + formateador + organizador de imports
lspconfig.ruff.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}



-- PYREFLY (Rust) - type checker
--lspconfig.pyrefly.setup {
  --on_attach = nvlsp.on_attach,
  --on_init = nvlsp.on_init,
  --capabilities = nvlsp.capabilities,
--}