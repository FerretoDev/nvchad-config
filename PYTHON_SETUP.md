# Configuración Python Avanzada - NvChad

## 🎯 Arquitectura

### Herramientas y sus roles:

1. **Pyright (LSP)**
   - 🎯 Rol: Autocompletado inteligente, importaciones automáticas, análisis de código
   - ❌ NO hace: Diagnósticos de tipos, formateo, linting
   - 📍 Configurado en: `lua/configs/lspconfig.lua`

2. **Ruff (Linter + Formatter via none-ls)**
   - 🎯 Rol: 
     - Linting de sintaxis y errores
     - Formateo de código (reemplaza black)
     - Organización de imports (reemplaza isort)
   - 📍 Configurado en: `lua/configs/none-ls.lua`

3. **Mypy/Pyrefly (Type Checker via none-ls)**
   - 🎯 Rol: Verificación de tipos estricta
   - 🔄 Puedes alternar entre ambos con `:TogglePythonTypeChecker`
   - 📍 Configurado en: `lua/configs/none-ls.lua`

## 📦 Instalación

1. **Instalar paquetes con Mason:**
   ```vim
   :MasonInstall pyright ruff mypy debugpy
   ```

2. **Instalar none-ls (ya incluido en plugins):**
   Los plugins se instalarán automáticamente con lazy.nvim

3. **Configurar ruff en tu proyecto:**
   Copia el contenido de `ruff-example.toml` a tu `pyproject.toml`

## 🚀 Comandos disponibles

### Formateo
- `:RuffFormat` - Formatear archivo actual con ruff
- `<leader>fm` - Formatear con LSP (atajo de NvChad)
- Auto-formateo al guardar está activado por defecto

### Organización de imports
- `:RuffOrganizeImports` - Organizar imports con ruff

### Type Checking
- `:TogglePythonTypeChecker` - Alternar entre mypy y pyrefly
- `:ShowPythonTypeChecker` - Ver cuál está activo

### LSP General
- `:LspInfo` - Ver servidores LSP activos
- `:LspRestart` - Reiniciar LSP si hay problemas

## ⚙️ Configuración personalizada

### Desactivar auto-formateo al guardar
Edita `lua/configs/none-ls.lua` y comenta esta sección:
```lua
-- on_attach = function(client, bufnr)
--   if client.supports_method("textDocument/formatting") then
--     ...
--   end
-- end,
```

### Usar ruff como LSP en lugar de via none-ls
Edita `lua/configs/lspconfig.lua` y descomenta la sección de ruff LSP

### Cambiar configuración de ruff
Edita tu `pyproject.toml` en la raíz del proyecto

### Configurar mypy strictness
Edita tu `pyproject.toml`:
```toml
[tool.mypy]
strict = true  # o false para menos estricto
```

## 🔍 Troubleshooting

### Ruff no formatea
1. Verifica que ruff esté instalado: `:Mason`
2. Verifica que ruff esté en el PATH: `:echo exepath('ruff')`
3. Reinicia LSP: `:LspRestart`

### Mypy/Pyrefly no muestra errores
1. Verifica instalación: `:Mason`
2. Cambia de type checker: `:TogglePythonTypeChecker`
3. Revisa logs: `:messages`

### Pyright da muchos errores
Es normal - pyright solo hace análisis LSP, no diagnósticos.
Los diagnósticos vienen de ruff y mypy/pyrefly.

## 📊 Flujo de trabajo recomendado

1. **Escribir código**: Pyright te da autocompletado inteligente
2. **Guardar archivo**: Ruff formatea automáticamente
3. **Ver errores**: Ruff muestra errores de sintaxis, mypy/pyrefly de tipos
4. **Antes de commit**: Todo ya está formateado y verificado

## 🎨 Personalización avanzada

### Agregar más formatters/linters
Edita `lua/configs/none-ls.lua` y agrega a la tabla `sources`:
```lua
diagnostics.pylint,  -- Ejemplo: agregar pylint
```

### Usar black en lugar de ruff
1. Desinstala ruff formatter: comenta en none-ls.lua
2. Agrega black formatter:
   ```lua
   formatting.black.with({
     extra_args = { "--fast" }
   }),
   ```

### Keymaps personalizados
Edita `lua/mappings.lua` y agrega:
```lua
vim.keymap.set("n", "<leader>rf", ":RuffFormat<CR>", { desc = "Ruff format" })
vim.keymap.set("n", "<leader>ri", ":RuffOrganizeImports<CR>", { desc = "Ruff organize imports" })
```
