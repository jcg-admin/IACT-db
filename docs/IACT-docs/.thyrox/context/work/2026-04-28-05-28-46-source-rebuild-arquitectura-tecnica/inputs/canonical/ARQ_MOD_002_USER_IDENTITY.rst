.. =============================================================================
.. ARQ_MOD_002_USER_IDENTITY.rst
.. Modulo Funcional: Gestion de Identidades y Cuentas de Usuario
.. Version: 1.0.0
.. =============================================================================

====================================================
ARQ_MOD_002: Gestion de Identidades (USER_IDENTITY)
====================================================

.. metadata::
   :id: ARQ_MOD_002
   :codigo: USER_IDENTITY
   :nombre: Gestion de Identidades y Cuentas de Usuario
   :version: 1.0.0
   :estado: APROBADO
   :fecha_creacion: 2025-12-22

.. contents:: Contenido
   :local:
   :depth: 2

----

1. Proposito
============

El modulo USER_IDENTITY gestiona el **ciclo de vida de las cuentas de usuario**:
alta, modificacion, baja logica, y datos de perfil.

**Pregunta clave que responde:**

   *"¿Que usuarios existen y con que atributos/relaciones?"*

**NO responde:** *"¿Que pueden hacer?"* - Eso es ARQ_MOD_003_RBAC_CORE.

----

2. Alcance
==========

2.1 Incluye
-----------

- Alta de usuarios (username autogenerado, estado PENDIENTE_CONFIGURACION)
- Modificacion de datos basicos (nombre, apellidos, unidad organizacional)
- Baja logica de usuarios (deleted_at, deleted_by, conservar para auditoria)
- Gestion de preguntas de seguridad (minimo 3 preguntas)
- Consulta de perfil de usuario
- Asociacion usuario-roles como **relacion** (no como logica)

2.2 Excluye (NO incluye)
------------------------

- Calculo de permisos efectivos → **ARQ_MOD_003_RBAC_CORE**
- Definicion de catalogos de roles/permisos → **ARQ_MOD_003_RBAC_CORE**
- Validacion de SoD (conflicto de roles) → **ARQ_MOD_003_RBAC_CORE**
- Autenticacion (login/logout) → **ARQ_MOD_001_AUTH**

----

3. Responsabilidades
====================

3.1 PUEDE Hacer
---------------

.. list-table::
   :widths: 60 20 20
   :header-rows: 1

   * - Responsabilidad
     - UC Relacionado
     - CNST
   * - Crear cuenta con username autogenerado
     - UC_006
     - CNST_005
   * - Asignar estado inicial PENDIENTE_CONFIGURACION
     - UC_006
     - -
   * - Generar contrasena temporal
     - UC_006
     - CNST_001
   * - Actualizar nombre, apellidos, unidad organizacional
     - UC_007
     - -
   * - Cambiar estado del usuario (ACTIVO, INACTIVO, BLOQUEADO)
     - UC_007
     - -
   * - Ejecutar baja logica (soft delete)
     - UC_008
     - CNST_009
   * - Almacenar deleted_at, deleted_by
     - UC_008
     - CNST_009
   * - Gestionar preguntas de seguridad (min 3)
     - UC_009
     - CNST_001
   * - Mostrar perfil con roles asignados
     - UC_010
     - -
   * - Asociar usuario con roles (relacion M:N)
     - UC_007
     - -

3.2 NO PUEDE Hacer (Violaciones)
--------------------------------

.. warning::

   Las siguientes acciones **violan la separacion de responsabilidades**:

- **Calcular permisos efectivos**
  
  - Ejemplo: "Si tiene rol X y segmento Y, puede acceder a Z"
  - Eso es responsabilidad de → **ARQ_MOD_003_RBAC_CORE**

- **Validar conflictos de roles (SoD)**
  
  - Ejemplo: "No puede tener rol A y rol B simultaneamente"
  - Eso es responsabilidad de → **ARQ_MOD_003_RBAC_CORE**

- **Definir catalogos de permisos**
  
  - Los enums y catalogos de permisos van en RBAC_CORE
  - Eso es responsabilidad de → **ARQ_MOD_003_RBAC_CORE**

- **Implementar logica de precedencia**
  
  - Directo > Rol > Segmento
  - Eso es responsabilidad de → **ARQ_MOD_003_RBAC_CORE**

----

4. Dependencias
===============

4.1 Depende de
--------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_003_RBAC_CORE
     - Para mostrar roles en perfil (solo lectura)

4.2 Es Requerido por
--------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_001_AUTH
     - Valida que usuario existe y esta activo
   * - ARQ_MOD_003_RBAC_CORE
     - Calcula permisos sobre el usuario
   * - ARQ_MOD_007_AUDIT
     - Registra cambios en usuarios

----

5. Componentes Tecnicos
=======================

5.1 Apps Django
---------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - App
     - Descripcion
   * - apps.users
     - Modelos User, SecurityQuestion, vistas de gestion

5.2 Modelos de Datos
--------------------

- **DSC_MOD_001_User** - Usuario del sistema

.. code-block:: python

   class User(AbstractBaseUser):
       username = models.CharField(max_length=50, unique=True)
       first_name = models.CharField(max_length=100)
       last_name = models.CharField(max_length=100)
       organizational_unit = models.CharField(max_length=100)
       status = models.CharField(choices=USER_STATUS_CHOICES)
       created_at = models.DateTimeField(auto_now_add=True)
       updated_at = models.DateTimeField(auto_now=True)
       deleted_at = models.DateTimeField(null=True, blank=True)
       deleted_by = models.ForeignKey('self', null=True)
       
   class SecurityQuestion(models.Model):
       user = models.ForeignKey(User)
       question = models.CharField(max_length=200)
       answer_hash = models.CharField(max_length=128)

5.3 APIs Expuestas
------------------

- **API_002_Users_Endpoints**

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - Metodo
     - Endpoint
     - Descripcion
   * - POST
     - /api/v1/users
     - Crear usuario
   * - GET
     - /api/v1/users/{id}
     - Obtener usuario
   * - PUT
     - /api/v1/users/{id}
     - Actualizar usuario
   * - DELETE
     - /api/v1/users/{id}
     - Baja logica
   * - GET
     - /api/v1/users/{id}/profile
     - Perfil completo
   * - PUT
     - /api/v1/users/{id}/security-questions
     - Gestionar preguntas

----

6. Restricciones Aplicables
===========================

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - CNST
     - Descripcion y Aplicacion
   * - CNST_001
     - **Comunicaciones Prohibidas**: Preguntas de seguridad obligatorias 
       (no hay email para recuperacion).
   * - CNST_009
     - **Logging Auditoria**: Baja logica, nunca eliminacion fisica. 
       Conservar datos para auditoria.

----

7. Casos de Uso Asociados
=========================

.. list-table::
   :widths: 12 40 48
   :header-rows: 1

   * - UC ID
     - Nombre
     - Descripcion
   * - UC_006
     - Crear_Cuenta_Usuario
     - Alta con username autogenerado, estado inicial
   * - UC_007
     - Actualizar_Datos_Usuario
     - Modificar nombre, apellidos, unidad, estado
   * - UC_008
     - Baja_Logica_Usuario
     - Soft delete con deleted_at/by
   * - UC_009
     - Gestionar_Preguntas_Seguridad
     - Alta/cambio de min 3 preguntas
   * - UC_010
     - Consultar_Perfil_Usuario
     - Ver datos basicos y roles asignados

----

8. Requisitos Funcionales Derivados
===================================

.. list-table::
   :widths: 12 45 20 23
   :header-rows: 1

   * - FR ID
     - Nombre
     - Deriva de
     - Descripcion
   * - FR_006
     - Generar_Username_Automatico
     - UC_006
     - Patron: inicial + apellido + numero
   * - FR_007
     - Validar_Datos_Usuario
     - UC_007
     - Campos obligatorios, formatos
   * - FR_008
     - Ejecutar_Baja_Logica
     - UC_008
     - Soft delete, no hard delete
   * - FR_009
     - Almacenar_Preguntas_Seguridad
     - UC_009
     - Hash de respuestas, min 3
   * - FR_010
     - Cargar_Perfil_Usuario
     - UC_010
     - Incluir roles desde RBAC

----

9. Estados del Usuario
======================

.. code-block:: text

   +------------------------+
   |  PENDIENTE_CONFIGURACION|
   +------------+-----------+
                |
                | (completa preguntas seguridad)
                v
   +------------+-----------+
   |         ACTIVO         |
   +------------+-----------+
                |
        +-------+-------+
        |               |
        v               v
   +----+----+    +-----+-----+
   | INACTIVO|    | BLOQUEADO |
   +---------+    +-----------+
        |               |
        +-------+-------+
                |
                v
   +------------+-----------+
   |         ACTIVO         | (reactivacion)
   +------------------------+

----

10. Historial de Cambios
========================

.. list-table::
   :widths: 12 15 73
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 1.0.0
     - 2025-12-22
     - Version inicial

----

*Documento de Arquitectura - ARQ_MOD_002_USER_IDENTITY*
*Proyecto IACT Dashboard Analytics*
*Version 1.0.0*
