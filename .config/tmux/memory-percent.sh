#!/usr/bin/env bash

awk '
  $1 == "MemTotal:"     { total = $2 }
  $1 == "MemAvailable:" { available = $2 }
  END {
    if (total > 0)
      printf "%d%%", (100 * (total - available) / total) + 0.5
    else
      printf "0%%"
  }
' /proc/meminfo
