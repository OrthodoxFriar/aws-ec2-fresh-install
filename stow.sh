#!/usr/bin/env bash
#
# stow.sh
# Convenience wrapper for GNU Stow.
# Run this from the aws-ec2-fresh-install root to link all packages.
#
# Usage:
#   ./stow.sh          # Stow all packages in stow/
#   ./stow.sh bash     # Stow only the bash package
#

set -euo pipefail

STOW_DIR="stow"
TARGET="$HOME"

if [[ ! -d "$STOW_DIR" ]]; then
    echo "Error: $STOW_DIR directory not found. Run this script from the aws-ec2-fresh-install root."
    exit 1
fi

if [[ $# -eq 0 ]]; then
    echo "Stowing all packages from $STOW_DIR into $TARGET..."
    stow -d "$STOW_DIR" -t "$TARGET" */
else
    echo "Stowing packages: $*"
    stow -d "$STOW_DIR" -t "$TARGET" "$@"
fi

echo "Done. Symlinks created in $TARGET"
echo "To unstow a package: stow -D -d $STOW_DIR -t $TARGET <package>"
