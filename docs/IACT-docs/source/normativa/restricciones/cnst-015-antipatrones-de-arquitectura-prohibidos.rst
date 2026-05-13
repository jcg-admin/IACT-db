.. meta::
 :artefacto: CNST_015
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-015:

=================================================
CNST-015: Antipatrones de Arquitectura Prohibidos
=================================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_015
 * - **Categoria**
   - Arquitectura
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


Los siguientes antipatrones estan PROHIBIDOS en el codebase del
sistema IACT. Su deteccion en code review obliga a refactor antes de
merge a ``main``.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Los antipatrones erosionan la mantenibilidad del codebase, concentran riesgo en clases que ningun integrante quiere tocar, y son causa frecuente de bugs de seguridad y performance. La deteccion temprana es mas barata que la refactorizacion tardia.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Buenas practicas + experiencia operativa
- **Documento:** Convencion de codigo IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


.. list-table::
 :header-rows: 1
 :widths: 30 70

 * - Antipatron
   - Razon
 * - Fat Models
   - Modelos con >300 lineas o >15 metodos. Mover logica a service layer.
 * - Fat Views
   - Vistas con logica de negocio. Vistas son orquestadores delgados.
 * - God Object
   - Cualquier clase >500 lineas que abarca multiples dominios.
 * - Hardcoded Configuration
   - Valores de produccion en codigo. Usar ``settings`` o env vars.
 * - SQL Injection via Raw SQL
   - ``cursor.execute(f"...{user_input}...")``. Usar parametros.
 * - Sleep en Vistas
   - ``time.sleep`` en path de request.
 * - N+1 Queries
   - Sin ``select_related``/``prefetch_related`` cuando aplica.
 * - Catch Pokemon
   - ``except Exception: pass`` sin logging ni accion.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- ruff
- Linter custom
- Code review

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - (todos)
   - Aplica al codebase completo

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - (transversal)
   - Aplica a todo el codigo IACT

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Modelos > 300 ln
- Vistas con logica de negocio
- God objects > 500 ln
- Hardcoded config
- Raw SQL con interpolacion
- time.sleep en path de request
- N+1 sin justificar
- except Exception: pass

4. Business Rules Derivadas
---------------------------

Sin BRs especificas mapeadas a esta CNST en la base cognitiva actual.
El catalogo BR_NNN del dominio IACT esta pendiente de elaborar en
el WP de requisitos (deuda diferida).

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^

(detalle en seccion 5.2 Validacion de Cumplimiento)

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


- Linter custom + ``ruff`` con reglas activadas.
- Code review obligatorio en PR a ``main``.


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Casos legacy en migracion con plan de refactor documentado

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Excepciones temporales requieren issue + plan de refactor.

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

- **Tipo:** Mixto
- **Frecuencia:** Continuo (linter) + Code review
- **Herramienta:** ruff + linter custom + code review checklist

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-016-principios-solid-obligatorios`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - (transversal)
 * - **MODs afectados**
   - (todos)
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

