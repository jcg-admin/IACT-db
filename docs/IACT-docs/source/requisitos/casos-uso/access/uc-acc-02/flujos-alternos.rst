.. _uc-acc-02-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Revocacion totalmente idempotente
============================================

**Activador**: PASO 10 — todas las funciones del
payload ya estan REVOKED (o nunca estuvieron
asignadas).

**Diferencia**: ``to_revoke_ids`` queda vacio.
PASO 12 ejecuta cero UPDATEs.

**Pasos:**

::

   PASO 12A   Backend detecta to_revoke_ids vacio.
              No hay UPDATE.

   PASO 14A   AuditEvent FUNCTIONS_REVOKE_NOOP con
              payload {function_ids_already_inactive}.

   PASO 16A   200 OK con body {"revoked":[],
                             "skipped":[...],
                             "message":"Funciones ya
                                        no estaban
                                        activas"}

**Postcondicion**: cero cambios en BD (excepto
AuditEvent informativo).

4.2 FA-02: Revocacion con warning critico
=========================================

**Activador**: PASO 11 — la revocacion incluye
una funcion en ``CRITICAL_FUNCTIONS``
(ej. ``configure_sod``,
``deactivate_users``).

**Diferencia**: PASO 11 marca
``warnings.critical_revoked = [...]``. La
operacion procede, pero la response y
AuditEvent destacan el warning.

**Justificacion**: no se bloquea (la operacion
es legitima si el invocante tiene permiso),
pero se eleva visibilidad para auditor y para
el invocante.

4.3 FA-03: Revocacion deja al User sin funciones
================================================

**Activador**: PASO 11 — tras la revocacion,
``post_revoke_active_count == 0``.

**Diferencia**:

- Response incluye ``warnings.no_functions =
  true``.
- Frontend muestra advertencia destacada.
- AuditEvent FUNCTIONS_REVOKED con
  ``warnings.no_functions``.

**No se bloquea**: dejar al User sin funciones
es valido (preludio a UC_USR_03 → INACTIVE
o UC_USR_04 → ELIMINATED). Pero se documenta
para auditoria.

4.4 FA-04: User es ultimo holder de una funcion
===============================================

**Activador**: PASO 11 — el User es uno de los
ultimos N (politica
``LAST_HOLDER_THRESHOLD``,
default 1) que tiene una funcion en el
sistema.

**Justificacion**: defensa contra
"bus factor" de privilegios. Si solo una
persona tiene la funcion ``configure_sod``,
revocarsela deja al sistema sin admin de
seguridad.

**Diferencia**:

- Response incluye
  ``warnings.last_holder=[{function_id,
  remaining_holders_after}]``.
- Si politica
  ``BLOCK_LAST_HOLDER_REVOKE=true`` y queda
  ``remaining_holders_after == 0``, EX-09
  (409) bloquea.

4.5 FA-05: Revocacion masiva (>10 funciones)
============================================

**Activador**: ``len(function_ids) > 10``.

**Diferencia**: validacion adicional de tamano
payload (max 50). Performance: el UPDATE
masivo se beneficia de indice en
``(user_id, state)``.

4.6 FA-06: Revoke con notify_user=false
=======================================

**Activador**: ``payload.notify_user=false``.

**Diferencia**: PASO 15 omitido. Util para
casos donde el admin prefiere comunicarse
directamente o cuando la revocacion es
tecnica/preliminar (e.g. resolucion SoD
seguida de re-asignacion).

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
   - Todas ya REVOKED (idempotente)
   - 0 UPDATE, audit NOOP
   - 200 OK
 * - FA-02
   - Revoca funcion critica
   - warnings.critical_revoked
   - 200 OK + warning
 * - FA-03
   - User queda sin funciones
   - warnings.no_functions=true
   - 200 OK + warning
 * - FA-04
   - User es ultimo holder
   - warnings.last_holder
   - 200 OK / 409 strict
 * - FA-05
   - >10 funciones
   - max 50 enforced
   - 200 OK
 * - FA-06
   - notify_user=false
   - PASO 15 omitido
   - 200 OK
