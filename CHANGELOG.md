# Changelog

Todos los cambios notables de esta configuración se documentan aquí.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es/1.1.0/)
y las versiones siguen [Semantic Versioning](https://semver.org/lang/es/).

## [2.0.0] - 2026-07-16

Modernización completa. La configuración de 2024 ya no funcionaba en Neovim
actual (0.12): Packer y null-ls fueron abandonados en 2023 y varios plugins
cambiaron de nombre o de repositorio.

### Cambiado
- **Gestor de plugins: Packer → lazy.nvim** (auto-bootstrap, lockfile
  `lazy-lock.json` versionado, carga perezosa).
- **Estructura**: los archivos `plugin/*.rc.lua` y `after/plugin/*.rc.lua`
  se convirtieron en specs de lazy en `lua/craftzdog/plugins/` (un archivo
  por grupo).
- **Tema: neosolarized + colorbuddy → solarized-osaka.nvim** (mismo autor
  original —craftzdog—, misma estética solarized dark con fondo transparente,
  pero mantenido activamente).
- **LSP**: de `on_attach` por servidor a la API nativa de Neovim 0.11+
  (`vim.lsp.config` / `vim.lsp.enable`) con **Mason v2** y
  `mason-lspconfig` (instalación y activación automáticas).
- `tsserver` → **`vtsls`**: el nombre `tsserver` ya no existe en
  nvim-lspconfig (se renombró a `ts_ls`), y se eligió vtsls porque trae
  TypeScript incluido — funciona hasta en archivos sueltos sin
  `node_modules`, y usa la versión del proyecto cuando existe.
- `glepnir/lspsaga.nvim` → **`nvimdev/lspsaga.nvim`** (el repo se movió);
  el keymap `gd` ahora usa `:Lspsaga finder` (antes `lsp_finder`).
- `kyazdani42/nvim-web-devicons` → **`nvim-tree/nvim-web-devicons`**.
- `akinsho/nvim-bufferline.lua` → **`akinsho/bufferline.nvim`**.
- `norcalli/nvim-colorizer.lua` → **`catgoose/nvim-colorizer.lua`** (fork
  mantenido).
- **nvim-treesitter**: rama `master` (congelada en 2025) → rama **`main`**,
  con highlight/indent activados por autocmd `FileType`. Requiere el CLI
  `tree-sitter` (se instala con Homebrew).
- Comment.nvim + ts-context-commentstring: integración moderna
  (`create_pre_hook()`).
- Diagnósticos con la API actual: `vim.diagnostic.config()` con
  `signs.text` (antes `sign_define`) y sin `vim.lsp.with` (deprecado).
- `vim.opt.shell = 'fish'` eliminado — usa el shell del sistema ($SHELL).
  fish no está instalado en la máquina actual y rompía los comandos `:!`.

### Añadido
- **Formateo**: conform.nvim (prettierd/prettier para web, stylua para Lua),
  formateo al guardar con `:FormatDisable` / `:FormatEnable`.
- **Linting**: nvim-lint con `eslint_d` (solo se activa si el proyecto tiene
  configuración de ESLint).
- **Más lenguajes LSP**: JSON y YAML con esquemas de schemastore.nvim,
  Bash (`bashls`), Docker (`dockerls`), Emmet (`emmet_language_server`),
  Markdown (`marksman`), Python (`pyright`), PHP (`intelephense`).
- **Debugger**: nvim-dap + nvim-dap-ui + nvim-dap-virtual-text +
  mason-nvim-dap con adaptadores para Python (debugpy) y JS/TS (js-debug).
  Keymaps: `F5`/`F10`/`F11`/`F12`, `\db` breakpoint, `\du` panel.
- **Terminal integrada**: toggleterm (`Ctrl-\`, flotante) y **LazyGit**
  (`\gg`).
- **Explorador lateral**: neo-tree (`Ctrl-n`), conviviendo con
  telescope-file-browser (`sf`).
- **Navegación**: flash.nvim (`;s` salto, `;S` selección por sintaxis).
- **Edición**: nvim-surround (`ys`/`cs`/`ds`), vim-illuminate,
  guess-indent, indent-blankline.
- **Proyecto**: trouble.nvim (`\xx`), todo-comments (`\xt`, `]t`/`[t`),
  grug-far (`\sr` buscar/reemplazar global), persistence.nvim (sesiones,
  `\qs`).
- **Descubribilidad**: which-key (muestra atajos al escribir, `\?`).
- **Calidad de vida**: `undofile` persistente, `signcolumn` fijo,
  mason-tool-installer (prettierd, eslint_d, stylua), lazydev.nvim para
  la API de Neovim en Lua.
- **Parsers de treesitter añadidos**: bash, dart, diff, dockerfile,
  gitcommit, gitignore, regex, scss, sql, vim, vimdoc.
- **Documentación**: README completo, COMANDOS.md (guía por niveles),
  este CHANGELOG, y AGENTS.md + CLAUDE.md (contexto para asistentes AI).
- `.gitignore`.

### Eliminado
- **packer.nvim** y `plugin/packer_compiled.lua` (artefacto de máquina que
  estaba versionado).
- **null-ls.nvim** (archivado en 2023) → reemplazado por conform + nvim-lint.
- **lsp-colors.nvim** (archivado; Neovim trae los grupos `Diagnostic*`
  nativos).
- LSP de **flow** (tecnología abandonada) y **sourcekit** (Swift; se puede
  reactivar con `vim.lsp.enable('sourcekit')` si algún día hace falta).
- Diagnósticos de fish en null-ls.
- Override manual de `protocol.CompletionItemKind` y el `symbol_map` con
  glifos de Nerd Font v2 (obsoletos) — lspkind usa sus defaults actuales.
- Autocmd `set nopaste` en InsertLeave y códigos de terminal `t_Cs`/`t_Ce`
  (obsoletos en Neovim).
- `vim.cmd("autocmd!")` global al inicio de base.lua (borraba autocmds de
  plugins).

### Notas de migración
- Los keymaps originales se conservaron **todos** (`;f`, `;r`, `sf`, `ss`,
  `sv`, `Espacio`, `Tab`, `te`, `x`, `dw`, `+`/`-`, `Ctrl-a`, `K`, `gd`,
  `gp`, `gr`, `gl`, `Ctrl-j`, `\ca`, `\gb`, `\go`, `Ctrl-w o`...).
- Herramientas de sistema instaladas con Homebrew: `neovim`, `tree-sitter-cli`,
  `lazygit`, `fd`, `font-jetbrains-mono-nerd-font` (además de las que ya
  estaban: git, node, ripgrep, fzf).

## [1.0.0] - 2024-03-24

### Añadido
- Configuración inicial basada en los dotfiles de craftzdog (devaslife):
  Packer, neosolarized, lualine, bufferline, telescope + file-browser,
  treesitter, nvim-cmp, lspconfig (tsserver, lua_ls, tailwindcss, cssls,
  astro, flow, sourcekit), null-ls (prettierd, eslint_d), lspsaga, mason,
  gitsigns, git.nvim, autopairs, autotag, Comment.nvim, colorizer,
  zen-mode, markdown-preview.
