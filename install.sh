#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
#  NVIM-FAVORITE-SETTING — instalación completa en una Mac nueva
#
#  USO (un solo comando):
#    git clone https://github.com/ChristianBarillas/NVIM-FAVORITE-SETTING.git ~/.config/nvim && bash ~/.config/nvim/install.sh
#
#  FRONTERA DEL SCRIPT (decisión del dueño del repo):
#    · Las cosas de SISTEMA las instalas TÚ, de forma natural en Mac:
#      Command Line Tools de Xcode, Homebrew, Flutter, apps (Ghostty...).
#      El script solo las VERIFICA y te dice el comando exacto si faltan.
#    · El script instala únicamente el ÁMBITO DEL EDITOR:
#      herramientas de terminal por brew, la fuente de íconos, la config
#      en su lugar, plugins, parsers y paquetes de Mason.
#
#  Qué hace (todo idempotente: se puede re-ejecutar sin miedo):
#    1. VERIFICA requisitos de sistema (CLT de Xcode, Homebrew) — no
#       los instala; si faltan, te muestra cómo y se detiene
#    2. Herramientas de terminal: neovim git node python ripgrep fd fzf
#       tree-sitter-cli lazygit gh
#    3. Fuente JetBrainsMono Nerd Font (cask)
#    4. Config en su lugar (~/.config/nvim) con respaldo de lo previo
#    5. Config de Ghostty (solo si YA tienes Ghostty) + zshrc
#    6. Plugins (lazy.nvim), parsers de treesitter, y TODOS los
#       paquetes de Mason (LSPs, formateadores, linters, debuggers)
#    7. Verificación final con resumen ✓/✗ (incluye estado de Flutter,
#       Ghostty y gh auth como informativos)
#
#  La guía completa está en INSTALL.md
# ══════════════════════════════════════════════════════════════════════
set -uo pipefail

AZUL=$'\033[1;34m'; VERDE=$'\033[1;32m'; AMARILLO=$'\033[1;33m'; ROJO=$'\033[1;31m'; FIN=$'\033[0m'
info()  { printf '%s==>%s %s\n' "$AZUL" "$FIN" "$1"; }
ok()    { printf '%s ✓ %s %s\n' "$VERDE" "$FIN" "$1"; }
avisa() { printf '%s ! %s %s\n' "$AMARILLO" "$FIN" "$1"; }
falla() { printf '%s ✗ %s %s\n' "$ROJO" "$FIN" "$1"; }

FALLAS=0
paso_critico() { # paso_critico "descripción" comando...
  local desc="$1"; shift
  if "$@"; then ok "$desc"; else falla "$desc"; FALLAS=$((FALLAS+1)); fi
}

[ "$(uname -s)" = "Darwin" ] || { falla "Este script es para macOS."; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CFG="$HOME/.config/nvim"

# ── 1. Requisitos de sistema: SOLO SE VERIFICAN, los instalas tú ──────
info "1/7 · Verificando requisitos de sistema (no se instalan solos)"

if xcode-select -p >/dev/null 2>&1; then
  ok "Command Line Tools de Xcode"
else
  falla "Faltan las Command Line Tools de Xcode (compilador C)."
  cat <<'EOF'

   Instálalas tú, de forma natural en Mac (una sola vez):

       xcode-select --install

   Acepta el diálogo, espera a que termine, y vuelve a correr este
   script. (Si tienes Xcode completo de la App Store, también sirve.)
EOF
  exit 1
fi

# Activar brew en esta sesión si existe (Apple Silicon o Intel)
for BREW_BIN in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [ -x "$BREW_BIN" ] && eval "$("$BREW_BIN" shellenv)" && break
done
if command -v brew >/dev/null 2>&1; then
  ok "Homebrew $(brew --version | head -1 | awk '{print $2}')"
  if ! grep -q 'brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
    printf '\neval "$(%s shellenv)"\n' "$(command -v brew)" >> "$HOME/.zprofile"
    ok "brew shellenv agregado a ~/.zprofile (para nuevas terminales)"
  fi
else
  falla "Falta Homebrew."
  cat <<'EOF'

   Instálalo tú con el comando oficial de https://brew.sh :

       /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

   Al terminar sigue las 2 líneas de "Next steps" que imprime, y
   vuelve a correr este script.
EOF
  exit 1
fi

# Informativos (opcionales, también los instalas tú si los quieres):
command -v flutter >/dev/null 2>&1 \
  && ok "Flutter SDK detectado (el soporte del editor se activa solo)" \
  || avisa "Flutter no está (opcional). Cuando lo quieras: brew install --cask flutter"
[ -d "/Applications/Ghostty.app" ] \
  && ok "Ghostty detectada" \
  || avisa "Ghostty no está (opcional, recomendada). Cuando la quieras: brew install --cask ghostty"

# ── 2. Herramientas de terminal (formulas) ────────────────────────────
info "2/7 · Herramientas del editor (brew install)"
FORMULAS=(neovim git node python ripgrep fd fzf tree-sitter-cli lazygit gh tmux)
for f in "${FORMULAS[@]}"; do
  if brew list --formula "$f" >/dev/null 2>&1; then
    ok "$f (ya estaba)"
  else
    paso_critico "$f" brew install "$f"
  fi
done

# ── 3. Fuente con íconos (único cask: es un recurso del editor) ───────
info "3/7 · Fuente JetBrainsMono Nerd Font"
if brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1; then
  ok "font-jetbrains-mono-nerd-font (ya estaba)"
else
  paso_critico "font-jetbrains-mono-nerd-font" brew install --cask font-jetbrains-mono-nerd-font
fi

# ── 4. La configuración en su lugar (~/.config/nvim) ──────────────────
info "4/7 · Configuración de Neovim en ~/.config/nvim"
mkdir -p "$HOME/.config"
REAL_CFG="$(readlink -f "$NVIM_CFG" 2>/dev/null || echo '')"
if [ "$REAL_CFG" = "$SCRIPT_DIR" ]; then
  ok "~/.config/nvim ya apunta a este repositorio"
elif [ ! -e "$NVIM_CFG" ]; then
  ln -s "$SCRIPT_DIR" "$NVIM_CFG"
  ok "Symlink creado: ~/.config/nvim → $SCRIPT_DIR"
else
  RESPALDO="$HOME/.config/nvim.respaldo.$(date +%Y%m%d%H%M%S)"
  mv "$NVIM_CFG" "$RESPALDO"
  avisa "Config previa respaldada en: $RESPALDO"
  ln -s "$SCRIPT_DIR" "$NVIM_CFG"
  ok "Symlink creado: ~/.config/nvim → $SCRIPT_DIR"
fi

# ── 5. Ghostty (solo config, y solo si TÚ ya la instalaste) y zsh ─────
info "5/7 · Terminal y shell"
GHOSTTY_CFG="$HOME/.config/ghostty/config"
if [ ! -d "/Applications/Ghostty.app" ]; then
  avisa "Ghostty no está instalada: no se escribe su configuración."
elif [ ! -f "$GHOSTTY_CFG" ]; then
  mkdir -p "$(dirname "$GHOSTTY_CFG")"
  cat > "$GHOSTTY_CFG" <<'EOF'
# Configuración de Ghostty — a juego con NVIM-FAVORITE-SETTING
theme = Solarized Osaka Night
font-family = JetBrainsMono Nerd Font
font-size = 14
mouse-hide-while-typing = true
macos-option-as-alt = true
window-save-state = always
copy-on-select = clipboard
shell-integration = zsh
unfocused-split-opacity = 0.92
EOF
  ok "Ghostty configurada (tema y fuente a juego con el editor)"
else
  ok "Ghostty ya tenía configuración (no se toca)"
fi

# tmux: enlazar la config del repo (sesiones persistentes, SSH, agentes AI)
TMUX_CFG="$HOME/.config/tmux/tmux.conf"
if [ ! -e "$TMUX_CFG" ]; then
  mkdir -p "$(dirname "$TMUX_CFG")"
  ln -s "$SCRIPT_DIR/extras/tmux.conf" "$TMUX_CFG"
  ok "tmux configurado (~/.config/tmux/tmux.conf → repo)"
else
  ok "tmux ya tenía configuración (no se toca)"
fi

if ! grep -q "EDITOR=nvim" "$HOME/.zshrc" 2>/dev/null; then
  cat >> "$HOME/.zshrc" <<'EOF'

# ─── Neovim como editor principal (ver repo NVIM-FAVORITE-SETTING) ───
export EDITOR=nvim
export VISUAL=nvim
alias v='nvim'          # v archivo.txt  |  v .
alias vim='nvim'        # por costumbre
alias neovim='nvim'     # por si escribes el nombre completo
alias lg='lazygit'      # git visual en la terminal
# ──────────────────────────────────────────────────────────────────────
EOF
  ok "EDITOR=nvim y aliases v/lg agregados a ~/.zshrc"
else
  ok "~/.zshrc ya estaba configurado"
fi

# ── 6. Plugins, parsers y paquetes de Mason (headless) ────────────────
info "6/7 · Plugins, sintaxis y servidores de lenguaje (esto tarda unos minutos)"

info "   Plugins con lazy.nvim..."
if nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1; then
  ok "Plugins sincronizados"
else
  falla "Lazy sync devolvió error (revisa abriendo nvim)"; FALLAS=$((FALLAS+1))
fi

info "   Parsers de treesitter (compilación)..."
if nvim --headless -c "lua require('nvim-treesitter').install({'astro','bash','css','dart','diff','dockerfile','gitcommit','gitignore','html','javascript','json','lua','markdown','markdown_inline','php','python','regex','scss','sql','toml','tsx','typescript','vim','vimdoc','yaml'}):wait(600000)" -c q >/dev/null 2>&1; then
  ok "Parsers compilados"
else
  falla "Parsers de treesitter"; FALLAS=$((FALLAS+1))
fi

info "   Paquetes de Mason: LSPs, formateadores, linters y debuggers..."
MASON_LUA="$(mktemp /tmp/mason_install.XXXXXX)"
cat > "$MASON_LUA" <<'EOF'
-- Instala TODOS los paquetes de Mason y verifica en disco
-- (mantener en sincronía con lua/craftzdog/plugins/lsp.lua y dap.lua)
local pkgs = {
  -- LSPs
  'lua-language-server', 'vtsls', 'html-lsp', 'css-lsp',
  'tailwindcss-language-server', 'astro-language-server',
  'pyright', 'ruff', 'intelephense', 'json-lsp',
  'yaml-language-server', 'bash-language-server',
  'dockerfile-language-server', 'emmet-language-server', 'marksman',
  -- Formateadores y linters
  'prettierd', 'eslint_d', 'stylua', 'djlint',
  -- Debuggers
  'debugpy', 'js-debug-adapter',
}
require('mason').setup()
local reg = require('mason-registry')
reg.refresh()
local resultado = {}
reg:on('package:install:success', vim.schedule_wrap(function(p) resultado[p.name] = true end))
reg:on('package:install:failed', vim.schedule_wrap(function(p) resultado[p.name] = false end))
local pendientes = 0
for _, name in ipairs(pkgs) do
  local ok_pkg, p = pcall(reg.get_package, name)
  if ok_pkg and not p:is_installed() then
    pendientes = pendientes + 1
    p:install()
  end
end
if pendientes > 0 then
  vim.wait(900000, function()
    local n = 0
    for _, v in pairs(resultado) do if v ~= nil then n = n + 1 end end
    return n >= pendientes
  end, 3000)
end
-- verificación real: el directorio del paquete debe existir
local fallos = 0
for _, name in ipairs(pkgs) do
  local dir = vim.fn.stdpath('data') .. '/mason/packages/' .. name
  if not (vim.uv or vim.loop).fs_stat(dir) then
    print('MASON_FALLO: ' .. name)
    fallos = fallos + 1
  end
end
print('MASON_RESUMEN: ' .. (#pkgs - fallos) .. '/' .. #pkgs)
EOF
MASON_OUT="$(nvim --headless -c "luafile $MASON_LUA" -c q 2>&1 | tr -d '\r')"
rm -f "$MASON_LUA"
echo "$MASON_OUT" | grep -o 'MASON_FALLO: [a-z0-9_-]*' || true
RESUMEN_MASON="$(echo "$MASON_OUT" | grep -o 'MASON_RESUMEN: [0-9/]*' | tail -1)"
if echo "$RESUMEN_MASON" | grep -q "21/21"; then
  ok "Mason: ${RESUMEN_MASON#MASON_RESUMEN: } paquetes"
else
  falla "Mason incompleto (${RESUMEN_MASON:-sin respuesta}) — re-ejecuta el script o abre :Mason"
  FALLAS=$((FALLAS+1))
fi

# ── 7. Verificación final ─────────────────────────────────────────────
info "7/7 · Verificación final"

for cmd in nvim git node rg fd fzf tree-sitter lazygit gh; do
  if command -v "$cmd" >/dev/null 2>&1; then ok "comando: $cmd"; else falla "comando: $cmd"; FALLAS=$((FALLAS+1)); fi
done

if nvim --headless "+lua print('BOOT_OK')" +qa 2>&1 | grep -q "BOOT_OK"; then
  ok "Neovim arranca sin errores"
else
  falla "Neovim no arranca limpio"; FALLAS=$((FALLAS+1))
fi

NPARSERS="$(ls "$HOME/.local/share/nvim/site/parser" 2>/dev/null | wc -l | tr -d ' ')"
[ "${NPARSERS:-0}" -ge 25 ] && ok "Parsers de treesitter: $NPARSERS" || { falla "Parsers: solo $NPARSERS (esperados ≥25)"; FALLAS=$((FALLAS+1)); }

command -v flutter >/dev/null 2>&1 && ok "Flutter SDK: $(flutter --version 2>/dev/null | head -1 | awk '{print $2}')" || avisa "Flutter no instalado (opcional; el soporte del editor se activa solo al instalarlo)"

# ── Resumen y pasos manuales ──────────────────────────────────────────
echo
if [ "$FALLAS" -eq 0 ]; then
  printf '%s══════════════════════════════════════════════════%s\n' "$VERDE" "$FIN"
  ok "TODO LISTO, sin fallas."
else
  printf '%s══════════════════════════════════════════════════%s\n' "$AMARILLO" "$FIN"
  avisa "Terminó con $FALLAS falla(s) — revisa arriba y re-ejecuta: bash ~/.config/nvim/install.sh"
fi
cat <<'EOF'

  Cosas de sistema que instalas TÚ cuando quieras (el script no las toca):
   · Terminal recomendada:  brew install --cask ghostty
     (si ya está, este script le deja la config a juego con el editor)
   · Flutter:               brew install --cask flutter
     y para apps móviles:   flutter doctor

  Pasos manuales de identidad (por seguridad no se automatizan):
   · GitHub CLI:     gh auth login        (para PRs/issues con \gp)
   · Identidad git:  git config --global user.name  "Tu Nombre"
                     git config --global user.email "tu@email"

  Para empezar:  abre tu terminal  →  v .
  Guía de atajos dentro de Neovim:  :Guia
EOF
exit "$FALLAS"
