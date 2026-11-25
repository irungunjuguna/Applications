#!/usr/bin/env bash
# Read-only baseline checks. Results are advisory and should be adapted to local policy.
set -Eeuo pipefail

pass() { printf 'PASS  %s\n' "$1"; }
warn() { printf 'WARN  %s\n' "$1"; }
info() { printf 'INFO  %s\n' "$1"; }

printf 'Security baseline — %s\n\n' "$(hostname -f 2>/dev/null || hostname)"
if [[ -r /etc/passwd && $(stat -c '%a' /etc/passwd 2>/dev/null || echo 777) =~ ^[0-7]{3,4}$ ]]; then
  mode=$(stat -c '%a' /etc/passwd)
  if (( (8#$mode & 8#022) == 0 )); then pass "/etc/passwd permissions are $mode"; else warn "/etc/passwd is group/world writable (mode $mode)"; fi
else
  warn '/etc/passwd is unavailable or its permissions could not be read'
fi
if [[ -r /etc/shadow ]]; then
  mode=$(stat -c '%a' /etc/shadow 2>/dev/null || echo unknown)
  if [[ "$mode" != unknown ]] && (( (8#$mode & 8#077) == 0 )); then pass "/etc/shadow permissions are restricted (mode $mode)"; else warn "/etc/shadow permissions need review (mode $mode)"; fi
else
  info '/etc/shadow is not readable by this user; rerun with appropriate privileges for this check'
fi

if command -v sshd >/dev/null 2>&1; then
  root_login=$(sshd -T 2>/dev/null | awk '$1 == "permitrootlogin" { print $2; exit }' || true)
  case "$root_login" in
    no) pass 'SSH root login is disabled' ;;
    yes) warn 'SSH root login is enabled' ;;
    '') info 'Could not determine effective SSH PermitRootLogin setting' ;;
    *) info "SSH PermitRootLogin is set to $root_login; review against policy" ;;
  esac
else
  info 'OpenSSH server (sshd) is not installed; SSH server check skipped'
fi

if command -v ufw >/dev/null 2>&1; then
  if ufw status 2>/dev/null | grep -q '^Status: active'; then pass 'UFW firewall is active'; else warn 'UFW is installed but not reported active'; fi
elif command -v firewall-cmd >/dev/null 2>&1; then
  if firewall-cmd --state >/dev/null 2>&1; then pass 'firewalld is active'; else warn 'firewalld is installed but not reported active'; fi
else
  info 'No supported host firewall tool (ufw/firewalld) detected; verify network controls separately'
fi

printf '\nChecks are read-only and do not establish compliance certification. Validate findings against your organization\x27s baseline.\n'
