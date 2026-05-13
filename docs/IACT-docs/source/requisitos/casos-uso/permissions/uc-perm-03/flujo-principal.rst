.. _uc-perm-03-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen del flujo
=====================

::

   PASO 1   Invoker abre form excepcional
            desde vista PERM                      (Frontend)
   PASO 2   Selecciona User + functions +
            expires_at + justification +
            ticket_reference                       (Frontend)
   PASO 3   Modal robusto con preview SoD          (Frontend)
   PASO 4   Confirma                                (Frontend)
   PASO 5   POST /api/users/{id}/
            exceptional-permissions/                (FE → BE)
   ── flujo backend identico a UC_ACC_08 ──
   PASO 6   Validar JWT +
            grant_exceptional_permission
   PASO 7   Validar User + funciones
   PASO 8   Validar P-11 anti-self
   PASO 9   Validar payload (justification +
            expires_at bounds)
   PASO 10  Filtrar idempotencia
   PASO 11  Validar SoD effective_post_grant
   PASO 12  INSERT ExceptionalPermission (N)
   PASO 13  Invalidar cache (post-COMMIT)
   PASO 14  INSERT InternalMessage OBLIGATORIO
   PASO 15  Emitir AuditEvent
            EXCEPTIONAL_PERMISSION_GRANTED
            (high-priority)
   PASO 16  201 Created con resumen + warnings    (BE → FE)

3.2 Diferencias de la vista PERM
================================

PASO 1 — Form desde vista PERM
------------------------------

Entrada desde vista de catalogo de funciones
o desde detalle del User en vista PERM.
Audiencia conoce el catalogo de funciones.

PASO 3 — Preview SoD
--------------------

Modal muestra:

- Funciones a otorgar (display_names).
- Conjunto efectivo resultante.
- Posibles violaciones SoD detectadas
  client-side (sin bloquear, solo info —
  el bloqueo es write-time).
- Warning de high-priority audit ("esta
  operacion sera auditada con visibilidad
  alta").

3.3 Atomicidad
==============

Identica a UC_ACC_08 (PASOS 12-15 atomicos +
mailbox HARD).
