-- Autocomandos personalizados del usuario
vim.api.nvim_create_autocmd(
  'VimEnter',
  {
    pattern = '*',
    callback = function()
      vim.cmd('NvDash')
    end,
  }
)
