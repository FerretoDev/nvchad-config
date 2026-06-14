# CLAUDE.md — Guía del Proyecto de Configuración de Neovim

Este repositorio contiene una configuración personalizada de Neovim basada en **NvChad v2.5**. Está optimizada para programación en general (especialmente Python), escritura académica en LaTeX y gestión de conocimiento (PKM) mediante Obsidian.

---

## 🛠️ Comandos Frecuentes de Neovim

- **Abrir el editor**: `nvim`
- **Gestión de Plugins (Lazy)**:
  - Ver estado de plugins: `:Lazy`
  - Actualizar/Sincronizar plugins: `:Lazy sync`
  - Limpiar plugins no utilizados: `:Lazy clean`
- **Gestión de Herramientas Externas (LSP/Formatters/Linters)**:
  - Abrir Mason: `:Mason`
  - Ver estado de formateo: `:ConformInfo`
- **Comandos de Obsidian**:
  - Buscar nota (contenido): `:ObsidianSearch`
  - Cambiar de nota rápido (título): `:ObsidianQuickSwitch`
  - Nueva nota: `:ObsidianNew` o `:ObsidianNewFromTemplate`
  - Abrir nota en la app de Obsidian: `:ObsidianOpen`
  - Vincular/abrir nota de proyecto: `:ObsidianProjectNote`
- **Comandos de Proyectos**:
  - Buscar y cambiar de proyecto: `:TelescopeProjects`

---

## 🎹 Mapeos de Teclado Clave

### Generales y Proyectos

- `;` ➡️ `:` (Entrar a modo comando rápidamente)
- `jk` ➡️ `<ESC>` (Salir de modo inserción)
- `<leader>fp` ➡️ Abrir lista de proyectos en `~/Dev` con Telescope, cambiar de directorio y buscar archivos en el proyecto seleccionado.

### Obsidian (`<leader>o`)

- `<leader>onn` ➡️ Crear nueva nota sin plantilla
- `<leader>ont` ➡️ Crear nueva nota desde plantilla
- `<leader>of` ➡️ Buscar notas por contenido (`ObsidianSearch`)
- `<leader>os` ➡️ Buscar notas por título (`ObsidianQuickSwitch`)
- `<leader>ob` ➡️ Ver backlinks de la nota actual
- `<leader>ot` ➡️ Abrir/Crear nota diaria (Daily Note)
- `<leader>ol` ➡️ Ver enlaces salientes
- `<leader>oo` ➡️ Abrir en la app de Obsidian
- `<leader>os` ➡️ Buscar notas por título (`ObsidianQuickSwitch`)
- `<leader>oi` ➡️ Insertar plantilla
- `<leader>opn` ➡️ Abrir/Crear nota técnica vinculada al proyecto actual (`ObsidianProjectNote`)
- `<leader>oc` ➡️ Captura rápida de ideas en Inbox (`ObsidianCapture`)
- `<leader>och` ➡️ Alternar checkbox (`- [ ]` ↔️ `- [x]`) en buffers de Obsidian
- `gf` ➡️ Seguir enlace de Obsidian (bajo el cursor). Si el enlace es un archivo local (`file:///...`), se abrirá directamente en un buffer de Neovim.

### LaTeX & Vimtex (`<leader>l`)

- `<leader>lc` ➡️ Iniciar compilación continua a PDF
- `<leader>lv` ➡️ Ver PDF generado
- `<leader>le` ➡️ Mostrar errores de compilación
- `<leader>ls` ➡️ Detener la compilación
- `<leader>lt` ➡️ Abrir el índice/TOC (Table of Contents)
- `<leader>lk` ➡️ Limpiar archivos auxiliares de LaTeX
- **Ecuaciones y Entornos**:
  - `<leader>lmi` ➡️ Insertar ecuación en línea (`$$`)
  - `<leader>lmb` ➡️ Insertar ecuación en bloque (`$$ \n $$`)
  - `<leader>ln` ➡️ Crear nuevo entorno LaTeX (`\begin{} ... \end{}`)

### Python (Depuración y Tests)

- `<leader>vs` ➡️ Seleccionar entorno virtual Python (`VenvSelect`)
- `<leader>db` ➡️ Alternar Breakpoint (`DapToggleBreakpoint`)
- `<leader>dc` ➡️ Continuar depuración (`DapContinue`)
- `<leader>di` ➡️ Paso Adentro (`DapStepInto`)
- `<leader>do` ➡️ Paso Sobre (`DapStepOver`)
- `<leader>dt` ➡️ Terminar depuración (`DapTerminate`)
- `<leader>du` ➡️ Alternar panel gráfico de depuración (`DapUiToggle`)
- `<leader>tn` ➡️ Correr test cercano (Neotest)
- `<leader>tf` ➡️ Correr test en el archivo actual (Neotest)
- `<leader>ts` ➡️ Alternar resumen visual de tests (Neotest)

---

## 🎨 Pautas de Estilo y Formateo

### Lenguajes y Formateadores

El formateo se ejecuta automáticamente al guardar (`BufWritePre` mediante `conform.nvim`):

- **Lua**: Formateado con **Stylua** (regido por [.stylua.toml](file:///home/maru/.config/nvim/.stylua.toml)).
- **Python**: Formateado con **Ruff** (`ruff_organize_imports` y `ruff_format`).
- **Markdown / HTML / CSS / JS / TS / JSON**: Formateado con **Prettierd** (o **Prettier** como alternativa).
- **C / C++**: Formateado con **Clang-format**.

### Linting

El linting se ejecuta en tiempo real en los eventos `BufEnter`, `BufWritePost` e `InsertLeave` (`nvim-lint`):

- **Python**: Delegado enteramente a **Ruff** (a través de LSP para máxima velocidad).
- **Javascript / Typescript**: Utiliza **eslint_d**.
- **Shell**: Utiliza **shellcheck**.

---

## 📂 Arquitectura del Proyecto

### Archivos de la Raíz

- [init.lua](file:///home/maru/.config/nvim/init.lua): Punto de entrada principal. Carga el gestor de plugins `lazy.nvim` y los submódulos de configuración.
- [lazy-lock.json](file:///home/maru/.config/nvim/lazy-lock.json): Archivo generado por `lazy.nvim` que fija las versiones exactas (hashes) de los plugins instalados.
- [.stylua.toml](file:///home/maru/.config/nvim/.stylua.toml): Configuración de formateo para código Lua usando StyLua.
- [ruff-example.toml](file:///home/maru/.config/nvim/ruff-example.toml): Ejemplo de reglas y configuración para Ruff (linter/formateador de Python).
- [PYTHON_SETUP.md](file:///home/maru/.config/nvim/PYTHON_SETUP.md): Guía de referencia sobre cómo configurar herramientas de Python en el entorno.
- [README.md](file:///home/maru/.config/nvim/README.md): Documentación general de uso e inicio rápido de la configuración.
- [LICENSE](file:///home/maru/.config/nvim/LICENSE): Términos de licencia del repositorio.

### Carpetas y Módulos de Configuración

#### 📂 [ftplugin/](file:///home/maru/.config/nvim/ftplugin/)

Contiene archivos de configuración específicos de tipos de archivo (filetypes). Neovim los carga de manera automática.

- [markdown.lua](file:///home/maru/.config/nvim/ftplugin/markdown.lua): Habilita `conceallevel = 2` para esconder enlaces raw de Obsidian, activa el ajuste de línea (`wrap`) y el corrector ortográfico (`spell`).

#### 📂 [lua/](file:///home/maru/.config/nvim/lua/)

Directorio raíz del código Lua de la configuración.

- [options.lua](file:///home/maru/.config/nvim/lua/options.lua): Opciones globales de configuración de Neovim (`vim.opt`).
- [mappings.lua](file:///home/maru/.config/nvim/lua/mappings.lua): Punto de entrada y cargador modular de mapeos de teclado.
- [chadrc.lua](file:///home/maru/.config/nvim/lua/chadrc.lua): Archivo central para modificar y extender NvChad (estética de autocompletado, temas base46 y paquetes de Mason).

#### 📂 [lua/mappings/](file:///home/maru/.config/nvim/lua/mappings/)

Módulos individuales de atajos de teclado del usuario.

- [general.lua](file:///home/maru/.config/nvim/lua/mappings/general.lua): Atajos generales y del menú contextual del ratón.
- [projects.lua](file:///home/maru/.config/nvim/lua/mappings/projects.lua): Atajos para la navegación de directorios de desarrollo.
- [obsidian.lua](file:///home/maru/.config/nvim/lua/mappings/obsidian.lua): Atajos para el vault, búsqueda, plantillas e Inbox.
- [latex.lua](file:///home/maru/.config/nvim/lua/mappings/latex.lua): Atajos para Vimtex y matemáticas.
- [dap.lua](file:///home/maru/.config/nvim/lua/mappings/dap.lua): Atajos para depuración con nvim-dap y debugpy.

#### 📂 [lua/configs/](file:///home/maru/.config/nvim/lua/configs/)

Configuraciones específicas para herramientas externas e integraciones core.

- [lazy.lua](file:///home/maru/.config/nvim/lua/configs/lazy.lua): Configuración de comportamiento y UI del gestor de plugins `lazy.nvim`.
- [conform.lua](file:///home/maru/.config/nvim/lua/configs/conform.lua): Configura el formateo automático al guardar archivos (`format_on_save`) asociando formateadores específicos (Ruff, StyLua, Prettier, etc.) a cada extensión.
- [lint.lua](file:///home/maru/.config/nvim/lua/configs/lint.lua): Define linters por tipo de archivo usando `nvim-lint`.
- [lspconfig.lua](file:///home/maru/.config/nvim/lua/configs/lspconfig.lua): Configuración de los servidores de lenguaje (LSP). Configura Pyright en modo silencioso y delega diagnósticos a Ruff.
- [none-ls.lua](file:///home/maru/.config/nvim/lua/configs/none-ls.lua): Configuración de `null-ls` para inyectar formateadores/linters tradicionales como fuentes de diagnóstico.
- [ruff-spanish.lua](file:///home/maru/.config/nvim/lua/configs/ruff-spanish.lua): Script personalizado para traducir y localizar al español las advertencias del linter de Ruff.

#### 📂 [lua/custom/](file:///home/maru/.config/nvim/lua/custom/)

Secuencias de comandos y utilidades propias no integradas en NvChad core.

- [commands.lua](file:///home/maru/.config/nvim/lua/custom/commands.lua): Punto de entrada y cargador modular de comandos de automatización.

#### 📂 [lua/custom/commands/](file:///home/maru/.config/nvim/lua/custom/commands/)

Comandos y utilidades específicas modularizadas.

- [autocmds.lua](file:///home/maru/.config/nvim/lua/custom/commands/autocmds.lua): Autocomandos generales (ej. NvDash en VimEnter).
- [mason.lua](file:///home/maru/.config/nvim/lua/custom/commands/mason.lua): Comandos de instalación automática de Mason (`MasonInstallAll`).
- [projects.lua](file:///home/maru/.config/nvim/lua/custom/commands/projects.lua): Buscador de directorios en `~/Dev` implementado con la API `vim.fs`.
- [obsidian.lua](file:///home/maru/.config/nvim/lua/custom/commands/obsidian.lua): Localizador inteligente de notas con `plenary.scandir` y generador de notas rápidas para captura.

#### 📂 [lua/plugins/](file:///home/maru/.config/nvim/lua/plugins/)

Definición, procedencia y condiciones de carga (_lazy-loading_) de los plugins de Neovim.

- [init.lua](file:///home/maru/.config/nvim/lua/plugins/init.lua): Archivo de carga que registra los plugins integrados de NvChad e importa recursivamente el resto de plugins modulares de la carpeta.
- [cmp.lua](file:///home/maru/.config/nvim/lua/plugins/cmp.lua): Configuración detallada de `nvim-cmp` (prioridad de fuentes de autocompletado e integración de Obsidian).
- [obsidian.lua](file:///home/maru/.config/nvim/lua/plugins/obsidian.lua): Configuración y opciones de ruta del espacio de notas (`obsidian-student-vault`) e interceptor para abrir links `file://` en buffers de Neovim.
- [copilot.lua](file:///home/maru/.config/nvim/lua/plugins/copilot.lua): Configuración de GitHub Copilot (desactivado de manera predeterminada en markdown y texto).
- [supermaven.lua](file:///home/maru/.config/nvim/lua/plugins/supermaven.lua): Configuración de Supermaven (actualmente deshabilitado).
- [vimtex.lua](file:///home/maru/.config/nvim/lua/plugins/vimtex.lua): Configuración del entorno de edición y previsualización de documentos LaTeX.
- [which-key.lua](file:///home/maru/.config/nvim/lua/plugins/which-key.lua): Configuración visual del menú flotante de recordatorios de comandos.
- [lspkind.lua](file:///home/maru/.config/nvim/lua/plugins/lspkind.lua): Añade pictogramas estéticos del estilo de VS Code al menú de autocompletado.
- [carbon.lua](file:///home/maru/.config/nvim/lua/plugins/carbon.lua): Mapeo y opciones para exportar hermosas capturas de pantalla de código usando Carbon.sh.
- [render-markdown.lua](file:///home/maru/.config/nvim/lua/plugins/render-markdown.lua): Embellecedor visual para tablas, checkbox, headers y bloques de código de Obsidian.

---

## 🦖 Modo Caveman (Eficiencia de Tokens)

Para optimizar comunicación y ahorrar tokens, asistente usa **Modo Caveman (nivel full)** al responder. Estilo ultra-terse en prosa, mantiene código exacto.
