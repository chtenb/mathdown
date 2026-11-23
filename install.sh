#!/bin/sh
# Link mathdown into pandoc's user data folder, so that
#   pandoc -d mathdown -d mathdown-default doc.md -o doc.pdf
# works from anywhere. Links, not copies: `git pull` here updates it.
# Usage: ./install.sh [data-folder]   (default: pandoc's user data folder)
set -e
src=$(cd "$(dirname "$0")" && pwd)
dest=${1:-$(pandoc --version | sed -n 's/^.*[Dd]ata directory: //p')}
[ -n "$dest" ] || { echo "could not find pandoc's data folder; pass it as an argument" >&2; exit 1; }
for f in custom/mathdown.lua filters/mathdown.lua \
         defaults/mathdown.yaml defaults/mathdown-default.yaml mathdown; do
  mkdir -p "$dest/$(dirname "$f")"
  ln -sfn "$src/$f" "$dest/$f"
done
echo "mathdown linked into $dest"
