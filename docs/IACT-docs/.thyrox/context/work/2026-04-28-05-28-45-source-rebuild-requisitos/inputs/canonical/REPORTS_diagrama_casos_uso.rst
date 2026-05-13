====================================================
REPORTS Module — Use Case Diagram
====================================================

:module: REPORTS
:diagram_type: use-case
:color: COLOR_REPORTS (#10B981)
:actors: Analyst, Supervisor, Client, ReportingService, DataWarehouse
:created: 2026-04-26
:status: Production

Overview
========

The REPORTS (Analytics & Reporting) module enables ad-hoc and scheduled report generation, dashboard creation, data export, and sharing of insights across IACT stakeholders.

Use Case Diagram
================

.. uml::

   @startuml reports_use_cases
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: use-case
   ' description: REPORTS module analytics and reporting use cases

   actor "Analyst" as analyst <<AGR_OPERADOR>>
   actor "Supervisor" as supervisor <<AGR_OPERADOR>>
   actor "Client" as client <<Usuario>>
   actor "ReportingService" as rep_svc <<SISTEMA>>

   usecase "Generate\nReport" as gen_report
   usecase "Schedule\nReport" as schedule
   usecase "Export\nData" as export_data
   usecase "Create\nDashboard" as create_dash
   usecase "Share\nReport" as share
   usecase "View\nReport" as view_report

   usecase "Query\nData" as query_data
   usecase "Format\nOutput" as format_output
   usecase "Apply\nFilters" as apply_filters

   analyst --> gen_report
   analyst --> create_dash
   supervisor --> schedule

   client --> view_report
   client --> export_data

   gen_report --> query_data: <<include>>
   gen_report --> apply_filters: <<include>>
   gen_report --> format_output: <<include>>

   create_dash --> query_data: <<include>>

   view_report --> gen_report: <<include>>
   share --> view_report: <<include>>

   note right of gen_report
     Ad-hoc report creation
     with custom filters
   end note

   note right of schedule
     Automated reports
     on defined schedule
   end note

   @enduml

**Actors:**
- Analyst: Creates reports, builds dashboards
- Supervisor: Manages report schedules, approves exports
- Client: Views reports, exports data
- ReportingService: Executes queries and formats results

**Use Cases:**

1. **Generate Report** - Create on-demand report with selected metrics, filters, time period
2. **Schedule Report** - Configure recurring report (daily, weekly, monthly) with email delivery
3. **Export Data** - Download report data in CSV, Excel, or JSON format
4. **Create Dashboard** - Build visual dashboard with widgets/charts for real-time monitoring
5. **Share Report** - Grant access to other users (via email, link, group assignment)
6. **View Report** - Display report in web UI with interactive visualizations

**Constraints:**
- CNST-REPORTS-001: Query timeout 5 minutes; return partial results if exceeded
- CNST-REPORTS-002: Max 1 million rows per export; pagination for larger results
- CNST-REPORTS-003: Scheduled reports max 50 concurrent executions
- CNST-REPORTS-004: Report history retained 1 year

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Module Color:** COLOR_REPORTS (#10B981)
