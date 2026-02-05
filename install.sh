#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

info() { printf '\033[34m[info]\033[0m %s\n' "$1"; }
ok()   { printf '\033[32m[ok]\033[0m   %s\n' "$1"; }
warn() { printf '\033[33m[warn]\033[0m %s\n' "$1"; }

link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    warn "$dst already exists (not a symlink), skipping"
    return
  fi
  ln -s "$src" "$dst"
  ok "$dst -> $src"
}

#--------------------------------------
# Symlinks: $HOME directly
#--------------------------------------
info "Creating symlinks..."

home_files=(
  .zshrc
  .zshenv
  .zsh_profile
  .gitconfig
  .tmux.conf
  .ideavimrc
  .xvimrc
  .tigrc
  .zpreztorc
)

for f in "${home_files[@]}"; do
  link "$DOTFILES/$f" "$HOME/$f"
done

#--------------------------------------
# Symlinks: .config directories
#--------------------------------------
mkdir -p "$HOME/.config"

config_dirs=(
  nvim
  alacritty
)

for d in "${config_dirs[@]}"; do
  link "$DOTFILES/.config/$d" "$HOME/.config/$d"
done

#--------------------------------------
# Zprezto
#--------------------------------------
ZPREZTO_DIR="${ZDOTDIR:-$HOME}/.zprezto"
if [ -d "$ZPREZTO_DIR" ]; then
  ok "Zprezto already installed"
else
  info "Installing Zprezto..."
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "$ZPREZTO_DIR"
  ok "Zprezto installed"
fi

#--------------------------------------
# TPM (Tmux Plugin Manager)
#--------------------------------------
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ -d "$TPM_DIR" ]; then
  ok "TPM already installed"
else
  info "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  ok "TPM installed"
fi

#--------------------------------------
# Tmux plugins
#--------------------------------------
if [ -x "$TPM_DIR/bin/install_plugins" ]; then
  info "Installing tmux plugins..."
  "$TPM_DIR/bin/install_plugins"
  ok "Tmux plugins installed"
fi

#--------------------------------------
# Neovim plugins (lazy.nvim)
#--------------------------------------
if command -v nvim &>/dev/null; then
  info "Syncing Neovim plugins..."
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
  ok "Neovim plugins synced"
else
  warn "nvim not found, skipping plugin sync"
fi

#--------------------------------------
# Reminder
#--------------------------------------
echo ""
info "Done! Remaining manual steps:"
echo "  1. Create ~/.zshenv.local with your API keys"
echo "  2. Restart your shell: exec zsh -l"
