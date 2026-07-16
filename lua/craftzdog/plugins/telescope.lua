return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-tree/nvim-web-devicons',
    -- ordenador fzf compilado en C: búsqueda mucho más rápida
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  cmd = 'Telescope',
  keys = { ';f', ';r', '\\\\', ';t', ';;', ';e', ';o', ';k', ';c', 'sf' },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local builtin = require('telescope.builtin')

    local function telescope_buffer_dir()
      return vim.fn.expand('%:p:h')
    end

    local fb_actions = telescope.extensions.file_browser.actions

    telescope.setup({
      defaults = {
        mappings = {
          n = {
            ['q'] = actions.close,
          },
        },
      },
      extensions = {
        file_browser = {
          theme = 'dropdown',
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          mappings = {
            -- your custom insert mode mappings
            ['i'] = {
              ['<C-w>'] = function()
                vim.cmd('normal vbd')
              end,
            },
            ['n'] = {
              -- your custom normal mode mappings
              ['N'] = fb_actions.create,
              ['h'] = fb_actions.goto_parent_dir,
              ['/'] = function()
                vim.cmd('startinsert')
              end,
            },
          },
        },
      },
    })

    telescope.load_extension('file_browser')
    telescope.load_extension('fzf')

    vim.keymap.set('n', ';f', function()
      builtin.find_files({
        no_ignore = false,
        hidden = true,
      })
    end, { desc = 'Buscar archivos' })
    vim.keymap.set('n', ';r', function()
      builtin.live_grep()
    end, { desc = 'Buscar texto en el proyecto' })
    vim.keymap.set('n', '\\\\', function()
      builtin.buffers()
    end, { desc = 'Buffers abiertos' })
    vim.keymap.set('n', ';t', function()
      builtin.help_tags()
    end, { desc = 'Ayuda' })
    vim.keymap.set('n', ';;', function()
      builtin.resume()
    end, { desc = 'Reabrir última búsqueda' })
    vim.keymap.set('n', ';e', function()
      builtin.diagnostics()
    end, { desc = 'Diagnósticos' })
    vim.keymap.set('n', ';o', function()
      builtin.oldfiles()
    end, { desc = 'Archivos recientes' })
    vim.keymap.set('n', ';k', function()
      builtin.keymaps()
    end, { desc = 'Buscar atajos de teclado' })
    vim.keymap.set('n', ';c', function()
      builtin.commands()
    end, { desc = 'Paleta de comandos' })
    vim.keymap.set('n', 'sf', function()
      telescope.extensions.file_browser.file_browser({
        path = '%:p:h',
        cwd = telescope_buffer_dir(),
        respect_gitignore = false,
        hidden = true,
        grouped = true,
        previewer = false,
        initial_mode = 'normal',
        layout_config = { height = 40 },
      })
    end, { desc = 'Explorador de archivos' })
  end,
}
