.. _uc-perm-10-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Date range > 90 dias
===============================

Caller pide rango > 90 dias.

Comportamiento:

- Si include_archive=false (default) → 400
  con mensaje "use export with archive
  flag".
- Si include_archive=true → query atrasado
  via ExportWorker (async).

4.2 FA-02: Cursor invalido o expirado
=====================================

Cursor opaco corrupto o > 24h. → 400
``CURSOR_INVALID``. Caller debe re-iniciar
paginacion.

4.3 FA-03: Auditor con scope segmento
=====================================

User tiene ``view_audit_log`` con condition
``module IN [MOD_X, MOD_Y]``. Query
implicitamente filtrada — NO retorna
events de otros modulos.

4.4 FA-04: Aggregate masivo
===========================

group_by=actor_id sin date filter →
potencialmente millones de filas.
Comportamiento: limite hard de 100K rows
analizadas; si excede, sugerir export +
ofrecer top N solo.

4.5 FA-05: Export job
=====================

ExportWorker procesa filtros y produce CSV /
JSON.

- Job estado: queued → running → done /
  failed.
- Notificacion via internal mailbox cuando
  done (CNST-002).
- Archivo download via URL firmada con
  TTL 24h.
- Eventos AUDIT_LOG_EXPORT_COMPLETED con
  byte_count + row_count.

4.6 FA-06: Detalle de evento archivado
======================================

ID corresponde a evento > 90 dias (en
archive). Repo automatically queries
archive partition. Latencia mayor (P95
~5s).

4.7 FA-07: Detalle no existe
============================

ID no encontrado en online ni archive →
404 ``AUDIT_EVENT_NOT_FOUND``.

4.8 FA-08: Filtro text_search en payload
========================================

Limitado a casos especificos por costo.

- Si filtros + date range estrechos →
  permitir.
- Sin filtros + sin date range →
  rechazado 400.

4.9 FA-09: Vista mobile
=======================

Frontend mobile request ``page_size=20``,
campos compactos. La vista UI puede
excluir payload completo en list (solo
detalle on demand). Comportamiento del
backend identico.

4.10 Resumen
============

.. list-table::
 :widths: 12 38 30 20
 :header-rows: 1

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Range > 90 dias
   - sugiere export
   - online vs archive
 * - FA-02
   - Cursor invalido
   - 400
   - re-iniciar
 * - FA-03
   - Scope segmento
   - filtro implicito
   - condition
 * - FA-04
   - Aggregate masivo
   - top N
   - cost limit
 * - FA-05
   - Export job
   - async + mailbox
   - URL firmada
 * - FA-06
   - Detalle archive
   - latencia mayor
   - particion
 * - FA-07
   - Detalle no existe
   - 404
   - online + archive
 * - FA-08
   - text_search
   - cost-bounded
   - filtros + date req
 * - FA-09
   - Mobile
   - page_size 20
   - sin payload list
