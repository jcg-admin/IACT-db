.. meta::
 :artefacto: CNST_017
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-017:

=====================================
CNST-017: SLA de Tiempos de Respuesta
=====================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_017
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


Los endpoints del sistema IACT DEBEN cumplir SLAs de tiempo de
respuesta segun su tipo. Endpoints que no cumplen el SLA requieren
optimizacion o reclasificacion (mover a procesamiento asincrono).

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Tiempos de respuesta predecibles son requisito para la usabilidad y la confianza del usuario. Endpoints sin SLA definido tienden a degradarse silenciosamente con el crecimiento del dataset y se detectan solo cuando el incidente ya ocurrio.

1.3 Origen
^^^^^^^^^^

- **Fuente:** SLA del cliente
- **Documento:** RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.rst:715-742
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^

(detalle en parametros)

2.2 Parametros
^^^^^^^^^^^^^^


.. list-table::
 :header-rows: 1
 :widths: 50 25 25

 * - Tipo de endpoint
   - SLA p95
   - SLA p99
 * - Lectura simple (detalle)
   - 200 ms
   - 500 ms
 * - Lectura paginada
   - 500 ms
   - 1 s
 * - Escritura (CRUD)
   - 800 ms
   - 2 s
 * - Reporte sincrono
   - 5 s
   - 10 s
 * - Login
   - 1 s
   - 2 s

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- APM (Sentry o Prometheus)
- django-debug-toolbar (dev)

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - Todos los modulos DRF
   - Cumplen SLA por endpoint type

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_017
   - Reporte simple (<5s)
 * - UC_018
   - Reporte complejo (<10s)
 * - UC_019
   - Analisis exploratorio (<300s)
 * - UC_025
   - Dashboard (<3s carga inicial)

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Endpoints sincronos > 5s en p95
- Ignorar degradacion de p99 sostenida

4. Business Rules Derivadas
---------------------------

.. list-table::
 :widths: 20 40 40
 :header-rows: 1

 * - BR
   - Nombre
   - Relacion
 * - BR_011 (legacy)
   - Limites de Exportacion (relacionado pero no equivalente)
   - FND_00:298 — pendiente WP requisitos

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^

(detalle en seccion 5.2 Validacion de Cumplimiento)

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


- APM en produccion (Sentry o Prometheus) con alertas por endpoint
  que exceda el p95 sostenido.


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Reportes complejos (>10s) deben moverse a procesamiento async (CNST_019)

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Endpoint que excede SLA p95 sostenido requiere ticket de optimizacion o reclasificacion async.

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
- **Frecuencia:** Continuo (APM en produccion)
- **Herramienta:** Sentry / Prometheus con alertas por endpoint

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-018-rango-maximo-de-consulta-de-2-anos`, :doc:`cnst-019-exportaciones-asincronas-sobre-10k-registros`
 * - **BR derivadas**
   - BR_011 (legacy)
 * - **UCs afectados**
   - UC_017, UC_018, UC_019, UC_025
 * - **MODs afectados**
   - Todos los modulos DRF
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

