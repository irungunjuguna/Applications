#!/usr/bin/env bash
# Inspect recent system logs for high-priority events.
set -Eeuo pipefail

LOG_TAIL_LINES="${LOG_TAIL_LINES:-100}"

usage() {
    echo "Usage: $0 [log_file ...]"
    echo "Environment: LOG_TAIL_LINES (default: 100)"
    echo "If no files are supplied, common system log locations are checked."
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

if ! [[ "$LOG_TAIL_LINES" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: LOG_TAIL_LINES must be a positive integer." >&2
    exit 2
fi

if (($# > 0)); then
    logs=("$@")
else
    logs=(
        /var/log/syslog
        /var/log/messages
        /var/log/auth.log
        /var/log/secure
    )
fi

scanned=0
found=0

for file in "${logs[@]}"; do
    if [[ ! -f "$file" || ! -r "$file" ]]; then
        printf 'SKIP: Not a readable regular file: %s\n' "$file" >&2
        continue
    fi

    ((scanned += 1))

    printf '\n== %s (last %s lines) ==\n' "$file" "$LOG_TAIL_LINES"

    matches=$(
        tail -n "$LOG_TAIL_LINES" -- "$file" |
            grep -Ein '(^|[^[:alpha:]])(error|err|critical|crit|alert|emergency|failed|failure)(:|\]|[[:space:]]|$)' ||
            true
    )

    if [[ -n "$matches" ]]; then
        printf '%s\n' "$matches"
        found=1
    else
        echo "No matching high-priority events found."
    fi
done

if ((scanned == 0)); then
    echo "Error: No readable log files were scanned." >&2
    exit 2
fi

if ((found)); then
    printf '\nReview matching entries in context. Keyword matches may include expected events.\n'
    exit 1
fi

printf '\nLog scan completed. No matching high-priority events were found.\n'
exit 0
