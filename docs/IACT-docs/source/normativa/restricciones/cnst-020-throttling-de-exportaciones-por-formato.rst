.. meta::
 :artefacto: CNST_020
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 3.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-020:

================================================
CNST-020: Throttling de Exportaciones (Recursos)
================================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_020
 * - **Categoria**
   - Performance
 * - **Tipo (TXM_01)**
   - Tecnica
 * - **Criticidad**
   - Alto
 * - **Negociable**
   - No
 * - **Estado**
   - Vigente

1. Definicion
-------------

1.1 Enunciado
^^^^^^^^^^^^^

Las exportaciones DEBEN respetar restricciones de **recursos del
sistema**, NO límites arbitrarios por formato. La protección
opera en cuatro ejes:

1. **Procesamiento asíncrono** sobre umbral declarado en CNST-019.
2. **Aislamiento de recursos** — pool de workers dedicado a exports,
   separado del pool que sirve UI/API.
3. **Throttling anti-abuse** — concurrent jobs por usuario y quota
   diaria total por usuario, sin distinguir formato.
4. **Tamaño máximo del artefacto generado** — si el archivo final
   excede el límite operacional, se divide o rechaza con mensaje
   claro al usuario.

1.2 Justificacion
^^^^^^^^^^^^^^^^^

**Cambio de modelo v2.0.0 → v3.0.0:** la versión anterior declaraba
límites arbitrarios por formato (CSV 100K, Excel 50K, PDF 10K)
sin justificación empírica medida. Un reporte trimestral de
200 000 registros DEBE poder exportarse en cualquier formato si
los recursos del sistema lo soportan. La restricción real está
en los recursos (memoria, CPU, ancho de banda, archivos
inmanejables del lado cliente), no en el formato.

El modelo v3.0.0 mueve cifras concretas y prescripción
tecnológica al ADR de implementación, donde pueden ajustarse
según observación empírica de uso real.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Aislamiento de recursos + control anti-abuse
- **Documento original:** RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.rst:621-640 (v1.0)
- **Revisión v3.0.0:** WP rbac-modelo-conceptual-cleanup, decision D-08
- **Fecha:** 2026-04-30

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^

(detalle en parametros)

2.2 Parametros
^^^^^^^^^^^^^^

**Lo que esta CNST especifica (qué proteger):**

.. list-table::
 :header-rows: 1
 :widths: 25 75

 * - Parámetro
   - Descripción (sin cifras — definidas en ADR)
 * - Concurrent jobs por usuario
   - Máximo de exports en cola/proceso simultáneamente. Aplica al
     mismo usuario sin distinguir formato.
 * - Quota diaria por usuario
   - Máximo de exports completados en ventana de 24h, sin
     distinguir formato.
 * - Aislamiento de pool
   - Pool de workers dedicado a exports, NO compartido con UI/API.
 * - Tamaño máximo del archivo generado
   - Límite del archivo final entregado al usuario; si excede,
     dividir o rechazar.
 * - Timeout por tipo de generación
   - Tiempo máximo de procesamiento, parametrizable según el costo
     del generador (CSV ligero, PDF intensivo).

**Cifras concretas:** declaradas en ADR de implementación,
ajustables según observación de uso real.

**Lo que esta CNST PROHÍBE explícitamente:**

- Límites arbitrarios de registros por formato no justificados por
  medición empírica de recursos.
- Quotas diarias por formato (10 CSV / 5 Excel / 3 PDF en v2.0.0).
  Reemplazadas por quota diaria total agnóstica al formato.
- Acoplar la prescripción tecnológica (broker, runtime de tareas)
  a esta CNST normativa. Esa decisión vive en ADR técnico.

2.3 Capacidades requeridas (independientes de tecnología)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Mecanismo de rate limiting por usuario (concurrent + diario).
- Workers de exportación aislados del path UI/API.
- Tracking de tamaño del artefacto generado antes de entrega.
- Configurabilidad de cifras vía settings (no hardcodeadas).
- Observabilidad: métricas de uso por formato, tiempo medio,
  tasa de rechazo por límite.

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Reports
   - Aplica throttling en endpoint de exportación consolidado
 * - MOD_Logs
   - Aplica throttling en exportación de logs (CNST-024 + LOG-002)

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - uc-rpt-04
   - Exportar Reporte (UC consolidado por formato — Larman)
 * - uc-log-04
   - Exportar Logs

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Exceder concurrent jobs configurado para el usuario.
- Exceder quota diaria total del usuario.
- Generar artefactos que excedan tamaño máximo declarado.
- Compartir worker pool de exports con tráfico UI/API.
- Hardcodear cifras de throttling en el código (deben venir
  de settings).

4. Business Rules Derivadas
---------------------------

.. list-table::
 :widths: 20 40 40
 :header-rows: 1

 * - BR
   - Nombre
   - Relacion
 * - BR_011 (v2.0+)
   - Límites de Exportación
   - Apunta a CNST-019/020 sin replicar cifras concretas

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

 # Configuración via settings (NO hardcodeada)
 EXPORT_LIMITS = settings.EXPORT_LIMITS

 # Validación abstracta (no asume formato)
 if active_jobs(user) >= EXPORT_LIMITS['max_concurrent']:
 raise ThrottleException("Demasiados exports activos")

 if daily_jobs(user) >= EXPORT_LIMITS['max_daily']:
 raise ThrottleException("Quota diaria excedida")

 # Async sobre umbral CNST-019
 if estimated_records > settings.ASYNC_EXPORT_THRESHOLD:
 job = enqueue_export(query_params, format, user)
 return Response({"job_id": job.id}, status=202)

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).

6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Roles administrativos pueden tener cifras configurables
  superiores en settings.
- Permiso excepcional temporal (CNST-031) puede elevar el quota
  diario por una ventana acotada.

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Cifras por rol/escenario se configuran en settings; cambios
estructurales requieren ADR.

El protocolo formal de waiver de CNSTs esta pendiente de elaborar en
el WP de gobernanza (`PROC_Excepciones_CNST` — ver
(referencia interna) § W-4).

7. Verificacion
---------------

7.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El cumplimiento se verifica via los snippets de la seccion 5.

7.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo:** Automatico
- **Frecuencia:** Continuo
- **Herramienta:** Tests que verifican respuesta 429 al exceder
  concurrent o daily, y métricas de uso publicadas.

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-019-exportaciones-asincronas-sobre-10k-registros`, :doc:`cnst-011-throttling-obligatorio-en-endpoints-publicos`
 * - **BR derivadas**
   - BR_011 (v2.0.0+ — alineado a CNST-019/020 v3.0.0)
 * - **UCs afectados**
   - uc-rpt-04 (consolidado), uc-log-04
 * - **MODs afectados**
   - MOD_Reports, MOD_Logs
 * - **ADRs relacionados**
   - ADR de implementación de cola asíncrona y throttling
     (pendiente — declara cifras concretas y stack tecnológico)

9. Historial de Cambios
-----------------------

.. list-table::
 :widths: 12 15 25 48
 :header-rows: 1

 * - Version
   - Fecha
   - Autor
   - Cambios
 * - 1.0.0
   - 2025-12-17
   - NestorMonroy
   - Version inicial con tabla por formato (CSV 100K, Excel 50K, PDF 10K)
 * - 2.0.0
   - 2026-04-28
   - NestorMonroy
   - Descomposicion SRP (un concern por archivo) + enriquecimiento estructura TPL_CNST
 * - 3.0.0
   - 2026-04-30
   - NestorMonroy
   - **Reescritura abstracta:** eliminar tabla arbitraria por formato (CSV/Excel/PDF), eliminar quota por formato, agregar capacidades requeridas independientes de tecnología, mover cifras concretas y stack a ADR de implementación. Decision D-08 + D-09 (WP rbac-modelo-conceptual-cleanup).
