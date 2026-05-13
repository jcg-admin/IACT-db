.. _uc-acc-03-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: User sin permisos efectivos
======================================

**Activador**: PASO 10 — el conjunto consolidado
es vacio.

**Diferencia**: response con
``effective_functions: []``,
``via_direct: []``, etc. Frontend muestra
"Usuario sin permisos efectivos" con sugerencia
(asignar AGR o funcion directa).

4.2 FA-02: Vista propia (self-view)
===================================

**Activador**: ``user_id == invoker.id`` o
endpoint ``/api/auth/me/permissions/``.

**Diferencia**:

- NO requiere ``view_assignments`` (cualquier
  User puede ver sus propios permisos).
- Audit con ``self_view=true``.

4.3 FA-03: User con muchos AGRs
===============================

**Activador**: User con > 3 AGRs ACTIVE.

**Diferencia**: rendimiento — la expansion de
funciones (PASO 8) puede agregarse en una
query con join. Indices recomendados.

4.4 FA-04: User con expirados pendientes purga
==============================================

**Activador**: existen Assignments con
``state=ACTIVE`` y ``expires_at < NOW()``.

**Diferencia**: response incluye
``expired_pending_purge`` no vacio. Frontend
muestra warning visual.

4.5 FA-05: Inconsistencia SoD detectada
=======================================

**Activador**: el User tiene un par
conflictivo segun SoDRule activa (caso raro
post-modificacion retroactiva de reglas).

**Diferencia**: response incluye
``sod_violations_detected``. Frontend muestra
alerta destacada con sugerencia "revocar una
de las funciones via UC_ACC_02".

4.6 FA-06: Audit suprimido (P-16 lectura amplia)
================================================

**Activador**: endpoint extendido
``/api/users/effective-permissions/`` (sin
user_id especifico) si existiera para listar
permisos masivos. NO es scope de UC_ACC_03,
pero se nota como flujo alterno potencial.

**Diferencia**: AuditEvent NO se emite (lectura
amplia per P-16). Fuera de scope de este UC.

4.7 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia
   - Status
 * - FA-01
   - Sin permisos efectivos
   - effective vacio
   - 200 OK
 * - FA-02
   - Self-view
   - Sin view_assignments req
   - 200 OK
 * - FA-03
   - Muchos AGRs
   - Performance / index
   - 200 OK
 * - FA-04
   - Expirados pending purge
   - expired_pending_purge no vacio
   - 200 OK + warning
 * - FA-05
   - SoD inconsistencia detectada
   - sod_violations_detected
   - 200 OK + warning
 * - FA-06
   - Lectura masiva (futuro)
   - Sin audit (P-16)
   - n/a en este UC
