# ⚡ Neovim & NvChad (Coding + Obsidian PKM Config)

Esta es una configuración personalizada de Neovim construida sobre **NvChad v2.5** (utilizando `lazy.nvim`). Su objetivo principal es unificar el entorno de **desarrollo de software** con un sistema de **gestión de conocimiento (PKM)** en Obsidian, permitiendo un flujo de trabajo fluido y guiado por teclado en Fedora Linux.

---

## 🌟 Pilares del Setup

### 1. Entorno de Desarrollo (Coding Mode)

Optimizado principalmente para **Python** (lenguaje principal), desarrollo web y edición científica en **LaTeX**:

- **Python**: Integración rápida con **Ruff** (LSP principal para diagnóstico, linter y formateador) y **Pyright** (configurado en silencio, exclusivamente para autocompletado y saltos de definición sin duplicar advertencias).
- **Herramientas Python**: Selección interactiva de entornos virtuales (`venv-selector.nvim`), depuración con **DAP** (`nvim-dap-python` + `debugpy`) y suite de pruebas (`neotest` + `neotest-python`).
- **Format on Save**: Formateo automático al guardar (`conform.nvim`) usando `stylua` para Lua, `ruff` para Python, `prettierd` para HTML/CSS/JS/JSON/Markdown y `clang-format` para C/C++.
- **Edición LaTeX**: Soporte completo con **Vimtex** para compilación en vivo a PDF y navegación estructural de documentos.

### 2. Segundo Cerebro (Knowledge Mode)

Integración nativa con **Obsidian** mediante `obsidian.nvim`:

- Apunta directamente al vault local en `~/Sync/Obsidian/Cloud Files/obsidian-student-vault`.
- Carga perezosa (_lazy-loading_) exclusiva para tipos de archivo `markdown` para evitar ralentizar el inicio del editor en proyectos de código.
- Configuración visual limpia con `conceallevel = 2` para esconder sintaxis de corchetes, y renderizado estético de tablas, checkboxes, callouts y bloques de código usando `render-markdown.nvim` (la interfaz visual de `obsidian.nvim` se ha desactivado para evitar conflictos).
- Atajos integrados para marcar checkboxes (`<leader>och`).

### 3. Puente Código ↔️ Conocimiento

Automatizaciones personalizadas para conectar tus proyectos en `~/Dev` con tus notas de investigación:

- **Telescope Projects (`<leader>fp`)**: Explora y salta rápidamente a directorios en `~/Dev`, cambia el directorio de trabajo actual (CWD) en Neovim y abre el buscador de archivos.
- **Project Note (`<leader>opn`)**: Comando inteligente que detecta el nombre de tu proyecto actual de código, busca su archivo `.md` técnico correspondiente en tu vault de Obsidian y lo abre. Si no existe, ofrece crearlo con tus plantillas.
- **Navegación Local Inteligente (`gf`)**: Si estás en una nota en Neovim y pulsas `gf` sobre un enlace a un archivo local (ej. `file:///home/maru/Dev/proyecto/main.py`), Neovim abrirá el código fuente directamente en un buffer nativo en lugar de invocar una aplicación externa.

---

## 🎹 Atajos de Teclado Esenciales

### Navegación y Proyectos

- `;` ➡️ Modo Comando (`:`)
- `jk` ➡️ Modo Normal (`<ESC>`)
- `<leader>fp` ➡️ Selector de proyectos en `~/Dev` con Telescope.

### Obsidian / Notas (`<leader>o`)

- `<leader>of` ➡️ Buscar texto completo dentro de las notas (`ObsidianSearch`).
- `<leader>os` ➡️ Cambiar de nota rápido por su título (`ObsidianQuickSwitch`).
- `<leader>opn` ➡️ Abrir/Crear nota técnica para el proyecto de desarrollo activo.
- `<leader>ot` ➡️ Ir a la nota diaria (Daily Note).
- `<leader>onn` / `<leader>ont` ➡️ Crear nota nueva (vacía o desde plantilla).
- `<leader>oc` ➡️ Captura rápida de ideas/fleeting notes en Inbox.
- `gf` ➡️ Seguir enlace de nota (abre archivos locales `file://` dentro de Neovim).

### LaTeX / Documentos (`<leader>l`)

- `<leader>lc` ➡️ Compilar documento continuamente.
- `<leader>lv` ➡️ Ver visor PDF (`zathura`/visor del sistema).
- `<leader>lt` ➡️ Abrir la tabla de contenidos (índice del documento).

### Python (Entornos, Depuración y Tests)

- `<leader>vs` ➡️ Seleccionar entorno virtual (VenvSelect).
- `<leader>db` ➡️ Alternar Breakpoint (DAP).
- `<leader>dc` ➡️ Continuar depuración.
- `<leader>di` / `<leader>do` ➡️ Paso adentro / Paso sobre.
- `<leader>dt` ➡️ Terminar depuración.
- `<leader>du` ➡️ Mostrar/ocultar panel de depuración (DAP UI).
- `<leader>tn` / `<leader>tf` ➡️ Correr test cercano / test de archivo (Neotest).
- `<leader>ts` ➡️ Mostrar panel resumen de tests.

---

## 📂 Estructura de Configuración

Para mantener el orden de NvChad y evitar deuda técnica, la configuración se organiza de forma modular:

- [init.lua](file:///home/maru/.config/nvim/init.lua): Punto de entrada. Bootstrapea `lazy.nvim` y carga mapeos y comandos.
- [lua/chadrc.lua](file:///home/maru/.config/nvim/lua/chadrc.lua): Configuraciones visuales, temas base46 y dependencias de Mason.
- [lua/mappings.lua](file:///home/maru/.config/nvim/lua/mappings.lua): Punto de entrada que carga los atajos de teclado modulares de la carpeta `lua/mappings/`.
- 📂 [lua/mappings/](file:///home/maru/.config/nvim/lua/mappings/): Atajos separados por áreas ([general.lua](file:///home/maru/.config/nvim/lua/mappings/general.lua), [projects.lua](file:///home/maru/.config/nvim/lua/mappings/projects.lua), [obsidian.lua](file:///home/maru/.config/nvim/lua/mappings/obsidian.lua), [latex.lua](file:///home/maru/.config/nvim/lua/mappings/latex.lua), [dap.lua](file:///home/maru/.config/nvim/lua/mappings/dap.lua)).
- [lua/custom/commands.lua](file:///home/maru/.config/nvim/lua/custom/commands.lua): Punto de entrada que carga las automatizaciones de la carpeta `lua/custom/commands/`.
- 📂 [lua/custom/commands/](file:///home/maru/.config/nvim/lua/custom/commands/): Lógica de comandos separada ([autocmds.lua](file:///home/maru/.config/nvim/lua/custom/commands/autocmds.lua), [mason.lua](file:///home/maru/.config/nvim/lua/custom/commands/mason.lua), [projects.lua](file:///home/maru/.config/nvim/lua/custom/commands/projects.lua), [obsidian.lua](file:///home/maru/.config/nvim/lua/custom/commands/obsidian.lua)).
- [lua/plugins/](file:///home/maru/.config/nvim/lua/plugins/): Declaración individual y lazy-loading de plugins externos.
- [lua/configs/](file:///home/maru/.config/nvim/lua/configs/): Configuraciones detalladas de herramientas core del editor (LSP, conform, linting).
- [ftplugin/markdown.lua](file:///home/maru/.config/nvim/ftplugin/markdown.lua): Reglas estéticas y de corrección ortográfica aplicadas exclusivamente a notas Markdown.

_Para un desglose técnico completo, consulta el archivo de instrucciones para agentes en [CLAUDE.md](file:///home/maru/.config/nvim/CLAUDE.md)._
