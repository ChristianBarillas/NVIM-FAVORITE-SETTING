return {
  -- Iconos de archivos (antes kyazdani42/nvim-web-devicons)
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    opts = { default = true },
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'solarized_dark',
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          disabled_filetypes = {},
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = { {
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
          } },
          lualine_x = {
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            },
            'encoding',
            'filetype',
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { {
            'filename',
            file_status = true,
            path = 1,
          } },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { 'lazy' },
      })
    end,
  },

  -- Pestañas (antes akinsho/nvim-bufferline.lua)
  {
    'akinsho/bufferline.nvim',
    version = '*',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup({
        options = {
          mode = 'tabs',
          separator_style = 'slant',
          always_show_bufferline = false,
          show_buffer_close_icons = false,
          show_close_icon = false,
          color_icons = true,
        },
        highlights = {
          separator = {
            fg = '#073642',
            bg = '#002b36',
          },
          separator_selected = {
            fg = '#073642',
          },
          background = {
            fg = '#657b83',
            bg = '#002b36',
          },
          buffer_selected = {
            fg = '#fdf6e3',
            bold = true,
          },
          fill = {
            bg = '#073642',
          },
        },
      })

      vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
      vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})
    end,
  },

  -- Pinta los códigos de color (#RRGGBB) con su color real
  -- (fork mantenido de norcalli/nvim-colorizer.lua)
  {
    'catgoose/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      filetypes = { '*' },
    },
  },

  -- Modo sin distracciones
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {},
    keys = {
      { '<C-w>o', '<cmd>ZenMode<cr>', desc = 'Zen Mode', silent = true },
    },
  },
}
