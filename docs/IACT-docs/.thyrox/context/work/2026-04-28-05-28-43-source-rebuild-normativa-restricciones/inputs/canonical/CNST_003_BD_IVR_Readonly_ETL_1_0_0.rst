.. _CNST_003:

============================================================
CNST_003 - BD IVR Readonly, ETL 6-12h, NO Real-Time
============================================================

:Restricción: CNST_003
:Versión: 1.0.0
:Fecha: 2026-01-11
:Estado: VIGENTE
:Prioridad: CRÍTICA
:Ámbito: MOD_Pipeline, MOD_Reports - Datos de negocio
:Fundamento: Arquitectura de integración y protección de datos
:Proyecto: IACT-2025-001
:Relacionado_Con: CNST_005 (RBAC), CNST_006 (Límites reportes)

.. contents:: Tabla de Contenido
   :depth: 4
   :local:

============================================================
1. RESUMEN EJECUTIVO
============================================================

1.1 Definición de la Restricción
----------------------------------

   **El Sistema IACT NO accede directamente a la Base de Datos del IVR 
   en producción. Los datos se obtienen mediante un proceso ETL 
   (Extract-Transform-Load) que corre periódicamente cada 6-12 horas.**
   
   **Características obligatorias:**
   
   1. **BD IVR es READONLY:** IACT solo tiene permisos de LECTURA 
      (SELECT) sobre la BD del IVR. NO puede escribir, modificar ni 
      eliminar datos.
   
   2. **ETL Periódico:** La sincronización ocurre cada 6-12 horas, 
      típicamente a las 06:00 y 18:00 horas.
   
   3. **NO Real-Time:** Los datos que ve el usuario están desfasados 
      según el último ETL exitoso. NO hay datos en tiempo real.
   
   4. **BD IACT Local:** Los datos se copian a la BD local de IACT 
      (MySQL) para consultas rápidas y sin impacto en el IVR.

1.2 Justificación
------------------

**Protección del Sistema IVR:**

- El IVR es un sistema CRÍTICO de producción (contact center)
- Consultas pesadas afectarían el rendimiento del IVR
- Evitar que errores en IACT impacten el servicio de llamadas
- Prevenir bloqueos de tablas durante operaciones de IACT

**Performance:**

- Consultas a BD local (IACT) son más rápidas
- Se pueden crear índices optimizados en BD IACT
- Agregaciones pre-calculadas en ETL
- Sin competencia de recursos con el IVR

**Seguridad:**

- Credenciales readonly reducen riesgo de modificación accidental
- Aislamiento de sistemas
- Trazabilidad: Solo ETL accede al IVR

**Modelo de Negocio:**

- Los análisis de IACT NO requieren datos en tiempo real
- Decisiones de negocio basadas en tendencias (horas/días)
- Reportes históricos, no monitoreo real-time

1.3 Impacto General
--------------------

.. list-table:: Impacto de CNST_003
   :header-rows: 1
   :widths: 30 70

   * - Aspecto
     - Impacto
   * - **Usuario Final**
     - • Datos desfasados según último ETL
       • Banner: "Datos actualizados al: [timestamp último ETL]"
       • NO esperar datos de última hora
   * - **Módulos Afectados**
     - • MOD_Reports: Todos los reportes (8 funciones)
       • MOD_Pipeline: Supervisión del ETL (4 funciones)
       • MOD_Alerts: Umbrales basados en datos desfasados
   * - **Funciones RBAC**
     - • PIP-001: ve_estado_etl
       • PIP-002: ve_errores_etl
       • PIP-003: ve_disponibilidad_datos
       • PIP-004: solicita_reintento_etl
       • RPT-001 a RPT-008: Todos los reportes
   * - **Infraestructura**
     - • BD IVR: Solo permisos SELECT
       • BD IACT: Tablas espejo de IVR
       • Proceso ETL: Cron job 2x/día
       • Monitoreo ETL: Alertas si falla
   * - **SLA Datos**
     - • Desfase: 6-12 horas (aceptable)
       • Disponibilidad: 99.5% (dependiente de ETL)
       • Freshness: Indicador visible en UI

============================================================
2. ARQUITECTURA DE INTEGRACIÓN
============================================================

2.1 Diagrama de Arquitectura
------------------------------

.. code-block:: text

   ┌─────────────────────────────────────────────────────────┐
   │              ARQUITECTURA ETL IACT ↔ IVR                 │
   └─────────────────────────────────────────────────────────┘
   
   ┌──────────────────────┐
   │   SISTEMA IVR        │  ← Sistema de producción CRÍTICO
   │   (Contact Center)   │
   ├──────────────────────┤
   │   BD IVR (Oracle)    │
   │   - llamadas         │
   │   - menus            │
   │   - transferencias   │
   │   - navegacion       │
   └──────────────────────┘
            │ ▲
            │ │ SELECT (readonly)
            │ │ NO: INSERT, UPDATE, DELETE
            │ │
            ▼ │
   ┌──────────────────────┐
   │   PROCESO ETL        │  ← Corre cada 6-12h
   │   (Python + Airflow) │
   ├──────────────────────┤
   │ 1. Extract (06:00,   │
   │            18:00)    │
   │ 2. Transform         │
   │    - Limpieza        │
   │    - Agregaciones    │
   │    - Cálculos        │
   │ 3. Load a BD IACT    │
   └──────────────────────┘
            │
            │ INSERT/UPDATE
            │
            ▼
   ┌──────────────────────┐
   │   BD IACT (MySQL)    │  ← BD local del sistema
   │   - llamadas_ivr     │
   │   - menus_ivr        │
   │   - transferencias   │
   │   - navegacion_ivr   │
   │   - etl_executions   │
   └──────────────────────┘
            │ ▲
            │ │ SELECT (queries rápidos)
            │ │
            ▼ │
   ┌──────────────────────┐
   │   SISTEMA IACT       │
   │   (Django App)       │
   ├──────────────────────┤
   │ - Reportes           │
   │ - Dashboards         │
   │ - Alertas            │
   │ - Exportaciones      │
   └──────────────────────┘
            │
            ▼
   ┌──────────────────────┐
   │   USUARIOS           │
   │   (Navegador Web)    │
   └──────────────────────┘

2.2 Flujo del Proceso ETL
---------------------------

.. code-block:: yaml

   Nombre: ETL_IVR_to_IACT
   Frecuencia: Cada 6-12 horas
   Horarios: 06:00 AM y 06:00 PM (UTC-6)
   Duración estimada: 15-45 minutos
   Motor: Apache Airflow + Python
   
   FASE 1: PRE-VALIDACIÓN (5 min)
   ──────────────────────────────────
   1.1 Verificar conexión a BD IVR
       - Host: ivr-db.prod.internal
       - Puerto: 1521 (Oracle)
       - Usuario: iact_readonly
       - Schema: IVR_PROD
   
   1.2 Verificar conexión a BD IACT
       - Host: localhost
       - Puerto: 3306 (MySQL)
       - Schema: iact_db
   
   1.3 Validar última ejecución exitosa
       - Consultar tabla etl_executions
       - Si última ejecución < 18h → WARNING
       - Si última ejecución < 24h → CRITICAL
   
   1.4 Obtener ventana de datos
       - desde: última ejecución exitosa
       - hasta: NOW()
   
   FASE 2: EXTRACT (10-20 min)
   ────────────────────────────────
   2.1 Extraer llamadas nuevas
       SELECT *
       FROM IVR_PROD.llamadas
       WHERE fecha_llamada >= :ultima_ejecucion
         AND fecha_llamada < :ahora
       
       Volumen estimado: 50,000-200,000 registros
   
   2.2 Extraer navegación de menús
       SELECT *
       FROM IVR_PROD.navegacion_menus
       WHERE fecha_navegacion >= :ultima_ejecucion
         AND fecha_navegacion < :ahora
       
       Volumen estimado: 100,000-500,000 registros
   
   2.3 Extraer transferencias
       SELECT *
       FROM IVR_PROD.transferencias
       WHERE fecha_transferencia >= :ultima_ejecucion
         AND fecha_transferencia < :ahora
       
       Volumen estimado: 20,000-80,000 registros
   
   FASE 3: TRANSFORM (5-15 min)
   ─────────────────────────────────
   3.1 Limpieza de datos
       - Eliminar registros duplicados
       - Normalizar códigos de centro
       - Validar fechas (no futuras)
       - Corregir tipos de dato
   
   3.2 Enriquecimiento
       - Agregar centro_nombre desde catálogo
       - Calcular duracion_total = duracion_ivr + duracion_agente
       - Clasificar horarios (diurno, nocturno, fin de semana)
   
   3.3 Agregaciones pre-calculadas
       - Totales por día + centro
       - Totales por hora + centro
       - Promedios de duración
       - Top 10 problemas de menú
   
   FASE 4: LOAD (5-10 min)
   ────────────────────────────────
   4.1 Insertar en tablas IACT
       BEGIN TRANSACTION
       
       INSERT INTO iact_db.llamadas_ivr (...)
       VALUES (...) 
       ON DUPLICATE KEY UPDATE ...
       
       INSERT INTO iact_db.navegacion_ivr (...)
       VALUES (...)
       ON DUPLICATE KEY UPDATE ...
       
       INSERT INTO iact_db.transferencias (...)
       VALUES (...)
       ON DUPLICATE KEY UPDATE ...
       
       COMMIT
   
   4.2 Actualizar tabla de agregaciones
       TRUNCATE TABLE iact_db.agregaciones_diarias
       INSERT INTO iact_db.agregaciones_diarias
       SELECT fecha, centro_id, COUNT(*), AVG(duracion), ...
       FROM iact_db.llamadas_ivr
       GROUP BY fecha, centro_id
   
   FASE 5: POST-VALIDACIÓN (2-5 min)
   ──────────────────────────────────
   5.1 Validar integridad
       - Comparar count(*) IVR vs IACT
       - Diferencia < 0.1% → OK
       - Diferencia > 0.1% → WARNING
   
   5.2 Actualizar metadatos
       INSERT INTO etl_executions (
           ejecucion_id,
           fecha_inicio,
           fecha_fin,
           estado,
           registros_extraidos,
           registros_insertados,
           errores,
           duracion_segundos
       ) VALUES (...)
   
   5.3 Notificar resultado
       - Si SUCCESS → Notificación INFO en buzón de admins ETL
       - Si WARNING → Notificación WARNING
       - Si ERROR → Notificación CRITICAL + email externo (excepción CNST_001)
   
   ESTADOS POSIBLES:
   ─────────────────
   - SUCCESS: ETL completado sin errores
   - SUCCESS_WITH_WARNINGS: Completado con advertencias menores
   - PARTIAL_SUCCESS: Completado parcialmente (algunos registros fallaron)
   - FAILED: ETL falló, datos inconsistentes
   - ABORTED: ETL cancelado manualmente

2.3 Tablas Afectadas
---------------------

**En BD IVR (Oracle) - READONLY:**

.. list-table:: Tablas del IVR
   :header-rows: 1
   :widths: 30 70

   * - Tabla
     - Descripción
   * - ``IVR_PROD.llamadas``
     - Registro de todas las llamadas al IVR
   * - ``IVR_PROD.navegacion_menus``
     - Navegación del usuario por los menús
   * - ``IVR_PROD.transferencias``
     - Transferencias a agentes/centros
   * - ``IVR_PROD.catalogos``
     - Catálogos de centros, menús, códigos

**En BD IACT (MySQL) - READ/WRITE:**

.. list-table:: Tablas Espejo en IACT
   :header-rows: 1
   :widths: 30 70

   * - Tabla
     - Descripción
   * - ``llamadas_ivr``
     - Copia de llamadas del IVR
   * - ``navegacion_ivr``
     - Copia de navegación de menús
   * - ``transferencias``
     - Copia de transferencias
   * - ``agregaciones_diarias``
     - Agregaciones pre-calculadas
   * - ``agregaciones_horarias``
     - Agregaciones por hora
   * - ``etl_executions``
     - Historial de ejecuciones ETL

============================================================
3. FUNCIONES RBAC AFECTADAS
============================================================

3.1 MOD_Pipeline: Supervisión del ETL
---------------------------------------

**PIP-001: ve_estado_etl**

.. code-block:: yaml

   Función: ve_estado_etl
   Capacidad: pipeline:ver_estado
   Módulo: MOD_Pipeline
   
   Información visible:
     - Última ejecución exitosa:
       * Timestamp: 2026-01-11 06:15:23
       * Estado: SUCCESS
       * Duración: 23 minutos
       * Registros procesados: 156,432
     
     - Próxima ejecución programada:
       * Timestamp: 2026-01-11 18:00:00
       * Tiempo restante: 5h 32m
     
     - Estado actual:
       * IDLE (esperando próxima ejecución)
       * RUNNING (ETL en progreso - mostrar %)
       * ERROR (último ETL falló)
     
     - Histórico últimas 10 ejecuciones:
       * Fecha
       * Duración
       * Estado
       * Registros procesados
   
   Restricción CNST_003:
     ✓ Muestra desfase de datos
     ✓ Indica próxima actualización
     ✓ NO permite forzar ETL manual (usar PIP-004)
   
   Caso de Uso: UC-050
   Código de ejemplo: Ver sección 6.1

**PIP-002: ve_errores_etl**

.. code-block:: yaml

   Función: ve_errores_etl
   Capacidad: pipeline:ver_errores
   Módulo: MOD_Pipeline
   
   Información visible:
     - Errores de última ejecución:
       * Timestamp del error
       * Fase del ETL (Extract, Transform, Load)
       * Mensaje de error
       * Stack trace (si aplica)
       * Tabla/dato afectado
     
     - Histórico de errores:
       * Últimos 30 días
       * Filtros por fase, tipo, severidad
     
     - Tendencias:
       * Errores por día (gráfico)
       * Errores más frecuentes (top 10)
   
   Restricción CNST_003:
     ✓ Ayuda a diagnosticar por qué datos están desfasados
     ✓ Permite investigar fallos del ETL
   
   Caso de Uso: UC-051

**PIP-003: ve_disponibilidad_datos**

.. code-block:: yaml

   Función: ve_disponibilidad_datos
   Capacidad: pipeline:disponibilidad
   Módulo: MOD_Pipeline
   
   Información visible:
     - Última actualización por tabla:
       * llamadas_ivr: 2026-01-11 06:15:23
       * navegacion_ivr: 2026-01-11 06:16:45
       * transferencias: 2026-01-11 06:17:12
     
     - Completitud de datos:
       * % de registros vs esperado
       * Fechas con gaps de datos
       * Alertas de datos faltantes
     
     - Desfase actual:
       * Datos disponibles hasta: 2026-01-11 06:00:00
       * Desfase: 5 horas 32 minutos
       * Próxima actualización: 2026-01-11 18:00:00
   
   Restricción CNST_003:
     ✓ Transparencia sobre frescura de datos
     ✓ Usuario informado del desfase
   
   Caso de Uso: UC-052

**PIP-004: solicita_reintento_etl**

.. code-block:: yaml

   Función: solicita_reintento_etl
   Capacidad: pipeline:reintento
   Módulo: MOD_Pipeline
   
   Acción:
     - Permite solicitar un reintento del ETL SI:
       * Última ejecución falló (ERROR)
       * Han pasado >2 horas desde el fallo
       * Usuario tiene función PIP-004
     
     - NO permite:
       * Forzar ETL fuera de schedule
       * Reintentos ilimitados (max 3/día)
       * Sobrescribir ETL en progreso
   
   Proceso:
     1. Validar condiciones de reintento
     2. Marcar ejecución actual como ABORTED
     3. Crear nueva ejecución en cola
     4. Airflow pickup automáticamente
     5. Notificar en buzón interno
   
   Restricción CNST_003:
     ✓ Control limitado sobre ETL
     ✓ Prevenir sobrecarga del IVR
   
   Caso de Uso: UC-053

3.2 MOD_Reports: Todos Afectados
----------------------------------

**Impacto en TODAS las funciones de reportes:**

.. list-table:: Funciones de Reportes con Datos Desfasados
   :header-rows: 1
   :widths: 15 35 50

   * - Función
     - Capacidad
     - Impacto CNST_003
   * - RPT-001
     - ve_reportes
     - Datos desfasados 6-12h, indicador visible
   * - RPT-002
     - ve_dashboard
     - KPIs desfasados, timestamp visible
   * - RPT-003
     - filtra_reportes
     - Filtros sobre datos desfasados
   * - RPT-004
     - exporta_csv
     - Exporta datos desfasados con advertencia
   * - RPT-005
     - exporta_excel
     - Exporta datos desfasados con advertencia
   * - RPT-006
     - exporta_pdf
     - Exporta datos desfasados con advertencia
   * - RPT-007
     - ve_kpis
     - KPIs estáticos desfasados
   * - RPT-008
     - ve_graficos
     - Gráficos con datos desfasados

**Indicador Obligatorio en UI:**

.. code-block:: html

   <!-- Banner en TODAS las páginas de reportes -->
   <div class="alert alert-info">
       <i class="icon-info"></i>
       <strong>Datos actualizados al:</strong> 2026-01-11 06:15:23
       <span class="text-muted">(hace 5 horas 32 minutos)</span>
       <br>
       <small>Próxima actualización: 2026-01-11 18:00:00 (en 6 horas 28 min)</small>
   </div>

============================================================
4. MODELO DE DATOS
============================================================

4.1 Tabla: etl_executions
---------------------------

.. code-block:: sql

   CREATE TABLE etl_executions (
       ejecucion_id BIGINT AUTO_INCREMENT PRIMARY KEY,
       fecha_inicio DATETIME NOT NULL,
       fecha_fin DATETIME,
       estado ENUM(
           'SUCCESS', 
           'SUCCESS_WITH_WARNINGS',
           'PARTIAL_SUCCESS',
           'FAILED',
           'ABORTED',
           'RUNNING'
       ) NOT NULL DEFAULT 'RUNNING',
       
       -- Métricas de extracción
       registros_extraidos INT DEFAULT 0,
       registros_insertados INT DEFAULT 0,
       registros_actualizados INT DEFAULT 0,
       registros_con_error INT DEFAULT 0,
       
       -- Detalles por tabla
       llamadas_extraidas INT DEFAULT 0,
       navegacion_extraida INT DEFAULT 0,
       transferencias_extraidas INT DEFAULT 0,
       
       -- Performance
       duracion_segundos INT,
       fase_actual VARCHAR(50),  -- 'EXTRACT', 'TRANSFORM', 'LOAD', 'VALIDATE'
       
       -- Errores
       errores_count INT DEFAULT 0,
       errores_log JSON,  -- Array de mensajes de error
       warnings_log JSON,  -- Array de advertencias
       
       -- Auditoría
       ejecutado_por VARCHAR(100) DEFAULT 'airflow_scheduler',
       metadata JSON,
       
       INDEX idx_etl_fecha_inicio (fecha_inicio DESC),
       INDEX idx_etl_estado (estado)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

4.2 Tabla: llamadas_ivr (espejo)
----------------------------------

.. code-block:: sql

   CREATE TABLE llamadas_ivr (
       llamada_id BIGINT PRIMARY KEY,  -- ID del IVR
       fecha_llamada DATETIME NOT NULL,
       hora_llamada TIME NOT NULL,
       
       -- Identificación
       ani VARCHAR(20),  -- Número del cliente (anonimizado)
       dnis VARCHAR(20),  -- Número marcado
       
       -- Información de la llamada
       duracion_ivr INT,  -- Segundos en el IVR
       duracion_agente INT,  -- Segundos con agente
       duracion_total INT,  -- Total de la llamada
       
       -- Centro y transferencia
       centro_id VARCHAR(10),
       centro_nombre VARCHAR(100),
       transferido BOOLEAN DEFAULT FALSE,
       
       -- Clasificación
       tipo_llamada VARCHAR(50),  -- 'normal', 'abandono', 'error'
       resultado VARCHAR(50),  -- 'atendida', 'abandonada', 'ocupado'
       
       -- Datos del IVR
       menus_navegados INT DEFAULT 0,
       problema_identificado BOOLEAN DEFAULT FALSE,
       codigo_problema VARCHAR(20),
       
       -- Metadatos
       fecha_sincronizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       ejecucion_etl_id BIGINT,
       
       CONSTRAINT fk_llamada_etl FOREIGN KEY (ejecucion_etl_id)
           REFERENCES etl_executions(ejecucion_id),
       
       INDEX idx_llamada_fecha (fecha_llamada),
       INDEX idx_llamada_centro (centro_id),
       INDEX idx_llamada_sincronizacion (fecha_sincronizacion)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

4.3 Vista: Disponibilidad de Datos
------------------------------------

.. code-block:: sql

   CREATE VIEW vw_disponibilidad_datos AS
   SELECT 
       'llamadas_ivr' AS tabla,
       MAX(fecha_llamada) AS ultima_fecha_dato,
       MAX(fecha_sincronizacion) AS ultima_sincronizacion,
       COUNT(*) AS total_registros,
       TIMESTAMPDIFF(HOUR, MAX(fecha_sincronizacion), NOW()) 
           AS horas_desfase
   FROM llamadas_ivr
   
   UNION ALL
   
   SELECT 
       'navegacion_ivr' AS tabla,
       MAX(fecha_navegacion) AS ultima_fecha_dato,
       MAX(fecha_sincronizacion) AS ultima_sincronizacion,
       COUNT(*) AS total_registros,
       TIMESTAMPDIFF(HOUR, MAX(fecha_sincronizacion), NOW()) 
           AS horas_desfase
   FROM navegacion_ivr
   
   UNION ALL
   
   SELECT 
       'transferencias' AS tabla,
       MAX(fecha_transferencia) AS ultima_fecha_dato,
       MAX(fecha_sincronizacion) AS ultima_sincronizacion,
       COUNT(*) AS total_registros,
       TIMESTAMPDIFF(HOUR, MAX(fecha_sincronizacion), NOW()) 
           AS horas_desfase
   FROM transferencias;

============================================================
5. CREDENCIALES Y PERMISOS
============================================================

5.1 Usuario de BD IVR (Readonly)
----------------------------------

.. code-block:: sql

   -- En Oracle (BD IVR)
   -- Usuario: iact_readonly
   
   CREATE USER iact_readonly IDENTIFIED BY '<password_complejo>';
   
   -- SOLO permisos de lectura
   GRANT CONNECT TO iact_readonly;
   GRANT SELECT ON IVR_PROD.llamadas TO iact_readonly;
   GRANT SELECT ON IVR_PROD.navegacion_menus TO iact_readonly;
   GRANT SELECT ON IVR_PROD.transferencias TO iact_readonly;
   GRANT SELECT ON IVR_PROD.catalogos TO iact_readonly;
   
   -- EXPLÍCITAMENTE NO otorgar:
   -- GRANT INSERT ... → PROHIBIDO
   -- GRANT UPDATE ... → PROHIBIDO
   -- GRANT DELETE ... → PROHIBIDO
   -- GRANT CREATE ... → PROHIBIDO
   -- GRANT DROP ... → PROHIBIDO

5.2 Validación de Permisos
----------------------------

.. code-block:: python

   # file: etl/validators.py
   import cx_Oracle
   
   def validar_permisos_readonly():
       """
       Valida que usuario IVR solo tiene permisos SELECT.
       
       Ejecutar antes de cada ETL.
       """
       conn = cx_Oracle.connect(
           user='iact_readonly',
           password=settings.IVR_DB_PASSWORD,
           dsn='ivr-db.prod.internal:1521/IVR_PROD'
       )
       
       cursor = conn.cursor()
       
       # Intentar INSERT (debe fallar)
       try:
           cursor.execute("""
               INSERT INTO IVR_PROD.llamadas (llamada_id, fecha_llamada)
               VALUES (999999999, SYSDATE)
           """)
           conn.commit()
           
           # Si llegamos aquí, hay un problema crítico
           raise SecurityError(
               "¡CRÍTICO! Usuario iact_readonly puede escribir en BD IVR"
           )
       
       except cx_Oracle.DatabaseError as e:
           error_code = e.args[0].code
           if error_code == 1031:  # ORA-01031: insufficient privileges
               # Esperado - usuario NO puede escribir
               pass
           else:
               # Error inesperado
               raise
       
       # Intentar SELECT (debe funcionar)
       cursor.execute("SELECT COUNT(*) FROM IVR_PROD.llamadas WHERE ROWNUM = 1")
       result = cursor.fetchone()
       
       if result is None:
           raise ConnectionError("No se puede leer de BD IVR")
       
       conn.close()
       
       return {
           'readonly_validado': True,
           'puede_leer': True,
           'puede_escribir': False
       }

============================================================
6. IMPLEMENTACIÓN DJANGO
============================================================

6.1 Servicio: Estado del ETL
------------------------------

.. code-block:: python

   # file: pipeline/services.py
   from django.db import models
   from django.utils import timezone
   from datetime import timedelta
   from .models import ETLExecution
   
   class ETLService:
       """
       Servicio para gestión y monitoreo del ETL.
       
       Implementa funciones PIP-001, PIP-002, PIP-003, PIP-004.
       """
       
       @staticmethod
       def obtener_estado_etl():
           """
           Obtiene el estado actual del ETL.
           
           Implementa PIP-001: ve_estado_etl
           
           Returns:
               dict: Estado completo del ETL
           """
           # Última ejecución
           ultima_ejecucion = ETLExecution.objects.order_by(
               '-fecha_inicio'
           ).first()
           
           if not ultima_ejecucion:
               return {
                   'estado': 'SIN_EJECUCIONES',
                   'mensaje': 'No hay ejecuciones registradas'
               }
           
           # Próxima ejecución programada
           # ETL corre a las 06:00 y 18:00
           ahora = timezone.now()
           if ahora.hour < 6:
               proxima = ahora.replace(hour=6, minute=0, second=0, microsecond=0)
           elif ahora.hour < 18:
               proxima = ahora.replace(hour=18, minute=0, second=0, microsecond=0)
           else:
               proxima = (ahora + timedelta(days=1)).replace(
                   hour=6, minute=0, second=0, microsecond=0
               )
           
           tiempo_restante = proxima - ahora
           
           # Desfase de datos
           if ultima_ejecucion.estado == 'SUCCESS':
               desfase = ahora - ultima_ejecucion.fecha_fin
               datos_actualizados_al = ultima_ejecucion.fecha_fin
           else:
               # Si falló, buscar última exitosa
               ultima_exitosa = ETLExecution.objects.filter(
                   estado__in=['SUCCESS', 'SUCCESS_WITH_WARNINGS']
               ).order_by('-fecha_inicio').first()
               
               if ultima_exitosa:
                   desfase = ahora - ultima_exitosa.fecha_fin
                   datos_actualizados_al = ultima_exitosa.fecha_fin
               else:
                   desfase = None
                   datos_actualizados_al = None
           
           return {
               'estado': 'OK' if ultima_ejecucion.estado == 'SUCCESS' else 'ERROR',
               'ultima_ejecucion': {
                   'id': ultima_ejecucion.ejecucion_id,
                   'fecha_inicio': ultima_ejecucion.fecha_inicio,
                   'fecha_fin': ultima_ejecucion.fecha_fin,
                   'estado': ultima_ejecucion.estado,
                   'duracion_minutos': ultima_ejecucion.duracion_segundos // 60 
                       if ultima_ejecucion.duracion_segundos else None,
                   'registros_procesados': ultima_ejecucion.registros_insertados,
                   'errores': ultima_ejecucion.errores_count
               },
               'proxima_ejecucion': {
                   'timestamp': proxima,
                   'tiempo_restante_minutos': int(tiempo_restante.total_seconds() // 60)
               },
               'desfase_datos': {
                   'datos_actualizados_al': datos_actualizados_al,
                   'desfase_horas': desfase.total_seconds() / 3600 
                       if desfase else None
               },
               'historico_10': list(
                   ETLExecution.objects.order_by('-fecha_inicio')[:10].values(
                       'ejecucion_id', 'fecha_inicio', 'estado', 
                       'duracion_segundos', 'registros_insertados'
                   )
               )
           }
       
       @staticmethod
       def obtener_errores_etl(ejecucion_id=None):
           """
           Obtiene errores del ETL.
           
           Implementa PIP-002: ve_errores_etl
           
           Args:
               ejecucion_id: ID de ejecución específica (None = última)
           
           Returns:
               dict: Errores y warnings
           """
           if ejecucion_id:
               ejecucion = ETLExecution.objects.get(ejecucion_id=ejecucion_id)
           else:
               ejecucion = ETLExecution.objects.order_by('-fecha_inicio').first()
           
           if not ejecucion:
               return {'errores': [], 'warnings': []}
           
           return {
               'ejecucion_id': ejecucion.ejecucion_id,
               'fecha': ejecucion.fecha_inicio,
               'estado': ejecucion.estado,
               'errores': ejecucion.errores_log or [],
               'warnings': ejecucion.warnings_log or [],
               'errores_count': ejecucion.errores_count,
               'fase_fallo': ejecucion.fase_actual if ejecucion.estado == 'FAILED' else None
           }
       
       @staticmethod
       def obtener_disponibilidad_datos():
           """
           Obtiene disponibilidad y frescura de datos.
           
           Implementa PIP-003: ve_disponibilidad_datos
           
           Returns:
               dict: Disponibilidad por tabla
           """
           from django.db import connection
           
           with connection.cursor() as cursor:
               cursor.execute("SELECT * FROM vw_disponibilidad_datos")
               columns = [col[0] for col in cursor.description]
               results = [
                   dict(zip(columns, row))
                   for row in cursor.fetchall()
               ]
           
           return {
               'tablas': results,
               'desfase_promedio_horas': sum(r['horas_desfase'] for r in results) / len(results),
               'datos_completos': all(r['horas_desfase'] < 24 for r in results)
           }
       
       @staticmethod
       def solicitar_reintento_etl(usuario):
           """
           Solicita un reintento del ETL.
           
           Implementa PIP-004: solicita_reintento_etl
           
           Args:
               usuario: Usuario que solicita el reintento
           
           Raises:
               PermissionError: Si usuario no tiene función PIP-004
               ValueError: Si no se cumplen condiciones de reintento
           
           Returns:
               dict: Confirmación de solicitud
           """
           from core.rbac import RBACManager
           
           # Validar permiso
           rbac = RBACManager()
           if not rbac.user_has_function(usuario, 'solicita_reintento_etl'):
               raise PermissionError("Requiere función PIP-004")
           
           # Obtener última ejecución
           ultima = ETLExecution.objects.order_by('-fecha_inicio').first()
           
           if not ultima:
               raise ValueError("No hay ejecuciones previas")
           
           # Validar condiciones
           if ultima.estado not in ['FAILED', 'PARTIAL_SUCCESS']:
               raise ValueError(
                   f"Última ejecución está en estado {ultima.estado}. "
                   f"Solo se puede reintentar FAILED o PARTIAL_SUCCESS"
               )
           
           # Validar que han pasado >2 horas
           tiempo_desde_fallo = timezone.now() - ultima.fecha_inicio
           if tiempo_desde_fallo < timedelta(hours=2):
               raise ValueError(
                   f"Deben pasar al menos 2 horas desde el fallo. "
                   f"Tiempo transcurrido: {tiempo_desde_fallo}"
               )
           
           # Validar límite de reintentos (max 3/día)
           reintentos_hoy = ETLExecution.objects.filter(
               fecha_inicio__gte=timezone.now().replace(hour=0, minute=0, second=0),
               ejecutado_por__contains='reintento'
           ).count()
           
           if reintentos_hoy >= 3:
               raise ValueError("Límite de 3 reintentos/día alcanzado")
           
           # Marcar ejecución actual como ABORTED
           ultima.estado = 'ABORTED'
           ultima.save(update_fields=['estado'])
           
           # Crear nueva ejecución en cola
           # (Airflow la pickup automáticamente)
           nueva = ETLExecution.objects.create(
               estado='RUNNING',
               ejecutado_por=f'reintento_manual_by_{usuario.username}',
               metadata={
                   'tipo': 'reintento_manual',
                   'solicitado_por': usuario.username,
                   'ejecucion_previa_id': ultima.ejecucion_id
               }
           )
           
           # Notificar en buzón
           from core.buzon_interno import BuzonInterno
           BuzonInterno.enviar_notificacion(
               usuario_id=usuario.usuario_id,
               tipo='SISTEMA',
               severidad='INFO',
               titulo='Reintento de ETL solicitado',
               mensaje=(
                   f"Se ha solicitado un reintento del ETL.\n"
                   f"Ejecución ID: {nueva.ejecucion_id}\n"
                   f"Estado: En cola para procesamiento\n\n"
                   f"Recibirás una notificación cuando complete."
               )
           )
           
           return {
               'success': True,
               'nueva_ejecucion_id': nueva.ejecucion_id,
               'mensaje': 'Reintento solicitado exitosamente'
           }

6.2 Decorador: Mostrar Desfase de Datos
-----------------------------------------

.. code-block:: python

   # file: reports/decorators.py
   from functools import wraps
   from django.shortcuts import render
   from pipeline.services import ETLService
   
   def mostrar_desfase_datos(view_func):
       """
       Decorador que inyecta información de desfase de datos
       en el contexto de reportes.
       
       Cumple CNST_003: Transparencia sobre frescura de datos.
       """
       @wraps(view_func)
       def _wrapped_view(request, *args, **kwargs):
           # Obtener estado ETL
           estado_etl = ETLService.obtener_estado_etl()
           
           # Inyectar en request
           request.desfase_datos = estado_etl['desfase_datos']
           request.proxima_actualizacion = estado_etl['proxima_ejecucion']
           
           # Ejecutar vista original
           response = view_func(request, *args, **kwargs)
           
           # Si es render, agregar al contexto
           if hasattr(response, 'context_data'):
               response.context_data['desfase_datos'] = request.desfase_datos
               response.context_data['proxima_actualizacion'] = request.proxima_actualizacion
           
           return response
       
       return _wrapped_view
   
   # Uso en vistas de reportes
   from django.views.generic import TemplateView
   from django.utils.decorators import method_decorator
   
   @method_decorator(mostrar_desfase_datos, name='dispatch')
   class ReporteTrimestralView(TemplateView):
       template_name = 'reportes/trimestral.html'
       
       def get_context_data(self, **kwargs):
           context = super().get_context_data(**kwargs)
           # desfase_datos ya está en context por el decorador
           return context

============================================================
7. ALERTAS Y MONITOREO ETL
============================================================

7.1 Alertas Automáticas
-------------------------

.. code-block:: python

   # file: pipeline/monitors.py
   from core.buzon_interno import BuzonInterno
   from users.models import Usuario
   
   def verificar_salud_etl():
       """
       Verifica salud del ETL y envía alertas si es necesario.
       
       Ejecutar cada hora vía cron.
       """
       from pipeline.models import ETLExecution
       from pipeline.services import ETLService
       
       estado = ETLService.obtener_estado_etl()
       
       # ALERTA 1: Última ejecución falló
       if estado['estado'] == 'ERROR':
           usuarios_admin_etl = Usuario.objects.filter(
               usuariofuncion__funcion__nombre='ve_errores_etl',
               usuariofuncion__activa=True
           ).distinct()
           
           for usuario in usuarios_admin_etl:
               BuzonInterno.enviar_notificacion(
                   usuario_id=usuario.usuario_id,
                   tipo='ALERTA',
                   severidad='CRITICAL',
                   titulo='⚠️ ETL ha fallado',
                   mensaje=(
                       f"La última ejecución del ETL ha fallado.\n\n"
                       f"Ejecución ID: {estado['ultima_ejecucion']['id']}\n"
                       f"Fecha: {estado['ultima_ejecucion']['fecha_inicio']}\n"
                       f"Errores: {estado['ultima_ejecucion']['errores']}\n\n"
                       f"Los datos están desfasados. Revisa los errores."
                   ),
                   url_accion='/pipeline/errores'
               )
       
       # ALERTA 2: Datos muy desfasados (>24h)
       desfase_horas = estado['desfase_datos']['desfase_horas']
       if desfase_horas and desfase_horas > 24:
           # Enviar alerta crítica
           pass
       
       # ALERTA 3: ETL tarda mucho (>2h)
       if estado['ultima_ejecucion']['duracion_minutos']:
           if estado['ultima_ejecucion']['duracion_minutos'] > 120:
               # Enviar alerta warning
               pass

============================================================
8. VALIDACIÓN Y TESTING
============================================================

8.1 Tests de Integración ETL
------------------------------

.. code-block:: python

   # file: tests/test_cnst_003.py
   from django.test import TestCase
   from pipeline.models import ETLExecution
   from pipeline.services import ETLService
   
   class TestCNST003(TestCase):
       """
       Tests para validar CNST_003: BD IVR readonly, ETL 6-12h, NO real-time
       """
       
       def test_bd_ivr_es_readonly(self):
           """Validar que BD IVR es readonly."""
           from etl.validators import validar_permisos_readonly
           
           resultado = validar_permisos_readonly()
           
           self.assertTrue(resultado['readonly_validado'])
           self.assertTrue(resultado['puede_leer'])
           self.assertFalse(resultado['puede_escribir'])
       
       def test_datos_tienen_desfase(self):
           """Validar que datos muestran desfase."""
           # Crear ejecución ETL simulada
           ejecucion = ETLExecution.objects.create(
               fecha_inicio=timezone.now() - timedelta(hours=8),
               fecha_fin=timezone.now() - timedelta(hours=7, minutes=30),
               estado='SUCCESS',
               registros_insertados=100000
           )
           
           estado = ETLService.obtener_estado_etl()
           
           # Debe mostrar desfase
           self.assertIsNotNone(estado['desfase_datos']['desfase_horas'])
           self.assertGreater(estado['desfase_datos']['desfase_horas'], 7)
       
       def test_no_real_time(self):
           """Validar que NO hay datos en tiempo real."""
           from llamadas.models import LlamadaIVR
           
           # Última llamada en BD
           ultima_llamada = LlamadaIVR.objects.order_by(
               '-fecha_llamada'
           ).first()
           
           if ultima_llamada:
               # Debe estar desfasada al menos 6 horas
               desfase = timezone.now() - ultima_llamada.fecha_sincronizacion
               self.assertGreater(desfase.total_seconds(), 6 * 3600)

============================================================
9. REFERENCIAS
============================================================

9.1 Documentos Relacionados
-----------------------------

:CNST_005: RBAC Flat, funciones de pipeline
:CNST_006: Reportes con rango máximo 2 años
:UC_050: Ver estado del ETL
:UC_051: Ver errores del ETL
:UC_052: Consultar disponibilidad de datos
:UC_053: Solicitar reintento del ETL

9.2 Funciones RBAC Relacionadas
---------------------------------

:PIP_001: ve_estado_etl
:PIP_002: ve_errores_etl
:PIP_003: ve_disponibilidad_datos
:PIP_004: solicita_reintento_etl
:RPT_001-008: Todos los reportes (datos desfasados)

============================================================
10. HISTORIAL DE CAMBIOS
============================================================

.. list-table:: Historial de Versiones
   :header-rows: 1
   :widths: 15 15 70

   * - Versión
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-11
     - Versión inicial. Documentación completa de CNST_003:
       BD IVR readonly, ETL cada 6-12h, NO real-time.
       Incluye: arquitectura ETL, proceso completo, modelo de datos,
       implementación Django, validación de permisos.

============================================================

.. warning::
   **RECORDATORIO CRÍTICO:**
   
   CNST_003 define restricciones FUNDAMENTALES del sistema:
   - BD IVR: SOLO lectura (SELECT), NUNCA escritura
   - ETL: Cada 6-12 horas (06:00 y 18:00)
   - Datos: Desfasados 6-12h, NO real-time
   - UI: SIEMPRE mostrar timestamp de última actualización
   
   Violar estas restricciones puede afectar el sistema IVR en producción.

**FIN DEL DOCUMENTO CNST_003**
