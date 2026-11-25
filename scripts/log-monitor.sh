#!/usr/bin/env bash
# Scan the newest lines of selected logs for common high-priority events.
set -Eeuo pipefail

lines="${LOG_TAIL_LINES:-200}"
if [[ ! "$lines" =~ ^[1-9][0-9]*$ ]]; then
  echo 'LOG_TAIL_LINES must be a positive integer.' >&2
  exit 2
fi
if (($#)); then
  logs=("$@")
else
  logs=()
  for candidate in /var/log/syslog /var/log/messages /var/log/auth.log /var/log/secure; do
    [[ -r "$candidate" ]] && logs+=("$candidate")
  done
fi
if ((${#logs[@]} == 0)); then
  echo 'No readable log files selected. Pass one or more file paths.' >&2
  exit 2
fi

found=0
for file in "${logs[@]}"; do
  if [[ ! -r "$file" || ! -f "$file" ]]; then
    printf 'SKIP: not a readable regular file: %s\n' "$file" >&2
    continue
  fi
  printf '\n== %s (last %s lines) ==\n' "$file" "$lines"
  matches=$(tail -n "$lines" -- "$file" | grep -Ein ' (error|err|critical|crit|alert|emergency|failed|failure)(:|\]|[[:space:]])' || true)
  if [[ -n "$matches" ]]; then
    printf '%s\n' "$matches"
    found=1
  else
    echo 'No matching high-priority events found.'
  fi
done
if ((found)); then
  echo '\nReview matches in context; keyword matches may include expected events.'
  exit 1
fi
