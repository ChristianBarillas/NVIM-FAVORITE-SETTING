return {
  -- Sticky scroll: mantiene visible arriba la función/clase actual
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = { max_lines = 4 },
  },

  -- Paréntesis/llaves/corchetes de colores por nivel (como VS Code)
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
  },

  -- Plegado de código inteligente (LSP) con za/zR/zM
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      vim.o.foldcolumn = '0'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      local ufo = require('ufo')
      ufo.setup({
        provider_selector = function()
          return { 'lsp', 'indent' }
        end,
      })

      vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'Abrir todos los pliegues' })
      vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'Cerrar todos los pliegues' })
      vim.keymap.set('n', 'zp', ufo.peekFoldedLinesUnderCursor, { desc = 'Ver pliegue sin abrirlo' })
    end,
  },

  -- Panel lateral de símbolos del archivo (outline, como Ctrl+Shift+O)
  {
    'stevearc/aerial.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    cmd = { 'AerialToggle', 'AerialOpen' },
    keys = {
      { '<leader>o', '<cmd>AerialToggle!<cr>', desc = 'Outline de símbolos' },
    },
    opts = {
      layout = { default_direction = 'prefer_right', min_width = 28 },
      -- saltar entre símbolos desde el panel con { y }
      keymaps = { ['{'] = 'actions.prev', ['}'] = 'actions.next' },
    },
  },
}
