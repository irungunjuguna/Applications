# AWS Security Incident Response Playbooks

These playbooks are an operational starting point. Integrate them with the organization's incident management, legal, privacy, communications, law-enforcement, and regulatory-notification processes.

Follow current AWS service documentation and organizational evidence-handling procedures. Do not destroy evidence or make irreversible changes without incident commander authorization unless immediate containment is necessary to prevent imminent harm.

## 1. Response principles and authority

1. **Declare and coordinate:** The SOC/on-call responder opens an incident record, assigns severity, notifies the incident commander, and engages cloud platform, workload owner, security, legal/privacy, and communications as required.
2. **Preserve evidence:** Record timestamps in UTC, account/Region/resource identifiers, actor/session context, queries, decisions, and actions. Preserve relevant audit, identity, network, endpoint, and application logs in restricted storage. Maintain chain of custody where required.
3. **Scope before broad action:** Identify affected identities, accounts, Regions, resources, data, and downstream trust relationships. Assess possible attacker persistence and tampering of logs or controls.
4. **Contain proportionately:** Prefer reversible, scoped actions. Emergency containment authority and pre-approved guardrails must be documented. Avoid tipping off an adversary where it would increase risk, while prioritizing safety and business continuity.
5. **Eradicate and recover:** Remove unauthorized access and persistence, rebuild from trusted sources when warranted, rotate exposed secrets, validate integrity, and restore using an approved recovery plan.
6. **Close the loop:** Communicate approved updates, meet applicable notification timelines, conduct a blameless post-incident review, track corrective actions, and update detections and playbooks.

Severity, notification targets, and response-time objectives must be set by the organization and exercised. Contact routes and escalation schedules must be maintained outside this repository in an access-controlled operational system.

## 2. Playbook: suspected compromised IAM credentials or role

**Triggers:** Unusual console/API activity, impossible travel or unfamiliar source, unexpected role assumption, credential exposure, access-key finding, privilege escalation, or high-confidence identity alert.

### Triage and scope

- Verify account, principal, session, source IP/device, user agent, time window, API actions, resources accessed, and whether activity matches an approved change.
- Query protected CloudTrail and identity-provider evidence. Identify all sessions, keys, roles, trust relationships, affected resources, and signs of persistence or log tampering.
- Determine whether the credentials are long-lived IAM access keys, temporary STS credentials, federated sessions, workload credentials, or credentials issued by an external identity provider.
- Identify whether credentials may have been copied into source repositories, build logs, artifacts, container images, application configuration, or other systems.
- Ask identity and workload owners to confirm legitimate activity without sharing secrets in incident channels.

### Containment (authorized responder)

- For compromised IAM access keys, deactivate the affected key and assess whether it should be deleted after evidence preservation and coordination.
- For compromised IAM users, roles, or federated identities, apply the approved containment process. This may include disabling the identity, restricting permissions, changing trust relationships, or applying a scoped deny.
- Assess active temporary sessions separately. Use supported session-revocation mechanisms, identity-provider session termination, role-session restrictions, or other approved controls as appropriate. Do not assume that disabling an access key or changing an IAM policy immediately invalidates every credential or session already issued.
- Consider downstream credential exposure, including secrets, database credentials, tokens, and credentials obtained by workloads using the affected identity.
- Apply scoped deny/containment controls and isolate affected compute or workloads where safe. Protect unaffected break-glass and incident-response access.
- Preserve relevant policy versions, identity evidence, resource state, and logs before cleanup when feasible.

### Eradication and recovery

- Identify the initial access path and persistence, including new users, access keys, roles, policies, trust changes, compute credentials, secrets, or pipeline changes. Remove unauthorized changes only after evidence capture and owner coordination.
- Rotate exposed secrets, tokens, and keys. Review dependent systems for reuse of compromised credentials.
- Rebuild compromised workloads from trusted artifacts if integrity is uncertain.
- Restore minimum necessary permissions, validate expected identities and workload behavior, and monitor for re-entry.
- Review related accounts and trust relationships where the compromised identity had cross-account access.

**Exit criteria:** Unauthorized access is contained; scope and data exposure are assessed; credentials and persistence are addressed; service owner validates recovery; monitoring is heightened; incident commander accepts residual risk.

## 3. Playbook: suspected public data exposure or exfiltration

**Triggers:** Public access configuration change, sensitive-data finding, abnormal object/database access or transfer, exfiltration alert, or customer report.

### Triage and containment

- Determine data classification, resources, exposure duration, access path, principal/source, affected records, and whether data was accessed or downloaded.
- Preserve access logs, configuration history, policy versions, and relevant network evidence.
- Restrict unintended public access using the narrowest safe control. Coordinate with data/service owners to avoid destructive changes or loss of legitimate service.
- Preserve a controlled forensic copy if required.
- Revoke compromised credentials and investigate adjacent resources and copied data paths.
- Do not assume removal of public access reverses prior exposure. Assess whether data may have been downloaded, replicated, cached, or otherwise retained by an unauthorized party.

### Assessment and notification

- Engage privacy, legal, compliance, and business owners promptly to assess obligations, impact, and notification deadlines.
- Only authorized parties communicate externally.
- Verify exposure closure from an independent perspective and monitor for further access or replication.
- Record the data types, affected individuals or customers where ascertainable, potential impact, and any remaining uncertainty.

**Exit criteria:** Exposure is contained and validated, impact assessment is documented, legal/privacy decisions are recorded, affected parties are handled under approved policy, and corrective controls have owners and deadlines.

## 4. Playbook: audit logging or security-control tampering

**Triggers:** CloudTrail disabled/deleted, delivery failures, log bucket/key policy changes, retention reduction, monitoring disabled, security service tampering, or unexplained telemetry gaps.

- Treat missing telemetry as a potential incident, not merely a configuration defect. Determine affected accounts/Regions, change principal, exact gap interval, and possible evidence deletion.
- Use independent organization-level, identity-provider, service, and external SIEM evidence to establish the timeline.
- Preserve configuration snapshots, storage access records, relevant event history, and available copies of logs.
- Restore approved logging and alerting configuration through a trusted administrative path.
- Restrict the suspected principal and review access to logging destinations and encryption keys.
- Hunt for related privilege changes, unusual resource creation, data access, and persistence.
- Validate delivery, integrity, searchability, and alert routing end-to-end.
- Record the telemetry gap, lost visibility, scope uncertainty, and compensating evidence.
- Escalate material gaps to the incident commander and risk owner.

## 5. Playbook: suspected ransomware, destructive activity, or backup compromise

**Triggers:** Mass encryption/deletion, abnormal API deletion, backup recovery point removal, vault/retention changes, corrupted data, or service outage with destructive indicators.

- Declare the incident and invoke the business continuity/DR authority.
- Identify affected accounts, Regions, data, backups, keys, and dependencies.
- Preserve logs, snapshots, workload state, and backup metadata as directed.
- Stop ongoing destructive access with scoped identity/session containment.
- Protect unaffected backup accounts and recovery identities. Do not delete compromised resources or backups before preservation decisions.
- Validate backup integrity and isolation from affected principals.
- Determine a known-good recovery point and test restoration in an isolated environment before production recovery.
- Rebuild from trusted infrastructure and artifacts; rotate credentials and keys as required.
- Verify application and data integrity before reconnecting recovered workloads.
- Communicate service impact through approved channels.
- Record measured recovery time/data loss versus objectives and initiate corrective actions for any gap.

## 6. Playbook: vulnerable or compromised production deployment

**Triggers:** Critical vulnerability in a deployed component, malicious artifact, unauthorized deployment, pipeline compromise, or unexpected production change.

- Freeze or restrict the affected pipeline/environment under incident authority.
- Preserve source, workflow definitions, build logs, artifact hashes/provenance, approvals, deployment records, and cloud activity.
- Identify impacted versions, accounts, workloads, exposed secrets, and data.
- Determine whether the issue is exploitation, supply-chain compromise, or configuration error.
- Revoke or restrict compromised pipeline identities and credentials. Assess whether temporary sessions or downstream workload credentials remain active.
- Roll back to a known-good version or deploy a reviewed fix using a trusted pipeline. Do not bypass review without documented emergency authorization.
- Rotate any credentials available to the compromised build or workload.
- Verify production state independently, monitor for persistence/exploitation, and restore normal change controls only after approval.
- Review the pipeline's permissions, source repository access, runner configuration, artifact storage, and deployment trust relationships.

## 7. Communications, evidence, and post-incident review

Maintain a timeline, decision log, severity rationale, evidence index, containment/eradication record, affected-scope assessment, customer/business impact, and approval trail.

Store records in a restricted repository with retention aligned to legal and regulatory needs. Do not include credentials or unnecessary sensitive data in chat/tickets.

After stabilization, hold a review proportionate to severity. Document root and contributing causes, detection/response performance, control failures, decision trade-offs, what worked, and specific actions with accountable owners and dates.

Track actions to verified closure, update threat models and detections, and report material lessons and residual risks to the CISO/risk committee under [governance.md](governance.md).

## 8. Exercise and readiness requirements

- Maintain 24x7 escalation paths appropriate to workload criticality and ensure responders can access logs during an identity-provider or production-account disruption.
- Exercise at least annually and after major changes; include security, platform, workload, legal/privacy, and communications roles as appropriate.
- Test access revocation, evidence preservation, central-log access, backup isolation, recovery, decision authority, and external notification workflow using tabletop or controlled simulations.
- Test containment procedures for long-lived credentials and temporary sessions without using real destructive actions.
- Record objectives, participants, findings, lessons, action owners, deadlines, and retest evidence.
- Never use real destructive actions in an exercise without explicit authorization and safeguards.
