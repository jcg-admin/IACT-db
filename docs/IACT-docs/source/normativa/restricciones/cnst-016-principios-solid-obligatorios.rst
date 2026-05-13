.. meta::
 :artefacto: CNST_016
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-016:

=======================================
CNST-016: Principios SOLID Obligatorios
=======================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_016
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


El diseno de clases y modulos del sistema IACT DEBE cumplir los cinco
principios SOLID. Las violaciones documentadas requieren ADR con
justificacion.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


SOLID es la base reconocida para un diseno orientado a objetos mantenible y extensible. Su aplicacion sistematica reduce el acoplamiento, facilita el testing y permite que el codebase crezca sin acumular deuda tecnica.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Buenas practicas de diseno OO
- **Documento:** Convencion de codigo IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- **S - Single Responsibility:** una clase, una razon para cambiar.
- **O - Open/Closed:** abierto a extension, cerrado a modificacion.
- **L - Liskov Substitution:** subclase debe sustituir a su base sin
  romper contrato.
- **I - Interface Segregation:** preferir interfaces especificas a
  una grande.
- **D - Dependency Inversion:** depender de abstracciones, no
  implementaciones.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- radon (complejidad)
- Code review checklist

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

- Acoplar clases con multiples responsabilidades
- Modificar clases existentes para nuevas features (en lugar de extender)
- Romper contratos de subclase

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


- Code review explicito con checklist SOLID.
- Metricas: complejidad ciclomatica <10, longitud de metodo <50 ln.


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Violaciones documentadas con ADR explicito

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Cada violacion tiene ADR documentado.

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

- **Tipo:** Manual
- **Frecuencia:** Code review
- **Herramienta:** Code review checklist + radon (complejidad ciclomatica < 10)

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-015-antipatrones-de-arquitectura-prohibidos`
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

