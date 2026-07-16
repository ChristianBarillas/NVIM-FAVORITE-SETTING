# Contexto para asistentes de AI

Este archivo existe para que cualquier asistente de AI (Claude, Copilot,
etc.) entienda este repositorio rápido y trabaje sobre él de forma segura.

## Qué es este repositorio

Configuración personal de Neovim de Christian Barillas. Se instala clonando
en `~/.config/nvim`. Es un IDE completo manejado por teclado: LSP, formateo,
linting, debugger, git y terminal integrados.

- **Neovim mínimo**: 0.11 (desarrollada y probada con 0.12.4 en macOS arm64).
- **Gestor de plugins**: lazy.nvim, con bootstrap automático en
  `lua/craftzdog/lazy.lua` y versiones fijadas en `lazy-lock.json`.
- **Idioma**: usuario hispanohablante. Documentación y descripciones de
  keymaps en español. Los comentarios de código pueden estar en ambos idiomas.
- **Historia**: nació de los dotfiles de craftzdog (devaslife) con Packer
  (v1.0.0, 2024); migrada por completo a lazy.nvim en julio 2026 (v2.0.0).
  El namespace `craftzdog` se conservó a propósito. Detalle en CHANGELOG.md.

## Mapa del código

```
init.lua                 → requiere: base, highlights, maps, lazy, {so}.lua
lua/craftzdog/base.lua   → opciones (indentación 2sp, undofile, signcolumn…)
lua/craftzdog/highlights.lua → opciones visuales + highlight al copiar
lua/craftzdog/maps.lua   → keymaps SIN plugins (ver abajo)
lua/craftzdog/lazy.lua   → bootstrap de lazy.nvim; importa craftzdog.plugins
lua/craftzdog/{macos,windows,wsl}.lua → portapapeles por SO
lua/craftzdog/plugins/*.lua → cada archivo retorna specs de lazy.nvim
```

Cada archivo de `plugins/` retorna una tabla de specs de lazy.nvim y agrupa
un tema: `lsp.lua` (Mason + lspconfig + diagnósticos), `completion.lua`
(nvim-cmp), `formatting.lua` (conform), `linting.lua` (nvim-lint),
`telescope.lua`, `explorer.lua` (neo-tree), `ui.lua` (lualine/bufferline/
colorizer/zen), `git.lua`, `terminal.lua` (toggleterm+lazygit),
`editor.lua`, `editor-extras.lua` (surround/flash/ibl/grug-far),
`trouble.lua`, `whichkey.lua`, `sessions.lua`, `dap.lua`,
`treesitter.lua`, `colorscheme.lua`, `lspsaga.lua`.

## Reglas al modificar

1. **No rompas los keymaps históricos** (memoria muscular del usuario):
   `;f ;r ;t ;; ;e \\ sf` (telescope), `ss sv sh sj sk sl` (ventanas),
   `Espacio` (cambiar ventana), `Tab/S-Tab` (pestañas), `te`, `x`, `dw`,
   `+ -`, `Ctrl-a`, `K gd gp gr gD gi gl Ctrl-j \ca` (LSP), `\gb \go \gg`
   (git), `Ctrl-\` (terminal), `Ctrl-n` (árbol), `;s ;S` (flash),
   `Ctrl-w o` (zen).
2. **La tecla líder es `\`** (default de Vim). NO cambiar a Espacio:
   Espacio ya está mapeado a `<C-w>w`.
3. Un plugin nuevo va en el archivo temático que corresponda (o uno nuevo
   en `lua/craftzdog/plugins/`), con `event`/`cmd`/`keys` para carga
   perezosa y un comentario de una línea explicando qué hace.
4. **Toda modificación se registra en CHANGELOG.md** (formato Keep a
   Changelog, en español) y, si cambia atajos o flujo, también en
   COMANDOS.md y README.md.
5. Los docs están en español; mantenerlo.
6. `lazy-lock.json` SÍ se commitea (reproducibilidad).
7. Preferir siempre plugins mantenidos; este repo acaba de salir de una
   migración por plugins archivados (Packer, null-ls, lsp-colors). No
   reintroducir dependencias muertas.
8. Herramientas de sistema: instalar por **Homebrew** siempre que exista
   formula (preferencia explícita del usuario).

## Decisiones técnicas ya tomadas (no revertir sin razón)

- **nvim-treesitter rama `main`** (la master está congelada desde 2025).
  Requiere el CLI `tree-sitter` (brew). Highlight se activa con un autocmd
  `FileType` que llama `vim.treesitter.start()` con `pcall`.
- **LSP por API nativa**: `vim.lsp.config()` para settings y
  mason-lspconfig v2 con activación automática (`vim.lsp.enable` interno).
  No usar el patrón viejo `require('lspconfig').X.setup{}`.
- **Formateo ≠ linting**: conform.nvim formatea (prettierd→prettier
  fallback, stylua), nvim-lint lintea (eslint_d, solo si el proyecto tiene
  config de ESLint — guard en `linting.lua`).
- **TypeScript usa `vtsls`** (no `ts_ls`/`tsserver`): vtsls trae typescript
  incluido, así que funciona en archivos sueltos; con proyecto usa el
  typescript de `node_modules`.
- Tema: `solarized-osaka` con `transparent = true` (sucesor de neosolarized,
  misma estética). bufferline conserva colores solarized hardcodeados.
- neo-tree tiene `hijack_netrw_behavior = 'disabled'` porque
  telescope-file-browser ya hace hijack de netrw.
- DAP: adaptadores vía mason-nvim-dap (`handlers = {}` = setup automático);
  `python` (debugpy) y `js` (js-debug-adapter).
- **Python = pyright + ruff juntos**: pyright para tipos/navegación, ruff
  para lint y formateo (conform usa `ruff_organize_imports` +
  `ruff_format`); el `hoverProvider` de ruff se desactiva en LspAttach.
- **Flutter usa flutter-tools.nvim** (NO mason): el LSP dartls viene con
  el SDK de Flutter. El spec tiene `cond = executable('flutter')` para no
  fallar sin SDK. Django: plantillas `htmldjango` se formatean con djlint.

## Cómo verificar cambios (headless, sin abrir la UI)

```bash
# 1. Sincronizar plugins según el lockfile / instalar nuevos
nvim --headless "+Lazy! sync" +qa

# 2. Arranque limpio: no debe imprimir errores
nvim --headless "+lua print('OK arranque')" +qa

# 3. Salud general (opcional, output largo)
nvim --headless "+checkhealth" "+w! /tmp/health.txt" +qa

# 4. Instalar parsers de treesitter y esperar
nvim --headless -c "lua require('nvim-treesitter').install({'lua','typescript'}):wait(300000)" -c q
```

Un cambio está "verificado" cuando (1) y (2) corren sin errores y los
keymaps afectados funcionan en una sesión real.

## Requisitos de sistema (todos por Homebrew)

`neovim git node ripgrep fd tree-sitter-cli lazygit` +
`font-jetbrains-mono-nerd-font` (cask). Compilador C (Xcode CLT) para
treesitter. Mason instala por sí solo los LSPs, prettierd, eslint_d,
stylua, debugpy y js-debug-adapter (necesita node y python3 del sistema).
