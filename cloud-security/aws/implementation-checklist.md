# Implementation and Evidence Checklist

Use this checklist to plan adoption and assurance. Assign an owner and due date for each item in the organization's tracking system.

“Implemented” requires evidence of both configuration and operation. Where a control is not applicable, document the reason, approval and review date.

## Phase 1 — Governance and account foundations

- [ ] Approve the baseline, scope, control owners, risk tiers, and exception authority.
- [ ] Establish an AWS Organizations account inventory with business/technical owners, environment, data classification, contact, cost owner, and lifecycle status.
- [ ] Define production/non-production separation and account vending, decommissioning, and ownership-change processes.
- [ ] Establish organization-level guardrails with tested break-glass recovery and change governance.
- [ ] Restrict and monitor access to the AWS Organizations management account and organization-wide administration.
- [ ] Document the scope and limitations of organization-level policies and delegated administration.
- [ ] Map this baseline to internal policies, legal/regulatory obligations, and evidence-retention requirements.
- [ ] Establish a process for recording control non-applicability and approved exceptions.

**Evidence examples:** approved policy/version record; account inventory export; owner attestation; architecture/landing-zone design; guardrail test and change record; organization administration access review; exception register.

## Phase 2 — Identity and privilege

- [ ] Federate human access through approved centralized identity; enforce MFA for all human access paths.
- [ ] Protect root users, prohibit root access keys, monitor root activity, and document recovery/break-glass procedures.
- [ ] Review centralized root-access capabilities where adopted and document account coverage and recovery arrangements.
- [ ] Replace embedded credentials and routine long-lived keys with roles and temporary credentials.
- [ ] Define role catalog, least-privilege policy standards, permission boundaries/guardrails, and privileged approval workflow.
- [ ] Review cross-account trusts, wildcard permissions, administrative entitlements, and privilege-escalation paths.
- [ ] Establish controls for service roles, automation identities, and CI/CD workload identities.
- [ ] Complete periodic access recertification and promptly revoke leaver/role-change access.
- [ ] Establish monitoring and response procedures for credential exposure and suspicious role assumption.

**Evidence examples:** IdP/MFA coverage report; role and policy inventory; access-review sign-offs; key/credential findings and remediation; break-glass exercise record; cross-account trust review; privileged access monitoring evidence.

## Phase 3 — Network, data protection, and configuration

- [ ] Apply security-group standards, tag owners, identify public exposure, and implement exception expiry/review.
- [ ] Review VPC routing, network segmentation, gateways, peering, private endpoints, and administrative access paths.
- [ ] Classify data stored or processed in AWS and identify data owners, retention requirements, and permitted access.
- [ ] Verify encryption in transit and at rest for in-scope data stores, workloads, backups, and logs.
- [ ] Define AWS KMS key ownership, policies, permitted use, rotation, recovery, and deletion controls.
- [ ] Restrict key-administration and destructive key-management permissions.
- [ ] Enable and review appropriate public-access protections for supported storage services.
- [ ] Establish secrets-management requirements for credentials, tokens, certificates, and sensitive configuration.
- [ ] Verify that secrets are not embedded in source repositories, images, artifacts, user data, or logs.
- [ ] Establish configuration visibility across in-scope accounts and Regions using AWS Config or an approved equivalent.
- [ ] Define configuration rules, drift handling, coverage reporting, and remediation ownership.
- [ ] Establish vulnerability identification, prioritization, remediation targets, and exception handling.

**Evidence examples:** security-group inventory; network architecture and rule review; data classification records; encryption coverage report; KMS key-policy review; public-access findings; secrets inventory and rotation evidence; AWS Config coverage report; vulnerability remediation records.

## Phase 4 — Audit logging and detection

- [ ] Verify organization-wide multi-Region CloudTrail management-event coverage and required data-event selection.
- [ ] Centralize and restrict log archive access; configure encryption, integrity checks where supported, retention, and deletion safeguards.
- [ ] Monitor CloudTrail delivery failures, configuration changes, and attempts to alter log archives.
- [ ] Establish configuration monitoring and drift detection for in-scope resources.
- [ ] Evaluate threat-detection services such as GuardDuty, Security Hub, and Amazon Inspector based on applicability and risk.
- [ ] Confirm account, Region, and workload coverage for approved detection services.
- [ ] Alert on logging gaps/tampering, root and privileged activity, public exposure, sensitive data access, backup destruction, and critical service signals.
- [ ] Assign alert owners, response objectives, runbooks, escalation, and delivery tests.
- [ ] Validate telemetry coverage and searchability across all in-scope accounts/Regions and document gaps.
- [ ] Test end-to-end notification and escalation paths.

**Evidence examples:** trail/account/Region coverage report; event selectors; archive policy and access review; integrity/delivery test; AWS Config coverage; GuardDuty/Security Hub findings; alarm inventory; notification test; finding remediation tickets.

## Phase 5 — Resilience and incident response

- [ ] Complete BIA and approved RTO/RPO for every critical/high workload.
- [ ] Define backup scope, frequency, retention, encryption, isolation, cross-account/Region needs, and deletion protection.
- [ ] Protect backup administration, recovery identities, and encryption keys from compromise of routine production credentials.
- [ ] Monitor backup success, resource coverage, missed recovery points, and replication lag.
- [ ] Test restore and DR procedures; record measured recovery results and corrective actions.
- [ ] Confirm recovery access, keys, network connectivity, quotas, and dependencies are available during a disruption.
- [ ] Approve incident severity, contact routes, authority, evidence handling, and notification workflows.
- [ ] Document procedures for credential compromise, data exposure, logging tampering, destructive activity, and deployment compromise.
- [ ] Exercise access revocation, temporary-session containment, evidence preservation, backup isolation, and recovery.
- [ ] Track after-action findings and verify corrective-action closure.

**Evidence examples:** BIA and objectives approval; coverage report; backup policy and vault protections; access review; restore/DR exercise record; incident timeline; response playbooks; after-action closure.

## Phase 6 — Secure delivery and continuous assurance

- [ ] Use reviewed source control, protected branches, authenticated CI/CD, and short-lived deployment identities.
- [ ] Separate production deployment privileges; require approval for high-impact changes and document emergency paths.
- [ ] Scan code, dependencies, artifacts, containers, and infrastructure as code; block defined high-risk policy violations.
- [ ] Protect pipeline runners and artifacts; maintain provenance/traceability from commit to production.
- [ ] Protect repository administration, build configuration, workflow definitions, and deployment credentials.
- [ ] Test drift detection, rollback/recovery, and post-deployment validation.
- [ ] Establish dashboards and CISO reporting for control coverage, overdue risk, access, logging, encryption, backup/DR, incidents, and deployment integrity.
- [ ] Schedule recurring control tests and independent assurance; verify remediation closure.
- [ ] Review control non-applicability and exceptions before expiry.

**Evidence examples:** pipeline configuration and role trust; approval records; scan results; artifact provenance; change/deployment record; drift findings; dashboard definitions and review minutes; independent assurance reports; exception review evidence.

## Operational review register

| Review | Minimum cadence | Accountable owner | Record |
| --- | --- | --- | --- |
| High-severity detections and logging health | Continuous/daily | SOC / Cloud Security | Incident and alert queue evidence |
| Critical/high control findings and remediation | Monthly | Cloud Security + workload owner | Risk register and tickets |
| Account ownership and inventory | Monthly or on account change | Platform owner | Reconciled inventory |
| Privileged access and exceptions | Quarterly | Identity owner + risk owner | Approved review and exception register |
| Encryption and key-management controls | At least quarterly, and after material changes | Cloud Security + platform owner | Key and encryption review |
| Configuration and threat-detection coverage | Monthly | Cloud Security + platform owner | Coverage and findings reports |
| Backup coverage and restore evidence | Quarterly (more often by tier) | Workload owner | Coverage and restore reports |
| Incident contacts and tabletop exercise | At least annually and after major change | Incident response lead | Exercise report/actions |
| Vulnerability remediation | Monthly; critical findings more frequently | Workload owner + security | Vulnerability and remediation reports |
| Policy, threat, and control baseline | At least annually | CISO / Cloud Security | Approved version and change log |

Cadences above are minimum planning guidance; use stronger frequencies where risk, contractual requirements, or regulation demand.

See [governance.md](governance.md) for evidence and exception governance.
