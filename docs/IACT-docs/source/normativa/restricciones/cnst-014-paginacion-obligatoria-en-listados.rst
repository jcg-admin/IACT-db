.. meta::
 :artefacto: CNST_014
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-014:

============================================
CNST-014: Paginacion Obligatoria en Listados
============================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_014
 * - **Categoria**
   - Seguridad DRF
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


Todo endpoint DRF que retorne una lista DEBE paginar la respuesta.
Esta prohibido retornar ``QuerySet.all`` sin paginar para evitar
cargas no acotadas.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Garantiza tiempo de respuesta predecible, controla uso de memoria y
previene exfiltracion masiva por endpoints de lectura.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Performance + control de exposicion
- **Documento:** RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.rst:750-751
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^

(detalle en parametros)

2.2 Parametros
^^^^^^^^^^^^^^


- ``DEFAULT_PAGINATION_CLASS = "rest_framework.pagination.PageNumberPagination"``.
- ``PAGE_SIZE = 50``.
- Maximo override por request: ``page_size`` <= 200.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- DRF PageNumberPagination
- PAGE_SIZE = 50

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
   - Heredan paginacion default

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_017..025
   - Listados paginados
 * - Cualquier UC con lista
   - Pagina respuesta

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Retornar QuerySet.all sin paginar
- Permitir page_size > 200
- Devolver listas no acotadas

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

 resp = client.get("/api/clientes/")
 data = resp.json
 assert "results" in data and "count" in data
 assert len(data["results"]) <= 50

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Endpoints de combos / dropdowns con lista pequena (<= 50) y cacheada

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Endpoints exentos requieren cache y limite duro de tamano.

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
- **Herramienta:** Tests que verifican estructura {results, count} y len(results) <= PAGE_SIZE

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-017-sla-de-tiempos-de-respuesta`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_017..025, Cualquier UC con lista
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

