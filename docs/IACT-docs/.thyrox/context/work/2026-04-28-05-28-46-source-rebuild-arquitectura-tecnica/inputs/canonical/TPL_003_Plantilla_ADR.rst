.. meta::
   :artefacto: TPL_003
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _tpl-003:

==============================================================================
TPL_003: Plantilla de Decision de Arquitectura (ADR)
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Proposito
---------

Esta plantilla define la estructura estandar para documentar Decisiones
de Arquitectura (Architecture Decision Records) en el proyecto IACT.

----

Instrucciones de Uso
--------------------

1. Copiar este archivo como ``ADR_NNN_Nombre_Decision.rst``
2. Reemplazar todos los marcadores ``[PLACEHOLDER]`` con valores reales
3. Documentar ANTES de implementar la decision
4. Actualizar estado cuando la decision sea aceptada/rechazada

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: ADR_[NNN]
      :tipo: Decision de Arquitectura
      :dominio: arquitectura_tecnica
      :subdominio: arquitectura/decisiones
      :estado: [Propuesta|Aceptada|Rechazada|Obsoleta|Reemplazada]
      :version: [X.Y.Z]
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: [Nombre]
      :clasificacion: Interno

   .. _adr-[nnn]:

   ==============================================================================
   ADR_[NNN]: [Titulo de la Decision]
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
        - ADR_[NNN]
      * - **Titulo**
        - [Titulo descriptivo de la decision]
      * - **Estado**
        - [Propuesta | Aceptada | Rechazada | Obsoleta | Reemplazada]
      * - **Fecha Decision**
        - [YYYY-MM-DD]
      * - **Decisores**
        - [Lista de personas que tomaron la decision]
      * - **Impacto**
        - [Alto | Medio | Bajo]

   ----

   1. Contexto
   -----------

   1.1 Situacion Actual
   ^^^^^^^^^^^^^^^^^^^^

   [Describir el contexto tecnico y de negocio que motiva esta decision.
   Que problema estamos tratando de resolver? Cual es la situacion actual?]

   1.2 Fuerzas en Juego
   ^^^^^^^^^^^^^^^^^^^^

   Factores que influyen en la decision:

   - **[Fuerza 1]**: [Descripcion]
   - **[Fuerza 2]**: [Descripcion]
   - **[Fuerza 3]**: [Descripcion]

   1.3 Restricciones
   ^^^^^^^^^^^^^^^^^

   Limitaciones que condicionan la decision:

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - CNST
        - Restriccion
      * - CNST_[NNN]
        - [Como afecta esta restriccion a la decision]

   ----

   2. Decision
   -----------

   2.1 Enunciado de la Decision
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. note:: **Decision ADR_[NNN]**

      [Enunciado claro y conciso de la decision tomada.
      Formato: "Usaremos [X] para [Y] porque [Z]"]

   2.2 Justificacion
   ^^^^^^^^^^^^^^^^^

   [Explicar POR QUE se tomo esta decision. Que criterios se usaron?
   Por que es la mejor opcion dadas las restricciones?]

   ----

   3. Opciones Consideradas
   ------------------------

   3.1 Opcion A: [Nombre]
   ^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion**: [Que implica esta opcion]

   **Pros**:

   - [Ventaja 1]
   - [Ventaja 2]

   **Contras**:

   - [Desventaja 1]
   - [Desventaja 2]

   **Evaluacion**: [Puntuacion o valoracion]

   3.2 Opcion B: [Nombre]
   ^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion**: [Que implica esta opcion]

   **Pros**:

   - [Ventaja 1]
   - [Ventaja 2]

   **Contras**:

   - [Desventaja 1]
   - [Desventaja 2]

   **Evaluacion**: [Puntuacion o valoracion]

   3.3 Opcion C: [Nombre] (SELECCIONADA)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion**: [Que implica esta opcion]

   **Pros**:

   - [Ventaja 1]
   - [Ventaja 2]

   **Contras**:

   - [Desventaja 1]
   - [Desventaja 2]

   **Evaluacion**: [Puntuacion o valoracion]

   **Razon de Seleccion**: [Por que se eligio esta opcion sobre las otras]

   ----

   4. Consecuencias
   ----------------

   4.1 Positivas
   ^^^^^^^^^^^^^

   - [Consecuencia positiva 1]
   - [Consecuencia positiva 2]

   4.2 Negativas
   ^^^^^^^^^^^^^

   - [Consecuencia negativa 1 y como se mitigara]
   - [Consecuencia negativa 2 y como se mitigara]

   4.3 Riesgos
   ^^^^^^^^^^^

   .. list-table::
      :widths: 30 20 50
      :header-rows: 1

      * - Riesgo
        - Probabilidad
        - Mitigacion
      * - [Riesgo 1]
        - [Alta|Media|Baja]
        - [Como se mitiga]

   ----

   5. Implementacion
   -----------------

   5.1 Componentes Afectados
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Componente 1]
   - [Componente 2]

   5.2 Plan de Accion
   ^^^^^^^^^^^^^^^^^^

   1. [Paso 1]
   2. [Paso 2]
   3. [Paso N]

   5.3 Verificacion
   ^^^^^^^^^^^^^^^^

   [Como se verificara que la decision fue implementada correctamente]

   ----

   6. Trazabilidad
   ---------------

   6.1 Restricciones Relacionadas
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - CNST_[NNN]: [Relacion]

   6.2 Otras ADR Relacionadas
   ^^^^^^^^^^^^^^^^^^^^^^^^^^

   - ADR_[NNN]: [Relacion - depende de | reemplaza | complementa]

   6.3 Artefactos Afectados
   ^^^^^^^^^^^^^^^^^^^^^^^^

   - [Lista de documentos/codigo afectados por esta decision]

   ----

   7. Historial de Cambios
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
        - Version inicial - Propuesta
      * - 1.1.0
        - [YYYY-MM-DD]
        - [Nombre]
        - Decision aceptada

----

Ejemplo de Uso
--------------

Ver ``ADR_001_Stack_Django_React.rst`` para un ejemplo completo de aplicacion
de esta plantilla.

----

Referencias
-----------

- Michael Nygard, "Documenting Architecture Decisions"
- ESTRUCTURA v2.0.0: Modelo Documental IACT
- Restricciones CNST_ del proyecto

----

*Plantilla version 1.0.0 - Proyecto IACT Dashboard Analytics*
