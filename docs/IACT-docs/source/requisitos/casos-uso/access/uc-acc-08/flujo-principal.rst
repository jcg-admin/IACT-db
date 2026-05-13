.. _uc-acc-08-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen del flujo
=====================

::

   PASO 1   Invoker abre form de excepcional      (Frontend)
   PASO 2   Selecciona User + funciones +
            expires_at + justification             (Frontend)
   PASO 3   Modal robusto + confirma                (Frontend)
   PASO 4   POST /api/users/{user_id}/
            exceptional-permissions/                (FE → BE)
   PASO 5   Validar JWT (CNST-009)                  (Backend)
   PASO 6   Validar funcion
            grant_exceptional_permission            (Backend)
   PASO 7   Validar User destino                    (Backend → BD)
   PASO 8   Validar P-11 anti-self                  (Backend)
   PASO 9   Validar payload (justification +
            expires_at bounds)                       (Backend)
   PASO 10  Validar funciones (existen + ACTIVE)    (Backend → BD)
   PASO 11  Filtrar idempotencia (ya granted
            ACTIVE no expirado)                      (Backend → BD)
   PASO 12  Validar SoD del set efectivo
            resultante                               (Backend → BD)
   PASO 13  INSERT ExceptionalPermissions            (Backend → BD)
   PASO 14  Invalidar cache (post-COMMIT)            (Backend)
   PASO 15  INSERT InternalMessage OBLIGATORIO       (Backend → BD)
   PASO 16  Emitir AuditEvent
            EXCEPTIONAL_PERMISSION_GRANTED           (Backend → BD)
   PASO 17  201 Created con resumen                  (BE → FE)

3.2 Detalle clave
=================

PASO 9 — Validacion payload
---------------------------

::

   require justification != ""
     and len(justification) >= 20
   require expires_at > NOW() + 1h
   require expires_at <= NOW() + 30 dias
     # (politica MAX_EXCEPTIONAL_DURATION)
   require len(function_ids) <= 10
     # politica MAX_EXCEPTIONAL_FUNCTIONS

PASO 12 — SoD validation
------------------------

Identica a UC_ACC_01: construir
``effective_post_grant`` (current effective
∪ exceptional functions nuevas), evaluar
SoDRules ACTIVE, all-or-nothing si viola.

PASO 15 — InternalMessage OBLIGATORIO
-------------------------------------

A diferencia de UC_USR_04 (mailbox-or-abort
softer), aqui el mailbox es OBLIGATORIO. La
notificacion al User es parte del compliance:
el User debe saber que tiene capacidades
excepcionales temporales para no caer en
"side-channel" administrativo.

Si mailbox falla → EX-XX → ROLLBACK total
(P-10 mailbox-or-abort hard).

3.3 Atomicidad
==============

PASOS 13-16 atomicos. Cache invalidate
post-COMMIT (P-29).
