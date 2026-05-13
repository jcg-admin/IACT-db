.. _uc-perm-01-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

.. note::

 El flujo subyacente es identico al de
 :doc:`/requisitos/casos-uso/access/uc-acc-04/index`
 Parte 3. Los pasos backend (validar JWT,
 verificar ``assign_function_groups``,
 expandir AGR, validar SoD, INSERT
 Assignment, audit, mailbox, cache) son los
 mismos. Esta parte documenta el flujo
 desde la vista PERM.

3.1 Resumen del flujo (vista PERM)
==================================

::

   PASO 1   Invoker abre catalogo de AGRs       (Frontend PERM)
   PASO 2   Selecciona AGR del catalogo         (Frontend)
   PASO 3   Selecciona User destino             (Frontend)
   PASO 4   Define expires_at opcional          (Frontend)
   PASO 5   Modal con composicion del AGR       (Frontend)
   PASO 6   Confirma asignacion                  (Frontend)
   PASO 7   POST /api/users/{id}/access-groups/ (FE → BE backing)
   ── desde aqui flujo identico a UC_ACC_04 ──
   PASO 8   Validar JWT + RBAC (Backend)
   PASO 9   Validar User + AGR
   PASO 10  Idempotencia check
   PASO 11  Expandir AGR + SoD
   PASO 12  INSERT Assignment AGR
   PASO 13  AuditEvent + InternalMessage
   PASO 14  Cache invalidate post-COMMIT
   PASO 15  201 Created
   ── retorno a vista PERM ──
   PASO 16  Frontend actualiza catalogo +
            users-por-AGR

3.2 Diferencias clave de la vista PERM
======================================

PASO 1 — Catalogo de AGRs
-------------------------

A diferencia de UC_ACC_04 (que entra desde
detalle del User), UC_PERM_01 entra desde el
**catalogo de AGRs**. La UI muestra:

- Lista de AGRs predefinidos + custom.
- Composicion (functions) de cada AGR.
- Count de Users que tienen cada AGR.
- Filtros por categoria, severity.

PASO 5 — Modal con composicion
------------------------------

A diferencia del modal en UC_ACC_04 (que solo
confirma "asignar AGR-X a User-Y"), en
UC_PERM_01 el modal MUESTRA la composicion
explicita del AGR:

::

   "Vas a asignar el AGR 'user_admin_group'
    a 'ana.gomez.0001'. Esto otorgara las
    siguientes 8 capacidades:
    - create_users
    - modify_users
    - deactivate_users
    - ...
    Confirmas?"

Defensa contra asignaciones por nombre sin
saber que contienen. Audiencia (admin de
seguridad) decide informadamente.

PASO 16 — Vista catalogo actualizada
------------------------------------

UI re-renderiza:

- Count de Users del AGR incrementado.
- (Opcional) graph de coverage RBAC.

3.3 Atomicidad
==============

Identica a UC_ACC_04. Backend transaccion
ACID en pasos backend 12-13.
