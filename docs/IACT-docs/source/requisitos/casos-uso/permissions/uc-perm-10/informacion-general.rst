.. _uc-perm-10-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - UC_PERM_10
 * - **Nombre**
   - Consultar Auditoria de Permisos
 * - **Categoria**
   - Compliance / investigation
 * - **Modulo**
   - MOD_Permissions
 * - **BReq**
   - BReq-004
 * - **Funcion RBAC**
   - ``view_audit_log``
 * - **Criticidad**
   - Importante (compliance)

1.2 Proposito
=============

Permitir a auditores y soporte tecnico:

- Investigar incidentes (quien hizo que,
  cuando, desde donde).
- Demostrar trazabilidad a auditorías
  externas.
- Detectar patrones anomalos (denials,
  intentos repetidos, criticos fuera de
  horario).
- Revisar histórico de cambios de
  permisos.

1.3 Modos de consulta
=====================

(a) **Listado paginado con filtros**:

::

   GET /api/audit-events/

Filtros: actor_id, event_type, target_type,
target_id, date_range, ip_address, module.

(b) **Detalle de un evento**:

::

   GET /api/audit-events/{id}/

(c) **Agregaciones** (counts por
event_type, top denials, etc.):

::

   GET /api/audit-events/aggregate/

(d) **Export** (CSV / JSON):

::

   POST /api/audit-events/export/

Async — genera archivo en background con
limit + retencion definidos.

1.4 Filtros soportados
======================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Filtro
   - Tipo
 * - actor_id
   - exact match
 * - event_type
   - in list
 * - target_type
   - exact
 * - target_id
   - exact
 * - module
   - in list
 * - date_from / date_to
   - date range UTC
 * - ip_address
   - exact / CIDR
 * - request_id
   - exact (correlacion)
 * - has_payload_field
   - exists check
 * - text_search
   - en payload (limitado)

1.5 Paginacion y limites
========================

- Page size default 50, max 200.
- Cursor-based (no offset) para evitar
  inconsistencias en tablas grandes.
- Resultado total **estimado** (no exacto)
  para evitar COUNT pesado.
- Hard limit: respuesta paginada cubre como
  maximo 90 dias online; rangos mayores
  van a archive query.

1.6 Restricciones canonicas
===========================

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - CNST
   - Aplicacion
 * - **CNST-008**
   - segmento NO aplica (auditor ve
     todo lo que su scope autoriza)
     pero ``view_audit_log`` puede
     restringirse a un segmento via
     condition (auditores de segmento)
 * - **CNST-009**
   - JWT
 * - **CNST-013**
   - Excepciones estandar
 * - **CNST-025**
   - inmutable: no UPDATE/DELETE
 * - **CNST-026**
   - sin PII en respuesta

1.7 Audit del audit (meta-audit)
================================

P-44 visibility audit prio: cada consulta a
``view_audit_log`` se audita (UC_PERM_09)
con event_type ``AUDIT_LOG_QUERIED``,
incluyendo filtros usados, count de rows
retornados.

Razón: el auditor mismo debe ser auditable
para integrity de compliance.

1.8 Out of scope
================

- Modificar AuditEvents (CNST-025: nunca).
- Eliminar AuditEvents (CNST-025: nunca).
- Generar alertas (UC_ALR_*).
- Aging / archival (UC_LOG_*).
- Audit de acciones operacionales no de
  permisos (UC_LOG_*).
