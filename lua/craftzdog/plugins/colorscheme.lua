-- Solarized dark, igual que la estética original (neosolarized),
-- pero con el sucesor mantenido por el mismo craftzdog.
return {
  'craftzdog/solarized-osaka.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('solarized-osaka').setup({
      transparent = true, -- el fondo transparente que tenía neosolarized
      styles = {
        comments = { italic = true },
      },
    })
    vim.cmd.colorscheme('solarized-osaka')
  end,
}
