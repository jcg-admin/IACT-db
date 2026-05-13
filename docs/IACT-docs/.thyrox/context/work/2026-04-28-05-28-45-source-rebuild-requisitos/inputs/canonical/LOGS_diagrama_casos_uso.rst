====================================================
LOGS Module — Use Case Diagram
====================================================

:module: LOGS
:diagram_type: use-case
:color: COLOR_LOGS (#64748B)
:actors: DevOps, Operator, LogService, Monitoring Dashboard
:created: 2026-04-26
:status: Production

Overview
========

The LOGS (Logging & Monitoring) module captures operational logs from all IACT components, provides real-time monitoring, alerting on patterns, and enables root cause analysis.

Use Case Diagram
================

.. uml::

   @startuml logs_use_cases
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: use-case
   ' description: LOGS module logging and monitoring use cases

   actor "DevOps" as devops <<AGR_OPERADOR>>
   actor "Operator" as operator <<AGR_OPERADOR>>
   actor "LogService" as log_svc <<SISTEMA>>

   usecase "Collect\nLogs" as collect_logs
   usecase "Parse\nLogs" as parse_logs
   usecase "Store\nLogs" as store_logs
   usecase "Search\nLogs" as search_logs
   usecase "Alert on\nPattern" as alert_pattern
   usecase "View\nDashboard" as view_dashboard

   usecase "Index\nLogs" as index_logs
   usecase "Correlate\nEvents" as correlate

   collect_logs --> parse_logs: <<include>>
   parse_logs --> index_logs: <<include>>
   index_logs --> store_logs: <<include>>

   store_logs --> search_logs: <<include>>
   store_logs --> alert_pattern: <<include>>

   alert_pattern --> correlate: <<include>>

   operator --> view_dashboard
   operator --> search_logs

   devops --> parse_logs
   devops --> alert_pattern

   note right of collect_logs
     Real-time log ingestion
     from all system components
   end note

   note right of alert_pattern
     Detect error patterns,
     anomalies, security events
   end note

   @enduml

**Actors:**
- DevOps: Configures logging, sets up alerts on patterns
- Operator: Monitors dashboard, searches logs for troubleshooting
- LogService: Collects, parses, and stores logs

**Use Cases:**

1. **Collect Logs** - Ingest operational logs from all IACT components (API, workers, services)
2. **Parse Logs** - Extract structured data from log lines (timestamp, level, component, message)
3. **Store Logs** - Persist logs in searchable database with retention policy
4. **Search Logs** - Query logs by component, level, time range, keywords
5. **Alert on Pattern** - Detect and alert on error patterns, anomalies, security events
6. **View Dashboard** - Display real-time log statistics, error rates, throughput

**Constraints:**
- CNST-LOGS-001: Log ingestion latency <500ms end-to-end
- CNST-LOGS-002: Retention: 30 days hot, 1 year cold archive
- CNST-LOGS-003: Max 1M log entries per second sustained throughput
- CNST-LOGS-004: Search queries timeout after 30 seconds

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Module Color:** COLOR_LOGS (#64748B)
