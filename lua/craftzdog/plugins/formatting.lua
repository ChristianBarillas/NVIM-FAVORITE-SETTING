-- Reemplaza el formateo de null-ls (archivado en 2023)
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        astro = { 'prettierd', 'prettier', stop_after_first = true },
        lua = { 'stylua' },
      },
      -- Formatear al guardar (como hacía null-ls)
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 1000, lsp_format = 'fallback' }
      end,
    })

    -- Equivalente al antiguo :DisableLspFormatting
    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        vim.b.disable_autoformat = true -- solo este buffer
      else
        vim.g.disable_autoformat = true
      end
    end, { desc = 'Desactivar formateo al guardar', bang = true })

    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = 'Activar formateo al guardar' })
  end,
}
