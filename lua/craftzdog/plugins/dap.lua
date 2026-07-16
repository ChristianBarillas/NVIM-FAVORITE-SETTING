-- Debugger integrado (breakpoints, step, inspección de variables)
-- Adaptadores instalados por Mason: Python (debugpy) y JavaScript/TypeScript (js-debug)
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      dependencies = { 'nvim-neotest/nvim-nio' },
      opts = {},
    },
    { 'theHamsta/nvim-dap-virtual-text', opts = {} },
    {
      'jay-babu/mason-nvim-dap.nvim',
      dependencies = { 'mason-org/mason.nvim' },
      opts = {
        ensure_installed = { 'python', 'js' },
        -- handlers vacío = configuración automática de cada adaptador
        handlers = {},
      },
    },
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: iniciar/continuar',
    },
    {
      '<F10>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: paso siguiente',
    },
    {
      '<F11>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: entrar a la función',
    },
    {
      '<F12>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: salir de la función',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Breakpoint on/off',
    },
    {
      '<leader>dc',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: iniciar/continuar',
    },
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = 'Panel de debug on/off',
    },
    {
      '<leader>dt',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: terminar',
    },
  },
  config = function()
    local dap, dapui = require('dap'), require('dapui')

    -- Abrir/cerrar el panel automáticamente al iniciar/terminar el debug
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
    vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticWarn' })
  end,
}
