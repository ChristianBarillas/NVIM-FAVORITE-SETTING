return {
  -- UI moderna: cmdline flotante, mensajes bonitos, progreso del LSP
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      -- Notificaciones tipo toast (estilo VS Code)
      {
        'rcarriga/nvim-notify',
        opts = {
          timeout = 3000,
          render = 'wrapped-compact',
          stages = 'fade',
        },
      },
    },
    opts = {
      presets = {
        bottom_search = true, -- la búsqueda / se queda abajo (clásico)
        command_palette = true, -- cmdline y popupmenu juntos arriba
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      lsp = {
        progress = { enabled = true },
      },
    },
  },

  -- Pantalla de inicio con accesos rápidos
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      theme = 'doom',
      config = {
        header = {
          '',
          '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
          '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
          '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
          '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
          '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
          '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
          '',
          'Christian Barillas · NVIM-FAVORITE-SETTING',
          '',
        },
        center = {
          { icon = '\u{F002}  ', desc = 'Buscar archivo', key = 'f', action = 'Telescope find_files hidden=true' },
          { icon = '\u{F017}  ', desc = 'Archivos recientes', key = 'r', action = 'Telescope oldfiles' },
          { icon = '\u{F0F6}  ', desc = 'Buscar texto', key = 'g', action = 'Telescope live_grep' },
          { icon = '\u{F021}  ', desc = 'Restaurar sesión', key = 's', action = "lua require('persistence').load()" },
          { icon = '\u{F1D2}  ', desc = 'LazyGit', key = 'l', action = 'LazyGit' },
          { icon = '\u{F04B2}  ', desc = 'Plugins (Lazy)', key = 'p', action = 'Lazy' },
          { icon = '\u{F0AD}  ', desc = 'LSPs (Mason)', key = 'm', action = 'Mason' },
          { icon = '\u{F08B}  ', desc = 'Salir', key = 'q', action = 'qa' },
        },
        footer = { '', 'Guía de atajos: COMANDOS.md · \\? muestra which-key' },
      },
    },
  },

  -- Breadcrumbs (migas de pan) en la parte superior, como VS Code
  {
    'Bekaboo/dropbar.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    keys = {
      {
        ';b',
        function()
          require('dropbar.api').pick()
        end,
        desc = 'Navegar breadcrumbs (símbolos de la ruta)',
      },
    },
  },
}
