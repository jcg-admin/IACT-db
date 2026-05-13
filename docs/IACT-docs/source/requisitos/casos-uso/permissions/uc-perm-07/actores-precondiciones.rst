.. _uc-perm-07-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Actor
   - Tipo
   - Rol
 * - **Caller interno**
   - Sistema
   - Decorator / middleware /
     permission class — invoca al servicio.
 * - **User con funcion**
     ``view_assignments``
   - Humano
   - Auditor / soporte — consulta via
     endpoint admin.
 * - **AuthService**
   - Sistema
   - Aporta el ``invoker`` autenticado
     (caller) en el caso admin.
 * - **PermissionCache**
   - Sistema
   - Cache de ``effective_set`` por User.

2.2 Precondiciones
==================

**Comunes:**

- Existe el User cuyo permiso se verifica.
- Existe el ``function_code`` solicitado.
- BD accesible.

**Variante admin endpoint:**

- Caller autenticado (JWT valido).
- Caller tiene
  ``view_assignments`` activa.
- Si funcion verificada es de otro
  segmento, se respeta CNST-008
  (no exfiltrar membresia cross-segmento sin
  permiso).

**Variante interna:**

- Caller (decorator) ya valido la sesion del
  User cuya accion se chequea.
- ``function_code`` declarada en el handler.

2.3 Postcondiciones
===================

**En cualquier caso:**

- Estado de la BD **sin cambios**
  (operacion read-only).
- ``PermissionCache`` puede haberse poblado
  para futuras consultas.

**Si origen = REVOKED_EXCEPTIONAL:**

- ``allowed = false`` aun si el User esta en
  AGRs que otorgan la funcion.

**Si origen = GRANTED_EXCEPTIONAL:**

- ``allowed = true`` aun si el User no esta
  en ningun AGR que la otorgue.

**Si origen = GRANTED_BY_AGR:**

- ``allowed = true``.
- Response detalla AGR(s) responsables
  (informativo).

**Si origen = DENIED_NO_GRANT:**

- ``allowed = false``.

2.4 Datos de entrada
====================

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Notas
 * - ``user_id``
   - int
   - Obligatorio
 * - ``function_code``
   - string
   - Obligatorio. Codigo canonico
     (``snake_case``).
 * - ``invoker``
   - identity
   - Para admin endpoint solo.
 * - ``context``
   - object
   - request_id, source (decorator|middleware|
     admin), trace_id.

2.5 Datos de salida
===================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Campo
   - Notas
 * - ``user_id``
   - eco
 * - ``function_code``
   - eco
 * - ``allowed``
   - bool
 * - ``origin``
   - enum
     (REVOKED_EXCEPTIONAL,
     GRANTED_EXCEPTIONAL,
     GRANTED_BY_AGR,
     DENIED_NO_GRANT)
 * - ``via_agr_codes``
   - lista de AGR codes (solo si
     GRANTED_BY_AGR)
 * - ``valid_until``
   - timestamp si la concesion / revocacion
     tiene expiracion
 * - ``cache``
   - bool — true si retornado de cache
 * - ``checked_at``
   - timestamp
