-- Comandos personalizados para Obsidian y PKM usando APIs nativas Lua (plenary/vim.fs)
local function open_project_note()
  local vault_dir = "/home/maru/Sync/Obsidian/Cloud Files/obsidian-student-vault"
  if vim.fn.isdirectory(vault_dir) == 0 then
    vim.notify("El vault de Obsidian no se encontró en: " .. vault_dir, vim.log.levels.ERROR)
    return
  end

  -- Obtener nombre de la carpeta del proyecto actual
  local cwd = vim.fn.getcwd()
  local project_name = vim.fn.fnamemodify(cwd, ":t")

  -- Búsqueda segura en el vault usando Plenary (sin llamadas a shell de sistema)
  local path = ""
  local ok_scandir, scandir = pcall(require, "plenary.scandir")
  if ok_scandir then
    local files = scandir.scan_dir(vault_dir, {
      search_pattern = "^" .. vim.pesc(project_name) .. "%.md$",
      depth = 5,
    })
    if files and #files > 0 then
      path = files[1]
    end
  else
    -- Fallback portable con vim.fs
    local files = vim.fs.find(project_name .. ".md", { path = vault_dir, limit = 1 })
    if files and #files > 0 then
      path = files[1]
    end
  end

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

-- Captura rápida en la carpeta Inbox (fleeting notes / ideas)
local function capture_inbox_note()
  -- Usamos Zettel-time (YYYY-MM-DD-HHMM) para evitar colisiones y mantener orden temporal
  local note_name = os.date("%Y-%m-%d-%H%M")
  vim.cmd("ObsidianNew " .. note_name)
  vim.notify("Nota de captura rápida creada en Inbox: " .. note_name, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("ObsidianProjectNote", open_project_note, {})
vim.api.nvim_create_user_command("ObsidianCapture", capture_inbox_note, {})
