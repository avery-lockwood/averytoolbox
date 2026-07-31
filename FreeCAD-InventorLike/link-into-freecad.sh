#!/usr/bin/env bash
# Symlink this repo's macro files into the FreeCAD (flatpak) Macro directory,
# so the repo working tree IS the live copy — edits in either place are the
# same file. Run once per machine (or to repair a broken link).
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
MACRO="$HOME/.var/app/org.freecad.FreeCAD/data/FreeCAD/v1-1/Macro"

mkdir -p "$MACRO"
for f in Install_InventorLike_FreeCAD_v1.4.0.FCMacro \
         InventorLikeUI_Profile_Source_v1.4.0.py \
         InventorLike_README.txt; do
    ln -sfv "$REPO/$f" "$MACRO/$f"
done

echo "Linked. FreeCAD's macro dialog now reads straight from the repo."
