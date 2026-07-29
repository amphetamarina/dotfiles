#!/usr/bin/env bash
set -euo pipefail

gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
