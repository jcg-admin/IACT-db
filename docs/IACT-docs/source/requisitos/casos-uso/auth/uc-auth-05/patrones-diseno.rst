.. _uc-auth-05-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF aplicables
============================

10.1.1 Repository / DAO
-----------------------

**Aplica a**: ``SessionRepository`` abstrae el
acceso a Session: filtros, paginacion, cierre.

::

   class SessionRepository:
       def list_active(self, filters, page, page_size): ...
       def get(self, session_id): ...
       def close(self, session_id, admin, reason): ...
       def close_all_for_user(self, user_id, admin): ...

10.1.2 Strategy
---------------

**Aplica a**: politica de notificacion al User
(InternalMessage o no) — ``NotifyOnClose
Strategy`` injectable.

10.1.3 Specification
--------------------

**Aplica a**: filtros del listado componibles
(state + user_id + ip_like + ...).

10.1.4 Observer
---------------

**Aplica a**: AuditEvent + UC_ALR_*

10.1.5 Chain of Responsibility
------------------------------

**Aplica a**: pipeline DRF
authentication → permission(view_all)
→ permission(close) por endpoint, → throttle.

10.2 Patrones IACT especificos
==============================

10.2.1 P-02 Idempotencia por estado terminal
--------------------------------------------

FA-02 — cerrar lo ya cerrado es no-op +
SESSION_CLOSE_NOOP.

10.2.2 P-08 Fail-closed en transacciones criticas
-------------------------------------------------

Cierre individual y masivo son atomicos. Si
una etapa falla, ROLLBACK completo.

10.2.3 P-09 Audit-or-abort
--------------------------

EX-08 — sin AuditEvent no se permite el
cierre.

10.2.4 P-11 Anti-self-action
----------------------------

EX-04 auto-bulk-close. Permitido cierre
INDIVIDUAL de la propia sesion (eso es
UC_AUTH_02). Pero el bulk masivo de todas las
del propio admin esta prohibido por defecto
para evitar lockout accidental.

10.2.5 P-15 RBAC granular (lectura vs accion)
---------------------------------------------

``view_all_active_sessions`` separado de
``close_user_session``. Auditor puede tener
solo lectura. Admin operacional puede tener
ambas. Esta granularidad permite enforcing
de menor privilegio.

10.2.6 P-16 Auditoria selectiva en lectura
------------------------------------------

Decisiones:

- Lecturas amplias: NO se audita cada GET
  list (volumen alto).
- Lecturas focalizadas (por user_id): SI se
  auditan (SESSIONS_VIEWED_FOR_USER) — son
  investigaciones especificas.

Trade-off: balance entre volumen de audit log
y trazabilidad de investigaciones.

10.3 Anti-patrones evitados
===========================

10.3.1 Bulk close sin rollback
------------------------------

**No aplica**: si el bulk procesa N Sessions y
falla en la N/2, las primeras N/2-1 quedan
cerradas pero las ultimas no — estado
parcial que confunde al admin. Atomicidad
total resuelve.

10.3.2 Permitir auto-bulk-close por default
-------------------------------------------

**No aplica**: EX-04 default. Si el admin se
cierra todas sus sesiones, queda lockout
inmediato.

10.3.3 Listado sin paginacion
-----------------------------

**No aplica**: 250+ Sessions concurrentes
sin paginacion = response > 100KB y P99
degradado.

10.3.4 Mostrar email/full_name en listado
-----------------------------------------

**No aplica**: CNST-026 — sin PII en payload.
``username`` es identificador no-PII.

10.4 Resumen
============

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - Repository
   - GoF
   - SessionRepository
 * - Strategy
   - GoF
   - NotifyOnClose
 * - Specification
   - GoF
   - Filtros componibles
 * - Observer
   - GoF
   - AuditEvent
 * - Chain of Responsibility
   - GoF
   - DRF middleware
 * - P-02 Idempotencia
   - IACT
   - FA-02
 * - P-08 Fail-closed
   - IACT
   - Transacciones
 * - P-09 Audit-or-abort
   - IACT
   - EX-08
 * - P-11 Anti-self-action
   - IACT
   - EX-04
 * - P-15 RBAC granular
   - IACT
   - view vs close
 * - P-16 Audit selectivo
   - IACT
   - SESSIONS_VIEWED_FOR_USER
