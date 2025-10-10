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


