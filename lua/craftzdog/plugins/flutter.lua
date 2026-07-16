-- Soporte completo de Flutter/Dart: usa el LSP del SDK (dartls) y agrega
-- comandos :FlutterRun, :FlutterDevices, :FlutterReload, hot-reload, etc.
-- Solo se activa si el SDK está instalado (brew install --cask flutter).
return {
  'nvim-flutter/flutter-tools.nvim', -- antes akinsho/flutter-tools.nvim
  ft = 'dart',
  cond = function()
    return vim.fn.executable('flutter') == 1
  end,
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('flutter-tools').setup({
      lsp = {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      },
      -- Integra el debugger de Flutter con nvim-dap (F5, breakpoints)
      debugger = {
        enabled = true,
        register_configurations = function(_)
          require('dap').configurations.dart = {}
          require('dap.ext.vscode').load_launchjs()
        end,
      },
      widget_guides = { enabled = true },
      closing_tags = { enabled = true },
    })
  end,
}
