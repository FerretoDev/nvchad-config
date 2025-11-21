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


