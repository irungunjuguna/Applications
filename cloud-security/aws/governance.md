# Governance and Control Assurance

## 1. Purpose and scope

This standard establishes accountable governance for AWS accounts, workloads, and delivery systems owned or operated by the organization. It applies to production and non-production environments, including services managed by internal teams and approved providers. Contractual, regulatory, and data-residency obligations may impose stricter requirements.

The baseline sets minimum expectations. Workload owners remain responsible for secure architecture, data classification, application controls, operational readiness, and compliance with approved exceptions.

A control is not considered implemented solely because a service is enabled. Its coverage, configuration, alerting, ownership, evidence, and response must also be demonstrated.

Where an AWS service or control is not applicable, the reason must be documented. Where a control cannot be met, the deviation must follow the formal risk exception process.

## 2. Governance model

| Role | Accountability |
| --- | --- |
| Board / risk committee | Oversees material cyber risk, risk appetite, and significant residual risk through established reporting. |
| CISO / security executive | Owns security policy, approves the baseline, sets risk thresholds, sponsors remediation, and escalates material exposure. |
| Cloud Security | Maintains control design, threat guidance, detection requirements, exception review, and security assurance testing. |
| Cloud Platform / landing-zone owner | Implements organization-level guardrails, identity integration, logging foundations, account lifecycle, configuration visibility, and platform evidence. |
| Account / workload owner | Implements workload controls, names service owners, maintains inventory and recovery plans, remediates findings, and participates in exercises. |
| SOC / incident commander | Monitors alerts, coordinates response, maintains incident records, and conducts after-action reviews. |
| Risk / Compliance | Maps controls to obligations, validates evidence, tracks residual risk, and supports independent assurance. |
| CI/CD and developer teams | Protect source, build, deployment identities, artifacts, approvals, and production change records. |
| Data owner / privacy function | Defines data classification, handling requirements, access expectations, retention, and privacy obligations for relevant workloads. |

Each AWS account must have a business owner, technical owner, environment classification, data classification, support/on-call contact, and cost owner recorded in the approved inventory.

Accounts without accountable owners are escalated and may be restricted or decommissioned under approved lifecycle procedures.

AWS Organizations and its management account must receive additional protection. Access to organization-wide administration, consolidated billing, service control policies, delegated administration, and organization-level security services must be restricted, monitored, and subject to change control.

## 3. Control lifecycle

For each control, maintain:

- A unique control ID, objective, applicability, implementation guidance, and accountable owner.
- A testable pass/fail or maturity measure, evidence source, assessment frequency, and remediation target.
- A mapping to internal policies and relevant external requirements, maintained separately from this technical baseline.
- A record of findings, severity, compensating safeguards, due date, and closure evidence.
- A documented process for identifying and recording controls that are not applicable to a particular account or workload.

Use preventive controls where feasible, detective controls for residual risk, and documented response procedures.

Prefer organization-level policies and centrally managed services for consistency, while preserving workload-level ownership and documented responsibility boundaries.

Organization-level guardrails must be tested for their actual scope and limitations. For example, service control policies define maximum available permissions for affected member accounts; they do not grant permissions, and they do not apply to the AWS Organizations management account in the same way they apply to member accounts. Validate policy behavior and recovery procedures before enforcement.

## 4. Risk and exception management

A baseline deviation requires a written exception before implementation, except where an approved emergency process applies.

Each request must include:

1. Control ID and affected accounts, resources, data, and environments.
2. Business rationale and threat/risk assessment, including potential blast radius.
3. Compensating controls, monitoring, and incident response implications.
4. Named accountable owner and risk owner, remediation plan, and target date.
5. Approval under the organization's delegated risk authority; material residual risk is escalated to the CISO or designated committee.

Exceptions must be time-bound, normally no longer than 90 days without renewal. Renewal requires updated evidence and risk review.

Expired exceptions revert to baseline requirements and are escalated. Emergency changes must be documented and reviewed promptly after stabilization.

No approval waives legal, regulatory, or contractual obligations. Where a requirement cannot legally or contractually be waived, the exception process must not be used to authorize non-compliance.

Risk acceptance must be made by an individual with the appropriate delegated authority. Technical teams may recommend acceptance but must not accept material business risk on behalf of the organization unless formally authorized.

## 5. Risk tiers and review cadence

At minimum, classify workloads as **Critical**, **High**, **Standard**, or **Sandbox** using business impact, data sensitivity, internet exposure, and dependency analysis.

Critical and High workloads require stronger recovery objectives, more frequent privileged-access review, and prioritized incident response.

Sandbox accounts remain subject to identity, audit logging, and non-production data safeguards; they are not exempt from foundational security controls. Production data must not be copied into lower environments without approved masking, minimization, and access safeguards.

Recommended minimum governance cadence:

- **Continuous or daily:** control-plane detections, pipeline security gates, high-severity alerts, and exposed-resource checks.
- **Monthly:** security findings and overdue remediation review; inventory/account owner validation.
- **Quarterly:** privileged access and exception review; recovery-point and backup coverage reporting; incident response contact validation.
- **At least annually:** policy and threat review, access recertification for all access, DR exercise for critical services, and baseline approval.
- **After significant change:** reassess threat model, data classification, recovery design, and applicable controls.

Adjust frequencies based on risk, threat intelligence, regulation, and demonstrated control effectiveness.

## 6. Executive oversight and metrics

Cloud Security provides a concise, trend-based view to the CISO and designated risk committee.

Metrics must include scope and denominator, ownership, reporting period, and known limitations. Avoid presenting raw counts without context.

Suggested indicators:

- Percentage of accounts with verified owners, required logging, monitoring, configuration visibility, and approved guardrails.
- MFA/federated-access coverage and completion of privileged-access recertification.
- Critical/high findings open past target, age distribution, and exception exposure.
- Publicly exposed resources and broad security-group rules, by risk tier and time to remediation.
- CloudTrail coverage, delivery/validation health, and alert pipeline test results.
- AWS Config coverage and compliance drift for in-scope resources.
- Threat-detection coverage, high-severity findings, investigation status, and remediation.
- Encryption coverage for in-scope data stores and backup repositories.
- Backup coverage against policy, last successful restore test, and RPO/RTO exercise results.
- Security incident severity, time to acknowledge/contain, recurrence, and after-action item closure.
- Production deployment policy-gate pass rates, emergency changes, and change traceability.

Metrics support risk decisions; they do not prove compliance on their own. Material gaps, systemic failures, and accepted high residual risks must be escalated through established governance.

## 7. Evidence and assurance

Evidence should be attributable, time-stamped, reproducible, access-controlled, and retained according to the organization's records schedule.

Examples include:

- Organization/account inventory exports.
- Service control policy and configuration records.
- Identity-provider and MFA reports.
- CloudTrail status, event selectors, and delivery validation.
- AWS Config coverage and compliance reports.
- Security Hub and GuardDuty findings and remediation records, where deployed.
- KMS key policies and encryption configuration.
- CloudWatch alert tests.
- Backup policy and restore records.
- Access review sign-offs.
- Approved exceptions.
- Pipeline run attestations.
- Incident timelines.
- Remediation tickets.

Evidence repositories must not be writable by the same routine workload identities whose controls they demonstrate.

Protect sensitive evidence and incident records according to classification.

Independent assurance should sample control design and operating effectiveness, verify exceptions, and test recovery and response—not rely only on screenshots or self-attestation.

Where the same team operates and assesses a control, the organization should consider independent review proportionate to the control's risk and regulatory significance.

## 8. Policy review and change control

Cloud Security owns this baseline.

Material changes require documented review by platform, operations, workload representatives, and risk/compliance as appropriate, followed by approval from the designated security authority.

Maintain version history and communicate effective dates.

AWS product documentation and organizational policy take precedence where this reference becomes outdated or conflicts with binding requirements. Record and resolve conflicts through governance rather than silently bypassing controls.
