return {
  -- GitHub dentro del editor: PRs, issues, reviews, comentarios
  -- (usa el CLI `gh` ya autenticado)
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    cmd = 'Octo',
    keys = {
      { '<leader>gp', '<cmd>Octo pr list<cr>', desc = 'GitHub: pull requests' },
      { '<leader>gi', '<cmd>Octo issue list<cr>', desc = 'GitHub: issues' },
    },
    opts = {
      enable_builtin = true,
    },
  },

  -- Diffs visuales y historial de archivos (como la vista Source Control)
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
    keys = {
      {
        '<leader>gd',
        function()
          if next(require('diffview.lib').views) then
            vim.cmd('DiffviewClose')
          else
            vim.cmd('DiffviewOpen')
          end
        end,
        desc = 'Diff de cambios (abrir/cerrar)',
      },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Historial del archivo actual' },
    },
    opts = {},
  },
}
