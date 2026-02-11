#!/bin/bash
# Flapper – Flutter app template clone
# Usage: curl -fsSL https://raw.githubusercontent.com/purplem0n/flapper/main/clone.sh | bash
#    or: curl -fsSL https://raw.githubusercontent.com/purplem0n/flapper/main/clone.sh | bash -s my-app-name

set -e

# --- Configure this when you publish (e.g. your GitHub repo) ---
REPO_URL="${FLAPPER_REPO_URL:-https://github.com/purplem0n/flapper.git}"
DEFAULT_DIR="flapper"

# Target directory: first argument, or $FLAPPER_DIR, or default
TARGET_DIR="${1:-${FLAPPER_DIR:-$DEFAULT_DIR}}"

echo "Flapper – Flutter app template"
echo "================================"
echo ""

# Require git
if ! command -v git &>/dev/null; then
  echo "Error: git is required. Install git and try again."
  exit 1
fi

# Avoid overwriting existing dir
if [ -d "$TARGET_DIR" ] && [ -n "$(ls -A "$TARGET_DIR" 2>/dev/null)" ]; then
  echo "Error: Directory '$TARGET_DIR' already exists and is not empty."
  echo "Choose another name: curl ... | bash -s my-app-name"
  exit 1
fi

echo "Cloning template into '$TARGET_DIR'..."
git clone --depth 1 "$REPO_URL" "$TARGET_DIR"
cd "$TARGET_DIR"

echo "Removing template git history..."
rm -rf .git

if [ ! -f "setup.sh" ]; then
  echo "Error: setup.sh not found in the cloned repo."
  exit 1
fi

echo "Running setup (package ID, app name, icons, etc.)..."
chmod +x setup.sh
./setup.sh

echo ""
echo "Done. Your app is in: $(pwd)"
echo "  cd $TARGET_DIR"
echo "  flutter run"
