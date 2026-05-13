=====================================================
Critical Incident Response Process — Activity Diagram
=====================================================

:module: requisitos
:diagram_type: activity
:description: Escalation, investigation, and resolution workflow
:created: 2026-04-26
:status: Production

Process Overview
================

This activity diagram illustrates the critical incident response workflow from alert detection through operator response, escalation to supervisor, investigation, remediation, and post-mortem analysis.

Activity Diagram
================

.. uml::

   @startuml incident_response
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: activity
   ' description: Incident response and escalation workflow

   start
   :Alert triggered;
   :Operator notified\n(email, SMS, Slack);
   :Operator acknowledges\nalert within 15 min?;
   if (Acknowledged?) then (no)
     :Auto-escalate to\nSupervisor;
   else (yes)
   endif
   :Operator investigates\nroot cause;
   :Classify severity\n(P1/P2/P3);
   fork
     :Escalate to Supervisor\n(if P1);
     :Create incident ticket;
   fork again
     :Audit log incident;
     :Notify stakeholders;
   end fork
   :Execute remediation\n(manual or automated);
   :Verify fix\n(metrics return to normal);
   if (Fixed?) then (no)
     :Escalate further;
     :Re-investigate;
   else (yes)
     :Close incident;
     :Schedule post-mortem\n(within 48h);
     :Conduct post-mortem\n(root cause analysis);
     :Document lessons learned;
   endif
   end

   note right
     Swimlanes:
     - Operator: Responds and investigates
     - Supervisor: Escalation and approval
     - DevOps: Implements fixes
     - Auditor: Logs and tracks
   end note

**Process Steps:**

1. **Alert Triggered** - System detects critical condition
2. **Notification** - Operator receives alert (multi-channel)
3. **Acknowledgment Check** - Operator acknowledges within SLA?
   - **NO:** Auto-escalate to Supervisor
   - **YES:** Operator begins investigation
4. **Investigation** - Operator collects logs, checks metrics, identifies root cause
5. **Severity Classification:**
   - P1 (Critical): System down, data loss risk, security breach
   - P2 (High): Degraded performance, limited functionality
   - P3 (Medium): Minor issue, workaround available
6. **Parallel Actions:**
   - Escalate to Supervisor (P1 only)
   - Create incident ticket in tracking system
   - Audit log incident details
   - Notify stakeholders (manager, team, customer if applicable)
7. **Remediation** - Execute fix (manual for P1, may be automated for P2/P3)
8. **Verification** - Confirm metrics return to normal, services functional
9. **Fix Validation Check:**
   - **NO:** Escalate further, restart investigation
   - **YES:** Proceed to closure
10. **Incident Closure** - Mark resolved in ticket system
11. **Post-Mortem** - Schedule within 48 hours; conduct blameless analysis
12. **Learning Documentation** - Record lessons for prevention

**SLA Targets:**

.. list-table::
   :header-rows: 1

   * - Severity
     - Response
     - Resolution
     - Post-Mortem
   * - P1
     - 5 min
     - 30 min
     - 48 hours
   * - P2
     - 15 min
     - 2 hours
     - 1 week
   * - P3
     - 1 hour
     - 8 hours
     - As needed

**Escalation Triggers:**
- Operator doesn't acknowledge within 15 minutes
- Acknowledgment but no progress within 30 minutes
- Severity escalates (initial assessment underestimated)

**Post-Mortem Topics:**
- What was the incident?
- What was the impact?
- What was the root cause?
- How did we detect it?
- What was the fix?
- How do we prevent recurrence?
- What should we monitor differently?

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Related Module:** ALERTS
