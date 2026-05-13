.. _uc-perm-10-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Metrica
   - Target
   - Notas
 * - List P50
   - ≤ 100 ms
   - filtros indexados
 * - List P95
   - ≤ 500 ms
   - filtros menos
     selectivos
 * - Detalle
   - ≤ 50 ms
   - online
 * - Detalle archive
   - ≤ 5 s
   - acceso a partition
 * - Aggregate
   - ≤ 2 s
   - hasta 100K rows
 * - Export start
   - ≤ 200 ms
   - solo encolar
 * - Export job (1M rows)
   - ≤ 30 min
   - background

6.2 Confiabilidad
=================

- Read replicas (la query no afecta write).
- Disponibilidad ≥ 99.9%.
- ExportWorker pool con autoscaling.

6.3 Seguridad
=============

- ``view_audit_log`` solo en AGRs
  predefinidos auditor (AGR-009) y daily
  audit (AGR-008) o concesion temporal.
- Otorgar la funcion fuera de esos AGRs
  requiere ADR.
- Meta-audit obligatorio.
- URLs de export firmadas, TTL 24h.

6.4 Auditabilidad
=================

- TODA invocacion audita
  AUDIT_LOG_QUERIED / DETAIL_VIEWED /
  AGGREGATE_QUERIED / EXPORT_QUEUED /
  EXPORT_COMPLETED.
- Volumen anomalo en consultas (> 100/h
  por User) dispara alerta.

6.5 Usabilidad
==============

- Cursor-based UX claro: hay "siguiente"
  hasta que next_cursor=null.
- Filtros guardables (UI feature).
- Detalle expandible inline.

6.6 Mantenibilidad
==================

- Indices revisados periodicamente segun
  patrones de query.
- Particionamiento mensual habilita
  archive sin reescribir codigo.

6.7 Cumplimiento
================

- Retencion online 90 dias, archive 7
  anos.
- Export disponible para auditorías
  externas con scope acotado.
- Eventos firmados (HMAC opcional)
  validables por consumidor externo.
