.. meta::
 :artefacto: INDEX_BUSINESS_REQUIREMENTS
 :tipo: Indice
 :dominio: requisitos
 :subdominio: business-requirements
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Interno

==============================
Business Requirements (BReq)
==============================

Esta sección contiene los **Business Requirements (BReq)** del
proyecto IACT — el **nivel 2** de la jerarquía de requisitos
canónica del proyecto per
:doc:`/normativa/gobernanza/adr-gob-003-jerarquia-requerimientos-5-niveles`.

Los BReq representan **objetivos de negocio de alto nivel** que
el sistema debe satisfacer.

Diferencia BReq vs BR
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Tipo
   - Descripción
 * - **BReq** (este cajón)
   - Objetivo de negocio nivel 2. Abstracto, estratégico,
     medible. Deriva en BR + UC.
 * - **BR** (Business Rule)
   - Regla operativa nivel 1. Concreta, externa al sistema.
     Vive en :doc:`/requisitos/reglas-negocio/index`.

Catálogo de BReq (8 objetivos)
==============================

Distribución por categoría (per
:doc:`/normativa/procedimientos/proc-req-001-generacion-breq` § 3):

.. list-table::
 :widths: 25 15 60
 :header-rows: 1

 * - Categoría
   - BReqs
   - Foco
 * - Funcionalidad Core
   - 001, 002, 003
   - Visibilidad, alertas, decisiones
 * - Seguridad
   - 004, 005
   - RBAC + auditoría + integridad de datos
 * - Rendimiento
   - 006
   - Disponibilidad operativa + SLA
 * - Integración
   - 007, 008
   - ETL IVR + comunicaciones internas

.. toctree::
 :maxdepth: 1
 :caption: Catálogo

 breq-001-visibilidad-metricas
 breq-002-reduccion-tiempo-incidentes
 breq-003-decisiones-basadas-datos
 breq-004-cumplimiento-seguridad-auditoria
 breq-005-integridad-trazabilidad-datos
 breq-006-operacion-continua-sla
 breq-007-integracion-ivr-operacional
 breq-008-comunicaciones-internas-controladas

Tabla de mapping BRQ legacy → BReq canónico
===========================================

Durante la generación inicial de UCs (v4.0.0 monolíticos), se
introdujo un identificador legacy ``BRQ-{cluster}-NNN`` que NO
está documentado en la metodología canónica. Esta tabla mapea
cada BRQ legacy al BReq canónico que satisface, sin necesidad
de reescribir las referencias en los UCs.

Decisión registrada en el WP
``2026-05-01-15-44-20-metodologia-base-cognitiva-mapeo`` —
DEC-03.

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - BRQ legacy (en UCs)
   - BReq canónico
   - Justificación
 * - BRQ-AUTH-001..005
   - BReq-004
   - Autenticación es parte del cumplimiento de seguridad
 * - BRQ-USR-001..009
   - BReq-004
   - Gestión de usuarios sustenta el control de acceso
 * - BRQ-ACC-001..009
   - BReq-004
   - Permisos / RBAC son parte del cumplimiento de seguridad
 * - BRQ-RPT-001..017
   - BReq-001 + BReq-003
   - Visibilidad y decisiones basadas en datos
 * - BRQ-ALR-001..006
   - BReq-002
   - Alertas operativas reducen tiempo de resolución
 * - BRQ-PIP-001..004
   - BReq-005 + BReq-007
   - ETL preserva integridad y desacopla del IVR
 * - BRQ-AUD-001..004
   - BReq-004
   - Auditoría es parte del cumplimiento de seguridad
 * - BRQ-LOG-001..007
   - BReq-006
   - Bitácoras sustentan operación continua
 * - PERM cluster (PRIORIDAD/RNF/N)
   - (pendiente)
   - Cluster fuera de scope — WP futuro
     ``perm-cluster-traceability-normalization``

Convención
==========

**Naming canónico de BReq:**

- ID en metadata: ``BReq-NNN`` (con guión, NNN de 3 dígitos)
- Nombre de archivo: ``breq-nnn-{descripcion-kebab}.rst``
- Sin sufijo de módulo

per
:doc:`/normativa/estandares/std-007-convencion-naming` y
:doc:`/normativa/estandares/std-008-naming-identificadores`.

**Plantilla aplicable:**
:doc:`/normativa/estandares/plantillas/tpl-breq-objetivos-negocio`.

**Procedimientos:**

- Generación:
  :doc:`/normativa/procedimientos/proc-req-001-generacion-breq`
- Derivación BReq → BR:
  :doc:`/normativa/procedimientos/proc-req-002-derivacion-breq-br`
- Trazabilidad:
  :doc:`/normativa/procedimientos/proc-req-019-trazabilidad-requisitos`

**Skill guía**: ``ba-elicitation`` (BABOK).

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ADR origen**
   - :doc:`/normativa/gobernanza/adr-gob-003-jerarquia-requerimientos-5-niveles`
 * - **Nivel jerárquico**
   - 2 (intermedio — entre BR y UC)
 * - **Deriva en**
   - BR (reglas-negocio/), UC (casos-uso/), FR (requisitos-funcionales/)
 * - **Influenciado por**
   - BR (Nivel 1) según FND_05 § 3.3
