#!/bin/bash

# Get the absolute path of the dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🚀 Starting dotfiles installation from $DOTFILES_DIR"

# Helper function to create symlinks safely
# Arguments: source_path, destination_path
create_symlink() {
    local src="$1"
    local dest="$2"

    # Ensure the parent directory of the destination exists
    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ]; then
        echo "  ✅ $dest is already a symlink. Skipping."
    elif [ -e "$dest" ]; then
        echo "  ⚠️  $dest exists and is NOT a symlink. Skipping to avoid overwriting your data."
    else
        echo "  🔗 Linking $dest -> $src"
        ln -s "$src" "$dest"
    fi
}

# 1. Symlink each folder in .config to ~/.config/[folder-name]
echo ""
echo "📂 Processing .config directories..."
CONFIG_SRC_DIR="$DOTFILES_DIR/.config"

for item in "$CONFIG_SRC_DIR"/*; do
    if [ -d "$item" ]; then
        folder_name=$(basename "$item")
        create_symlink "$item" "$HOME/.config/$folder_name"
    fi
done

# 2. Symlink .vimrc
echo ""
echo "📝 Processing .vimrc..."
VIMRC_SRC="$DOTFILES_DIR/.vimrc"

create_symlink "$VIMRC_SRC" "$HOME/.vimrc"

echo ""
echo "✨ Installation complete!"
