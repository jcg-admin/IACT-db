.. meta::
 :artefacto: SAGA_DARK_MODE
 :tipo: Saga Pedagogica
 :dominio: base-cognitiva
 :subdominio: ejemplos-pedagogicos
 :saga: dark-mode
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==============================================
Saga: Implementación de Dark Mode (end-to-end)
==============================================

.. note::

 **Saga pedagógica completa.** Esta serie de artefactos sigue la
 implementación hipotética de la feature "Dark Mode" desde la
 detección de la necesidad hasta el deployment a producción,
 aplicando el proceso documental SDLC del proyecto IACT.

 Esta saga es referenciada desde
 :doc:`/normativa/procedimientos/proc-gob-001-mapeo-procesos-templates`
 como ejemplo end-to-end del proceso.

1. Contexto del ejemplo
=======================

**Feature hipotética:** Dark Mode toggle para la UI del producto
IACT.

**Stakeholder originador:** Product Manager.

**Necesidad expresada:** "Los usuarios que trabajan de noche
piden que la interfaz tenga un modo oscuro para reducir fatiga
visual."

Esta saga muestra cómo esa necesidad se transforma en 13
artefactos formales del proceso SDLC, con trazabilidad completa
entre ellos.

2. Mapa de la saga
==================

.. list-table::
 :header-rows: 1
 :widths: 8 30 32 30

 * - Fase SDLC
   - Artefacto
   - Skill aplicada
   - Documento
 * - Descubrimiento
   - Necesidad de Negocio
   - ``ba-elicitation``
   - :doc:`bn-001-dark-mode`
 * - Análisis
   - Reporte de Factibilidad
   - ``cp-diagnosis``
   - :doc:`feasibility-report-dark-mode`
 * - Análisis
   - Regla de Negocio
   - ``ba-requirements-analysis``
   - :doc:`rn-001-dark-mode`
 * - Especificación
   - Requisito Funcional 1 (toggle)
   - ``rm-specification``
   - :doc:`rf-001-dark-mode-toggle`
 * - Especificación
   - Requisito Funcional 2 (persistencia)
   - ``rm-specification``
   - :doc:`rf-002-dark-mode-persistence`
 * - Especificación
   - Caso de Uso
   - ``rm-specification``
   - :doc:`uc-001-activar-dark-mode`
 * - Diseño
   - Diseño de Alto Nivel (HLD)
   - ``bpa-design``
   - :doc:`hld-dark-mode`
 * - Diseño
   - Diseño de Bajo Nivel (LLD)
   - ``bpa-design``
   - :doc:`lld-dark-mode`
 * - Diseño
   - Esquema de Base de Datos
   - ``db-postgresql``
   - :doc:`db-user-preferences`
 * - Implementación
   - API Reference
   - ``backend-nodejs``
   - :doc:`api-reference-preferences`
 * - Pruebas
   - Plan de Pruebas
   - ``dmaic-control``
   - :doc:`test-plan-dark-mode`
 * - Pruebas
   - Caso de Prueba
   - ``dmaic-control``
   - :doc:`tc-001-toggle-dark-mode`
 * - Release
   - Plan de Release
   - ``pm-executing``
   - :doc:`release-plan-v1-5-0`
 * - Deployment
   - Guía de Deployment
   - ``bpa-implement``
   - :doc:`deployment-guide-staging`

3. Hilo de trazabilidad
=======================

::

  BN-001 (necesidad)
   └─> Reporte factibilidad (decision: GO)
        └─> RN-001 (regla negocio)
             ├─> RF-001 (req func: toggle)
             ├─> RF-002 (req func: persistencia)
             └─> UC-001 (caso uso end-user)
                  ├─> HLD (diseño alto nivel)
                  │    ├─> LLD (diseño bajo nivel)
                  │    └─> DB-design (schema preferencias)
                  ├─> API ref (contrato implementación)
                  └─> Test plan
                       └─> TC-001 (test case toggle)
                            └─> Release plan v1.5.0
                                 └─> Deployment guide staging

4. Cómo navegar la saga
=======================

**Lectura secuencial recomendada:** seguir el orden de la tabla
en sección 2 — equivale a recorrer el proceso SDLC en su orden
natural.

**Lectura por skill:** cada artefacto declara
``:skill_aplicada:`` en su metadata. Filtrar por skill permite
ver cómo se aplica cada metodología en distintos artefactos.

**Lectura por fase:** cada artefacto declara ``:fase_sdlc:``.
Útil para entender qué artefactos se generan en cada etapa.

5. Toctree de artefactos
========================

.. toctree::
 :maxdepth: 1

 bn-001-dark-mode
 feasibility-report-dark-mode
 rn-001-dark-mode
 rf-001-dark-mode-toggle
 rf-002-dark-mode-persistence
 uc-001-activar-dark-mode
 hld-dark-mode
 lld-dark-mode
 db-user-preferences
 api-reference-preferences
 test-plan-dark-mode
 tc-001-toggle-dark-mode
 release-plan-v1-5-0
 deployment-guide-staging
