.. =============================================================================
.. ARQ_MOD_003_RBAC_CORE.rst
.. Modulo Funcional: Administracion de Roles, Segmentos y Permisos
.. Version: 1.0.0
.. =============================================================================

=========================================================
ARQ_MOD_003: Roles, Segmentos y Permisos (RBAC_CORE)
=========================================================

.. metadata::
   :id: ARQ_MOD_003
   :codigo: RBAC_CORE
   :nombre: Administracion de Roles, Segmentos y Permisos
   :version: 1.0.0
   :estado: APROBADO
   :fecha_creacion: 2025-12-22

.. contents:: Contenido
   :local:
   :depth: 2

----

1. Proposito
============

El modulo RBAC_CORE es el **nucleo de control de acceso** del sistema IACT.
Define roles, permisos, segmentos de datos, y calcula los permisos efectivos
de cada usuario.

**Pregunta clave que responde:**

   *"¿Que puede hacer este usuario en este modulo, sobre que datos?"*

**Incluye enforcers de seguridad** (lo que antes era SEC_RULES) como
validaciones internas del RBAC.

----

2. Alcance
==========

2.1 Incluye
-----------

- Catalogo de roles funcionales (R001-R017)
- Catalogo de permisos (view, export, create, edit, delete, etc.)
- Segmentos de datos (por centro, servicio, region)
- Calculo de permisos efectivos (precedencia: Directo > Rol > Segmento)
- Reglas SoD (Separation of Duties - conflicto entre roles)
- Simulacion de acceso ("que veria este usuario?")
- Matriz consolidada de roles/permisos (vista PMO)
- **Enforcers de seguridad** (middleware, decoradores, policies)

2.2 Excluye (NO incluye)
------------------------

- Autenticacion (login/logout) → **ARQ_MOD_001_AUTH**
- Gestion de datos de usuario → **ARQ_MOD_002_USER_IDENTITY**
- UI de reportes/dashboards → **ARQ_MOD_005_VIS_REPORTS**
- Logica de negocio IVR → **ARQ_MOD_005_VIS_REPORTS**

----

3. Responsabilidades
====================

3.1 PUEDE Hacer
---------------

.. list-table::
   :widths: 55 20 25
   :header-rows: 1

   * - Responsabilidad
     - UC Relacionado
     - CNST
   * - CRUD de roles funcionales
     - UC_041
     - CNST_005
   * - Calcular permisos efectivos
     - UC_042
     - CNST_005
   * - Aplicar precedencia (Directo > Rol > Segmento)
     - UC_042
     - -
   * - Validar reglas SoD
     - UC_042
     - -
   * - Asignar/retirar roles a usuarios
     - UC_043
     - -
   * - Configurar segmentos de datos
     - UC_044
     - -
   * - Asignar permisos directos con vigencia
     - UC_045
     - -
   * - Simular acceso de un usuario
     - UC_046
     - -
   * - Generar matriz de roles/permisos
     - UC_047
     - -
   * - Aplicar restricciones criticas (enforcers)
     - Transversal
     - CNST_001-010

3.2 NO PUEDE Hacer (Violaciones)
--------------------------------

.. warning::

   Las siguientes acciones **violan la separacion de responsabilidades**:

- **Mostrar UI funcional final**
  
  - Ejemplo: Renderizar dashboards o reportes
  - Eso es responsabilidad de → **ARQ_MOD_005_VIS_REPORTS**

- **Implementar logica de negocio de reportes**
  
  - Ejemplo: "Aplicar este filtro SQL concreto para metricas"
  - Eso es responsabilidad de → **ARQ_MOD_005_VIS_REPORTS**

- **Ejecutar ETL o agendar jobs**
  
  - Eso es responsabilidad de → **ARQ_MOD_004_ETL_MONITORING**

- **Validaciones propias del dominio IVR**
  
  - Ejemplo: Reglas de menus, transferencias, etc.
  - Eso es responsabilidad de → **ARQ_MOD_005_VIS_REPORTS**

----

4. Enforcers de Seguridad (ex-SEC_RULES)
========================================

Los enforcers aplican **automaticamente** las restricciones criticas:

.. list-table::
   :widths: 30 30 40
   :header-rows: 1

   * - Enforcer
     - Tipo
     - Restriccion que Aplica
   * - NoEmailEnforcer
     - Middleware
     - CNST_001: Bloquea cualquier intento de enviar email
   * - ReadOnlyIVREnforcer
     - DB Router
     - CNST_003: BD IVR solo lectura
   * - NoRealTimeEnforcer
     - Middleware
     - CNST_003: Bloquea WebSockets, SSE
   * - SessionDBEnforcer
     - Middleware
     - CNST_002: Sesiones en PostgreSQL
   * - ExportLimitEnforcer
     - Decorator
     - CNST_007: Limites de exportacion
   * - ThrottlingEnforcer
     - Middleware
     - CNST_007: Rate limiting

----

5. Dependencias
===============

5.1 Depende de
--------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_002_USER_IDENTITY
     - Necesita datos del usuario para calcular permisos
   * - ARQ_MOD_001_AUTH
     - Necesita sesion valida

5.2 Es Requerido por
--------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_005_VIS_REPORTS
     - Consulta permisos para mostrar/ocultar dashboards
   * - ARQ_MOD_006_ALERTS
     - Consulta permisos para configurar alertas
   * - ARQ_MOD_007_AUDIT
     - Registra cambios de roles/permisos
   * - TODOS
     - Todos los modulos consultan permisos

----

6. Componentes Tecnicos
=======================

6.1 Apps Django
---------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - App
     - Descripcion
   * - apps.common.permissions
     - Logica RBAC, enforcers, calculadores

6.2 Modelos de Datos
--------------------

- **DSC_MOD_002_Role** - Roles funcionales
- **DSC_MOD_003_Permission** - Permisos del sistema

.. code-block:: python

   class Role(models.Model):
       code = models.CharField(max_length=50, unique=True)  # R001, R002...
       name = models.CharField(max_length=100)
       category = models.CharField(max_length=50)  # OPERATIVO, GESTION, ADMIN
       permissions = models.ManyToManyField('Permission')
       is_active = models.BooleanField(default=True)
       
   class Permission(models.Model):
       code = models.CharField(max_length=100)  # reports.view, users.create
       module = models.CharField(max_length=50)
       action = models.CharField(max_length=50)
       
   class DataSegment(models.Model):
       code = models.CharField(max_length=50)
       segment_type = models.CharField()  # CENTRO, SERVICIO, REGION
       value = models.CharField(max_length=100)
       
   class UserRole(models.Model):
       user = models.ForeignKey(User)
       role = models.ForeignKey(Role)
       assigned_at = models.DateTimeField(auto_now_add=True)
       assigned_by = models.ForeignKey(User, related_name='assignments')

6.3 APIs Expuestas
------------------

- **API_003_RBAC_Endpoints**

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - Metodo
     - Endpoint
     - Descripcion
   * - GET
     - /api/v1/roles
     - Listar roles
   * - POST
     - /api/v1/roles
     - Crear rol
   * - GET
     - /api/v1/users/{id}/permissions
     - Permisos efectivos
   * - POST
     - /api/v1/users/{id}/roles
     - Asignar rol
   * - DELETE
     - /api/v1/users/{id}/roles/{roleId}
     - Retirar rol
   * - GET
     - /api/v1/users/{id}/simulate
     - Simular acceso
   * - GET
     - /api/v1/rbac/matrix
     - Matriz consolidada

----

7. Restricciones Aplicables
===========================

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - CNST
     - Descripcion y Aplicacion
   * - CNST_005
     - **Seguridad DRF Checklist**: Implementa permisos DRF, 
       IsAuthenticated, roles via JWT claims.
   * - CNST_001-010
     - **Todas**: Los enforcers aplican TODAS las restricciones criticas.

----

8. Casos de Uso Asociados
=========================

.. list-table::
   :widths: 12 40 48
   :header-rows: 1

   * - UC ID
     - Nombre
     - Descripcion
   * - UC_041
     - Administrar_Catalogo_Roles
     - CRUD de roles funcionales (R001-R017)
   * - UC_042
     - Calcular_Permisos_Efectivos
     - Aplicar precedencia y SoD
   * - UC_043
     - Asignar_Retirar_Roles
     - Gestionar roles de un usuario
   * - UC_044
     - Configurar_Segmentos_Datos
     - Data segments por centro, servicio
   * - UC_045
     - Asignar_Permisos_Directos
     - Con justificacion y vigencia max 6 meses
   * - UC_046
     - Simular_Acceso_Usuario
     - Preview "que veria este usuario?"
   * - UC_047
     - Consultar_Matriz_Roles
     - Vista consolidada para PMO

----

9. Precedencia de Permisos
==========================

.. code-block:: text

   ORDEN DE PRECEDENCIA (mayor a menor):
   
   1. Permiso DIRECTO (asignado al usuario especificamente)
      - Tiene fecha de expiracion (max 6 meses)
      - Requiere justificacion obligatoria
      
   2. Permiso por ROL (heredado del rol asignado)
      - Usuario tiene rol R005
      - R005 tiene permiso reports.view
      - Usuario hereda reports.view
      
   3. Permiso por SEGMENTO (heredado del segmento de datos)
      - Usuario tiene segmento CENTRO_NORTE
      - CENTRO_NORTE tiene reports.view limitado
      - Usuario hereda con restriccion de datos

----

10. Reglas SoD (Separation of Duties)
=====================================

.. code-block:: text

   CONFLICTOS DEFINIDOS:
   
   - USERS_CREATOR (R006) <-> AUDIT_VIEWER (R017)
     Quien crea usuarios no puede ver auditoria completa
     
   - REPORTS_ADMIN (R003) <-> EXPORT_UNLIMITED (R004)
     Evita acumulacion de poder sobre datos

----

11. Historial de Cambios
========================

.. list-table::
   :widths: 12 15 73
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 1.0.0
     - 2025-12-22
     - Version inicial. Incluye enforcers (ex-SEC_RULES).

----

*Documento de Arquitectura - ARQ_MOD_003_RBAC_CORE*
*Proyecto IACT Dashboard Analytics*
*Version 1.0.0*
