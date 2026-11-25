# Backup, Disaster Recovery, and Resilience Requirements

## 1. Objectives

Every workload must have recovery objectives derived from an approved business impact analysis (BIA), data classification, dependency map, and regulatory/contractual needs. The service owner documents a target Recovery Time Objective (RTO) and Recovery Point Objective (RPO), business owner approval, recovery priorities, and acceptable data loss. “Backed up” does not mean “recoverable.”

## 2. Tiered recovery policy

Use the following as a starting framework; business owners and risk management must approve actual targets. Targets are illustrative, not guarantees of AWS service performance.

| Tier | Example criticality | Suggested planning range | Minimum validation |
| --- | --- | --- | --- |
| Tier 0 — Critical | Safety, revenue-critical, identity/control plane, or severe legal impact | RTO under 4 hours; RPO under 1 hour, subject to architecture feasibility | At least annual full recovery exercise; quarterly restore sampling for critical data. |
| Tier 1 — High | Major customer or business service | RTO under 24 hours; RPO under 4 hours | Annual recovery exercise and quarterly representative restore test. |
| Tier 2 — Standard | Important but tolerates extended outage | RTO under 72 hours; RPO under 24 hours | Annual restore test; verify backup coverage at least quarterly. |
| Tier 3 — Low / Sandbox | Non-critical disposable workloads | Rebuild from source or approved backup; targets set by owner | Validate rebuild procedure and data handling; do not retain regulated data without controls. |

If a workload cannot meet its approved RTO/RPO, record the gap, business impact, interim safeguards, funding/decision owner, and time-bound risk exception.

## 3. Backup policy requirements

- Define scope, schedule/frequency, retention, encryption, recovery point expectations, owner, and deletion lifecycle for each data store and configuration item. Cover data, databases, file systems, object stores, secrets/configuration needed for recovery, and infrastructure definitions as applicable.
- Use centrally governed backup policies and inventory where available. Ensure account/Region coverage includes all in-scope resources and supported resource types; explicitly identify exclusions.
- Encrypt backups in transit and at rest using approved key management. Restrict key administrators and backup operators; separate backup deletion authority from routine workload administration.
- Keep protected copies in a separate account and, where required by threat model, a separate Region. Use logically or physically isolated/immutable vault capabilities where supported and appropriate. Confirm cross-account policies and keys permit recovery without granting broad access.
- Protect backup plans, vaults, retention, recovery points, and encryption keys from unauthorized deletion, shortening retention, or disabling. Alert on policy changes and destructive operations.
- Apply retention, legal holds, data residency, privacy, and secure disposal requirements. Avoid retaining data indefinitely without an approved purpose.
- Back up infrastructure and application configuration in version control, while recognizing that code alone may not preserve data, state, secrets, or service dependencies.
- Monitor job success/failure, missed recovery points, coverage drift, vault capacity/cost anomalies, and replication lag. Assign failures to an accountable on-call owner and track resolution.

## 4. Recovery testing

- Test restore procedures at a cadence based on tier and after major architecture changes. Include representative data, dependent services, identity, network, DNS, secrets, and operational procedures.
- Verify integrity, application functionality, access controls, encryption, and consistency—not merely successful job completion.
- Restore into an isolated, controlled environment. Protect restored sensitive data and prevent test systems from unintentionally connecting to production or public networks.
- Record test scope, backup point, measured RTO/RPO, results, issues, evidence, owner, and corrective-action deadlines. Test a recovery path that does not depend on the compromised or unavailable primary account when the threat model requires it.
- Conduct periodic table-top or live exercises for loss of a Region, account compromise, ransomware/destructive actions, and critical provider dependency as appropriate.

## 5. Disaster recovery architecture and operations

Workload owners must maintain a recovery plan covering:

- Service criticality, approved RTO/RPO, dependency and data-flow diagrams, authoritative recovery source, and recovery sequence.
- Primary and recovery account/Region architecture, identity and privileged access during an outage, network connectivity, DNS/failover behavior, secrets/key availability, and external dependencies.
- Failover/failback decision authority, customer/business communications, operational staffing, vendor contacts, and security monitoring during recovery.
- Capacity/quota readiness, infrastructure-as-code version, recovery runbook location, data consistency controls, and rollback criteria.
- Criteria to declare disaster, validate recovery, exit elevated operations, and return to normal production.

Choose backup-and-restore, pilot-light, warm-standby, multi-site, or other patterns based on approved business objectives and total cost/risk. Multi-Region designs introduce complexity and do not by themselves guarantee resilience. Confirm service-specific behavior, data replication consistency, quota limits, encryption key availability, and regional service support.

## 6. Roles, governance, and evidence

The workload owner maintains the plan and test evidence; platform teams provide approved backup foundations; security reviews isolation, encryption, and destructive-risk protections; business owners approve objectives and residual risk. Report backup coverage, restore success, RPO/RTO performance, and overdue corrective actions through governance defined in [governance.md](governance.md).

Minimum evidence includes approved BIA/objectives, resource coverage report, backup policy configuration, encrypted/protected destination, job and failure metrics, access review, restore-test results, DR exercise record, and tracked remediation. A failed restore or missed objective is a risk finding requiring a documented response—not a pass based on backup job status.
