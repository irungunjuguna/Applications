
# AWS Cloud Security Governance

## 1. Purpose

This document establishes the governance framework for managing information security risks across AWS cloud environments.

It defines accountability, ownership, oversight, risk management, control assurance and exception management requirements to ensure that AWS environments are operated securely and in alignment with organizational objectives.

The governance framework is designed to support executive oversight while ensuring that cloud security responsibilities are integrated into technology delivery and day-to-day operations.

## 2. Governance Principles

AWS cloud security governance shall be guided by the following principles:

- **Accountability:** Every AWS environment, workload and security control must have an identified owner.
- **Risk-based decision-making:** Security requirements should reflect business criticality, data sensitivity, regulatory obligations and threat exposure.
- **Shared responsibility:** Cloud security responsibilities must be understood across AWS and the organization.
- **Segregation of duties:** Administrative, operational, development and security responsibilities should be appropriately separated.
- **Security by design:** Security requirements must be considered during architecture, procurement, development and deployment.
- **Continuous oversight:** Security risks, control effectiveness and remediation progress must be regularly reviewed.
- **Evidence-based assurance:** Control compliance must be supported by verifiable configuration records, operational evidence and testing.

## 3. Governance and Accountability Structure

The following governance structure defines the principal responsibilities for AWS security.

### 3.1 Executive Management / Board Risk Oversight

Executive management and relevant Board committees provide oversight of material technology and cybersecurity risks.

Responsibilities include:

- Approving the organization's technology and cybersecurity risk appetite.
- Reviewing material cloud security risks and significant incidents.
- Ensuring adequate resources are allocated to cloud security and resilience.
- Reviewing significant risk exceptions and unresolved high-risk findings.
- Monitoring management's response to material security issues.

The Board should receive information proportionate to its oversight responsibilities rather than routine technical configuration reports.

### 3.2 Chief Information Security Officer (CISO) / Information Security Function

The CISO or designated information security function provides security governance and oversight of AWS environments.

Responsibilities include:

- Establishing and maintaining cloud security policies and baseline requirements.
- Defining minimum security controls for AWS environments.
- Providing independent security review and challenge where organizational responsibilities require it.
- Reviewing cloud security risks and material control deficiencies.
- Monitoring security findings, remediation progress and risk exceptions.
- Providing security guidance for cloud architecture and technology initiatives.
- Overseeing cloud incident response readiness and security assurance.
- Reporting material cloud security risks and control performance to executive management and relevant governance committees.

The CISO should have appropriate visibility into AWS security posture, material risks, exceptions and remediation status.

### 3.3 Cloud Platform / Infrastructure Team

The cloud platform or infrastructure team is responsible for implementing and operating approved AWS environments.

Responsibilities include:

- Managing AWS accounts and organizational structures.
- Implementing approved IAM, network and infrastructure configurations.
- Maintaining secure infrastructure provisioning and configuration practices.
- Implementing logging, monitoring and backup configurations.
- Managing cloud infrastructure changes.
- Supporting vulnerability remediation and incident response.
- Maintaining infrastructure documentation and operational evidence.

### 3.4 Application and Development Teams

Application and development teams are responsible for ensuring that workloads deployed to AWS meet approved security requirements.

Responsibilities include:

- Applying secure coding and deployment practices.
- Protecting application credentials and secrets.
- Integrating security testing into CI/CD pipelines.
- Implementing application-level logging and monitoring.
- Addressing vulnerabilities in application code and dependencies.
- Maintaining application recovery procedures and supporting incident investigations.

### 3.5 Risk, Compliance and Internal Audit

Risk and compliance functions support the identification, assessment and monitoring of cloud-related risks and applicable obligations.

Internal Audit provides independent assurance in accordance with its approved audit mandate.

Responsibilities may include:

- Reviewing cloud security risk assessments and control documentation.
- Monitoring regulatory and contractual compliance requirements.
- Assessing the adequacy of risk treatment plans.
- Reviewing control evidence and remediation records.
- Performing independent assurance over cloud security governance and controls.

Internal Audit should retain appropriate independence from the design and operation of the controls it assesses.

## 4. AWS Shared Responsibility Model

Security responsibilities must be clearly understood between AWS and the organization.

AWS is responsible for security of the cloud, including the underlying infrastructure, physical facilities, hardware and managed service foundations.

The organization is responsible for security in the cloud, including, as applicable:

- Identity and access management.
- Data classification and protection.
- Network and workload configuration.
- Operating system and application security.
- Encryption and key management.
- Logging and monitoring.
- Backup and recovery.
- Security incident response.

Responsibilities vary depending on the AWS service and deployment model. Managed services may reduce certain operational responsibilities but do not remove the organization's accountability for data, access, configuration and business risk.

## 5. AWS Account and Organizational Governance

AWS accounts should be managed through an approved organizational structure.

Minimum requirements include:

- Use AWS Organizations where appropriate to centralize account governance.
- Separate production, development, testing and security functions according to business and risk requirements.
- Restrict access to the AWS Organizations management account.
- Avoid using the management account for routine workload deployment.
- Establish controlled processes for account creation, closure and ownership changes.
- Use delegated administration for supported security services where appropriate.
- Apply Service Control Policies (SCPs) to establish organization-level permission guardrails where applicable.
- Monitor account-level security configurations and unauthorized changes.
- Maintain an inventory of AWS accounts, workloads, owners and business purposes.

SCPs define permission boundaries within AWS Organizations; they do not grant permissions by themselves. Their applicability and exceptions must be understood, including the special treatment of the management account and service-linked roles.

## 6. Cloud Security Risk Management

Cloud security risks must be identified, assessed, documented and treated through the organization's established risk management framework.

Risk assessments should consider:

- Unauthorized access and privilege escalation.
- Public exposure of workloads and data.
- Insecure network configurations.
- Data loss, leakage or unauthorized disclosure.
- Misconfigured cloud services.
- Vulnerable infrastructure and applications.
- Compromised credentials and secrets.
- Inadequate monitoring and incident detection.
- Third-party and supply chain risks.
- Backup compromise and recovery failure.
- Availability, resilience and regional service disruption.

Each material risk should have:

- A clear risk description.
- An identified business and technical owner.
- An assessment of likelihood and impact.
- An agreed risk treatment plan.
- A target remediation date.
- Documented residual risk where applicable.
- Management approval where risk acceptance is required.

Risk assessments should be performed before significant new cloud services or workloads are introduced and periodically thereafter.

## 7. Security Control Ownership

Each security control must have an assigned owner responsible for implementation, operation and evidence retention.

| Control area | Primary operational owner | Oversight |
|---|---|---|
| IAM and MFA | Cloud platform / IAM team | Information Security |
| Privileged access | IAM / Cloud platform team | Information Security |
| Network security | Cloud platform / Network team | Information Security |
| CloudTrail logging | Cloud platform / Security operations | Information Security |
| CloudWatch monitoring | Cloud operations / Security operations | Information Security |
| Threat detection | Security operations / Cloud security | CISO |
| Encryption and key management | Cloud platform / Data owners | Information Security |
| Secrets management | Application / Cloud platform teams | Information Security |
| Configuration management | Cloud platform team | Information Security |
| Vulnerability management | Infrastructure / Application teams | Information Security |
| Backup and recovery | Infrastructure / Workload owners | IT management and Information Security |
| Disaster recovery | IT operations / Business owners | Executive management |
| Incident response | Security operations / Incident response team | CISO |
| Secure deployment | Application / DevOps teams | Information Security |

Responsibilities should be formally assigned and reviewed when teams, systems or ownership structures change.

## 8. Security Exceptions and Risk Acceptance

Exceptions to this baseline must be formally documented, assessed and approved before implementation, except where an emergency process is required.

An exception request must include:

- The specific baseline requirement being waived.
- The business justification.
- The affected AWS accounts, workloads and data.
- The associated security and operational risks.
- Existing or proposed compensating controls.
- The responsible risk owner.
- The proposed exception duration and expiry date.
- The remediation plan, where applicable.

Exceptions should be reviewed by Information Security and approved by the appropriate business or technology risk owner in accordance with the organization's risk authority framework.

Material or high-risk exceptions should be escalated to the CISO and relevant executive risk authority.

Exceptions must not be used to waive applicable legal, regulatory or contractual obligations.

All approved exceptions must be recorded in a centralized risk or exception register and periodically reviewed. Expired exceptions must be reassessed, closed or formally renewed.

## 9. Security Assurance and Control Evidence

AWS security controls must be supported by evidence demonstrating both their implementation and ongoing effectiveness.

Examples include:

| Control domain | Example evidence |
|---|---|
| IAM | IAM policies, role assignments, access reviews and identity configuration |
| MFA | MFA enforcement settings and identity-provider configuration |
| Network security | Security group configurations, network diagrams and firewall rules |
| Logging | CloudTrail configuration, log validation and centralized archive evidence |
| Monitoring | CloudWatch alarms, dashboards, alert records and incident tickets |
| Threat detection | GuardDuty, Security Hub and Inspector configuration and findings |
| Encryption | KMS configuration, key policies and encryption status |
| Configuration management | AWS Config rules, compliance reports and remediation records |
| Vulnerability management | Scan reports, risk assessments and remediation tracking |
| Backup | Backup policies, job reports and restore test evidence |
| Disaster recovery | Approved recovery plans and exercise results |
| Incident response | Incident records, investigation reports and lessons learned |
| Secure deployment | Source control reviews, pipeline security checks and deployment approvals |

Evidence should be retained in accordance with the organization's record retention, audit and regulatory requirements.

Control assurance should distinguish between:

1. **Design effectiveness:** Whether the control is appropriately designed to address the identified risk.
2. **Implementation:** Whether the control has been configured and deployed as intended.
3. **Operating effectiveness:** Whether the control continues to operate consistently and produces the intended outcome.

## 10. Cloud Security Metrics and Reporting

The CISO and relevant technology leadership should receive regular reporting on the AWS security posture.

Suggested metrics include:

| Metric | Reporting objective |
|---|---|
| MFA coverage | Measure enforcement across human identities and privileged access |
| Privileged access reviews | Track completion of periodic access reviews |
| IAM policy exceptions | Monitor excessive permissions and unresolved access risks |
| Public exposure findings | Track publicly exposed resources and remediation |
| CloudTrail coverage | Measure account and Region logging coverage |
| Monitoring coverage | Track critical workload and security alert coverage |
| Threat detection coverage | Monitor relevant GuardDuty, Security Hub and Inspector coverage |
| Encryption coverage | Track encryption of applicable storage, databases and communications |
| Secrets management | Monitor exposed secrets, access and rotation status |
| Configuration compliance | Track AWS Config coverage and unresolved configuration drift |
| Vulnerability remediation | Monitor overdue vulnerabilities by severity and risk |
| Backup success | Track backup completion and failures |
| Recovery testing | Monitor completion of restore and disaster recovery exercises |
| Incident management | Track incident severity, response and remediation trends |
| Security exceptions | Monitor open, overdue and expired exceptions |

Metrics should have defined owners, reporting frequency, targets or thresholds, and escalation criteria. Targets should be established based on business requirements and risk appetite rather than assumed universal values.

## 11. Governance and Review Cadence

The following cadence provides a minimum governance reference. Organizations may adopt more frequent reviews based on risk.

| Activity | Minimum review frequency |
|---|---|
| Critical security alerts | Continuous monitoring where supported |
| High-risk security findings | Prioritized review and tracking |
| Privileged access review | Quarterly |
| IAM access review | Quarterly or following material changes |
| Security group and network exposure review | Quarterly |
| Cloud configuration compliance | Continuous or scheduled monitoring |
| Vulnerability management | Based on severity and defined remediation SLAs |
| Backup monitoring | Daily or according to backup schedules |
| Restore testing | At least annually, with more frequent testing for critical workloads |
| Disaster recovery exercises | At least annually and following significant changes |
| Incident response exercises | At least annually |
| Security exception review | Before expiry and at defined review intervals |
| Cloud security baseline review | At least annually |

## 12. Third-Party and Supplier Governance

Third parties that access AWS environments or process organizational data must be assessed according to their level of access, service criticality and associated risks.

Minimum expectations include:

- Appropriate security due diligence before engagement.
- Defined contractual security and data protection requirements.
- Restricted and monitored third-party access.
- MFA and individual identities for external users where supported.
- Time-bound access and periodic access reviews.
- Appropriate incident notification and escalation obligations.
- Review of relevant assurance reports and certifications where available.
- Secure termination of access when contracts or services end.

Third-party access should be treated as a potential extension of the organization's attack surface.

## 13. Governance Review and Continuous Improvement

This governance framework should be reviewed at least annually and following significant changes to:

- AWS architecture or organizational account structures.
- Business services and workload criticality.
- Security threats and material vulnerabilities.
- Regulatory and contractual requirements.
- Security incidents and audit findings.
- AWS security services and organizational operating models.

Lessons from incidents, audits, control testing and recovery exercises should be used to improve the baseline and strengthen cloud security maturity.

## 14. Approval and Document Control

| Field | Description |
|---|---|
| Document | AWS Cloud Security Governance |
| Document owner | Information Security Function |
| Executive sponsor | CISO / Head of Information Security |
| Review frequency | At least annually |
| Classification | Internal |
| Approval authority | Appropriate technology and risk governance authority |
| Version | 1.0 |
| Status | Draft for review and approval |

This document should be approved through the organization's established policy and governance process before being adopted as a mandatory organizational standard.
