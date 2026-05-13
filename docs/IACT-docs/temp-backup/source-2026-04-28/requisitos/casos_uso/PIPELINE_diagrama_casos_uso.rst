====================================================
PIPELINE Module — Use Case Diagram
====================================================

:module: PIPELINE
:diagram_type: use-case
:color: COLOR_PIPELINE (#F59E0B)
:actors: Operator, DataService, PBX/IVR, CRM, ETL Engine
:created: 2026-04-26
:status: Production

Overview
========

The PIPELINE (Data Pipeline & Integration) module manages data ingestion, transformation, validation, routing, and archival from external systems (PBX/IVR, CRM, compliance).

Use Case Diagram
================

.. uml::

   @startuml pipeline_use_cases
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: use-case
   ' description: PIPELINE module data ingestion and integration use cases

   actor "Operator" as operator <<AGR_OPERADOR>>
   actor "DataService" as data_svc <<SISTEMA>>
   actor "PBX/IVR" as pbx <<Externo>>
   actor "CRM" as crm <<Externo>>

   usecase "Ingest\nData" as ingest
   usecase "Transform\nData" as transform
   usecase "Validate\nQuality" as validate
   usecase "Route\nData" as route
   usecase "Archive\nData" as archive
   usecase "Monitor\nPipeline" as monitor

   usecase "Parse\nFormat" as parse
   usecase "Normalize\nFields" as normalize
   usecase "Enrich\nData" as enrich
   usecase "Store\nWarehouse" as store

   pbx --> ingest
   crm --> ingest

   ingest --> parse: <<include>>
   transform --> normalize: <<include>>
   transform --> enrich: <<include>>

   ingest --> transform: <<include>>
   transform --> validate: <<include>>
   validate --> route: <<include>>
   route --> store: <<include>>
   store --> archive: <<include>>

   operator --> monitor

   note right of ingest
     Real-time ingestion
     from PBX and CRM systems
   end note

   note right of validate
     Data quality checks:
     completeness, accuracy,
     consistency
   end note

   @enduml

**Actors:**
- Operator: Monitors pipeline health
- DataService: Manages data flow
- PBX/IVR, CRM: External data sources

**Use Cases:**

1. **Ingest Data** - Receive and accept data from external systems (PBX/IVR call events, CRM interactions)
2. **Transform Data** - Parse format, normalize fields, enrich with reference data
3. **Validate Quality** - Check completeness, format, business rules compliance
4. **Route Data** - Direct to appropriate downstream systems (warehouse, analytics, reporting)
5. **Archive Data** - Store historical data for compliance and long-term retention
6. **Monitor Pipeline** - Track throughput, latency, error rates; alert on anomalies

**Constraints:**
- CNST-PIPELINE-001: Real-time ingestion; <2 second latency
- CNST-PIPELINE-002: Exactly-once delivery semantic; no duplicates
- CNST-PIPELINE-003: Failed records logged but do not block pipeline
- CNST-PIPELINE-004: Data retention: 1 year hot, 7 years archive

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Module Color:** COLOR_PIPELINE (#F59E0B)
