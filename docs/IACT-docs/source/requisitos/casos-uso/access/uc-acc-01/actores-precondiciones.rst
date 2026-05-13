.. _uc-acc-01-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion** ``assign_functions``.

La dependencia canonica del UC es **la
funcion**, no un AGR especifico. La funcion es
distinta de:

- ``revoke_functions`` (UC_ACC_02 inverso —
  granularidad explicita: poder asignar y
  poder revocar son privilegios distintos).
- ``assign_access_group`` (UC_ACC_04 — masivo
  via AGR).
- ``configure_sod`` (UC_ACC_05 — privilegio
  mas alto, solo admin de seguridad).

En el catalogo predefinido, la funcion
``assign_functions`` esta agrupada en AGR-006
user_admin_group; otros AGRs custom (creados
via UC_PERM_05) pueden contenerla.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Persona (humano)
 * - **Iniciador**
   - SI
 * - **Beneficiario directo**
   - NO — el beneficiario operacional es el
     User al que se asignan las funciones
 * - **Responsabilidad**
   - presentar token valido; identificar
     correctamente las funciones a asignar;
     manejar el modal con conocimiento de las
     implicaciones (cambio de capacidades del
     User destino)

2.2 Actores Secundarios
=======================

2.2.1 User destino (al que se asignan funciones)
------------------------------------------------

Receptor pasivo durante el flujo. Posteriormente:

- Su proximo request al backend ya considera
  las nuevas funciones (cache de permisos
  invalidada).
- (Opcional) recibe ``InternalMessage``
  notificando las nuevas capacidades.

2.2.2 Sistema (Backend)
-----------------------

Responsabilidades:

- Validar funcion ``assign_functions`` del
  invocante.
- Validar User destino (estado y existencia).
- Validar cada funcion a asignar (existencia,
  estado activo).
- **Validar SoD** por cada funcion contra el
  conjunto actual del User
  (intersection de funciones asignadas +
  pending → buscar conflictos en SoDRules
  ACTIVE).
- Crear N Assignments atomicamente.
- Invalidar cache de permisos del User.
- Emitir AuditEvent FUNCTIONS_ASSIGNED.

2.2.3 BD analitica (MySQL)
--------------------------

- Atomicidad ACID en INSERT masivo de
  Assignments + cache invalidation + audit.
- UNIQUE constraint sobre
  ``(user, function, state=ACTIVE)`` impide
  duplicados.
- Append-only en AuditEvent (CNST-025).

2.2.4 SoDValidator (servicio interno)
-------------------------------------

- Consume SoDRules vigentes (CNST-005).
- Determina si una nueva asignacion crearia
  conflicto.
- Bloquea con mensaje especifico citando la
  regla SoD violada.

2.2.5 Frontend (React)
----------------------

- Pagina de asignacion con multi-select de
  funciones (visible solo con
  ``assign_functions``).
- Validacion client-side basica.
- Feedback claro cuando SoD bloquea
  (mostrando regla y conflicto).
- Confirmacion antes de aplicar.

2.2.6 Auditor (beneficiario indirecto)
--------------------------------------

Consume AuditEvent FUNCTIONS_ASSIGNED para
detectar:

- Asignaciones masivas inusuales.
- Asignacion de funciones criticas (admin de
  seguridad, etc.).
- Patrones de escalada de privilegios.

2.3 Precondiciones
==================

2.3.1 Sistema disponible
------------------------

- Backend respondiendo en
  ``/api/users/{user_id}/functions/`` (POST).
- BD analitica MySQL accesible.
- HTTPS configurado.

2.3.2 Invocante autenticado y autorizado
----------------------------------------

- Session ACTIVE del invocante.
- Invocante posee la funcion
  ``assign_functions`` (granted via cualquier
  AGR — tipicamente AGR-006).

2.3.3 User destino valido
-------------------------

- ``User`` existe en BD.
- ``User.state ∈ {ACTIVE, INACTIVE}`` (no
  ELIMINATED, no BLOCKED — politica: no se
  asignan permisos a cuentas inhabiles).
- ``user_id != invoker.id`` (politica P-11
  anti-self-assignment para evitar escalada
  en cascada — opcional segun politica
  organizacional, configurable).

2.3.4 Funciones a asignar validas
---------------------------------

- Cada ``function_id`` en el payload existe
  en catalogo.
- Cada funcion esta en estado ``ACTIVE``.
- El conjunto de funciones nuevas + las
  actuales del User no viola ninguna regla
  SoD ``ACTIVE``.

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- N nuevos ``Assignment`` con
  ``state='ACTIVE'``,
  ``granted_at=NOW()``,
  ``granted_by_admin_id=invoker.id``,
  opcional ``expires_at`` segun input.
- Cache de permisos del User invalidada
  (proximas requests del User reflejan las
  nuevas funciones).
- 1 ``AuditEvent`` con
  ``event_type='FUNCTIONS_ASSIGNED'``,
  ``actor_user_id=invoker.id``,
  ``payload={target_user_id,
  function_ids: [...], expires_at?,
  ip, user_agent, sod_validations_passed}``.
- (Opcional) InternalMessage al User destino.
- Frontend muestra confirmacion con detalle
  por funcion.

2.4.2 Postcondiciones de fallo
------------------------------

- EX-01..EX-09: rollback completo. Cero
  Assignments creados. Cache no invalidada.
  Sin AuditEvent FUNCTIONS_ASSIGNED. Posible
  AuditEvent FUNCTIONS_ASSIGN_FAILED segun
  excepcion.

2.4.3 Postcondiciones idempotentes
----------------------------------

Si una funcion ya esta asignada activamente
al User:

- NO se crea nuevo Assignment.
- AuditEvent payload registra la lista de
  funciones efectivamente asignadas (excluye
  las que ya estaban).
- Status final 200 con resumen indicando
  cuales fueron nuevas y cuales ya estaban.
