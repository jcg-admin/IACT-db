.. _uc-acc-02-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion** ``revoke_functions``.

La dependencia canonica del UC es **la
funcion**, no un AGR especifico. La funcion es
distinta de:

- ``assign_functions`` (UC_ACC_01) —
  granularidad explicita (P-15): asignar y
  revocar son privilegios separados.
- ``deactivate_users`` (UC_USR_04) — la
  eliminacion del User invoca revocacion
  internamente, pero requiere privilegio mayor.

En el catalogo predefinido, ``revoke_functions``
esta agrupada en AGR-006 user_admin_group;
otros AGRs custom (creados via UC_PERM_05)
pueden contenerla.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Persona (humano)
 * - **Iniciador**
   - SI
 * - **Beneficiario directo**
   - NO — el User pierde capacidades
 * - **Responsabilidad**
   - presentar token valido; identificar
     funciones a revocar; documentar
     ``revoke_reason``; manejar
     confirmacion robusta dado que la
     operacion afecta capacidades del User

2.2 Actores Secundarios
=======================

2.2.1 User destino
------------------

Receptor pasivo. Tras la operacion:

- Su proximo request al backend ya considera
  las funciones revocadas (cache invalidada).
- (Opcional) recibe ``InternalMessage``
  notificando funciones perdidas.

2.2.2 Sistema (Backend)
-----------------------

Responsabilidades:

- Validar funcion ``revoke_functions``.
- Validar User destino (existencia).
- Validar que cada funcion existe en
  Assignments ACTIVE del User (idempotencia).
- Transicion atomica
  ``Assignment.state ACTIVE → REVOKED``.
- Detectar lockout potencial post-revocacion
  (warning en response).
- Invalidar cache de permisos.
- Emitir AuditEvent FUNCTIONS_REVOKED.

2.2.3 BD analitica
------------------

- Atomicidad ACID en UPDATE masivo +
  AuditEvent.
- Append-only (CNST-025).

2.2.4 Frontend
--------------

- Vista detalle del User con funciones
  actuales (multi-select de las que se
  desean revocar).
- Modal robusto de confirmacion (operacion
  con side-effect: User pierde capacidades).
- Campo obligatorio ``revoke_reason``
  (texto libre o select de razones
  predefinidas).
- Warning visual si la revocacion deja al
  User sin funciones criticas.

2.2.5 Auditor
-------------

Consume AuditEvent FUNCTIONS_REVOKED para
detectar:

- Revocaciones masivas sospechosas.
- Patrones de revocacion-asignacion
  (potencial bypass SoD).
- Revocacion de funciones criticas.

2.3 Precondiciones
==================

2.3.1 Sistema disponible
------------------------

- Backend respondiendo en
  ``/api/users/{user_id}/functions/``
  (DELETE con body).
- BD MySQL accesible.
- HTTPS configurado.

2.3.2 Invocante autenticado y autorizado
----------------------------------------

- Session ACTIVE del invocante.
- Invocante posee la funcion
  ``revoke_functions``.

2.3.3 User destino valido
-------------------------

- ``User`` existe en BD.
- ``User.state != 'ELIMINATED'`` (los
  ELIMINATED ya tienen sus Assignments
  REVOKED por UC_USR_04).
- ``user_id != invoker.id`` si politica
  ``ANTI_SELF_REVOKE_FUNCTIONS=true`` (P-11).

2.3.4 Funciones a revocar
-------------------------

- Cada ``function_id`` provisto debe existir
  en Assignment ACTIVE del User. Si no existe
  o ya fue revocado, idempotencia (skip).

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- N ``Assignment`` con
  ``state='REVOKED'``,
  ``revoked_at=NOW()``,
  ``revoked_by_admin_id=invoker.id``,
  ``revoke_reason=<input>``.
- Cache de permisos del User invalidada
  (post-COMMIT).
- 1 ``AuditEvent FUNCTIONS_REVOKED`` con
  payload conteniendo
  ``function_ids_revoked``,
  ``function_ids_skipped``
  (las que ya estaban REVOKED o no existian),
  ``revoke_reason``,
  ``ip``, ``user_agent``,
  ``post_revoke_active_count``,
  ``lockout_warning`` si aplica.
- (Opcional) InternalMessage al User.
- Frontend muestra resumen.

2.4.2 Postcondiciones de fallo
------------------------------

- EX-01..EX-08: rollback completo. Sin
  Assignments revocados. Cache no invalidada.
  Sin AuditEvent FUNCTIONS_REVOKED. Posible
  AuditEvent FUNCTIONS_REVOKE_FAILED.

2.4.3 Postcondiciones de warning
--------------------------------

- Si tras la revocacion el User queda con cero
  funciones activas: response incluye
  ``warning.no_functions = true``.
- Si la revocacion incluye una funcion
  critica registrada en
  ``CRITICAL_FUNCTIONS`` (politica): response
  incluye ``warning.critical_revoked``.
- Si politica ``WARN_ON_LAST_REVOKE=true`` y
  el User es uno de pocos que tiene esta
  funcion (e.g. ultimo admin de seguridad):
  warning ``warning.last_holder``.
