#!/usr/bin/env bash

read_cpu() {
  read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
  CPU_TOTAL=$((user + nice + system + idle + iowait + irq + softirq + steal))
  CPU_IDLE=$((idle + iowait))
}

read_cpu
total_before=$CPU_TOTAL
idle_before=$CPU_IDLE
sleep 0.2
read_cpu

total_delta=$((CPU_TOTAL - total_before))
idle_delta=$((CPU_IDLE - idle_before))

if ((total_delta > 0)); then
  printf '%d%%' "$(((100 * (total_delta - idle_delta) + total_delta / 2) / total_delta))"
else
  printf '0%%'
fi
