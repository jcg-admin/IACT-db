.. _uc-rpt-11-parte-03:

==========================
Parte 3 — Flujo principal
==========================

3.1 Compartir
=============

PASO 1 — POST.
PASO 2 — JWT.
PASO 3 — RBAC ``share_reports``.
PASO 4 — Validar:

- view existe + owner == invoker
- target valido (user existe / AGR existe)
- target NO es el owner
- expires_at en futuro

PASO 5 — Crear ShareEntry.
PASO 6 — Audit ``REPORT_SHARED`` con
view_id + target.
PASO 7 — Mailbox notify a receptor(es)
con link de vista.
PASO 8 — Response 201.

3.2 Aplicar share
=================

Receptor invoca:

::

   GET /api/reports/{report_type}/?view_id=X

Backend:

- Verifica si view es propia (owner) →
  aplica.
- Si no, busca ShareEntry activo entre
  invoker y view → aplica con segmento
  DEL INVOKER (CNST-008).
- Sin share → 403.

3.3 Listar shares emitidos
==========================

GET /api/me/shares/sent/.

3.4 Listar shares recibidos
===========================

GET /api/me/shares/received/.

3.5 Revocar share
=================

DELETE /api/me/shares/{share_id}/.
Audit ``REPORT_SHARE_REVOKED``.

3.6 Resumen
===========

.. list-table::
 :widths: 8 50 22 20

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1-3
   - POST + JWT + RBAC
   - Endpoint
   - 009
 * - 4
   - Validar
   - Validator
   - —
 * - 5
   - INSERT
   - Repo
   - —
 * - 6
   - Audit
   - UC_PERM_09
   - 025
 * - 7
   - Mailbox
   - MailboxService
   - 002
 * - 8
   - 201
   - View
   - —
