-- Ejecutar NvDash al iniciar Neovim
vim.api.nvim_create_autocmd(
  'VimEnter',
  {
    pattern = '*',
    callback = function()
      vim.cmd('NvDash')  -- Llama al comando NvDash
    end,
  }
)


-- Mason: instalar paquetes definidos en chadrc.lua (M.mason.pkgs)
local function mason_install_all()
  local ok_mason, _ = pcall(require, 'mason')
  if not ok_mason then
    vim.notify('[Mason] mason.nvim no está instalado/cargado', vim.log.levels.ERROR)
    return
  end
  local ok_reg, registry = pcall(require, 'mason-registry')
  if not ok_reg then
    vim.notify('[Mason] mason-registry no disponible', vim.log.levels.ERROR)
    return
  end
  local ok_cfg, cfg = pcall(require, 'chadrc')
  if not ok_cfg or not cfg.mason or not cfg.mason.pkgs then
    vim.notify('[Mason] No se encontró M.mason.pkgs en chadrc.lua', vim.log.levels.WARN)
    return
  end

  local aliases = {
    ['html-lsp'] = 'vscode-langservers-extracted',
    ['css-lsp'] = 'vscode-langservers-extracted',
    ['ruff-lsp'] = 'ruff',
  }

  local total = 0
  local started = 0
  for _, name in ipairs(cfg.mason.pkgs) do
    local reg_name = aliases[name] or name
    total = total + 1
    if registry.has_package(reg_name) then
      local pkg = registry.get_package(reg_name)
      if not pkg:is_installed() then
        pkg:install()
        started = started + 1
      end
    else
      vim.notify('[Mason] Paquete no encontrado en registry: ' .. reg_name .. ' (de ' .. name .. ')', vim.log.levels.WARN)
    end
  end
  vim.notify(string.format('[Mason] Instalaciones iniciadas: %d/%d (si alguno ya estaba instalado, se omite)', started, total), vim.log.levels.INFO)
end

-- Comando principal recomendado
vim.api.nvim_create_user_command('MasonInstallPkgs', mason_install_all, {})

-- Alias compatible si no existe ya
if vim.fn.exists(':MasonInstallAll') == 0 then
  vim.api.nvim_create_user_command('MasonInstallAll', mason_install_all, {})
end


-- =============================================================================
-- 🚀 INTEGRACIÓN CÓDIGO (~/Dev) ↔️ CONOCIMIENTO (Obsidian Vault)
-- =============================================================================

-- 1. Buscador de proyectos en ~/Dev usando Telescope
local function find_projects()
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    vim.notify("[Telescope] no está cargado", vim.log.levels.ERROR)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local dev_dir = vim.fn.expand("~/Dev")
  
  if vim.fn.isdirectory(dev_dir) == 0 then
    vim.notify("El directorio ~/Dev no existe", vim.log.levels.WARN)
    return
  end

  -- fd busca directorios en ~/Dev hasta nivel 2 de profundidad (para incluir subgrupos/clientes)
  local cmd = "fd --type d --max-depth 2 . " .. dev_dir
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()

  local dirs = {}
  for dir in string.gmatch(result, "[^\r\n]+") do
    table.insert(dirs, dir)
  end

  if #dirs == 0 then
    vim.notify("No se encontraron directorios en ~/Dev", vim.log.levels.INFO)
    return
  end

  pickers.new({}, {
    prompt_title = "Proyectos (~/Dev)",
    finder = finders.new_table {
      results = dirs,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry:gsub(dev_dir .. "/", ""),
          ordinal = entry,
        }
      end
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          vim.cmd("cd " .. selection.value)
          vim.notify("CWD cambiado a: " .. selection.value, vim.log.levels.INFO)
          require("telescope.builtin").find_files({ cwd = selection.value })
        end
      end)
      return true
    end,
  }):find()
end

vim.api.nvim_create_user_command("TelescopeProjects", find_projects, {})


-- 2. Abrir/Crear nota específica de Obsidian vinculada al proyecto actual
local function open_project_note()
  local vault_dir = "/home/maru/Sync/Obsidian/Cloud Files/obsidian-student-vault"
  if vim.fn.isdirectory(vault_dir) == 0 then
    vim.notify("El vault de Obsidian no se encontró en: " .. vault_dir, vim.log.levels.ERROR)
    return
  end

  -- Obtener nombre de la carpeta del proyecto actual
  local cwd = vim.fn.getcwd()
  local project_name = vim.fn.fnamemodify(cwd, ":t")

  -- Buscar si existe una nota con ese nombre exacto (.md) en cualquier parte del vault
  local cmd = string.format("fd -i -e md '^%s$' '%s'", project_name, vault_dir)
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()

  local path = result:gsub("%s+$", "")

  if path ~= "" then
    vim.cmd("edit " .. path)
    vim.notify("Abriendo nota de proyecto: " .. project_name, vim.log.levels.INFO)
  else
    local choice = vim.fn.confirm("No existe nota para '" .. project_name .. "' en el vault. ¿Crear nueva?", "&Sí\n&No", 1)
    if choice == 1 then
      vim.cmd("ObsidianNew " .. project_name)
      vim.notify("Creando nueva nota de proyecto: " .. project_name, vim.log.levels.INFO)
    end
  end
end

vim.api.nvim_create_user_command("ObsidianProjectNote", open_project_note, {})


