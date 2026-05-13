.. _uc-perm-10-parte-03:

==========================
Parte 3 — Flujo principal
==========================

3.1 Pasos (modo list)
=====================

**PASO 1 — Recepcion**

::

   GET /api/audit-events/?actor_id=X
       &event_type=AGR_REVOKED
       &date_from=...&date_to=...
       &page_size=50

**PASO 2 — Auth**

JWT valido (CNST-009).

**PASO 3 — RBAC**

``view_audit_log``. Falla → 403 +
UNAUTHORIZED audit.

**PASO 4 — Validar filtros**

- date range coherente (from < to).
- date range ≤ 90 dias (online).
- page_size ≤ 200.
- event_type en enum.

**PASO 5 — Query AuditRepo (read replica)**

Construir query con filtros + cursor +
page_size + 1 (para detectar next).

**PASO 6 — Sanitizar response**

- Truncar payload a snippet (≤ 500 char)
  con elipsis.
- Asegurar 0 PII en snippets (ya
  enforzado por UC_PERM_09 al escribir,
  pero defensa en profundidad).

**PASO 7 — Construir cursor**

Cursor opaco que codifica
``(created_at, id)`` del ultimo evento.
Permite paginacion estable.

**PASO 8 — Estimar total**

NO COUNT (caro). En su lugar: estimacion
basada en estadisticas de la BD o limite
de busqueda.

**PASO 9 — Meta-audit (P-44)**

Antes de devolver response, emitir
``AUDIT_LOG_QUERIED`` via UC_PERM_09:

::

   payload: {
     filters: { ... no PII ... },
     page_size,
     row_count_returned,
     query_id: response.query_id
   }

**PASO 10 — Respuesta 200**

Con events + cursor + estimated_total +
query_id.

3.2 Sub-flujo: detalle
======================

GET ``/api/audit-events/{id}``.

PASO 1-3 igual.
PASO 4: validar UUID.
PASO 5: AuditRepo.get(id). 404 si no existe.
PASO 6: Response con AuditEvent completo
(payload sin truncar — auditor lo necesita).
PASO 9: AUDIT_LOG_DETAIL_VIEWED emitido.

3.3 Sub-flujo: aggregate
========================

POST/GET ``/api/audit-events/aggregate/``.

PASO 4: validar group_by, period.
PASO 5: query agregada (counts por
event_type / actor / dia / ...).
PASO 9: AUDIT_LOG_AGGREGATE_QUERIED.

3.4 Sub-flujo: export
=====================

POST ``/api/audit-events/export/``.

PASO 4: validar filtros + format +
include_archive.
PASO 5: encolar job en ExportWorker. NO
ejecuta sync (puede ser GBs).
PASO 9: AUDIT_LOG_EXPORT_QUEUED con
filtros.
PASO 10: 202 Accepted con job_id.

3.5 Resumen
===========

.. list-table::
 :widths: 8 50 22 20
 :header-rows: 1

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1
   - GET con filtros
   - View
   - —
 * - 2
   - JWT
   - Middleware
   - 009
 * - 3
   - RBAC view_audit_log
   - Guard
   - —
 * - 4
   - Validar filtros
   - PayloadValidator
   - —
 * - 5
   - Query repo
   - AuditRepo
   - —
 * - 6
   - Sanitizar
   - Sanitizer
   - 026
 * - 7
   - Cursor
   - CursorEncoder
   - —
 * - 8
   - Estimar total
   - Repo
   - —
 * - 9
   - Meta-audit
   - UC_PERM_09
   - 025
 * - 10
   - Response 200
   - View
   - —
