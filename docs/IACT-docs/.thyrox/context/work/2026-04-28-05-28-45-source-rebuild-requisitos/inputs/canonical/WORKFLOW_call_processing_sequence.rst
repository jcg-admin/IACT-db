====================================================
Call Processing Workflow — Sequence Diagram
====================================================

:module: requisitos
:diagram_type: sequence
:description: PBX/IVR integration and call data processing through pipeline
:created: 2026-04-26
:status: Production

Overview
========

This sequence diagram shows how call events from PBX/IVR systems are ingested, processed, validated, and stored in the data warehouse for analytics and reporting.

Sequence Diagram
================

.. uml::

   @startuml call_processing
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: sequence
   ' description: Call processing from PBX ingestion through warehouse storage

   participant "PBX/IVR\nSystem" as pbx <<External>>
   participant "API\nEndpoint" as api <<Backend>>
   participant "Pipeline\nService" as pipe <<Service>>
   participant "Validation\nEngine" as validate <<Service>>
   participant "Data\nWarehouse" as dw <<Database>>

   autonumber
   pbx -> api: POST /ingest/call-event\n{ani, dnis, duration, timestamp}
   api -> pipe: Enqueue event
   pipe -> pipe: Parse & normalize format
   pipe -> pipe: Extract fields\n(ani, dnis, duration, date, time)
   pipe -> validate: Validate data quality
   validate -> validate: Check completeness\nCheck format\nCheck business rules
   alt Validation failed
     validate --> pipe: Error {reason}
     pipe -> pipe: Log error\nIncrement error counter
     pipe --> api: 400 Bad Request
   else Validation passed
     validate --> pipe: Valid
     pipe -> dw: INSERT call_event\n{ani, dnis, duration, date, timestamp}
     dw --> pipe: Inserted (id)
     pipe -> pipe: Mark processed\nIndex for search
     pipe --> api: 200 OK {event_id}
   end

   note over pbx,dw
     Real-time processing: <2 sec latency
     Each call creates 1 analytics record
   end note

   par Parallel Processing
     note right of pipe
       Immediate storage + indexing
       for <2sec latency requirement
     end note
   end

Processing Steps
================

1. PBX/IVR sends call event to IACT API endpoint
2. API enqueues event for pipeline processing
3. Pipeline service receives event from queue
4. Pipeline parses raw format and normalizes fields
5. Pipeline extracts key fields (ANI, DNIS, duration, timestamp)
6. Validation engine validates data quality:
   - Completeness: All required fields present
   - Format: ANI/DNIS valid phone numbers, duration numeric, timestamp valid ISO format
   - Business Rules: Duration > 0, timestamp not future, ANI ≠ DNIS
7. **Decision Point:** Validation passed?
   - **NO:** Log error, return 400, increment error counter
   - **YES:** Proceed to storage
8. Pipeline inserts validated record into Data Warehouse
9. Warehouse returns inserted record ID
10. Pipeline marks event as processed
11. API returns 200 OK with event ID

Error Handling
==============

- **Malformed Event:** Return 400 Bad Request; error logged for investigation
- **Validation Failure:** Event dropped, logged in error queue, ops alerted after 100 errors
- **Warehouse Down:** Event queued for retry (max 3 attempts); auto-backoff
- **Duplicate Event:** Detected by unique constraint (ANI+DNIS+timestamp); rejected with 409 Conflict

Performance SLA
===============

- **Ingestion Latency:** <200ms (receive to enqueue)
- **Processing Latency:** <2 seconds (enqueue to warehouse insert)
- **Throughput:** 1000+ events/second sustained
- **Availability:** 99.9% (target)

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Related Module:** PIPELINE
