```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-42-source-rebuild-normativa-procedimientos
phase: Phase 1 — DISCOVER (input staging)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Inventory — WP normativa-procedimientos

Documentos pre-staged desde `temp-backup/` y `temp-holding/`. Solo estos archivos deben consultarse para el analisis de este WP — evita buscar en todo `temp-*`.

## Convencion

- `canonical/` — un solo archivo por concepto (MD5 deduplicado, preferencia: temp-backup > FASE 02 > FASE 01).
- `variants/` — archivos con mismo nombre pero contenido distinto, ruta espejo del origen para desambiguar.

## Resumen

- Canonicos: **82**
- Variantes: **0**
- Duplicados colapsados: **0**

- Tamano total stage: 994,294 bytes (971.0 KB)

## Canonicos

| Destino | Origen elegido | Hash | Bytes | Dups colapsados |
|---------|---------------|------|-------|----------------|
| `canonical/ANALISIS_PROCEDIMIENTOS_PENDIENTES_v2.md` | `temp-holding/FASE 01/PROC_Procedimientos/ANALISIS_PROCEDIMIENTOS_PENDIENTES_v2.md` | 8ec07e8d | 10,751 | 0 |
| `canonical/ANALISIS_PROC_COMPLETO_1_0_0.md` | `temp-holding/FASE 01/PROC_Procedimientos/ANALISIS_PROC_COMPLETO_1_0_0.md` | 9cedbe56 | 11,518 | 0 |
| `canonical/ANALISIS_PROC_COMPLETO_v2.md` | `temp-holding/FASE 01/PROC_Procedimientos/ANALISIS_PROC_COMPLETO_v2.md` | 48d5e7b9 | 15,065 | 0 |
| `canonical/Catálogo Completo de 38 PROC.txt` | `temp-holding/FASE 01/PROC_Procedimientos/Catálogo Completo de 38 PROC.txt` | 3f039581 | 1,978 | 0 |
| `canonical/Deployment del Backend IACT- README.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/Deployment del Backend IACT- README.rst` | ffacec0b | 731 | 0 |
| `canonical/GAPS-CRITICOS-SOLUCIONADOS-PROCED-GOB-009.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/GAPS-CRITICOS-SOLUCIONADOS-PROCED-GOB-009.rst` | 1fa69eae | 16,069 | 0 |
| `canonical/PROC-001-gobernanza_sdlc.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC-001-gobernanza_sdlc.rst` | c9c84de2 | 20,800 | 0 |
| `canonical/PROC-DEV-001-pipeline_trabajo_iact.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC-DEV-001-pipeline_trabajo_iact.rst` | 12d912f7 | 20,074 | 0 |
| `canonical/PROC-DEV-002-sdlc_process.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC-DEV-002-sdlc_process.rst` | 6c567038 | 26,900 | 0 |
| `canonical/PROC-DEVOPS-001-devops_automation.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC-DEVOPS-001-devops_automation.rst` | 9fcf56a4 | 16,189 | 0 |
| `canonical/PROC-GOB-001-mapeo_procesos_templates.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC-GOB-001-mapeo_procesos_templates.rst` | 4e9b997e | 45,751 | 0 |
| `canonical/PROC-GOB-008-reorganizacion-estructura-documental.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC-GOB-008-reorganizacion-estructura-documental.rst` | aa2db996 | 25,337 | 0 |
| `canonical/PROC-OPS-001-deployment.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC-OPS-001-deployment.rst` | 1b662928 | 6,559 | 0 |
| `canonical/PROC-OPS-002-setup-entorno-desarrollo.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC-OPS-002-setup-entorno-desarrollo.rst` | 90251318 | 9,812 | 0 |
| `canonical/PROC-QA-001-actividades_garantia_documental.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC-QA-001-actividades_garantia_documental.rst` | e413a70c | 6,098 | 0 |
| `canonical/PROC-QA-002-estrategia_qa.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC-QA-002-estrategia_qa.rst` | 044eeee9 | 2,419 | 0 |
| `canonical/PROCED-DEV-001-crear_pull_request.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-DEV-001-crear_pull_request.rst` | ddbeea52 | 8,206 | 0 |
| `canonical/PROCED-DEV-002-code_review.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-DEV-002-code_review.rst` | 86efa1ef | 12,939 | 0 |
| `canonical/PROCED-DEV-003-resolver_conflictos_merge.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-DEV-003-resolver_conflictos_merge.rst` | e7eb0146 | 15,565 | 0 |
| `canonical/PROCED-DEVOPS-001-deploy_staging.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-DEVOPS-001-deploy_staging.rst` | 77508887 | 11,862 | 0 |
| `canonical/PROCED-GOB-001-crear_adr.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-GOB-001-crear_adr.rst` | e3838211 | 18,869 | 0 |
| `canonical/PROCED-GOB-002-actualizar_documentacion.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-GOB-002-actualizar_documentacion.rst` | 14e3f19f | 16,119 | 0 |
| `canonical/PROCED-GOB-003-documentar-regla-negocio.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-GOB-003-documentar-regla-negocio.rst` | cf795d1f | 26,265 | 0 |
| `canonical/PROCED-GOB-004-crear-caso-uso.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-GOB-004-crear-caso-uso.rst` | 4b06fb79 | 40,178 | 0 |
| `canonical/PROCED-GOB-005-analisis-impacto-cambios.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-GOB-005-analisis-impacto-cambios.rst` | 59f26eb6 | 40,293 | 0 |
| `canonical/PROCED-GOB-006-generar-diagrama-uml-plantuml.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-GOB-006-generar-diagrama-uml-plantuml.rst` | a1042a39 | 43,219 | 0 |
| `canonical/PROCED-GOB-007-consolidacion-ramas-git.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-GOB-007-consolidacion-ramas-git.rst` | 77827646 | 21,799 | 0 |
| `canonical/PROCED-GOB-008-configurar-permisos-git-push.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-GOB-008-configurar-permisos-git-push.rst` | 1a438b13 | 12,786 | 0 |
| `canonical/PROCED-GOB-009-refactorizaciones-codigo-tdd.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-GOB-009-refactorizaciones-codigo-tdd.rst` | abc0eecb | 33,365 | 0 |
| `canonical/PROCED-QA-001-ejecutar_tests.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROCED-QA-001-ejecutar_tests.rst` | f067cb45 | 13,210 | 0 |
| `canonical/PROC_Actualizacion_Modelo_Documental_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Actualizacion_Modelo_Documental_1_0_0.rst` | 37e1cc1e | 7,895 | 0 |
| `canonical/PROC_Aprobacion_Documentos_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Aprobacion_Documentos_1_0_0.rst` | d14f2d51 | 8,084 | 0 |
| `canonical/PROC_Auditoria_Documental_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Auditoria_Documental_1_0_0.rst` | 5d4bbdd6 | 3,424 | 0 |
| `canonical/PROC_Cambio_Requisitos_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Cambio_Requisitos_1_0_0.rst` | f39a5aed | 6,942 | 0 |
| `canonical/PROC_Congelamiento_Subdominio_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Congelamiento_Subdominio_1_0_0.rst` | 1f659482 | 7,993 | 0 |
| `canonical/PROC_Crear_Estructura_Directorios_Tmp_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Crear_Estructura_Directorios_Tmp_1_0_0.rst` | f0bb7816 | 8,446 | 0 |
| `canonical/PROC_Crear_Plan_Analisis_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Crear_Plan_Analisis_1_0_0.rst` | 301dca99 | 2,405 | 0 |
| `canonical/PROC_Derivacion_BR_UC_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Derivacion_BR_UC_1_0_0.rst` | 5bdf42b5 | 3,170 | 0 |
| `canonical/PROC_Derivacion_BReq_BR_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Derivacion_BReq_BR_1_0_0.rst` | 4e9a39db | 2,989 | 0 |
| `canonical/PROC_Derivacion_FR_CODE_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Derivacion_FR_CODE_1_0_0.rst` | a403eaef | 3,301 | 0 |
| `canonical/PROC_Derivacion_FR_TST_1_1_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Derivacion_FR_TST_1_1_0.rst` | 48052e6e | 8,510 | 0 |
| `canonical/PROC_Derivacion_UC_FR_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Derivacion_UC_FR_1_0_0.rst` | 919881f2 | 10,246 | 0 |
| `canonical/PROC_Descongelamiento_Subdominio_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Descongelamiento_Subdominio_1_0_0.rst` | 469788e6 | 8,205 | 0 |
| `canonical/PROC_Generacion_ADR_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_ADR_1_0_0.rst` | 7e940de4 | 2,963 | 0 |
| `canonical/PROC_Generacion_API_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_API_1_0_0.rst` | 97922398 | 9,366 | 0 |
| `canonical/PROC_Generacion_BR_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_BR_1_0_0.rst` | 14591b3e | 8,156 | 0 |
| `canonical/PROC_Generacion_BReq_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_BReq_1_0_0.rst` | 95323465 | 2,649 | 0 |
| `canonical/PROC_Generacion_CNST_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_CNST_1_0_0.rst` | 5d605353 | 2,868 | 0 |
| `canonical/PROC_Generacion_FD_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_FD_1_0_0.rst` | 7d6d0fc7 | 2,490 | 0 |
| `canonical/PROC_Generacion_FR_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_FR_1_0_0.rst` | b5139b77 | 9,969 | 0 |
| `canonical/PROC_Generacion_Index_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_Index_1_0_0.rst` | 5ea84a63 | 7,671 | 0 |
| `canonical/PROC_Generacion_MOD_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_MOD_1_0_0.rst` | d85f7f7b | 3,188 | 0 |
| `canonical/PROC_Generacion_NFR_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_NFR_1_0_0.rst` | b4627702 | 8,154 | 0 |
| `canonical/PROC_Generacion_POL_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_POL_1_0_0.rst` | 1106f7a8 | 2,548 | 0 |
| `canonical/PROC_Generacion_RTM_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_RTM_1_0_0.rst` | 3d59982d | 8,570 | 0 |
| `canonical/PROC_Generacion_STD_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_STD_1_0_0.rst` | b744bad2 | 7,892 | 0 |
| `canonical/PROC_Generacion_TST_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_TST_1_0_0.rst` | cbeccb8d | 11,376 | 0 |
| `canonical/PROC_Generacion_UC_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_UC_1_0_0.rst` | 47e52212 | 8,768 | 0 |
| `canonical/PROC_Generacion_VIEW_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Generacion_VIEW_1_0_0.rst` | acba5a09 | 2,753 | 0 |
| `canonical/PROC_Identificar_Gaps_Huerfanos_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Identificar_Gaps_Huerfanos_1_0_0.rst` | 804ad87e | 3,319 | 0 |
| `canonical/PROC_Publicacion_Documentacion_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Publicacion_Documentacion_1_0_0.rst` | 526a7877 | 3,288 | 0 |
| `canonical/PROC_Revision_Artefactos_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Revision_Artefactos_1_0_0.rst` | 2d1d9143 | 7,861 | 0 |
| `canonical/PROC_Revision_TPL_Previo_Generacion_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Revision_TPL_Previo_Generacion_1_0_0.rst` | 13c9dd13 | 7,646 | 0 |
| `canonical/PROC_Revision_UC_Previo_Derivacion_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Revision_UC_Previo_Derivacion_1_0_0.rst` | 1d8052fb | 8,645 | 0 |
| `canonical/PROC_Validacion_Sphinx_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Validacion_Sphinx_1_0_0.rst` | 67c8b744 | 3,032 | 0 |
| `canonical/PROC_Verificacion_Cobertura_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Verificacion_Cobertura_1_0_0.rst` | ce1cbf97 | 3,209 | 0 |
| `canonical/PROC_Versionado_Semantico_1_0_0.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/PROC_Versionado_Semantico_1_0_0.rst` | 315c83d0 | 7,289 | 0 |
| `canonical/Procedimientos - frontend-README.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/Procedimientos - frontend-README.rst` | c7b41e1a | 413 | 0 |
| `canonical/Procesos de Gobernanza-README.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/Procesos de Gobernanza-README.rst` | 23a3e555 | 22,014 | 0 |
| `canonical/RESUMEN_SDLC_AI_DOCS.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/RESUMEN_SDLC_AI_DOCS.rst` | e97bbca8 | 2,959 | 0 |
| `canonical/guia_completa_desarrollo_features.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/guia_completa_desarrollo_features.rst` | f2528548 | 53,916 | 0 |
| `canonical/index.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/index.rst` | 2f77cadd | 3,310 | 0 |
| `canonical/procedimiento_analisis_seguridad.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/procedimiento_analisis_seguridad.rst` | 3be2f274 | 28,300 | 0 |
| `canonical/procedimiento_desarrollo_local.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/procedimiento_desarrollo_local.rst` | 893f5199 | 6,363 | 0 |
| `canonical/procedimiento_diseno_tecnico.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/procedimiento_diseno_tecnico.rst` | 00771714 | 22,202 | 0 |
| `canonical/procedimiento_gestion_cambios.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/procedimiento_gestion_cambios.rst` | 89f32d78 | 9,150 | 0 |
| `canonical/procedimiento_instalacion_entorno.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/procedimiento_instalacion_entorno.rst` | dc687e6b | 7,823 | 0 |
| `canonical/procedimiento_qa.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/procedimiento_qa.rst` | 40d788f4 | 11,187 | 0 |
| `canonical/procedimiento_release.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/procedimiento_release.rst` | 7c80dbb9 | 6,846 | 0 |
| `canonical/procedimiento_revision_documental.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/procedimiento_revision_documental.rst` | c3a897a9 | 7,193 | 0 |
| `canonical/procedimiento_trazabilidad_requisitos.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/procedimiento_trazabilidad_requisitos.rst` | aa6cf633 | 30,268 | 0 |
| `canonical/procedimientos operacionales-readme.rst` | `temp-backup/source-2026-04-28/normativa/procedimientos/procedimientos operacionales-readme.rst` | 9049dc81 | 6,344 | 0 |

