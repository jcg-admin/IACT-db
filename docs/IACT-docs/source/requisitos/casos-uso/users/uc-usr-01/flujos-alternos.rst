.. _uc-usr-01-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Sin AGR inicial
==========================

**Activador**: PASO 11 — admin no provee
``access_group_id``.

**Justificacion**: caso operacional comun. El
admin de usuarios crea la cuenta primero; la
asignacion de permisos la hace posteriormente
otro admin (UC_PERM_*) o el mismo admin via
UC_ACC_01.

**Punto de divergencia**: PASO 11.

**Pasos:**

::

   PASO 11A (FA-01)  Backend NO crea Assignment.
                     User queda sin AGR.

   PASO 13A          AuditEvent payload incluye
                     {has_initial_agr: false}.

**Postcondiciones especiales:**

- ``Assignment.count() = 0`` para el nuevo user.
- En su primer login (UC_AUTH_01), FA-04
  detectara "User sin Assignments" y devolvera
  warning ``no_permissions`` al frontend.

4.2 FA-02: Colision de username (CNST-029 retry)
================================================

**Activador**: PASO 7 — el username generado
``ana.gomez.0001`` ya existe (multi-thread race
o timing).

**Justificacion**: la generacion no es atomica
con el INSERT. Otro request paralelo puede haber
creado el mismo username entre el SELECT COUNT
y el INSERT.

**Pasos:**

::

   PASO 10A (FA-02)  INSERT falla con
                     IntegrityError (UNIQUE
                     violation en username).

   PASO 7B           Backend reintenta:
                     incrementa contador y
                     regenera username
                     (ana.gomez.0002).

   PASO 10B          INSERT exitoso.

   PASO 13B          AuditEvent payload incluye
                     {username_retries: N}.

**Postcondiciones especiales:**

- Username final con sufijo > 1.
- Limite de retries: 5. Si excedido, EX-08.

4.3 FA-03: AGR no AGR-001..010 (custom)
=======================================

**Activador**: PASO 11 — el ``access_group_id``
provisto NO esta en el catalogo de AGR
predefinidos (AGR-001..010) sino es un AGR
custom creado via UC_PERM_05.

**Justificacion**: el sistema permite AGRs
custom; este caso solo cambia la fuente del AGR.

**Diferencia**: ninguna en el procesamiento. El
AuditEvent payload incluye
``access_group_type='custom'`` para
correlacionable con UC_PERM_*.

4.4 FA-04: Email con dominios externos
======================================

**Activador**: PASO 6 — el ``email`` provisto
es de un dominio externo a la organizacion
(ej. ``@gmail.com`` en vez de ``@empresa.com``).

**Justificacion**: politica configurable por
ADR. Default permite ambos; configuracion
strict prohibe externos.

**Diferencia segun setting**:

- Default permissive: continua sin cambios.
- Strict (``REQUIRE_CORPORATE_EMAIL=True``):
  rechaza con EX-09.

4.5 Resumen
===========

.. list-table::
 :widths: 12 35 30 23
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia clave
   - Status
 * - FA-01
   - Sin AGR
   - User sin Assignments
   - 201 OK
 * - FA-02
   - Colision username
   - Retry con sufijo + 1
   - 201 OK (lento)
 * - FA-03
   - AGR custom
   - AuditEvent metadata
   - 201 OK
 * - FA-04
   - Email externo
   - Segun setting
   - 201 OK / 400
