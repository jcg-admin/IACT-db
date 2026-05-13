.. meta::
 :artefacto: CNST_013
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-013:

=================================================
CNST-013: Manejo Estandarizado de Excepciones DRF
=================================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_013
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


Las excepciones DRF DEBEN manejarse mediante un ``EXCEPTION_HANDLER``
custom que retorne respuestas estructuradas. Las excepciones NO
PUEDEN exponer trazas, paths internos o nombres de clases del backend.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


La filtracion de detalles internos en respuestas de error es vector
clasico de reconnaissance para atacantes.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Mitigacion de filtracion de informacion sensible
- **Documento:** Convencion de codigo IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- ``REST_FRAMEWORK['EXCEPTION_HANDLER']`` apunta a handler custom en
  ``api/common/exceptions.py``.
- Estructura de respuesta: ``{"error": {"code": str, "message": str,
  "details": dict}}``.
- En produccion: ``DEBUG = False``, sin tracebacks en respuesta.
- Excepciones inesperadas se logean pero no se exponen.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- DRF EXCEPTION_HANDLER custom
- api/common/exceptions.py

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Common
   - Implementa el handler centralizado

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - Todos los UCs
   - Manejo uniforme de errores

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Exponer tracebacks en respuestas
- Filtrar paths internos o nombres de clases
- Pasar mensajes de Django/DRF directamente al cliente

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

 resp = client.post("/api/broken/", data={})
 assert "Traceback" not in resp.content.decode
 assert "django." not in resp.content.decode

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

Modificar el handler requiere ADR + revision de seguridad.

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
- **Frecuencia:** Continuo (tests de error)
- **Herramienta:** Tests que verifican que respuestas de error no contengan 'Traceback' ni 'django.'

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-024-logs-estructurados-en-formato-json`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - Todos los UCs
 * - **MODs afectados**
   - MOD_Common
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

