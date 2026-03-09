#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/Lynxz411/lynxz-fastfetch.git"
TARGET_DIR="$HOME/.config/fastfetch"
FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="JetBrainsMono Nerd Font"

echo "⚡ Installing Lynxz Fastfetch..."

# -----------------------------
# Detect shell
# -----------------------------
CURRENT_SHELL=$(basename "$SHELL")

if [ "$CURRENT_SHELL" = "bash" ]; then
    RC_FILE="$HOME/.bashrc"
elif [ "$CURRENT_SHELL" = "zsh" ]; then
    RC_FILE="$HOME/.zshrc"
elif [ "$CURRENT_SHELL" = "fish" ]; then
    RC_FILE="$HOME/.config/fish/config.fish"
    # Pastikan folder config fish sudah ada
    mkdir -p "$HOME/.config/fish"
else
    echo "Unsupported shell: $CURRENT_SHELL"
    exit 1
fi

echo "Detected shell: $CURRENT_SHELL"

# -----------------------------
# Check fastfetch
# -----------------------------
if ! command -v fastfetch &> /dev/null; then
    echo "❌ Fastfetch is not installed"
    echo "Install it first then re-run this script, type sudo pacman -S fastfetch and press enter"
    exit 1
fi

# -----------------------------
# Install config
# -----------------------------
mkdir -p "$TARGET_DIR"

if [ -f "$TARGET_DIR/config.jsonc" ]; then
    mv "$TARGET_DIR/config.jsonc" "$TARGET_DIR/config.jsonc.bak.$(date +%s)"
fi

# Pastikan folder config dan images ada sebelum dicopy
[ -d "config" ] && cp config/config.jsonc "$TARGET_DIR/" || echo "Warning: config/config.jsonc not found."
[ -d "images" ] && cp -r images "$TARGET_DIR/"

echo "✔ Config installed."

# -----------------------------
# Inject fastfetch to shell rc
# -----------------------------
# Tambahkan 2>/dev/null untuk mencegah error jika file RC belum ada
if ! grep -q "fastfetch" "$RC_FILE" 2>/dev/null; then
    echo "" >> "$RC_FILE"
    echo "# Lynxz Fastfetch" >> "$RC_FILE"
    echo "fastfetch" >> "$RC_FILE"
    echo "✔ fastfetch added to $RC_FILE"
else
    echo "fastfetch already in $RC_FILE"
fi

# -----------------------------
# Install JetBrainsMono Nerd Font
# -----------------------------
if [ ! -d "$FONT_DIR" ]; then
    mkdir -p "$FONT_DIR"
fi

if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    echo "🧠 Installing JetBrainsMono Nerd Font..."

    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"

    curl -fLo "JetBrainsMono.zip" \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

    unzip JetBrainsMono.zip
    cp *.ttf "$FONT_DIR/"
    fc-cache -fv

    cd -
    rm -rf "$TMP_DIR"

    echo "✔ Font installed."
else
    echo "JetBrainsMono Nerd Font already installed."
fi

echo
echo "Fastfetch theme installed successfully!"
echo "If you wanna change system information you can edit the file ~/.config/fastfetch/config.jsonc"
echo "Btw if you don't know how to set picture you can edit "source": "fastfetch.jpg" to your photo (only 1:1 photo)"
echo "Restart terminal or run: source $RC_FILE"
