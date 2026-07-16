return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'b0o/schemastore.nvim', -- esquemas de JSON/YAML (package.json, docker-compose, CI...)
      { 'folke/lazydev.nvim', ft = 'lua', opts = {} }, -- API de Neovim en lua_ls
    },
    config = function()
      -- Capacidades de autocompletado para todos los servidores
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      -- y de plegado de código (nvim-ufo)
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      vim.lsp.config('*', { capabilities = capabilities })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      -- Validación de JSON/YAML con los esquemas de schemastore.org
      vim.lsp.config('jsonls', {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })
      vim.lsp.config('yamlls', {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = '' }, -- lo maneja schemastore.nvim
            schemas = require('schemastore').yaml.schemas(),
          },
        },
      })

      -- Servidores LSP (Mason los instala y activa automáticamente)
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'vtsls', -- TypeScript/JS: trae typescript incluido y usa el del proyecto si existe
          'html',
          'cssls',
          'tailwindcss',
          'astro',
          'pyright', -- Python: tipos y navegación
          'ruff', -- Python: linting y formateo (lo usa conform)
          'intelephense',
          'jsonls',
          'yamlls',
          'bashls',
          'dockerls',
          'emmet_language_server',
          'marksman', -- markdown
        },
        -- stylua es formateador (lo usa conform), no queremos su modo LSP
        automatic_enable = { exclude = { 'stylua' } },
      })

      -- Formateadores y linters
      require('mason-tool-installer').setup({
        ensure_installed = { 'prettierd', 'eslint_d', 'stylua', 'djlint' },
      })

      -- Keymaps cuando un LSP se conecta al buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
        callback = function(ev)
          -- En Python conviven pyright (tipos) y ruff (lint/format):
          -- el hover lo da pyright para no duplicar ventanas
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.name == 'ruff' then
            client.server_capabilities.hoverProvider = false
          end

          local opts = { buffer = ev.buf, silent = true }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        end,
      })

      -- Diagnósticos
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          spacing = 4,
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.HINT] = '󰠠 ',
            [vim.diagnostic.severity.INFO] = ' ',
          },
        },
      })
    end,
  },
}
