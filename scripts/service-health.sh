#!/usr/bin/env bash
# Check requested systemd services; with no arguments, check a small common set.
set -Eeuo pipefail
services=("$@")
if ((${#services[@]} == 0)); then
  services=(ssh.service cron.service)
fi
if ! command -v systemctl >/dev/null 2>&1; then
  echo 'systemctl is unavailable; this check requires a systemd host.' >&2
  exit 2
fi

status=0
printf '%-32s %-12s %s\n' 'SERVICE' 'STATE' 'DETAIL'
for service in "${services[@]}"; do
  if systemctl is-active --quiet "$service"; then
    printf '%-32s %-12s %s\n' "$service" 'ACTIVE' 'running'
  else
    state=$(systemctl is-active "$service" 2>/dev/null || true)
    [[ -n "$state" ]] || state='unknown/not-found'
    printf '%-32s %-12s %s\n' "$service" 'NOT ACTIVE' "$state"
    status=1
  fi
done
exit "$status"
