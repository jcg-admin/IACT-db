.. =============================================================================
.. ARQ_MOD_007_AUDIT.rst
.. Modulo Funcional: Auditoria Funcional
.. Version: 1.0.0
.. =============================================================================

=========================================================
ARQ_MOD_007: Auditoria Funcional (AUDIT)
=========================================================

.. metadata::
   :id: ARQ_MOD_007
   :codigo: AUDIT
   :nombre: Auditoria Funcional
   :version: 1.0.0
   :estado: APROBADO
   :fecha_creacion: 2025-12-22

.. contents:: Contenido
   :local:
   :depth: 2

----

1. Proposito
============

El modulo AUDIT registra **acciones de negocio** realizadas por los usuarios
en el sistema. Es la bitacora funcional para cumplimiento y gobernanza.

**Pregunta clave que responde:**

   *"¿Que acciones de negocio relevantes se hicieron en el sistema?"*

**NO es un log tecnico** - eso es ARQ_MOD_008_SYS_LOGS.

----

2. Alcance
==========

2.1 Incluye
-----------

**Eventos auditados:**

- Login/logout de usuarios
- Creacion y modificacion de usuarios
- Asignacion y retiro de roles
- Cambios de segmentos de datos
- Exportaciones de reportes
- Cambios de configuracion de alertas
- Cambios de contrasena
- Intentos de acceso fallidos

**Funcionalidades:**

- Consultar bitacora de auditoria
- Filtrar por usuario, fecha, recurso, tipo de accion
- Exportar eventos de auditoria
- Generar reportes de cambios de permisos

2.2 Excluye (NO incluye)
------------------------

- Stack traces y errores tecnicos → **ARQ_MOD_008_SYS_LOGS**
- Logs de infraestructura → **ARQ_MOD_008_SYS_LOGS**
- Definir reglas de acceso → **ARQ_MOD_003_RBAC_CORE**

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
   * - Registrar evento de auditoria
     - Transversal
     - CNST_009
   * - Consultar bitacora de auditoria
     - UC_070
     - CNST_009
   * - Filtrar por usuario, fecha, recurso
     - UC_071
     - -
   * - Exportar eventos a CSV/Excel
     - UC_072
     - CNST_007
   * - Generar reporte de cambios de permisos
     - UC_073
     - -
   * - Almacenar quien, que, cuando, desde donde
     - Transversal
     - CNST_009

3.2 NO PUEDE Hacer (Violaciones)
--------------------------------

.. warning::

   Las siguientes acciones **violan la separacion de responsabilidades**:

- **Guardar stack traces o errores tecnicos**
  
  - Ejemplo: Tracebacks de excepciones Python
  - Eso es responsabilidad de → **ARQ_MOD_008_SYS_LOGS**

- **Definir reglas de acceso**
  
  - Ejemplo: "Solo auditor ve esto"
  - Eso es responsabilidad de → **ARQ_MOD_003_RBAC_CORE**

- **Almacenar logs de infraestructura**
  
  - Ejemplo: Estado de servicios, timeouts, conexiones
  - Eso es responsabilidad de → **ARQ_MOD_008_SYS_LOGS**

----

4. Estructura del Evento de Auditoria
=====================================

.. code-block:: python

   class AuditLog(models.Model):
       """
       Registro inmutable de auditoria funcional.
       CNST_009: No se modifica ni elimina.
       """
       # Quien
       user = models.ForeignKey(User, null=True)  # null = sistema
       user_display = models.CharField(max_length=100)  # snapshot del nombre
       
       # Que
       action = models.CharField(max_length=50, choices=AUDIT_ACTIONS)
       resource_type = models.CharField(max_length=50)  # User, Role, Report
       resource_id = models.CharField(max_length=100, null=True)
       resource_display = models.CharField(max_length=200)
       
       # Detalles
       old_value = models.JSONField(null=True)
       new_value = models.JSONField(null=True)
       
       # Cuando
       timestamp = models.DateTimeField(auto_now_add=True, db_index=True)
       
       # Desde donde
       ip_address = models.GenericIPAddressField()
       user_agent = models.TextField()
       
       # Resultado
       result = models.CharField(choices=AUDIT_RESULTS)  # SUCCESS, FAILED, DENIED
       
       class Meta:
           ordering = ['-timestamp']
           indexes = [
               models.Index(fields=['user', 'timestamp']),
               models.Index(fields=['action', 'timestamp']),
               models.Index(fields=['resource_type', 'timestamp']),
           ]

----

5. Tipos de Accion Auditada
===========================

.. list-table::
   :widths: 25 35 40
   :header-rows: 1

   * - Accion
     - Descripcion
     - Modulo Origen
   * - AUTH_LOGIN
     - Inicio de sesion exitoso
     - ARQ_MOD_001
   * - AUTH_LOGOUT
     - Cierre de sesion
     - ARQ_MOD_001
   * - AUTH_FAILED
     - Intento de login fallido
     - ARQ_MOD_001
   * - USER_CREATE
     - Creacion de usuario
     - ARQ_MOD_002
   * - USER_UPDATE
     - Modificacion de usuario
     - ARQ_MOD_002
   * - USER_DELETE
     - Baja logica de usuario
     - ARQ_MOD_002
   * - ROLE_ASSIGN
     - Asignacion de rol
     - ARQ_MOD_003
   * - ROLE_REVOKE
     - Retiro de rol
     - ARQ_MOD_003
   * - PERMISSION_GRANT
     - Permiso directo asignado
     - ARQ_MOD_003
   * - REPORT_EXPORT
     - Exportacion de reporte
     - ARQ_MOD_005
   * - ALERT_CREATE
     - Configuracion de alerta
     - ARQ_MOD_006
   * - PASSWORD_CHANGE
     - Cambio de contrasena
     - ARQ_MOD_001

----

6. Dependencias
===============

6.1 Depende de
--------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_001_AUTH
     - Requiere sesion para identificar usuario
   * - ARQ_MOD_003_RBAC_CORE
     - Verifica permisos de ver auditoria (R017)

6.2 Es Requerido por
--------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_001_AUTH
     - Registra login/logout
   * - ARQ_MOD_002_USER_IDENTITY
     - Registra cambios de usuarios
   * - ARQ_MOD_003_RBAC_CORE
     - Registra cambios de roles/permisos
   * - ARQ_MOD_005_VIS_REPORTS
     - Registra exportaciones
   * - ARQ_MOD_006_ALERTS
     - Registra configuracion de alertas

----

7. Componentes Tecnicos
=======================

7.1 Apps Django
---------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - App
     - Descripcion
   * - apps.common.audit
     - Modelo AuditLog, decoradores, servicios

7.2 Modelos de Datos
--------------------

- **DSC_MOD_008_AuditLog** - Registro de auditoria

7.3 APIs Expuestas
------------------

- **API_008_Audit_Endpoints**

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - Metodo
     - Endpoint
     - Descripcion
   * - GET
     - /api/v1/audit/logs
     - Listar eventos (paginado)
   * - GET
     - /api/v1/audit/logs/{id}
     - Detalle de evento
   * - POST
     - /api/v1/audit/export
     - Exportar a CSV/Excel
   * - GET
     - /api/v1/audit/reports/permissions
     - Reporte de cambios de permisos

7.4 Decorador de Auditoria
--------------------------

.. code-block:: python

   from apps.common.audit import audit_action
   
   @audit_action(action='USER_CREATE', resource_type='User')
   def create_user(request, data):
       # La accion se registra automaticamente
       user = User.objects.create(**data)
       return user

----

8. Restricciones Aplicables
===========================

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - CNST
     - Descripcion y Aplicacion
   * - CNST_009
     - **Logging Auditoria Inmutable**: Registros no se modifican ni eliminan.
       Retencion minima 2 anos. Indices para consulta eficiente.
   * - CNST_007
     - **Limites Performance**: Exportacion de auditoria con limites.

----

9. Casos de Uso Asociados
=========================

.. list-table::
   :widths: 12 40 48
   :header-rows: 1

   * - UC ID
     - Nombre
     - Descripcion
   * - UC_070
     - Consultar_Bitacora_Auditoria
     - Ver eventos funcionales
   * - UC_071
     - Filtrar_Auditoria
     - Por usuario, fecha, recurso, tipo
   * - UC_072
     - Exportar_Eventos_Auditoria
     - CSV/Excel con limites
   * - UC_073
     - Generar_Reporte_Cambios_Permisos
     - Cumplimiento periodico

----

10. Requisitos Funcionales Derivados
====================================

.. list-table::
   :widths: 12 45 20 23
   :header-rows: 1

   * - FR ID
     - Nombre
     - Deriva de
     - Descripcion
   * - FR_031
     - Listar_Eventos_Auditoria
     - UC_070
     - Paginacion, ordenamiento
   * - FR_032
     - Filtrar_Auditoria
     - UC_071
     - Multiples criterios
   * - FR_033
     - Exportar_Auditoria
     - UC_072
     - CSV/Excel

----

11. Retencion y Compliance
==========================

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Politica
     - Valor
   * - Retencion minima
     - 2 anos
   * - Retencion maxima
     - 5 anos (configurable)
   * - Inmutabilidad
     - No UPDATE, no DELETE
   * - Acceso
     - Solo rol R017 (AUDIT_VIEWER)
   * - Exportacion
     - Max 100,000 registros por descarga

----

12. Historial de Cambios
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

*Documento de Arquitectura - ARQ_MOD_007_AUDIT*
*Proyecto IACT Dashboard Analytics*
*Version 1.0.0*
