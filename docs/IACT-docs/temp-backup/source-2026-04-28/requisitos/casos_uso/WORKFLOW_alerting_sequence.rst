====================================================
Alerting Workflow — Sequence Diagram
====================================================

:module: requisitos
:diagram_type: sequence
:description: Alert detection, routing, and escalation workflow
:created: 2026-04-26
:status: Production

Sequence Diagram
================

.. uml::

   @startuml alerting_workflow
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: sequence
   ' description: Alert detection, routing, notification, and escalation

   participant "Monitoring\nSystem" as monitor <<Backend>>
   participant "Alert\nService" as alerts <<Service>>
   participant "Rule\nEngine" as rules <<Backend>>
   participant "Notification\nEngine" as notif <<Backend>>
   participant "Escalation\nQueue" as esc <<Database>>

   autonumber
   monitor -> alerts: Metric event\n{metric, value, timestamp}
   alerts -> rules: Evaluate rule\n{rule_id, metric, threshold}
   rules -> rules: Check condition\n(value > threshold?)
   alt Condition NOT matched
     rules --> alerts: No action
   else Condition matched
     rules --> alerts: Create alert
     alerts -> alerts: Deduplicate\n(same condition, 5min window?)
     alt Duplicate found
       alerts -> alerts: Update existing alert
     else New alert
       alerts -> notif: Create notification
       notif -> notif: Format message\nSelect channel
       notif -> notif: Send (Email/SMS/Slack)
       alerts -> esc: Queue for escalation\nwith SLA timer
       esc --> alerts: Queued (ack_deadline = now + SLA)
       notif --> alerts: Notification sent
       alerts --> monitor: Alert created {id}
       par Escalation tracking
         esc -> esc: Monitor SLA timeout
         note right of esc
           P1: 15 min
           P2: 1 hour
           P3: 4 hours
         end note
       end
     end
   end

   note over monitor,esc
     Alert-to-notification: <30 sec
     Escalation: Automatic if not acknowledged within SLA
   end note

---

**Workflow Steps:**
1. Monitoring system detects metric event (e.g., CPU >90%)
2. Alert Service evaluates configured rules
3. Rule Engine checks if condition matches threshold
4. **Decision:** Condition matched?

   - NO: No action, continue monitoring
   - YES: Create alert, proceed

5. **Deduplication:** Is this the same condition within 5 minutes?
   - YES: Update existing alert
   - NO: Create new alert
6. Notification Engine formats alert and sends via configured channel (email, SMS, Slack)
7. Alert queued for escalation tracking with SLA timer
8. If operator doesn't acknowledge within SLA, auto-escalate to supervisor

**Error Handling:**
- Notification channel down: Fallback to email; log error; retry
- Rule engine unavailable: Queue event for later evaluation
- Escalation timeout: Auto-escalate even if no channel response

**Performance SLA:**
- Metric event to alert creation: <10 seconds
- Alert creation to notification: <30 seconds
- Escalation auto-trigger: On SLA timeout (15min/1hr/4hr)

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Related Module:** ALERTS
