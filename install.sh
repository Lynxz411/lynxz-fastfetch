#!/usr/bin/env bash

set -e

echo "Installing Lynxz Fastfetch..."

if ! command -v fastfetch &> /dev/null; then
    echo "Fastfetch not installed."
    exit 1
fi

TARGET_DIR="$HOME/.config/fastfetch"
mkdir -p "$TARGET_DIR"

# Backup
if [ -f "$TARGET_DIR/config.jsonc" ]; then
    mv "$TARGET_DIR/config.jsonc" "$TARGET_DIR/config.jsonc.bak.$(date +%s)"
fi

cp config/config.jsonc "$TARGET_DIR/"
cp -r images "$TARGET_DIR/"

echo "Done. Restart terminal."
