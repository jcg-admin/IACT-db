.. _uc-acc-05-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

UC_ACC_05 tiene **4 sub-flujos**:

- **3.A** Listar reglas SoD (lectura)
- **3.B** Crear nueva regla SoD (CRUD)
- **3.C** Modificar regla SoD (CRUD)
- **3.D** Retirar regla SoD (CRUD)

3.A Sub-flujo: Listar
=====================

3.A.1 Pasos
-----------

::

   PASO 1   GET /api/access/sod-rules/?...    (FE → BE)
   PASO 2   Validar JWT + view_separation_rules (Backend)
   PASO 3   Construir query (filter, paginate) (Backend)
   PASO 4   SELECT SoDRule con paginacion      (BE → BD)
   PASO 5   Audit selectivo P-16 si rule_id    (BE → BD)
   PASO 6   200 OK con lista                   (BE → FE)

3.A.2 Filtros
-------------

``state``, ``rule_id``,
``includes_function_id``, ordering.

3.B Sub-flujo: Crear
====================

3.B.1 Pasos
-----------

::

   PASO 1   POST /api/access/sod-rules/         (FE → BE)
   PASO 2   Validar JWT + manage_separation_rules
   PASO 3   Validar payload
            (functions, name, description)
   PASO 4   Validar funciones existen + ACTIVE
   PASO 5   Validar no duplica regla ACTIVE
   PASO 6   INSERT SoDRule
   PASO 7   Invalidar cache de reglas ACTIVE
            (post-COMMIT)
   PASO 8   Emitir AuditEvent SOD_RULE_CREATED
   PASO 9   201 Created

3.B.2 Validacion de no-duplicado
--------------------------------

::

   existing = SoDRuleRepository
     .find_active_with_same_functions(
       payload.function_ids)
   if existing is not None:
       raise SoDRuleAlreadyExists(existing.id)

Defensa contra reglas redundantes que pueden
generar mensajes de error duplicados al
usuario.

3.C Sub-flujo: Modificar
========================

3.C.1 Pasos
-----------

::

   PASO 1   PATCH /api/access/sod-rules/{id}/   (FE → BE)
   PASO 2   Validar JWT + manage_separation_rules
   PASO 3   Validar payload (campos modificables)
   PASO 4   Localizar SoDRule
   PASO 5   Aplicar PATCH parcial
   PASO 6   Invalidar cache (post-COMMIT)
   PASO 7   Emitir AuditEvent SOD_RULE_MODIFIED
   PASO 8   200 OK

3.C.2 Campos modificables
-------------------------

- ``display_name``
- ``description``
- ``severity`` (informativo)
- (Restringido) ``function_ids``: cambio
  re-evalua impact retroactivo. Politica:
  prohibir o requerir migracion explicita
  via ``RETIRE old`` + ``CREATE new``.

3.D Sub-flujo: Retirar
======================

3.D.1 Pasos
-----------

::

   PASO 1   DELETE /api/access/sod-rules/{id}/  (FE → BE)
   PASO 2   Validar JWT + manage_separation_rules
   PASO 3   Validar regla existe + ACTIVE
   PASO 4   UPDATE state=RETIRED + metadata
            (retire_reason obligatorio)
   PASO 5   Invalidar cache (post-COMMIT)
   PASO 6   Emitir AuditEvent SOD_RULE_RETIRED
   PASO 7   200 OK

3.D.2 Justificacion
-------------------

Retirar una regla NO es DELETE — la regla
permanece en historial. UC_ACC_03 puede
mostrar reglas RETIRED para investigacion
historica.

3.E Datos comunes
=================

- HTTPS, JWT (CNST-009).
- RBAC granular (P-15).
- AuditEvent obligatorio (CNST-025).
- Cache invalidation post-COMMIT (P-29).
