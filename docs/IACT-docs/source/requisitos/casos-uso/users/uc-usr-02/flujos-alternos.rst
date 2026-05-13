.. _uc-usr-02-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Listado vacio
========================

**Activador**: filtros aplicados no matchean
ningun User.

**Diferencia**: Backend retorna 200 OK con
``count=0, results=[], next=null,
previous=null``.

**Frontend**: muestra estado "Sin resultados" con
sugerencia de relajar filtros.

4.2 FA-02: Filtrado por user_id especifico (audit)
==================================================

**Activador**: query param ``?user_id=42``.

**Justificacion**: caso de investigacion. Audit
selectivo P-16 aplica.

**Diferencia**: PASO 8 emite AuditEvent
``USERS_VIEWED_FOR_USER`` con
``payload.target_user_id``.

4.3 FA-03: Filtrado por AGR
===========================

**Activador**: query param ``?access_group_id=6``.

**Diferencia**: query agrega JOIN con Assignment
WHERE ``access_group_id`` y ``state='ACTIVE'``.

NO se audita (lectura amplia, no focalizada).

4.4 FA-04: Ordenamiento por columna
===================================

**Activador**: query param ``?ordering=-last_login_at``
(prefijo ``-`` para descendente).

**Diferencia**: backend valida que la columna sea
permitida (whitelist) — anti-SQLi.

4.5 FA-05: Vista detalle de usuario inactivo
============================================

**Activador**: PASO 4 sub-flujo 3.B — User existe
con ``state != 'ACTIVE'``.

**Diferencia**: respuesta incluye flag
``is_inactive=true`` para que la UI muestre
indicador visual. AuditEvent payload incluye
``target_user_state``.

4.6 FA-06: Vista detalle del propio invocante
=============================================

**Activador**: PASO 4 sub-flujo 3.B — el
``user_id`` consultado coincide con el invocante.

**Diferencia**: 200 OK normal, sin restricciones
adicionales. AuditEvent payload incluye
``self_view=true`` para distinguir de vistas a
terceros.

4.7 Resumen
===========

.. list-table::
 :widths: 12 40 30 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia clave
   - Status
 * - FA-01
   - Sin matches
   - results=[], count=0
   - 200 OK
 * - FA-02
   - Filter user_id
   - Audit USERS_VIEWED_FOR_USER
   - 200 OK
 * - FA-03
   - Filter AGR
   - JOIN Assignment, sin audit
   - 200 OK
 * - FA-04
   - Ordering
   - Whitelist anti-SQLi
   - 200 OK
 * - FA-05
   - User inactivo
   - Flag visual
   - 200 OK
 * - FA-06
   - Self-view
   - Audit self_view=true
   - 200 OK
