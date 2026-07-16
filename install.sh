#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
#  NVIM-FAVORITE-SETTING — instalación completa en una Mac nueva
#
#  USO (un solo comando):
#    git clone https://github.com/ChristianBarillas/NVIM-FAVORITE-SETTING.git ~/.config/nvim && bash ~/.config/nvim/install.sh
#
#  Qué hace (todo idempotente: se puede re-ejecutar sin miedo):
#    1. Command Line Tools de Xcode (compilador para treesitter/fzf)
#    2. Homebrew (+ shellenv en ~/.zprofile)
#    3. Herramientas: neovim git node python ripgrep fd fzf
#       tree-sitter-cli lazygit gh
#    4. Casks: Nerd Font, Ghostty (terminal), Flutter SDK
#    5. Config en su lugar (~/.config/nvim) con respaldo de lo previo
#    6. Ghostty configurada + zshrc (EDITOR=nvim, aliases v/lg)
#    7. Plugins (lazy.nvim), parsers de treesitter, y TODOS los
#       paquetes de Mason (LSPs, formateadores, linters, debuggers)
#    8. Verificación final con resumen ✓/✗
#
#  Variables opcionales:
#    SIN_FLUTTER=1 bash install.sh    # omite el SDK de Flutter (~3 GB)
#
#  La guía completa de lo que se instala está en INSTALL.md
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

# ── 1. Command Line Tools de Xcode ────────────────────────────────────
info "1/8 · Command Line Tools de Xcode (compilador C)"
if ! xcode-select -p >/dev/null 2>&1; then
  avisa "Faltan las Command Line Tools. Se abrirá un diálogo: acéptalo."
  xcode-select --install >/dev/null 2>&1 || true
  until xcode-select -p >/dev/null 2>&1; do
    printf '   esperando a que termine la instalación de CLT...\r'
    sleep 15
  done
  echo
fi
ok "Command Line Tools"

# ── 2. Homebrew ───────────────────────────────────────────────────────
info "2/8 · Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  # Instalador oficial (pedirá tu contraseña de usuario, es normal)
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Activar brew en esta sesión y dejarlo permanente en ~/.zprofile
for BREW_BIN in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [ -x "$BREW_BIN" ] && eval "$("$BREW_BIN" shellenv)" && break
done
command -v brew >/dev/null 2>&1 || { falla "Homebrew no quedó disponible"; exit 1; }
if ! grep -q 'brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
  printf '\neval "$(%s shellenv)"\n' "$(command -v brew)" >> "$HOME/.zprofile"
  ok "brew shellenv agregado a ~/.zprofile"
fi
ok "Homebrew $(brew --version | head -1 | awk '{print $2}')"

# ── 3. Herramientas de terminal (formulas) ────────────────────────────
info "3/8 · Herramientas (brew install)"
FORMULAS=(neovim git node python ripgrep fd fzf tree-sitter-cli lazygit gh)
for f in "${FORMULAS[@]}"; do
  if brew list --formula "$f" >/dev/null 2>&1; then
    ok "$f (ya estaba)"
  else
    paso_critico "$f" brew install "$f"
  fi
done

# ── 4. Fuente, terminal y Flutter (casks) ─────────────────────────────
info "4/8 · Fuente con íconos, Ghostty y Flutter"
CASKS=(font-jetbrains-mono-nerd-font ghostty)
[ "${SIN_FLUTTER:-0}" = "1" ] && avisa "SIN_FLUTTER=1: se omite el SDK de Flutter" || CASKS+=(flutter)
for c in "${CASKS[@]}"; do
  if brew list --cask "$c" >/dev/null 2>&1; then
    ok "$c (ya estaba)"
  else
    paso_critico "$c" brew install --cask "$c"
  fi
done

# ── 5. La configuración en su lugar (~/.config/nvim) ──────────────────
info "5/8 · Configuración de Neovim en ~/.config/nvim"
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

# ── 6. Ghostty y zsh ──────────────────────────────────────────────────
info "6/8 · Terminal y shell"
GHOSTTY_CFG="$HOME/.config/ghostty/config"
if [ ! -f "$GHOSTTY_CFG" ]; then
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

if ! grep -q "EDITOR=nvim" "$HOME/.zshrc" 2>/dev/null; then
  cat >> "$HOME/.zshrc" <<'EOF'

# ─── Neovim como editor principal (ver repo NVIM-FAVORITE-SETTING) ───
export EDITOR=nvim
export VISUAL=nvim
alias v='nvim'          # v archivo.txt  |  v .
alias lg='lazygit'      # git visual en la terminal
# ──────────────────────────────────────────────────────────────────────
EOF
  ok "EDITOR=nvim y aliases v/lg agregados a ~/.zshrc"
else
  ok "~/.zshrc ya estaba configurado"
fi

# ── 7. Plugins, parsers y paquetes de Mason (headless) ────────────────
info "7/8 · Plugins, sintaxis y servidores de lenguaje (esto tarda unos minutos)"

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

# ── 8. Verificación final ─────────────────────────────────────────────
info "8/8 · Verificación final"

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

command -v flutter >/dev/null 2>&1 && ok "Flutter SDK: $(flutter --version 2>/dev/null | head -1 | awk '{print $2}')" || avisa "Flutter no instalado (SIN_FLUTTER=1 u omitido)"

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

  Pasos manuales que ninguna máquina puede hacer por ti:
   1. Abre la app "Ghostty" (Cmd+Espacio → Ghostty) — ya está configurada.
   2. GitHub CLI:      gh auth login        (para PRs/issues con \gp)
   3. Identidad git:   git config --global user.name  "Tu Nombre"
                       git config --global user.email "tu@email"
   4. (Solo si harás apps móviles)  flutter doctor  y sigue sus pasos.

  Para empezar:  abre Ghostty  →  v .
  Guía de atajos dentro de Neovim:  :Guia
EOF
exit "$FALLAS"
