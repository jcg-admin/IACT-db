.. =============================================================================
.. ARQ_MOD_006_ALERTS.rst
.. Modulo Funcional: Alertas Internas y Notificaciones
.. Version: 1.0.0
.. =============================================================================

=========================================================
ARQ_MOD_006: Alertas y Notificaciones (ALERTS)
=========================================================

.. metadata::
   :id: ARQ_MOD_006
   :codigo: ALERTS
   :nombre: Alertas Internas y Notificaciones
   :version: 1.0.0
   :estado: APROBADO
   :fecha_creacion: 2025-12-22

.. contents:: Contenido
   :local:
   :depth: 2

----

1. Proposito
============

El modulo ALERTS gestiona el **sistema de alertas operativas** y el
**buzon interno de notificaciones**. Respeta la restriccion critica de
**NO EMAIL** - todo se entrega via InternalMessage.

**Pregunta clave que responde:**

   *"¿Que condiciones disparan alertas y que mensajes internos se envian a los usuarios?"*

----

2. Alcance
==========

2.1 Incluye
-----------

- Configuracion de alertas operativas (THRESHOLD, ANOMALY, TREND)
- Evaluacion periodica de condiciones de alerta
- Buzon interno (InternalMessage) - reemplaza email
- Bandeja de notificaciones con filtros
- Silenciar/posponer alertas (snooze)
- Confirmar/cerrar alertas

2.2 Excluye (NO incluye)
------------------------

- Envio de email → **CNST_001** (prohibido)
- Consultas directas a BD IVR → **ARQ_MOD_004_ETL_MONITORING**
- Logica de permisos → **ARQ_MOD_003_RBAC_CORE**
- Generacion de reportes → **ARQ_MOD_005_VIS_REPORTS**

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
   * - Crear configuracion de alerta operativa
     - UC_036
     - -
   * - Definir tipo (THRESHOLD/ANOMALY/TREND)
     - UC_036
     - -
   * - Definir severidad y destinatarios
     - UC_036
     - -
   * - Enviar notificacion a buzon interno
     - UC_037
     - CNST_001
   * - Listar bandeja de notificaciones
     - UC_038
     - -
   * - Filtrar por severidad, tipo, estado
     - UC_038
     - -
   * - Aplicar snooze (1h, 8h, 24h, personalizado)
     - UC_039
     - -
   * - Confirmar/cerrar alerta atendida
     - UC_040
     - -

3.2 NO PUEDE Hacer (Violaciones)
--------------------------------

.. warning::

   Las siguientes acciones **violan la separacion de responsabilidades**:

- **Enviar email**
  
  - Viola restriccion critica → **CNST_001**
  - Todo va por InternalMessage (buzon interno)

- **Consultar BD IVR directamente**
  
  - Debe usar datos de BD Analytics (ya transformados)
  - Eso es responsabilidad de → **ARQ_MOD_004_ETL_MONITORING**

- **Implementar logica de permisos**
  
  - Ejemplo: "Solo admin ve estas alertas"
  - Debe pasar por → **ARQ_MOD_003_RBAC_CORE**

- **Generar reportes de negocio**
  
  - Eso es responsabilidad de → **ARQ_MOD_005_VIS_REPORTS**

----

4. Tipos de Alerta
==================

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Tipo
     - Descripcion
     - Ejemplo
   * - THRESHOLD
     - Se dispara cuando una metrica supera/baja de un umbral
     - "Llamadas fallidas > 100/hora"
   * - ANOMALY
     - Se dispara por desviacion estadistica
     - "Duracion promedio 3 std por encima"
   * - TREND
     - Se dispara por tendencia sostenida
     - "Incremento 20% en 3 dias consecutivos"

----

5. InternalMessage (Reemplaza Email)
====================================

.. code-block:: python

   class InternalMessage(models.Model):
       """
       Reemplaza completamente el email.
       CNST_001: No se envia ningun correo electronico.
       """
       sender = models.ForeignKey(User, null=True)  # null = sistema
       recipient = models.ForeignKey(User)
       subject = models.CharField(max_length=200)
       body = models.TextField()
       message_type = models.CharField(choices=MESSAGE_TYPES)
       severity = models.CharField(choices=SEVERITY_LEVELS)
       is_read = models.BooleanField(default=False)
       read_at = models.DateTimeField(null=True)
       created_at = models.DateTimeField(auto_now_add=True)
       
       # Relacionado con alerta (opcional)
       alert = models.ForeignKey('Alert', null=True)

**Usos de InternalMessage:**

- Alertas operativas
- Notificaciones de ETL (fallos, completado)
- Recuperacion de contrasena (codigo temporal)
- Avisos de cambios de roles/permisos
- Mensajes del sistema

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
     - Requiere sesion autenticada
   * - ARQ_MOD_003_RBAC_CORE
     - Verifica permisos de configurar alertas
   * - ARQ_MOD_004_ETL_MONITORING
     - Obtiene metricas para evaluar condiciones
   * - ARQ_MOD_005_VIS_REPORTS
     - Puede usar metricas agregadas

6.2 Es Requerido por
--------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_001_AUTH
     - Envia codigo temporal via InternalMessage
   * - ARQ_MOD_004_ETL_MONITORING
     - Notifica fallos de ETL
   * - ARQ_MOD_007_AUDIT
     - Registra alertas generadas

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
   * - apps.common.notifications
     - InternalMessage, AlertConfig, servicios

7.2 Modelos de Datos
--------------------

- **DSC_MOD_007_Alert** - Configuracion de alertas
- **DSC_MOD_009_InternalMessage** - Mensajes internos

.. code-block:: python

   class AlertConfig(models.Model):
       name = models.CharField(max_length=100)
       alert_type = models.CharField(choices=ALERT_TYPES)
       metric = models.CharField(max_length=100)
       condition = models.CharField(max_length=50)  # GT, LT, EQ
       threshold = models.DecimalField()
       severity = models.CharField(choices=SEVERITY_LEVELS)
       recipients = models.ManyToManyField(User)
       frequency = models.CharField()  # IMMEDIATE, HOURLY, DAILY
       is_active = models.BooleanField(default=True)
       snooze_until = models.DateTimeField(null=True)
       
   class AlertInstance(models.Model):
       config = models.ForeignKey(AlertConfig)
       triggered_at = models.DateTimeField()
       metric_value = models.DecimalField()
       status = models.CharField()  # OPEN, ACKNOWLEDGED, CLOSED
       acknowledged_by = models.ForeignKey(User, null=True)
       acknowledged_at = models.DateTimeField(null=True)

7.3 APIs Expuestas
------------------

- **API_007_Alerts_Endpoints**

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - Metodo
     - Endpoint
     - Descripcion
   * - GET
     - /api/v1/alerts/configs
     - Listar configuraciones
   * - POST
     - /api/v1/alerts/configs
     - Crear configuracion
   * - GET
     - /api/v1/notifications
     - Bandeja de notificaciones
   * - PUT
     - /api/v1/notifications/{id}/read
     - Marcar como leida
   * - PUT
     - /api/v1/alerts/{id}/snooze
     - Silenciar alerta
   * - PUT
     - /api/v1/alerts/{id}/acknowledge
     - Confirmar alerta

----

8. Restricciones Aplicables
===========================

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - CNST
     - Descripcion y Aplicacion
   * - CNST_001
     - **Comunicaciones Prohibidas**: NO EMAIL. Todo via InternalMessage.
       Esto aplica a alertas, recuperacion de contrasena, avisos del sistema.

----

9. Casos de Uso Asociados
=========================

.. list-table::
   :widths: 12 40 48
   :header-rows: 1

   * - UC ID
     - Nombre
     - Descripcion
   * - UC_036
     - Configurar_Alerta_Operativa
     - Tipo, severidad, destinatarios, frecuencia
   * - UC_037
     - Recibir_Notificacion_Buzon
     - InternalMessage generico reutilizable
   * - UC_038
     - Consultar_Bandeja_Notificaciones
     - Filtrar por severidad, tipo, estado
   * - UC_039
     - Silenciar_Posponer_Alerta
     - Snooze 1h, 8h, 24h, personalizado
   * - UC_040
     - Confirmar_Cerrar_Alerta
     - Marcar como atendida

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
   * - FR_027
     - Crear_Configuracion_Alerta
     - UC_036
     - CRUD alertas
   * - FR_028
     - Enviar_Notificacion_Interna
     - UC_037
     - Via InternalMessage
   * - FR_029
     - Listar_Notificaciones
     - UC_038
     - Con filtros
   * - FR_030
     - Aplicar_Snooze_Alerta
     - UC_039
     - Tiempos predefinidos

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
     - Version inicial. Incluye InternalMessage como reemplazo de email.

----

*Documento de Arquitectura - ARQ_MOD_006_ALERTS*
*Proyecto IACT Dashboard Analytics*
*Version 1.0.0*
