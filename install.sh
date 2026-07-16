#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
#  NVIM-FAVORITE-SETTING — instalación en una máquina nueva (macOS)
#
#  Uso:
#    git clone https://github.com/ChristianBarillas/NVIM-FAVORITE-SETTING.git ~/.config/nvim
#    cd ~/.config/nvim && bash install.sh
# ══════════════════════════════════════════════════════════════════════
set -euo pipefail

info()  { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
ok()    { printf '\033[1;32m ✓ \033[0m %s\n' "$1"; }
avisa() { printf '\033[1;33m ! \033[0m %s\n' "$1"; }

# ── 1. Homebrew ───────────────────────────────────────────────────────
if ! command -v brew >/dev/null 2>&1; then
  info "Instalando Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
ok "Homebrew"

# ── 2. Herramientas de sistema (todas por Homebrew) ───────────────────
info "Instalando herramientas..."
brew install neovim git node ripgrep fd tree-sitter-cli lazygit gh 2>/dev/null || true
ok "neovim, git, node, ripgrep, fd, tree-sitter-cli, lazygit, gh"

# ── 3. Fuente con íconos y terminal ───────────────────────────────────
brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || true
ok "JetBrainsMono Nerd Font"
if [ ! -d "/Applications/Ghostty.app" ]; then
  brew install --cask ghostty 2>/dev/null || true
  ok "Ghostty (terminal)"
fi

# Config de Ghostty a juego con el editor (si no existe ya)
GHOSTTY_CFG="$HOME/.config/ghostty/config"
if [ ! -f "$GHOSTTY_CFG" ]; then
  mkdir -p "$(dirname "$GHOSTTY_CFG")"
  cat > "$GHOSTTY_CFG" <<'EOF'
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
  ok "Configuración de Ghostty escrita"
fi

# ── 4. Neovim como editor por defecto + aliases ───────────────────────
if ! grep -q "EDITOR=nvim" "$HOME/.zshrc" 2>/dev/null; then
  cat >> "$HOME/.zshrc" <<'EOF'

# ─── Neovim como editor principal (ver repo NVIM-FAVORITE-SETTING) ───
export EDITOR=nvim
export VISUAL=nvim
alias v='nvim'
alias lg='lazygit'
# ──────────────────────────────────────────────────────────────────────
EOF
  ok "EDITOR=nvim y aliases agregados a ~/.zshrc"
fi

# ── 5. Plugins, LSPs y parsers (todo headless) ────────────────────────
info "Instalando plugins (lazy.nvim)..."
nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1 || true
ok "Plugins"

info "Compilando parsers de treesitter..."
nvim --headless -c "lua require('nvim-treesitter').install({'astro','bash','css','dart','diff','dockerfile','gitcommit','gitignore','html','javascript','json','lua','markdown','markdown_inline','php','python','regex','scss','sql','toml','tsx','typescript','vim','vimdoc','yaml'}):wait(600000)" -c q >/dev/null 2>&1 || true
ok "Parsers"

avisa "Los LSPs de Mason terminan de instalarse en el primer arranque (:Mason para ver)."

# ── 6. Extras opcionales ──────────────────────────────────────────────
command -v flutter >/dev/null 2>&1 || avisa "Flutter no está: brew install --cask flutter (el soporte se activa solo)"
gh auth status >/dev/null 2>&1 || avisa "GitHub CLI sin autenticar: corre 'gh auth login' para usar Octo (\\gp)"

echo
ok "¡Listo! Abre Ghostty y escribe: nvim"
echo "   Guía de atajos: :Guia dentro de Neovim, o COMANDOS.md"
