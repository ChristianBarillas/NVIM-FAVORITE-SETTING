return {
  -- Rodear texto con comillas/paréntesis/etiquetas: ys, cs, ds
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    opts = {},
  },

  -- Salto rápido a cualquier parte visible de la pantalla
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        ';s',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Salto rápido (flash)',
      },
      {
        ';S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Seleccionar por sintaxis (flash)',
      },
    },
  },

  -- Resalta las otras apariciones de la palabra bajo el cursor
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('illuminate').configure({ delay = 200 })
    end,
  },

  -- Detecta automáticamente la indentación del archivo abierto
  {
    'nmac427/guess-indent.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },

  -- Guías de indentación verticales
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      indent = { char = '│' },
      scope = { enabled = false },
    },
  },

  -- Buscar y reemplazar en todo el proyecto con vista previa
  {
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    keys = {
      { '<leader>sr', '<cmd>GrugFar<cr>', desc = 'Buscar y reemplazar en el proyecto' },
    },
    opts = {},
  },
}
