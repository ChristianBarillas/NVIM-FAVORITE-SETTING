return {
  -- Señales de git en el gutter
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },

  -- Git blame y abrir en GitHub
  {
    'dinhhuy258/git.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('git').setup({
        keymaps = {
          -- Open blame window
          blame = '<Leader>gb',
          -- Open file/folder in git repository
          browse = '<Leader>go',
        },
      })
    end,
  },
}
