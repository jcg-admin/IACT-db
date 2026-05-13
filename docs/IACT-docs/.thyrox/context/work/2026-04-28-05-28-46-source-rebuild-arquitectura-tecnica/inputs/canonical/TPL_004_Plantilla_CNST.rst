.. meta::
   :artefacto: TPL_004
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _tpl-004:

==============================================================================
TPL_004: Plantilla de Restriccion Tecnica (CNST)
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Proposito
---------

Esta plantilla define la estructura estandar para documentar Restricciones
Tecnicas (Constraints) en el proyecto IACT. Las restricciones son imposiciones
externas del cliente o ambiente que el sistema DEBE respetar.

----

Instrucciones de Uso
--------------------

1. Copiar este archivo como ``CNST_NNN_Nombre_Restriccion.rst``
2. Reemplazar todos los marcadores ``[PLACEHOLDER]`` con valores reales
3. Las restricciones NO son negociables - documentar como hechos
4. Derivar BR_ cuando la restriccion implique reglas de negocio

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: CNST_[NNN]
      :tipo: Restriccion Tecnica
      :dominio: arquitectura_tecnica
      :subdominio: restricciones
      :estado: [Vigente|Revision|Obsoleta]
      :version: [X.Y.Z]
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: [Nombre]
      :clasificacion: Interno

   .. _cnst-[nnn]:

   ==============================================================================
   CNST_[NNN]: [Nombre de la Restriccion]
   ==============================================================================

   .. contents:: Contenido
      :local:
      :depth: 2

   ----

   Resumen Ejecutivo
   -----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **ID**
        - CNST_[NNN]
      * - **Nombre**
        - [Nombre descriptivo de la restriccion]
      * - **Categoria**
        - [Infraestructura | Datos | Seguridad | Integracion | Performance]
      * - **Origen**
        - [Cliente | Regulacion | Tecnologia Legacy | Politica Corporativa]
      * - **Criticidad**
        - [Critica | Alta | Media]
      * - **Negociable**
        - No (las restricciones son imposiciones, no opciones)

   ----

   1. Definicion de la Restriccion
   --------------------------------

   1.1 Enunciado Formal
   ^^^^^^^^^^^^^^^^^^^^

   .. warning:: **Restriccion CNST_[NNN]**

      [Enunciado claro de la restriccion. Usar lenguaje imperativo.
      Ejemplo: "El sistema NO DEBE escribir directamente en la base de datos IVR."]

   1.2 Justificacion
   ^^^^^^^^^^^^^^^^^

   [Explicar POR QUE existe esta restriccion. Cual es el contexto?
   Que problema se previene al respetarla?]

   1.3 Origen de la Restriccion
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **Fuente**
        - [Quien impone la restriccion]
      * - **Documento**
        - [Documento donde se origina, si aplica]
      * - **Fecha**
        - [Desde cuando aplica]
      * - **Contacto**
        - [Persona de referencia para consultas]

   ----

   2. Alcance
   ----------

   2.1 Componentes Afectados
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 30 70
      :header-rows: 1

      * - Componente
        - Como Afecta
      * - [Backend Django]
        - [Descripcion de impacto]
      * - [Frontend React]
        - [Descripcion de impacto]
      * - [Base de Datos]
        - [Descripcion de impacto]

   2.2 Operaciones Afectadas
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Operacion 1 que debe respetar la restriccion]
   - [Operacion 2 que debe respetar la restriccion]

   2.3 Exclusiones
   ^^^^^^^^^^^^^^^

   [Casos donde la restriccion NO aplica, si existen]

   ----

   3. Especificacion Tecnica
   -------------------------

   3.1 Descripcion Detallada
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   [Descripcion tecnica completa de la restriccion.
   Incluir todos los detalles necesarios para implementacion.]

   3.2 Parametros y Valores
   ^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 30 30 40
      :header-rows: 1

      * - Parametro
        - Valor
        - Notas
      * - [Parametro 1]
        - [Valor]
        - [Explicacion]
      * - [Parametro 2]
        - [Valor]
        - [Explicacion]

   3.3 Ejemplos
   ^^^^^^^^^^^^

   **Correcto (cumple restriccion):**

   .. code-block:: python

      # Ejemplo de codigo que CUMPLE la restriccion
      [codigo ejemplo]

   **Incorrecto (viola restriccion):**

   .. code-block:: python

      # Ejemplo de codigo que VIOLA la restriccion - NO HACER
      [codigo ejemplo]

   ----

   4. Cumplimiento
   ---------------

   4.1 Como Cumplir
   ^^^^^^^^^^^^^^^^

   Pasos para asegurar cumplimiento:

   1. [Paso 1]
   2. [Paso 2]
   3. [Paso N]

   4.2 Verificacion
   ^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 30 70
      :header-rows: 1

      * - Metodo
        - Descripcion
      * - [Manual | Automatizado]
        - [Como se verifica cumplimiento]
      * - [Test | Review | Audit]
        - [Frecuencia y responsable]

   4.3 Consecuencias de Incumplimiento
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   [Que sucede si se viola esta restriccion:
   - Falla de sistema
   - Perdida de datos
   - Violacion de seguridad
   - Problema legal/contractual]

   ----

   5. Antipatrones
   ---------------

   Patrones de codigo o diseno que VIOLAN esta restriccion:

   5.1 Antipatron 1: [Nombre]
   ^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion**: [Que es este antipatron]

   **Por que es problema**: [Por que viola la restriccion]

   **Solucion**: [Como evitarlo]

   ----

   6. Reglas de Negocio Derivadas
   ------------------------------

   Reglas de negocio que se derivan de esta restriccion:

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - BR
        - Descripcion
      * - BR_[NNN]
        - [Regla de negocio derivada de esta CNST]

   ----

   7. Trazabilidad
   ---------------

   7.1 ADR Relacionadas
   ^^^^^^^^^^^^^^^^^^^^

   - ADR_[NNN]: [Decision arquitectonica que respeta esta restriccion]

   7.2 Otros CNST Relacionados
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - CNST_[NNN]: [Relacion con otra restriccion]

   ----

   8. Historial de Cambios
   -----------------------

   .. list-table::
      :widths: 15 15 20 50
      :header-rows: 1

      * - Version
        - Fecha
        - Autor
        - Descripcion del Cambio
      * - 1.0.0
        - [YYYY-MM-DD]
        - [Nombre]
        - Version inicial

----

Ejemplo de Uso
--------------

Ver ``CNST_003_Base_Datos_Dual_Inmutable.rst`` para un ejemplo completo 
de aplicacion de esta plantilla.

----

Referencias
-----------

- CNST_001 a CNST_010 existentes como ejemplos
- ESTRUCTURA v2.0.0: Modelo Documental IACT
- FND_05: Jerarquia de Requisitos (relacion CNST con BR)

----

*Plantilla version 1.0.0 - Proyecto IACT Dashboard Analytics*
