```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-51-source-rebuild-operations
phase: Phase 1 — DISCOVER (input staging)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Inventory — WP operations

Documentos pre-staged desde `temp-backup/` y `temp-holding/`. Solo estos archivos deben consultarse para el analisis de este WP — evita buscar en todo `temp-*`.

## Convencion

- `canonical/` — un solo archivo por concepto (MD5 deduplicado, preferencia: temp-backup > FASE 02 > FASE 01).
- `variants/` — archivos con mismo nombre pero contenido distinto, ruta espejo del origen para desambiguar.

## Resumen

- Canonicos: **203**
- Variantes: **4**
- Duplicados colapsados: **9**

- Tamano total stage: 1,294,906 bytes (1264.6 KB)

## Canonicos

| Destino | Origen elegido | Hash | Bytes | Dups colapsados |
|---------|---------------|------|-------|----------------|
| `canonical/CONTENIDO_DEL_ZIP.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/CONTENIDO_DEL_ZIP.md` | b95f4c84 | 11,097 | 0 |
| `canonical/FASE 10 PARTE_4 - COMPLETADA.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 10/FASE 10 PARTE_4 - COMPLETADA.txt` | 82141f41 | 1,997 | 0 |
| `canonical/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md` | `temp-holding/FASE 01/docs/operaciones/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md` | 4a51f5f4 | 13,258 | 0 |
| `canonical/INFORME_REGENERACION_v1_2_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/INFORME_REGENERACION_v1_2_0.md` | b3532b0b | 3,445 | 0 |
| `canonical/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md` | `temp-holding/FASE 01/docs/operaciones/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md` | ebc423de | 14,483 | 0 |
| `canonical/PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 10/PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md` | cc694bf2 | 206,450 | 0 |
| `canonical/PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 12/PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md` | 552a2df4 | 35,530 | 0 |
| `canonical/PLAN_TEMPLATES_3_12_v1_2_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/PLAN_TEMPLATES_3_12_v1_2_0.md` | 23e60b05 | 18,451 | 0 |
| `canonical/QUICKSTART.md` | `temp-holding/FASE 01/docs/scripts/QUICKSTART.md` | a7a80e0f | 5,950 | 0 |
| `canonical/README.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/iact_templates_v1_3_0/iact_templates_v1_3_0/README.txt` | ddda16d1 | 1,081 | 0 |
| `canonical/RESUMEN_FASE_10.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 10/RESUMEN_FASE_10.md` | e36d61c4 | 3,525 | 0 |
| `canonical/RESUMEN_FASE_12.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 12/RESUMEN_FASE_12.md` | 6ca5bd93 | 6,327 | 0 |
| `canonical/TASK-013-cron_jobs_maintenance.md` | `temp-holding/FASE 01/docs/operaciones/TASK-013-cron_jobs_maintenance.md` | 023b045d | 12,403 | 0 |
| `canonical/TASK-019-log_retention_policies.md` | `temp-holding/FASE 01/docs/operaciones/TASK-019-log_retention_policies.md` | f6fdde78 | 2,245 | 0 |
| `canonical/TASK-036-disaster_recovery.md` | `temp-holding/FASE 01/docs/operaciones/TASK-036-disaster_recovery.md` | fda057bc | 19,506 | 0 |
| `canonical/TASK-038-production_readiness.md` | `temp-holding/FASE 01/docs/operaciones/TASK-038-production_readiness.md` | 189e0dbb | 22,375 | 0 |
| `canonical/TPL_BR_Decision_Tipo_1_0_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_BR_Decision_Tipo_1_0_0.rst` | 59aa6de3 | 7,522 | 0 |
| `canonical/TPL_BR_Decision_Tipo_1_1_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_BR_Decision_Tipo_1_1_0.rst` | d13e39ea | 24,991 | 0 |
| `canonical/TPL_BR_Decision_Tipo_1_2_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_BR_Decision_Tipo_1_2_0.rst` | ac0deddc | 58,042 | 0 |
| `canonical/TPL_BR_Decision_Tipo_1_3_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_BR_Decision_Tipo_1_3_0.rst` | 3bcad517 | 56,132 | 1 |
| `canonical/TPL_BR_Decision_Tipo_1_4_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_BR_Decision_Tipo_1_4_0.rst` | 68547e86 | 56,163 | 0 |
| `canonical/TPL_FR_Documentacion_10_Componentes_1_2_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_FR_Documentacion_10_Componentes_1_2_0.rst` | 4a6af0cf | 21,405 | 0 |
| `canonical/TPL_FR_Documentacion_10_Componentes_1_3_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_FR_Documentacion_10_Componentes_1_3_0.rst` | abfa5488 | 34,827 | 1 |
| `canonical/TPL_FR_Query_SQL_1_3_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_FR_Query_SQL_1_3_0.rst` | a790c31d | 23,520 | 1 |
| `canonical/TPL_FR_Validacion_Reglas_1_3_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_FR_Validacion_Reglas_1_3_0.rst` | 2446300a | 30,883 | 1 |
| `canonical/TPL_TRZ_Matriz_RTM_1_3_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/iact_templates_v1_3_0/iact_templates_v1_3_0/TPL_TRZ_Matriz_RTM_1_3_0.rst` | bd41a9a2 | 17,580 | 0 |
| `canonical/TPL_UC_Actor_Secundario_1_2_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_Actor_Secundario_1_2_0.rst` | fa0daa45 | 4,985 | 0 |
| `canonical/TPL_UC_Actor_Secundario_1_3_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_Actor_Secundario_1_3_0.rst` | 4f9f5957 | 21,791 | 1 |
| `canonical/TPL_UC_CRUD_Operaciones_1_2_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_CRUD_Operaciones_1_2_0.rst` | 2e57b8b4 | 35,312 | 1 |
| `canonical/TPL_UC_Construccion_7_Pasos_1_0_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_Construccion_7_Pasos_1_0_0.rst` | 6f2ffc8c | 9,426 | 0 |
| `canonical/TPL_UC_Construccion_7_Pasos_1_1_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_Construccion_7_Pasos_1_1_0.rst` | 8186244c | 3,340 | 0 |
| `canonical/TPL_UC_Construccion_7_Pasos_1_2_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_Construccion_7_Pasos_1_2_0.rst` | b4139fa7 | 17,830 | 0 |
| `canonical/TPL_UC_Construccion_7_Pasos_1_4_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_Construccion_7_Pasos_1_4_0.rst` | 9d3033eb | 32,007 | 0 |
| `canonical/TPL_UC_Larman_Contratos_1_2_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_Larman_Contratos_1_2_0.rst` | 9f7cfe74 | 28,232 | 1 |
| `canonical/TPL_UC_Stakeholder_Driven_1_2_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_Stakeholder_Driven_1_2_0.rst` | d8644251 | 5,369 | 0 |
| `canonical/TPL_UC_Stakeholder_Driven_1_3_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/iact_templates_v1_3_0/iact_templates_v1_3_0/TPL_UC_Stakeholder_Driven_1_3_0.rst` | c7c36c51 | 22,316 | 0 |
| `canonical/TPL_UC_Temporal_Schedulers_1_2_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_Temporal_Schedulers_1_2_0.rst` | 5c23b63b | 9,442 | 0 |
| `canonical/TPL_UC_Temporal_Schedulers_1_3_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/iact_templates_v1_3_0/iact_templates_v1_3_0/TPL_UC_Temporal_Schedulers_1_3_0.rst` | ade365dc | 20,983 | 0 |
| `canonical/TPL_UC_UI_Driven_1_2_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_UI_Driven_1_2_0.rst` | fec4154b | 17,508 | 0 |
| `canonical/TPL_UC_UI_Driven_1_3_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_UI_Driven_1_3_0.rst` | ca208b17 | 25,847 | 1 |
| `canonical/backend_test.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/backend_test.sh_analysis.md` | 46a4430d | 434 | 0 |
| `canonical/backup_cassandra.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/backup_cassandra.sh_analysis.md` | bce8eba2 | 440 | 0 |
| `canonical/backup_data_centralization.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/backup_data_centralization.sh_analysis.md` | 8bb7fcab | 460 | 0 |
| `canonical/backup_mysql.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/backup_mysql.sh_analysis.md` | 808ad95b | 432 | 0 |
| `canonical/bandit-scan.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/bandit-scan.sh_analysis.md` | dad942d0 | 432 | 0 |
| `canonical/bash_script_template.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/bash_script_template.sh_analysis.md` | 62501c5b | 450 | 0 |
| `canonical/bootstrap.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/bootstrap.sh_analysis.md` | f5019a6d | 426 | 0 |
| `canonical/bootstrap_test.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/bootstrap_test.sh_analysis.md` | 6ce75785 | 436 | 0 |
| `canonical/build_cpython.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/build_cpython.sh_analysis.md` | 4ae78257 | 434 | 0 |
| `canonical/build_wrapper.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/build_wrapper.sh_analysis.md` | 222bbd63 | 436 | 0 |
| `canonical/check_all.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/check_all.sh_analysis.md` | 4398cf92 | 426 | 0 |
| `canonical/check_csrf_protection.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/check_csrf_protection.sh_analysis.md` | 03a18810 | 451 | 0 |
| `canonical/check_django_security.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/check_django_security.sh_analysis.md` | 8951efd6 | 452 | 0 |
| `canonical/check_docs_old_references.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/check_docs_old_references.sh_analysis.md` | 6e92cca0 | 459 | 0 |
| `canonical/check_email_usage.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/check_email_usage.sh_analysis.md` | 2c7077f7 | 443 | 0 |
| `canonical/check_guides_broken_links.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/check_guides_broken_links.sh_analysis.md` | 100f07b8 | 458 | 0 |
| `canonical/check_guides_quality.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/check_guides_quality.sh_analysis.md` | 12b82d0d | 450 | 0 |
| `canonical/check_no_emojis.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/check_no_emojis.sh_analysis.md` | c2354625 | 440 | 0 |
| `canonical/check_redis_usage.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/check_redis_usage.sh_analysis.md` | 7165cdb1 | 444 | 0 |
| `canonical/check_release_exists.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/check_release_exists.sh_analysis.md` | 3f58b548 | 450 | 0 |
| `canonical/check_sql_injection.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/check_sql_injection.sh_analysis.md` | b852fd28 | 447 | 0 |
| `canonical/check_xss_protection.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/check_xss_protection.sh_analysis.md` | 1753a16d | 449 | 0 |
| `canonical/ci_cd_scripts.md` | `temp-holding/FASE 01/docs/scripts/ci_cd_scripts.md` | 7cb2719c | 11,409 | 0 |
| `canonical/claude_code.md` | `temp-holding/FASE 01/docs/operaciones/claude_code.md` | 5fe74ebb | 14,365 | 0 |
| `canonical/clean_emojis.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/clean_emojis.sh_analysis.md` | ffbd7bfd | 434 | 0 |
| `canonical/cleanup.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/cleanup.sh_analysis.md` | c75b4967 | 422 | 0 |
| `canonical/cleanup_branches.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/cleanup_branches.sh_analysis.md` | 6614d5cf | 440 | 0 |
| `canonical/cleanup_sessions.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/cleanup_sessions.sh_analysis.md` | 14cba393 | 440 | 0 |
| `canonical/common.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/common.sh_analysis.md` | 01ee71a4 | 421 | 0 |
| `canonical/complete_sync.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/complete_sync.sh_analysis.md` | a1a66cf1 | 434 | 0 |
| `canonical/configure-django.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/configure-django.sh_analysis.md` | 10b58f1d | 442 | 0 |
| `canonical/contar_requisitos.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/contar_requisitos.sh_analysis.md` | 1521274c | 442 | 0 |
| `canonical/core.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/core.sh_analysis.md` | 8ff74850 | 416 | 0 |
| `canonical/create_github_release.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/create_github_release.sh_analysis.md` | 4adaf673 | 452 | 0 |
| `canonical/create_release_packages.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/create_release_packages.sh_analysis.md` | 60529090 | 456 | 0 |
| `canonical/csrf-check.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/csrf-check.sh_analysis.md` | 513e04a9 | 428 | 0 |
| `canonical/database.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/database.sh_analysis.md` | e2daccba | 425 | 0 |
| `canonical/database_mariadb.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/database_mariadb.sh_analysis.md` | b7a9a120 | 441 | 0 |
| `canonical/database_postgres.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/database_postgres.sh_analysis.md` | eabc7dc9 | 443 | 0 |
| `canonical/demo.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/demo.sh_analysis.md` | 4c615e01 | 417 | 0 |
| `canonical/deploy.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/deploy.sh_analysis.md` | 0f2f509d | 421 | 0 |
| `canonical/disaster_recovery.md` | `temp-holding/FASE 01/docs/scripts/disaster_recovery.md` | 0a37b463 | 7,263 | 0 |
| `canonical/django-security-check.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/django-security-check.sh_analysis.md` | e12b3bdb | 450 | 0 |
| `canonical/documentation_review.md` | `temp-holding/FASE 01/docs/scripts/analisis/documentation_review.md` | 532d8a6c | 17,546 | 0 |
| `canonical/environment.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/environment.sh_analysis.md` | 32e43368 | 430 | 0 |
| `canonical/estado_generacion.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 12/estado_generacion.txt` | 2b1a4081 | 2,470 | 1 |
| `canonical/example_ci_integration.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/example_ci_integration.sh_analysis.md` | 218eee8c | 452 | 0 |
| `canonical/example_single_file.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/example_single_file.sh_analysis.md` | 4418936d | 446 | 0 |
| `canonical/exit_codes.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/exit_codes.sh_analysis.md` | 7a7d845b | 429 | 0 |
| `canonical/feature_install.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/feature_install.sh_analysis.md` | 7d0f56f8 | 440 | 0 |
| `canonical/filesystem.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/filesystem.sh_analysis.md` | ae8ab0a8 | 430 | 0 |
| `canonical/fix_db_connectivity.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/fix_db_connectivity.sh_analysis.md` | 4d9c32fa | 446 | 0 |
| `canonical/frontend_test.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/frontend_test.sh_analysis.md` | cf409664 | 436 | 0 |
| `canonical/gate-db-router.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/gate-db-router.sh_analysis.md` | 29e5e64c | 438 | 0 |
| `canonical/gate-docs-structure.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/gate-docs-structure.sh_analysis.md` | bef96001 | 448 | 0 |
| `canonical/gate-no-emojis.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/gate-no-emojis.sh_analysis.md` | 2fa7ac7b | 438 | 0 |
| `canonical/gate-restrictions.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/gate-restrictions.sh_analysis.md` | ecdf092a | 444 | 0 |
| `canonical/gate-route-lint.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/gate-route-lint.sh_analysis.md` | dd7d675d | 440 | 0 |
| `canonical/generate_docs_stats.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/generate_docs_stats.sh_analysis.md` | 07bae03d | 448 | 0 |
| `canonical/generate_dora_report.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/generate_dora_report.sh_analysis.md` | c54826a4 | 450 | 0 |
| `canonical/generate_plan.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/generate_plan.sh_analysis.md` | a503d607 | 434 | 0 |
| `canonical/generate_release_notes.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/generate_release_notes.sh_analysis.md` | 1d22811b | 454 | 0 |
| `canonical/get_next_version.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/get_next_version.sh_analysis.md` | 091f1d2b | 440 | 0 |
| `canonical/github_copilot_codespaces.md` | `temp-holding/FASE 01/docs/operaciones/github_copilot_codespaces.md` | 1b5415b2 | 9,554 | 0 |
| `canonical/health-check.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/health-check.sh_analysis.md` | 13570eba | 432 | 0 |
| `canonical/health_check.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/health_check.sh_analysis.md` | 5df36cbd | 432 | 0 |
| `canonical/init_host.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/init_host.sh_analysis.md` | 9f449398 | 426 | 0 |
| `canonical/install-cassandra.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/install-cassandra.sh_analysis.md` | edf31cb7 | 443 | 0 |
| `canonical/install.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/install.sh_analysis.md` | da227990 | 424 | 0 |
| `canonical/install_hooks.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/install_hooks.sh_analysis.md` | d29bac35 | 434 | 0 |
| `canonical/install_prebuilt_cpython.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/install_prebuilt_cpython.sh_analysis.md` | eb6711d9 | 458 | 0 |
| `canonical/library_template.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/library_template.sh_analysis.md` | 4c300226 | 440 | 0 |
| `canonical/lightweight_venv.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/lightweight_venv.sh_analysis.md` | 897c7477 | 441 | 0 |
| `canonical/listar_requisitos.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/listar_requisitos.sh_analysis.md` | 3e19ef6d | 443 | 0 |
| `canonical/logger.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/logger.sh_analysis.md` | ac618be5 | 420 | 0 |
| `canonical/logging.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/logging.sh_analysis.md` | 88164ffd | 423 | 0 |
| `canonical/mariadb.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/mariadb.sh_analysis.md` | 42a4811d | 424 | 0 |
| `canonical/mariadb_install.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/mariadb_install.sh_analysis.md` | ab22b560 | 438 | 0 |
| `canonical/merge_y_limpieza_ramas.md` | `temp-holding/FASE 01/docs/operaciones/merge_y_limpieza_ramas.md` | 5d3c9ab9 | 10,067 | 0 |
| `canonical/metrics_and_reporting.md` | `temp-holding/FASE 01/docs/scripts/metrics_and_reporting.md` | fc764057 | 979 | 0 |
| `canonical/name_parser.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/name_parser.sh_analysis.md` | e4b1955c | 430 | 0 |
| `canonical/network.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/network.sh_analysis.md` | 4068eb6b | 422 | 0 |
| `canonical/npm-audit.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/npm-audit.sh_analysis.md` | 833f1ac8 | 428 | 0 |
| `canonical/on_create.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/on_create.sh_analysis.md` | 7c1635e7 | 426 | 0 |
| `canonical/posix_script_template.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/posix_script_template.sh_analysis.md` | 3d651b62 | 452 | 0 |
| `canonical/post_create.md` | `temp-holding/FASE 01/docs/operaciones/post_create.md` | c3fe1a96 | 8,043 | 0 |
| `canonical/post_create.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/post_create.sh_analysis.md` | 301bf359 | 430 | 0 |
| `canonical/post_start.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/post_start.sh_analysis.md` | adf09db2 | 428 | 0 |
| `canonical/postgres_install.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/postgres_install.sh_analysis.md` | 007d10cc | 440 | 0 |
| `canonical/postgresql.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/postgresql.sh_analysis.md` | 8342cdb2 | 430 | 0 |
| `canonical/pre-up-validations.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/pre-up-validations.sh_analysis.md` | 2501efdf | 444 | 0 |
| `canonical/procedimiento_merge_analyze_scripts.md` | `temp-holding/FASE 01/docs/operaciones/procedimiento_merge_analyze_scripts.md` | 329ac9af | 7,583 | 0 |
| `canonical/python.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/python.sh_analysis.md` | 5aa31fc8 | 420 | 0 |
| `canonical/quickstart.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/quickstart.sh_analysis.md` | 09d1f1ce | 428 | 0 |
| `canonical/remediation_plan.md` | `temp-holding/FASE 01/docs/scripts/analisis/remediation_plan.md` | 3a4cf92f | 15,140 | 0 |
| `canonical/reorganizar_docs_por_dominio.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/reorganizar_docs_por_dominio.sh_analysis.md` | 89f80bf3 | 464 | 0 |
| `canonical/reprocesar_etl_fallido.md` | `temp-holding/FASE 01/docs/operaciones/reprocesar_etl_fallido.md` | e8473295 | 10,118 | 0 |
| `canonical/requirements_management.md` | `temp-holding/FASE 01/docs/scripts/requirements_management.md` | f615ec85 | 5,456 | 0 |
| `canonical/restore_mysql.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/restore_mysql.sh_analysis.md` | c1bc9abe | 436 | 0 |
| `canonical/retry_handler.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/retry_handler.sh_analysis.md` | ca44c008 | 434 | 0 |
| `canonical/run-all-checks.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/run-all-checks.sh_analysis.md` | d1723458 | 436 | 0 |
| `canonical/run-all-gates.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/run-all-gates.sh_analysis.md` | e3e26fa3 | 434 | 0 |
| `canonical/run-tdd-cycle.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/run-tdd-cycle.sh_analysis.md` | 77c81489 | 436 | 0 |
| `canonical/run_all_compliance_checks.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/run_all_compliance_checks.sh_analysis.md` | 270811e8 | 458 | 0 |
| `canonical/run_all_security_checks.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/run_all_security_checks.sh_analysis.md` | 5298afd3 | 454 | 0 |
| `canonical/run_all_tests.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/run_all_tests.sh_analysis.md` | f9fe493e | 434 | 0 |
| `canonical/run_all_unit_tests.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/run_all_unit_tests.sh_analysis.md` | 3aa246f5 | 444 | 0 |
| `canonical/run_all_use_cases.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/run_all_use_cases.sh_analysis.md` | 244d345b | 443 | 0 |
| `canonical/run_benchmarks.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/run_benchmarks.sh_analysis.md` | e7b6c924 | 438 | 0 |
| `canonical/run_integration_tests.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/run_integration_tests.sh_analysis.md` | a46cfccc | 452 | 0 |
| `canonical/run_test_generation.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/run_test_generation.sh_analysis.md` | 2daa07b5 | 448 | 0 |
| `canonical/script_development_guide.md` | `temp-holding/FASE 01/docs/scripts/script_development_guide.md` | bf1cb00e | 9,490 | 0 |
| `canonical/scripts_matrix.md` | `temp-holding/FASE 01/docs/scripts/scripts_matrix.md` | 34b8a948 | 935 | 0 |
| `canonical/sdlc_automation_reference.md` | `temp-holding/FASE 01/docs/scripts/sdlc_automation_reference.md` | 46280e3d | 17,360 | 0 |
| `canonical/sdlc_process_guide.md` | `temp-holding/FASE 01/docs/scripts/sdlc_process_guide.md` | 566fc704 | 28,184 | 0 |
| `canonical/security_scan.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/security_scan.sh_analysis.md` | 7c949cc3 | 435 | 0 |
| `canonical/seed_data.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/seed_data.sh_analysis.md` | 795aacb3 | 427 | 0 |
| `canonical/setup-cron-jobs.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/setup-cron-jobs.sh_analysis.md` | f66ffce2 | 438 | 0 |
| `canonical/setup_mariadb_database.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/setup_mariadb_database.sh_analysis.md` | 523b5434 | 452 | 0 |
| `canonical/setup_postgres_database.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/setup_postgres_database.sh_analysis.md` | 6a798d18 | 454 | 0 |
| `canonical/simple_load_test.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/simple_load_test.sh_analysis.md` | cd4d79f4 | 440 | 0 |
| `canonical/state_manager.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/state_manager.sh_analysis.md` | 8a9228a1 | 434 | 0 |
| `canonical/system_prepare.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/system_prepare.sh_analysis.md` | dd10bcd9 | 436 | 0 |
| `canonical/test-execution-time.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/test-execution-time.sh_analysis.md` | d4b3bc2d | 446 | 0 |
| `canonical/test-pyramid.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/test-pyramid.sh_analysis.md` | 93e6dd77 | 432 | 0 |
| `canonical/test_dr.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/test_dr.sh_analysis.md` | 39517a91 | 422 | 0 |
| `canonical/test_pyramid_check.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/test_pyramid_check.sh_analysis.md` | 52547831 | 444 | 0 |
| `canonical/update_content.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/update_content.sh_analysis.md` | 4809314b | 436 | 0 |
| `canonical/update_version.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/update_version.sh_analysis.md` | 91f0e77a | 436 | 0 |
| `canonical/vagrant_setup_example.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/vagrant_setup_example.sh_analysis.md` | 2750e244 | 451 | 0 |
| `canonical/validar_estructura_docs.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validar_estructura_docs.sh_analysis.md` | e8e42f83 | 455 | 0 |
| `canonical/validate-config.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate-config.sh_analysis.md` | c0d19a97 | 438 | 0 |
| `canonical/validate-docker.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate-docker.sh_analysis.md` | 2d2d46ac | 438 | 0 |
| `canonical/validate-environment-files.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate-environment-files.sh_analysis.md` | e3ef4887 | 460 | 0 |
| `canonical/validate-environment.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate-environment.sh_analysis.md` | e78f7a1e | 448 | 0 |
| `canonical/validate-hardware-requirements.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate-hardware-requirements.sh_analysis.md` | c25fbc00 | 468 | 0 |
| `canonical/validate-naming-compliance.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate-naming-compliance.sh_analysis.md` | 8c60aecb | 460 | 0 |
| `canonical/validate-network-configuration.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate-network-configuration.sh_analysis.md` | cae4a956 | 470 | 0 |
| `canonical/validate-scripts.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate-scripts.sh_analysis.md` | e108c62a | 440 | 0 |
| `canonical/validate-secrets-enhanced.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate-secrets-enhanced.sh_analysis.md` | e493658b | 458 | 0 |
| `canonical/validate-software-dependencies.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate-software-dependencies.sh_analysis.md` | 12db885f | 468 | 0 |
| `canonical/validate_autogenerated_docs.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate_autogenerated_docs.sh_analysis.md` | 9e85483c | 462 | 0 |
| `canonical/validate_build.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate_build.sh_analysis.md` | 9c8c4681 | 436 | 0 |
| `canonical/validate_critical_restrictions.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate_critical_restrictions.sh_analysis.md` | f3d8752c | 468 | 0 |
| `canonical/validate_database_router.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate_database_router.sh_analysis.md` | ca8b971a | 458 | 0 |
| `canonical/validate_environment.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate_environment.sh_analysis.md` | ac050728 | 448 | 0 |
| `canonical/validate_frontmatter.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate_frontmatter.sh_analysis.md` | 406a94b6 | 448 | 0 |
| `canonical/validate_guides_frontmatter.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate_guides_frontmatter.sh_analysis.md` | 8d0c322d | 462 | 0 |
| `canonical/validate_guides_structure.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate_guides_structure.sh_analysis.md` | 373232a8 | 458 | 0 |
| `canonical/validate_security_config.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate_security_config.sh_analysis.md` | 02093b85 | 456 | 0 |
| `canonical/validate_session_backend.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate_session_backend.sh_analysis.md` | 2de1dee3 | 458 | 0 |
| `canonical/validate_shell_constitution.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate_shell_constitution.sh_analysis.md` | be589136 | 462 | 0 |
| `canonical/validate_spec.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate_spec.sh_analysis.md` | 61edb192 | 436 | 0 |
| `canonical/validate_wrapper.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validate_wrapper.sh_analysis.md` | efbb8c1c | 442 | 0 |
| `canonical/validation.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validation.sh_analysis.md` | 8a645433 | 428 | 0 |
| `canonical/validator.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/validator.sh_analysis.md` | 22e35838 | 426 | 0 |
| `canonical/ver_documentacion.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/ver_documentacion.sh_analysis.md` | 7db35aff | 442 | 0 |
| `canonical/verificar_servicios.md` | `temp-holding/FASE 01/docs/operaciones/verificar_servicios.md` | a43d5d77 | 8,230 | 0 |
| `canonical/verificar_servicios.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/verificar_servicios.sh_analysis.md` | 2e45dc41 | 447 | 0 |
| `canonical/verify_connections.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/verify_connections.sh_analysis.md` | 3de29ec6 | 444 | 0 |
| `canonical/verify_connections_.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/verify_connections_.sh_analysis.md` | 1874accf | 446 | 0 |
| `canonical/virtualize.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/virtualize.sh_analysis.md` | 9f7f3f2f | 430 | 0 |
| `canonical/wasm_style_sandbox.sh_analysis.md` | `temp-holding/FASE 01/docs/scripts/analisis/wasm_style_sandbox.sh_analysis.md` | 6fce59ff | 446 | 0 |

## Variantes

| Destino | Origen | Hash | Bytes |
|---------|--------|------|-------|
| `variants/temp-holding/FASE 01/docs/scripts/README.md` | `temp-holding/FASE 01/docs/scripts/README.md` | 91473a41 | 8,946 |
| `variants/temp-holding/GENERACION_DOCUMENTACION/FASE 13/README.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/README.md` | 43a1f251 | 10,504 |
| `variants/temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_Construccion_7_Pasos_1_3_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/TPL_UC_Construccion_7_Pasos_1_3_0.rst` | 83bf08bd | 31,709 |
| `variants/temp-holding/GENERACION_DOCUMENTACION/FASE 13/iact_templates_v1_3_0/iact_templates_v1_3_0/TPL_UC_Construccion_7_Pasos_1_3_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 13/iact_templates_v1_3_0/iact_templates_v1_3_0/TPL_UC_Construccion_7_Pasos_1_3_0.rst` | 9d3033eb | 32,007 |

