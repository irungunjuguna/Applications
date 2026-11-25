
# Linux Operations Toolkit

A collection of Bash scripts for routine Linux system administration, operational monitoring, backup management, patch management and basic security checks.

The toolkit is designed to simplify common administrative tasks and provide practical examples of Linux operations automation.

## Features

| Script | Purpose |
|---|---|
| `user-audit.sh` | Lists interactive user accounts and identifies UID 0 accounts |
| `disk-monitor.sh` | Checks disk utilisation against a configurable threshold |
| `log-monitor.sh` | Scans recent log entries for high-priority events |
| `backup.sh` | Creates and verifies timestamped compressed backups |
| `patch-management.sh` | Checks for available package updates or applies them |
| `service-health.sh` | Checks the status of selected systemd services |
| `security-check.sh` | Performs basic Linux security configuration checks |

## Project Structure

```text
linux-operations-toolkit/
│
├── scripts/
│   ├── user-audit.sh
│   ├── disk-monitor.sh
│   ├── log-monitor.sh
│   ├── backup.sh
│   ├── patch-management.sh
│   ├── service-health.sh
│   └── security-check.sh
│
└── README.md
```

## Requirements

The scripts are intended for GNU/Linux systems.

General requirements:

- Bash 4 or later
- GNU/Linux command-line utilities
- Appropriate permissions to access the files and services being checked

Additional requirements:

| Utility | Used by |
|---|---|
| `getent` | User audit |
| `df` | Disk monitoring |
| `tail`, `grep` | Log monitoring |
| `tar`, `realpath`, `du` | Backup |
| `apt-get`, `dnf` or `yum` | Patch management |
| `systemctl` | Service health |
| `stat`, `sshd`, `ufw` or `firewall-cmd` | Security checks |

Some scripts require elevated privileges for complete results or administrative operations.

## Installation

Clone the repository:

```bash
git clone https://github.com/irungunjuguna/Applications.git
```

Navigate to the toolkit directory:

```bash
cd Applications
```

Make the scripts executable:

```bash
chmod +x scripts/*.sh
```

You can also run scripts directly through Bash without changing their permissions:

```bash
bash scripts/user-audit.sh
```

## Usage

### 1. User Audit

Lists interactive accounts with UID values of 1000 or higher and identifies accounts with UID 0.

```bash
./scripts/user-audit.sh
```

**Note:** The script uses `getent passwd`, which can include accounts provided by configured identity services such as LDAP, not only accounts stored locally. UID 1000 is a common convention for regular users, but UID allocation differs between Linux distributions.

### 2. Disk Monitoring

Checks filesystem utilisation and identifies filesystems exceeding the configured warning threshold.

```bash
./scripts/disk-monitor.sh
```

Set a custom warning threshold:

```bash
DISK_WARN_PERCENT=85 ./scripts/disk-monitor.sh
```

The threshold is expressed as a percentage and must be between 1 and 100.

### 3. Log Monitoring

Scans common Linux log files for high-priority events.

```bash
./scripts/log-monitor.sh
```

Specify the number of recent lines to inspect:

```bash
LOG_TAIL_LINES=200 ./scripts/log-monitor.sh
```

Alternatively, specify particular log files:

```bash
./scripts/log-monitor.sh /var/log/syslog /var/log/auth.log
```

The script searches for terms such as:

- ERROR
- CRITICAL
- ALERT
- EMERGENCY
- FAILED
- FAILURE

Keyword matches should be reviewed in context because not every match represents a genuine incident.

### 4. Backup Management

Creates a compressed `.tar.gz` archive of a specified directory.

Syntax:

```bash
./scripts/backup.sh <source_directory> <backup_directory>
```

Example:

```bash
sudo ./scripts/backup.sh /etc /mnt/backups
```

The script:

1. Validates the source and backup directories.
2. Prevents backing up the filesystem root.
3. Prevents placing the backup directory inside the source directory.
4. Creates a timestamped compressed archive.
5. Verifies the archive before publishing it.
6. Avoids overwriting an existing archive.

Example output archive:

```text
/etc_20261125_103000.tar.gz
```

To inspect an archive:

```bash
tar -tzf /mnt/backups/etc_20261125_103000.tar.gz
```

To extract an archive:

```bash
sudo tar -xzf /mnt/backups/etc_20261125_103000.tar.gz -C /tmp
```

**Backup considerations:**

- Store backups on a separate filesystem or remote storage location.
- Restrict access to backup files, particularly where they contain sensitive configuration or credentials.
- Consider encryption where appropriate.
- Establish a retention policy.
- Perform periodic restoration tests to confirm that backups are usable.

The script creates and verifies an archive but does not implement encryption, remote replication or automated retention.

### 5. Patch Management

Checks for available package updates by default.

```bash
./scripts/patch-management.sh
```

Explicitly run the check:

```bash
./scripts/patch-management.sh --check
```

Apply available updates:

```bash
sudo ./scripts/patch-management.sh --apply
```

The script supports:

- APT-based distributions, such as Ubuntu and Debian.
- DNF-based distributions, such as Fedora and newer RHEL-based systems.
- YUM-based distributions where supported.

The `--apply` option requires root privileges and asks for confirmation before installing updates.

**Important:** Applying package updates can affect running services, application compatibility and system availability. Review updates and follow your organisation's change-management procedures before applying them to production systems.

### 6. Service Health Monitoring

Checks the status of selected systemd services.

Run the default checks:

```bash
./scripts/service-health.sh
```

Check specific services:

```bash
./scripts/service-health.sh ssh.service cron.service
```

Service names may differ between distributions. For example:

- `ssh.service` or `sshd.service`
- `cron.service` or `crond.service`

The script is intended for systems that use systemd.

### 7. Security Configuration Checks

Runs basic checks on important Linux security settings.

```bash
./scripts/security-check.sh
```

The script checks:

- Ownership and permissions of `/etc/passwd`.
- Ownership and permissions of `/etc/shadow`.
- The effective SSH root-login setting, where `sshd` is available.
- UFW firewall status, where installed.
- firewalld status, where installed.

Run with elevated privileges where necessary to obtain complete results:

```bash
sudo ./scripts/security-check.sh
```

The script reports successful checks and warnings.

**Important:** This is a basic configuration review, not a comprehensive security assessment or compliance audit. Firewall status alone does not establish that firewall rules are appropriate. SSH settings, network controls, access policies and host configurations should be assessed against the applicable security baseline.

## Exit Codes

Some scripts use exit codes to distinguish successful checks from findings.

| Script | Exit code | Meaning |
|---|---:|---|
| `log-monitor.sh` | 0 | No matching high-priority events found |
| `log-monitor.sh` | 1 | Matching log entries found |
| `log-monitor.sh` | 2 | Invalid configuration or no readable log files |
| `security-check.sh` | 0 | No warnings detected by the checks |
| `security-check.sh` | 1 | One or more warnings detected |
| `patch-management.sh` | 0 | Operation completed successfully |
| `backup.sh` | 0 | Backup created and verified successfully |
| Other scripts | Non-zero | Refer to the error output for details |

## Validation and Testing

Before using the scripts in an operational environment, perform syntax checks:

```bash
bash -n scripts/*.sh
```

If ShellCheck is installed, run static analysis:

```bash
shellcheck scripts/*.sh
```

Review script permissions:

```bash
ls -l scripts/
```

Recommended functional tests:

| Script | Suggested test |
|---|---|
| User audit | Compare reported accounts with the system's account configuration |
| Disk monitor | Test with different warning thresholds |
| Log monitor | Test against a log file containing known error and failure entries |
| Backup | Create a backup, inspect its contents and test extraction |
| Patch management | Run `--check` before considering `--apply` |
| Service health | Check both running and stopped services |
| Security check | Review output on systems with UFW, firewalld or neither installed |

For backup testing, use a test directory rather than important production data.

Example:

```bash
mkdir -p /tmp/backup-test
echo "Linux backup test" > /tmp/backup-test/sample.txt

./scripts/backup.sh /tmp/backup-test /tmp/test-backups

tar -tzf /tmp/test-backups/backup-test_*.tar.gz
```

## Operational Considerations

- Review script output rather than treating automated checks as definitive security conclusions.
- Use least-privilege access when running administrative scripts.
- Test changes in a non-production environment before deployment.
- Back up important data before applying system updates or making configuration changes.
- Keep scripts and documentation under version control.
- Review and update scripts as Linux distributions and system requirements change.

## Limitations

This toolkit provides practical automation for common Linux administration tasks. It is not intended to replace:

- Enterprise monitoring and alerting platforms.
- Centralised log management and SIEM solutions.
- Configuration management platforms.
- Enterprise backup and disaster recovery solutions.
- Vulnerability management tools.
- Formal security assessments and compliance audits.

## Future Improvements

Potential enhancements include:

- Automated execution using cron or systemd timers.
- Centralised logging and email notifications.
- Remote backup destinations and backup encryption.
- Backup retention and rotation policies.
- More detailed service and resource monitoring.
- Integration with configuration management tools such as Ansible.
- Structured reporting in JSON or CSV format.
- Automated testing through a CI/CD pipeline.

## Author

**Bernard Irungu**

GitHub: https://github.com/irungunjuguna/Applications

---

*Linux Operations Toolkit — practical Bash automation for Linux system administration, monitoring and security checks.*
