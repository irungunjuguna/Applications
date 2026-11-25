#!/usr/bin/env bash
# Check for available package updates or apply them when explicitly requested.
set -Eeuo pipefail

usage() {
    echo "Usage: $0 [--check|--apply]"
    echo
    echo "Options:"
    echo "  --check   Check for available updates (default)"
    echo "  --apply   Install available updates (requires root privileges)"
}

mode="--check"

if (($# > 1)); then
    usage >&2
    exit 2
fi

if (($# == 1)); then
    case "$1" in
        --check|--apply)
            mode="$1"
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Error: Unsupported option: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
fi

if [[ "$mode" == "--apply" && "$EUID" -ne 0 ]]; then
    echo "Error: Applying updates requires root privileges." >&2
    echo "Run with sudo: sudo $0 --apply" >&2
    exit 1
fi

if command -v apt-get >/dev/null 2>&1; then
    package_manager="apt"
elif command -v dnf >/dev/null 2>&1; then
    package_manager="dnf"
elif command -v yum >/dev/null 2>&1; then
    package_manager="yum"
else
    echo "Error: No supported package manager found (apt-get, dnf or yum)." >&2
    exit 1
fi

printf 'Package manager detected: %s\n' "$package_manager"

if [[ "$mode" == "--check" ]]; then
    echo "Checking for available package updates..."

    case "$package_manager" in
        apt)
            # Simulation checks what would be upgraded without installing it.
            apt-get -s upgrade
            ;;
        dnf)
            set +e
            dnf check-update
            status=$?
            set -e

            if ((status == 100)); then
                echo "Updates are available."
                exit 0
            elif ((status != 0)); then
                echo "Error: DNF update check failed with exit code $status." >&2
                exit "$status"
            fi
            ;;
        yum)
            set +e
            yum check-update
            status=$?
            set -e

            if ((status == 100)); then
                echo "Updates are available."
                exit 0
            elif ((status != 0)); then
                echo "Error: YUM update check failed with exit code $status." >&2
                exit "$status"
            fi
            ;;
    esac

    echo "Update check completed."
    exit 0
fi

echo "WARNING: This will install available system package updates."
read -r -p "Continue? Type 'yes' to proceed: " confirmation

if [[ "$confirmation" != "yes" ]]; then
    echo "Update operation cancelled."
    exit 0
fi

echo "Applying package updates..."

case "$package_manager" in
    apt)
        apt-get update
        apt-get upgrade -y
        ;;
    dnf)
        dnf upgrade -y
        ;;
    yum)
        yum update -y
        ;;
esac

echo "Package update operation completed."
