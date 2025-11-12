-- none-ls: Integración de herramientas externas para formateo y linting
local null_ls = require("null-ls")

-- Agregar Mason bin al PATH para que none-ls encuentre las herramientas
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

-- Variable global para controlar qué type checker está activo
_G.python_type_checker = "mypy" -- Opciones: "mypy" o "pyrefly"

-- Helpers para formatters y diagnostics
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- Función para obtener el type checker activo dinámicamente
local function get_type_checker_source()
  if _G.python_type_checker == "mypy" then
    return diagnostics.mypy.with({
      extra_args = function()
        return {
          "--show-column-numbers",
          "--show-error-end",
          "--hide-error-codes",
          "--no-color-output",
          "--no-error-summary",
          "--no-pretty",
        }
      end,
    })
  elseif _G.python_type_checker == "pyrefly" then
    -- Pyrefly/pyrightfly (puede requerir ajustes según tu instalación)
    return diagnostics.pylint.with({
      -- Ajusta según cómo ejecutes pyrefly
      command = "pyrefly",
      args = { "$FILENAME" },
    })
  end
  return nil
end

-- Configuración de none-ls
null_ls.setup({
  debug = false,
  sources = {
    -- ============ PYTHON ============
    
    -- RUFF: Se usa como LSP (configurado en lspconfig.lua)
    -- No como builtin de none-ls porque no está disponible
    
    -- TYPE CHECKER: Mypy (dinámico - puede cambiar a pyrefly con :TogglePythonTypeChecker)
    diagnostics.mypy.with({
      extra_args = function()
        -- Solo ejecutar si es el type checker activo
        if _G.python_type_checker ~= "mypy" then
          return nil
        end
        return {
          "--show-column-numbers",
          "--show-error-end",
          "--no-color-output",
          "--no-error-summary",
          "--no-pretty",
        }
      end,
      -- Solo ejecutar si mypy está activo
      condition = function()
        return _G.python_type_checker == "mypy"
      end,
    }),

    -- ============ OTROS LENGUAJES ============
    
    -- Lua (si tienes stylua instalado)
    formatting.stylua,

    -- JavaScript/TypeScript (si tienes prettier instalado)
    formatting.prettier.with({
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "html", "css", "markdown" },
    }),

    -- C/C++ (si tienes clang-format instalado)
    -- formatting.clang_format,

    -- Shell (comentado - descomentar si instalas shellcheck y shfmt)
    -- diagnostics.shellcheck,
    -- formatting.shfmt,
  },

  -- Formateo automático al guardar
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      -- Autoformateo al guardar
      local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})

-- ============ COMANDOS PERSONALIZADOS ============

-- Comando para cambiar entre mypy y pyrefly
vim.api.nvim_create_user_command("TogglePythonTypeChecker", function()
  if _G.python_type_checker == "mypy" then
    _G.python_type_checker = "pyrefly"
    vim.notify("Type checker cambiado a: pyrefly", vim.log.levels.INFO)
  else
    _G.python_type_checker = "mypy"
    vim.notify("Type checker cambiado a: mypy", vim.log.levels.INFO)
  end
  
  -- Reiniciar none-ls para aplicar cambios
  -- Buscar el cliente de none-ls y reiniciarlo
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == "null-ls" then
      vim.cmd("LspRestart " .. client.id)
      vim.notify("none-ls reiniciado", vim.log.levels.INFO)
      return
    end
  end
  
  -- Si no se encuentra, intentar reiniciar todos los LSP de Python
  vim.notify("Reiniciando LSP... Cierra y vuelve a abrir el archivo", vim.log.levels.WARN)
end, { desc = "Alternar entre mypy y pyrefly para type checking" })

-- Comando para ver qué type checker está activo
vim.api.nvim_create_user_command("ShowPythonTypeChecker", function()
  vim.notify("Type checker activo: " .. _G.python_type_checker, vim.log.levels.INFO)
end, { desc = "Mostrar type checker activo (mypy o pyrefly)" })

-- Comando para formatear manualmente con ruff
vim.api.nvim_create_user_command("RuffFormat", function()
  vim.lsp.buf.format({ 
    filter = function(client)
      return client.name == "null-ls"
    end
  })
end, { desc = "Formatear con Ruff" })

-- Comando para organizar imports con ruff
vim.api.nvim_create_user_command("RuffOrganizeImports", function()
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeImports" } },
    apply = true,
  })
end, { desc = "Organizar imports con Ruff" })
