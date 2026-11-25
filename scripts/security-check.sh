#!/usr/bin/env bash
# Perform basic Linux host security configuration checks.
set -Eeuo pipefail

warnings=0
checks=0

pass() {
    printf '[PASS] %s\n' "$1"
    ((checks += 1))
}

warn() {
    printf '[WARN] %s\n' "$1"
    ((warnings += 1))
    ((checks += 1))
}

info() {
    printf '[INFO] %s\n' "$1"
}

check_file() {
    local file="$1"
    local expected_modes="$2"
    local description="$3"
    local mode owner

    if [[ ! -e "$file" ]]; then
        warn "$description does not exist: $file"
        return
    fi

    if ! command -v stat >/dev/null 2>&1; then
        warn "Cannot inspect $file because stat is unavailable"
        return
    fi

    mode=$(stat -c '%a' -- "$file")
    owner=$(stat -c '%U' -- "$file")

    if [[ "$owner" != "root" ]]; then
        warn "$description is not owned by root (owner: $owner)"
    elif " ${expected_modes} " == *" ${mode} "*; then
        pass "$description has expected ownership and permissions ($owner:$mode)"
    else
        warn "$description has unexpected permissions ($owner:$mode); expected: $expected_modes"
    fi
}

echo "Linux Security Configuration Check"
echo "Host: $(hostname -f 2>/dev/null || hostname)"
echo "Date: $(date)"
echo

# 1. Account file permissions and ownership.
echo "Account File Checks"
check_file "/etc/passwd" "644" "/etc/passwd"
check_file "/etc/shadow" "600 640" "/etc/shadow"

# 2. SSH root login configuration.
echo
echo "SSH Configuration Check"

if command -v sshd >/dev/null 2>&1; then
    if ssh_config=$(sshd -T 2>/dev/null); then
        permit_root_login=$(
            printf '%s\n' "$ssh_config" |
                awk '$1 == "permitrootlogin" { print $2; exit }'
        )

        if [[ "$permit_root_login" == "no" ]]; then
            pass "SSH root login is disabled"
        elif [[ -n "$permit_root_login" ]]; then
            warn "SSH root login setting is '$permit_root_login' rather than 'no'"
        else
            warn "Could not determine the effective SSH root login setting"
        fi
    else
        warn "Could not read effective SSH configuration using sshd -T"
    fi
else
    info "sshd command not found; SSH configuration check skipped"
fi

# 3. Host firewall checks.
echo
echo "Firewall Checks"

firewall_detected=0

if command -v ufw >/dev/null 2>&1; then
    firewall_detected=1

    if ufw status 2>/dev/null | grep -q '^Status: active'; then
        pass "UFW firewall is active"
    else
        warn "UFW is installed but is not reported as active"
    fi
fi

if command -v firewall-cmd >/dev/null 2>&1; then
    firewall_detected=1

    if firewall-cmd --state 2>/dev/null | grep -q '^running$'; then
        pass "firewalld is active"
    else
        warn "firewalld is installed but is not reported as running"
    fi
fi

if ((firewall_detected == 0)); then
    warn "No supported host firewall tool (ufw/firewalld) detected; verify network controls separately"
fi

# 4. Summary.
echo
echo "Security Check Summary"
printf 'Checks performed: %s\n' "$checks"
printf 'Warnings: %s\n' "$warnings"

if ((warnings > 0)); then
    echo "Review the warnings and verify settings against your security policy."
    exit 1
fi

echo "No issues detected by these basic checks."
exit 0
