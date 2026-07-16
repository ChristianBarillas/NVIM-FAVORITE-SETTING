return {
  -- Señales de git en el gutter + blame inline (estilo GitLens)
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 700, virt_text_pos = 'eol' },
    },
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
