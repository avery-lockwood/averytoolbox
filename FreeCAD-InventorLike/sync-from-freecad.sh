#!/usr/bin/env bash
# Pull the current Inventor-like macro files from the live FreeCAD (flatpak)
# Macro directory into this repo folder. Run after editing/regenerating the
# macro, then commit.
set -euo pipefail

SRC="$HOME/.var/app/org.freecad.FreeCAD/data/FreeCAD/v1-1/Macro"
DEST="$(cd "$(dirname "$0")" && pwd)"

rsync -av --checksum \
    "$SRC"/Install_InventorLike_FreeCAD_*.FCMacro \
    "$SRC"/InventorLikeUI_Profile_Source_*.py \
    "$SRC"/InventorLike_README.txt \
    "$DEST"/

echo "Synced. Review with: git -C \"$DEST\" status"
