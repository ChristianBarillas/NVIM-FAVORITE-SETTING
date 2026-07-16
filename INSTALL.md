# INSTALL.md — Instalación completa en una computadora nueva

> **El objetivo de este documento**: que el día que estrenes una Mac,
> traigas este repositorio, corras **un solo comando**, y en ~15 minutos
> tengas tu entorno de desarrollo completo, idéntico, verificado y sin
> omisiones. Todo lo que compone el entorno está inventariado aquí.

---

## 🧭 La frontera: qué hace el script y qué haces tú

**Regla de la casa**: las cosas de sistema se instalan **a mano, de
forma natural en Mac** — el script jamás instala Xcode, Homebrew,
Flutter ni aplicaciones. Solo las **verifica** y, si faltan, te muestra
el comando exacto y se detiene con amabilidad.

| Lo instalas TÚ (sistema) | Lo instala el SCRIPT (ámbito del editor) |
|---|---|
| Command Line Tools de Xcode | Herramientas de terminal vía brew (neovim, git, node, python, ripgrep, fd, fzf, tree-sitter-cli, lazygit, gh) |
| Homebrew | Fuente JetBrainsMono Nerd Font (recurso del editor) |
| Flutter SDK (opcional) | La config en `~/.config/nvim` (con respaldo de lo previo) |
| Ghostty u otra terminal (opcional) | Config de Ghostty **solo si ya la tienes instalada** |
| Xcode completo / Android Studio (móvil) | Bloque de `~/.zshrc` (EDITOR, aliases) y `brew shellenv` en `~/.zprofile` |
| | 65 plugins + 26 parsers + 21 paquetes de Mason, verificados |

## 🖐️ Paso 0 — Lo que instalas tú (una sola vez, ~10 min)

```bash
# 1. Compilador (diálogo de macOS, acéptalo y espera)
xcode-select --install

# 2. Homebrew (pedirá tu contraseña; sigue sus "Next steps" al final)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Opcionales, cuando tú quieras:
brew install --cask ghostty      # terminal recomendada (true color)
brew install --cask flutter      # SDK de Flutter (~3 GB)
```

## ⚡ El comando único (después del paso 0)

```bash
git clone https://github.com/ChristianBarillas/NVIM-FAVORITE-SETTING.git ~/.config/nvim && bash ~/.config/nvim/install.sh
```

El script es **idempotente**: puedes correrlo las veces que quieras; lo
que ya está lo salta, lo que falta lo instala, y al final imprime un
resumen ✓/✗. Si algo falla (internet, etc.), re-ejecútalo y continúa.
Si instalas Ghostty o Flutter DESPUÉS, re-ejecuta el script y él
escribe la config de Ghostty; el soporte de Flutter en el editor se
activa solo.

### Tiempo estimado

| Fase | Tiempo aprox. |
|---|---|
| Paso 0 manual (CLT + Homebrew) | ~10 min |
| Script: herramientas + fuente | 3-5 min |
| Script: plugins + parsers + LSPs de Mason | 5-8 min |
| **Total** | **~20 min** |

---

## 📦 Inventario completo (lo que el script instala, sin omisiones)

### 1. Base del sistema (la instalas tú; el script solo verifica)

| Qué | Cómo la instalas tú | Para qué |
|---|---|---|
| Command Line Tools de Xcode | `xcode-select --install` | Compilador C (parsers de treesitter, fzf-native) |
| Homebrew | instalador oficial de brew.sh | Gestor de paquetes (el script sí agrega `brew shellenv` a `~/.zprofile`) |
| Ghostty (opcional) | `brew install --cask ghostty` | Terminal con true color; el script le escribe la config si existe |
| Flutter SDK (opcional) | `brew install --cask flutter` | Dart/Flutter; flutter-tools lo detecta solo |

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
| `tmux` | Sesiones persistentes: SSH que sobrevive desconexiones, agentes AI en paralelo |

### 3. Fuente (único cask que el script instala: es un recurso del editor)

| Cask | Para qué |
|---|---|
| `font-jetbrains-mono-nerd-font` | Fuente con TODOS los íconos (Nerd Font v3) |

### 4. Archivos de configuración que el script escribe/toca

| Archivo | Qué hace el script |
|---|---|
| `~/.config/nvim` | Symlink al repo (si había algo, lo respalda como `nvim.respaldo.FECHA`) |
| `~/.config/ghostty/config` | Tema `Solarized Osaka Night` + Nerd Font (solo si Ghostty está instalada Y no hay config previa) |
| `~/.config/tmux/tmux.conf` | Symlink a `extras/tmux.conf` del repo (solo si no existe) |
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

## 👤 Pasos manuales de identidad (por seguridad no se automatizan)

1. **Autenticar GitHub CLI** (para PRs/issues con `\gp`):
   ```bash
   gh auth login
   # → GitHub.com → HTTPS → Login with a web browser
   ```
2. **Identidad de git** (para poder commitear):
   ```bash
   git config --global user.name  "christian barillas"
   git config --global user.email "70426461+ChristianBarillas@users.noreply.github.com"
   ```
3. **Solo para apps móviles** (si instalaste Flutter): `flutter doctor`
   te dirá qué falta del toolchain móvil (Xcode completo para iOS,
   Android Studio para Android). Para web/desktop no necesitas nada.

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
