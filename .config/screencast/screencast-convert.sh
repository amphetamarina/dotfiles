#!/usr/bin/env bash
# Convert GNOME screencast webm files to Twitter/X-ready MP4 files.
# This script is idempotent. You can run it manually at any time.
set -u

DIR="$HOME/Videos/Screencasts"
LOCK="${XDG_RUNTIME_DIR:-/tmp}/screencast-convert.lock"
LOG="$HOME/.cache/screencast-convert.log"
MIN_AGE=20  # seconds; skip files that may still be written

# One instance at a time. Exit if another instance is running.
exec 9>"$LOCK"
flock -n 9 || exit 0

mkdir -p "$HOME/.cache"
touch "$LOG"

shopt -s nullglob
for src in "$DIR"/*.webm; do
    dst="${src%.webm}.mp4"

    # Already converted and up to date.
    if [ -f "$dst" ] && [ "$dst" -nt "$src" ]; then
        continue
    fi

    # Recording may still be in progress.
    age=$(( $(date +%s) - $(stat -c %Y "$src") ))
    if [ "$age" -lt "$MIN_AGE" ]; then
        echo "$(date -Is) skip (too recent): $src" >> "$LOG"
        continue
    fi

    echo "$(date -Is) convert: $src" >> "$LOG"
    if ffmpeg -hide_banner -loglevel error -y -i "$src"         -vf "fps=30,scale=trunc(iw/2)*2:trunc(ih/2)*2"         -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p         -an -movflags +faststart "$dst" >>"$LOG" 2>&1; then
        echo "$(date -Is) ok: $dst" >> "$LOG"
    else
        echo "$(date -Is) FAILED: $src" >> "$LOG"
        rm -f "$dst"
    fi
done
exit 0
