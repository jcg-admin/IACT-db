.. _uc-acc-03-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen del flujo
=====================

::

   PASO 1   Invoker abre vista de permisos        (Frontend)
   PASO 2   GET /api/users/{user_id}/
            effective-permissions/                (FE → BE)
   PASO 3   Validar JWT (CNST-009)                (Backend)
   PASO 4   Validar funcion view_assignments      (Backend)
   PASO 5   Localizar User destino                (Backend → BD)
   PASO 6   Cargar Assignments directos ACTIVE    (Backend → BD)
   PASO 7   Cargar AGRs ACTIVE del User           (Backend → BD)
   PASO 8   Expandir funciones de cada AGR        (Backend → BD)
   PASO 9   Cargar ExceptionalPermissions
            ACTIVE                                (Backend → BD)
   PASO 10  Consolidar (deduplicar + metadata)    (Backend)
   PASO 11  Detectar expirados pendientes purga   (Backend)
   PASO 12  Detectar SoD violations informativas  (Backend → BD)
   PASO 13  Audit selectivo P-16                  (Backend → BD)
   PASO 14  200 OK con vista consolidada          (BE → FE)
   PASO 15  Frontend renderiza tabla              (Frontend)

3.2 Detalle paso a paso
=======================

PASO 6 — Assignments directos
-----------------------------

::

   AssignmentRepository
     .list_active_for_user(user)
     -- Excluye state in {REVOKED, EXPIRED}

PASO 7 — AGRs ACTIVE
--------------------

::

   AssignmentRepository
     .list_active_agr_assignments(user)
     -- Assignments cuyo target es un AGR

PASO 8 — Expandir funciones de cada AGR
---------------------------------------

::

   for agr in user_agrs:
       agr_functions =
         AGRRepository
           .list_functions_in_agr(agr)
       # Cada funcion se acompana de
       # via='via_agr:{agr_id}' como origen

PASO 9 — ExceptionalPermissions
-------------------------------

::

   ExceptionalPermissionRepository
     .list_active_for_user(user, NOW())
     -- state=ACTIVE AND expires_at > NOW()

PASO 10 — Consolidacion
-----------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - construir set unico de funciones,
     conservando para cada una su lista de
     origenes (puede tener > 1 si aparece via
     directo + via AGR — caso comun en RBAC
     hibrido).
 * - **Estructura**
   - ``effective_functions`` es un mapa
     indexado por ``function_id`` donde cada
     entrada incluye ``function_code``,
     ``display_name`` y una lista
     ``sources``. Cada source es uno de tres
     tipos: ``direct`` (con
     ``assignment_id``, ``expires_at?``),
     ``via_agr`` (con ``agr_id``,
     ``agr_code``), o ``exceptional`` (con
     ``permission_id``, ``expires_at``). Ver
     Parte 7 § 7.3 para ejemplo completo.
 * - **Razon multiples sources**
   - permite trazabilidad. Si admin quiere
     "revocar funcion X", debe revocar todos
     los sources.

PASO 11 — Expirados pendientes purga
-------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - filtrar Assignments con
     ``state='ACTIVE'`` y
     ``expires_at IS NOT NULL AND expires_at <
     NOW()``. Estos son "deuda": el cron de
     expiracion aun no los procesa pero
     conceptualmente no deberian ser efectivos.
 * - **Decision**
   - se INCLUYEN en effective_functions pero
     se marcan en
     ``expired_pending_purge``. Frontend
     puede mostrarlos en gris para indicar
     transicion.

PASO 12 — SoD detection (informativa)
-------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - evaluar SoDRules ACTIVE contra el set
     efectivo. Si hay violaciones, listarlas
     en ``sod_violations_detected``.
 * - **Naturaleza**
   - INFORMATIVA, no bloqueo. UC_ACC_01 ya
     valida SoD en write-time; UC_ACC_03
     muestra inconsistencias si las hubiera
     (defensa en profundidad — pueden surgir
     si se modifican SoDRules
     retroactivamente).

PASO 13 — Audit selectivo (P-16)
--------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Audit**
   - SI se audita: vista de un User especifico
     se considera focalizada (tipico en
     investigacion).
 * - **Event type**
   - ``EFFECTIVE_PERMISSIONS_VIEWED`` con
     payload ``{target_user_id, self_view,
     effective_count, via_direct_count,
     via_agr_count, via_exceptional_count}``.

PASO 14 — Response
------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Body**
   - JSON estructurado (ver Parte 7 § 7.3)

PASO 15 — Frontend render
-------------------------

Tabla con columnas: function_code,
display_name, sources (badges), expires_at
si aplica, indicador SoD si la funcion
participa en violacion detectada.
