#!/usr/bin/env bash
# Report mounted filesystems whose use percentage reaches the configured threshold.
set -Eeuo pipefail

threshold="${DISK_WARN_PERCENT:-80}"
if [[ ! "$threshold" =~ ^[0-9]+$ ]] || (( threshold < 1 || threshold > 100 )); then
  echo 'DISK_WARN_PERCENT must be an integer from 1 to 100.' >&2
  exit 2
fi

printf 'Disk space check — %s (warning threshold: %s%%)\n' "$(date -Is)" "$threshold"
printf '%-24s %8s %8s %8s %s\n' 'FILESYSTEM' 'SIZE' 'USED' 'USE%' 'MOUNT'
status=0
while read -r filesystem size used available percent mount; do
  [[ "$filesystem" == Filesystem ]] && continue
  value="${percent%%%}"
  printf '%-24s %8s %8s %8s %s\n' "$filesystem" "$size" "$used" "$percent" "$mount"
  if [[ "$value" =~ ^[0-9]+$ ]] && (( value >= threshold )); then
    printf 'WARNING: %s is %s full (threshold %s%%).\n' "$mount" "$percent" "$threshold" >&2
    status=1
  fi
df_output=$(df -P -h) || {
  echo 'Unable to retrieve filesystem usage information.' >&2
  exit 2
}

while read -r filesystem size used available percent mount; do
  [[ "$filesystem" == Filesystem ]] && continue
  value="${percent%%%}"
  printf '%-24s %8s %8s %8s %s\n" "$filesystem" "$size" "$used" "$percent" "$mount"
  if [[ "$value" =~ ^[0-9]+$ ]] && (( value >= threshold )); then
    printf 'WARNING: %s is %s full (threshold %s%%).\n' "$mount" "$percent" "$threshold" >&2
    status=1
  fi
done <<< "$df_output"

exit "$status"
