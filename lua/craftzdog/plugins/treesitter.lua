return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- la rama master quedó congelada en 2025
    build = ':TSUpdate',
    lazy = false,
    config = function()
      local ts = require('nvim-treesitter')
      ts.setup({})

      -- Parsers a instalar (se descargan/compilan en segundo plano)
      ts.install({
        'astro',
        'bash',
        'css',
        'dart',
        'diff',
        'dockerfile',
        'gitcommit',
        'gitignore',
        'html',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'php',
        'python',
        'regex',
        'scss',
        'sql',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      })

      -- Activar highlight e indentación por treesitter cuando haya parser
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_start', { clear = true }),
        callback = function(ev)
          local ok = pcall(vim.treesitter.start, ev.buf)
          if ok then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    'windwp/nvim-ts-autotag', -- cierra/renombra etiquetas HTML/JSX automáticamente
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
}
