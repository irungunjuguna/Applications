# AWS Security Control Standards

This document defines minimum technical expectations. Controls should be implemented through a governed landing zone, organization policies, infrastructure as code, managed security services, and workload-specific controls as appropriate. Validate behavior in test accounts before enforcing organization-wide.

## 1. Identity and access management (IAM)

### 1.1 Identity source and human access

- Use the approved enterprise identity provider and centralized federation (for example, AWS IAM Identity Center) for workforce access. Avoid creating routine standalone IAM users.
- Require MFA for every human interactive path to AWS, including console and command-line access. Prefer phishing-resistant methods where supported by organizational standards. Require step-up/authentication strength appropriate to privileged operations.
- Use named individual identities; prohibit shared human accounts. Access must be attributable to a person and tied to an approved role, ticket, or job function.
- Use separate roles/permission sets for read-only, operational, security administration, and high-impact changes. Production administration must not be bundled into day-to-day access.
- Use time-bound, just-in-time privileged access where available. Require approval and enhanced audit for highly privileged sessions.
- Review role assignments at least quarterly and all entitlements at least annually; more frequently for privileged or regulated workloads. Remove access promptly on termination or role change.

### 1.2 Root and emergency access

- Do not use the account root user for routine operations. Protect root credentials with MFA, store recovery material in an approved restricted vault, and monitor root activity.
- Do not create root access keys. Secure contact and recovery channels and review them periodically.
- Define a controlled break-glass path for loss of federation or critical incident: sealed/managed credentials, named custodians, approval or documented emergency rationale, MFA, alerting, session recording where supported, immediate post-use rotation/review, and an after-action record.
- Exercise the break-glass procedure without weakening normal controls. Root protection features and account-specific requirements should be checked against current AWS guidance.

### 1.3 Workload identities and credentials

- Use IAM roles and temporary credentials for AWS workloads, automation, and cross-account access. Do not embed credentials in source code, container images, AMIs, user data, artifacts, tickets, or logs.
- Prohibit new long-lived access keys except for documented, approved compatibility cases. For approved keys, assign an owner, restrict permissions, store in a secrets manager, monitor usage, rotate on a defined schedule, and remove when no longer needed.
- Use workload-specific roles and trust policies restricted to expected principals, accounts, repositories, environments, and conditions. Avoid overly broad trust relationships and unconstrained external IDs.
- Separate duties for identity administration, policy approval, production deployment, and security-log administration where practicable.

### 1.4 Least privilege and policy hygiene

- Grant permissions for explicit actions on explicit resources, constrained by conditions (such as resource tags, source identity, organization, network, or encryption context) where applicable and tested.
- Start with a narrow role and expand based on observed, reviewed application needs. Never treat generated access recommendations as automatic approval.
- `Action: "*"`, `Resource: "*"`, administrative managed policies, wildcard trust, and privilege-escalation paths require explicit risk review and documented justification. Use resource scoping and permission boundaries or equivalent guardrails where appropriate.
- Apply organization-level service control policies as guardrails, not as a substitute for identity policies. Test policy effects, maintain emergency recovery paths, and avoid locking out organization management.
- Restrict ability to modify identity policies, disable security controls, alter audit destinations, or delete evidence to a small, monitored administrative set. Use separation of duties and change review.
- Use IAM Access Analyzer and policy validation/simulation as supporting checks; review findings, unused access, and cross-account/public exposure on a recurring basis.

## 2. Network and security group standards

- Use security groups as stateful workload firewalls with explicit ownership, purpose, and application flows. Permit only required protocol/port/source or destination combinations.
- Default inbound posture is deny (no unnecessary inbound rules). Egress should be constrained where feasible based on architecture; document and monitor justified broad egress.
- Prohibit public ingress from `0.0.0.0/0` or `::/0` to administration and data-plane ports (including SSH, RDP, database, cache, and management interfaces). Prefer managed access paths such as private connectivity, VPN, bastion alternatives, or approved session-management services.
- Public web ingress is allowed only for approved internet-facing endpoints, through the documented edge architecture and protective controls. Avoid exposing instances directly when a managed load balancer or equivalent architecture is appropriate.
- Do not reference another security group without validating the associated trust boundary, account, and network path. Avoid rules that unintentionally enable broad lateral movement.
- Tag groups with owner, application, environment, purpose, and review date. Remove stale rules and unattached groups through a controlled process.
- Alert on newly created public exposure, high-risk ports, broad CIDRs, and unexpected changes. Exceptions must specify source, ports, resource scope, expiry, owner, and compensating controls.

## 3. CloudTrail logging baseline

- Enable organization-wide CloudTrail management-event coverage across enabled and opted-in Regions using a centrally governed trail or equivalent organization-approved architecture.
- Capture read and write management events. Protect trail configuration and delivery from modification by ordinary account administrators and workloads.
- Select data events according to data sensitivity, threat model, service support, and cost/risk analysis (for example, access to sensitive object stores or serverless workloads). Document services/resources not covered and compensating detections.
- Enable log-file integrity validation where supported. Deliver logs to a dedicated central security/log-archive account and restricted storage destination. Use encryption with controlled key administration, least-privilege bucket/key policies, public-access blocks, and organization guardrails.
- Apply retention, legal hold, and deletion controls according to regulatory and records-management requirements. Use immutability/WORM controls where required and validate recovery from accidental or malicious deletion.
- Monitor delivery failures, trail disablement/deletion, logging configuration changes, unusual root activity, and attempts to alter archive policy. Route alerts to an owned queue/SOC with severity and response targets.
- Validate actual coverage, event selectors, Region behavior, delivery, access restrictions, and searchability. A trail configured as enabled is not sufficient evidence of effective logging.

## 4. CloudWatch and security monitoring requirements

CloudWatch is one part of the detection architecture. Where appropriate, integrate CloudTrail, AWS Config, GuardDuty, Security Hub, VPC Flow Logs, application/security logs, and approved SIEM tooling. Availability of services and integrations varies by Region and account; document coverage gaps.

Minimum monitoring expectations:

- Centralize relevant account, workload, and application telemetry in approved security/operations destinations with access controls and defined retention.
- Create actionable alerts for high-risk identity events, root use, suspicious authentication, privilege/policy changes, public exposure, logging disablement, encryption/key-policy changes, security service tampering, backup deletion, and critical service health/capacity signals.
- Define each alarm’s signal/source, severity, owner, threshold or detection logic, notification route, response target, runbook, suppression policy, and test method.
- Avoid alerting without a responsible responder. Route security events to the SOC/on-call pathway; service health alarms go to the service owner. Maintain escalation when primary responders do not acknowledge.
- Protect alarm, dashboard, log-group, subscription, and notification configuration from unauthorized changes. Alert on tampering and ensure delivery endpoints have least privilege.
- Set log retention by data classification and legal requirements. Avoid logging credentials, secrets, or unnecessary personal data. Apply encryption and access auditing to sensitive log groups.
- Test alarms and end-to-end notification delivery at a defined cadence and after material change. Track noisy or ineffective detections and tune under change control.

## 5. Secure deployment and change principles

- Store infrastructure and application changes in version control. Require peer review, protected branches, accountable approvals, and traceable links between commit, build, deployment, and change record.
- Use CI/CD federation (OIDC or an equivalent short-lived identity mechanism) to assume narrowly scoped roles. Do not use personal access keys or persistent cloud keys in pipeline secrets.
- Separate build, test, and production deployment permissions and environments. Require explicit approval for production and high-impact security-control changes; emergency bypasses require later review.
- Scan source, dependencies, container images, infrastructure-as-code, and artifacts using approved tools. Enforce policy checks for public exposure, encryption, identity wildcards, logging, and prohibited services before production deployment.
- Produce traceable, integrity-protected build artifacts; restrict who can publish/promote them. Pin dependencies and actions/images where practical, and maintain vulnerability response and provenance practices appropriate to risk.
- Use isolated and ephemeral runners where feasible; minimize runner permissions, network reach, and secret exposure. Protect pipeline configuration and review changes to workflow definitions.
- Deploy through staged environments with automated tests, security gates, rollback/forward-fix plans, and post-deployment verification. Detect infrastructure drift and reconcile it through reviewed changes.
- Prevent pipelines and workload roles from disabling audit, guardrails, monitoring, or backup protections unless specifically authorized, isolated, and audited.

## 6. Control acceptance

A control owner must retain evidence of configuration and operation, review findings, and document gaps. Risk-based deviations follow [governance.md](governance.md). Use the [implementation checklist](implementation-checklist.md) to establish coverage and test evidence. Do not claim compliance solely from this document or a service being enabled.
