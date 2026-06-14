-- Buscador y gestor de proyectos en ~/Dev usando Telescope y vim.fs (sin popen shell)
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

  -- Usamos la API de Neovim vim.fs para encontrar directorios de manera segura y portable (evita inyecciones de shell)
  local dirs = {}
  for name, type in vim.fs.dir(dev_dir) do
    if type == "directory" then
      local path = dev_dir .. "/" .. name
      table.insert(dirs, path)
      
      -- Profundidad 2: Buscar subcarpetas (ej. ~/Dev/organizacion/proyecto)
      pcall(function()
        for subname, subtype in vim.fs.dir(path) do
          if subtype == "directory" and not subname:match("^%.") then
            table.insert(dirs, path .. "/" .. subname)
          end
        end
      end)
    end
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
