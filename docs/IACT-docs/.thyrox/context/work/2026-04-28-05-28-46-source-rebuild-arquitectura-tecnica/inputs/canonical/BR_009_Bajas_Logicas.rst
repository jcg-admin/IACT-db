.. meta::
   :artefacto: BR_009
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

.. _br-009:

==============================================================================
BR_009: Bajas Siempre Logicas
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   El sistema NO DEBE eliminar fisicamente registros de usuarios,
   roles asignados, ni permisos. Toda "eliminacion" DEBE ser una
   baja logica mediante cambio de estado (soft delete).

**Enunciado SBVR:**

   It is prohibited that the system physically deletes user records.
   All deletions must be logical (soft delete) via status change.

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
     - Estatica (requerimiento de auditoria)

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Politica de Retencion de Datos, Auditoria
   * - **Documento**
     - POL_001 Seguridad de la Informacion
   * - **Seccion**
     - 8.1 Retencion y Eliminacion de Datos
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Auditoria:** Permite rastrear historico completo de accesos
   y acciones de usuarios eliminados.

2. **Integridad referencial:** Evita registros huerfanos en tablas
   de auditoria y logs.

3. **Recuperacion:** Permite reactivar usuarios dados de baja
   por error.

4. **Compliance:** Requerimiento comun en normativas de retencion
   de datos.

----

Implementacion
--------------

Campo de Estado
^^^^^^^^^^^^^^^

.. code-block:: sql

   -- Tabla users
   ALTER TABLE users ADD COLUMN estado VARCHAR(20) DEFAULT 'ACTIVO';
   ALTER TABLE users ADD COLUMN deleted_at TIMESTAMP NULL;
   ALTER TABLE users ADD COLUMN deleted_by INTEGER REFERENCES users(id);

   -- Estados posibles
   -- ACTIVO: Usuario operativo
   -- INACTIVO: Sin actividad 90 dias (BR_003)
   -- BLOQUEADO: Bloqueado por seguridad
   -- ELIMINADO: Baja logica (soft delete)

Operacion de "Eliminacion"
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # services/users.py

   class UserService:

       def delete(self, user_id, deleted_by):
           """
           BR_009: Baja logica, nunca fisica
           """
           user = User.objects.get(id=user_id)

           # NO HACER: user.delete()  # Prohibido por BR_009

           # HACER: Baja logica
           user.estado = 'ELIMINADO'
           user.deleted_at = timezone.now()
           user.deleted_by_id = deleted_by
           user.save()

           # Invalidar sesiones activas
           Session.objects.filter(user_id=user_id, is_active=True).update(
               is_active=False,
               invalidated_by='USER_DELETED'
           )

           return user

QuerySet por Defecto
^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # models/managers.py

   class ActiveUserManager(models.Manager):
       """Manager que excluye usuarios eliminados por defecto"""

       def get_queryset(self):
           return super().get_queryset().exclude(estado='ELIMINADO')

   class User(models.Model):
       # ... campos ...

       objects = ActiveUserManager()  # Por defecto excluye eliminados
       all_objects = models.Manager()  # Incluye eliminados (para admin)

----

Entidades Afectadas
-------------------

.. list-table::
   :header-rows: 1
   :widths: 25 25 50

   * - Entidad
     - Campo Estado
     - Comportamiento
   * - users
     - estado
     - Soft delete, excluir de queries normales
   * - user_roles
     - is_active
     - Desactivar, no eliminar
   * - user_direct_permissions
     - is_active
     - Desactivar, no eliminar
   * - roles
     - is_active
     - Desactivar, no eliminar (catalogo)
   * - sessions
     - is_active
     - Invalidar, no eliminar

----

Casos de Uso Afectados
----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Impacto de BR_009
   * - UC_008
     - Baja Usuario
     - Cambia estado a ELIMINADO
   * - UC_009
     - Listar Usuarios
     - Por defecto excluye ELIMINADO
   * - UC_010
     - Asignar Roles
     - Revoca, no elimina registro

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-008.01
     - Sistema NO DEBE ejecutar DELETE fisico en tabla users
   * - FR-008.02
     - Sistema DEBE cambiar estado a ELIMINADO en baja de usuario
   * - FR-008.03
     - Sistema DEBE registrar fecha y responsable de eliminacion
   * - FR-008.04
     - Sistema DEBE invalidar sesiones del usuario eliminado
   * - FR-009.01
     - Sistema DEBE excluir usuarios ELIMINADO de listados por defecto
   * - FR-009.02
     - Sistema DEBE permitir a admin ver usuarios eliminados

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. No existe sentencia DELETE en codigo para tabla users
2. Baja de usuario cambia estado a ELIMINADO
3. Usuario eliminado no aparece en listados normales
4. Admin puede ver usuarios eliminados con filtro especial
5. Registros de auditoria del usuario eliminado se mantienen

Verificacion en Codigo
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   # Buscar DELETE prohibidos
   grep -r "\.delete()" --include="*.py" | grep -i user
   # Resultado esperado: Ninguno o solo en tests

----

Excepciones
-----------

Esta BR NO tiene excepciones para datos de usuarios.

Para datos transaccionales de gran volumen (logs tecnicos muy
antiguos), puede aplicarse politica de archivado separada
documentada en POL_001 seccion 8.2.

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`br-003` - BR_003 Usuario Inactivo 90 dias
- :ref:`br-010` - BR_010 Auditoria Inmutable
- :ref:`cnst-005` - CNST_005 Seguridad DRF
- UC_008 - Baja Usuario

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

- Origen: POL_001 Seguridad de la Informacion
- Implementa: CNST_005 (parcialmente)
- Influye: UC_008, UC_009, UC_010
- Deriva: FR-008.01 a FR-008.04, FR-009.01, FR-009.02
