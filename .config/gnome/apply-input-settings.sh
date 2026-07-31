#!/usr/bin/env bash
set -euo pipefail

gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"

gsettings set org.gnome.desktop.peripherals.keyboard repeat true
gsettings set org.gnome.desktop.peripherals.keyboard delay 250
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20
