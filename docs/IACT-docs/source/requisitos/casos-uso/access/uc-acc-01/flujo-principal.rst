.. _uc-acc-01-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen del flujo
=====================

::

   PASO 1   Invoker abre detalle del User           (Frontend)
   PASO 2   Selecciona funciones a asignar          (Frontend)
   PASO 3   Opcionalmente define expires_at         (Frontend)
   PASO 4   POST /api/users/{user_id}/functions/    (FE → BE)
   PASO 5   Validar JWT (CNST-009)                  (Backend)
   PASO 6   Validar funcion assign_functions        (Backend)
   PASO 7   Validar User destino (estado, P-11)     (Backend → BD)
   PASO 8   Validar cada funcion (existe + ACTIVE)  (Backend → BD)
   PASO 9   Filtrar idempotente (excluir las
            ya asignadas activamente)               (Backend → BD)
   PASO 10  Validar SoD del conjunto resultante     (Backend → BD)
   PASO 11  INSERT N Assignments                    (Backend → BD)
   PASO 12  Invalidar cache de permisos del User    (Backend)
   PASO 13  Emitir AuditEvent FUNCTIONS_ASSIGNED    (Backend → BD)
   PASO 14  (Opcional) InternalMessage al User      (Backend → BD)
   PASO 15  201 Created con resumen detallado       (BE → FE)
   PASO 16  Frontend muestra confirmacion           (Frontend)

3.2 Detalle paso a paso
=======================

PASO 4 — Request
----------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Metodo**
   - POST
 * - **Path**
   - ``/api/users/{user_id}/functions/``
 * - **Headers**
   - ``Authorization: Bearer <token>``
 * - **Body**
   - ``{"function_ids": [1, 2, 3],
     "expires_at": "2026-12-31T23:59:59Z"}``
     (``expires_at`` opcional)

PASO 5-6 — Validacion auth + RBAC
---------------------------------

Middleware de autenticacion valida JWT
(CNST-009). ``AuthorizationGuard`` verifica
que el invocante posee la funcion
``assign_functions`` (sin importar via que
AGR la haya obtenido — DEC-USR04-01).

PASO 7 — Validar User destino
-----------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``UserRepository.get_by_id_for_update(
     user_id)``;
     verifica existencia,
     ``state ∈ {ACTIVE, INACTIVE}``,
     y ``user_id != invoker.id`` si politica
     ``ANTI_SELF_ASSIGN_FUNCTIONS=true``.
 * - **Errores**
   - EX-02 (404 USER_NOT_FOUND),
     EX-03 (400 INVALID_USER_STATE),
     EX-04 (400 SELF_ASSIGN_FORBIDDEN).

PASO 8 — Validar funciones
--------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - Por cada ``function_id`` en payload,
     ``FunctionRepository.get(id)``;
     verificar ``state == ACTIVE``.
 * - **Errores**
   - EX-05 (400 FUNCTION_NOT_FOUND),
     EX-06 (400 FUNCTION_INACTIVE).

PASO 9 — Filtrar idempotente
----------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - Para cada ``function_id``, verificar si
     ya existe ``Assignment(user, function,
     state='ACTIVE')``. Excluir esas del
     conjunto a insertar.
 * - **Resultado**
   - dos listas:
     ``new_function_ids`` (a insertar) y
     ``already_assigned_ids`` (idempotente —
     skip).

PASO 10 — Validar SoD
---------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - construir el ``effective_function_set``
     que el User tendra DESPUES de la
     operacion (funciones actuales +
     ``new_function_ids``);
     consultar
     ``SoDRule.objects.filter(state='ACTIVE')``;
     por cada regla, verificar que NO se
     cumple la condicion de conflicto.
 * - **Implementacion (pseudocodigo)**
   - ::

      sod_rules = SoDRuleRepo.list_active()
      for rule in sod_rules:
        if rule.is_violated_by(effective_set):
          raise SoDViolation(
            rule_id=rule.id,
            conflicting_pair=
              rule.find_conflict(effective_set))
 * - **Errores**
   - EX-07 (409 SOD_VIOLATION) — bloquea con
     detalle de la regla y par de funciones
     en conflicto.
 * - **CNST**
   - CNST-005 enforcement en tiempo de
     asignacion.

PASO 11 — INSERT Assignments
----------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - Por cada ``function_id`` en
     ``new_function_ids``,
     ``Assignment.objects.create(
     user=target_user,
     function_id=fid,
     state='ACTIVE',
     granted_at=NOW(),
     granted_by_admin_id=invoker.id,
     expires_at=payload.expires_at)``
 * - **Clase**
   - ``Assignment`` (escritura — N inserts)

PASO 12 — Invalidar cache de permisos
-------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``PermissionCache.invalidate(
     user_id=target.id)`` — elimina entry de
     cache para que el proximo request del
     User recompute permisos efectivos desde
     BD.
 * - **Justificacion**
   - sin esto, el User puede tener cache
     stale por TTL del cache (minutos), y no
     reflejaria las nuevas funciones.

PASO 13 — AuditEvent
--------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``AuditEvent.objects.create(
     event_type='FUNCTIONS_ASSIGNED',
     actor_user_id=invoker.id,
     occurred_at=NOW(),
     payload={target_user_id,
     function_ids_assigned: new_ids,
     function_ids_skipped: already_ids,
     expires_at, ip, user_agent,
     sod_rules_evaluated: count})``
 * - **CNST**
   - CNST-025; CNST-026 sin PII (no email,
     no full_name del User destino — solo
     IDs).

PASO 14 — InternalMessage opcional
----------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Politica**
   - ``NOTIFY_USER_ON_ASSIGN=true`` (default):
     enviar InternalMessage al User destino
     listando las funciones agregadas (por
     nombre legible — function.display_name)
     y la fecha de expiracion si aplica.
 * - **Critico**
   - el mensaje no expone detalles tecnicos
     (no muestra IDs internos), solo nombres
     legibles.

PASO 15 — Response 201
----------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - 201 Created con body detallado:
     ``{"target_user_id": 42,
     "assigned": [{"function_id": 1,
     "function_code": "view_users",
     "expires_at": "..."}],
     "skipped": [{"function_id": 2,
     "function_code": "modify_users",
     "reason": "already_active"}],
     "sod_rules_evaluated": 5,
     "user_notified": true}``

PASO 16 — Confirmacion
----------------------

Frontend toast: "Asignadas N funciones a
{username}. M ya estaban activas y se
omitieron."

3.3 Atomicidad
==============

PASOS 11-13 dentro de transaccion atomica:

::

   BEGIN
     # PASO 10 ya valido SoD (lectura)
     INSERT INTO assignment ...; -- N filas
     -- (cache invalidation en PASO 12 fuera
     --  de la tx para evitar lock)
     INSERT INTO audit_event (
       event_type='FUNCTIONS_ASSIGNED', ...);
     [opcional] INSERT INTO internal_message;
   COMMIT

   -- PASO 12 cache invalidation post-COMMIT
   PermissionCache.invalidate(user_id);

Si cualquier INSERT en transaccion falla,
ROLLBACK total. El cache NO se invalida si la
transaccion falla (orden importante: cache
post-commit).
