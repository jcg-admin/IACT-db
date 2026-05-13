.. _uc-acc-09-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen del flujo
=====================

::

   PASO 1   Invoker abre vista de auditoria         (Frontend)
   PASO 2   Aplica filtros (event_type, actor,
            target, fecha, function_id)              (Frontend)
   PASO 3   GET /api/access/audit/?...               (FE → BE)
   PASO 4   Validar JWT (CNST-009)                   (Backend)
   PASO 5   Validar funcion view_access_audit        (Backend)
   PASO 6   Validar filtros (whitelist anti-SQLi)    (Backend)
   PASO 7   Construir query con filtros + ordering   (Backend)
   PASO 8   SELECT AuditEvent paginado               (Backend → BD)
   PASO 9   Aplicar mascarado PII (CNST-026)         (Backend)
   PASO 10  Audit selectivo P-16 si target_user_id   (Backend → BD)
   PASO 11  200 OK con resultados                    (BE → FE)
   PASO 12  Frontend renderiza tabla                  (Frontend)

3.2 Detalle clave
=================

PASO 6 — Validacion filtros (P-20)
----------------------------------

Whitelist:

- ``event_type`` ∈ catalogo conocido
  (FUNCTIONS_ASSIGNED, FUNCTIONS_REVOKED,
  AGR_ASSIGNED, SOD_RULE_CREATED, etc.).
- ``ordering`` whitelist
  (occurred_at, -occurred_at, event_type).

PASO 7 — Construir query
------------------------

::

   query = AuditEventRepository
             .where(event_type__in=
               ACCESS_EVENT_TYPES)
             .filter(filters)
             .order_by(ordering or
                       '-occurred_at')

Pre-filtro por
``event_type__in=ACCESS_EVENT_TYPES`` limita
el scope a eventos de MOD_Access (vs UC_AUD_*
que muestra todos).

PASO 8 — SELECT paginado
------------------------

Cursor-based pagination recomendado para
volumenes grandes (> 100k eventos).

PASO 9 — Mascarado PII (CNST-026)
---------------------------------

Aunque AuditEvent payload se diseno sin PII
(se valida en cada UC productor), el UC
agrega defensa secundaria: filtrar campos
``email``, ``full_name`` si por bug
historico aparecen.

PASO 10 — Audit P-16
--------------------

Si filtro incluye ``target_user_id``
especifico:

::

   AuditEvent.create(
     event_type='ACCESS_AUDIT_VIEWED',
     actor_user_id=invoker.id,
     payload={target_user_id, ...})

3.3 Sin atomicidad transaccional
================================

Lectura pura. Solo el AuditEvent P-16 es
escritura, en transaccion separada.
