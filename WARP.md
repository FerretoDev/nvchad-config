# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a personal Neovim configuration built on NvChad v2.5. NvChad is used as a plugin/framework (from NvChad/NvChad repo), and this repository imports and extends its modules.

## Essential Commands

### Package Management
```bash
# Install packages via Mason (run inside Neovim)
:MasonInstall <package_name>

# View installed packages and available tools
:Mason

# Update lazy.nvim plugins
:Lazy sync
```

### Python Development Workflow
```bash
# Install Python tooling (run in Neovim)
:MasonInstall pyright ruff mypy debugpy

# Format current file with Ruff
:RuffFormat

# Organize imports
:RuffOrganizeImports

# Toggle between mypy and pyrefly type checkers
:TogglePythonTypeChecker

# Check which type checker is active
:ShowPythonTypeChecker

# General LSP commands
:LspInfo        # View active LSP servers
:LspRestart     # Restart LSP if issues occur
```

### Lua Formatting
```bash
# Format Lua files with stylua (from repository root)
stylua lua/ init.lua
```

### LaTeX Commands (VimTeX)
All LaTeX commands use `<leader>l` prefix (leader = space):
- `:VimtexCompile` - Compile document
- `:VimtexView` - View PDF
- `:VimtexClean` - Clean auxiliary files

### Obsidian Commands
All Obsidian commands use `<leader>o` prefix:
- `:ObsidianNew` - Create new note
- `:ObsidianToday` - Open daily note
- `:ObsidianBacklinks` - View backlinks

## Architecture

### Configuration Structure

```
init.lua                    # Entry point: bootstraps lazy.nvim, loads theme and core modules
lua/
├── chadrc.lua             # NvChad configuration (theme, Mason packages)
├── options.lua            # Vim options (extends NvChad defaults)
├── mappings.lua           # Key mappings (extends NvChad defaults)
├── configs/               # Tool-specific configurations
│   ├── lazy.lua          # Lazy.nvim plugin manager settings
│   ├── lspconfig.lua     # LSP server configurations
│   ├── none-ls.lua       # Formatters/linters integration (null-ls fork)
│   └── conform.lua       # Code formatting configuration
└── plugins/               # Plugin specifications
    ├── init.lua          # Core plugins list
    ├── obsidian.lua      # Obsidian.nvim for note-taking
    ├── vimtex.lua        # LaTeX support
    ├── cmp.lua           # Completion configuration
    ├── carbon.lua        # Code screenshot generation
    ├── supermaven.lua    # AI completion
    └── which-key.lua     # Keybinding hints
```

### Python Tooling Architecture

This configuration uses a **specialized Python setup** with clear separation of concerns:

1. **Pyright (LSP)** - Handles ONLY:
   - Intelligent autocompletion
   - Auto-imports
   - Code navigation
   - Type inference for completion
   - **NOT** used for: diagnostics, type checking, formatting

2. **Ruff (via LSP in lspconfig.lua)** - Handles:
   - Linting (syntax errors, code quality)
   - Code formatting (replaces black)
   - Import organization (replaces isort)

3. **Mypy/Pyrefly (via none-ls)** - Handles:
   - Strict type checking
   - Switchable between mypy and pyrefly using `:TogglePythonTypeChecker`

**Key Design Decision**: Pyright has diagnostics explicitly disabled (`typeCheckingMode = "off"`, `diagnosticProvider = false`) to avoid redundant/conflicting errors. All diagnostics come from Ruff and mypy/pyrefly through none-ls.

### LSP Configuration Pattern

All LSP servers in `configs/lspconfig.lua` follow this pattern:
```lua
lspconfig.<server>.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  -- server-specific settings
}
```

Configured LSP servers: lua_ls, html, cssls, ts_ls, marksman, clangd, texlab, pyright, ruff, omnisharp

### Plugin Loading Strategy

- Core NvChad plugins loaded via `{ import = "nvchad.plugins" }`
- Custom plugins loaded via `{ import = "plugins" }`
- Lazy loading enabled for most plugins (lazy = true by default)
- Obsidian.nvim lazy-loads on markdown files
- VimTeX loads immediately for .tex files
- none-ls loads on VeryLazy event

### Mason Package Management

All language tools are installed via Mason (defined in `lua/chadrc.lua`). Mason bin path is added to PATH in both lspconfig.lua and none-ls.lua:
```lua
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
```

### Theme and UI

- Base theme: `ayu_dark` (configurable in `lua/chadrc.lua`)
- Uses NvChad's base46 theme system
- Comments rendered in italics via highlight overrides
- NvDash dashboard loads on startup

## Language-Specific Notes

### Python
- **IMPORTANT**: When editing Python LSP config, never enable Pyright diagnostics - this causes duplicate/conflicting errors
- To customize Ruff behavior, create `pyproject.toml` in your project root (see `ruff-example.toml`)
- Auto-format on save is enabled by default (configured in none-ls.lua)
- Type checker can be switched dynamically without restarting Neovim

### Lua
- Formatted with stylua using settings from `.stylua.toml`
- 2-space indentation, 120 column width
- Auto-prefer double quotes

### LaTeX
- Compiler: latexmk
- Viewer: zathura
- Quickfix mode disabled for cleaner interface

### Markdown (Obsidian)
- Vault path: `/mnt/c/Users/marco/OneDrive - MSFT/Obsidian/Cloud Files/obsidian-student-vault`
- New notes location: `000 - Inbox`
- Templates directory: `z - Templates`
- Note IDs use Zettelkasten format: `timestamp-title`
- Checkbox toggle available via `<leader>och`

## Common Patterns

### Adding a New Language Server
1. Add to Mason packages in `lua/chadrc.lua`
2. Configure in `lua/configs/lspconfig.lua` using the standard pattern
3. Run `:MasonInstall <package_name>` or restart Neovim

### Adding a New Formatter/Linter
1. Install via Mason
2. Add to `sources` table in `lua/configs/none-ls.lua`
3. Use `null_ls.builtins.formatting.<tool>` or `null_ls.builtins.diagnostics.<tool>`

### Adding Custom Keymaps
Add to `lua/mappings.lua` using the pattern:
```lua
local map = vim.keymap.set
map("n", "<leader>xx", "<cmd>Command<cr>", { desc = "Description for which-key" })
```

## Special Files

- `PYTHON_SETUP.md` - Comprehensive Spanish documentation of Python tooling architecture
- `ruff-example.toml` - Example Ruff configuration for pyproject.toml
- `lazy-lock.json` - Plugin version lockfile (gitignored)
- `.stylua.toml` - Lua formatting rules

## Troubleshooting

### LSP Issues
1. Check active servers: `:LspInfo`
2. Verify Mason installation: `:Mason`
3. Check tool availability: `:echo exepath('tool_name')`
4. Restart LSP: `:LspRestart`
5. View logs: `:messages`

### Python Formatting Not Working
- Ensure Ruff is installed in Mason
- Verify Ruff LSP is running via `:LspInfo`
- Check for project-level Ruff config conflicts
- Manually format with `:RuffFormat`

### Plugin Issues
- Sync plugins: `:Lazy sync`
- Check plugin status: `:Lazy`
- Clear plugin cache and reinstall: `:Lazy clean` then `:Lazy sync`
