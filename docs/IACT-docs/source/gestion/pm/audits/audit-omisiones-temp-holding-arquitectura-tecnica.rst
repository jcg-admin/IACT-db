.. meta::
 :artefacto: AUDIT_OMISIONES_TEMP_HOLDING
 :tipo: Audit
 :dominio: gestion
 :subdominio: pm/audits
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

============================================================
Audit omisiones temp-holding — Arquitectura Técnica (WP #7)
============================================================

.. note::

 Migrado a source/ desde artefacto histórico de WP
 source-rebuild-arquitectura-tecnica (Phase 11 TRACK).
 Audit retrospectivo de inputs no migrados desde
 ``temp-holding/``. Aplica skill ``pm-monitoring``.

1. Premisa
==========

Tras pregunta del ejecutor: "sólo consideraste información de
``temp-backup/``, ¿qué pasó con ``temp-holding/*``?". Audit de
inputs/canonical revela que el WP #7 tiene **117 archivos
pre-staged** (algunos de ``temp-holding``) de los cuales en v1
mínimal sólo se migró **1** (``MODELO_RBAC_IACT_v5_2_1.md``).

2. Inventario de inputs no migrados (post v1)
=============================================

2.1 Migrado en v1 mínimal
-------------------------

- ``MODELO_RBAC_IACT_v5_2_1.md`` →
  ``source/arquitectura-tecnica/rbac/modelo-rbac-iact.rst``
- ``ARQ_MOD_001..008.rst`` (8 archivos) →
  ``source/arquitectura-tecnica/modulos/`` (agregado en v1.1)

2.2 NO migrado todavía (categorías por orden de prioridad)
----------------------------------------------------------

.. list-table::
 :widths: 30 10 18 12 30
 :header-rows: 1

 * - Categoría
   - Cantidad
   - Origen probable
   - Prioridad
   - Decisión propuesta
 * - BR_*.rst (variantes)
   - 22
   - temp-holding
   - Baja
   - Descartar (BRs canónicos ya en
     ``source/requisitos/reglas-negocio/`` desde WP #6 v2)
 * - MODELO_DOCUMENTAL_IACT_v*
   - 13
   - temp-holding
   - Media
   - Migrar 1 (v más reciente); descartar versiones legacy
 * - TPL (plantillas)
   - 5
   - temp-holding
   - Baja
   - Probables duplicados de
     ``normativa/estandares/plantillas/`` — verificar y
     descartar duplicados
 * - MODELO_RBAC versiones legacy (v5.0, 5.1, 5.1.1, 5.2.0)
   - 4
   - temp-holding
   - Baja
   - Descartar (v5.2.1 es la canónica vigente)
 * - ANEXO_A_ARBOL_COMPLETO
   - 3
   - temp-holding
   - Baja
   - Descartar (análisis del árbol del proyecto, ya integrado
     a ``meta/``)
 * - PARTE
   - 2
   - temp-holding
   - Baja
   - Probable análisis pedagógico fragmentado
 * - ANALISIS_FND_vs_MODELO
   - 2
   - temp-holding
   - Baja
   - Análisis previos a la consolidación v5.2.x
 * - ANALISIS_ERRORES_MODELO_RBAC_v5_2_0
   - 1
   - temp-holding
   - Media
   - Migrar como ADR-tipo "errores corregidos en v5.2.1" o
     descartar
 * - ANALISIS_PROFUNDO_RBAC_MODULOS_IACT
   - 1
   - temp-holding
   - Alta
   - **MIGRAR — análisis estructurado de los 8 módulos**
 * - ANALISIS_PROFUNDO_TAXONOMIAS_METAMODELOS_IACT
   - 1
   - temp-holding
   - Media
   - Migrar a ``base-cognitiva`` (no aquí)
 * - etl-pipeline.rst
   - 1
   - temp-backup
   - Alta
   - **MIGRAR a ``arquitectura-tecnica/diseno-detallado/``**
 * - lineamientos-codigo.rst
   - 1
   - temp-backup
   - Alta
   - **MIGRAR a ``arquitectura-tecnica/arquitectura/``**
 * - sistema-completo.rst
   - 1
   - temp-backup
   - Media
   - Migrar como vista global del sistema
 * - test-uc-diagram.rst, test-component-diagram.rst
   - 2
   - temp-backup
   - Baja
   - Tests de PlantUML — diferir a v2 con plantuml-guide
 * - GUIDELINES.rst, METADATA-STANDARD.rst, color-palette.rst
     (plantuml-guide)
   - 3
   - temp-backup
   - Media
   - Migrar a ``arquitectura-tecnica/plantuml-guide/`` en v2
 * - 15 archivos .rst de arquitectura-tecnica/
     {arquitectura,despliegue,diseno-detallado}/
   - 15
   - temp-backup
   - Alta
   - **MIGRAR en v2** del WP #7

3. Ajuste retrospectivo: v1 ya hizo más de lo declarado
=======================================================

En v1 mínimal originalmente sólo se migró
``modelo-rbac-iact.rst``. En la misma iteración (post-pregunta del
ejecutor) se agregaron los **8 ARQ_MOD_001..008** porque eran
omisión crítica (definición arquitectónica de los 8 módulos del
sistema).

Estado real de v1 (post-fix):

- 9 archivos en ``source/arquitectura-tecnica/``:

  - ``rbac/modelo-rbac-iact.rst`` (~2616 líneas)
  - ``rbac/index.rst``
  - ``modulos/arq-mod-001..008.rst`` (8 archivos)
  - ``modulos/index.rst``
  - ``index.rst`` raíz

4. Trabajo restante (v2 del WP #7)
==================================

4.1 Alta prioridad (debe hacerse en v2)
---------------------------------------

1. **15 archivos de** ``temp-backup/source-2026-04-28/arquitectura-tecnica/``
   distribuidos en 3 sub-cajones:

   - ``arquitectura/`` (overview, OBSERVABILITY_LAYERS,
     STORAGE_ARCHITECTURE, design patterns, lineamientos-codigo,
     etc.)
   - ``despliegue/`` (deployment topologies)
   - ``diseno-detallado/``

2. **Migración de** ``plantuml-guide/`` (8 archivos absorbidos del
   cajón original — F-04 declarado en wp-state original)
3. **etl-pipeline.rst** y **sistema-completo.rst** (vistas del
   sistema)
4. ``ANALISIS_PROFUNDO_RBAC_MODULOS_IACT.md`` convertido a ``.rst``
5. ``ANALISIS_PROFUNDO_TAXONOMIAS_METAMODELOS_IACT.md`` → migrar
   a ``base-cognitiva`` (no a ``arquitectura-tecnica``)

4.2 Media prioridad
-------------------

6. **MODELO_DOCUMENTAL_IACT** v más reciente (1 de 13 versiones).
   Descartar las 12 anteriores.
7. **ANALISIS_ERRORES_MODELO_RBAC_v5_2_0** como ADR tipo "errores
   corregidos en migración v5.2.0 → v5.2.1".

4.3 Baja prioridad / descartables
---------------------------------

8. 4 versiones legacy de MODELO_RBAC (v5.0, v5.1, v5.1.1, v5.2.0):
   descartar — la canónica vigente es v5.2.1.
9. 22 BR_*.rst variantes: ya están en
   ``source/requisitos/reglas-negocio`` desde WP #6 v2. Verificar
   duplicación antes de descartar.
10. 5 TPL: verificar si son duplicados de
    ``normativa/estandares/plantillas``.
11. ANEXOS, PARTEs, ANALISIS_FND_vs_MODELO: descartar (análisis
    previos).

5. Veredicto
============

WP #7 v1 NO está completo — sólo cubre el RBAC. v2 debe ejecutarse
para migrar los 15+ archivos restantes de arquitectura técnica
canónica + plantuml-guide.

Estimación v2: ~4-6 horas dependiendo de cuántos requieren
conversión ``.md → .rst`` vs sólo copia.

6. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``pm-monitoring`` (PMBOK — Monitoring & Controlling)
 * - **WP origen**
   - source-rebuild-arquitectura-tecnica (2026-04-28)
 * - **Migrado a source**
   - 2026-04-30 (sub-WP md-references-audit)
 * - **Audit master**
   - :doc:`audit-cross-wp-source-rebuild`
