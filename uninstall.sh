#!/usr/bin/env bash

TARGET_DIR="$HOME/.config/fastfetch"
CURRENT_SHELL=$(basename "$SHELL")

if [ "$CURRENT_SHELL" = "bash" ]; then
    RC_FILE="$HOME/.bashrc"
elif [ "$CURRENT_SHELL" = "zsh" ]; then
    RC_FILE="$HOME/.zshrc"
else
    echo "Unsupported shell."
    exit 1
fi

echo "Removing Lynxz Fastfetch..."

# Remove config
rm -rf "$TARGET_DIR"

# Remove injected line
sed -i '/# Lynxz Fastfetch/d' "$RC_FILE"
sed -i '/^fastfetch$/d' "$RC_FILE"

echo "✔ Removed config and shell injection."
echo "Font not removed (to avoid breaking other apps)."

echo "Uninstall complete."
