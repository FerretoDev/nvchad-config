# ⚡ Neovim & NvChad (Coding + Obsidian PKM Config)

Esta es una configuración personalizada de Neovim construida sobre **NvChad v2.5** (utilizando `lazy.nvim`). Su objetivo principal es unificar el entorno de **desarrollo de software** con un sistema de **gestión de conocimiento (PKM)** en Obsidian, permitiendo un flujo de trabajo fluido y guiado por teclado en Fedora Linux.

---

## 🌟 Pilares del Setup

### 1. Entorno de Desarrollo (Coding Mode)

Optimizado principalmente para **Python** (lenguaje principal), desarrollo web y edición científica en **LaTeX**:

- **Python**: Integración rápida con **Ruff** (LSP principal para diagnóstico, linter y formateador) y **Pyright** (configurado en silencio, exclusivamente para autocompletado y saltos de definición sin duplicar advertencias).
- **Format on Save**: Formateo automático al guardar (`conform.nvim`) usando `stylua` para Lua, `ruff` para Python, `prettierd` para HTML/CSS/JS/JSON/Markdown y `clang-format` para C/C++.
- **Edición LaTeX**: Soporte completo con **Vimtex** para compilación en vivo a PDF y navegación estructural de documentos.

### 2. Segundo Cerebro (Knowledge Mode)

Integración nativa con **Obsidian** mediante `obsidian.nvim`:

- Apunta directamente al vault local en `~/Sync/Obsidian/Cloud Files/obsidian-student-vault`.
- Carga perezosa (*lazy-loading*) exclusiva para tipos de archivo `markdown` para evitar ralentizar el inicio del editor en proyectos de código.
- Configuración visual limpia con `conceallevel = 2` para esconder la sintaxis de corchetes y atajos integrados para marcar checkboxes (`<leader>och`).

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
- `gf` ➡️ Seguir enlace de nota (abre archivos locales `file://` dentro de Neovim).

### LaTeX / Documentos (`<leader>l`)

- `<leader>lc` ➡️ Compilar documento continuamente.
- `<leader>lv` ➡️ Ver visor PDF (`zathura`/visor del sistema).
- `<leader>lt` ➡️ Abrir la tabla de contenidos (índice del documento).

---

## 📂 Estructura de Configuración

Para mantener el orden de NvChad, la configuración se divide en módulos Lua:

- [init.lua](file:///home/maru/.config/nvim/init.lua): bootstrap de cargador y llamado a comandos/mapeos.
- [lua/chadrc.lua](file:///home/maru/.config/nvim/lua/chadrc.lua): configuraciones visuales, temas base46 y lista de dependencias Mason.
- [lua/mappings.lua](file:///home/maru/.config/nvim/lua/mappings.lua): atajos de teclado globales y menús Which-Key.
- [lua/custom/commands.lua](file:///home/maru/.config/nvim/lua/custom/commands.lua): comandos personalizados de automatización (Mason, Proyectos, Notas).
- [lua/plugins/](file:///home/maru/.config/nvim/lua/plugins/): declaración individual de plugins (`obsidian.lua`, `cmp.lua`, `copilot.lua`, `vimtex.lua`, etc.).
- [lua/configs/](file:///home/maru/.config/nvim/lua/configs/): configuraciones detalladas de herramientas (`lspconfig.lua`, `conform.lua`, `lint.lua`).
- [ftplugin/markdown.lua](file:///home/maru/.config/nvim/ftplugin/markdown.lua): opciones estéticas e idiomáticas dedicadas para notas markdown.

*Para un desglose completo, consulta el archivo de instrucciones para agentes en [CLAUDE.md](file:///home/maru/.config/nvim/CLAUDE.md).*
