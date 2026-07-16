-- Ancla tus 3-4 archivos de trabajo y salta entre ellos al instante
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      ';a',
      function()
        require('harpoon'):list():add()
        vim.notify('Archivo anclado en Harpoon')
      end,
      desc = 'Harpoon: anclar archivo',
    },
    {
      ';h',
      function()
        local harpoon = require('harpoon')
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = 'Harpoon: menú de anclados',
    },
    { ';1', function() require('harpoon'):list():select(1) end, desc = 'Harpoon: archivo 1' },
    { ';2', function() require('harpoon'):list():select(2) end, desc = 'Harpoon: archivo 2' },
    { ';3', function() require('harpoon'):list():select(3) end, desc = 'Harpoon: archivo 3' },
    { ';4', function() require('harpoon'):list():select(4) end, desc = 'Harpoon: archivo 4' },
  },
  config = function()
    require('harpoon'):setup()
  end,
}
