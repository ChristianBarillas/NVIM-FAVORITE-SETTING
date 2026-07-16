-- Guarda y restaura sesiones por carpeta de proyecto
return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {},
  keys = {
    {
      '<leader>qs',
      function()
        require('persistence').load()
      end,
      desc = 'Restaurar sesión del proyecto',
    },
    {
      '<leader>ql',
      function()
        require('persistence').load({ last = true })
      end,
      desc = 'Restaurar última sesión',
    },
    {
      '<leader>qd',
      function()
        require('persistence').stop()
      end,
      desc = 'No guardar esta sesión',
    },
  },
}
