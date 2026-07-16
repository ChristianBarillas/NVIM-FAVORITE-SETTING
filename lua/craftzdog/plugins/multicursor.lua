-- Multicursores estilo VS Code
-- OJO: Ctrl-d deja de ser "media página abajo" (usa Ctrl-f/Ctrl-b para paginar)
return {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  event = 'VeryLazy',
  config = function()
    local mc = require('multicursor-nvim')
    mc.setup()

    -- Como Ctrl+D en VS Code: agrega un cursor en la siguiente
    -- aparición de la palabra bajo el cursor (o de la selección)
    vim.keymap.set({ 'n', 'x' }, '<C-d>', function()
      mc.matchAddCursor(1)
    end, { desc = 'Multicursor: siguiente coincidencia' })

    -- Como Ctrl+Shift+L en VS Code: cursores en TODAS las coincidencias
    vim.keymap.set({ 'n', 'x' }, '<leader>ma', mc.matchAllAddCursors,
      { desc = 'Multicursor: todas las coincidencias' })

    -- Cursores arriba/abajo (como Cmd+Alt+↑/↓)
    vim.keymap.set({ 'n', 'x' }, '<C-Up>', function()
      mc.lineAddCursor(-1)
    end, { desc = 'Multicursor: agregar arriba' })
    vim.keymap.set({ 'n', 'x' }, '<C-Down>', function()
      mc.lineAddCursor(1)
    end, { desc = 'Multicursor: agregar abajo' })

    -- Mientras hay cursores activos:
    mc.addKeymapLayer(function(layerSet)
      -- saltarse una coincidencia
      layerSet({ 'n', 'x' }, '<C-s>', function()
        mc.matchSkipCursor(1)
      end)
      -- Esc: primero re-habilita cursores, luego los limpia
      layerSet('n', '<Esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)
  end,
}
