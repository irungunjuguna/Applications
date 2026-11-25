# AWS Cloud Security Baseline

A governance-oriented baseline for designing, operating, monitoring, and continuously improving AWS environments. It defines minimum control expectations for identity, network boundaries, data protection, detection, audit logging, resilience, incident response, and secure software delivery.

> **Audience:** CISO and security leadership, cloud platform owners, security engineering, application teams, risk/compliance, and auditors.
>
> **Status:** Reference baseline for adaptation. This repository is not an AWS service configuration, legal opinion, or certification. Validate controls against current AWS capabilities, applicable regulations, threat models, and organizational risk appetite before adoption.

## Outcomes and principles

- Establish accountable ownership, measurable controls, and auditable evidence across AWS accounts.
- Prefer centralized, preventive guardrails with service-team accountability for workload-level controls.
- Use identity federation and short-lived credentials; grant only the access needed for a defined purpose and duration.
- Protect sensitive information through classification, encryption, access controls, and appropriate data-handling safeguards.
- Enable organization-wide audit and security telemetry, protect it from alteration, and test alert response.
- Use centralized configuration visibility and threat detection appropriate to workload risk.
- Design backup and recovery around approved business impact analysis (BIA), Recovery Time Objectives (RTO), and Recovery Point Objectives (RPO)—not assumptions.
- Treat infrastructure, source repositories, build systems, and deployment pipelines as production security boundaries.
- Document, approve, time-limit, and review exceptions; no exception silently becomes the standard.

## Baseline documents

| Document | Scope |
| --- | --- |
| [Governance and control assurance](governance.md) | Ownership, control lifecycle, evidence, risk exceptions, and executive oversight. |
| [Security control standards](security-controls.md) | IAM, network security, encryption, data protection, secrets, CloudTrail, monitoring, and secure deployments. |
| [Resilience and recovery](resilience.md) | Backup, retention, recovery objectives, DR patterns, and restore testing. |
| [Incident response playbooks](incident-response.md) | Triage and response procedures for common AWS security events. |
| [Implementation and evidence checklist](implementation-checklist.md) | Rollout sequence, evidence examples, and operating cadence. |

## Minimum baseline at a glance

1. AWS Organizations account boundaries and centrally managed guardrails are used where available; production workloads are separated from non-production.
2. Human access is federated through an approved identity provider and AWS IAM Identity Center or an equivalent controlled federation. MFA is required for all human access.
3. Root credentials are tightly controlled, protected with MFA, unused for routine work, and monitored. Workloads use roles and temporary credentials, not embedded access keys.
4. Permissions are role-based and least privilege. Wildcards, privileged policies, and long-lived credentials require justification, controls, and review.
5. Security groups and network controls allow only documented, necessary flows; broad public ingress is prohibited unless explicitly approved and protected.
6. Sensitive data is classified and protected through encryption, access restrictions, secure handling, and appropriate key-management controls.
7. Secrets and credentials are stored in approved secrets-management systems rather than source code, images, deployment artifacts, or logs.
8. Organization-wide, multi-Region CloudTrail management-event logging is enabled and delivered to a restricted central archive. Required data events are selected by risk and service.
9. AWS Config and approved threat-detection services provide configuration visibility and security findings across in-scope accounts and Regions, where supported and justified.
10. CloudWatch and other approved telemetry feed actionable alerts with named owners, severity, response targets, and tested escalation paths.
11. Backup and recovery policies are tiered by workload criticality, with protected copies and recurring restore/DR exercises.
12. Production changes flow through authenticated, reviewed, policy-checked CI/CD using short-lived credentials and traceable artifacts.
13. Security incidents are handled through documented playbooks, evidence-preserving procedures, and post-incident improvement.

## Use and tailoring

Start with [governance.md](governance.md) to assign owners and define risk tiers. Apply [security-controls.md](security-controls.md) across the organization, then tailor the recovery objectives and safeguards in [resilience.md](resilience.md). Exercise [incident-response.md](incident-response.md) with the relevant teams and track closure of checklist items in [implementation-checklist.md](implementation-checklist.md).

Use a documented control mapping to connect this baseline to internal policies and external obligations. AWS service names, features, defaults, pricing, and regional availability can change; confirm current product documentation and test changes in a representative account before broad rollout.

Not every AWS service or control is applicable to every workload. Where a service is not used, document its non-applicability. Where a control cannot be implemented, record the risk, compensating safeguards, accountable owner, approval, and review date through the exception process.

## Reference material

- [AWS Well-Architected Framework — Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
- [AWS Security Reference Architecture](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/welcome.html)
- [AWS Organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html)
- [AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)
- [AWS IAM best practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [AWS KMS best practices](https://docs.aws.amazon.com/kms/latest/developerguide/best-practices.html)
- [AWS Config](https://docs.aws.amazon.com/config/latest/developerguide/WhatIsConfig.html)
- [Amazon GuardDuty](https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html)
- [AWS Security Hub](https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html)
- [AWS Backup](https://docs.aws.amazon.com/aws-backup/latest/devguide/whatisbackup.html)

## Versioning

Baseline owner: Cloud Security.

Review at least annually and after material architecture, threat, regulatory, or AWS service changes. Material changes should follow the approval and change-control process in [governance.md](governance.md).
