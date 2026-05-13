.. meta::
   :artefacto: BR_008
   :tipo: Business Rule
   :subtipo: Restriccion
   :modalidad: Deontica (Obligacion)
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-008:

==============================================================================
BR_008: Permisos Directos con Vencimiento
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   Los permisos directos asignados a un usuario (fuera del mecanismo
   de roles) DEBEN tener una fecha de vencimiento obligatoria.
   El sistema DEBE revocar automaticamente los permisos directos
   cuando expiran. El periodo maximo de vigencia es de 6 meses.

**Enunciado SBVR:**

   It is obligatory that direct permissions have an expiration date.
   Direct permissions must not exceed 6 months validity.
   The system must automatically revoke expired direct permissions.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Restriccion (Constraint)
   * - **Modalidad**
     - Deontica - Obligacion (Obligation)
   * - **Estatica/Dinamica**
     - Dinamica (periodo maximo puede ajustarse)

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Politica de Seguridad - Principio de Minimo Privilegio
   * - **Documento**
     - POL_002 Control de Acceso
   * - **Seccion**
     - 5.4 Permisos Excepcionales
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Principio de minimo privilegio:** Permisos excepcionales no
   deben convertirse en permanentes.

2. **Revision periodica:** Fuerza la revision de necesidad del
   permiso cada 6 meses maximo.

3. **Reduccion de riesgo:** Limita ventana de exposicion si el
   permiso ya no es necesario.

4. **Auditoria:** Facilita seguimiento de permisos excepcionales.

----

Contexto: Roles vs Permisos Directos
------------------------------------

.. code-block:: text

   PERMISOS VIA ROLES (mecanismo normal):
   - Usuario tiene roles
   - Roles tienen permisos
   - Permisos son permanentes mientras tenga el rol
   - Gestion mediante asignacion/revocacion de roles

   PERMISOS DIRECTOS (excepcional):
   - Permiso asignado directamente al usuario
   - Bypasea el mecanismo de roles
   - Usado para casos especiales o temporales
   - DEBE tener fecha de vencimiento (esta BR)

----

Modelo de Datos
---------------

.. code-block:: sql

   CREATE TABLE user_direct_permissions (
       id SERIAL PRIMARY KEY,
       user_id INTEGER NOT NULL REFERENCES users(id),
       permission_id INTEGER NOT NULL REFERENCES permissions(id),
       granted_by INTEGER NOT NULL REFERENCES users(id),
       granted_at TIMESTAMP DEFAULT NOW(),
       expires_at TIMESTAMP NOT NULL,
       reason TEXT NOT NULL,
       is_active BOOLEAN DEFAULT TRUE,
       revoked_at TIMESTAMP,
       revoked_by INTEGER REFERENCES users(id),
       revocation_reason VARCHAR(50),  -- 'EXPIRED', 'MANUAL', 'USER_INACTIVE'
       CONSTRAINT max_6_months CHECK (
           expires_at <= granted_at + INTERVAL '6 months'
       )
   );

----

Comportamiento del Sistema
--------------------------

Al Asignar Permiso Directo
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   1. Validar que expires_at es obligatorio
   2. Validar que expires_at <= NOW() + 6 meses
   3. Validar que reason es obligatorio
   4. Registrar granted_by (quien otorga)
   5. Crear registro con is_active = TRUE

Job de Revocacion Automatica
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Frecuencia: Diaria (01:30, despues del job de inactividad)

   1. Buscar permisos directos donde:
      - is_active = TRUE
      - expires_at < NOW()
   2. Para cada permiso encontrado:
      - Marcar is_active = FALSE
      - Registrar revoked_at = NOW()
      - Registrar revocation_reason = 'EXPIRED'
   3. Registrar en auditoria

----

Casos de Uso Afectados
----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Impacto de BR_008
   * - UC_042
     - Asignar Permiso Directo
     - Requiere fecha vencimiento
   * - UC_044
     - Consultar Permisos Efectivos
     - Incluye permisos directos vigentes

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-042.01
     - Sistema DEBE requerir fecha de vencimiento al asignar permiso directo
   * - FR-042.02
     - Sistema DEBE validar que vencimiento no exceda 6 meses
   * - FR-042.03
     - Sistema DEBE requerir justificacion al asignar permiso directo
   * - FR-042.04
     - Sistema DEBE registrar quien otorga el permiso
   * - FR-042.05
     - Sistema DEBE ejecutar job diario de revocacion de expirados
   * - FR-042.06
     - Sistema DEBE auditar revocaciones automaticas
   * - FR-044.01
     - Sistema DEBE incluir permisos directos vigentes en calculo efectivo

----

Implementacion Tecnica
----------------------

Servicio de Permisos Directos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # services/direct_permissions.py
   from datetime import timedelta
   from django.utils import timezone

   class DirectPermissionService:

       MAX_VALIDITY_DAYS = 180  # 6 meses

       def grant(self, user_id, permission_id, expires_at, reason, granted_by):
           """
           BR_008: Permisos directos con vencimiento obligatorio
           """
           # Validar fecha de vencimiento obligatoria
           if not expires_at:
               raise ValidationError("Fecha de vencimiento es obligatoria")

           # Validar maximo 6 meses
           max_expiry = timezone.now() + timedelta(days=self.MAX_VALIDITY_DAYS)
           if expires_at > max_expiry:
               raise ValidationError(
                   f"Vencimiento no puede exceder {self.MAX_VALIDITY_DAYS} dias"
               )

           # Validar justificacion
           if not reason or len(reason) < 10:
               raise ValidationError("Justificacion es obligatoria (min 10 chars)")

           return UserDirectPermission.objects.create(
               user_id=user_id,
               permission_id=permission_id,
               expires_at=expires_at,
               reason=reason,
               granted_by_id=granted_by
           )

Job de Revocacion
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # tasks/revoke_expired_permissions.py

   def revoke_expired_direct_permissions():
       """
       BR_008: Revocar automaticamente permisos directos expirados
       """
       expired = UserDirectPermission.objects.filter(
           is_active=True,
           expires_at__lt=timezone.now()
       )

       count = expired.update(
           is_active=False,
           revoked_at=timezone.now(),
           revocation_reason='EXPIRED'
       )

       # Auditar
       for perm in expired:
           AuditLog.objects.create(
               action='DIRECT_PERMISSION_EXPIRED',
               target_user_id=perm.user_id,
               details=f"Permission {perm.permission_id} expired"
           )

       return f"Permisos revocados: {count}"

----

Parametros Configurables
------------------------

.. list-table::
   :widths: 30 20 50

   * - Parametro
     - Valor Default
     - Descripcion
   * - MAX_VALIDITY_DAYS
     - 180
     - Maximo dias de vigencia (6 meses)
   * - JOB_HOUR
     - 01:30
     - Hora de ejecucion del job
   * - MIN_REASON_LENGTH
     - 10
     - Caracteres minimos en justificacion

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. No se puede crear permiso directo sin fecha de vencimiento
2. No se puede crear permiso directo con vencimiento > 6 meses
3. No se puede crear permiso directo sin justificacion
4. Job diario revoca permisos expirados
5. Permisos revocados no aparecen en permisos efectivos

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`br-006` - BR_006 RBAC Flat NIST
- :ref:`cnst-005` - CNST_005 Seguridad DRF
- UC_042 - Asignar Permiso Directo
- UC_044 - Consultar Permisos Efectivos

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
     - Version inicial aprobada

----

**Trazabilidad:**

- Origen: POL_002 Control de Acceso
- Implementa: CNST_005 (parcialmente)
- Influye: UC_042, UC_044
- Deriva: FR-042.01 a FR-042.06, FR-044.01
