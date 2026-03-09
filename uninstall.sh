#!/usr/bin/env bash

TARGET_DIR="$HOME/.config/fastfetch"
CURRENT_SHELL=$(basename "$SHELL")

if [ "$CURRENT_SHELL" = "bash" ]; then
    RC_FILE="$HOME/.bashrc"
elif [ "$CURRENT_SHELL" = "zsh" ]; then
    RC_FILE="$HOME/.zshrc"
elif [ "$CURRENT_SHELL" = "fish" ]; then
    RC_FILE="$HOME/.config/fish/config.fish"
else
    echo "Unsupported shell."
    exit 1
fi

echo "Removing Lynxz Fastfetch..."

# Remove config
rm -rf "$TARGET_DIR"

# Remove injected line
if [ -f "$RC_FILE" ]; then
    sed -i '/# Lynxz Fastfetch/d' "$RC_FILE"
    sed -i '/^fastfetch$/d' "$RC_FILE"
    echo "✔ Removed config and shell injection from $RC_FILE."
else
    echo "⚠ Shell config file not found, skipping injection removal."
fi

echo "Font not removed (to avoid breaking other apps)."

echo "Uninstall complete, thank you for using my script :)"
