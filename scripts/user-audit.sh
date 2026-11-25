#!/usr/bin/env bash
# Report local users with interactive shells and UID >= 1000.
set -Eeuo pipefail

printf 'User audit — %s\n' "$(hostname -f 2>/dev/null || hostname)"
printf '%-24s %-8s %-32s %s\n' 'USERNAME' 'UID' 'HOME' 'SHELL'
getent passwd | awk -F: '$3 >= 1000 && $7 != "" && $7 !~ /(^|\/)(nologin|false)$/ {
  printf "%-24s %-8s %-32s %s\n", $1, $3, $6, $7
}'
printf '\nAdministrator accounts (UID 0):\n'
getent passwd | awk -F: '$3 == 0 { print "  " $1 " (home=" $6 ", shell=" $7 ")" }'
printf '\nAudit completed. Review listed accounts against your access policy.\n'
