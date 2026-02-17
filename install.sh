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
else
    echo "Unsupported shell: $CURRENT_SHELL"
    exit 1
fi

echo "Detected shell: $CURRENT_SHELL"

# -----------------------------
# Check fastfetch
# -----------------------------
if ! command -v fastfetch &> /dev/null; then
    echo "❌ Fastfetch is not installed."
    echo "Install it first then re-run this script."
    exit 1
fi

# -----------------------------
# Install config
# -----------------------------
mkdir -p "$TARGET_DIR"

if [ -f "$TARGET_DIR/config.jsonc" ]; then
    mv "$TARGET_DIR/config.jsonc" "$TARGET_DIR/config.jsonc.bak.$(date +%s)"
fi

cp config/config.jsonc "$TARGET_DIR/"
[ -d "images" ] && cp -r images "$TARGET_DIR/"

echo "✔ Config installed."

# -----------------------------
# Inject fastfetch to shell rc
# -----------------------------
if ! grep -q "fastfetch" "$RC_FILE"; then
    echo "" >> "$RC_FILE"
    echo "# Lynxz Fastfetch" >> "$RC_FILE"
    echo "fastfetch" >> "$RC_FILE"
    echo "✔ fastfetch added to $RC_FILE"
else
    echo "fastfetch already in $RC_FILE"
fi

# -----------------------------
# Install JetBrainsMono Nerd Font (Linux only)
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
echo "🎉 Lynxz Fastfetch installed successfully!"
echo "Restart terminal or run: source $RC_FILE"
