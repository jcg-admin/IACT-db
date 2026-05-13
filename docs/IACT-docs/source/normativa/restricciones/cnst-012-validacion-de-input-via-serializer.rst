.. meta::
 :artefacto: CNST_012
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-012:

============================================
CNST-012: Validacion de Input via Serializer
============================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_012
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


Todo input al sistema DEBE validarse mediante ``Serializer`` o
``ModelSerializer`` de DRF. Esta prohibido leer ``request.data``
directamente y procesarlo sin pasar por un serializer.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Centraliza la validacion, previene inyeccion y garantiza consistencia
de tipos. Saltarse el serializer es vector tipico de bugs de
seguridad.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Convencion de codigo + mitigacion de inyeccion
- **Documento:** Convencion de codigo IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- Cada vista que recibe payload define un serializer dedicado.
- Validaciones cruzadas usan ``validate`` a nivel serializer.
- ``raise_exception=True`` obligatorio en ``is_valid``.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- DRF Serializer / ModelSerializer
- validate / validate_<field>

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - Todos los modulos con vistas DRF
   - Implementan serializers

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - Todos los UCs con input
   - Requieren serializer dedicado

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Leer request.data directamente sin validar
- Pasar input crudo a queries
- Saltarse is_valid

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

 serializer = MySerializer(data=request.data)
 serializer.is_valid(raise_exception=True)

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

Sin excepciones — convencion absoluta.

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

- **Tipo:** Manual + Automatico
- **Frecuencia:** Code review + linter
- **Herramienta:** ruff + code review checklist

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-013-manejo-estandarizado-de-excepciones-drf`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - Todos los UCs con input
 * - **MODs afectados**
   - Todos los modulos con vistas DRF
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

