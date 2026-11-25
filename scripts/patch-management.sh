#!/usr/bin/env bash
# Inspect available package updates; applying updates requires an explicit --apply.
set -Eeuo pipefail

mode="${1:---check}"
case "$mode" in
  --check) apply=0 ;;
  --apply) apply=1 ;;
  *) echo "Usage: $0 [--check|--apply]" >&2; exit 2 ;;
esac

if ((apply)) && ((EUID != 0)); then
  echo 'Applying updates requires root privileges (for example, sudo).' >&2
  exit 1
fi

if command -v apt-get >/dev/null 2>&1; then
  if ((apply)); then
    echo 'Updating package indexes and applying available upgrades (Ubuntu/Debian)...'
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
  else
    echo 'Simulated package upgrade plan (Ubuntu/Debian); no changes will be made.'
    apt-get -s upgrade
  fi
elif command -v dnf >/dev/null 2>&1; then
  if ((apply)); then
    echo 'Applying available package upgrades (DNF)...'
    dnf upgrade -y
  else
    echo 'Available package updates (DNF); no changes will be made.'
    dnf check-update || status=$?
    # DNF uses exit status 100 when updates are available.
    [[ "${status:-0}" == 0 || "${status:-0}" == 100 ]] || exit "${status:-1}"
  fi
elif command -v yum >/dev/null 2>&1; then
  if ((apply)); then
    echo 'Applying available package upgrades (YUM)...'
    yum update -y
  else
    echo 'Available package updates (YUM); no changes will be made.'
    yum check-update || status=$?
    [[ "${status:-0}" == 0 || "${status:-0}" == 100 ]] || exit "${status:-1}"
  fi
else
  echo 'Unsupported distribution: expected apt-get, dnf, or yum.' >&2
  exit 2
fi
if ((apply)); then
  echo 'Update command completed. Review package-manager output and plan any required reboot.'
fi
