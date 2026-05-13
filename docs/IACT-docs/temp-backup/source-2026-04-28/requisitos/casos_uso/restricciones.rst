.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06

.. _restricciones:

================================================
Restricciones de Arquitectura (CNST) - IACT v4.0
================================================

1. Introducción
===============

Este documento resume las **restricciones de arquitectura (CNST)** que deben
aplicarse en todos los casos de uso del sistema IACT.

.. danger::
   
   Las restricciones CNST son **OBLIGATORIAS** y de **cumplimiento inmediato**.
   Su violación implica rechazo en code review y rollback de deployment.

2. Catálogo de Restricciones
============================

2.1 CNST-001: Comunicaciones Prohibidas
---------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - CNST-001
   * - **Nombre**
     - Comunicaciones Externas Prohibidas
   * - **Severidad**
     - CRÍTICA
   * - **Módulos Afectados**
     - AUTH, USR, ALR, RPT, AUD

**Descripción:**

El sistema IACT **NO PUEDE** enviar comunicaciones externas bajo ninguna
circunstancia.

**PROHIBIDO:**

.. code-block:: text

   ❌ SMTP / Email (SendGrid, Mailgun, SES, etc.)
   ❌ SMS (Twilio, etc.)
   ❌ Webhooks externos
   ❌ Push notifications externas
   ❌ Cualquier API de terceros para notificaciones

**PERMITIDO:**

.. code-block:: text

   ✅ InternalMessage (modelo Django en apps/common/models.py)
   ✅ Tabla: internal_messages (PostgreSQL Analytics)
   ✅ Métodos: notify(), notify_admins(), notify_by_function()

**Aplicación en UC:**

- UC_AUTH_03: Recuperar contraseña → Notificar vía buzón interno
- UC_USR_01: Crear usuario → Notificar credenciales vía buzón interno
- UC_ALR_01 a UC_ALR_05: Todas las alertas → Solo buzón interno
- UC_RPT_06 a UC_RPT_08: Exportación → NO enviar por email

2.2 CNST-002: Sesión Única y Timeout
------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - CNST-002
   * - **Nombre**
     - Gestión de Sesiones
   * - **Severidad**
     - ALTA
   * - **Módulos Afectados**
     - AUTH

**Reglas:**

.. code-block:: text

   • Sesión única por usuario (nueva sesión cierra anteriores)
   • Timeout de inactividad: 15 minutos
   • Throttling de login: 5 intentos fallidos / 5 minutos
   • Bloqueo temporal: 15 minutos tras exceder intentos

**Aplicación en UC:**

- UC_AUTH_01: Validar sesión única al iniciar
- UC_AUTH_05: Permitir cerrar sesiones de otros usuarios

2.3 CNST-003: Base de Datos Dual Inmutable
------------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - CNST-003
   * - **Nombre**
     - Arquitectura de Base de Datos Dual
   * - **Severidad**
     - CRÍTICA
   * - **Módulos Afectados**
     - PIP, RPT

**Arquitectura:**

.. code-block:: text

   ┌─────────────────────┐      ┌─────────────────────┐
   │   IVR (MariaDB)     │      │ Analytics (PostgreSQL)│
   │   ───────────────   │      │   ─────────────────   │
   │   • SOLO LECTURA    │ ETL  │   • Lectura/Escritura │
   │   • managed=False   │ ───► │   • Usuarios          │
   │   • Tablas: calls,  │      │   • Métricas          │
   │     queues, ivr_*   │      │   • Auditoría         │
   └─────────────────────┘      └─────────────────────────┘

**Reglas IVR:**

.. code-block:: python

   # PROHIBIDO en modelos IVR
   model.save()    # ❌ ERROR
   model.delete()  # ❌ ERROR
   
   # PERMITIDO
   Model.objects.using('ivr_readonly').filter(...)  # ✅ Solo SELECT

**Aplicación en UC:**

- UC_PIP_01 a UC_PIP_04: ETL extrae de IVR, carga en Analytics
- UC_RPT_01 a UC_RPT_14: Datos provienen de Analytics (post-ETL)

2.4 CNST-004: Alertas Solo Buzón Interno
----------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - CNST-004
   * - **Nombre**
     - Restricciones de Alertas
   * - **Severidad**
     - ALTA
   * - **Módulos Afectados**
     - ALR

**Reglas:**

.. code-block:: text

   • Máximo 50 destinatarios por alerta
   • Notificación SOLO vía InternalMessage
   • Consolidación de alertas repetidas (no spam)
   • NO real-time extremo (evaluación cada 15 min)

**Aplicación en UC:**

- UC_ALR_01: Validar máximo 50 destinatarios
- UC_ALR_05: Gestionar lista de destinatarios con límite

2.5 CNST-005: Modelo RBAC Flat
------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - CNST-005
   * - **Nombre**
     - RBAC Flat con Funciones Atómicas
   * - **Severidad**
     - ALTA
   * - **Módulos Afectados**
     - ACC, USR

**Reglas:**

.. code-block:: text

   • 44 funciones atómicas (no roles jerárquicos)
   • 10 agrupadores (asignación masiva)
   • Permisos directos temporales (máx 6 meses, justificación obligatoria)
   • Precedencia: Permiso Directo > Función Asignada > Segmento
   • SoD obligatorio (3 restricciones)
   • Bajas de usuario siempre LÓGICAS (nunca físicas)
   • Username autogenerado
   • Estado inicial: PENDIENTE_CONFIGURACION

**SoD Obligatorio:**

.. list-table::
   :widths: 33 33 34
   :header-rows: 1

   * - Grupo A
     - Grupo B
     - Razón
   * - admin_pipeline
     - auditor
     - Quien opera NO audita
   * - admin_usuarios
     - auditor
     - Quien gestiona NO audita
   * - admin_acceso
     - auditor
     - Quien asigna NO audita

**Aplicación en UC:**

- UC_ACC_01: Validar SoD antes de asignar
- UC_ACC_05: Gestionar restricciones SoD
- UC_ACC_08: Permisos temporales con vencimiento

2.6 CNST-006: Rango Máximo de Reportes
--------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - CNST-006
   * - **Nombre**
     - Límite Temporal de Reportes
   * - **Severidad**
     - MEDIA
   * - **Módulos Afectados**
     - RPT

**Regla:**

.. code-block:: text

   • Rango máximo de consulta: 2 años
   • Fechas fuera de rango: ERROR con mensaje descriptivo

**Aplicación en UC:**

- UC_RPT_04: Validar rango al filtrar por fecha
- UC_RPT_01 a UC_RPT_03: Aplicar límite en consultas

2.7 CNST-007: Límites de Exportación
------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - CNST-007
   * - **Nombre**
     - Throttling de Exportaciones
   * - **Severidad**
     - ALTA
   * - **Módulos Afectados**
     - RPT

**Límites por Formato:**

.. list-table::
   :widths: 20 25 25 30
   :header-rows: 1

   * - Formato
     - Máx Registros
     - Límite Diario
     - Timeout
   * - CSV
     - 100,000
     - 10 exportaciones
     - 60 segundos
   * - Excel
     - 50,000
     - 5 exportaciones
     - 90 segundos
   * - PDF
     - 10,000
     - 3 exportaciones
     - 120 segundos

**Aplicación en UC:**

- UC_RPT_06: Exportar CSV con límites
- UC_RPT_07: Exportar Excel con límites
- UC_RPT_08: Exportar PDF con límites

2.8 CNST-008: Logs Sin PII
--------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - CNST-008
   * - **Nombre**
     - Protección de Datos en Logs
   * - **Severidad**
     - ALTA
   * - **Módulos Afectados**
     - LOG, AUD

**PROHIBIDO en logs:**

.. code-block:: text

   ❌ Contraseñas (ni siquiera hasheadas)
   ❌ Tokens de sesión completos
   ❌ Números de tarjeta
   ❌ Información médica
   ❌ Datos biométricos

**PERMITIDO:**

.. code-block:: text

   ✅ User ID (numérico)
   ✅ Username
   ✅ IP address
   ✅ Timestamps
   ✅ Acciones realizadas
   ✅ Tokens truncados (últimos 4 caracteres)

**Aplicación en UC:**

- UC_LOG_01 a UC_LOG_03: Consultar logs sanitizados
- UC_AUD_01 a UC_AUD_03: Auditoría sin PII innecesaria

2.9 CNST-009: Auditoría Inmutable
---------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - CNST-009
   * - **Nombre**
     - Logging de Auditoría Inmutable
   * - **Severidad**
     - CRÍTICA
   * - **Módulos Afectados**
     - AUD (todos los módulos generan eventos)

**Modelo: UserActionLog**

.. code-block:: python

   class UserActionLog(models.Model):
       user = models.ForeignKey(User, ...)
       action = models.CharField(...)      # LOGIN, LOGOUT, VIEW, EXPORT, etc.
       resource = models.CharField(...)    # Recurso afectado
       result = models.CharField(...)      # SUCCESS, FAILURE
       ip_address = models.GenericIPAddressField(...)
       user_agent = models.CharField(...)
       details = models.JSONField(...)     # Datos adicionales
       created_at = models.DateTimeField(auto_now_add=True)
       
       def save(self, *args, **kwargs):
           if self.pk:
               raise PermissionError('CNST-009: Auditoría inmutable')
           super().save(*args, **kwargs)
       
       def delete(self, *args, **kwargs):
           raise PermissionError('CNST-009: No se puede eliminar auditoría')

**Método de Registro:**

.. code-block:: python

   UserActionLog.record(
       user=request.user,
       action='ROLE_ASSIGN',
       resource=f'User:{target_user.id}',
       result='SUCCESS',
       ip=get_client_ip(request),
       user_agent=request.META.get('HTTP_USER_AGENT'),
       details={'function': 'ACC-001', 'target': target_user.username}
   )

**Aplicación en UC:**

- Todos los UC que modifican datos críticos deben llamar a UserActionLog.record()
- UC_AUD_01 a UC_AUD_03: Solo lectura de auditoría
- UC_AUD_04: Registro automático por el sistema

2.10 CNST-010: Clasificación de Datos
-------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - CNST-010
   * - **Nombre**
     - Clasificación y Manejo de Datos
   * - **Severidad**
     - MEDIA
   * - **Módulos Afectados**
     - Todos

**Niveles de Clasificación:**

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Nivel
     - Descripción
     - Ejemplos
   * - PÚBLICO
     - Sin restricciones
     - Nombres de reportes, KPIs agregados
   * - INTERNO
     - Solo usuarios autenticados
     - Métricas, dashboards
   * - CONFIDENCIAL
     - Roles específicos
     - Datos de usuarios, auditoría
   * - RESTRINGIDO
     - Administradores únicamente
     - Configuración SoD, logs técnicos

3. Matriz CNST → Módulos
========================

.. code-block:: text

                    AUTH  USR  ACC  PIP  RPT  ALR  AUD  LOG
   ─────────────────────────────────────────────────────────
   CNST-001 (no email)  ●    ●    -    -    ●    ●    ●    -
   CNST-002 (sesión)    ●    -    -    -    -    -    -    -
   CNST-003 (BD dual)   -    -    -    ●    ●    -    -    -
   CNST-004 (alertas)   -    -    -    -    -    ●    -    -
   CNST-005 (RBAC)      -    ●    ●    -    -    -    -    -
   CNST-006 (2 años)    -    -    -    -    ●    -    -    -
   CNST-007 (export)    -    -    -    -    ●    -    -    -
   CNST-008 (no PII)    -    -    -    -    -    -    ●    ●
   CNST-009 (audit)     ●    ●    ●    ●    ●    ●    ●    ●
   CNST-010 (clasif)    ●    ●    ●    ●    ●    ●    ●    ●

4. Validación en Casos de Uso
=============================

Cada caso de uso debe incluir una sección **"11. Restricciones de Arquitectura"**
con la siguiente estructura:

.. code-block:: rst

   11. Restricciones de Arquitectura
   ---------------------------------
   
   .. list-table::
      :widths: 15 25 60
      :header-rows: 1
   
      * - CNST
        - Nombre
        - Aplicación en este UC
      * - CNST-001
        - Comunicaciones Prohibidas
        - Notificación vía InternalMessage.notify()
      * - CNST-009
        - Auditoría Inmutable
        - UserActionLog.record() al completar acción

5. Historial de Cambios
=======================

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 4.0.0
     - 2026-01-06
     - Equipo IACT
     - Versión inicial consolidando CNST-001 a CNST-010
