# INSTALL.md — Instalación completa en una computadora nueva

> **El objetivo de este documento**: que el día que estrenes una Mac,
> traigas este repositorio, corras **un solo comando**, y en ~15 minutos
> tengas tu entorno de desarrollo completo, idéntico, verificado y sin
> omisiones. Todo lo que compone el entorno está inventariado aquí.

---

## ⚡ El comando único

```bash
git clone https://github.com/ChristianBarillas/NVIM-FAVORITE-SETTING.git ~/.config/nvim && bash ~/.config/nvim/install.sh
```

Si no quieres el SDK de Flutter (~3 GB) todavía:

```bash
SIN_FLUTTER=1 bash ~/.config/nvim/install.sh
```

El script es **idempotente**: puedes correrlo las veces que quieras; lo
que ya está instalado lo salta, lo que falta lo instala, y al final te
da un resumen ✓/✗. Si algo falla (por internet, etc.), simplemente
re-ejecútalo.

### Requisitos previos

- Una Mac con macOS (Apple Silicon o Intel — el script detecta ambos).
- Tu contraseña de usuario (la pedirá el instalador de Homebrew, es normal).
- Conexión a internet. Nada más.

### Tiempo estimado

| Fase | Tiempo aprox. |
|---|---|
| Command Line Tools de Xcode (si faltan) | 3-5 min |
| Homebrew + herramientas | 3-5 min |
| Fuente + Ghostty | 1 min |
| Flutter SDK (opcional) | 5-10 min |
| Plugins + parsers + LSPs de Mason | 5-8 min |
| **Total** | **~15-25 min** |

---

## 📦 Inventario completo (lo que el script instala, sin omisiones)

### 1. Base del sistema

| Qué | Cómo | Para qué |
|---|---|---|
| Command Line Tools de Xcode | `xcode-select --install` | Compilador C (parsers de treesitter, fzf-native) |
| Homebrew | instalador oficial | Gestor de paquetes; queda activado en `~/.zprofile` |

### 2. Herramientas de terminal (brew, formulas)

| Paquete | Para qué |
|---|---|
| `neovim` | El editor (0.11+; probado con 0.12) |
| `git` | Control de versiones |
| `node` | Servidores LSP de web, prettier, js-debug |
| `python` | Python moderno (pyright/debugpy lo usan) |
| `ripgrep` | Búsqueda de texto de Telescope (`;r`) |
| `fd` | Búsqueda rápida de archivos |
| `fzf` | Fuzzy finder de shell |
| `tree-sitter-cli` | Compilar parsers (la rama main de nvim-treesitter lo exige) |
| `lazygit` | Git visual (`\gg` / `lg`) |
| `gh` | GitHub CLI (lo usa Octo para PRs/issues) |

### 3. Apps y fuente (brew, casks)

| Cask | Para qué |
|---|---|
| `font-jetbrains-mono-nerd-font` | Fuente con TODOS los íconos (Nerd Font v3) |
| `ghostty` | Terminal recomendada: true color, rápida, config en texto |
| `flutter` | SDK completo de Flutter/Dart (omitible con `SIN_FLUTTER=1`) |

### 4. Archivos de configuración que el script escribe/toca

| Archivo | Qué hace el script |
|---|---|
| `~/.config/nvim` | Symlink al repo (si había algo, lo respalda como `nvim.respaldo.FECHA`) |
| `~/.config/ghostty/config` | Tema `Solarized Osaka Night` + Nerd Font (solo si no existe) |
| `~/.zshrc` | Bloque con `EDITOR=nvim`, `VISUAL=nvim`, `alias v='nvim'`, `alias lg='lazygit'` (solo si no está) |
| `~/.zprofile` | `eval "$(brew shellenv)"` (solo si no está) |

### 5. Dentro de Neovim (automático, headless)

- **65 plugins** vía lazy.nvim, con las versiones exactas fijadas en
  `lazy-lock.json` (reproducibilidad total). La lista completa vive en
  `lua/craftzdog/plugins/*.lua` — un archivo por grupo, cada plugin
  comentado.
- **26 parsers de treesitter** compilados: astro, bash, css, dart, diff,
  dockerfile, gitcommit, gitignore, html, javascript, json, lua,
  markdown, markdown_inline, php (+php_only), python, regex, scss, sql,
  toml, tsx, typescript, vim, vimdoc, yaml.
- **21 paquetes de Mason**, verificados en disco uno por uno:

| Tipo | Paquetes |
|---|---|
| LSPs (15) | lua-language-server, vtsls (TS/JS con TypeScript incluido), html-lsp, css-lsp, tailwindcss-language-server, astro-language-server, pyright, ruff, intelephense (PHP), json-lsp, yaml-language-server, bash-language-server, dockerfile-language-server, emmet-language-server, marksman (Markdown) |
| Formato/lint (4) | prettierd, eslint_d, stylua, djlint (plantillas Django) |
| Debuggers (2) | debugpy (Python), js-debug-adapter (JS/TS) |

> El LSP de **Dart/Flutter no va por Mason**: viene dentro del SDK de
> Flutter y lo maneja flutter-tools.nvim automáticamente.

### 6. Verificación final automática

El script termina comprobando y reportando ✓/✗:

- Los 9 comandos existen (`nvim git node rg fd fzf tree-sitter lazygit gh`)
- Neovim arranca sin errores
- ≥25 parsers compilados
- 21/21 paquetes de Mason presentes en disco
- Versión de Flutter (si se instaló)

El **código de salida** del script es el número de fallas (0 = perfecto),
así puedes usarlo en automatizaciones.

---

## 👤 Pasos manuales (los únicos 4, por seguridad no se automatizan)

1. **Abrir Ghostty** la primera vez: Cmd+Espacio → "Ghostty" → Enter.
   (Opcional: arrástrala al Dock. En Ajustes de Ghostty puedes ponerla
   como terminal por defecto.)
2. **Autenticar GitHub CLI** (para PRs/issues con `\gp`):
   ```bash
   gh auth login
   # → GitHub.com → HTTPS → Login with a web browser
   ```
3. **Identidad de git** (para poder commitear):
   ```bash
   git config --global user.name  "christian barillas"
   git config --global user.email "70426461+ChristianBarillas@users.noreply.github.com"
   ```
4. **Solo para apps móviles**: `flutter doctor` te dirá qué falta del
   toolchain móvil (Xcode completo para iOS, Android Studio para
   Android). Para web/desktop no necesitas nada.

💡 Recomendado (una vez): Ajustes del Sistema → Teclado → sube
"Velocidad de repetición de tecla" al máximo y baja "Retardo hasta la
repetición" — en Vim la diferencia es enorme.

---

## 🔍 Cómo comprobar que todo quedó bien

```bash
# Dentro de una terminal nueva (Ghostty):
v .            # abre Neovim (alias) — debe verse el dashboard con íconos
```

Dentro de Neovim:

| Comando | Debe mostrar |
|---|---|
| `:checkhealth` | Sin líneas `ERROR` (algunos WARN son normales) |
| `:Lazy` | 65 plugins, todos con ✓ |
| `:Mason` | Todos los paquetes con ✓ |
| `:LspInfo` (en un archivo de código) | El servidor conectado |
| `:Guia` | La guía de atajos |

---

## 🚑 Solución de problemas

| Problema | Solución |
|---|---|
| El script falló a la mitad | Re-ejecuta `bash ~/.config/nvim/install.sh` — es idempotente |
| Íconos como `▯` | Estás en Terminal.app sin la fuente: usa Ghostty, o configura "JetBrainsMono Nerd Font Mono" en Terminal → Ajustes → Perfiles → Texto |
| Colores feos/lavados | Terminal.app no soporta true color: usa Ghostty |
| Un LSP no conecta | `:Mason` para reinstalarlo; `:LspInfo` para diagnosticar |
| Mason marcó fallos | Re-ejecuta el script, o `:MasonInstall <paquete>` a mano |
| `tree-sitter no encontrado` | `brew install tree-sitter-cli` |
| Empezar Neovim de CERO | `rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim` y re-ejecuta el script (la config no se pierde: vive en el repo) |
| Deshacer TODO | Ver "Desinstalación" abajo |

## 🗑️ Desinstalación / rollback completo

```bash
# Neovim y sus datos
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
rm ~/.config/nvim              # es un symlink; el repo queda intacto

# Restaurar config previa si existía respaldo
ls -d ~/.config/nvim.respaldo.* 2>/dev/null   # y mv de vuelta si quieres

# Quitar el bloque de ~/.zshrc: edítalo y borra el bloque marcado
# "Neovim como editor principal"

# Herramientas (solo si de verdad quieres quitarlas)
brew uninstall neovim tree-sitter-cli lazygit
brew uninstall --cask ghostty font-jetbrains-mono-nerd-font flutter
```

---

## 🤖 Nota para asistentes de AI

Si estás ayudando a instalar o migrar este entorno: lee primero
[AGENTS.md](AGENTS.md) (contexto, reglas y decisiones técnicas). La
lista de paquetes de Mason en `install.sh` debe mantenerse en sincronía
con `lua/craftzdog/plugins/lsp.lua` (ensure_installed + tool-installer)
y `lua/craftzdog/plugins/dap.lua`. Toda modificación se registra en
[CHANGELOG.md](CHANGELOG.md).
