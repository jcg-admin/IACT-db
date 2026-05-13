.. _uc-rpt-08-parte-03:

==========================
Parte 3 — Flujo principal
==========================

3.1 List
========

PASO 1 — GET con filtros opcionales.
PASO 2 — JWT.
PASO 3 — RBAC ``view_scheduled_reports``.
PASO 4 — Query ScheduledReportRepo
filtrado por actor_id (caller).
PASO 5 — Aplicar filtros (status,
frequency).
PASO 6 — Paginar.
PASO 7 — Response 200.

3.2 Detalle
===========

GET /scheduled/{id}/.
Auth + RBAC. Verificar ownership o scope.
Cargar ScheduledReport + ultima ejecucion.
Response.

3.3 Historico de ejecuciones
============================

GET /scheduled/{id}/runs/?page=1.
Cargar ScheduleExecutionLog (30 dias).
Response paginado.

3.4 Resumen
===========

.. list-table::
 :widths: 8 50 22 20

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1-3
   - GET + JWT + RBAC
   - Endpoint
   - 009
 * - 4
   - Query
   - Repo
   - 008
 * - 5-6
   - Filtrar/paginar
   - Service
   - —
 * - 7
   - 200
   - View
   - —
