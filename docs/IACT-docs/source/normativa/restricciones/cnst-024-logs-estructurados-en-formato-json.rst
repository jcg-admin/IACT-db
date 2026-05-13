.. meta::
 :artefacto: CNST_024
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-024:

============================================
CNST-024: Logs Estructurados en Formato JSON
============================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_024
 * - **Categoria**
   - Logging
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


Todo log emitido por el sistema IACT DEBE ser estructurado en formato
JSON con campos estandar. Esta prohibido el log de texto libre en
produccion.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


El log estructurado es procesable por herramientas de observabilidad
(ELK, Loki, Sentry) sin parsers ad hoc. El texto libre es opaco al
analisis automatizado.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Mejor practica de observabilidad
- **Documento:** Politica de logging IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- ``timestamp`` (ISO 8601, UTC).
- ``level`` (``DEBUG|INFO|WARNING|ERROR|CRITICAL``).
- ``logger`` (path del modulo).
- ``message`` (mensaje principal).
- ``request_id`` (UUID por request).
- ``user_id`` (si autenticado).
- ``module`` y ``function``.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- python-json-logger
- Django LOGGING config
- request_id middleware

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
   - Define LOGGING config y middleware
 * - (todos)
   - Usan structured logging

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - (transversal)
   - Todos los UCs generan logs estructurados

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Emitir logs en formato texto libre en produccion
- Usar print en lugar de logger
- Omitir request_id en operaciones autenticadas

4. Business Rules Derivadas
---------------------------

Sin BRs especificas mapeadas a esta CNST en la base cognitiva actual.
El catalogo BR_NNN del dominio IACT esta pendiente de elaborar en
el WP de requisitos (deuda diferida).

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^


.. code-block:: bash

 tail -1 /var/log/iact/app.log | jq -e '.timestamp and .level' && echo "OK"

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

Sin excepciones — politica absoluta en produccion.

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
- **Herramienta:** Test que verifica formato JSON + jq en smoke

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-025-auditoria-inmutable-append-only`, :doc:`cnst-026-pii-prohibida-en-logs-y-auditoria`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - (transversal)
 * - **MODs afectados**
   - MOD_Common, (todos)
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

