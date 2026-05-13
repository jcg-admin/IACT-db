.. _uc-perm-07-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Cache hit
====================

Origen detectado en cache, sin query a BD.
Response inmediato con ``cache: true``.
Camino mayoritario en runtime.

4.2 FA-02: Revocacion excepcional gana
======================================

User esta en AGR-008 (``daily_audit_group``)
que otorga ``view_audit_logs``, **pero**
tiene ExceptionalPermission de tipo REVOKE
para ``view_audit_logs`` (suspension
temporal).

Resultado: ``allowed = false``,
``origin = REVOKED_EXCEPTIONAL``. La
revocacion siempre gana — P-08 fail-closed.

4.3 FA-03: Concesion excepcional sin AGR
========================================

User no esta en ningun AGR que otorgue
``view_kpi_dashboard``, pero un Admin le
concedio acceso temporal (UC_ACC_06).

Resultado: ``allowed = true``,
``origin = GRANTED_EXCEPTIONAL``,
``valid_until`` retornado para que el frontend
muestre cuenta regresiva.

4.4 FA-04: Multi-AGR origin
===========================

User esta en 3 AGRs distintos que coinciden
en otorgar ``view_realtime_metrics``.

Resultado: ``allowed = true``,
``origin = GRANTED_BY_AGR``,
``via_agr_codes = ["agr_a", "agr_b",
"agr_c"]``. Informativo — el frontend puede
mostrar de donde viene.

4.5 FA-05: Cache invalidate por evento
======================================

Llega evento de UC_ACC_*, UC_PERM_05/06
indicando cambio que afecta a User U:

::

   PermissionCache.invalidate(user_id=U)

Proxima invocacion de UC_PERM_07 para U es
cache miss → recalcula. Garantiza
consistencia post-cambio (P-29 escalado).

4.6 FA-06: Bulk check para menu
===============================

UC_PERM_08 invoca bulk con 50 codes para
construir menu dinamico. Optimizacion:

- 1 round-trip a BD en lugar de 50
- Cache hits de codes ya consultados
- Tiempo total < 30 ms tipico.

4.7 FA-07: Concesion proximo a expirar
======================================

ExceptionalPermission GRANT con
``valid_until = now + 30s``.

Resultado actual: ``allowed = true``.
TTL de cache truncado a 30s para que la
proxima consulta post-expiracion devuelva
DENIED sin servir cache stale.

4.8 FA-08: Funcion no existe
============================

``function_code`` no encontrado en catalogo.
NO retornar DENIED silencioso (oculta bugs
de typo en codigo). Retornar 400 con
``FUNCTION_NOT_FOUND``.

4.9 FA-09: Modo interno (servicio)
==================================

Decorator invoca service directamente:

::

   PermissionService.check(
     user_id, function_code, context)

Sin HTTP, sin RBAC del caller, sin
``view_assignments``. Mismo algoritmo PASOS
4-11. Caller maneja la respuesta (decorator
levanta SinPermiso si ``allowed == false``).

4.10 Resumen
============

.. list-table::
 :widths: 12 38 30 20
 :header-rows: 1

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Cache hit
   - response inmediato
   - mayoritario
 * - FA-02
   - Revocacion gana
   - allowed=false
   - P-08
 * - FA-03
   - Concesion sin AGR
   - allowed=true
   - valid_until
 * - FA-04
   - Multi-AGR
   - via_agr_codes lista
   - informativo
 * - FA-05
   - Invalidate por evento
   - miss en proxima
   - P-29
 * - FA-06
   - Bulk
   - 1 round-trip
   - UC_PERM_08
 * - FA-07
   - Concesion proxima
   - TTL truncado
   - consistencia
 * - FA-08
   - Funcion no existe
   - 400
   - no DENIED silencioso
 * - FA-09
   - Modo servicio
   - sin RBAC del caller
   - decorator path
