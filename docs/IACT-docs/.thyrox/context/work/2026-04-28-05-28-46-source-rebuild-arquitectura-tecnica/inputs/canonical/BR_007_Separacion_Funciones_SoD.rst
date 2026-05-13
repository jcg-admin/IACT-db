.. meta::
   :artefacto: BR_007
   :tipo: Business Rule
   :subtipo: Restriccion
   :modalidad: Deontica (Prohibicion)
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-007:

==============================================================================
BR_007: Separacion de Funciones (SoD)
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   Ciertos pares de roles son mutuamente excluyentes y NO PUEDEN
   ser asignados simultaneamente al mismo usuario. El sistema DEBE
   validar y rechazar asignaciones que violen estas restricciones
   de Separacion de Funciones (Separation of Duties - SoD).

**Enunciado SBVR:**

   It is prohibited that a user has both roles of a conflicting role pair.
   The system must reject role assignments that violate SoD constraints.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Restriccion (Constraint)
   * - **Modalidad**
     - Deontica - Prohibicion (Prohibition)
   * - **Estatica/Dinamica**
     - Estatica (regla de seguridad fundamental)

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - NIST RBAC Level 2, Politica de Seguridad
   * - **Documento**
     - POL_002 Control de Acceso
   * - **Seccion**
     - 6.2 Separacion de Funciones
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Prevencion de fraude:** Evita que una persona tenga control
   completo sobre procesos criticos.

2. **Control interno:** Principio de los cuatro ojos - acciones
   criticas requieren mas de una persona.

3. **Compliance:** Requerimiento comun en auditorias de seguridad
   y compliance (SOX, ISO 27001).

4. **Reduccion de riesgo:** Limita el dano potencial de una cuenta
   comprometida.

----

Pares de Roles Conflictivos
---------------------------

Tabla de Conflictos
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 20 60

   * - Rol A
     - Rol B
     - Razon del Conflicto
   * - R016 (SYSTEM_ADMIN)
     - R017 (AUDIT_VIEWER)
     - Admin no debe auditar sus propias acciones
   * - R007 (REPORTS_CREATOR)
     - R005 (REPORTS_EXPORTER)
     - Quien crea no debe exportar sin revision
   * - R001 (USERS_FULL_MANAGER)
     - R018 (SECURITY_ADMIN)
     - Gestion usuarios separada de seguridad

Representacion en BD
^^^^^^^^^^^^^^^^^^^^

.. code-block:: sql

   CREATE TABLE role_conflicts (
       id SERIAL PRIMARY KEY,
       role_a_id INTEGER NOT NULL REFERENCES roles(id),
       role_b_id INTEGER NOT NULL REFERENCES roles(id),
       reason TEXT NOT NULL,
       created_at TIMESTAMP DEFAULT NOW(),
       CONSTRAINT unique_conflict UNIQUE (role_a_id, role_b_id),
       CONSTRAINT different_roles CHECK (role_a_id <> role_b_id)
   );

   -- Datos iniciales
   INSERT INTO role_conflicts (role_a_id, role_b_id, reason) VALUES
   (16, 17, 'Admin no debe auditar sus propias acciones'),
   (7, 5, 'Creador de reportes no debe exportar sin revision'),
   (1, 18, 'Gestion de usuarios separada de seguridad');

----

Comportamiento del Sistema
--------------------------

Validacion al Asignar Rol
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PROCESO: Asignar rol R_nuevo a usuario U

   1. Obtener roles actuales de U: [R1, R2, ..., Rn]

   2. Para cada rol Ri en roles actuales:
      - Verificar si existe conflicto (R_nuevo, Ri) o (Ri, R_nuevo)
      - Si existe conflicto: RECHAZAR asignacion

   3. Si no hay conflictos: PERMITIR asignacion

Mensaje de Error
^^^^^^^^^^^^^^^^

.. code-block:: text

   Error 409 Conflict:
   {
     "error": "SOD_VIOLATION",
     "message": "No se puede asignar rol AUDIT_VIEWER porque
                 el usuario ya tiene rol SYSTEM_ADMIN.
                 Estos roles son mutuamente excluyentes.",
     "conflict": {
       "existing_role": "SYSTEM_ADMIN",
       "requested_role": "AUDIT_VIEWER",
       "reason": "Admin no debe auditar sus propias acciones"
     }
   }

----

Casos de Uso Afectados
----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Impacto de BR_007
   * - UC_010
     - Asignar Roles
     - Paso de validacion SoD
   * - UC_043
     - Configurar SoD
     - Admin define pares conflictivos
   * - UC_011
     - Gestionar Permisos por Rol
     - No afectado directamente

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-010.06
     - Sistema DEBE validar SoD antes de asignar rol
   * - FR-010.07
     - Sistema DEBE rechazar asignacion si viola SoD
   * - FR-010.08
     - Sistema DEBE mostrar mensaje con motivo del conflicto
   * - FR-043.01
     - Sistema DEBE permitir definir pares de roles conflictivos
   * - FR-043.02
     - Sistema DEBE validar que pares sean roles diferentes
   * - FR-043.03
     - Sistema DEBE auditar cambios en tabla role_conflicts

----

Implementacion Tecnica
----------------------

Servicio de Validacion SoD
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # services/sod.py

   class SoDService:

       def validate_role_assignment(self, user_id, new_role_id):
           """
           BR_007: Validar Separacion de Funciones

           Returns:
               (True, None) si no hay conflicto
               (False, conflict_info) si hay conflicto
           """
           # Obtener roles actuales del usuario
           current_roles = UserRole.objects.filter(
               user_id=user_id
           ).values_list('role_id', flat=True)

           # Verificar conflictos
           conflict = RoleConflict.objects.filter(
               Q(role_a_id=new_role_id, role_b_id__in=current_roles) |
               Q(role_b_id=new_role_id, role_a_id__in=current_roles)
           ).first()

           if conflict:
               return False, {
                   'existing_role': self._get_role_name(
                       conflict.role_a_id if conflict.role_a_id in current_roles
                       else conflict.role_b_id
                   ),
                   'requested_role': self._get_role_name(new_role_id),
                   'reason': conflict.reason
               }

           return True, None

Integracion en Asignacion de Rol
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # views/roles.py

   class RoleAssignmentView(APIView):

       def post(self, request, user_id):
           role_id = request.data['role_id']

           # BR_007: Validar SoD
           sod_service = SoDService()
           is_valid, conflict = sod_service.validate_role_assignment(
               user_id, role_id
           )

           if not is_valid:
               return Response(
                   {
                       'error': 'SOD_VIOLATION',
                       'message': f"Conflicto SoD detectado",
                       'conflict': conflict
                   },
                   status=status.HTTP_409_CONFLICT
               )

           # Proceder con asignacion
           UserRole.objects.create(user_id=user_id, role_id=role_id)
           return Response({'status': 'assigned'}, status=201)

----

Tipo de SoD Implementado
------------------------

.. code-block:: text

   SoD ESTATICO (implementado):
   - Se valida al momento de asignar rol
   - Si hay conflicto, se rechaza la asignacion
   - Usuario nunca puede tener ambos roles simultaneamente

   SoD DINAMICO (no implementado):
   - Usuario puede tener ambos roles
   - No puede ACTIVAR ambos en la misma sesion
   - Mas complejo, no requerido para IACT

----

Restricciones Tecnicas Relacionadas
-----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - CNST
     - Nombre
     - Relacion
   * - CNST_005
     - Seguridad DRF Checklist
     - Define requerimiento SoD

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. Tabla role_conflicts existe con pares definidos
2. Asignacion de rol conflictivo es rechazada
3. Mensaje de error indica roles en conflicto
4. Admin puede consultar y modificar pares conflictivos

Casos de Prueba
^^^^^^^^^^^^^^^

.. code-block:: text

   TEST_001: SoD - Asignacion permitida
   - Usuario sin roles
   - Asignar REPORTS_VIEWER
   - Resultado: OK

   TEST_002: SoD - Conflicto detectado
   - Usuario con SYSTEM_ADMIN
   - Intentar asignar AUDIT_VIEWER
   - Resultado: 409 Conflict, mensaje SoD

   TEST_003: SoD - Orden inverso
   - Usuario con AUDIT_VIEWER
   - Intentar asignar SYSTEM_ADMIN
   - Resultado: 409 Conflict (bidireccional)

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`br-006` - BR_006 RBAC Flat NIST
- :ref:`mtm-03` - MTM_03 Metamodelo RBAC
- :ref:`cnst-005` - CNST_005 Seguridad DRF
- UC_010 - Asignar Roles
- UC_043 - Configurar SoD

Fuentes Externas
^^^^^^^^^^^^^^^^

- NIST RBAC Level 2 (Constrained RBAC)
- ISO 27001 - Segregation of Duties

----

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-03
     - Equipo IACT
     - Version inicial con 3 pares conflictivos

----

**Trazabilidad:**

- Origen: NIST RBAC Level 2, POL_002
- Implementa: CNST_005 (parcialmente)
- Influye: UC_010, UC_043
- Deriva: FR-010.06 a FR-010.08, FR-043.01 a FR-043.03
