# NVIM-FAVORITE-SETTING

Configuración personal de Neovim de Christian Barillas, pensada como un
**IDE completo para desarrollo profesional** manejado 100% con teclado.

Basada originalmente en la config de
[craftzdog (devaslife)](https://github.com/craftzdog/dotfiles-public) y
modernizada por completo en **julio 2026**: migrada de Packer a
[lazy.nvim](https://github.com/folke/lazy.nvim), LSP nativo de Neovim 0.11+,
Mason v2, debugger integrado y un set completo de herramientas nivel senior.

> 📖 **¿Nuevo en Neovim?** Empieza por [COMANDOS.md](COMANDOS.md) — guía de
> atajos por niveles (principiante → intermedio → avanzado).
>
> 🤖 **¿Eres una AI ayudando con este repo?** Lee [AGENTS.md](AGENTS.md) —
> contiene todo el contexto, convenciones y comandos de verificación.
>
> 📝 El historial de cambios está en [CHANGELOG.md](CHANGELOG.md).

## Qué incluye

### Núcleo
| Área | Herramienta |
|---|---|
| Gestor de plugins | **lazy.nvim** (con lockfile versionado) |
| Tema | **solarized-osaka** (solarized oscuro, fondo transparente) |
| Sintaxis | **nvim-treesitter** (rama `main`) con 25 lenguajes |
| LSP | Neovim nativo (`vim.lsp`) + **nvim-lspconfig** + **Mason v2** |
| Autocompletado | **nvim-cmp** + LuaSnip + lspkind (con colores de Tailwind) |
| Formateo | **conform.nvim** — prettier/stylua al guardar |
| Linting | **nvim-lint** — eslint_d (solo si el proyecto tiene config de ESLint) |
| UI de LSP | **lspsaga** — hover, rename, finder, code actions |

### Lenguajes configurados (Mason los instala solo)
TypeScript/JavaScript/**React** (`vtsls`, con TypeScript incluido), HTML,
CSS, **Tailwind CSS**, Astro, Emmet, Lua, **Python/Django** (pyright para
tipos + ruff para lint/formato), **PHP** (intelephense), JSON y YAML (con
esquemas de schemastore), Bash, Docker, Markdown (marksman), y plantillas
de Django con djlint.

**Flutter/Dart**: soporte completo vía flutter-tools.nvim (usa el LSP del
SDK). Se activa automáticamente si `flutter` está instalado
(`brew install --cask flutter`): autocompletado, `:FlutterRun`,
`:FlutterDevices`, hot reload, widget guides.

### Productividad senior
| Plugin | Para qué |
|---|---|
| **telescope** + file-browser | Buscar archivos (`;f`), texto (`;r`), buffers (`\\`) |
| **neo-tree** | Árbol de archivos lateral (`Ctrl-n`) |
| **which-key** | Muestra los atajos disponibles al escribir (aprende usándolo) |
| **flash.nvim** | Saltar a cualquier punto visible en 2 teclas (`;s`) |
| **nvim-surround** | Rodear con comillas/paréntesis/etiquetas (`ys`, `cs`, `ds`) |
| **Comment.nvim** | Comentar con `gcc` (soporta JSX/TSX) |
| **toggleterm** | Terminal flotante (`Ctrl-\`) |
| **lazygit** | Git visual dentro de Neovim (`\gg`) |
| **gitsigns** + git.nvim | Cambios en el gutter, blame (`\gb`), abrir en GitHub (`\go`) |
| **trouble** | Panel de errores del proyecto (`\xx`) |
| **todo-comments** | Resalta y lista TODO/FIXME (`\xt`, `]t`/`[t`) |
| **grug-far** | Buscar y reemplazar en todo el proyecto (`\sr`) |
| **nvim-dap** + dap-ui | Debugger con breakpoints para Python y JS/TS (`F5`, `\db`) |
| **persistence** | Sesiones por proyecto (`\qs` restaura) |
| **bufferline** | Pestañas arriba (`Tab` / `Shift-Tab`) |
| **lualine** | Statusline con diagnósticos y rama de git |
| autopairs, autotag, illuminate, guess-indent, indent-blankline, colorizer, zen-mode, markdown-preview | Detalles de calidad de vida |

### Paridad con VS Code (y más allá)
| Plugin | Equivalente en VS Code |
|---|---|
| **multicursor.nvim** | Multicursores: `Ctrl-D` siguiente coincidencia, `\ma` todas (Ctrl+Shift+L), `Ctrl-↑/↓` vertical |
| **dropbar** | Breadcrumbs navegables arriba (`;b` para saltar por ellos) |
| **aerial** | Outline de símbolos (`\o`) |
| **nvim-ufo** | Plegado de código por LSP (`za`, `zR`, `zM`, `zp` vista previa) |
| **treesitter-context** | Sticky scroll (la función actual fija arriba) |
| **rainbow-delimiters** | Coloreado de pares de paréntesis |
| **noice + notify** | Cmdline flotante, notificaciones toast, progreso del LSP |
| **dashboard** | Pantalla de bienvenida con accesos rápidos |
| **octo.nvim** | GitHub PRs e issues dentro del editor (`\gp`, `\gi`) |
| **diffview** | Vista de diffs y historial de archivo (`\gd`, `\gh`) |
| **gitsigns blame inline** | GitLens (autor y fecha al final de la línea actual) |
| **harpoon 2** | Anclar 4 archivos y saltar al instante (`;a`, `;1`-`;4`, `;h`) |
| **telescope-fzf-native** | Búsqueda fuzzy compilada en C (más rápida) |
| **toggleterm múltiple** | Varias terminales: `\tf` flotante, `\th` horizontal, `\tv` vertical |
| **telescope extras** | `;o` recientes, `;c` paleta de comandos, `;k` buscar atajos |

## Requisitos

Todo se instala con [Homebrew](https://brew.sh):

```bash
# Editor y toolchain
brew install neovim git node ripgrep fd tree-sitter-cli lazygit gh

# Fuente con íconos y terminal recomendada
brew install --cask font-jetbrains-mono-nerd-font ghostty
```

> 💻 **Terminal**: se recomienda **Ghostty** (color verdadero, rápida,
> config en texto plano). Terminal.app de macOS NO soporta true color y
> degrada el tema. La config de Ghostty va en `~/.config/ghostty/config`
> con el tema `Solarized Osaka Night` — a juego con el editor
> (`install.sh` la escribe sola).

- **Neovim 0.11 o superior** (probada con 0.12.4)
- Un compilador de C para treesitter (en macOS: Xcode o `xcode-select --install`)
- macOS, Linux o Windows/WSL (el portapapeles se configura solo según el SO)

## Instalación

**Máquina nueva — UN comando** (📖 guía completa e inventario total en
**[INSTALL.md](INSTALL.md)**):

```bash
git clone https://github.com/ChristianBarillas/NVIM-FAVORITE-SETTING.git ~/.config/nvim && bash ~/.config/nvim/install.sh
```

**Frontera clara**: lo de sistema lo instalas tú de forma natural en Mac
(Xcode CLT, Homebrew, y si quieres Ghostty/Flutter) — el script solo lo
verifica y te dice el comando exacto si falta. Lo del **editor** sí lo
hace todo él, idempotente y con verificación final ✓/✗: las 10
herramientas por brew, la fuente, tu shell (`EDITOR=nvim`, aliases
`v`/`lg`), los 65 plugins, 26 parsers y los 21 paquetes de Mason
verificados en disco.

**Solo el editor (si ya tienes las herramientas):**

```bash
git clone https://github.com/ChristianBarillas/NVIM-FAVORITE-SETTING.git ~/.config/nvim
nvim
```

El primer arranque hace todo solo, en este orden:

1. **lazy.nvim** se auto-instala y descarga todos los plugins.
2. **Mason** instala los servidores LSP, `prettierd`, `eslint_d`, `stylua`
   y los adaptadores de debug (`debugpy`, `js-debug-adapter`).
3. **treesitter** compila los parsers de sintaxis en segundo plano.

Espera 1-2 minutos a que termine y reinicia Neovim. Verifica con:

- `:Lazy` — estado de los plugins
- `:Mason` — estado de LSPs y herramientas
- `:checkhealth` — diagnóstico general

## Estructura del repositorio

```
init.lua                          -- punto de entrada: carga base, maps y lazy
lua/craftzdog/
├── base.lua                      -- opciones generales del editor
├── highlights.lua                -- opciones visuales y highlight al copiar
├── maps.lua                      -- atajos de teclado generales (sin plugins)
├── lazy.lua                      -- bootstrap de lazy.nvim
├── macos.lua / windows.lua / wsl.lua  -- portapapeles según sistema
└── plugins/                      -- UN ARCHIVO POR GRUPO de plugins
    ├── colorscheme.lua           -- solarized-osaka
    ├── treesitter.lua            -- sintaxis + autotag
    ├── lsp.lua                   -- mason, lspconfig, diagnósticos, schemastore
    ├── lspsaga.lua               -- UI de LSP y sus keymaps
    ├── completion.lua            -- nvim-cmp + luasnip + lspkind
    ├── formatting.lua            -- conform (formateo al guardar)
    ├── linting.lua               -- nvim-lint (eslint_d)
    ├── telescope.lua             -- búsqueda y file browser + keymaps ;
    ├── explorer.lua              -- neo-tree (árbol lateral)
    ├── ui.lua                    -- lualine, bufferline, devicons, colorizer, zen
    ├── git.lua                   -- gitsigns + git.nvim
    ├── terminal.lua              -- toggleterm + lazygit
    ├── editor.lua                -- autopairs, Comment, markdown-preview
    ├── editor-extras.lua         -- surround, flash, illuminate, ibl, grug-far
    ├── trouble.lua               -- trouble + todo-comments
    ├── whichkey.lua              -- which-key
    ├── sessions.lua              -- persistence
    └── dap.lua                   -- debugger (nvim-dap + ui + mason-nvim-dap)
lazy-lock.json                    -- versiones exactas de cada plugin (commiteado)
COMANDOS.md                       -- guía de atajos por niveles
CHANGELOG.md                      -- historial de cambios
AGENTS.md / CLAUDE.md             -- contexto para asistentes de AI
```

## Atajos esenciales (resumen)

La tecla líder es `\` (backslash). La guía completa por niveles está en
**[COMANDOS.md](COMANDOS.md)**.

| Atajo | Acción |
|---|---|
| `;f` / `;r` | Buscar archivo / buscar texto en el proyecto |
| `Ctrl-n` | Árbol de archivos |
| `sf` | Explorador flotante del directorio actual |
| `ss` / `sv` | Split horizontal / vertical |
| `Espacio` | Cambiar de ventana |
| `Tab` / `Shift-Tab` | Siguiente / anterior pestaña |
| `K` | Documentación del símbolo |
| `gd` / `gr` | Definición y referencias / renombrar |
| `\ca` | Code actions |
| `gcc` | Comentar línea |
| `Ctrl-\` | Terminal flotante |
| `\gg` | LazyGit |
| `\xx` | Errores del proyecto |
| `F5` / `\db` | Debug: iniciar / breakpoint |
| `\?` | Ver atajos del buffer (which-key) |

## Solución de problemas

| Problema | Solución |
|---|---|
| `:Lazy` muestra muchos "not loaded" | **Es normal y deseable**: carga perezosa. Los plugins despiertan al usarlos (`;f` carga telescope, `F5` el debugger, un `.dart` carga flutter-tools...). Al arrancar solo cargan ~3 de 65 — por eso abre instantáneo. Problema sería ✗ rojo/failed, no "not loaded" |
| Íconos se ven como `▯` | Usa Ghostty (ya trae la fuente configurada) o selecciona "JetBrainsMono Nerd Font" en tu terminal |
| Colores se ven mal | Terminal.app no soporta true color — usa Ghostty |
| `tree-sitter no encontrado` | `brew install tree-sitter-cli` |
| Un LSP no arranca | `:Mason` para ver el estado, `:LspInfo` en el buffer |
| Formateo no funciona | `:ConformInfo` muestra el formateador activo |
| Empezar de cero | `rm -rf ~/.local/share/nvim ~/.local/state/nvim` y abrir nvim |

## Filosofía

- **Teclado primero**: nada aquí necesita mouse.
- **Reproducible**: `lazy-lock.json` fija versiones; Mason instala lo demás.
- **Un archivo = un tema**: cada grupo de plugins vive en su propio archivo.
- **Documentado**: cada cambio importante queda en el CHANGELOG.
