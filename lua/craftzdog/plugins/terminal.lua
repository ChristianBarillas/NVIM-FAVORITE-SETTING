-- Terminal integrada flotante + LazyGit
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = 'ToggleTerm',
  keys = {
    { [[<C-\>]], desc = 'Terminal integrada' },
    { '<leader>gg', desc = 'LazyGit' },
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
    vim.keymap.set('n', '<leader>gg', function()
      lazygit:toggle()
    end, { desc = 'LazyGit' })
  end,
}
