#!/bin/bash

set -e

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}${BOLD}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}${BOLD}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}${BOLD}[WARN]${NC} $1"; }
error() { echo -e "${RED}${BOLD}[ERROR]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

echo -e "${BOLD}========================================${NC}"
echo -e "${BOLD}         Neovim Setup Script            ${NC}"
echo -e "${BOLD}========================================${NC}\n"

# 1. Dependency checks
info "Checking essential dependencies..."
if ! command -v nvim >/dev/null 2>&1; then
  warn "Neovim is not installed or not in PATH."
else
  NVIM_VERSION=$(nvim --version | head -n 1)
  success "Found $NVIM_VERSION"
fi

if ! command -v git >/dev/null 2>&1; then
  error "git is required but not installed."
  exit 1
fi

# 2. Setup git hooks if directory exists
if [ -d "$SCRIPT_DIR/hooks" ]; then
  git -C "$SCRIPT_DIR" config core.hooksPath hooks
  chmod +x "$SCRIPT_DIR"/hooks/* 2>/dev/null || true
  success "Configured git hooks"
fi

# 3. Confirmation prompt
echo ""
echo -e "This will install the Neovim configuration to:"
echo -e "  ${BOLD}$TARGET_DIR${NC}"
if [ -d "$TARGET_DIR" ]; then
  echo -e "Existing configuration will be backed up safely.\n"
fi

read -rp "Proceed with setup? (y/N): " confirm
if [[ ! "$confirm" =~ ^[yY]([eE][sS])?$ ]]; then
  info "Setup aborted by user."
  exit 0
fi

# 4. Backup existing config
if [ -d "$TARGET_DIR" ]; then
  BACKUP_DIR="${TARGET_DIR}-bak-$(date +%Y%m%d_%H%M%S)"
  info "Backing up existing configuration to: $BACKUP_DIR"
  mv "$TARGET_DIR" "$BACKUP_DIR"
  success "Backup created at $BACKUP_DIR"
fi

# 5. Deploy new configuration
info "Installing configuration..."
mkdir -p "$TARGET_DIR"

# Copy core configuration files and directories
for item in init.lua lazy-lock.json lua ftplugin; do
  if [ -e "$SCRIPT_DIR/$item" ]; then
    cp -r "$SCRIPT_DIR/$item" "$TARGET_DIR/"
  fi
done

success "Configuration successfully copied to $TARGET_DIR"

# 6. Optional cache/state cleanup
echo ""
read -rp "Do you want to clean Neovim cache and plugin storage (~/.cache/nvim and ~/.local/share/nvim)? (y/N): " clean_cache
if [[ "$clean_cache" =~ ^[yY]([eE][sS])?$ ]]; then
  info "Cleaning cache and data directories..."
  rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
  rm -rf "${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
  rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/nvim"
  success "Cache and storage wiped clean for fresh start."
else
  info "Kept existing cache and plugins."
fi

echo ""
success "Setup complete! Launch Neovim with 'nvim' to initialize plugins."
