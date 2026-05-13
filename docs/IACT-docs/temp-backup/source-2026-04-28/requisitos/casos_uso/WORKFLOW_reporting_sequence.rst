====================================================
Report Generation Workflow — Sequence Diagram
====================================================

:module: requisitos
:diagram_type: sequence
:description: On-demand and scheduled report generation workflow
:created: 2026-04-26
:status: Production

Sequence Diagram
================

.. uml::

   @startuml reporting_workflow
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: sequence
   ' description: Report generation and delivery workflow

   participant "User/Scheduler" as user <<Frontend>>
   participant "Reporting\nService" as reports <<Service>>
   participant "Data\nWarehouse" as dw <<Database>>
   participant "Report\nFormatter" as formatter <<Backend>>
   participant "Email\nService" as email <<Backend>>
   participant "Report\nStore" as storage <<Database>>

   autonumber
   user -> reports: Request report\n{metrics, filters, time_period}
   reports -> dw: Query data\n{select metrics where filters}
   dw -> dw: Execute query\n(max 5min timeout)
   alt Query timeout or error
     dw --> reports: Error
     reports --> user: Error: Query failed
   else Query succeeded
     dw --> reports: Result set {rows}
     reports -> formatter: Format result\n{format=PDF/Excel/CSV}
     formatter -> formatter: Apply styling\nAdd charts\nCreate layout
     formatter --> reports: Formatted report
     reports -> storage: Store report\n{report_id, metadata}
     storage --> reports: Stored
     alt Scheduled report
       reports -> email: Send report\n{recipient, attachment}
       email -> email: Compose email\nAttach report
       email --> user: Email sent
     else On-demand report
       reports --> user: Download link\nOR\nDisplay in UI
     end
   end

   note over user,storage
     On-demand: <30sec response
     Scheduled: Defined frequency (daily, weekly, monthly)
   end note

---

**Workflow Steps:**
1. User requests report (on-demand) or Scheduler triggers (scheduled)
2. Reporting Service queries Data Warehouse
3. Warehouse executes complex query (may take minutes for large datasets)
4. Results returned to Reporting Service
5. Report Formatter applies styling, charts, and layout
6. Formatted report stored for archival/audit
7. Report delivered: Email (scheduled) or Download link (on-demand)

**Constraints:**
- Max query time: 5 minutes
- Max export rows: 1 million (pagination for larger)
- Report retention: 1 year
- Concurrent report executions: Max 50

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Related Module:** REPORTS
