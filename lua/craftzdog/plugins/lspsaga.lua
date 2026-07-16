return {
  'nvimdev/lspsaga.nvim', -- antes glepnir/lspsaga.nvim
  event = 'LspAttach',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('lspsaga').setup({
      ui = {
        border = 'rounded',
      },
      symbol_in_winbar = {
        enable = false,
      },
    })

    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<C-j>', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
    vim.keymap.set('n', 'gl', '<Cmd>Lspsaga show_line_diagnostics<CR>', opts)
    vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', opts)
    vim.keymap.set('n', 'gd', '<Cmd>Lspsaga finder<CR>', opts) -- antes lsp_finder
    vim.keymap.set('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.keymap.set('n', 'gp', '<Cmd>Lspsaga peek_definition<CR>', opts)
    vim.keymap.set('n', 'gr', '<Cmd>Lspsaga rename<CR>', opts)

    -- code action
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', '<cmd>Lspsaga code_action<CR>')
  end,
}
