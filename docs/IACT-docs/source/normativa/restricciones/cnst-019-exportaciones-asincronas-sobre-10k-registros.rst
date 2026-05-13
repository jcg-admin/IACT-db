.. meta::
 :artefacto: CNST_019
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 3.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-019:

======================================================
CNST-019: Exportaciones Asincronas Sobre 10k Registros
======================================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_019
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


Toda exportacion que supere 10 000 registros DEBE procesarse de forma
asincrona. La respuesta sincrona DEBE retornar ``202 Accepted`` con
``job_id`` y la entrega final ocurre por el buzon interno.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Procesamiento sincrono de >10k registros excede el SLA del endpoint y
bloquea workers. La asincronia preserva la disponibilidad para otros
usuarios.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Performance + disponibilidad
- **Documento:** RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.rst:755-757
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- Umbral: 10 000 registros.
- Mecanismo: cola asíncrona dedicada con worker pool aislado del
  pool que sirve UI/API. La tecnología concreta (broker, runtime
  de tareas) se declara en ADR de implementación — esta CNST no
  prescribe stack específico.
- Respuesta sincrona inicial: ``202 Accepted`` + ``{"job_id": ...}``.
- Trazabilidad del job: el ``job_id`` debe ser consultable hasta
  finalización del job.
- Notificacion al completar: mensaje en buzon interno (CNST_002),
  independiente del canal originador del request.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Capacidades requeridas (independientes de tecnología)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Cola dedicada para exports (no compartida con UI/API).
- Worker pool aislado para evitar bloqueo recíproco.
- Buzón interno de notificación (CNST_002).
- Mecanismo de identificación de job (``job_id`` único, consultable).

Alternativas viables documentadas en ADR de implementación
(cualquiera que cumpla las capacidades anteriores):
broker + worker (Celery, RQ, Dramatiq), background tasks nativos
del framework (django-background-tasks), runtime asyncio + worker
pool, cola gestionada por la BD (PostgreSQL LISTEN/NOTIFY), o
servicios cloud-native (SQS + Lambda).

**Prohibición:** acoplar esta CNST a una tecnología específica
viola la separación entre "qué proteger" (CNST normativa) y
"cómo implementarlo" (ADR técnico).

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
   - Decide async vs sync
 * - MOD_Notifications
   - Notifica al completar

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_022
   - Export CSV
 * - UC_023
   - Export Excel
 * - UC_024
   - Export PDF

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Procesar exportaciones > 10k registros sincronamente
- Bloquear el worker en path de request por export grande

4. Business Rules Derivadas
---------------------------

Sin BRs especificas mapeadas a esta CNST en la base cognitiva actual.
El catalogo BR_NNN del dominio IACT esta pendiente de elaborar en
el WP de requisitos (deuda diferida).

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^


.. code-block:: python

 if total > 10_000:
 job = export_async.delay(query_params)
 return Response({"job_id": job.id}, status=202)

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

Sin excepciones permitidas.

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Sin excepciones — umbral fijo.

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
- **Herramienta:** Test que verifica respuesta 202 para count > 10000

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-002-buzon-interno-obligatorio`, :doc:`cnst-020-throttling-de-exportaciones-por-formato`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_022, UC_023, UC_024
 * - **MODs afectados**
   - MOD_Reports, MOD_Notifications
 * - **ADRs relacionados**
   - Pendiente WP arquitectura tecnica

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
   - Version inicial (consolidada del backup canonico)
 * - 2.0.0
   - 2026-04-28
   - NestorMonroy
   - Descomposicion SRP (un concern por archivo) + enriquecimiento estructura completa TPL_CNST (9 secciones)
 * - 3.0.0
   - 2026-04-30
   - NestorMonroy
   - Desacoplar tecnología (Celery → "cola asíncrona dedicada"); agregar capacidades requeridas y alternativas viables; mover prescripción de stack a ADR de implementación

