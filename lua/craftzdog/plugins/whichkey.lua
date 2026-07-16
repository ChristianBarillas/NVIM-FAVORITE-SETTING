-- Muestra los atajos disponibles mientras escribes (clave para aprender)
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'modern',
    spec = {
      { '<leader>c', group = 'Código' },
      { '<leader>d', group = 'Debug' },
      { '<leader>g', group = 'Git/GitHub' },
      { '<leader>m', group = 'Multicursor' },
      { '<leader>q', group = 'Sesión' },
      { '<leader>s', group = 'Buscar/Reemplazar' },
      { '<leader>t', group = 'Terminal' },
      { '<leader>x', group = 'Diagnósticos' },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ global = false })
      end,
      desc = 'Atajos del buffer actual',
    },
  },
}
