-- Terminal integrada flotante + LazyGit
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = { 'ToggleTerm', 'LazyGit' },
  keys = {
    { [[<C-\>]], desc = 'Terminal integrada' },
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Terminal flotante' },
    { '<leader>th', '<cmd>ToggleTerm size=15 direction=horizontal<cr>', desc = 'Terminal horizontal' },
    { '<leader>tv', '<cmd>ToggleTerm size=60 direction=vertical<cr>', desc = 'Terminal vertical' },
  },
  config = function()
    require('toggleterm').setup({
      open_mapping = [[<C-\>]],
      direction = 'float',
      float_opts = { border = 'rounded' },
    })

    -- Esc Esc para pasar la terminal a modo normal
    vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Terminal a modo normal' })

    -- LazyGit en ventana flotante (requiere: brew install lazygit)
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = 'lazygit',
      hidden = true,
      direction = 'float',
      float_opts = { border = 'rounded' },
    })
    vim.api.nvim_create_user_command('LazyGit', function()
      lazygit:toggle()
    end, { desc = 'Abrir/cerrar LazyGit' })
  end,
}
