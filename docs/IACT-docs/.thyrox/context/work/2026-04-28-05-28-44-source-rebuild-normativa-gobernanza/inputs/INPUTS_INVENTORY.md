```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-44-source-rebuild-normativa-gobernanza
phase: Phase 1 — DISCOVER (input staging)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Inventory — WP normativa-gobernanza

Documentos pre-staged desde `temp-backup/` y `temp-holding/`. Solo estos archivos deben consultarse para el analisis de este WP — evita buscar en todo `temp-*`.

## Convencion

- `canonical/` — un solo archivo por concepto (MD5 deduplicado, preferencia: temp-backup > FASE 02 > FASE 01).
- `variants/` — archivos con mismo nombre pero contenido distinto, ruta espejo del origen para desambiguar.

## Resumen

- Canonicos: **349**
- Variantes: **74**
- Duplicados colapsados: **0**

- Tamano total stage: 5,259,539 bytes (5136.3 KB)

## Canonicos

| Destino | Origen elegido | Hash | Bytes | Dups colapsados |
|---------|---------------|------|-------|----------------|
| `canonical/00_resumen_ejecutivo_mejores_practicas.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/00_resumen_ejecutivo_mejores_practicas.md` | 1f937581 | 15,746 | 0 |
| `canonical/01_marco_conceptual_iact.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/01_marco_conceptual_iact.md` | 094803c5 | 21,379 | 0 |
| `canonical/02_relaciones_fundamentales_iact.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/02_relaciones_fundamentales_iact.md` | 8127ff99 | 24,423 | 0 |
| `canonical/03_matrices_trazabilidad_iact.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/03_matrices_trazabilidad_iact.md` | beb541ce | 32,988 | 0 |
| `canonical/04_metodologia_analisis_iact.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/04_metodologia_analisis_iact.md` | e053ba41 | 23,731 | 0 |
| `canonical/05a_casos_practicos_iact.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/05a_casos_practicos_iact.md` | 1dfd829c | 44,901 | 0 |
| `canonical/05b_caso_didactico_generico.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/05b_caso_didactico_generico.md` | 9f8c2337 | 35,658 | 0 |
| `canonical/06_plantillas_integradas_iact.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/06_plantillas_integradas_iact.md` | df587a8a | 39,543 | 0 |
| `canonical/2025_02_16_ejecucion_pytest.md` | `temp-holding/FASE 01/docs/gobernanza/qa/registros/2025_02_16_ejecucion_pytest.md` | 8fddad9e | 1,447 | 0 |
| `canonical/2025_02_20_revision_documentacion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/registros/2025_02_20_revision_documentacion.md` | 8defa602 | 1,553 | 0 |
| `canonical/2025_02_21_revision_backend.md` | `temp-holding/FASE 01/docs/gobernanza/qa/registros/2025_02_21_revision_backend.md` | 25a83cb0 | 1,948 | 0 |
| `canonical/2025_11_02_ejecucion_pytest.md` | `temp-holding/FASE 01/docs/gobernanza/qa/registros/2025_11_02_ejecucion_pytest.md` | a7329138 | 1,489 | 0 |
| `canonical/2025_11_05_merge_ramas.md` | `temp-holding/FASE 01/docs/gobernanza/qa/registros/2025_11_05_merge_ramas.md` | e061b89f | 8,575 | 0 |
| `canonical/2025_11_05_merge_ramas_gitops.md` | `temp-holding/FASE 01/docs/gobernanza/qa/registros/2025_11_05_merge_ramas_gitops.md` | 35d9a38d | 16,260 | 0 |
| `canonical/ADR-BACK-001-grupos-funcionales-sin-jerarquia.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-BACK-001-grupos-funcionales-sin-jerarquia.rst` | 1d011ae7 | 13,505 | 0 |
| `canonical/ADR-BACK-002-configuracion-dinamica-sistema.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-BACK-002-configuracion-dinamica-sistema.rst` | 383cdfc8 | 10,122 | 0 |
| `canonical/ADR-BACK-003-orm-sql-hybrid-permissions.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-BACK-003-orm-sql-hybrid-permissions.rst` | fc92c8de | 14,044 | 0 |
| `canonical/ADR-BACK-004-sistema-permisos-sin-roles-jerarquicos.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-BACK-004-sistema-permisos-sin-roles-jerarquicos.rst` | df61c9cb | 10,048 | 0 |
| `canonical/ADR-DEVOPS-001-vagrant-mod-wsgi-IMPORTANTE-PRODUC.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-DEVOPS-001-vagrant-mod-wsgi-IMPORTANTE-PRODUC.rst` | 4e7577f6 | 8,233 | 0 |
| `canonical/ADR-DEVOPS-003-wasi-style-virtualization--IMPORTANTE-DB.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-DEVOPS-003-wasi-style-virtualization--IMPORTANTE-DB.rst` | 4a0baf6f | 12,070 | 0 |
| `canonical/ADR-FRONT-001-frontend-modular-monolith.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-FRONT-001-frontend-modular-monolith.rst` | bc334f1f | 8,059 | 0 |
| `canonical/ADR-FRONT-002-redux-toolkit-state-management.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-FRONT-002-redux-toolkit-state-management.rst` | d064eb05 | 10,033 | 0 |
| `canonical/ADR-FRONT-003-webpack-bundler.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-FRONT-003-webpack-bundler.rst` | 61601485 | 9,663 | 0 |
| `canonical/ADR-FRONT-004-arquitectura-microfrontends.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-FRONT-004-arquitectura-microfrontends.rst` | 9e772197 | 3,351 | 0 |
| `canonical/ADR-FRONT-010-typescript-adopcion-gradual.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-FRONT-010-typescript-adopcion-gradual.rst` | a918eba3 | 20,421 | 0 |
| `canonical/ADR-GOB-002-organizacion-proyecto-por-dominio.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-GOB-002-organizacion-proyecto-por-dominio.rst` | 30c79d65 | 17,996 | 0 |
| `canonical/ADR-GOB-004-plantuml-para-diagramas.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-GOB-004-plantuml-para-diagramas.rst` | 333a1ccc | 14,678 | 0 |
| `canonical/ADR-GOB-005-jerarquia-requerimientos-5-niveles.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-GOB-005-jerarquia-requerimientos-5-niveles.rst` | f61fa19a | 25,069 | 0 |
| `canonical/ADR-GOB-006-clasificacion-reglas-negocio.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-GOB-006-clasificacion-reglas-negocio.rst` | a41ec96f | 25,131 | 0 |
| `canonical/ADR-GOB-007-especificacion-casos-uso.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-GOB-007-especificacion-casos-uso.rst` | fc6f0743 | 25,170 | 0 |
| `canonical/ADR-GOB-008-diagramas-uml-casos-uso.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-GOB-008-diagramas-uml-casos-uso.rst` | d7dbe02f | 19,845 | 0 |
| `canonical/ADR-GOB-009-trazabilidad-artefactos-requisitos.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-GOB-009-trazabilidad-artefactos-requisitos.rst` | 3dbaeaf5 | 19,022 | 0 |
| `canonical/ADR-QA-002-testing-strategy-jest-testing-library.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/ADR-QA-002-testing-strategy-jest-testing-library.rst` | 40efba8c | 11,484 | 0 |
| `canonical/ANALISIS-ESTRUCTURA-GOBERNANZA-2025-11-17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-ESTRUCTURA-003/ANALISIS-ESTRUCTURA-GOBERNANZA-2025-11-17.md` | 42f44206 | 29,735 | 0 |
| `canonical/ANALISIS-GOBERNANZA-POST-LIMPIEZA-2025-11-17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/ANALISIS-GOBERNANZA-POST-LIMPIEZA-2025-11-17.md` | 2335c4d0 | 11,652 | 0 |
| `canonical/ANALISIS-PROYECTO-2025-01-17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/ANALISIS-PROYECTO-2025-01-17.md` | 31cfb063 | 13,573 | 0 |
| `canonical/ANALISIS-RAMAS-2025-11-17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/ANALISIS-RAMAS-2025-11-17.md` | 9126ed76 | 26,963 | 0 |
| `canonical/ANALISIS_COMPLETO_PROYECTO_IACT_2025_11_17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/ANALISIS_COMPLETO_PROYECTO_IACT_2025_11_17.md` | 031db760 | 35,146 | 0 |
| `canonical/ANALISIS_DOCS_ESTRUCTURA_20251116.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/ANALISIS_DOCS_ESTRUCTURA_20251116.md` | 029bc25d | 16,293 | 0 |
| `canonical/ANALISIS_DOCS_FINAL_20251116_0945.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/ANALISIS_DOCS_FINAL_20251116_0945.md` | 551721e6 | 10,733 | 0 |
| `canonical/ANALISIS_DOCS_GOBERNANZA_2025_11_17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/ANALISIS_DOCS_GOBERNANZA_2025_11_17.md` | 9d261d26 | 23,700 | 0 |
| `canonical/ANALISIS_FINAL_LIMPIO.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/ANALISIS_FINAL_LIMPIO.md` | 37f51fe3 | 8,341 | 0 |
| `canonical/ANALISIS_GUIAS_WORKFLOWS.md` | `temp-holding/FASE 01/docs/gobernanza/ANALISIS_GUIAS_WORKFLOWS.md` | 4a993cbc | 28,732 | 0 |
| `canonical/ANALISIS_INCONSISTENCIAS_NOMENCLATURA_2025_11_17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/ANALISIS_INCONSISTENCIAS_NOMENCLATURA_2025_11_17.md` | 79b840bb | 23,499 | 0 |
| `canonical/ANALISIS_UBICACION_ARCHIVOS.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/ANALISIS_UBICACION_ARCHIVOS.md` | ba089043 | 10,484 | 0 |
| `canonical/ANUNCIO_EQUIPO_REORGANIZACION.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/ANUNCIO_EQUIPO_REORGANIZACION.md` | aff5b9cc | 8,864 | 0 |
| `canonical/APLICACION_IACT.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/reglas_negocio/APLICACION_IACT.md` | fc51099e | 38,485 | 0 |
| `canonical/Architecture Decision Records (ADRs) - Indice Maestro.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/Architecture Decision Records (ADRs) - Indice Maestro.rst` | 0c3d789e | 6,591 | 0 |
| `canonical/CASOS_USO.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/CASOS_USO.md` | 6acefe5e | 27,876 | 0 |
| `canonical/CHANGELOG.md` | `temp-holding/FASE 01/docs/gobernanza/CHANGELOG.md` | 6fd04334 | 39,558 | 0 |
| `canonical/COMO_VER_DOCUMENTACION.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/COMO_VER_DOCUMENTACION.md` | 3900554d | 12,956 | 0 |
| `canonical/CONSOLIDATION_STATUS.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/CONSOLIDATION_STATUS.md` | a3a8a29f | 5,886 | 0 |
| `canonical/Casos de Uso (Plantilla UC-V2)- README.md` | `temp-holding/FASE 01/docs/trazabilidad/casos_de_uso/Casos de Uso (Plantilla UC-V2)- README.md` | 674be5bc | 1,000 | 0 |
| `canonical/DOCS_LEGACY_ANALYSIS_REPORT.md` | `temp-holding/FASE 01/docs/gobernanza/DOCS_LEGACY_ANALYSIS_REPORT.md` | 07d9c281 | 18,794 | 0 |
| `canonical/ESPECIFICACION_TESTS_COMPLIANCE.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/reglas_negocio/ESPECIFICACION_TESTS_COMPLIANCE.md` | 8b8544f0 | 9,532 | 0 |
| `canonical/ESTRATEGIA_QA.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/qa/ESTRATEGIA_QA.md` | 7f993e2e | 1,656 | 0 |
| `canonical/ESTRATEGIA_REORGANIZACION_TODO_POR_DOMINIO.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/ESTRATEGIA_REORGANIZACION_TODO_POR_DOMINIO.md` | 33da35fb | 36,141 | 0 |
| `canonical/ETA_CODEX_ANALISIS.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/ETA_CODEX_ANALISIS.md` | f5192110 | 8,868 | 0 |
| `canonical/Ejemplos - GOBERNANZA.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/Ejemplos - GOBERNANZA.rst` | b8c62999 | 8,929 | 0 |
| `canonical/FASE1_INVESTIGACION_APPS_DUPLICADAS_2025_11_17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/FASE1_INVESTIGACION_APPS_DUPLICADAS_2025_11_17.md` | 7ce13c50 | 16,300 | 0 |
| `canonical/FASE2_DECISION_ESTRATEGIA_NAMING_2025_11_17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/FASE2_DECISION_ESTRATEGIA_NAMING_2025_11_17.md` | 7fb15397 | 20,696 | 0 |
| `canonical/GAP_ANALYSIS_SISTEMA_PERMISOS.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/GAP_ANALYSIS_SISTEMA_PERMISOS.md` | 446b0d19 | 20,782 | 0 |
| `canonical/GOB_01_Modelo_Gobernanza_IACT.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/GOB_01_Modelo_Gobernanza_IACT.rst` | a9dd64c0 | 16,751 | 0 |
| `canonical/GOB_02_Roles_y_RACI.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/GOB_02_Roles_y_RACI.rst` | 18c93127 | 19,649 | 0 |
| `canonical/GOB_03_Control_Calidad_Documental.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/GOB_03_Control_Calidad_Documental.rst` | 52d39c41 | 18,915 | 0 |
| `canonical/GOB_04_Gestion_Cambios_Documentales.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/GOB_04_Gestion_Cambios_Documentales.rst` | be2f178a | 17,579 | 0 |
| `canonical/GOB_06_Trazabilidad_SDLC.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/GOB_06_Trazabilidad_SDLC.rst` | ce1110d0 | 16,988 | 0 |
| `canonical/GOB_07_Gestion_Dominios.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/GOB_07_Gestion_Dominios.rst` | 7c09941c | 20,137 | 0 |
| `canonical/GOB_08_Estados_Documentales.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/GOB_08_Estados_Documentales.rst` | a4d30602 | 19,154 | 0 |
| `canonical/GOB_09_Politica_Clasificacion.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/GOB_09_Politica_Clasificacion.rst` | 9a890780 | 16,926 | 0 |
| `canonical/GOB_10_Auditoria_Documental.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/GOB_10_Auditoria_Documental.rst` | 37dd445f | 21,734 | 0 |
| `canonical/GUIA-DEV-001-quickstart.md` | `temp-holding/FASE 01/docs/gobernanza/guias/GUIA-DEV-001-quickstart.md` | 685c21af | 6,711 | 0 |
| `canonical/GUIA-GOB-001-procesos_vs_procedimientos.md` | `temp-holding/FASE 01/docs/gobernanza/guias/GUIA-GOB-001-procesos_vs_procedimientos.md` | b1d8bce9 | 10,464 | 0 |
| `canonical/GUIA-GOB-002-convenciones_nomenclatura.md` | `temp-holding/FASE 01/docs/gobernanza/guias/GUIA-GOB-002-convenciones_nomenclatura.md` | d0067f4e | 14,382 | 0 |
| `canonical/GUIA-GOB-003-ubicaciones_artefactos.md` | `temp-holding/FASE 01/docs/gobernanza/guias/GUIA-GOB-003-ubicaciones_artefactos.md` | 51370290 | 42,669 | 0 |
| `canonical/GUIA-GOB-004-metrics.md` | `temp-holding/FASE 01/docs/gobernanza/guias/GUIA-GOB-004-metrics.md` | 936f2885 | 10,405 | 0 |
| `canonical/GUIA-GOB-005-derivar-requisitos-entre-niveles.md` | `temp-holding/FASE 01/docs/gobernanza/guias/GUIA-GOB-005-derivar-requisitos-entre-niveles.md` | edae9583 | 19,227 | 0 |
| `canonical/GUIA-GOB-006-identificar-clasificar-reglas-negocio.md` | `temp-holding/FASE 01/docs/gobernanza/guias/GUIA-GOB-006-identificar-clasificar-reglas-negocio.md` | c15a01e0 | 26,762 | 0 |
| `canonical/GUIA-GOB-007-escribir-casos-uso-efectivos.md` | `temp-holding/FASE 01/docs/gobernanza/guias/GUIA-GOB-007-escribir-casos-uso-efectivos.md` | 1ad1150a | 31,590 | 0 |
| `canonical/GUIA-GOB-008-crear-diagramas-plantuml.md` | `temp-holding/FASE 01/docs/gobernanza/guias/GUIA-GOB-008-crear-diagramas-plantuml.md` | f8e8f341 | 24,985 | 0 |
| `canonical/GUIA-GOB-009-documentacion-uml-completa.md` | `temp-holding/FASE 01/docs/gobernanza/guias/GUIA-GOB-009-documentacion-uml-completa.md` | 1667967b | 59,008 | 0 |
| `canonical/GUIA_ESTILO.md` | `temp-holding/FASE 01/docs/gobernanza/GUIA_ESTILO.md` | 95093994 | 15,806 | 0 |
| `canonical/Gobernanza del Frontend-README.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/Gobernanza del Frontend-README.rst` | 0764d99d | 5,139 | 0 |
| `canonical/HECHOS_RESTRICCIONES.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/reglas_negocio/HECHOS_RESTRICCIONES.md` | b6b2f008 | 18,635 | 0 |
| `canonical/IMPLEMENTACION_SCRIPTS.md` | `temp-holding/FASE 01/docs/gobernanza/trazabilidad/IMPLEMENTACION_SCRIPTS.md` | 63a321a0 | 13,276 | 0 |
| `canonical/INDEX.md` | `temp-holding/FASE 01/docs/gobernanza/INDEX.md` | bb99ed07 | 2,017 | 0 |
| `canonical/INDICE_ADRs.md` | `temp-holding/FASE 01/docs/gobernanza/INDICE_ADRs.md` | 6fa306ed | 24,211 | 0 |
| `canonical/INDICE_WORKFLOWS.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/INDICE_WORKFLOWS.md` | db3c7acb | 17,026 | 0 |
| `canonical/INTEGRATION_ANALYSIS_REPORT.md` | `temp-holding/FASE 01/docs/gobernanza/qa/INTEGRATION_ANALYSIS_REPORT.md` | 9ba12a65 | 12,177 | 0 |
| `canonical/INTRODUCCION.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/reglas_negocio/INTRODUCCION.md` | 25f4a7c2 | 10,357 | 0 |
| `canonical/LECCIONES_APRENDIDAS_FASE_4.md` | `temp-holding/FASE 01/docs/gobernanza/LECCIONES_APRENDIDAS_FASE_4.md` | 94b3d376 | 20,166 | 0 |
| `canonical/MAPEO_MIGRACION_LEGACY.md` | `temp-holding/FASE 01/docs/gobernanza/MAPEO_MIGRACION_LEGACY.md` | 73f67519 | 11,081 | 0 |
| `canonical/MATRIZ-BACK-autenticacion.md` | `temp-holding/FASE 01/docs/gobernanza/trazabilidad/matrices/MATRIZ-BACK-autenticacion.md` | b85027bc | 1,846 | 0 |
| `canonical/MATRIZ-trazabilidad-template.md` | `temp-holding/FASE 01/docs/gobernanza/templates/MATRIZ-trazabilidad-template.md` | a59fb065 | 11,353 | 0 |
| `canonical/MERGE_LOSS_ANALYSIS.md` | `temp-holding/FASE 01/docs/gobernanza/MERGE_LOSS_ANALYSIS.md` | eaeec8f1 | 3,134 | 0 |
| `canonical/MERGE_STRATEGY_PR_175.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/MERGE_STRATEGY_PR_175.md` | 70a0f083 | 13,713 | 0 |
| `canonical/META_CODEX_PARTE_1.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/META_CODEX_PARTE_1.md` | c8e75fbe | 17,328 | 0 |
| `canonical/METODOLOGIA-SERVICIOS-ESPECIALIZADOS-SESION-COMPLETA.md` | `temp-holding/FASE 01/docs/gobernanza/metodologias/METODOLOGIA-SERVICIOS-ESPECIALIZADOS-SESION-COMPLETA.md` | 6a90b279 | 19,723 | 0 |
| `canonical/METODOLOGIA_DESARROLLO_POR_LOTES.md` | `temp-holding/FASE 01/docs/gobernanza/metodologias/METODOLOGIA_DESARROLLO_POR_LOTES.md` | 6ba2974f | 31,264 | 0 |
| `canonical/MIGRATION_FROM_LEGACY.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/MIGRATION_FROM_LEGACY.md` | d226d644 | 13,245 | 0 |
| `canonical/NEXT_STEPS_IACT_CODE_REQUEST.md` | `temp-holding/FASE 01/docs/trazabilidad/NEXT_STEPS_IACT_CODE_REQUEST.md` | 0460794f | 1,698 | 0 |
| `canonical/PLAN-CONSOLIDACION-RAMAS-2025-11-17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/PLAN-CONSOLIDACION-RAMAS-2025-11-17.md` | e8ff2be3 | 27,201 | 0 |
| `canonical/PLAN-MEJORA-2025-01-17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/PLAN-MEJORA-2025-01-17.md` | 30e78a87 | 17,716 | 0 |
| `canonical/PLAN_CONSOLIDACION_PRS.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/PLAN_CONSOLIDACION_PRS.md` | efc693a6 | 8,780 | 0 |
| `canonical/PLAN_REMEDIACION_DOCS_GOBERNANZA.md` | `temp-holding/FASE 01/docs/gobernanza/planificacion/PLAN_REMEDIACION_DOCS_GOBERNANZA.md` | a233a3e7 | 34,521 | 0 |
| `canonical/PLAN_REMEDIACION_TRZ.md` | `temp-holding/FASE 01/docs/trazabilidad/PLAN_REMEDIACION_TRZ.md` | 240b1f3f | 52,785 | 0 |
| `canonical/PLAN_REORGANIZACION_DOCS_AI_20251117_080000.md` | `temp-holding/FASE 01/docs/gobernanza/qa/PLAN_REORGANIZACION_DOCS_AI_20251117_080000.md` | aae9e62d | 8,463 | 0 |
| `canonical/PROC-001-gobernanza_sdlc.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/PROC-001-gobernanza_sdlc.md` | ee4a0eee | 19,324 | 0 |
| `canonical/PROC-DEV-001-pipeline_trabajo_iact.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/PROC-DEV-001-pipeline_trabajo_iact.md` | da00596f | 17,552 | 0 |
| `canonical/PROC-DEV-002-sdlc_process.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/PROC-DEV-002-sdlc_process.md` | 23257e17 | 22,778 | 0 |
| `canonical/PROC-DEVOPS-001-devops_automation.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/PROC-DEVOPS-001-devops_automation.md` | 01e4e6b1 | 14,770 | 0 |
| `canonical/PROC-GOB-001-mapeo_procesos_templates.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/PROC-GOB-001-mapeo_procesos_templates.md` | 2491fb14 | 38,454 | 0 |
| `canonical/PROC-GOB-008-reorganizacion-estructura-documental.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/PROC-GOB-008-reorganizacion-estructura-documental.md` | 46134ece | 19,595 | 0 |
| `canonical/PROC-QA-001-actividades_garantia_documental.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/PROC-QA-001-actividades_garantia_documental.md` | 1e37d111 | 3,440 | 0 |
| `canonical/PROC-QA-002-estrategia_qa.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/PROC-QA-002-estrategia_qa.md` | ad397b50 | 1,687 | 0 |
| `canonical/PROPUESTA_FINAL_REESTRUCTURACION.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/PROPUESTA_FINAL_REESTRUCTURACION.md` | a2ae492f | 18,946 | 0 |
| `canonical/PR_BODY.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/PR_BODY.md` | f31b97ce | 2,950 | 0 |
| `canonical/PR_DESCRIPTION.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/PR_DESCRIPTION.md` | dbf2f22a | 9,235 | 0 |
| `canonical/README-(ADR) - Backend.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/README-(ADR) - Backend.rst` | 9035a4b4 | 2,033 | 0 |
| `canonical/README_glosario.md` | `temp-holding/FASE 01/docs/gobernanza/README_glosario.md` | a9e8a048 | 2,249 | 0 |
| `canonical/REORGANIZACION_DOCS.md` | `temp-holding/FASE 01/docs/trazabilidad/REORGANIZACION_DOCS.md` | 0f6bc973 | 2,463 | 0 |
| `canonical/REPORTE_ANALISIS_FINAL_GOBERNANZA_20251117_083000.md` | `temp-holding/FASE 01/docs/gobernanza/qa/REPORTE_ANALISIS_FINAL_GOBERNANZA_20251117_083000.md` | 7e3a2be4 | 20,517 | 0 |
| `canonical/REPORTE_ANALISIS_MARCO_INTEGRADO_20251117_083500.md` | `temp-holding/FASE 01/docs/gobernanza/qa/REPORTE_ANALISIS_MARCO_INTEGRADO_20251117_083500.md` | 538f928c | 14,954 | 0 |
| `canonical/REPORTE_APPS_DUPLICADAS_CONFIGURATION_2025_11_17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/REPORTE_APPS_DUPLICADAS_CONFIGURATION_2025_11_17.md` | da38a188 | 18,311 | 0 |
| `canonical/REPORTE_CLASIFICACION_ADRS_DOMINIO_20251117_062223.md` | `temp-holding/FASE 01/docs/gobernanza/qa/REPORTE_CLASIFICACION_ADRS_DOMINIO_20251117_062223.md` | d8e32610 | 40,383 | 0 |
| `canonical/REPORTE_DUPLICADOS.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/REPORTE_DUPLICADOS.md` | a31fae28 | 12,361 | 0 |
| `canonical/REPORTE_EMOJIS_DOCS_GOBERNANZA_2025_11_17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/REPORTE_EMOJIS_DOCS_GOBERNANZA_2025_11_17.md` | 355576e6 | 9,478 | 0 |
| `canonical/RESUMEN-FINAL.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/evidencias/TASK-001/RESUMEN-FINAL.md` | 20443e96 | 4,670 | 0 |
| `canonical/RESUMEN_EJECUTIVO_REORGANIZACION.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/RESUMEN_EJECUTIVO_REORGANIZACION.md` | 7e91ec1f | 22,612 | 0 |
| `canonical/RESUMEN_MIGRACION_SHELL_SCRIPTS.md` | `temp-holding/FASE 01/docs/gobernanza/RESUMEN_MIGRACION_SHELL_SCRIPTS.md` | adb6222d | 11,581 | 0 |
| `canonical/RESUMEN_SESION_CONSOLIDACION.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/RESUMEN_SESION_CONSOLIDACION.md` | 65b3387e | 11,535 | 0 |
| `canonical/REV_20251112_remediation_plan.md` | `temp-holding/FASE 01/docs/gobernanza/plans/REV_20251112_remediation_plan.md` | 3b0d9c63 | 4,885 | 0 |
| `canonical/RF-BACK-010-validar-credenciales.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/ejemplos_test/RF-BACK-010-validar-credenciales.md` | ed936e33 | 1,271 | 0 |
| `canonical/RF-template.md` | `temp-holding/FASE 01/docs/gobernanza/templates/RF-template.md` | 2b08912d | 9,516 | 0 |
| `canonical/RN-BACK-001-autenticacion-requerida.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/ejemplos_test/RN-BACK-001-autenticacion-requerida.md` | ffb181e8 | 893 | 0 |
| `canonical/RN-calculo-template.md` | `temp-holding/FASE 01/docs/gobernanza/templates/RN-calculo-template.md` | 2073b22a | 8,920 | 0 |
| `canonical/RN-desencadenador-template.md` | `temp-holding/FASE 01/docs/gobernanza/templates/RN-desencadenador-template.md` | 776fb143 | 5,369 | 0 |
| `canonical/RN-hecho-template.md` | `temp-holding/FASE 01/docs/gobernanza/templates/RN-hecho-template.md` | afb8d6e5 | 3,029 | 0 |
| `canonical/RN-inferencia-template.md` | `temp-holding/FASE 01/docs/gobernanza/templates/RN-inferencia-template.md` | 0e941ef6 | 6,588 | 0 |
| `canonical/RN-restriccion-template.md` | `temp-holding/FASE 01/docs/gobernanza/templates/RN-restriccion-template.md` | fc2147a5 | 4,631 | 0 |
| `canonical/RNEG-BACK-001-sistema-autenticacion.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/ejemplos_test/RNEG-BACK-001-sistema-autenticacion.md` | 89c3cf1b | 916 | 0 |
| `canonical/RNF-BACK-005-longitud-contrasena.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/ejemplos_test/RNF-BACK-005-longitud-contrasena.md` | 1546414b | 1,408 | 0 |
| `canonical/RNF-template.md` | `temp-holding/FASE 01/docs/gobernanza/templates/RNF-template.md` | b88fb2f8 | 10,556 | 0 |
| `canonical/ROADMAP.md` | `temp-holding/FASE 01/docs/gobernanza/ROADMAP.md` | 87bf7a7c | 12,811 | 0 |
| `canonical/SESSION_PIPELINE_2025_11_13.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/SESSION_PIPELINE_2025_11_13.md` | 859789c1 | 14,320 | 0 |
| `canonical/SYNC_REPORT_20251106_132547.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/SYNC_REPORT_20251106_132547.md` | ed307113 | 4,505 | 0 |
| `canonical/SYNC_REPORT_20251106_132936.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/SYNC_REPORT_20251106_132936.md` | 9ca1a0fc | 4,670 | 0 |
| `canonical/TAREAS_ACTIVAS.md` | `temp-holding/FASE 01/docs/gobernanza/TAREAS_ACTIVAS.md` | 38e53125 | 12,507 | 0 |
| `canonical/TASK-004-tests_de_auditoría_inmutable.md` | `temp-holding/FASE 01/docs/gobernanza/TASK-004-tests_de_auditoría_inmutable.md` | 6c71eb10 | 2,385 | 0 |
| `canonical/TASK-008-cron_job_dora_mensuales.md` | `temp-holding/FASE 01/docs/gobernanza/TASK-008-cron_job_dora_mensuales.md` | 6d1954f7 | 6,740 | 0 |
| `canonical/TASK-015-actualizacion_documentacion.md` | `temp-holding/FASE 01/docs/gobernanza/TASK-015-actualizacion_documentacion.md` | 4835d8ad | 12,422 | 0 |
| `canonical/TASK-016-compliance_rnf_002_audit.md` | `temp-holding/FASE 01/docs/gobernanza/TASK-016-compliance_rnf_002_audit.md` | 87e5d152 | 15,681 | 0 |
| `canonical/TASK-023-security_audit.md` | `temp-holding/FASE 01/docs/gobernanza/seguridad/TASK-023-security_audit.md` | 49a5995a | 4,366 | 0 |
| `canonical/TIPOS_AVANZADOS.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/reglas_negocio/TIPOS_AVANZADOS.md` | 83066580 | 15,650 | 0 |
| `canonical/TPL_BR_Decision_Tipo_1_1_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_BR_Decision_Tipo_1_1_0.rst` | d13e39ea | 24,991 | 0 |
| `canonical/TPL_BR_Decision_Tipo_1_3_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_BR_Decision_Tipo_1_3_0.rst` | 3bcad517 | 56,132 | 0 |
| `canonical/TPL_BR_Decision_Tipo_1_3_1.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_BR_Decision_Tipo_1_3_1.rst` | 3bcad517 | 56,132 | 0 |
| `canonical/TPL_FR_Documentacion_10_Componentes_1_1_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_FR_Documentacion_10_Componentes_1_1_0.rst` | ee876b4b | 1,914 | 0 |
| `canonical/TPL_FR_Documentacion_10_Componentes_1_2_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_FR_Documentacion_10_Componentes_1_2_0.rst` | 4a6af0cf | 21,405 | 0 |
| `canonical/TPL_FR_Documentacion_10_Componentes_1_3_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_FR_Documentacion_10_Componentes_1_3_0.rst` | abfa5488 | 34,827 | 0 |
| `canonical/TPL_FR_Documentacion_10_Componentes_1_3_1.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_FR_Documentacion_10_Componentes_1_3_1.rst` | abfa5488 | 34,827 | 0 |
| `canonical/TPL_FR_Query_SQL_1_1_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_FR_Query_SQL_1_1_0.rst` | 1a2558c4 | 1,259 | 0 |
| `canonical/TPL_FR_Query_SQL_1_3_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_FR_Query_SQL_1_3_0.rst` | a790c31d | 23,520 | 0 |
| `canonical/TPL_FR_Query_SQL_1_3_1.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_FR_Query_SQL_1_3_1.rst` | a790c31d | 23,520 | 0 |
| `canonical/TPL_FR_Validacion_Reglas_1_1_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_FR_Validacion_Reglas_1_1_0.rst` | fdcc157f | 1,648 | 0 |
| `canonical/TPL_FR_Validacion_Reglas_1_3_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_FR_Validacion_Reglas_1_3_0.rst` | 2446300a | 30,883 | 0 |
| `canonical/TPL_FR_Validacion_Reglas_1_3_1.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_FR_Validacion_Reglas_1_3_1.rst` | 2446300a | 30,883 | 0 |
| `canonical/TPL_TRZ_Matriz_RTM_1_1_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_TRZ_Matriz_RTM_1_1_0.rst` | c6ec6e68 | 2,396 | 0 |
| `canonical/TPL_TRZ_Matriz_RTM_1_3_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_TRZ_Matriz_RTM_1_3_0.rst` | bd41a9a2 | 17,580 | 0 |
| `canonical/TPL_TRZ_Matriz_RTM_1_3_1.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_TRZ_Matriz_RTM_1_3_1.rst` | bd41a9a2 | 17,580 | 0 |
| `canonical/TPL_UC_Actor_Secundario_1_1_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Actor_Secundario_1_1_0.rst` | 7bbd5e97 | 1,104 | 0 |
| `canonical/TPL_UC_Actor_Secundario_1_2_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Actor_Secundario_1_2_0.rst` | fa0daa45 | 4,985 | 0 |
| `canonical/TPL_UC_Actor_Secundario_1_3_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Actor_Secundario_1_3_0.rst` | 4f9f5957 | 21,791 | 0 |
| `canonical/TPL_UC_Actor_Secundario_1_3_1.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Actor_Secundario_1_3_1.rst` | 4f9f5957 | 21,791 | 0 |
| `canonical/TPL_UC_CRUD_Operaciones_1_1_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_CRUD_Operaciones_1_1_0.rst` | 82d801ee | 1,303 | 0 |
| `canonical/TPL_UC_CRUD_Operaciones_1_2_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_CRUD_Operaciones_1_2_0.rst` | 2e57b8b4 | 35,312 | 0 |
| `canonical/TPL_UC_CRUD_Operaciones_1_2_1.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_CRUD_Operaciones_1_2_1.rst` | 2e57b8b4 | 35,312 | 0 |
| `canonical/TPL_UC_Construccion_7_Pasos_1_1_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Construccion_7_Pasos_1_1_0.rst` | 8186244c | 3,340 | 0 |
| `canonical/TPL_UC_Construccion_7_Pasos_1_2_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Construccion_7_Pasos_1_2_0.rst` | b4139fa7 | 17,830 | 0 |
| `canonical/TPL_UC_Construccion_7_Pasos_1_3_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Construccion_7_Pasos_1_3_0.rst` | 9d3033eb | 32,007 | 0 |
| `canonical/TPL_UC_Construccion_7_Pasos_1_3_1.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Construccion_7_Pasos_1_3_1.rst` | 9d3033eb | 32,007 | 0 |
| `canonical/TPL_UC_Larman_Contratos_1_1_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Larman_Contratos_1_1_0.rst` | e8c757ff | 928 | 0 |
| `canonical/TPL_UC_Larman_Contratos_1_2_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Larman_Contratos_1_2_0.rst` | 9f7cfe74 | 28,232 | 0 |
| `canonical/TPL_UC_Larman_Contratos_1_2_1.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Larman_Contratos_1_2_1.rst` | 9f7cfe74 | 28,232 | 0 |
| `canonical/TPL_UC_Stakeholder_Driven_1_1_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Stakeholder_Driven_1_1_0.rst` | ad9adf3e | 1,088 | 0 |
| `canonical/TPL_UC_Stakeholder_Driven_1_2_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Stakeholder_Driven_1_2_0.rst` | d8644251 | 5,369 | 0 |
| `canonical/TPL_UC_Stakeholder_Driven_1_3_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Stakeholder_Driven_1_3_0.rst` | c7c36c51 | 22,316 | 0 |
| `canonical/TPL_UC_Stakeholder_Driven_1_3_1.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Stakeholder_Driven_1_3_1.rst` | c7c36c51 | 22,316 | 0 |
| `canonical/TPL_UC_Temporal_Schedulers_1_1_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Temporal_Schedulers_1_1_0.rst` | 5593d4fe | 1,375 | 0 |
| `canonical/TPL_UC_Temporal_Schedulers_1_2_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Temporal_Schedulers_1_2_0.rst` | 5c23b63b | 9,442 | 0 |
| `canonical/TPL_UC_Temporal_Schedulers_1_3_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Temporal_Schedulers_1_3_0.rst` | ade365dc | 20,983 | 0 |
| `canonical/TPL_UC_Temporal_Schedulers_1_3_1.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_Temporal_Schedulers_1_3_1.rst` | ade365dc | 20,983 | 0 |
| `canonical/TPL_UC_UI_Driven_1_1_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_UI_Driven_1_1_0.rst` | 816d818e | 1,013 | 0 |
| `canonical/TPL_UC_UI_Driven_1_2_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_UI_Driven_1_2_0.rst` | fec4154b | 17,508 | 0 |
| `canonical/TPL_UC_UI_Driven_1_3_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_UI_Driven_1_3_0.rst` | ca208b17 | 25,847 | 0 |
| `canonical/TPL_UC_UI_Driven_1_3_1.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_UC_UI_Driven_1_3_1.rst` | ca208b17 | 25,847 | 0 |
| `canonical/UC-BACK-001-iniciar-sesion.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/ejemplos_test/UC-BACK-001-iniciar-sesion.md` | f906a19c | 1,559 | 0 |
| `canonical/UC-CALL-001_registrar_llamada_entrante.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-CALL-001_registrar_llamada_entrante.md` | b35fdce6 | 9,435 | 0 |
| `canonical/UC-CALL-002_atender_llamada.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-CALL-002_atender_llamada.md` | a74c8f16 | 7,179 | 0 |
| `canonical/UC-CALL-003_transferir_llamada.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-CALL-003_transferir_llamada.md` | 2befb6fa | 7,410 | 0 |
| `canonical/UC-CALL-004_generar_reporte_rendimiento.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-CALL-004_generar_reporte_rendimiento.md` | 96b58f0c | 8,106 | 0 |
| `canonical/UC-FRONT-001-ejemplo-sin-referencias.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/ejemplos_test/UC-FRONT-001-ejemplo-sin-referencias.md` | d1180fc1 | 277 | 0 |
| `canonical/UC-PERM-001_asignar_grupo_a_usuario.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-PERM-001_asignar_grupo_a_usuario.md` | e6ec01e5 | 11,268 | 0 |
| `canonical/UC-PERM-002_revocar_grupo_a_usuario.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-PERM-002_revocar_grupo_a_usuario.md` | 8fd177e3 | 9,609 | 0 |
| `canonical/UC-PERM-003_conceder_permiso_excepcional.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-PERM-003_conceder_permiso_excepcional.md` | e517e201 | 8,577 | 0 |
| `canonical/UC-PERM-004_revocar_permiso_excepcional.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-PERM-004_revocar_permiso_excepcional.md` | d2d6a39f | 4,260 | 0 |
| `canonical/UC-PERM-005_crear_grupo_permisos.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-PERM-005_crear_grupo_permisos.md` | 85dbcb5e | 3,227 | 0 |
| `canonical/UC-PERM-006_asignar_capacidades_grupo.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-PERM-006_asignar_capacidades_grupo.md` | 4a8cf7a9 | 1,902 | 0 |
| `canonical/UC-PERM-007_verificar_permiso_usuario.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-PERM-007_verificar_permiso_usuario.md` | d9e5edf2 | 2,767 | 0 |
| `canonical/UC-PERM-008_generar_menu_dinamico.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-PERM-008_generar_menu_dinamico.md` | 34c18a99 | 2,956 | 0 |
| `canonical/UC-PERM-009_auditar_acceso.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-PERM-009_auditar_acceso.md` | 12981dcc | 4,101 | 0 |
| `canonical/UC-PERM-010_consultar_auditoria.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-PERM-010_consultar_auditoria.md` | 3cfb8f6d | 6,610 | 0 |
| `canonical/UC-template-completo.md` | `temp-holding/FASE 01/docs/gobernanza/templates/UC-template-completo.md` | 31b4250a | 12,876 | 0 |
| `canonical/VALIDACION-TRAZABILIDAD-2025-01-17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/VALIDACION-TRAZABILIDAD-2025-01-17.md` | 48e0132c | 18,004 | 0 |
| `canonical/VERIFICACION_REAL_ESTADO_ARCHIVOS_2025_11_17.md` | `temp-holding/FASE 01/docs/gobernanza/qa/VERIFICACION_REAL_ESTADO_ARCHIVOS_2025_11_17.md` | 6c105f36 | 17,511 | 0 |
| `canonical/WORKFLOWS_COMPLETOS.md` | `temp-holding/FASE 01/docs/gobernanza/metodologias/WORKFLOWS_COMPLETOS.md` | 67d4b204 | 40,614 | 0 |
| `canonical/WORKFLOW_METRICAS_PROCESO.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/agentes/WORKFLOW_METRICAS_PROCESO.md` | 7f1d742d | 17,322 | 0 |
| `canonical/analisis-errores-adr-2025-11-16.md` | `temp-holding/FASE 01/docs/gobernanza/qa/analisis-errores-adr-2025-11-16.md` | 465206a1 | 24,361 | 0 |
| `canonical/analisis_completitud_reorganizacion.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/analisis_completitud_reorganizacion.md` | 1adf4d95 | 26,546 | 0 |
| `canonical/analisis_estructura_api.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc02/analisis_estructura_api.md` | d4030f7a | 20,078 | 0 |
| `canonical/analisis_fallas_docs.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/analisis_fallas_docs.md` | 3066fe2e | 10,603 | 0 |
| `canonical/analisis_funcion_real_apps.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc02/analisis_funcion_real_apps.md` | d3c1730e | 21,204 | 0 |
| `canonical/analisis_plantillas.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc02/analisis_plantillas.md` | bc356ac4 | 12,121 | 0 |
| `canonical/arquitectura_servicios_especializados.md` | `temp-holding/FASE 01/docs/gobernanza/metodologias/arquitectura_servicios_especializados.md` | 32b3ca43 | 35,023 | 0 |
| `canonical/auditoria_nombres_archivos.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/auditoria_nombres_archivos.md` | 4933e852 | 11,586 | 0 |
| `canonical/automatizacion_servicios.md` | `temp-holding/FASE 01/docs/gobernanza/metodologias/automatizacion_servicios.md` | 01dd8ff8 | 38,101 | 0 |
| `canonical/backup-commit-hash.txt` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-001-crear-backup-seguridad/evidencias/backup-commit-hash.txt` | 3be693a5 | 41 | 0 |
| `canonical/caso-practico-01-autenticacion-sesiones.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/casos_practicos/caso-practico-01-autenticacion-sesiones.md` | 69582a76 | 16,532 | 0 |
| `canonical/caso-practico-02-evaluacion-permisos.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/casos_practicos/caso-practico-02-evaluacion-permisos.md` | 7306bf9d | 13,359 | 0 |
| `canonical/caso-practico-03-auditoria-seguridad.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/casos_practicos/caso-practico-03-auditoria-seguridad.md` | 8637c6f9 | 13,947 | 0 |
| `canonical/casos_de_uso_guide.md` | `temp-holding/FASE 01/docs/gobernanza/casos_de_uso_guide.md` | 6ae384ff | 21,447 | 0 |
| `canonical/catalogo_todos_pendientes.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/catalogo_todos_pendientes.md` | 06873ffd | 71,895 | 0 |
| `canonical/check_no_emojis.md` | `temp-holding/FASE 01/docs/gobernanza/guias/scripts/check_no_emojis.md` | dd64ac2c | 7,187 | 0 |
| `canonical/checklist_cambios_documentales.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/checklists/checklist_cambios_documentales.md` | de3f7519 | 405 | 0 |
| `canonical/checklist_control_flujo.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc00/sc00_documents/checklist_control_flujo.md` | a152c164 | 2,612 | 0 |
| `canonical/checklist_desarrollo.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/checklists/checklist_desarrollo.md` | 52eb67c7 | 974 | 0 |
| `canonical/checklist_testing.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/checklists/checklist_testing.md` | ea76e579 | 385 | 0 |
| `canonical/checklist_trazabilidad_requisitos.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/checklists/checklist_trazabilidad_requisitos.md` | 88017cd7 | 547 | 0 |
| `canonical/claude_code.md` | `temp-holding/FASE 01/docs/gobernanza/claude_code.md` | f3453bc2 | 14,348 | 0 |
| `canonical/constitucion.yaml` | `temp-holding/FASE 01/docs/gobernanza/constitucion.yaml` | 3b45969e | 5,709 | 0 |
| `canonical/constitution.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/agentes/constitution.md` | 4093101b | 16,409 | 0 |
| `canonical/decisiones-remediation-adr-2025-11-16.md` | `temp-holding/FASE 01/docs/gobernanza/qa/decisiones-remediation-adr-2025-11-16.md` | 75c051ca | 3,176 | 0 |
| `canonical/decisions.md` | `temp-holding/project/decisions.md` | b24c4c32 | 176 | 0 |
| `canonical/deployment_001.md` | `temp-holding/FASE 01/docs/gobernanza/guias/deployment/deployment_001.md` | a91d1466 | 3,447 | 0 |
| `canonical/deployment_002.md` | `temp-holding/FASE 01/docs/gobernanza/guias/deployment/deployment_002.md` | 80283ff4 | 2,846 | 0 |
| `canonical/deployment_003_implementacion_permisos_granular.md` | `temp-holding/FASE 01/docs/gobernanza/guias/deployment/deployment_003_implementacion_permisos_granular.md` | ba83a243 | 27,240 | 0 |
| `canonical/deployment_004_tdd_backend_permisos_granular.md` | `temp-holding/FASE 01/docs/gobernanza/guias/deployment/deployment_004_tdd_backend_permisos_granular.md` | 7452e8b4 | 29,488 | 0 |
| `canonical/deployment_005_tdd_frontend_permisos_granular.md` | `temp-holding/FASE 01/docs/gobernanza/guias/deployment/deployment_005_tdd_frontend_permisos_granular.md` | aa9887dc | 26,192 | 0 |
| `canonical/documentacion_corporativa.md` | `temp-holding/FASE 01/docs/gobernanza/documentacion_corporativa.md` | 3be48e4b | 22,872 | 0 |
| `canonical/error-report.txt` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/evidencias/TASK-001/error-report.txt` | 87d6bd26 | 1,328 | 0 |
| `canonical/estandares_codigo.md` | `temp-holding/FASE 01/docs/gobernanza/estandares_codigo.md` | 2e78712f | 13,728 | 0 |
| `canonical/estrategia_qa.md` | `temp-holding/FASE 01/docs/gobernanza/qa/estrategia_qa.md` | 4315a078 | 1,639 | 0 |
| `canonical/faq.md` | `temp-holding/FASE 01/docs/gobernanza/faq.md` | 0d0f5931 | 263 | 0 |
| `canonical/generate_guides.md` | `temp-holding/FASE 01/docs/gobernanza/guias/scripts/generate_guides.md` | c6162ecf | 13,201 | 0 |
| `canonical/github_copilot_codespaces.md` | `temp-holding/FASE 01/docs/gobernanza/github_copilot_codespaces.md` | 7107a3ea | 9,537 | 0 |
| `canonical/guia-uso-plantillas.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/plantillas/guia-uso-plantillas.md` | b34bd1ba | 8,958 | 0 |
| `canonical/guia_documentacion_integrada.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc00/sc00_documents/guia_documentacion_integrada.md` | ba2e8f0c | 4,400 | 0 |
| `canonical/guia_estructura_qa.md` | `temp-holding/FASE 01/docs/gobernanza/qa/guia_estructura_qa.md` | d7d72999 | 8,235 | 0 |
| `canonical/guia_preparacion_archivos.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc00/guia_preparacion_archivos.md` | 9136e79d | 2,802 | 0 |
| `canonical/guia_template.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/guia_template.md` | cd81764d | 1,870 | 0 |
| `canonical/lineamientos_gobernanza.md` | `temp-holding/FASE 01/docs/gobernanza/lineamientos_gobernanza.md` | e8eeb2f8 | 358 | 0 |
| `canonical/marco_casos_uso.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/marco_casos_uso.md` | c4f20ad2 | 15,473 | 0 |
| `canonical/marco_reglas_negocio.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/marco_reglas_negocio.md` | 7cc98cac | 10,909 | 0 |
| `canonical/matriz_trazabilidad_rtm.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/matriz_trazabilidad_rtm.md` | 47a6587f | 7,504 | 0 |
| `canonical/merge_y_limpieza_ramas.md` | `temp-holding/FASE 01/docs/gobernanza/merge_y_limpieza_ramas.md` | 3c81c664 | 10,050 | 0 |
| `canonical/onboarding_001.md` | `temp-holding/FASE 01/docs/gobernanza/guias/onboarding/onboarding_001.md` | 979f0f6e | 3,735 | 0 |
| `canonical/onboarding_002.md` | `temp-holding/FASE 01/docs/gobernanza/guias/onboarding/onboarding_002.md` | fc0fbce2 | 3,653 | 0 |
| `canonical/onboarding_003.md` | `temp-holding/FASE 01/docs/gobernanza/guias/onboarding/onboarding_003.md` | f8ebe01c | 2,897 | 0 |
| `canonical/onboarding_004.md` | `temp-holding/FASE 01/docs/gobernanza/guias/onboarding/onboarding_004.md` | 210f7367 | 2,821 | 0 |
| `canonical/onboarding_005.md` | `temp-holding/FASE 01/docs/gobernanza/guias/onboarding/onboarding_005.md` | 39c4f164 | 3,193 | 0 |
| `canonical/onboarding_006.md` | `temp-holding/FASE 01/docs/gobernanza/guias/onboarding/onboarding_006.md` | 294f20e6 | 2,657 | 0 |
| `canonical/onboarding_007.md` | `temp-holding/FASE 01/docs/gobernanza/guias/onboarding/onboarding_007.md` | cb80ce11 | 2,651 | 0 |
| `canonical/onboarding_008_atencion_cliente.md` | `temp-holding/FASE 01/docs/gobernanza/guias/onboarding/onboarding_008_atencion_cliente.md` | 026aec96 | 14,052 | 0 |
| `canonical/plan_general.md` | `temp-holding/FASE 01/docs/gobernanza/plan_general.md` | 8c3afb05 | 7,333 | 0 |
| `canonical/plantilla-01-documento-maestro-analisis.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/plantillas/plantilla-01-documento-maestro-analisis.md` | f232642f | 11,187 | 0 |
| `canonical/plantilla-02-matriz-trazabilidad-rtm.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/plantillas/plantilla-02-matriz-trazabilidad-rtm.md` | 40d617f0 | 5,702 | 0 |
| `canonical/plantilla-03-checklist-completitud.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/plantillas/plantilla-03-checklist-completitud.md` | 9eb2d4bb | 11,887 | 0 |
| `canonical/plantilla-04-regla-negocio.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/plantillas/plantilla-04-regla-negocio.md` | c5491ab9 | 3,003 | 0 |
| `canonical/plantilla_adr.md` | `temp-holding/FASE 01/docs/gobernanza/plantilla_adr.md` | 4c1f3bec | 4,685 | 0 |
| `canonical/plantilla_api_reference.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_api_reference.md` | c6e60261 | 384 | 0 |
| `canonical/plantilla_business_case.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_business_case.md` | daba7eec | 444 | 0 |
| `canonical/plantilla_caso_de_uso.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_caso_de_uso.md` | 0dad4eae | 544 | 0 |
| `canonical/plantilla_caso_prueba.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_caso_prueba.md` | dd74bd46 | 364 | 0 |
| `canonical/plantilla_database_design.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_database_design.md` | 0dd3b09e | 452 | 0 |
| `canonical/plantilla_deployment_guide.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_deployment_guide.md` | 411f7bbe | 320 | 0 |
| `canonical/plantilla_django_app.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_django_app.md` | 61c86dfa | 19,397 | 0 |
| `canonical/plantilla_etl_job.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_etl_job.md` | 28cbe632 | 25,587 | 0 |
| `canonical/plantilla_manual_usuario.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_manual_usuario.md` | f4d7e848 | 348 | 0 |
| `canonical/plantilla_plan.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/desarrollo/plantilla_plan.md` | dbc7b759 | 21,807 | 0 |
| `canonical/plantilla_plan_pruebas.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_plan_pruebas.md` | f5fe74c1 | 324 | 0 |
| `canonical/plantilla_project_charter.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_project_charter.md` | c0818d93 | 454 | 0 |
| `canonical/plantilla_project_management_plan.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_project_management_plan.md` | 16940940 | 501 | 0 |
| `canonical/plantilla_registro_actividad.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_registro_actividad.md` | b1309a25 | 2,058 | 0 |
| `canonical/plantilla_regla_negocio.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_regla_negocio.md` | 63a8b692 | 412 | 0 |
| `canonical/plantilla_release_plan.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_release_plan.md` | ca795261 | 263 | 0 |
| `canonical/plantilla_runbook.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_runbook.md` | a105b7ca | 381 | 0 |
| `canonical/plantilla_sad.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_sad.md` | d1fcc60d | 546 | 0 |
| `canonical/plantilla_seccion_limitaciones.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_seccion_limitaciones.md` | 27460d53 | 289 | 0 |
| `canonical/plantilla_setup_entorno.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_setup_entorno.md` | 09c6f406 | 325 | 0 |
| `canonical/plantilla_setup_qa.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_setup_qa.md` | 79178fac | 282 | 0 |
| `canonical/plantilla_spec.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/desarrollo/plantilla_spec.md` | 0a63dc63 | 11,243 | 0 |
| `canonical/plantilla_srs.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_srs.md` | d639bf91 | 720 | 0 |
| `canonical/plantilla_stakeholder_analysis.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_stakeholder_analysis.md` | 16eccd2e | 299 | 0 |
| `canonical/plantilla_tdd.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_tdd.md` | 104a292c | 525 | 0 |
| `canonical/plantilla_troubleshooting.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_troubleshooting.md` | b806d793 | 453 | 0 |
| `canonical/plantilla_ui_ux.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_ui_ux.md` | 6e688d1e | 373 | 0 |
| `canonical/post_create.md` | `temp-holding/FASE 01/docs/gobernanza/post_create.md` | be5df50f | 8,026 | 0 |
| `canonical/registro_decisiones.md` | `temp-holding/FASE 01/docs/gobernanza/registro_decisiones.md` | a115f8ab | 1,805 | 0 |
| `canonical/reglas_restricciones_detalle.md` | `temp-holding/FASE 01/docs/gobernanza/reglas_restricciones_detalle.md` | ead7757c | 188,809 | 0 |
| `canonical/reporte_final_fases_1_2.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/reporte_final_fases_1_2.md` | 1c1ffcfb | 22,074 | 0 |
| `canonical/reporte_reorganizacion.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/reporte_reorganizacion.md` | 3abf001c | 2,280 | 0 |
| `canonical/reporte_reorganizacion_final.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/reporte_reorganizacion_final.md` | 8419b9f7 | 15,831 | 0 |
| `canonical/reporte_validacion_completa.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/reporte_validacion_completa.md` | 99e97d9d | 24,160 | 0 |
| `canonical/reprocesar_etl_fallido.md` | `temp-holding/FASE 01/docs/gobernanza/reprocesar_etl_fallido.md` | 570436ab | 10,101 | 0 |
| `canonical/resumen-casos-practicos.md` | `temp-holding/FASE 01/docs/gobernanza/marco_integrado/casos_practicos/resumen-casos-practicos.md` | 6b3a60a4 | 7,696 | 0 |
| `canonical/resumen_artefactos_reglas_restricciones.md` | `temp-holding/FASE 01/docs/gobernanza/resumen_artefactos_reglas_restricciones.md` | 15db59eb | 33,917 | 0 |
| `canonical/resumen_ejecutivo_fases_1_2_3.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/resumen_ejecutivo_fases_1_2_3.md` | 03f4e824 | 7,200 | 0 |
| `canonical/resumen_remediacion_critica_docs.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/resumen_remediacion_critica_docs.md` | 8f2825de | 9,178 | 0 |
| `canonical/rev_20251112_remediation_plan.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/rev_20251112_remediation_plan.md` | ce0ac953 | 4,757 | 0 |
| `canonical/revision_20251112_consolidada.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/revision_20251112_consolidada.md` | ca3c54b2 | 5,829 | 0 |
| `canonical/sc00_integrar_marco_analisis.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc00/sc00_documents/sc00_integrar_marco_analisis.md` | f2202eab | 3,750 | 0 |
| `canonical/scripts_validacion.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/scripts_validacion.md` | ce6b6e4e | 6,567 | 0 |
| `canonical/shell_scripting_guide.md` | `temp-holding/FASE 01/docs/gobernanza/shell_scripting_guide.md` | 884a00f0 | 23,977 | 0 |
| `canonical/srs_software_requirements.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_funcionales/srs_software_requirements.md` | 4e797e3d | 7,196 | 0 |
| `canonical/tdd_refactor_resumen.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/tdd_refactor_resumen.md` | 4fe0edcc | 8,042 | 0 |
| `canonical/template_necesidad.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/template_necesidad.md` | 5dadcccf | 8,143 | 0 |
| `canonical/template_requisito_funcional.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/template_requisito_funcional.md` | 4298337a | 13,378 | 0 |
| `canonical/template_requisito_negocio.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/template_requisito_negocio.md` | 9ba4947c | 15,418 | 0 |
| `canonical/template_requisito_no_funcional.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/template_requisito_no_funcional.md` | cfc82df8 | 3,569 | 0 |
| `canonical/template_requisito_stakeholder.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/template_requisito_stakeholder.md` | 40562ac3 | 17,187 | 0 |
| `canonical/test_diagrams.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc01/test_diagrams.md` | 4c2ee0e4 | 4,874 | 0 |
| `canonical/test_documentation_alignment.py` | `temp-holding/FASE 01/docs/gobernanza/qa/testing/test_documentation_alignment.py` | 79085849 | 14,836 | 0 |
| `canonical/testing_001.md` | `temp-holding/FASE 01/docs/gobernanza/guias/testing/testing_001.md` | 67a94557 | 3,053 | 0 |
| `canonical/testing_002.md` | `temp-holding/FASE 01/docs/gobernanza/guias/testing/testing_002.md` | aab39d25 | 2,582 | 0 |
| `canonical/testing_003.md` | `temp-holding/FASE 01/docs/gobernanza/guias/testing/testing_003.md` | e3efdfa6 | 2,650 | 0 |
| `canonical/troubleshooting_001.md` | `temp-holding/FASE 01/docs/gobernanza/guias/troubleshooting/troubleshooting_001.md` | 0a00d4c2 | 4,366 | 0 |
| `canonical/validacion_2025_11_04.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc01/validacion_2025_11_04.md` | a1dc2020 | 6,822 | 0 |
| `canonical/validacion_conformidad_gobernanza.md` | `temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/validacion_conformidad_gobernanza.md` | 8f88fd9f | 19,715 | 0 |
| `canonical/validate_critical_restrictions.md` | `temp-holding/FASE 01/docs/gobernanza/guias/scripts/validate_critical_restrictions.md` | 5b929071 | 12,286 | 0 |
| `canonical/ver_documentacion.sh` | `temp-holding/FASE 01/docs/gobernanza/guias/scripts/ver_documentacion.sh` | 22ca9e92 | 6,817 | 0 |
| `canonical/verificar_servicios.md` | `temp-holding/FASE 01/docs/gobernanza/verificar_servicios.md` | ba8993e5 | 8,213 | 0 |
| `canonical/vision_y_alcance.md` | `temp-holding/FASE 01/docs/gobernanza/vision_y_alcance.md` | 0cc0e3a7 | 2,603 | 0 |
| `canonical/workflow_admin_users_and_groups.md` | `temp-holding/FASE 01/docs/gobernanza/guias/workflows/workflow_admin_users_and_groups.md` | 7d929038 | 11,032 | 0 |
| `canonical/workflow_create_feature_branch.md` | `temp-holding/FASE 01/docs/gobernanza/guias/workflows/workflow_create_feature_branch.md` | b52cdf20 | 2,548 | 0 |
| `canonical/workflow_create_pull_request.md` | `temp-holding/FASE 01/docs/gobernanza/guias/workflows/workflow_create_pull_request.md` | e1775c5b | 3,230 | 0 |
| `canonical/workflow_implement_feature_with_tdd.md` | `temp-holding/FASE 01/docs/gobernanza/guias/workflows/workflow_implement_feature_with_tdd.md` | 4f6a2c11 | 16,009 | 0 |
| `canonical/workflow_interpret_ci_cd_results.md` | `temp-holding/FASE 01/docs/gobernanza/guias/workflows/workflow_interpret_ci_cd_results.md` | 2a18bf01 | 3,193 | 0 |
| `canonical/workflow_make_conventional_commits.md` | `temp-holding/FASE 01/docs/gobernanza/guias/workflows/workflow_make_conventional_commits.md` | 1c234ed1 | 2,832 | 0 |
| `canonical/workflow_manage_teams_as_coordinator.md` | `temp-holding/FASE 01/docs/gobernanza/guias/workflows/workflow_manage_teams_as_coordinator.md` | 6d5ca792 | 12,556 | 0 |

## Variantes

| Destino | Origen | Hash | Bytes |
|---------|--------|------|-------|
| `variants/temp-backup/source-2026-04-28/normativa/gobernanza/index.rst` | `temp-backup/source-2026-04-28/normativa/gobernanza/index.rst` | 9a9fb82b | 5,540 |
| `variants/temp-backup/source-2026-04-28/normativa/index.rst` | `temp-backup/source-2026-04-28/normativa/index.rst` | 404a32a9 | 1,041 |
| `variants/temp-holding/FASE 01/docs/gobernanza/README.md` | `temp-holding/FASE 01/docs/gobernanza/README.md` | 9ff5f9bf | 6,569 |
| `variants/temp-holding/FASE 01/docs/gobernanza/glossary.md` | `temp-holding/FASE 01/docs/gobernanza/glossary.md` | bb4499f7 | 1,424 |
| `variants/temp-holding/FASE 01/docs/gobernanza/guias/README.md` | `temp-holding/FASE 01/docs/gobernanza/guias/README.md` | 3181400f | 10,074 |
| `variants/temp-holding/FASE 01/docs/gobernanza/metodologias/README.md` | `temp-holding/FASE 01/docs/gobernanza/metodologias/README.md` | a6f79137 | 3,913 |
| `variants/temp-holding/FASE 01/docs/gobernanza/plantilla_espacio_documental.md` | `temp-holding/FASE 01/docs/gobernanza/plantilla_espacio_documental.md` | 4f4325f1 | 3,350 |
| `variants/temp-holding/FASE 01/docs/gobernanza/plantillas/README.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/README.md` | 34fb7f28 | 7,463 |
| `variants/temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_espacio_documental.md` | `temp-holding/FASE 01/docs/gobernanza/plantillas/plantilla_espacio_documental.md` | 72a952ed | 3,333 |
| `variants/temp-holding/FASE 01/docs/gobernanza/procesos/README.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/README.md` | 57c2942b | 15,705 |
| `variants/temp-holding/FASE 01/docs/gobernanza/procesos/agentes/README.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/agentes/README.md` | 9b990932 | 14,019 |
| `variants/temp-holding/FASE 01/docs/gobernanza/procesos/checklists/README.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/checklists/README.md` | eddaaf6a | 10,241 |
| `variants/temp-holding/FASE 01/docs/gobernanza/procesos/checklists/checklist_auditoria_restricciones.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/checklists/checklist_auditoria_restricciones.md` | 5bd6c62e | 23,820 |
| `variants/temp-holding/FASE 01/docs/gobernanza/procesos/qa/README.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/qa/README.md` | b956ac18 | 2,026 |
| `variants/temp-holding/FASE 01/docs/gobernanza/procesos/qa/actividades_garantia_documental.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/qa/actividades_garantia_documental.md` | 8c13c0c6 | 3,423 |
| `variants/temp-holding/FASE 01/docs/gobernanza/procesos/qa/checklist_auditoria_restricciones.md` | `temp-holding/FASE 01/docs/gobernanza/procesos/qa/checklist_auditoria_restricciones.md` | 5bd6c62e | 23,820 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-ESTRUCTURA-003/INDICE.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-ESTRUCTURA-003/INDICE.md` | 0b8cb3b7 | 7,003 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001.md` | 8f532d35 | 1,246 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/INDICE.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/INDICE.md` | c139b80d | 8,967 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/QA-ANALISIS-RAMAS-001.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/QA-ANALISIS-RAMAS-001.md` | 9beb4d58 | 3,254 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-001-crear-backup-seguridad/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-001-crear-backup-seguridad/README.md` | 6d5b1cd6 | 4,390 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-002-verificar-estado-limpio/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-002-verificar-estado-limpio/README.md` | 49b06fa9 | 3,539 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-002-verificar-estado-limpio/evidencias/evidencia-ejecucion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-002-verificar-estado-limpio/evidencias/evidencia-ejecucion.md` | 88ff8800 | 2,420 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-003-validar-rama-base/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-003-validar-rama-base/README.md` | 93b00a16 | 3,745 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-003-validar-rama-base/evidencias/evidencia-ejecucion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-003-validar-rama-base/evidencias/evidencia-ejecucion.md` | ac5e11ff | 4,474 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-004-integrar-mcp-registry/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-004-integrar-mcp-registry/README.md` | c4133ca0 | 7,051 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-004-integrar-mcp-registry/evidencias/evidencia-ejecucion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-004-integrar-mcp-registry/evidencias/evidencia-ejecucion.md` | 2e229a37 | 5,016 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-005-validar-estructura-mcp/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-005-validar-estructura-mcp/README.md` | c80622c4 | 5,571 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-005-validar-estructura-mcp/evidencias/evidencia-ejecucion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-005-validar-estructura-mcp/evidencias/evidencia-ejecucion.md` | a5a03ccb | 9,075 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-006-integrar-validaciones-api-callcentersite/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-006-integrar-validaciones-api-callcentersite/README.md` | d82df31f | 8,494 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-006-integrar-validaciones-api-callcentersite/evidencias/evidencia-ejecucion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-006-integrar-validaciones-api-callcentersite/evidencias/evidencia-ejecucion.md` | 7347df42 | 2,809 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-007-comparar-integrar-agentes-copilot/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-007-comparar-integrar-agentes-copilot/README.md` | f0c9f1f9 | 9,973 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-007-comparar-integrar-agentes-copilot/evidencias/evidencia-ejecucion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-007-comparar-integrar-agentes-copilot/evidencias/evidencia-ejecucion.md` | ae39706b | 7,039 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-008-integrar-mejoras-devcontainer/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-008-integrar-mejoras-devcontainer/README.md` | 290433d6 | 6,223 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-008-integrar-mejoras-devcontainer/evidencias/evidencia-ejecucion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-008-integrar-mejoras-devcontainer/evidencias/evidencia-ejecucion.md` | 8513fded | 1,148 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-009-integrar-reporte-integracion/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-009-integrar-reporte-integracion/README.md` | ae3bf252 | 7,551 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-009-integrar-reporte-integracion/evidencias/evidencia-ejecucion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-009-integrar-reporte-integracion/evidencias/evidencia-ejecucion.md` | a607456a | 1,319 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-010-eliminar-ramas-completamente-integradas/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-010-eliminar-ramas-completamente-integradas/README.md` | 048210c7 | 8,417 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-010-eliminar-ramas-completamente-integradas/evidencias/evidencia-ejecucion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-010-eliminar-ramas-completamente-integradas/evidencias/evidencia-ejecucion.md` | 9c81b200 | 4,237 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-011-eliminar-ramas-mcp-redundantes/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-011-eliminar-ramas-mcp-redundantes/README.md` | 06d0b6f9 | 10,567 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-011-eliminar-ramas-mcp-redundantes/evidencias/evidencia-ejecucion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-011-eliminar-ramas-mcp-redundantes/evidencias/evidencia-ejecucion.md` | 6a76a01a | 4,014 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-012-evaluar-rama-backup-final/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-012-evaluar-rama-backup-final/README.md` | c71431c5 | 8,739 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-012-evaluar-rama-backup-final/evidencias/evidencia-ejecucion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-012-evaluar-rama-backup-final/evidencias/evidencia-ejecucion.md` | 42c5d2ae | 2,684 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-013-eliminar-integration-analysis/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-013-eliminar-integration-analysis/README.md` | 00f28062 | 7,181 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-013-eliminar-integration-analysis/evidencias/evidencia-ejecucion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-013-eliminar-integration-analysis/evidencias/evidencia-ejecucion.md` | 5147f233 | 2,060 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-014-sincronizar-develop/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-014-sincronizar-develop/README.md` | 4d73edfe | 16,728 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-014-sincronizar-develop/evidencias/evidencia-ejecucion.md` | `temp-holding/FASE 01/docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-014-sincronizar-develop/evidencias/evidencia-ejecucion.md` | 5aabaf81 | 6,068 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/README.md` | `temp-holding/FASE 01/docs/gobernanza/qa/README.md` | e7724a5d | 2,060 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/actividades_garantia_documental.md` | `temp-holding/FASE 01/docs/gobernanza/qa/actividades_garantia_documental.md` | 8d335e99 | 3,406 |
| `variants/temp-holding/FASE 01/docs/gobernanza/qa/checklist_auditoria_restricciones.md` | `temp-holding/FASE 01/docs/gobernanza/qa/checklist_auditoria_restricciones.md` | 92726fe4 | 23,803 |
| `variants/temp-holding/FASE 01/docs/gobernanza/referencias/README.md` | `temp-holding/FASE 01/docs/gobernanza/referencias/README.md` | d6041dda | 7,605 |
| `variants/temp-holding/FASE 01/docs/gobernanza/requisitos/README.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/README.md` | 50b0b5bc | 5,883 |
| `variants/temp-holding/FASE 01/docs/gobernanza/requisitos/brs_business_requirements.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/brs_business_requirements.md` | 797f48e3 | 908 |
| `variants/temp-holding/FASE 01/docs/gobernanza/requisitos/reglas_negocio/README.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/reglas_negocio/README.md` | 1426332f | 4,533 |
| `variants/temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_negocio/brs_business_requirements.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/requerimientos_negocio/brs_business_requirements.md` | 7ff3d8df | 925 |
| `variants/temp-holding/FASE 01/docs/gobernanza/requisitos/stakeholders/strs_stakeholder_requirements.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/stakeholders/strs_stakeholder_requirements.md` | 392c13c8 | 1,619 |
| `variants/temp-holding/FASE 01/docs/gobernanza/requisitos/strs_stakeholder_requirements.md` | `temp-holding/FASE 01/docs/gobernanza/requisitos/strs_stakeholder_requirements.md` | a7cfab56 | 1,602 |
| `variants/temp-holding/FASE 01/docs/gobernanza/solicitudes/README.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/README.md` | 1c9f44c1 | 2,268 |
| `variants/temp-holding/FASE 01/docs/gobernanza/solicitudes/sc00/README.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc00/README.md` | 3a9271e3 | 3,259 |
| `variants/temp-holding/FASE 01/docs/gobernanza/solicitudes/sc00/meeting_and_discussion_notes/README.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc00/meeting_and_discussion_notes/README.md` | bebeb61a | 1,334 |
| `variants/temp-holding/FASE 01/docs/gobernanza/solicitudes/sc00/sc00_documents/README.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc00/sc00_documents/README.md` | 3fba16bc | 1,610 |
| `variants/temp-holding/FASE 01/docs/gobernanza/solicitudes/sc00/sc00_task_report/README.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc00/sc00_task_report/README.md` | 33ea254d | 1,405 |
| `variants/temp-holding/FASE 01/docs/gobernanza/solicitudes/sc01/README.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc01/README.md` | d3aaf8bd | 6,364 |
| `variants/temp-holding/FASE 01/docs/gobernanza/solicitudes/sc02/README.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc02/README.md` | 0ffda69a | 6,709 |
| `variants/temp-holding/FASE 01/docs/gobernanza/solicitudes/sc02/alcance.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc02/alcance.md` | 07ea3b62 | 8,753 |
| `variants/temp-holding/FASE 01/docs/gobernanza/solicitudes/sc02/checklist.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc02/checklist.md` | 9e9095df | 9,883 |
| `variants/temp-holding/FASE 01/docs/gobernanza/solicitudes/sc02/entregables/README.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc02/entregables/README.md` | df99ca72 | 2,884 |
| `variants/temp-holding/FASE 01/docs/gobernanza/solicitudes/sc03/README.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc03/README.md` | bc33d2c5 | 5,923 |
| `variants/temp-holding/FASE 01/docs/gobernanza/solicitudes/sc03/alcance.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc03/alcance.md` | 4807f8c5 | 8,647 |
| `variants/temp-holding/FASE 01/docs/gobernanza/solicitudes/sc03/checklist.md` | `temp-holding/FASE 01/docs/gobernanza/solicitudes/sc03/checklist.md` | 08571e87 | 11,175 |
| `variants/temp-holding/FASE 01/docs/gobernanza/templates/README.md` | `temp-holding/FASE 01/docs/gobernanza/templates/README.md` | 08583509 | 21,642 |
| `variants/temp-holding/FASE 01/docs/gobernanza/vision_y_alcance/README.md` | `temp-holding/FASE 01/docs/gobernanza/vision_y_alcance/README.md` | 0cc0e3a7 | 2,603 |
| `variants/temp-holding/FASE 01/docs/gobernanza/vision_y_alcance/glossary.md` | `temp-holding/FASE 01/docs/gobernanza/vision_y_alcance/glossary.md` | 246621eb | 1,407 |
| `variants/temp-holding/FASE 02/base_cognitiva/normativa/templates/README.md` | `temp-holding/FASE 02/base_cognitiva/normativa/templates/README.md` | 43a1f251 | 10,504 |

