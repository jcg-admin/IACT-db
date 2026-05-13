.. meta::
 :artefacto: CNST_027
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-027:

=========================================================
CNST-027: Clasificacion Obligatoria de Datos en 4 Niveles
=========================================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_027
 * - **Categoria**
   - Datos
 * - **Tipo (TXM_01)**
   - Regulatoria
 * - **Criticidad**
   - Critico
 * - **Negociable**
   - No
 * - **Estado**
   - Vigente

1. Definicion
-------------

1.1 Enunciado
^^^^^^^^^^^^^


Todo dato persistido en BD Analytics DEBE clasificarse en uno de
cuatro niveles: ``Public``, ``Internal``, ``Confidential``,
``Restricted``. Modelos sin clasificacion no se aceptan en code
review.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Sin clasificacion explicita, las decisiones de proteccion (cifrado, exportacion, RBAC) quedan a criterio caso a caso y son inconsistentes. La clasificacion explicita en el modelo permite enforce-ar las politicas en el codigo y en code review.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Compliance + gobernanza de datos
- **Documento:** Politica de clasificacion de datos IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- Cada modelo declara ``Meta.classification`` con uno de los 4
  valores.
- Datos ``Confidential`` y ``Restricted`` requieren cifrado en reposo
  (CNST_028).

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Meta.classification en modelos
- Linter que verifica clasificacion en migrations

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - (todos los modulos con modelos)
   - Declaran Meta.classification

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - (transversal)
   - Todos los UCs que manejan datos clasificados

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Persistir un modelo sin Meta.classification declarada
- Procesar datos Confidential/Restricted sin RBAC + cifrado

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

 for model in apps.get_models:
 if hasattr(model.Meta, "classification"):
 assert model.Meta.classification in ["Public", "Internal", "Confidential", "Restricted"]

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

Sin excepciones — todo modelo persistido tiene clasificacion.

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
- **Frecuencia:** Por deployment
- **Herramienta:** Test que itera apps.get_models y valida Meta.classification

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-028-cifrado-obligatorio-de-datos-confidenciales`, :doc:`cnst-026-pii-prohibida-en-logs-y-auditoria`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - (transversal)
 * - **MODs afectados**
   - (todos los modulos con modelos)
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

