.. meta::
   :artefacto: BR_002
   :tipo: Business Rule
   :subtipo: Desencadenador
   :modalidad: Deontica (Obligacion)
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-002:

==============================================================================
BR_002: ETL Batch Nocturno
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   SI la hora del sistema es 00:00 (medianoche, hora local),
   ENTONCES el sistema DEBE ejecutar el proceso ETL de sincronizacion
   desde la base de datos MySQL operacional hacia PostgreSQL analytics.

**Enunciado SBVR:**

   It is obligatory that IACT system executes ETL synchronization process
   when system time is 00:00 local time.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Desencadenador (Trigger)
   * - **Modalidad**
     - Deontica - Obligacion (Obligation)
   * - **Estatica/Dinamica**
     - Dinamica (horario puede ajustarse por operaciones)

**Nota:** Este es un DESENCADENADOR porque la accion (ejecucion ETL)
es OBSERVABLE: genera logs, actualiza timestamps, puede notificar
estado. Por tanto, genera Caso de Uso.

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Arquitectura del Sistema - Decision de Diseno
   * - **Documento**
     - ADR_002 Base de Datos Dual MySQL/PostgreSQL
   * - **Seccion**
     - 4. Estrategia de Sincronizacion
   * - **Fecha Vigencia**
     - 2025-01-15

----

Justificacion
-------------

1. **Minimizar impacto operacional:** La medianoche es el periodo de
   menor actividad del sistema IVR, reduciendo el impacto de las
   consultas ETL en el rendimiento operacional.

2. **Datos actualizados diariamente:** Los usuarios de analytics
   requieren datos del dia anterior disponibles al inicio de cada
   jornada laboral.

3. **Ventana de mantenimiento:** Permite que cualquier problema del
   ETL sea detectado y corregido antes del horario laboral.

4. **Consistencia de datos:** Al ejecutar en horario fijo, se garantiza
   que los reportes reflejan un corte temporal consistente.

----

Condicion y Accion
------------------

Condicion (SI)
^^^^^^^^^^^^^^

.. code-block:: text

   Condicion: hora_sistema = 00:00 (medianoche local)

   Verificacion:
   - Scheduler del sistema (cron, celery beat, etc.)
   - Timezone configurado correctamente
   - Servidor sincronizado con NTP

Accion (ENTONCES)
^^^^^^^^^^^^^^^^^

.. code-block:: text

   Accion: Ejecutar proceso ETL de sincronizacion

   Pasos del proceso:
   1. Conectar a MySQL con usuario readonly
   2. Leer datos nuevos/modificados desde ultima ejecucion
   3. Transformar datos segun reglas de negocio
   4. Cargar datos en PostgreSQL analytics
   5. Registrar resultado en tabla ETLExecution
   6. Actualizar timestamp de ultima sincronizacion

Observabilidad
^^^^^^^^^^^^^^

La accion es OBSERVABLE porque:

- Genera registro en tabla ETLExecution
- Actualiza campo last_sync_at
- Puede consultarse via UC_050 (Supervisar ETL)
- Genera logs tecnicos en MOD_Logs
- Si falla, genera alerta (BR_014)

----

Caso de Uso Generado
--------------------

Esta BR genera directamente el siguiente Caso de Uso:

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - UC
     - Nombre
     - Tipo
   * - UC_050
     - Supervisar ETL
     - UC de Sistema (actor: Tiempo)

Adicionalmente influye en:

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - UC
     - Nombre
     - Como Influye
   * - UC_051
     - Consultar Errores ETL
     - Errores del proceso batch
   * - UC_052
     - Consultar Disponibilidad
     - Estado de datos post-ETL
   * - UC_053
     - Solicitar Reintento ETL
     - Reintento manual si falla

----

Requisitos Funcionales Derivados
--------------------------------

Del proceso ETL:

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-050.01
     - Sistema DEBE ejecutar proceso ETL automaticamente a las 00:00
   * - FR-050.02
     - Sistema DEBE conectar a MySQL usando credenciales readonly
   * - FR-050.03
     - Sistema DEBE identificar registros nuevos desde ultima ejecucion
   * - FR-050.04
     - Sistema DEBE transformar datos segun reglas de mapeo
   * - FR-050.05
     - Sistema DEBE insertar datos transformados en PostgreSQL
   * - FR-050.06
     - Sistema DEBE registrar ejecucion en tabla ETLExecution
   * - FR-050.07
     - Sistema DEBE actualizar timestamp de ultima sincronizacion
   * - FR-050.08
     - Sistema DEBE registrar errores en tabla ETLError si ocurren

De la observabilidad:

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-050.09
     - Sistema DEBE permitir consultar historial de ejecuciones ETL
   * - FR-050.10
     - Sistema DEBE mostrar ultima ejecucion exitosa
   * - FR-050.11
     - Sistema DEBE mostrar proxima ejecucion programada

----

Frecuencia y Parametros
-----------------------

Configuracion Base
^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70

   * - **Frecuencia**
     - Diaria
   * - **Hora de Ejecucion**
     - 00:00 (medianoche)
   * - **Timezone**
     - Hora local del servidor
   * - **Duracion Tipica**
     - 15-45 minutos
   * - **Timeout Maximo**
     - 120 minutos

Ventana de Ejecucion
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   00:00 - 02:00  Ventana primaria de ejecucion ETL
   02:00 - 06:00  Ventana de reintento si falla
   06:00 - 23:59  Sin ejecucion automatica (solo manual)

----

Manejo de Fallos
----------------

Escenarios de Fallo
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 40 35

   * - Escenario
     - Causa
     - Accion
   * - Conexion fallida
     - MySQL no disponible
     - Reintentar 3 veces, luego alertar
   * - Timeout
     - Volumen excesivo de datos
     - Registrar parcial, alertar
   * - Error de transformacion
     - Datos invalidos en fuente
     - Saltar registro, continuar, alertar
   * - Espacio insuficiente
     - PostgreSQL lleno
     - Abortar, alertar critico

Politica de Reintentos
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Reintento automatico:
   - Maximo 3 intentos
   - Espera entre intentos: 15 minutos
   - Si 3 fallos consecutivos: alertar a administrador

   Reintento manual:
   - Disponible via UC_053
   - Requiere rol R015 (MODULES_ADMIN) o superior
   - Registra quien solicito el reintento

----

Restricciones Tecnicas Relacionadas
-----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - CNST
     - Nombre
     - Relacion
   * - CNST_003
     - Base de Datos Dual Inmutable
     - Define arquitectura dual
   * - CNST_004
     - Actualizacion Datos ETL
     - Implementa esta BR

----

Impacto en Modulos
------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Modulo
     - Impacto
   * - MOD_Pipeline
     - Responsable de ejecutar el ETL
   * - MOD_Reports
     - Consume datos sincronizados
   * - MOD_Alerts
     - Recibe alertas si ETL falla
   * - MOD_Logs
     - Registra logs tecnicos del proceso

----

Diagrama de Secuencia
---------------------

.. code-block:: text

   @startuml
   participant Scheduler
   participant ETLJob
   participant MySQL
   participant PostgreSQL
   participant ETLExecution

   Scheduler -> ETLJob: trigger (00:00)
   activate ETLJob

   ETLJob -> MySQL: SELECT nuevos registros
   MySQL --> ETLJob: datos

   ETLJob -> ETLJob: transformar datos

   ETLJob -> PostgreSQL: INSERT datos transformados
   PostgreSQL --> ETLJob: OK

   ETLJob -> ETLExecution: registrar ejecucion exitosa
   ETLExecution --> ETLJob: OK

   deactivate ETLJob
   @enduml

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. ETL se ejecuta automaticamente a las 00:00
2. Datos del dia anterior estan disponibles antes de las 06:00
3. Ejecucion se registra en ETLExecution
4. Errores se registran en ETLError
5. Administrador puede ver estado via UC_050

Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^

- Tests de integracion del scheduler
- Monitoreo de tabla ETLExecution
- Alertas configuradas para fallos

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`br-001` - BR_001 Fuente Inmutable
- :ref:`cnst-003` - CNST_003 Base de Datos Dual
- :ref:`cnst-004` - CNST_004 Actualizacion Datos ETL
- MOD_Pipeline - Modulo responsable

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

- Origen: ADR_002, Arquitectura del Sistema
- Implementa: CNST_004
- Genera: UC_050
- Influye: UC_051, UC_052, UC_053
- Deriva: FR-050.01 a FR-050.11
