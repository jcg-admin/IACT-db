.. _uc-usr-02-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **GET listado P50**
   - ≤ 150 ms (50 items/pagina, indices activos)
 * - **GET listado P99**
   - ≤ 400 ms
 * - **GET detalle P50**
   - ≤ 100 ms
 * - **Throughput**
   - ≥ 100 GET req/seg

6.2 Seguridad
=============

- HTTPS, JWT (CNST-009).
- RBAC granular (``list_users`` vs ``view_users``).
- Filtros validados en whitelist (anti-SQLi).
- Restriccion de campos sensibles (CNST-026):
  no PII directa en listado, mascarado en
  detalle segun politica.
- Throttling 150/min/invocante (CNST-011).

6.3 Confiabilidad
=================

- Lectura idempotente.
- Sin estado mutable, sin transacciones
  destructivas.
- Tolerancia a alta concurrencia.

6.4 Auditabilidad
=================

- Append-only AuditEvent (CNST-025).
- **Audit selectivo P-16**: NO se audita cada
  GET de listado amplio (volumen alto, baja
  relevancia). SI se audita listado focalizado
  (filter user_id) y detalle individual.

6.5 Usabilidad
==============

- Tabla con filtros: state, AGR, fecha rango,
  busqueda fuzzy.
- Paginacion 50/pagina default, hasta 200.
- Ordenamiento por columna (clic en header).
- Detalle expandible (no abre nueva pagina).
- Indicador de User propio (badge "TU").
- Indicador de User inactivo / bloqueado.

6.6 Mantenibilidad
==================

- Logging estructurado (correlation_id).
- Counter ``users.list.{requests, by_filter}``,
  ``users.detail.{requests, not_found,
  unauthorized}``.
- Alerta EX-02/EX-03 (UNAUTHORIZED) escalada
  baja-media.

6.7 Escalabilidad
=================

- Indices apropiados:

  - ``(state, created_at)``
  - ``email``
  - ``username``
  - ``last_login_at``

- Paginacion con cursor o offset (segun
  volumen). Para volumenes > 10k Users,
  recomendar cursor-based pagination.
