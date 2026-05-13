.. meta::
   :artefacto: TPL_ADR
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-adr:

====================================================
TPL_ADR: Plantilla de Decision Arquitectonica v1.0.0
====================================================


Proposito
---------

Esta plantilla define la estructura estandar para documentar **Architecture Decision Records (ADR)**
en el proyecto IACT. Los ADR capturan decisiones arquitectonicas significativas junto con
su contexto y consecuencias.

**Caracteristicas:**

- Documenta decisiones arquitectonicas importantes
- Captura contexto y alternativas consideradas
- Registra consecuencias positivas y negativas
- Mantiene historial de decisiones del proyecto
- Basado en formato Michael Nygard (original ADR)

**Cuando crear un ADR:**

- Eleccion de tecnologia o framework
- Patron arquitectonico adoptado
- Decision que afecta multiples componentes
- Trade-off significativo entre opciones
- Decision que sera dificil de revertir

----

Requisitos Tecnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Formato ReStructuredText (.rst)

**Ubicacion:**

::

   arquitectura_tecnica/decisiones/ADR_[NNN]_[Nombre_Descriptivo].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de seccion "Plantilla" a nuevo archivo
2. Nombrar archivo segun nomenclatura: ``ADR_[NNN]_[Nombre].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Documentar contexto completo de la decision
5. Listar todas las alternativas consideradas
6. Explicar claramente la decision tomada
7. Documentar consecuencias positivas y negativas
8. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   ADR_[NNN]

   Donde:
   - ADR: Prefijo fijo (Architecture Decision Record)
   - [NNN]: Numero secuencial de 3 digitos (001-999)

**Ejemplos:**

::

   ADR_001  -> Stack Django + DRF
   ADR_002  -> BD Dual MySQL + PostgreSQL
   ADR_003  -> RBAC Flat vs Hierarchical
   ADR_004  -> 8 Modulos + SEC_RULES Integrado
   ADR_005  -> UML con PlantUML

**Nombre de Archivo:**

::

   ADR_[NNN]_[Nombre_Descriptivo].rst

   Ejemplos:
   - ADR_001_Stack_Django_DRF.rst
   - ADR_002_BD_Dual_MySQL_PG.rst
   - ADR_003_RBAC_Flat_vs_Hierarchical.rst

----

Estados de ADR
--------------

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - Estado
     - Descripcion
   * - **Propuesto**
     - Decision en evaluacion, pendiente de aprobacion
   * - **Aceptado**
     - Decision aprobada e implementada
   * - **Deprecado**
     - Decision ya no aplica pero se mantiene por historial
   * - **Supersedido**
     - Reemplazado por otro ADR (indicar cual)
   * - **Rechazado**
     - Propuesta evaluada y rechazada

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: ADR_[NNN]
      :tipo: Decision Arquitectonica
      :dominio: arquitectura_tecnica
      :subdominio: decisiones
      :estado_adr: [Propuesto|Aceptado|Deprecado|Supersedido|Rechazado]
      :fecha_decision: [YYYY-MM-DD]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT
      :clasificacion: Interno

   .. _adr-[nnn]:

                                     
   ADR_[NNN]: [Titulo de la Decision]
                                     

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
        - [Propuesto|Aceptado|Deprecado|Supersedido|Rechazado]
      * - **Fecha Decision**
        - [YYYY-MM-DD]
      * - **Decisores**
        - [Nombres o roles de quienes tomaron la decision]
      * - **Categoria**
        - [Tecnologia|Arquitectura|Seguridad|Datos|Infraestructura]

   ----

   1. Contexto
   -----------

   [Descripcion detallada del contexto que motiva esta decision.
   Incluir:
   - Situacion actual o problema a resolver
   - Fuerzas en juego (requisitos, restricciones, preocupaciones)
   - Stakeholders afectados
   - Urgencia o importancia de la decision]

   ----

   2. Problema
   -----------

   [Enunciado claro y conciso del problema o pregunta que esta decision resuelve.
   Formato sugerido: "Necesitamos decidir [X] porque [Y]"]

   ----

   3. Alternativas Consideradas
   ----------------------------

   3.1 Alternativa A: [Nombre]
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:**
   [Descripcion de la alternativa]

   **Ventajas:**
   - [Ventaja 1]
   - [Ventaja 2]

   **Desventajas:**
   - [Desventaja 1]
   - [Desventaja 2]

   **Estimacion de esfuerzo:** [Alto|Medio|Bajo]

   3.2 Alternativa B: [Nombre]
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:**
   [Descripcion de la alternativa]

   **Ventajas:**
   - [Ventaja 1]
   - [Ventaja 2]

   **Desventajas:**
   - [Desventaja 1]
   - [Desventaja 2]

   **Estimacion de esfuerzo:** [Alto|Medio|Bajo]

   3.3 Alternativa C: [Nombre] (si aplica)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:**
   [Descripcion de la alternativa]

   **Ventajas:**
   - [Ventaja 1]

   **Desventajas:**
   - [Desventaja 1]

   **Estimacion de esfuerzo:** [Alto|Medio|Bajo]

   ----

   4. Decision
   -----------

   4.1 Alternativa Seleccionada
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. note:: **Decision**

      Se selecciona la **Alternativa [X]: [Nombre]**.

   4.2 Justificacion
   ^^^^^^^^^^^^^^^^^

   [Explicacion detallada de por que se eligio esta alternativa.
   Incluir:
   - Criterios de evaluacion utilizados
   - Peso de cada criterio
   - Por que las otras alternativas fueron descartadas]

   ----

   5. Consecuencias
   ----------------

   5.1 Consecuencias Positivas
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Consecuencia positiva 1]
   - [Consecuencia positiva 2]
   - [Consecuencia positiva 3]

   5.2 Consecuencias Negativas
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Consecuencia negativa 1 y como se mitigara]
   - [Consecuencia negativa 2 y como se mitigara]

   5.3 Riesgos Identificados
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 40 20 40
      :header-rows: 1

      * - Riesgo
        - Probabilidad
        - Mitigacion
      * - [Descripcion del riesgo]
        - [Alta|Media|Baja]
        - [Estrategia de mitigacion]

   ----

   6. Implementacion
   -----------------

   6.1 Acciones Requeridas
   ^^^^^^^^^^^^^^^^^^^^^^^

   1. [Accion 1 para implementar la decision]
   2. [Accion 2 para implementar la decision]
   3. [Accion 3 para implementar la decision]

   6.2 Componentes Afectados
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   - MOD_[xxx]: [Como afecta]
   - MOD_[yyy]: [Como afecta]

   6.3 Timeline Estimado
   ^^^^^^^^^^^^^^^^^^^^^

   - **Inicio**: [Fecha o sprint]
   - **Fin estimado**: [Fecha o sprint]

   ----

   7. Validacion
   -------------

   7.1 Criterios de Exito
   ^^^^^^^^^^^^^^^^^^^^^^

   La decision se considera exitosa si:

   - [ ] [Criterio 1]
   - [ ] [Criterio 2]
   - [ ] [Criterio 3]

   7.2 Metricas de Seguimiento
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Metrica 1]: [Como se medira]
   - [Metrica 2]: [Como se medira]

   ----

   8. Relaciones
   -------------

   8.1 ADR Relacionados
   ^^^^^^^^^^^^^^^^^^^^

   - ADR_[NNN]: [Relacion - complementa/depende/supersede]

   8.2 Artefactos Afectados
   ^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **CNST Generadas**
        - CNST_[NNN], CNST_[NNN]
      * - **BR Afectadas**
        - BR_[NNN], BR_[NNN]
      * - **MOD Afectados**
        - MOD_[xxx], MOD_[yyy]
      * - **NFR Relacionados**
        - NFR_[NNN]

   ----

   9. Referencias
   --------------

   - [Documento 1]: [URL o referencia]
   - [Documento 2]: [URL o referencia]
   - [Documentacion oficial]: [URL]

   ----

   10. Historial de Cambios
   ------------------------

   .. list-table::
      :widths: 12 12 20 56
      :header-rows: 1

      * - Version
        - Fecha
        - Autor
        - Cambios
      * - 1.0.0
        - [YYYY-MM-DD]
        - Equipo IACT
        - Decision inicial documentada

   ----

   *Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*

----

Secciones Obligatorias
----------------------

Cada ADR DEBE incluir minimo estas 10 secciones:

.. list-table::
   :widths: 5 25 70
   :header-rows: 1

   * - #
     - Seccion
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - ID, titulo, estado, fecha, decisores
   * - 1
     - Contexto
     - Situacion, fuerzas, stakeholders
   * - 2
     - Problema
     - Enunciado claro del problema
   * - 3
     - Alternativas
     - Opciones evaluadas con pros/contras
   * - 4
     - Decision
     - Alternativa seleccionada y justificacion
   * - 5
     - Consecuencias
     - Positivas, negativas, riesgos
   * - 6
     - Implementacion
     - Acciones, componentes, timeline
   * - 7
     - Validacion
     - Criterios de exito, metricas
   * - 8
     - Relaciones
     - ADR, CNST, BR, MOD relacionados
   * - 9
     - Referencias
     - Documentacion externa
   * - 10
     - Historial
     - Control de versiones

----

Validacion
----------

Antes de aprobar un ADR, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura ADR_[NNN]
- [ ] Estado del ADR especificado
- [ ] Contexto completo y claro
- [ ] Problema bien definido
- [ ] Al menos 2 alternativas documentadas
- [ ] Cada alternativa tiene pros y contras
- [ ] Decision justificada
- [ ] Consecuencias positivas y negativas listadas
- [ ] Riesgos identificados con mitigacion
- [ ] Componentes afectados documentados

**Comando de validacion:**

.. code-block:: bash

   # Validar sintaxis RST
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- Michael Nygard: "Documenting Architecture Decisions"
- CNST_*: Restricciones derivadas de ADR
- MOD_*: Modulos afectados
- STD_006: Versionado Semantico

----

Historial de Cambios
--------------------

.. list-table::
   :widths: 12 12 20 56
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Version inicial de plantilla ADR
