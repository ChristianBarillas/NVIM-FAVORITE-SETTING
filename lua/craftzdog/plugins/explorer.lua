-- Árbol de archivos lateral (estilo IDE). El explorador flotante
-- de siempre sigue en `sf` (telescope-file-browser).
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<C-n>', '<cmd>Neotree toggle<cr>', desc = 'Explorador de archivos (árbol)' },
  },
  opts = {
    close_if_last_window = true,
    window = { width = 32 },
    filesystem = {
      follow_current_file = { enabled = true },
      -- telescope-file-browser ya se encarga de netrw
      hijack_netrw_behavior = 'disabled',
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { 'node_modules', '.git' },
      },
    },
  },
}
