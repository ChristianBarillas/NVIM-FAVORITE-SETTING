return {
  -- Lista bonita de errores/diagnósticos de todo el proyecto
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnósticos del proyecto' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Diagnósticos del buffer' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Lista quickfix' },
      { '<leader>xt', '<cmd>Trouble todo toggle<cr>', desc = 'Lista de TODOs' },
    },
  },

  -- Resalta y lista comentarios TODO / FIXME / HACK / NOTE
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        desc = 'Siguiente TODO',
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        desc = 'TODO anterior',
      },
    },
  },
}
