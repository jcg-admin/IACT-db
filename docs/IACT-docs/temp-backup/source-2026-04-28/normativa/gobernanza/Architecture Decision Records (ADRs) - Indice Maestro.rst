Architecture Decision Records (ADRs)
====================================

Proposito
---------

Este directorio contiene todas las decisiones arquitectonicas
(Architecture Decision Records - ADRs) del proyecto IACT.

**Total ADRs en este directorio:** 13

**Ultima actualizacion:** 2025-11-16

--------------

Sistema de Numeracion
---------------------

**Formato Estandar:** ``ADR-{NNN}-{descripcion_con_underscores}.md``

-  **NNN:** Numero secuencial (001-999)
-  **descripcion:** Descripcion corta en snake_case (underscores)
-  Prefijo ADR siempre en UPPERCASE
-  Ejemplo: ``ADR-040-schema_validator_agent.md``

--------------

Indice de ADRs
--------------

ADR-008: CPython Features vs Imagen Base
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:** ``ADR_008_cpython_features_vs_imagen_base.md`` **Estado:**
Aceptada **Dominio:** Infraestructura **Propietario:** @equipo-devops

**Resumen:** Decision sobre features de CPython vs uso de imagen base
Docker.

--------------

ADR-009: Distribucion Artefactos Strategy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:** ``ADR_009_distribucion_artefactos_strategy.md`` **Estado:**
Aceptada **Dominio:** Infraestructura **Propietario:** @equipo-devops

**Resumen:** Estrategia de distribucion de artefactos.

--------------

ADR-010: Organizacion Proyecto por Dominio
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:** ``ADR_010_organizacion_proyecto_por_dominio.md``
**Estado:** Aceptada **Dominio:** General **Propietario:**
@arquitecto-senior

**Resumen:** Organizacion de documentacion y codigo por dominios.

--------------

ADR-011: Frontend Modular Monolith
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:** ``ADR_011_frontend_modular_monolith.md`` **Estado:**
Aceptada **Dominio:** Frontend **Propietario:** @equipo-frontend

**Resumen:** Arquitectura de monolito modular para frontend.

--------------

ADR-012: Sistema Permisos Sin Roles Jerarquicos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:** ``ADR-012-sistema_permisos_sin_roles_jerarquicos.md``
**Estado:** Aceptada **Dominio:** Backend **Propietario:**
@equipo-backend

**Resumen:** Sistema de permisos granular sin roles jerarquicos.

--------------

ADR-012 (Redux): Redux Toolkit State Management
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:** ``ADR_012_redux_toolkit_state_management.md`` **Estado:**
Aceptada **Dominio:** Frontend **Propietario:** @equipo-frontend

**Resumen:** Uso de Redux Toolkit para manejo de estado.

--------------

ADR-013: Webpack Bundler
~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:** ``ADR_013_webpack_bundler.md`` **Estado:** Aceptada
**Dominio:** Frontend **Propietario:** @equipo-frontend

**Resumen:** Uso de Webpack como bundler.

--------------

ADR-040: Schema Validator Agent
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:** ``ADR-040-schema_validator_agent.md`` **Estado:** Aceptada
**Fecha:** 2025-11-XX **Dominio:** AI/Automation **Propietario:**
@equipo-ai

**Resumen:** Agente de validacion de esquemas para documentacion
tecnica.

**Contexto:** Necesidad de validar estructura y formato de archivos de
documentacion automaticamente.

--------------

ADR-041: DevContainer Validator Agent
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:** ``ADR-041-devcontainer_validator_agent.md`` **Estado:**
Aceptada **Fecha:** 2025-11-XX **Dominio:** AI/Automation
**Propietario:** @equipo-ai

**Resumen:** Agente de validacion de configuracion DevContainer.

**Contexto:** Asegurar configuracion correcta de entornos de desarrollo
containerizados.

--------------

ADR-042: Metrics Collector Agent
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:** ``ADR-042-metrics_collector_agent.md`` **Estado:** Aceptada
**Fecha:** 2025-11-XX **Dominio:** AI/Automation **Propietario:**
@equipo-ai

**Resumen:** Agente de recoleccion de metricas de desarrollo y calidad.

**Contexto:** Automatizar recoleccion de metricas DORA y metricas de
calidad de codigo.

--------------

ADR-043: Coherence Analyzer Agent
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:** ``ADR-043-coherence_analyzer_agent.md`` **Estado:**
Aceptada **Fecha:** 2025-11-XX **Dominio:** AI/Automation
**Propietario:** @equipo-ai

**Resumen:** Agente de analisis de coherencia entre documentacion y
codigo.

**Contexto:** Detectar inconsistencias entre documentacion tecnica y
implementacion real.

--------------

ADR-044: Constitution Validator Agent
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:** ``ADR-044-constitution_validator_agent.md`` **Estado:**
Aceptada **Fecha:** 2025-11-XX **Dominio:** AI/Automation
**Propietario:** @equipo-ai

**Resumen:** Agente de validacion de conformidad con constitucion del
proyecto.

**Contexto:** Asegurar que cambios cumplen con principios y
restricciones fundamentales del proyecto.

--------------

ADR-045: CI Pipeline Orchestrator Agent
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:** ``ADR-045-ci_pipeline_orchestrator_agent.md`` **Estado:**
Aceptada **Fecha:** 2025-11-XX **Dominio:** AI/Automation + DevOps
**Propietario:** @equipo-ai @equipo-devops

**Resumen:** Agente orquestador de pipelines CI/CD.

**Contexto:** Coordinar ejecucion de multiples agentes de validacion en
pipeline de integracion continua.

--------------

Organizacion de ADRs
--------------------

Todos los ADRs del proyecto se encuentran en este directorio:
``docs/gobernanza/adr/``

**Indice maestro detallado:** ``docs/gobernanza/INDICE_ADRs.md``

--------------

Proceso de ADR
--------------

Cuando Crear un ADR
~~~~~~~~~~~~~~~~~~~

Crear un ADR cuando:

-  Se toma una decision arquitectonica significativa
-  La decision tiene impacto en multiples dominios
-  La decision establece un patron o estandar
-  Se necesita documentar el razonamiento detras de una eleccion tecnica

Como Crear un ADR
~~~~~~~~~~~~~~~~~

1. Copiar plantilla: ``docs/gobernanza/adr/plantilla_adr.md``
2. Asignar siguiente numero secuencial
3. Nombrar archivo: ``ADR-{NNN}-{descripcion_breve_snake_case}.md``
4. Completar secciones:

   -  Contexto
   -  Decision
   -  Consecuencias
   -  Alternativas consideradas

5. Solicitar revision de arquitecto senior
6. Actualizar este indice
7. Actualizar ``docs/gobernanza/INDICE_ADRs.md``

Template ADR
~~~~~~~~~~~~

Usar plantilla oficial: ``docs/gobernanza/adr/plantilla_adr.md``

--------------

Recursos
--------

-  **Plantilla ADR:** ``docs/gobernanza/adr/plantilla_adr.md``
-  **Guia de Estilo:** ``docs/gobernanza/GUIA_ESTILO.md``
-  **Indice Maestro:** ``docs/gobernanza/INDICE_ADRs.md``

--------------

**Mantenido por:** Equipo de Arquitectura **Contacto:**
@arquitecto-senior
