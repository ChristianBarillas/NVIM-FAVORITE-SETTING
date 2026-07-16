return {
  -- Autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      disable_filetype = { 'TelescopePrompt', 'vim' },
    },
  },

  -- Comentarios (gcc, gc en visual) con soporte JSX/TSX
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      vim.g.skip_ts_context_commentstring_module = true
      require('ts_context_commentstring').setup({
        enable_autocmd = false,
      })
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  },

  -- Markdown bonito DENTRO del editor (títulos, tablas, checkboxes)
  -- La línea donde editas se muestra cruda; el resto, renderizado.
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
  },

  -- Vista previa de Markdown en el navegador (100% tipo página web)
  -- build por npm: el binario precompilado no sirve en Apple Silicon
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = 'cd app && npm install',
    init = function()
      -- muestra la URL del preview por si el navegador no abre solo
      vim.g.mkdp_echo_preview_url = 1
    end,
    keys = {
      { ';m', '<cmd>MarkdownPreviewToggle<cr>', desc = 'Markdown en el navegador' },
    },
  },
}
