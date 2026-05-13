.. _uc-acc-01-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Asignacion totalmente idempotente
============================================

**Activador**: PASO 9 — todas las funciones del
payload ya estan asignadas activamente al User.

**Diferencia**: ``new_function_ids`` queda
vacio. PASO 10 (SoD) skipped (no hay cambios).
PASO 11 ejecuta cero INSERTs.

**Pasos:**

::

   PASO 9A   Backend detecta que ALL function_ids
             ya tienen Assignment ACTIVE.

   PASO 13A  AuditEvent FUNCTIONS_ASSIGN_NOOP con
             payload {target_user_id,
             function_ids_already_assigned}.

   PASO 15A  200 OK (no 201) con body
             {"assigned": [],
              "skipped": [...all...],
              "message": "Funciones ya activas"}

**Postcondicion**: cero cambios en BD (excepto
AuditEvent informativo). Cache no invalidada.

4.2 FA-02: Asignacion temporal con expires_at
=============================================

**Activador**: payload incluye ``expires_at``.

**Justificacion**: BR-008 (Permisos con
Vencimiento) — funciones temporales para
soporte ad-hoc, cobertura de licencias, etc.

**Diferencia**: PASO 11 incluye
``expires_at`` en cada Assignment. Un cron job
externo (no parte de este UC) debera
desactivar Assignments expirados.

**Validaciones adicionales**:

- ``expires_at > NOW() + 1 hour`` (politica
  minima — no permite expiraciones en menos
  de 1 hora; defensa anti-error).
- ``expires_at <= NOW() + 1 anio`` (politica
  maxima — para forzar revisiones
  periodicas).

4.3 FA-03: Mix de nuevas + ya asignadas
=======================================

**Activador**: payload con N funciones donde
algunas ya estan asignadas.

**Diferencia**: PASO 9 separa en
``new_function_ids`` y
``already_assigned_ids``. PASO 10 SoD valida
solo el estado resultante (ya considerando
activas + nuevas). PASO 11 inserta solo
las nuevas. Response 201 incluye ambas listas
en ``assigned`` y ``skipped``.

4.4 FA-04: Asignacion sobre User INACTIVE
=========================================

**Activador**: PASO 7 — User destino con state
INACTIVE (suspension temporal).

**Diferencia**: politica configurable:

- Default: permite asignar (las funciones
  estaran disponibles cuando el User regrese
  a ACTIVE).
- Strict: rechaza con EX-03
  INVALID_USER_STATE (politica
  ``ASSIGN_TO_INACTIVE_FORBIDDEN=true``).

4.5 FA-05: Asignacion masiva (>10 funciones)
============================================

**Activador**: ``function_ids.length > 10``.

**Justificacion**: caso de bulk operations.

**Diferencia**:

- PASO 4: validacion adicional de tamano
  payload (max 50 por request — politica
  CNST-011).
- PASO 10: SoD validation puede ser costosa —
  recomendar al frontend confirmacion robusta
  antes del POST.

4.6 FA-06: Re-asignacion despues de revocacion
==============================================

**Activador**: existe ``Assignment(user,
function, state='REVOKED')`` por UC_ACC_02
previo.

**Justificacion**: re-otorgar una funcion
revocada debe crear NUEVO Assignment, no
"reactivar" el anterior. Preserva historial
completo.

**Diferencia**: PASO 9 considera solo
``state='ACTIVE'`` para idempotencia. El
Assignment REVOKED previo permanece intacto
como historial. Se inserta nuevo con
``granted_at=NOW()`` y nuevo ID.

4.7 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia clave
   - Status
 * - FA-01
   - Todas ya asignadas (idempotente)
   - 0 INSERT, audit NOOP
   - 200 OK
 * - FA-02
   - Con expires_at
   - Assignment temporal (BR-008)
   - 201 Created
 * - FA-03
   - Mix nuevas + activas
   - assigned + skipped lists
   - 201 Created
 * - FA-04
   - User INACTIVE
   - Permitido por default
   - 201 / 400 segun politica
 * - FA-05
   - >10 funciones
   - Validacion tamano + SoD costosa
   - 201 / 400 si > 50
 * - FA-06
   - Re-asignacion post-revoke
   - Nuevo Assignment, REVOKED preservado
   - 201 Created
