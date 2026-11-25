# Linux Operations Toolkit

A practical, **read-only by default** collection of Bash utilities for routine Linux operations and baseline checks. This project is designed as a small, auditable starting point for DevOps and systems-administration workflows—not as a replacement for configuration management, centralized monitoring, or a formally approved security baseline.

## What it includes

| Script | Purpose |
| --- | --- |
| `scripts/user-audit.sh` | Lists local interactive accounts (UID 1000+) and UID 0 accounts. |
| `scripts/disk-monitor.sh` | Reports mounted filesystem usage and exits non-zero at the configured threshold. |
| `scripts/log-monitor.sh` | Scans the newest lines of selected logs for common high-priority keywords. |
| `scripts/backup.sh` | Creates a timestamped gzip-compressed tar archive of a directory. |
| `scripts/patch-management.sh` | Displays available updates by default; applies them only with explicit `--apply`. |
| `scripts/service-health.sh` | Checks requested systemd services, or a small default service list. |
| `scripts/security-check.sh` | Runs read-only checks on account-file permissions, SSH root login, and host firewall status. |

## Requirements

- Bash 4+ and standard GNU/Linux utilities (`awk`, `df`, `getent`, `grep`, `realpath`, `stat`, `tar`, `tail`).
- systemd for service health checks.
- `apt-get`, `dnf`, or `yum` for patch management.
- Root/sudo only when required by the underlying operation (notably applying updates and reading protected system details).

The scripts are intended for Linux. Package names, service names, log locations, permissions, and security expectations vary by distribution and organization.

## Installation

```bash
git clone https://github.com/irungunjuguna/Applications.git
cd Applications
chmod +x scripts/*.sh
```

Run an individual check from the repository root:

```bash
./scripts/user-audit.sh
./scripts/disk-monitor.sh
./scripts/security-check.sh
```

No installer changes system configuration or installs dependencies.

## Usage

### User audit

```bash
./scripts/user-audit.sh
```

Sample output (accounts vary by host):

```text
User audit — node01.example.net
USERNAME                 UID      HOME                             SHELL
alice                    1000     /home/alice                      /bin/bash

Administrator accounts (UID 0):
  root (home=/root, shell=/bin/bash)

Audit completed. Review listed accounts against your access policy.
```

### Disk space monitoring

The default warning threshold is 80%. Set `DISK_WARN_PERCENT` to an integer from 1–100. The script exits `1` if any mounted filesystem meets or exceeds the threshold, which is useful in scheduled jobs and alerting integrations.

```bash
DISK_WARN_PERCENT=90 ./scripts/disk-monitor.sh
```

Sample output:

```text
Disk space check — 2026-01-15T10:30:00+00:00 (warning threshold: 90%)
FILESYSTEM                   SIZE     USED     USE% MOUNT
/dev/sda1                     40G      22G      55% /
/dev/sdb1                    100G      93G      93% /data
WARNING: /data is 93% full (threshold 90%).
```

### Log monitoring

With no paths, the script checks readable standard system/auth log files. You can also pass explicit files. It scans the last 200 lines by default; configure this with `LOG_TAIL_LINES`. A match causes exit status `1` and needs human review—keyword matches can be benign.

```bash
LOG_TAIL_LINES=500 ./scripts/log-monitor.sh /var/log/auth.log /var/log/syslog
```

Sample output:

```text
== /var/log/auth.log (last 500 lines) ==
42:Nov 25 10:11:12 node01 sshd[1234]: Failed password for invalid user guest

Review matches in context; keyword matches may include expected events.
```

### Backup automation

Pass a source directory and a backup destination. The source is not changed. The destination is created if needed; timestamped archives are not overwritten. Store backups on a separate filesystem or remote target for resilience, and define retention/encryption/restore testing separately.

```bash
./scripts/backup.sh /etc /var/backups/linux-ops
```

Sample output:

```text
Creating archive: /var/backups/linux-ops/etc-20261125T101500Z.tar.gz
Backup complete: /var/backups/linux-ops/etc-20261125T101500Z.tar.gz (2.1M)
Verify with: tar -tzf /var/backups/linux-ops/etc-20261125T101500Z.tar.gz | head
```

### Patch management

The default `--check` mode is non-mutating: it simulates upgrades on Debian/Ubuntu and lists available updates on DNF/YUM systems. Apply only after reviewing a maintenance window, backups, and change approval. `--apply` runs the platform package manager and requires root; it does not reboot the host.

```bash
./scripts/patch-management.sh                 # check only
sudo ./scripts/patch-management.sh --apply    # apply package updates
```

### Service health

Pass one or more systemd unit names. With no arguments, the script checks `ssh.service` and `cron.service`; these names may differ on your distribution.

```bash
./scripts/service-health.sh nginx.service sshd.service
```

Sample output:

```text
SERVICE                          STATE        DETAIL
nginx.service                    ACTIVE       running
sshd.service                     NOT ACTIVE   inactive
```

### Security baseline checks

```bash
sudo ./scripts/security-check.sh
```

Checks are informational and read-only. `PASS`, `WARN`, and `INFO` findings do not constitute a compliance certification. Validate recommendations against your distribution and organizational policy.

## Exit codes and automation

Most checks return `0` when no issue is detected and non-zero when a finding or execution error occurs. In particular, disk usage at/above threshold and log keyword matches return `1`. Invalid arguments/configuration generally return `2`. Capture both output streams and account for expected non-zero statuses in schedulers/monitoring. These scripts do not configure cron, systemd timers, email, or alerting integrations.

## Safety and operational notes

- Scripts do not run as root automatically and do not alter host configuration, except `patch-management.sh --apply`, which explicitly invokes the system package manager.
- Review scripts before running them, especially on production systems. Start with check-only modes and test on a non-production host.
- Backup archives can contain secrets and inherit destination permissions; restrict access and protect off-host copies.
- Log and security checks are lightweight heuristics. They are not exhaustive, and log format/service availability varies.
- Before applying patches, review the package-manager plan, verify backups, confirm application compatibility, and arrange reboot handling as needed.

## Contributing

Issues and pull requests are welcome. Keep scripts portable, quote variable expansions, document assumptions, and preserve a safe check-only default for operations that can change system state.

## License

No license has been assigned yet. All rights remain with the repository owner unless a license is added.
