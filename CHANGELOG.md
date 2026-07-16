# Changelog

Todos los cambios notables de esta configuración se documentan aquí.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es/1.1.0/)
y las versiones siguen [Semantic Versioning](https://semver.org/lang/es/).

## [2.6.1] - 2026-07-16

### Añadido
- **render-markdown.nvim**: los archivos `.md` se ven renderizados
  DENTRO del editor (títulos con color, checkboxes, tablas dibujadas,
  código resaltado). Automático al abrir markdown; la línea en edición
  se muestra cruda. `:RenderMarkdown toggle` lo apaga/enciende.
  Complementa a markdown-preview (`:MarkdownPreview`, navegador).

## [2.6.0] - 2026-07-16

Documentación del flujo de trabajo diario y del modo auto de Claude Code.

### Añadido
- **COMANDOS.md — "La rutina diaria"**: el flujo completo al inicio de
  la guía (Ghostty → `tmux new -As` → `v .` → terminales sin salir →
  Claude Code en su ventana → `Ctrl-b d` al terminar) con la regla de
  oro del orden de capas.
- **Claude Code en modo auto documentado**: sección nueva en INSTALL.md
  y ejemplo versionado en `extras/claude-settings.example.json`
  (`permissions.defaultMode: "auto"` + `autoMode.environment` con
  `"$defaults"` y la cuenta de GitHub como infraestructura confiable).
  Incluye cómo verificar (`claude auto-mode config`), el ciclo
  `Shift+Tab` (manual → accept edits → plan → auto) y cómo revisar
  bloqueos (`/permissions` → Recently denied → `r`). Nota: el modo auto
  solo se lee del settings de USUARIO (`~/.claude/settings.json`).

## [2.5.3] - 2026-07-16

### Cambiado
- tmux: `prefijo+c` (ventana nueva) ahora hereda la carpeta del panel
  actual, igual que los splits `|` y `-`.

## [2.5.2] - 2026-07-16

### Cambiado
- **Mouse desactivado en Neovim** (`mouse = ''`) a petición del usuario:
  entrenamiento 100% teclado. Comandos de emergencia `:MouseOn` /
  `:MouseOff` para la sesión actual. (El mouse de tmux sigue activo
  para scroll en terminales.)

## [2.5.1] - 2026-07-16

### Corregido
- **Copiado estilo vim en tmux ahora es real**: `v` selecciona, `y`
  copia al portapapeles de macOS, `Esc` cancela, `Ctrl-v` selección
  rectangular (por defecto tmux usaba Espacio/Enter y `v` hacía otra
  cosa). Además `set-clipboard on` para que lo copiado llegue al
  sistema vía OSC52/Ghostty.
- COMANDOS.md: guía de copiar/pegar sin mouse en los 3 contextos
  (tmux, terminal de Neovim, código).

## [2.5.0] - 2026-07-16

### Añadido
- **tmux** (brew) con configuración versionada en `extras/tmux.conf`,
  enlazada como `~/.config/tmux/tmux.conf` (install.sh lo hace en
  máquinas nuevas). Pensado para: sesiones SSH que sobreviven
  desconexiones y **agentes de AI (Claude Code) corriendo en paralelo
  en sesiones separadas**. Config: true color (Neovim idéntico adentro),
  `escape-time 10` (Esc instantáneo en Neovim), mouse, modo vi para
  copiar, splits `|`/`-`, paneles con `prefijo+hjkl`, barra solarized,
  prefijo default `Ctrl-b`.
- COMANDOS.md: sección completa de tmux (sesiones, atajos, flujo SSH y
  flujo de agentes AI).
- Nota: se evitó a propósito el plugin vim-tmux-navigator para no pisar
  `Ctrl-j` (diagnóstico siguiente en Neovim).

## [2.4.2] - 2026-07-16

### Añadido
- Aliases `vim` y `neovim` → `nvim` en el bloque de `~/.zshrc` (el
  binario real se llama `nvim`; así cualquier nombre funciona).
  COMANDOS.md lo aclara.

## [2.4.1] - 2026-07-16

### Cambiado
- **Frontera de install.sh** (decisión del dueño): el script YA NO
  instala cosas de sistema — Command Line Tools de Xcode, Homebrew,
  Flutter SDK ni Ghostty. Esas se instalan a mano, de forma natural en
  Mac; el script las **verifica** y, si faltan las obligatorias
  (CLT/brew), imprime el comando exacto y se detiene. Ghostty y Flutter
  quedan como opcionales informativos (la config de Ghostty solo se
  escribe si la app ya existe; el soporte de Flutter se activa solo).
  El único cask que instala el script es la Nerd Font (recurso del
  editor). Se eliminó la variable `SIN_FLUTTER`.
- INSTALL.md reorganizado: "Paso 0 — lo que instalas tú" + tabla de la
  frontera script/usuario. Regla protegida en AGENTS.md.

## [2.4.0] - 2026-07-16

Migración a máquina nueva con un solo comando, sin omisiones.

### Añadido
- **INSTALL.md**: guía definitiva de instalación con el inventario
  COMPLETO del entorno (herramientas de brew con su propósito, casks,
  los 21 paquetes de Mason, los 26 parsers, archivos de configuración
  que se tocan, tiempos estimados, los 4 pasos manuales, verificación,
  solución de problemas y desinstalación/rollback).
- Regla en AGENTS.md: mantener install.sh e INSTALL.md en sincronía con
  lsp.lua/dap.lua/treesitter.lua al cambiar paquetes.

### Cambiado
- **install.sh reescrito de cero** (probado end-to-end, terminó
  "sin fallas"):
  - Instala/verifica Command Line Tools de Xcode (espera el diálogo).
  - Homebrew con `shellenv` permanente en `~/.zprofile` (Apple
    Silicon e Intel).
  - Todas las herramientas y casks, incluido el **SDK de Flutter**
    (omitible con `SIN_FLUTTER=1`).
  - Respaldo automático de cualquier `~/.config/nvim` previo y symlink
    al repo desde donde esté clonado.
  - Instala los **21 paquetes de Mason por eventos y verifica cada uno
    en disco** (aprendido del bug de instalaciones fantasma de 2.0.0).
  - Verificación final ✓/✗ de comandos, arranque, parsers y Mason;
    el código de salida es el número de fallas (0 = perfecto).
  - Idempotente: re-ejecutable sin efectos secundarios.

## [2.3.1] - 2026-07-16

### Corregido
- **Íconos que se veían mal**: los glifos de diagnósticos (gutter y
  statusline), los separadores powerline de lualine y los íconos del
  dashboard se habían corrompido al escribirse los archivos (quedaron
  como espacios en blanco). Ahora todos los íconos se declaran con
  escapes explícitos `'\u{XXXX}'` (codepoints FontAwesome/Material
  válidos en Nerd Fonts v3), inmunes a corrupción por copy/paste.
- Regla nueva en AGENTS.md: los íconos siempre por codepoint, nunca
  glifo crudo.

### Notas
- Si aún se ven `▯`: la terminal debe usar una **Nerd Font**. Ghostty ya
  viene configurada; en Terminal.app: Ajustes → Perfiles → Texto →
  Fuente → "JetBrainsMono Nerd Font Mono". Los emojis (🔍 📁) no
  necesitan nada: macOS los pone solo.

## [2.3.0] - 2026-07-16

El entorno alrededor del editor: terminal, shell y bootstrap.

### Añadido
- **`install.sh`**: instalación completa en una máquina nueva con un solo
  comando (Homebrew, herramientas, fuente, Ghostty, zshrc, plugins y
  parsers precargados).
- **Terminal Ghostty** como recomendada (Terminal.app no soporta true
  color): instalada por brew y configurada en `~/.config/ghostty/config`
  con el tema `Solarized Osaka Night` (a juego con el editor) y la
  JetBrainsMono Nerd Font — cero pasos manuales.
- **Shell**: `EDITOR=nvim`/`VISUAL=nvim` y aliases `v` (nvim) y `lg`
  (lazygit) en `~/.zshrc`.
- **`:Guia`**: abre COMANDOS.md en un split desde dentro de Neovim.
- **Debugger de Flutter**: flutter-tools registra su adaptador en
  nvim-dap (`F5`/breakpoints también en Dart, lee launch.json).

## [2.2.0] - 2026-07-16

Paridad con VS Code y flujo GitHub completo — el objetivo: no extrañar
ninguna UI.

### Añadido
- **Multicursores** (multicursor.nvim, rama 1.0): `Ctrl-D` agrega cursor
  en la siguiente coincidencia (como VS Code), `\ma` en todas
  (Ctrl+Shift+L), `Ctrl-↑/↓` cursores verticales, `Ctrl-S` salta una,
  `Esc` limpia. ⚠️ `Ctrl-D` ya no es "media página abajo" (usar
  `Ctrl-F`/`Ctrl-B`).
- **UI moderna**: noice.nvim (cmdline flotante, mensajes, progreso LSP) +
  nvim-notify (toasts) + dashboard-nvim (pantalla de inicio con accesos:
  buscar, recientes, sesión, LazyGit, Lazy, Mason).
- **Breadcrumbs**: dropbar.nvim en el winbar, `;b` para navegarlos.
- **Outline de símbolos**: aerial.nvim (`\o`).
- **Plegado inteligente**: nvim-ufo con provider LSP (`za`, `zR`, `zM`,
  `zp` para vista previa); capacidad foldingRange agregada al LSP.
- **Sticky scroll**: nvim-treesitter-context (máx. 4 líneas).
- **Paréntesis de colores**: rainbow-delimiters.nvim.
- **GitHub en el editor**: octo.nvim (`\gp` PRs, `\gi` issues; usa gh CLI)
  y diffview.nvim (`\gd` diff de cambios, `\gh` historial del archivo).
- **Blame inline estilo GitLens**: gitsigns `current_line_blame`.
- **Harpoon 2**: anclar archivos (`;a`) y saltar (`;1`-`;4`, menú `;h`).
- **Telescope**: fzf-native compilado (búsqueda más rápida), `;o`
  recientes, `;k` atajos, `;c` paleta de comandos.
- **Terminales múltiples**: `\tf` flotante, `\th` horizontal, `\tv`
  vertical (además del `Ctrl-\` de siempre); comando `:LazyGit`.
- Grupos nuevos en which-key: Terminal (`\t`), Multicursor (`\m`).

## [2.1.0] - 2026-07-16

Stack completo para el trabajo real del usuario: Flutter, Python/Django,
TypeScript/React, CSS/Tailwind.

### Añadido
- **Flutter/Dart**: `flutter-tools.nvim` (org nvim-flutter). Usa el LSP
  del SDK (dartls), agrega `:FlutterRun`, `:FlutterDevices`,
  `:FlutterReload`, `:FlutterRestart`, widget guides y closing tags.
  Solo se activa si `flutter` es ejecutable (`cond`), así la config no
  falla en máquinas sin el SDK. El SDK se instaló con
  `brew install --cask flutter`.
- **Python**: LSP `ruff` junto a pyright (pyright = tipos/navegación,
  ruff = linting; el hover de ruff se desactiva para no duplicar).
  Formateo al guardar con `ruff_organize_imports` + `ruff_format`
  vía conform.
- **Django**: formateo de plantillas `htmldjango` con `djlint`
  (mason-tool-installer lo instala).

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
