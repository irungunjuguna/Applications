# Implementation and Evidence Checklist

Use this checklist to plan adoption and assurance. Assign an owner and due date for each item in the organization’s tracking system. “Implemented” requires evidence of both configuration and operation.

## Phase 1 — Governance and account foundations

- [ ] Approve the baseline, scope, control owners, risk tiers, and exception authority.
- [ ] Establish an AWS Organizations account inventory with business/technical owners, environment, data classification, contact, and lifecycle status.
- [ ] Define production/non-production separation and account vending, decommissioning, and ownership-change processes.
- [ ] Establish organization-level guardrails with tested break-glass recovery and change governance.
- [ ] Map this baseline to internal policies, legal/regulatory obligations, and evidence-retention requirements.

**Evidence examples:** approved policy/version record; account inventory export; owner attestation; architecture/landing-zone design; guardrail test and change record.

## Phase 2 — Identity and privilege

- [ ] Federate human access through approved centralized identity; enforce MFA for all human access paths.
- [ ] Protect root users, prohibit root access keys, monitor root activity, and document recovery/break-glass procedures.
- [ ] Replace embedded credentials and routine long-lived keys with roles and temporary credentials.
- [ ] Define role catalog, least-privilege policy standards, permission boundaries/guardrails, and privileged approval workflow.
- [ ] Review cross-account trusts, wildcard permissions, administrative entitlements, and privilege-escalation paths.
- [ ] Complete periodic access recertification and promptly revoke leaver/role-change access.

**Evidence examples:** IdP/MFA coverage report; role and policy inventory; access-review sign-offs; key/credential findings and remediation; break-glass exercise record.

## Phase 3 — Network, audit, and detection

- [ ] Apply security-group standards, tag owners, identify public exposure, and implement exception expiry/review.
- [ ] Verify organization-wide multi-Region CloudTrail management-event coverage and required data-event selection.
- [ ] Centralize and restrict log archive access; configure encryption, integrity checks where supported, retention, and deletion safeguards.
- [ ] Alert on logging gaps/tampering, root and privileged activity, public exposure, sensitive data access, backup destruction, and critical service signals.
- [ ] Assign alert owners, response objectives, runbooks, escalation, and delivery tests.
- [ ] Validate telemetry coverage and searchability across all in-scope accounts/Regions and document gaps.

**Evidence examples:** trail/account/Region coverage report; event selectors; archive policy and access review; integrity/delivery test; alarm inventory; notification test; finding remediation tickets.

## Phase 4 — Resilience and response

- [ ] Complete BIA and approved RTO/RPO for every critical/high workload.
- [ ] Define backup scope, frequency, retention, encryption, isolation, cross-account/Region needs, and deletion protection.
- [ ] Monitor backup success, resource coverage, missed recovery points, and replication lag.
- [ ] Test restore and DR procedures; record measured recovery results and corrective actions.
- [ ] Approve incident severity, contact routes, authority, evidence handling, and notification workflows.
- [ ] Exercise credential compromise, data exposure, logging tampering, destructive activity, and deployment compromise scenarios.

**Evidence examples:** BIA and objectives approval; coverage report; backup policy and vault protections; restore/DR exercise record; incident timeline and after-action closure.

## Phase 5 — Secure delivery and continuous assurance

- [ ] Use reviewed source control, protected branches, authenticated CI/CD, and short-lived deployment identities.
- [ ] Separate production deployment privileges; require approval for high-impact changes and document emergency paths.
- [ ] Scan code, dependencies, artifacts, containers, and infrastructure as code; block defined high-risk policy violations.
- [ ] Protect pipeline runners and artifacts; maintain provenance/traceability from commit to production.
- [ ] Test drift detection, rollback/recovery, and post-deployment validation.
- [ ] Establish dashboards and CISO reporting for control coverage, overdue risk, access, logging, backup/DR, incidents, and deployment integrity.
- [ ] Schedule recurring control tests and independent assurance; verify remediation closure.

**Evidence examples:** pipeline configuration and role trust; approval records; scan results; artifact provenance; change/deployment record; drift findings; dashboard definitions and review minutes.

## Operational review register

| Review | Minimum cadence | Accountable owner | Record |
| --- | --- | --- | --- |
| High-severity detections and logging health | Continuous/daily | SOC / Cloud Security | Incident and alert queue evidence |
| Critical/high control findings and remediation | Monthly | Cloud Security + workload owner | Risk register and tickets |
| Account ownership and inventory | Monthly or on account change | Platform owner | Reconciled inventory |
| Privileged access and exceptions | Quarterly | Identity owner + risk owner | Approved review and exception register |
| Backup coverage and restore evidence | Quarterly (more often by tier) | Workload owner | Coverage and restore reports |
| Incident contacts and tabletop exercise | At least annually and after major change | Incident response lead | Exercise report/actions |
| Policy, threat, and control baseline | At least annually | CISO / Cloud Security | Approved version and change log |

Cadences above are minimum planning guidance; use stronger frequencies where risk, contractual requirements, or regulation demand. See [governance.md](governance.md) for evidence and exception governance.
