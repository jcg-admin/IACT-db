.. =============================================================================
.. ARQ_MOD_008_SYS_LOGS.rst
.. Modulo Funcional: Bitacoras Tecnicas y Monitoreo del Sistema
.. Version: 1.0.0
.. =============================================================================

=========================================================
ARQ_MOD_008: Bitacoras Tecnicas (SYS_LOGS)
=========================================================

.. metadata::
   :id: ARQ_MOD_008
   :codigo: SYS_LOGS
   :nombre: Bitacoras Tecnicas y Monitoreo del Sistema
   :version: 1.0.0
   :estado: APROBADO
   :fecha_creacion: 2025-12-22

.. contents:: Contenido
   :local:
   :depth: 2

----

1. Proposito
============

El modulo SYS_LOGS gestiona los **logs tecnicos** y el **estado de salud**
del sistema. Orientado a soporte, NOC y devops.

**Pregunta clave que responde:**

   *"¿Que esta pasando a nivel tecnico con el sistema y sus componentes?"*

**NO es auditoria funcional** - eso es ARQ_MOD_007_AUDIT.

----

2. Alcance
==========

2.1 Incluye
-----------

**Logs tecnicos:**

- Errores de servidor (500, excepciones)
- Warnings de aplicacion
- Tracebacks y stack traces
- Logs de infraestructura (up/down, timeouts)

**Monitoreo:**

- Estado de salud del sistema (health endpoints)
- Estado de servicios (BD, cache, colas)
- Metricas tecnicas agregadas (CPU, memoria, tiempos respuesta)
- Descarga de paquetes de logs para analisis externo

2.2 Excluye (NO incluye)
------------------------

- Acciones de negocio (login, exportaciones) → **ARQ_MOD_007_AUDIT**
- Reglas de seguridad → **ARQ_MOD_003_RBAC_CORE**
- PII sin enmascarar → **CNST_009**

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
   * - Mostrar logs de aplicacion (INFO/WARN/ERROR)
     - UC_080
     - CNST_009
   * - Filtrar logs por nivel, fecha, componente
     - UC_080
     - -
   * - Mostrar estado de salud del sistema
     - UC_081
     - -
   * - Mostrar estado de servicios externos
     - UC_081
     - -
   * - Generar paquete comprimido de logs
     - UC_082
     - CNST_009
   * - Mostrar metricas tecnicas agregadas
     - UC_083
     - -

3.2 NO PUEDE Hacer (Violaciones)
--------------------------------

.. warning::

   Las siguientes acciones **violan la separacion de responsabilidades**:

- **Registrar acciones de negocio**
  
  - Ejemplo: "Usuario exporto reporte X"
  - Eso es responsabilidad de → **ARQ_MOD_007_AUDIT**

- **Definir reglas de seguridad**
  
  - Ejemplo: "Si hay muchos errores de login, bloquear usuario"
  - Eso es responsabilidad de → **ARQ_MOD_003_RBAC_CORE** (enforcers)

- **Exponer PII sin enmascarar**
  
  - Viola → **CNST_009** (proteccion de datos en logs)
  - Usernames, IPs deben enmascararse en logs publicos

----

4. Niveles de Log
=================

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - Nivel
     - Codigo
     - Uso
   * - DEBUG
     - 10
     - Solo en desarrollo, nunca en produccion
   * - INFO
     - 20
     - Operaciones normales (inicio servicios, conexiones)
   * - WARNING
     - 30
     - Situaciones anomalas no criticas
   * - ERROR
     - 40
     - Errores que requieren atencion
   * - CRITICAL
     - 50
     - Fallas graves, sistema comprometido

----

5. Configuracion de Logging
===========================

.. code-block:: python

   # config/settings/base.py
   
   LOGGING = {
       'version': 1,
       'disable_existing_loggers': False,
       'formatters': {
           'verbose': {
               'format': '{asctime} [{levelname}] {name} {module}: {message}',
               'style': '{',
           },
       },
       'handlers': {
           'file': {
               'level': 'INFO',
               'class': 'logging.handlers.RotatingFileHandler',
               'filename': '/var/log/iact/application.log',
               'maxBytes': 10485760,  # 10MB
               'backupCount': 10,
               'formatter': 'verbose',
           },
           'error_file': {
               'level': 'ERROR',
               'class': 'logging.handlers.RotatingFileHandler',
               'filename': '/var/log/iact/error.log',
               'maxBytes': 10485760,
               'backupCount': 20,
               'formatter': 'verbose',
           },
       },
       'loggers': {
           'django': {
               'handlers': ['file'],
               'level': 'INFO',
           },
           'apps': {
               'handlers': ['file', 'error_file'],
               'level': 'INFO',
           },
       },
   }

----

6. Health Checks
================

.. code-block:: python

   # apps/monitoring/views.py
   
   class HealthCheckView(APIView):
       permission_classes = [AllowAny]
       
       def get(self, request):
           checks = {
               'database_analytics': self._check_analytics_db(),
               'database_ivr': self._check_ivr_db(),
               'cache': self._check_cache(),
               'disk_space': self._check_disk(),
               'memory': self._check_memory(),
           }
           
           all_healthy = all(c['status'] == 'healthy' for c in checks.values())
           
           return Response({
               'status': 'healthy' if all_healthy else 'degraded',
               'timestamp': timezone.now().isoformat(),
               'checks': checks,
           }, status=200 if all_healthy else 503)

----

7. Dependencias
===============

7.1 Depende de
--------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_001_AUTH
     - Requiere sesion (solo para UI de logs)
   * - ARQ_MOD_003_RBAC_CORE
     - Verifica permisos de ver logs tecnicos

7.2 Es Requerido por
--------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Modulo
     - Razon
   * - TODOS
     - Todos los modulos generan logs tecnicos
   * - ARQ_MOD_006_ALERTS
     - Puede generar alertas por health degradado

----

8. Componentes Tecnicos
=======================

8.1 Apps Django
---------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - App
     - Descripcion
   * - apps.monitoring
     - Health checks, metricas, vistas de logs

8.2 APIs Expuestas
------------------

- **API_009_Health_Endpoints**

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - Metodo
     - Endpoint
     - Descripcion
   * - GET
     - /api/v1/health
     - Estado de salud (publico)
   * - GET
     - /api/v1/health/detailed
     - Detalle de servicios (auth)
   * - GET
     - /api/v1/logs
     - Listar logs (paginado)
   * - GET
     - /api/v1/logs/download
     - Paquete comprimido
   * - GET
     - /api/v1/metrics/technical
     - Metricas agregadas

----

9. Restricciones Aplicables
===========================

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - CNST
     - Descripcion y Aplicacion
   * - CNST_009
     - **Logging Auditoria Inmutable**: PII enmascarado en logs.
       No incluir passwords, tokens, datos sensibles.
   * - CNST_008
     - **Infraestructura Deployment**: Logs en /var/log/iact/.
       Rotacion automatica. Permisos restrictivos.

----

10. Casos de Uso Asociados
==========================

.. list-table::
   :widths: 12 40 48
   :header-rows: 1

   * - UC ID
     - Nombre
     - Descripcion
   * - UC_080
     - Consultar_Bitacoras_Tecnicas
     - Logs de aplicacion con filtros
   * - UC_081
     - Consultar_Estado_Salud
     - Health endpoints, servicios
   * - UC_082
     - Descargar_Paquetes_Logs
     - Comprimido para analisis
   * - UC_083
     - Consultar_Metricas_Tecnicas
     - CPU, memoria, tiempos respuesta

----

11. Requisitos Funcionales Derivados
====================================

.. list-table::
   :widths: 12 45 20 23
   :header-rows: 1

   * - FR ID
     - Nombre
     - Deriva de
     - Descripcion
   * - FR_034
     - Listar_Logs_Sistema
     - UC_080
     - Con filtros y paginacion
   * - FR_035
     - Consultar_Health_Check
     - UC_081
     - Estado de servicios
   * - FR_036
     - Empaquetar_Logs
     - UC_082
     - Compresion y descarga

----

12. Metricas Tecnicas
=====================

.. list-table::
   :widths: 30 30 40
   :header-rows: 1

   * - Metrica
     - Tipo
     - Descripcion
   * - request_duration_seconds
     - Histogram
     - Tiempo de respuesta por endpoint
   * - active_connections
     - Gauge
     - Conexiones DB activas
   * - error_count
     - Counter
     - Errores por tipo
   * - memory_usage_bytes
     - Gauge
     - Uso de memoria
   * - disk_usage_percent
     - Gauge
     - Uso de disco

----

13. Historial de Cambios
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

*Documento de Arquitectura - ARQ_MOD_008_SYS_LOGS*
*Proyecto IACT Dashboard Analytics*
*Version 1.0.0*
