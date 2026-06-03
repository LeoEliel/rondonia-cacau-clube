#!/usr/bin/env bash
# setup.sh — Cacau Clube dev environment bootstrap for GitHub Codespaces
# Installs Flutter (stable), FlutterFire CLI, and Firebase CLI.
# Usage:  bash setup.sh   (then restart your shell or `source ~/.bashrc`)

set -euo pipefail

FLUTTER_DIR="$HOME/flutter"
FLUTTER_CHANNEL="stable"

echo "==> Cacau Clube setup starting..."

# ---------------------------------------------------------------------------
# 1. System dependencies Flutter needs (Debian/Ubuntu Codespaces image)
# ---------------------------------------------------------------------------
echo "==> Installing system dependencies..."
sudo apt-get update -y
sudo apt-get install -y \
  curl git unzip xz-utils zip libglu1-mesa \
  ca-certificates apt-transport-https

# ---------------------------------------------------------------------------
# 2. Flutter SDK (stable channel)
# ---------------------------------------------------------------------------
if [ ! -d "$FLUTTER_DIR" ]; then
  echo "==> Cloning Flutter ($FLUTTER_CHANNEL)..."
  git clone https://github.com/flutter/flutter.git -b "$FLUTTER_CHANNEL" "$FLUTTER_DIR"
else
  echo "==> Flutter already present at $FLUTTER_DIR — updating..."
  git -C "$FLUTTER_DIR" pull --ff-only || true
fi

# Add Flutter + Dart pub-cache to PATH (persist in ~/.bashrc)
if ! grep -q 'flutter/bin' "$HOME/.bashrc" 2>/dev/null; then
  {
    echo ''
    echo '# Flutter + Dart pub global'
    echo "export PATH=\"\$PATH:$FLUTTER_DIR/bin:\$HOME/.pub-cache/bin\""
  } >> "$HOME/.bashrc"
fi
export PATH="$PATH:$FLUTTER_DIR/bin:$HOME/.pub-cache/bin"

echo "==> Flutter version:"
flutter --version

echo "==> Pre-downloading Flutter web + caches..."
flutter config --enable-web
flutter precache --web

# ---------------------------------------------------------------------------
# 3. Firebase CLI + FlutterFire CLI
# ---------------------------------------------------------------------------
echo "==> Installing Firebase CLI..."
curl -sL https://firebase.tools | bash

echo "==> Installing FlutterFire CLI..."
dart pub global activate flutterfire_cli

# ---------------------------------------------------------------------------
# 4. Doctor + next steps
# ---------------------------------------------------------------------------
echo "==> Running flutter doctor..."
flutter doctor || true

cat <<'NEXT'

============================================================
 Setup complete. Next steps:
============================================================
 1) Reload PATH:           source ~/.bashrc
 2) Authenticate Firebase: firebase login --no-localhost
 3) Wire Firebase to app:  flutterfire configure
 4) Get packages:          flutter pub get
 5) Run on web (Codespaces friendly):
        flutter run -d web-server --web-port 8080
 6) Start Claude Code:     claude   (then paste prompt-code.md)
============================================================

NEXT
echo "Done."
