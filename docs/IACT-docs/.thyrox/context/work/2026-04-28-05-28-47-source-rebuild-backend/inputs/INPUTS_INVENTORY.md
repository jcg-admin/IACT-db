```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-47-source-rebuild-backend
phase: Phase 1 — DISCOVER (input staging)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Inventory — WP backend

Documentos pre-staged desde `temp-backup/` y `temp-holding/`. Solo estos archivos deben consultarse para el analisis de este WP — evita buscar en todo `temp-*`.

## Convencion

- `canonical/` — un solo archivo por concepto (MD5 deduplicado, preferencia: temp-backup > FASE 02 > FASE 01).
- `variants/` — archivos con mismo nombre pero contenido distinto, ruta espejo del origen para desambiguar.

## Resumen

- Canonicos: **277**
- Variantes: **126**
- Duplicados colapsados: **6**

- Tamano total stage: 4,723,087 bytes (4612.4 KB)

## Canonicos

| Destino | Origen elegido | Hash | Bytes | Dups colapsados |
|---------|---------------|------|-------|----------------|
| `canonical/00_resumen_ejecutivo_mejores_practicas.md` | `temp-holding/FASE 01/docs/backend/planificacion/analisis_negocio/marco_integrado/00_resumen_ejecutivo_mejores_practicas.md` | 5945d72f | 15,407 | 0 |
| `canonical/01_marco_conceptual_iact.md` | `temp-holding/FASE 01/docs/backend/planificacion/analisis_negocio/marco_integrado/01_marco_conceptual_iact.md` | 6ff66ae3 | 17,929 | 0 |
| `canonical/02_relaciones_fundamentales_iact.md` | `temp-holding/FASE 01/docs/backend/planificacion/analisis_negocio/marco_integrado/02_relaciones_fundamentales_iact.md` | c5f20308 | 20,080 | 0 |
| `canonical/2025_02_16_ejecucion_pytest.md` | `temp-holding/FASE 01/docs/backend/registros/2025_02_16_ejecucion_pytest.md` | 5b5a913a | 1,464 | 0 |
| `canonical/2025_11_02_ejecucion_pytest.md` | `temp-holding/FASE 01/docs/backend/registros/2025_11_02_ejecucion_pytest.md` | 503cfbff | 1,506 | 0 |
| `canonical/ADR-BACK-001-grupos-funcionales-sin-jerarquia.md` | `temp-holding/FASE 01/docs/backend/gobernanza/adr/ADR-BACK-001-grupos-funcionales-sin-jerarquia.md` | 685cae4f | 13,080 | 0 |
| `canonical/ADR-BACK-002-configuracion-dinamica-sistema.md` | `temp-holding/FASE 01/docs/backend/gobernanza/adr/ADR-BACK-002-configuracion-dinamica-sistema.md` | 6b57dca6 | 11,336 | 0 |
| `canonical/ADR-BACK-003-orm-sql-hybrid-permissions.md` | `temp-holding/FASE 01/docs/backend/gobernanza/adr/ADR-BACK-003-orm-sql-hybrid-permissions.md` | b9044fed | 13,192 | 0 |
| `canonical/ADR-BACK-004-autenticacion-hibrida-jwt-sessions.md` | `temp-holding/FASE 01/docs/backend/gobernanza/adr/ADR-BACK-004-autenticacion-hibrida-jwt-sessions.md` | dfd9775e | 13,044 | 0 |
| `canonical/ADR-BACK-005-middleware-decoradores-permisos.md` | `temp-holding/FASE 01/docs/backend/gobernanza/adr/ADR-BACK-005-middleware-decoradores-permisos.md` | b9161a4f | 13,387 | 0 |
| `canonical/ADR-BACK-010-django-5-framework-backend.md` | `temp-holding/FASE 01/docs/backend/gobernanza/adr/ADR-BACK-010-django-5-framework-backend.md` | aaf391f8 | 14,719 | 0 |
| `canonical/ADR-BACK-011-postgresql-mariadb-multi-database.md` | `temp-holding/FASE 01/docs/backend/gobernanza/adr/ADR-BACK-011-postgresql-mariadb-multi-database.md` | 62194850 | 17,721 | 0 |
| `canonical/ADR-BACK-012-apscheduler-tareas-programadas.md` | `temp-holding/FASE 01/docs/backend/gobernanza/adr/ADR-BACK-012-apscheduler-tareas-programadas.md` | d9dc23b6 | 18,623 | 0 |
| `canonical/ADR-BACKEND-001-ejemplo.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/decisions/ADR-BACKEND-001-ejemplo.md` | ee74f539 | 8,742 | 0 |
| `canonical/ADR-QA-010-pytest-framework-testing.md` | `temp-holding/FASE 01/docs/backend/gobernanza/adr/ADR-QA-010-pytest-framework-testing.md` | 19a323ef | 21,419 | 0 |
| `canonical/ADVANCED_PROMPTING_TECHNIQUES.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/promptops/ADVANCED_PROMPTING_TECHNIQUES.md` | 34dabf41 | 28,975 | 0 |
| `canonical/ANALISIS_IMPLEMENTACION_PRIORIDAD_02.md` | `temp-holding/FASE 01/docs/backend/ANALISIS_IMPLEMENTACION_PRIORIDAD_02.md` | fd999298 | 11,383 | 0 |
| `canonical/ANALISIS_RESTRICCIONES_VS_MEJORAS.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/ANALISIS_RESTRICCIONES_VS_MEJORAS.md` | 6cd2afd9 | 12,515 | 0 |
| `canonical/ANALISIS_SEGURIDAD_AMENAZAS.md` | `temp-holding/FASE 01/docs/backend/seguridad/ANALISIS_SEGURIDAD_AMENAZAS.md` | 0e5f522c | 30,269 | 0 |
| `canonical/ANALISIS_URLS_COMPLETO.md` | `temp-holding/FASE 01/docs/backend/validaciones/ANALISIS_URLS_COMPLETO.md` | e73ba0fe | 13,140 | 0 |
| `canonical/API-permisos.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/API-permisos.md` | 93205bad | 12,443 | 0 |
| `canonical/ARQUITECTURA-MODULOS-COMPLETA.md` | `temp-holding/FASE 01/docs/backend/ARQUITECTURA-MODULOS-COMPLETA.md` | 37a0f101 | 13,819 | 0 |
| `canonical/ARQUITECTURA_PERMISOS_UML.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/ARQUITECTURA_PERMISOS_UML.md` | be2ed610 | 24,315 | 0 |
| `canonical/AUTO_COT_IMPLEMENTATION.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/promptops/AUTO_COT_IMPLEMENTATION.md` | 0ece4f60 | 12,161 | 0 |
| `canonical/CASOS_DE_USO_SISTEMA_PERMISOS.md` | `temp-holding/FASE 01/docs/backend/requisitos/CASOS_DE_USO_SISTEMA_PERMISOS.md` | d87afd84 | 41,202 | 0 |
| `canonical/CATALOGO-APIs.md` | `temp-holding/FASE 01/docs/backend/catalogos/CATALOGO-APIs.md` | 492be87b | 19,072 | 0 |
| `canonical/CATALOGO-ENDPOINTS.md` | `temp-holding/FASE 01/docs/backend/catalogos/CATALOGO-ENDPOINTS.md` | 24ddfcca | 21,455 | 0 |
| `canonical/CATALOGO-MODELOS.md` | `temp-holding/FASE 01/docs/backend/catalogos/CATALOGO-MODELOS.md` | 60503eb6 | 27,455 | 0 |
| `canonical/CATALOGO-SERVICIOS.md` | `temp-holding/FASE 01/docs/backend/catalogos/CATALOGO-SERVICIOS.md` | 00a5739a | 14,958 | 0 |
| `canonical/CATALOGO_GRUPOS_FUNCIONALES.md` | `temp-holding/FASE 01/docs/backend/requisitos/CATALOGO_GRUPOS_FUNCIONALES.md` | 1a3b1db1 | 15,886 | 0 |
| `canonical/CONTRIBUTING.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/promptops/CONTRIBUTING.md` | 86f993f5 | 26,485 | 0 |
| `canonical/CORRECCIONES_MENORES.md` | `temp-holding/FASE 01/docs/backend/validaciones/CORRECCIONES_MENORES.md` | 5a1af248 | 6,781 | 0 |
| `canonical/FASE 3 PARTE_2A - COMPLETADA.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/FASE 3 PARTE_2A - COMPLETADA.txt` | 5de89fcc | 6,326 | 0 |
| `canonical/FASE 4  PARTE_2A - COMPLETADA.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/FASE 4  PARTE_2A - COMPLETADA.txt` | 967b92e2 | 6,421 | 0 |
| `canonical/FASE 4 PARTE_2B - COMPLETADA.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/FASE 4 PARTE_2B - COMPLETADA.txt` | 740d16e7 | 4,048 | 0 |
| `canonical/GLOSARIO-BACKEND.md` | `temp-holding/FASE 01/docs/backend/GLOSARIO-BACKEND.md` | 5aa82b45 | 2,640 | 0 |
| `canonical/GUIA_NAVEGACION_BACKEND.md` | `temp-holding/FASE 01/docs/backend/GUIA_NAVEGACION_BACKEND.md` | a66f2bee | 9,816 | 0 |
| `canonical/GUIA_USO_PRIORIDAD_02.md` | `temp-holding/FASE 01/docs/backend/GUIA_USO_PRIORIDAD_02.md` | a91a6c5c | 13,369 | 0 |
| `canonical/IMPLEMENTACION-SCRIPTS.md` | `temp-holding/FASE 01/docs/backend/trazabilidad/IMPLEMENTACION-SCRIPTS.md` | d85f0ddd | 13,589 | 0 |
| `canonical/INDEX.md` | `temp-holding/FASE 01/docs/backend/INDEX.md` | 8a031dd8 | 4,598 | 0 |
| `canonical/INDICE.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/INDICE.md` | aa8d64b5 | 6,883 | 0 |
| `canonical/INDICE_ADRs.md` | `temp-holding/FASE 01/docs/backend/gobernanza/adr/INDICE_ADRs.md` | b7d3abbe | 8,240 | 0 |
| `canonical/INDICE_MAESTRO_PERMISOS_GRANULAR.md` | `temp-holding/FASE 01/docs/backend/requisitos/INDICE_MAESTRO_PERMISOS_GRANULAR.md` | cf04ba23 | 15,324 | 0 |
| `canonical/INDICE_PROCESOS.md` | `temp-holding/FASE 01/docs/backend/procesos/INDICE_PROCESOS.md` | ea396511 | 10,796 | 0 |
| `canonical/INDICE_REQUISITOS.md` | `temp-holding/FASE 01/docs/backend/requisitos/INDICE_REQUISITOS.md` | f75d9457 | 17,400 | 0 |
| `canonical/INDICE_VALIDACION.md` | `temp-holding/FASE 01/docs/backend/validaciones/INDICE_VALIDACION.md` | f0f78d68 | 8,561 | 0 |
| `canonical/LISTADO-COMPLETO-TAREAS.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/LISTADO-COMPLETO-TAREAS.md` | ad0942fb | 19,006 | 0 |
| `canonical/MAPEO-MIGRACION-BACKEND-2025-11-18.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/MAPEO-MIGRACION-BACKEND-2025-11-18.md` | f0b328ca | 19,643 | 0 |
| `canonical/MAPEO_FUNCIONES_MODULOS_DJANGO.md` | `temp-holding/FASE 01/docs/backend/requisitos/MAPEO_FUNCIONES_MODULOS_DJANGO.md` | 58778184 | 12,267 | 0 |
| `canonical/MATRIZ-requisitos-codigo.md` | `temp-holding/FASE 01/docs/backend/trazabilidad/MATRIZ-requisitos-codigo.md` | 2bad5b3f | 19,729 | 0 |
| `canonical/MATRIZ-requisitos-tests.md` | `temp-holding/FASE 01/docs/backend/trazabilidad/MATRIZ-requisitos-tests.md` | dc70b4af | 16,505 | 0 |
| `canonical/MATRIZ_TRAZABILIDAD_PERMISOS.md` | `temp-holding/FASE 01/docs/backend/requisitos/MATRIZ_TRAZABILIDAD_PERMISOS.md` | 6a1eb49c | 31,213 | 0 |
| `canonical/MEJORAS_MIDDLEWARE_PROPUESTAS.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/MEJORAS_MIDDLEWARE_PROPUESTAS.md` | 5325b909 | 27,568 | 0 |
| `canonical/MODULOS_IMPLEMENTADOS_20251111.md` | `temp-holding/FASE 01/docs/backend/MODULOS_IMPLEMENTADOS_20251111.md` | 384b9a06 | 37,670 | 0 |
| `canonical/NOTA_FASES 3-9 - PARTES 2A-3D - COMPLETADAS.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/NOTA_FASES 3-9 - PARTES 2A-3D - COMPLETADAS.txt` | 0e4fdb95 | 1,819 | 0 |
| `canonical/OPTIMIZACIONES_PERFORMANCE.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/OPTIMIZACIONES_PERFORMANCE.md` | 0317956c | 21,441 | 0 |
| `canonical/PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md` | 31c81611 | 145,027 | 0 |
| `canonical/PARTE_2B_Construccion_Detallada_IACT_1_0_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/PARTE_2B_Construccion_Detallada_IACT_1_0_0.md` | b2d22e93 | 159,246 | 0 |
| `canonical/PARTE_2C, PARTE_3A-3D.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/PARTE_2C, PARTE_3A-3D.txt` | 1e25a52c | 13,924 | 0 |
| `canonical/PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md` | 837897da | 116,101 | 0 |
| `canonical/PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md` | 0ad151f3 | 25,185 | 0 |
| `canonical/PARTE_3B_Tecnica_Larman_IACT_1_0_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/PARTE_3B_Tecnica_Larman_IACT_1_0_0.md` | 7d91274e | 120,882 | 0 |
| `canonical/PARTE_3C_UI_Stakeholders_IACT_1_0_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/PARTE_3C_UI_Stakeholders_IACT_1_0_0.md` | 088138dc | 75,164 | 0 |
| `canonical/PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md` | 1084a799 | 48,256 | 0 |
| `canonical/PENDIENTE_ANALISIS_AMENAZAS_APLICACION.md` | `temp-holding/FASE 01/docs/backend/seguridad/PENDIENTE_ANALISIS_AMENAZAS_APLICACION.md` | 092b85de | 14,536 | 0 |
| `canonical/PLAN-REORGANIZACION-ESTRUCTURA-BACKEND-2025-11-18.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/PLAN-REORGANIZACION-ESTRUCTURA-BACKEND-2025-11-18.md` | 13394e97 | 28,218 | 0 |
| `canonical/PROC-BACK-001-desarrollo-features.md` | `temp-holding/FASE 01/docs/backend/procesos/PROC-BACK-001-desarrollo-features.md` | faea6e24 | 18,705 | 0 |
| `canonical/PROC-BACK-002-gestion-dependencias.md` | `temp-holding/FASE 01/docs/backend/procesos/PROC-BACK-002-gestion-dependencias.md` | 7b7ec277 | 14,794 | 0 |
| `canonical/PROC-BACK-003-code-review-backend.md` | `temp-holding/FASE 01/docs/backend/procesos/PROC-BACK-003-code-review-backend.md` | d02a53ed | 18,469 | 0 |
| `canonical/PROC-BACK-004-testing-estrategia.md` | `temp-holding/FASE 01/docs/backend/procesos/PROC-BACK-004-testing-estrategia.md` | 8e7f66f5 | 27,695 | 0 |
| `canonical/PROC-BACK-005-deployment-proceso.md` | `temp-holding/FASE 01/docs/backend/procesos/PROC-BACK-005-deployment-proceso.md` | c79903a4 | 28,457 | 0 |
| `canonical/PROC-BACKEND-001-ejemplo.md` | `temp-holding/FASE 01/docs/backend/procedures/PROC-BACKEND-001-ejemplo.md` | 66ed5566 | 11,003 | 0 |
| `canonical/PROCED-BACK-001-ejecutar-tests-backend.md` | `temp-holding/FASE 01/docs/backend/procedimientos/PROCED-BACK-001-ejecutar-tests-backend.md` | 79b6a9b3 | 15,776 | 0 |
| `canonical/PROCED-BACK-002-deployment-staging.md` | `temp-holding/FASE 01/docs/backend/procedimientos/PROCED-BACK-002-deployment-staging.md` | eb938445 | 18,371 | 0 |
| `canonical/PROCED-BACK-003-rollback-deployment.md` | `temp-holding/FASE 01/docs/backend/procedimientos/PROCED-BACK-003-rollback-deployment.md` | 875c9f66 | 19,888 | 0 |
| `canonical/PROCED-BACK-004-actualizar-dependencias.md` | `temp-holding/FASE 01/docs/backend/procedimientos/PROCED-BACK-004-actualizar-dependencias.md` | 76f83605 | 23,431 | 0 |
| `canonical/README_2411.md` | `temp-holding/FASE 01/docs/backend/README_2411.md` | 3a6b0ebc | 8,898 | 0 |
| `canonical/REORGANIZACION_SCRIPTS_AI.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/promptops/REORGANIZACION_SCRIPTS_AI.md` | 4f76e5ec | 11,547 | 0 |
| `canonical/REPORTE-CREACION-TAREAS-006-010.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/REPORTE-CREACION-TAREAS-006-010.md` | 8fc8b78d | 9,248 | 0 |
| `canonical/REPORTE-CREACION-TASKS-011-024.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/REPORTE-CREACION-TASKS-011-024.md` | 53933510 | 6,329 | 0 |
| `canonical/REPORTE-EJECUCION-TASK-011-024.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/REPORTE-EJECUCION-TASK-011-024.md` | d3f4ba86 | 12,284 | 0 |
| `canonical/REPORTE-EJECUCION-TASKS-002-005.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/REPORTE-EJECUCION-TASKS-002-005.md` | a551f79b | 14,410 | 0 |
| `canonical/REPORTE-LIMPIEZA-EMOJIS.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/REPORTE-LIMPIEZA-EMOJIS.md` | 8a932450 | 69,685 | 0 |
| `canonical/REPORTE_CONSOLIDADO_FASE2_ADR.md` | `temp-holding/FASE 01/docs/backend/gobernanza/adr/evidencias/REPORTE_CONSOLIDADO_FASE2_ADR.md` | 4b22fed1 | 12,731 | 0 |
| `canonical/REPORTE_EJECUCION_TASK_001_004.md` | `temp-holding/FASE 01/docs/backend/REPORTE_EJECUCION_TASK_001_004.md` | dda4039d | 4,237 | 0 |
| `canonical/RESUMEN_FASES_3_9.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/RESUMEN_FASES_3_9.md` | 200262f0 | 3,004 | 0 |
| `canonical/RESUMEN_VALIDACION.md` | `temp-holding/FASE 01/docs/backend/validaciones/RESUMEN_VALIDACION.md` | c20cbbf1 | 7,472 | 0 |
| `canonical/RNF-BACK-010-tiempo-respuesta-api-rest.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-010-tiempo-respuesta-api-rest.md` | 6869e65e | 5,681 | 0 |
| `canonical/RNF-BACK-011-tiempo-respuesta-graphql.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-011-tiempo-respuesta-graphql.md` | 36648e7b | 5,036 | 0 |
| `canonical/RNF-BACK-012-throughput-apis.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-012-throughput-apis.md` | 9104cc04 | 5,138 | 0 |
| `canonical/RNF-BACK-013-latencia-queries-bd.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-013-latencia-queries-bd.md` | c433c617 | 5,450 | 0 |
| `canonical/RNF-BACK-014-tiempo-carga-dashboard.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-014-tiempo-carga-dashboard.md` | 239b5d84 | 5,259 | 0 |
| `canonical/RNF-BACK-015-tiempo-generacion-reportes.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-015-tiempo-generacion-reportes.md` | 64a7265d | 5,252 | 0 |
| `canonical/RNF-BACK-016-consumo-memoria-worker.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-016-consumo-memoria-worker.md` | 7dd7d25d | 5,123 | 0 |
| `canonical/RNF-BACK-017-uso-cpu.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-017-uso-cpu.md` | ddc5d874 | 4,943 | 0 |
| `canonical/RNF-BACK-020-owasp-top-10-compliance.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-020-owasp-top-10-compliance.md` | f5f36dc2 | 6,109 | 0 |
| `canonical/RNF-BACK-021-encriptacion-datos-sensibles.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-021-encriptacion-datos-sensibles.md` | 8fdbb336 | 5,786 | 0 |
| `canonical/RNF-BACK-022-politica-contrasenas.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-022-politica-contrasenas.md` | 7d2f8940 | 5,929 | 0 |
| `canonical/RNF-BACK-023-rate-limiting.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-023-rate-limiting.md` | 052b5863 | 5,410 | 0 |
| `canonical/RNF-BACK-024-auditoria-acciones-criticas.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-024-auditoria-acciones-criticas.md` | 61712557 | 6,164 | 0 |
| `canonical/RNF-BACK-025-sesiones-jwt.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-025-sesiones-jwt.md` | 75c0ddae | 5,799 | 0 |
| `canonical/RNF-BACK-026-https-obligatorio.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-026-https-obligatorio.md` | c04b9cae | 5,674 | 0 |
| `canonical/RNF-BACK-030-uptime.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-030-uptime.md` | 00ff99fa | 5,522 | 0 |
| `canonical/RNF-BACK-031-rpo.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-031-rpo.md` | f9918a96 | 5,813 | 0 |
| `canonical/RNF-BACK-032-rto.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-032-rto.md` | 2efafbeb | 5,718 | 0 |
| `canonical/RNF-BACK-033-backup-diario.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-033-backup-diario.md` | 0e3135c0 | 6,196 | 0 |
| `canonical/RNF-BACK-034-monitoreo-health-checks.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-034-monitoreo-health-checks.md` | de6a70c0 | 5,884 | 0 |
| `canonical/RNF-BACK-040-usuarios-concurrentes.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-040-usuarios-concurrentes.md` | d6c763b8 | 2,631 | 0 |
| `canonical/RNF-BACK-041-crecimiento-datos.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-041-crecimiento-datos.md` | 6f80b25a | 2,740 | 0 |
| `canonical/RNF-BACK-042-escalado-horizontal.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-042-escalado-horizontal.md` | 24d5cf93 | 2,936 | 0 |
| `canonical/RNF-BACK-043-cache-distribuido.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-043-cache-distribuido.md` | 56cebccb | 2,635 | 0 |
| `canonical/RNF-BACK-044-particionamiento-bd.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-044-particionamiento-bd.md` | 34f63229 | 2,800 | 0 |
| `canonical/RNF-BACK-050-mensajes-error-descriptivos.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-050-mensajes-error-descriptivos.md` | f6ac529e | 3,104 | 0 |
| `canonical/RNF-BACK-051-paginacion-apis.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-051-paginacion-apis.md` | 90e10121 | 2,954 | 0 |
| `canonical/RNF-BACK-052-logs-estructurados.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-052-logs-estructurados.md` | 90339321 | 3,095 | 0 |
| `canonical/RNF-BACK-060-cobertura-tests.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-060-cobertura-tests.md` | 3a4cb2c1 | 3,325 | 0 |
| `canonical/RNF-BACK-061-complejidad-ciclomatica.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/RNF-BACK-061-complejidad-ciclomatica.md` | 93641561 | 4,946 | 0 |
| `canonical/ROADMAP_TDD_OPERATIVO.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/promptops/ROADMAP_TDD_OPERATIVO.md` | f32e749b | 13,267 | 0 |
| `canonical/SDLC_COMPLETE_RUN_TDD_PROMPTING_TECHNIQUES.md` | `temp-holding/FASE 01/docs/backend/SDLC_COMPLETE_RUN_TDD_PROMPTING_TECHNIQUES.md` | 18568977 | 12,267 | 0 |
| `canonical/SEARCH_OPTIMIZATION_TECHNIQUES.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/promptops/SEARCH_OPTIMIZATION_TECHNIQUES.md` | e41d1c74 | 19,764 | 0 |
| `canonical/TASK-002-LOG.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-002-crear-estructura-carpetas-nuevas/evidencias/TASK-002-LOG.md` | d1b74f00 | 2,674 | 0 |
| `canonical/TASK-002-validar_restricciones_criticas.md` | `temp-holding/FASE 01/docs/backend/TASK-002-validar_restricciones_criticas.md` | ff4f4a98 | 2,520 | 0 |
| `canonical/TASK-003-LOG.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-003-crear-readmes-carpetas-nuevas/evidencias/TASK-003-LOG.md` | 1bac73f3 | 6,049 | 0 |
| `canonical/TASK-003-verificar_sessionengine_en_settings.md` | `temp-holding/FASE 01/docs/backend/TASK-003-verificar_sessionengine_en_settings.md` | 9e7a9786 | 2,315 | 0 |
| `canonical/TASK-004-LOG.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-004-actualizar-gitkeep/evidencias/TASK-004-LOG.md` | defffc4d | 3,302 | 0 |
| `canonical/TASK-005-LOG.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-005-documentar-plan-migracion/evidencias/TASK-005-LOG.md` | fbc0ea2d | 7,782 | 0 |
| `canonical/TASK-006-identificacion-decisiones-arquitectonicas.md` | `temp-holding/FASE 01/docs/backend/gobernanza/adr/evidencias/TASK-006-identificacion-decisiones-arquitectonicas.md` | a6b3b255 | 7,515 | 0 |
| `canonical/TASK-010-validacion-chain-of-verification.md` | `temp-holding/FASE 01/docs/backend/gobernanza/adr/evidencias/TASK-010-validacion-chain-of-verification.md` | 3cb5cc10 | 14,978 | 0 |
| `canonical/TASK-021-alerting_system.md` | `temp-holding/FASE 01/docs/backend/TASK-021-alerting_system.md` | 2df5ca21 | 3,266 | 0 |
| `canonical/TASK-022-performance_optimization.md` | `temp-holding/FASE 01/docs/backend/TASK-022-performance_optimization.md` | 5586335f | 5,872 | 0 |
| `canonical/TASK-027-advanced_analytics.md` | `temp-holding/FASE 01/docs/backend/TASK-027-advanced_analytics.md` | 45c7a6ef | 11,627 | 0 |
| `canonical/TASK-030-api_rate_limiting.md` | `temp-holding/FASE 01/docs/backend/TASK-030-api_rate_limiting.md` | 50860064 | 2,098 | 0 |
| `canonical/TASK-031-api_versioning.md` | `temp-holding/FASE 01/docs/backend/TASK-031-api_versioning.md` | 69856d6d | 2,316 | 0 |
| `canonical/TASK-032-integration_tests_suite.md` | `temp-holding/FASE 01/docs/backend/TASK-032-integration_tests_suite.md` | 73e1f236 | 10,045 | 0 |
| `canonical/TASK-035-performance_benchmarking.md` | `temp-holding/FASE 01/docs/backend/TASK-035-performance_benchmarking.md` | 0c4d2940 | 15,583 | 0 |
| `canonical/TASK-037-load_testing.md` | `temp-holding/FASE 01/docs/backend/TASK-037-load_testing.md` | 541939f8 | 10,527 | 0 |
| `canonical/TDD-metodologia.md` | `temp-holding/FASE 01/docs/backend/metodologias/TDD-metodologia.md` | 7ce1f389 | 4,171 | 0 |
| `canonical/TDD_ERRORS_AND_SOLUTIONS.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/promptops/TDD_ERRORS_AND_SOLUTIONS.md` | 9689ee8e | 14,317 | 0 |
| `canonical/TDD_IMPLEMENTACION.md` | `temp-holding/FASE 01/docs/backend/TDD_IMPLEMENTACION.md` | 2d3a63d8 | 15,495 | 0 |
| `canonical/TODO.md` | `temp-holding/FASE 01/docs/backend/TODO.md` | bc78905f | 15,576 | 0 |
| `canonical/UC-001-ejemplo.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_usuario/casos_uso/UC-001-ejemplo.md` | f13299ee | 1,004 | 0 |
| `canonical/UC-PERM-001_asignar_grupo_a_usuario.md` | `temp-holding/FASE 01/docs/backend/UC-PERM-001_asignar_grupo_a_usuario.md` | 54c2cc09 | 11,269 | 0 |
| `canonical/UC-PERM-002_revocar_grupo_a_usuario.md` | `temp-holding/FASE 01/docs/backend/UC-PERM-002_revocar_grupo_a_usuario.md` | 859ff6c4 | 9,544 | 0 |
| `canonical/UC-PERM-003_conceder_permiso_excepcional.md` | `temp-holding/FASE 01/docs/backend/UC-PERM-003_conceder_permiso_excepcional.md` | 03ef7d56 | 8,498 | 0 |
| `canonical/UC-PERM-004_revocar_permiso_excepcional.md` | `temp-holding/FASE 01/docs/backend/UC-PERM-004_revocar_permiso_excepcional.md` | 027e4e90 | 4,224 | 0 |
| `canonical/UC-PERM-005_crear_grupo_permisos.md` | `temp-holding/FASE 01/docs/backend/UC-PERM-005_crear_grupo_permisos.md` | b960bd53 | 3,205 | 0 |
| `canonical/UC-PERM-006_asignar_capacidades_grupo.md` | `temp-holding/FASE 01/docs/backend/UC-PERM-006_asignar_capacidades_grupo.md` | 385f0399 | 1,908 | 0 |
| `canonical/UC-PERM-007_verificar_permiso_usuario.md` | `temp-holding/FASE 01/docs/backend/UC-PERM-007_verificar_permiso_usuario.md` | e9769a6b | 2,734 | 0 |
| `canonical/UC-PERM-008_generar_menu_dinamico.md` | `temp-holding/FASE 01/docs/backend/UC-PERM-008_generar_menu_dinamico.md` | ce7aa096 | 2,754 | 0 |
| `canonical/UC-PERM-010_consultar_auditoria.md` | `temp-holding/FASE 01/docs/backend/UC-PERM-010_consultar_auditoria.md` | f03e0959 | 6,418 | 0 |
| `canonical/VALIDACION-TRAZABILIDAD-COMPLETA.md` | `temp-holding/FASE 01/docs/backend/trazabilidad/VALIDACION-TRAZABILIDAD-COMPLETA.md` | ff4827f0 | 12,036 | 0 |
| `canonical/VALIDACION_API_CALLCENTERSITE.md` | `temp-holding/FASE 01/docs/backend/validaciones/VALIDACION_API_CALLCENTERSITE.md` | 554421a2 | 19,027 | 0 |
| `canonical/VALIDACION_RAPIDA.md` | `temp-holding/FASE 01/docs/backend/validaciones/VALIDACION_RAPIDA.md` | 4840fa2f | 4,165 | 0 |
| `canonical/_MOVIDO_A_IMPLEMENTACION.md` | `temp-holding/FASE 01/docs/backend/requisitos/_MOVIDO_A_IMPLEMENTACION.md` | db33ed32 | 2,478 | 0 |
| `canonical/actores.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_usuario/casos_uso/actores.md` | 2a990e72 | 766 | 0 |
| `canonical/analisis_arquitectura_2025-11-11.md` | `temp-holding/FASE 01/docs/backend/sesiones/2025-11-11/analisis_arquitectura_2025-11-11.md` | 1c84f937 | 8,779 | 0 |
| `canonical/analisis_congruencia_docs_codigo.md` | `temp-holding/FASE 01/docs/backend/analisis_congruencia_docs_codigo.md` | c3ddd6c8 | 16,869 | 0 |
| `canonical/analytics.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/analytics.md` | f04c17df | 601 | 0 |
| `canonical/arquitectura_permisos_granular.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/arquitectura_permisos_granular.md` | 41f701b0 | 12,871 | 0 |
| `canonical/audit.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/audit.md` | 7622a262 | 6,780 | 0 |
| `canonical/authentication.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/authentication.md` | 464eef81 | 9,862 | 0 |
| `canonical/backup-commit-hash.txt` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-001-crear-backup-completo/evidencias/backup-commit-hash.txt` | c2a7a14d | 41 | 0 |
| `canonical/calculos.md` | `temp-holding/FASE 01/docs/backend/requisitos/reglas_negocio/calculos.md` | 6903ac76 | 889 | 0 |
| `canonical/calidad_codigo_automatizacion.md` | `temp-holding/FASE 01/docs/backend/calidad_codigo_automatizacion.md` | 33b37b66 | 13,838 | 0 |
| `canonical/call_center_privilege_models.py` | `temp-holding/Modules/call_center_privilege_models.py` | 01fe1302 | 11,926 | 0 |
| `canonical/call_center_privilege_service.py` | `temp-holding/Modules/call_center_privilege_service.py` | 9477d7aa | 12,726 | 0 |
| `canonical/carpetas-nuevas.txt` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-002-crear-estructura-carpetas-nuevas/evidencias/carpetas-nuevas.txt` | fc96117b | 301 | 0 |
| `canonical/clean-architecture.md` | `temp-holding/FASE 01/docs/backend/metodologias/clean-architecture.md` | 80922d64 | 5,399 | 0 |
| `canonical/common.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/common.md` | 878ce535 | 788 | 0 |
| `canonical/configuration.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/configuration.md` | 060f23aa | 14,836 | 0 |
| `canonical/dashboard.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/dashboard.md` | 8bcda242 | 620 | 0 |
| `canonical/decoradores_y_middleware_permisos.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/decoradores_y_middleware_permisos.md` | 53e688e3 | 23,577 | 0 |
| `canonical/department_privilege_system.py` | `temp-holding/Modules/department_privilege_system.py` | 066b7177 | 11,970 | 0 |
| `canonical/desencadenadores.md` | `temp-holding/FASE 01/docs/backend/requisitos/reglas_negocio/desencadenadores.md` | 43a43b09 | 897 | 0 |
| `canonical/diseno_tecnico_autenticacion.md` | `temp-holding/FASE 01/docs/backend/diseno/detallado/diseno_tecnico_autenticacion.md` | d126f879 | 30,576 | 0 |
| `canonical/django-drf.md` | `temp-holding/FASE 01/docs/backend/referencias/django-drf.md` | 4e3d4f3a | 3,388 | 0 |
| `canonical/ejemplos_rest_apis.md` | `temp-holding/FASE 01/docs/backend/diseno/api/ejemplos_rest_apis.md` | 13b8e6f5 | 53,718 | 0 |
| `canonical/estado_generacion.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 3 - 9/estado_generacion.txt` | 2b1a4081 | 2,470 | 0 |
| `canonical/feasibility_analysis.md` | `temp-holding/FASE 01/docs/backend/planificacion/feasibility/feasibility_analysis.md` | 28cd358e | 7,375 | 0 |
| `canonical/git-status-sample.txt` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-004-actualizar-gitkeep/evidencias/git-status-sample.txt` | 4cd54bea | 391 | 0 |
| `canonical/guia_decision_patrones.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/guia_decision_patrones.md` | 4e9d4af0 | 10,519 | 0 |
| `canonical/hechos.md` | `temp-holding/FASE 01/docs/backend/requisitos/reglas_negocio/hechos.md` | 1b9209b3 | 772 | 0 |
| `canonical/implementacion_permisos_granular.md` | `temp-holding/FASE 01/docs/backend/implementacion_permisos_granular.md` | ba071a23 | 7,675 | 0 |
| `canonical/inferencias.md` | `temp-holding/FASE 01/docs/backend/requisitos/reglas_negocio/inferencias.md` | 0993092a | 890 | 0 |
| `canonical/ivr_legacy.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/ivr_legacy.md` | 897e1add | 797 | 0 |
| `canonical/management_commands.md` | `temp-holding/FASE 01/docs/backend/management_commands.md` | 7cf9fd66 | 17,212 | 0 |
| `canonical/management_commands_permisos.md` | `temp-holding/FASE 01/docs/backend/management_commands_permisos.md` | 764d8c11 | 10,366 | 0 |
| `canonical/mapeo-stats.txt` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-005-documentar-plan-migracion/evidencias/mapeo-stats.txt` | 32eeeecc | 109 | 0 |
| `canonical/migrations_strategy.md` | `temp-holding/FASE 01/docs/backend/diseno/database/migrations_strategy.md` | 98c0f7b3 | 14,768 | 0 |
| `canonical/module_initial_data.py` | `temp-holding/Modules/module_initial_data.py` | 1080a1d4 | 14,015 | 0 |
| `canonical/module_system_admin.py` | `temp-holding/Modules/module_system_admin.py` | 12a7679a | 11,929 | 0 |
| `canonical/module_system_models.py` | `temp-holding/Modules/module_system_models.py` | 47c24927 | 14,846 | 0 |
| `canonical/module_system_permissions.py` | `temp-holding/Modules/module_system_permissions.py` | 81112dd3 | 9,317 | 0 |
| `canonical/module_system_serializers.py` | `temp-holding/Modules/module_system_serializers.py` | e39f56a2 | 13,800 | 0 |
| `canonical/module_system_urls.py` | `temp-holding/Modules/module_system_urls.py` | 41b89949 | 1,386 | 0 |
| `canonical/module_system_views.py` | `temp-holding/Modules/module_system_views.py` | 20cb4d37 | 23,474 | 0 |
| `canonical/n001_visibilidad_metricas_ivr_tiempo_real.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_negocio/n001_visibilidad_metricas_ivr_tiempo_real.md` | 91581d9e | 17,123 | 0 |
| `canonical/n002_datos_actualizados_toma_decisiones.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_negocio/n002_datos_actualizados_toma_decisiones.md` | bfae7215 | 3,170 | 0 |
| `canonical/n003_visibilidad_metricas_operativas.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_negocio/n003_visibilidad_metricas_operativas.md` | 34e94f40 | 2,635 | 0 |
| `canonical/n004_metricas_dora_ingenieria_software.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_negocio/n004_metricas_dora_ingenieria_software.md` | 0e16c388 | 15,995 | 0 |
| `canonical/notifications.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/notifications.md` | dc395519 | 697 | 0 |
| `canonical/observability_layers.md` | `temp-holding/FASE 01/docs/backend/observability_layers.md` | e1b8b7dd | 13,447 | 0 |
| `canonical/openapi_permisos.yaml` | `temp-holding/FASE 01/docs/backend/diseno/api/openapi_permisos.yaml` | 64766d3b | 24,231 | 0 |
| `canonical/openapi_prioridad_02.yaml` | `temp-holding/FASE 01/docs/backend/diseno/api/openapi_prioridad_02.yaml` | 60aaf038 | 20,783 | 0 |
| `canonical/patrones_arquitectonicos.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/patrones_arquitectonicos.md` | 35790561 | 38,943 | 0 |
| `canonical/perfiles_usuario.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_usuario/perfiles_usuario.md` | f175401d | 744 | 0 |
| `canonical/permisos_granular.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/permisos_granular.md` | 7a92d1ca | 18,720 | 0 |
| `canonical/plan_maestro_prioridad_02.md` | `temp-holding/FASE 01/docs/backend/plan_maestro_prioridad_02.md` | b4d51fc8 | 24,037 | 0 |
| `canonical/planificacion_documentacion.md` | `temp-holding/FASE 01/docs/backend/planificacion_documentacion.md` | ccc20836 | 32,768 | 0 |
| `canonical/planning_output.md` | `temp-holding/FASE 01/docs/backend/planificacion/planning/planning_output.md` | b35e7ca8 | 4,916 | 0 |
| `canonical/plantilla-adr-backend.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/decisions/plantilla-adr-backend.md` | d9d855c3 | 9,560 | 1 |
| `canonical/plantilla-procedimiento-backend.md` | `temp-holding/FASE 01/docs/backend/plantillas/documentacion/plantilla-procedimiento-backend.md` | cf2f26d7 | 13,328 | 1 |
| `canonical/plantilla_api_reference.md` | `temp-holding/FASE 01/docs/backend/plantilla_api_reference.md` | 29a218fe | 472 | 1 |
| `canonical/plantilla_database_design.md` | `temp-holding/FASE 01/docs/backend/diseno/database/plantilla_database_design.md` | 2376dd52 | 542 | 0 |
| `canonical/plantilla_plan.md` | `temp-holding/FASE 01/docs/backend/plantilla_plan.md` | 8d6025b7 | 21,031 | 1 |
| `canonical/plantilla_spec.md` | `temp-holding/FASE 01/docs/backend/plantilla_spec.md` | 58ab90d6 | 11,140 | 1 |
| `canonical/plantilla_tdd.md` | `temp-holding/FASE 01/docs/backend/plantilla_tdd.md` | 6abbbedb | 631 | 1 |
| `canonical/prioridad_01_estructura_base_datos.md` | `temp-holding/FASE 01/docs/backend/requisitos/prioridad_01_estructura_base_datos.md` | 9eb78eb6 | 22,015 | 0 |
| `canonical/prioridad_02_funciones_core.md` | `temp-holding/FASE 01/docs/backend/requisitos/prioridad_02_funciones_core.md` | 649ddfd1 | 26,301 | 0 |
| `canonical/prioridad_03_modulos_operativos.md` | `temp-holding/FASE 01/docs/backend/requisitos/prioridad_03_modulos_operativos.md` | 71b25e9d | 24,076 | 0 |
| `canonical/prioridad_04_modulos_gestion.md` | `temp-holding/FASE 01/docs/backend/requisitos/prioridad_04_modulos_gestion.md` | 3a09aee0 | 22,663 | 0 |
| `canonical/privilege_flow_diagram.py` | `temp-holding/Modules/privilege_flow_diagram.py` | e99b5ed1 | 11,087 | 0 |
| `canonical/pytest_environment_fix.md` | `temp-holding/FASE 01/docs/backend/pytest_environment_fix.md` | 23159426 | 8,036 | 0 |
| `canonical/readmes-creados.txt` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-003-crear-readmes-carpetas-nuevas/evidencias/readmes-creados.txt` | 239d5e47 | 262 | 0 |
| `canonical/reporte_intermedio_01.md` | `temp-holding/FASE 01/docs/backend/reporte_intermedio_01.md` | 61e9ba4c | 15,872 | 0 |
| `canonical/reports.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/reports.md` | 09a40855 | 593 | 0 |
| `canonical/requirements.txt` | `temp-holding/FASE 01/docs/requirements.txt` | 68d1547f | 250 | 0 |
| `canonical/restricciones.md` | `temp-holding/FASE 01/docs/backend/requisitos/reglas_negocio/restricciones.md` | 42fcdc86 | 900 | 0 |
| `canonical/restricciones_y_lineamientos.md` | `temp-holding/FASE 01/docs/backend/requisitos/restricciones_y_lineamientos.md` | 086713e9 | 23,167 | 0 |
| `canonical/resumen_implementacion_completa.md` | `temp-holding/FASE 01/docs/backend/resumen_implementacion_completa.md` | a93e5a39 | 13,885 | 0 |
| `canonical/rf001_evaluacion_permisos_tres_niveles.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf001_evaluacion_permisos_tres_niveles.md` | 9081006e | 10,066 | 0 |
| `canonical/rf001_login_credenciales.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf001_login_credenciales.md` | 7b115727 | 7,422 | 0 |
| `canonical/rf002_gestion_permisos_granulares.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf002_gestion_permisos_granulares.md` | 1bdfd481 | 3,540 | 0 |
| `canonical/rf002_jwt_tokens.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf002_jwt_tokens.md` | 45b81ec5 | 1,365 | 0 |
| `canonical/rf003_bloqueo_intentos_fallidos.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf003_bloqueo_intentos_fallidos.md` | 8f0ade75 | 1,453 | 0 |
| `canonical/rf003_obtener_permisos_efectivos_usuario.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf003_obtener_permisos_efectivos_usuario.md` | 1a616dfa | 4,279 | 0 |
| `canonical/rf004_segmentos_criterios_dinamicos.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf004_segmentos_criterios_dinamicos.md` | 1777b014 | 5,298 | 0 |
| `canonical/rf004_sesion_unica.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf004_sesion_unica.md` | e02c2e96 | 1,351 | 0 |
| `canonical/rf005_login_credenciales_locales.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf005_login_credenciales_locales.md` | 00ba4f22 | 16,896 | 0 |
| `canonical/rf005_logout.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf005_logout.md` | ce98a43c | 1,301 | 0 |
| `canonical/rf006_recuperacion_sin_email.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf006_recuperacion_sin_email.md` | 5f497ee3 | 1,629 | 0 |
| `canonical/rf006_tokens_jwt.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf006_tokens_jwt.md` | fa8de4f7 | 18,363 | 0 |
| `canonical/rf007_logout_manual.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf007_logout_manual.md` | 0e1fce3b | 12,566 | 0 |
| `canonical/rf008_cierre_inactividad.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf008_cierre_inactividad.md` | 0d4fbc9f | 15,680 | 0 |
| `canonical/rf009_gestion_passwords_intentos_fallidos.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf009_gestion_passwords_intentos_fallidos.md` | 26e7b6e3 | 19,527 | 0 |
| `canonical/rf010_sesion_unica.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf010_sesion_unica.md` | 6b2918e2 | 17,699 | 0 |
| `canonical/rf020_registrar_ciclos_desarrollo_dora.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf020_registrar_ciclos_desarrollo_dora.md` | 5de0377d | 12,489 | 0 |
| `canonical/rf021_calcular_deployment_frequency.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf021_calcular_deployment_frequency.md` | 90771761 | 3,632 | 0 |
| `canonical/rf022_calcular_lead_time.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf022_calcular_lead_time.md` | 88b30615 | 4,217 | 0 |
| `canonical/rf023_calcular_change_failure_rate.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf023_calcular_change_failure_rate.md` | 17a6dae3 | 5,051 | 0 |
| `canonical/rf024_calcular_mttr.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf024_calcular_mttr.md` | 6542d1e9 | 6,919 | 0 |
| `canonical/rf025_clasificar_performance_dora.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf025_clasificar_performance_dora.md` | 167c2a83 | 11,512 | 0 |
| `canonical/rf026_dashboard_metricas_dora.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf026_dashboard_metricas_dora.md` | 6df76bb4 | 13,786 | 0 |
| `canonical/rf027_exportar_reportes_dora.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf027_exportar_reportes_dora.md` | a61bb006 | 17,450 | 0 |
| `canonical/rf028_data_catalog_index.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf028_data_catalog_index.md` | 1b02361f | 17,780 | 0 |
| `canonical/rf029_query_dora_metrics_dataset.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf029_query_dora_metrics_dataset.md` | f0123ee8 | 8,424 | 0 |
| `canonical/rf030_query_deployment_cycles.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf030_query_deployment_cycles.md` | b5d532c8 | 5,148 | 0 |
| `canonical/rf031_aggregated_stats.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/rf031_aggregated_stats.md` | b72ce96e | 5,403 | 0 |
| `canonical/rn001_sistema_seguridad_auditoria_conforme_iso27001.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_negocio/rn001_sistema_seguridad_auditoria_conforme_iso27001.md` | af5cdf8c | 17,768 | 0 |
| `canonical/rn004_metricas_dora_performance_ingenieria.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_negocio/rn004_metricas_dora_performance_ingenieria.md` | ba639277 | 9,977 | 0 |
| `canonical/rn_c01_autenticacion_sesiones.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_negocio/rn_c01_autenticacion_sesiones.md` | 5918ce11 | 44,960 | 0 |
| `canonical/rnf001_tiempo_respuesta_login.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/rnf001_tiempo_respuesta_login.md` | af781ffa | 1,618 | 0 |
| `canonical/rnf002_sesiones_en_bd.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/rnf002_sesiones_en_bd.md` | a7c3df1f | 1,434 | 0 |
| `canonical/roadmap-backend.md` | `temp-holding/FASE 01/docs/backend/vision-y-estrategia/roadmap-backend.md` | 62c1c4ff | 2,513 | 0 |
| `canonical/route_lint.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/promptops/gates/route_lint.md` | 2222ebff | 11,393 | 0 |
| `canonical/rq_plantilla.md` | `temp-holding/FASE 01/docs/backend/requisitos/rq_plantilla.md` | d8f60393 | 794 | 0 |
| `canonical/rs001_auditoria_requiere_trazabilidad_completa.md` | `temp-holding/FASE 01/docs/backend/requisitos/stakeholders/rs001_auditoria_requiere_trazabilidad_completa.md` | f9c76e7f | 13,713 | 0 |
| `canonical/rs002_reportes_automatizados_compliance.md` | `temp-holding/FASE 01/docs/backend/requisitos/stakeholders/rs002_reportes_automatizados_compliance.md` | ebe6fcf3 | 9,857 | 0 |
| `canonical/rs002_usuarios_requieren_acceso_rapido.md` | `temp-holding/FASE 01/docs/backend/requisitos/stakeholders/rs002_usuarios_requieren_acceso_rapido.md` | 3bff40e6 | 10,719 | 0 |
| `canonical/tdd_operativo.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/promptops/meta/tdd_operativo.md` | 85d726a4 | 16,339 | 0 |
| `canonical/template_requisito_funcional.md` | `temp-holding/FASE 01/docs/backend/template_requisito_funcional.md` | 012c8e34 | 13,332 | 0 |
| `canonical/test_use_cases.md` | `temp-holding/FASE 01/docs/backend/testing/test_use_cases.md` | e5cdc963 | 14,706 | 0 |
| `canonical/testing_strategy.md` | `temp-holding/FASE 01/docs/backend/testing/testing_strategy.md` | 89bc958c | 5,269 | 0 |
| `canonical/trazabilidad.md` | `temp-holding/FASE 01/docs/backend/requisitos/trazabilidad.md` | 315467d9 | 757 | 0 |
| `canonical/updated_main_urls.py` | `temp-holding/Modules/updated_main_urls.py` | b3eeef8a | 2,766 | 0 |
| `canonical/users.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/users.md` | 644f5ba4 | 5,064 | 0 |
| `canonical/vision-backend-2025.md` | `temp-holding/FASE 01/docs/backend/vision-y-estrategia/vision-backend-2025.md` | ce580a79 | 5,198 | 0 |

## Variantes

| Destino | Origen | Hash | Bytes |
|---------|--------|------|-------|
| `variants/temp-holding/FASE 01/docs/backend/README.md` | `temp-holding/FASE 01/docs/backend/README.md` | df941ced | 4,521 |
| `variants/temp-holding/FASE 01/docs/backend/analisis_cobertura_requisitos.md` | `temp-holding/FASE 01/docs/backend/analisis_cobertura_requisitos.md` | 56e4c1ab | 12,719 |
| `variants/temp-holding/FASE 01/docs/backend/catalogos/README.md` | `temp-holding/FASE 01/docs/backend/catalogos/README.md` | 2821150e | 1,781 |
| `variants/temp-holding/FASE 01/docs/backend/diseno/README.md` | `temp-holding/FASE 01/docs/backend/diseno/README.md` | 2cc68e07 | 8,040 |
| `variants/temp-holding/FASE 01/docs/backend/diseno/api/README.md` | `temp-holding/FASE 01/docs/backend/diseno/api/README.md` | cd5eb058 | 2,213 |
| `variants/temp-holding/FASE 01/docs/backend/diseno/arquitectura/README.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/README.md` | fd9dfda5 | 2,287 |
| `variants/temp-holding/FASE 01/docs/backend/diseno/arquitectura/decisions/README.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/decisions/README.md` | 6b20d971 | 5,877 |
| `variants/temp-holding/FASE 01/docs/backend/diseno/arquitectura/lineamientos_codigo.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/lineamientos_codigo.md` | 052427ac | 706 |
| `variants/temp-holding/FASE 01/docs/backend/diseno/database/README.md` | `temp-holding/FASE 01/docs/backend/diseno/database/README.md` | 2bfb7162 | 4,533 |
| `variants/temp-holding/FASE 01/docs/backend/diseno/detallado/README.md` | `temp-holding/FASE 01/docs/backend/diseno/detallado/README.md` | b725e995 | 4,839 |
| `variants/temp-holding/FASE 01/docs/backend/diseno/permisos/README.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/README.md` | 2f9e27a0 | 5,542 |
| `variants/temp-holding/FASE 01/docs/backend/diseno/permisos/promptops/README.md` | `temp-holding/FASE 01/docs/backend/diseno/permisos/promptops/README.md` | 6364074c | 6,170 |
| `variants/temp-holding/FASE 01/docs/backend/ejemplos/README.md` | `temp-holding/FASE 01/docs/backend/ejemplos/README.md` | 3b2caedc | 775 |
| `variants/temp-holding/FASE 01/docs/backend/estilos/README.md` | `temp-holding/FASE 01/docs/backend/estilos/README.md` | aa84e64d | 1,894 |
| `variants/temp-holding/FASE 01/docs/backend/gobernanza/README.md` | `temp-holding/FASE 01/docs/backend/gobernanza/README.md` | 4aac9dec | 2,215 |
| `variants/temp-holding/FASE 01/docs/backend/guias/README.md` | `temp-holding/FASE 01/docs/backend/guias/README.md` | c7addac0 | 321 |
| `variants/temp-holding/FASE 01/docs/backend/lineamientos_codigo.md` | `temp-holding/FASE 01/docs/backend/lineamientos_codigo.md` | b66b6b02 | 10,070 |
| `variants/temp-holding/FASE 01/docs/backend/metodologias/README.md` | `temp-holding/FASE 01/docs/backend/metodologias/README.md` | 6ba398f9 | 1,013 |
| `variants/temp-holding/FASE 01/docs/backend/planificacion/releases/README.md` | `temp-holding/FASE 01/docs/backend/planificacion/releases/README.md` | d1ef79ec | 199 |
| `variants/temp-holding/FASE 01/docs/backend/plans/README.md` | `temp-holding/FASE 01/docs/backend/plans/README.md` | 5a49cd5a | 321 |
| `variants/temp-holding/FASE 01/docs/backend/plantillas/README.md` | `temp-holding/FASE 01/docs/backend/plantillas/README.md` | 1e1c9f41 | 5,440 |
| `variants/temp-holding/FASE 01/docs/backend/plantillas/cicd/README.md` | `temp-holding/FASE 01/docs/backend/plantillas/cicd/README.md` | dfd2b342 | 308 |
| `variants/temp-holding/FASE 01/docs/backend/plantillas/codigo/README.md` | `temp-holding/FASE 01/docs/backend/plantillas/codigo/README.md` | 35da91a1 | 479 |
| `variants/temp-holding/FASE 01/docs/backend/plantillas/colaboracion/README.md` | `temp-holding/FASE 01/docs/backend/plantillas/colaboracion/README.md` | 65959925 | 353 |
| `variants/temp-holding/FASE 01/docs/backend/plantillas/documentacion/README.md` | `temp-holding/FASE 01/docs/backend/plantillas/documentacion/README.md` | f76b5eb8 | 618 |
| `variants/temp-holding/FASE 01/docs/backend/plantillas/infraestructura/README.md` | `temp-holding/FASE 01/docs/backend/plantillas/infraestructura/README.md` | 2277bb67 | 349 |
| `variants/temp-holding/FASE 01/docs/backend/procedimientos/README.md` | `temp-holding/FASE 01/docs/backend/procedimientos/README.md` | 279f07d1 | 1,141 |
| `variants/temp-holding/FASE 01/docs/backend/procedures/README.md` | `temp-holding/FASE 01/docs/backend/procedures/README.md` | 327e66ed | 10,727 |
| `variants/temp-holding/FASE 01/docs/backend/procesos/README.md` | `temp-holding/FASE 01/docs/backend/procesos/README.md` | c814a7b7 | 2,629 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/README.md` | a67a03ce | 22,213 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-001-crear-backup-completo/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-001-crear-backup-completo/README.md` | 00fbbb0d | 4,879 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-002-crear-estructura-carpetas-nuevas/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-002-crear-estructura-carpetas-nuevas/README.md` | 10509e14 | 4,422 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-003-crear-readmes-carpetas-nuevas/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-003-crear-readmes-carpetas-nuevas/README.md` | da76e564 | 2,236 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-004-actualizar-gitkeep/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-004-actualizar-gitkeep/README.md` | f481aa4e | 1,531 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-005-documentar-plan-migracion/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-005-documentar-plan-migracion/README.md` | bd1d6714 | 2,092 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-006-identificar-decisiones-arquitectonicas/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-006-identificar-decisiones-arquitectonicas/README.md` | 536c57bd | 11,404 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-007-crear-adrs-formales/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-007-crear-adrs-formales/README.md` | 51cbbd33 | 12,033 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-008-agregar-metadatos-yaml-adrs/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-008-agregar-metadatos-yaml-adrs/README.md` | 4d498e33 | 13,978 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/README.md` | 1a81f7b4 | 16,633 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/evidencias/INVENTARIO-ADRS.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/evidencias/INVENTARIO-ADRS.md` | 990e82ec | 11,162 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/evidencias/RESUMEN-EJECUCION.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/evidencias/RESUMEN-EJECUCION.md` | ce493335 | 8,059 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/evidencias/VALIDACION-INDICE.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/evidencias/VALIDACION-INDICE.md` | 0c99afd7 | 9,919 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-010-validar-adrs-creados/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-010-validar-adrs-creados/README.md` | 12f8a384 | 19,869 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-010-validar-adrs-creados/evidencias/INVENTARIO-ADRS.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-010-validar-adrs-creados/evidencias/INVENTARIO-ADRS.md` | a7ac28c6 | 3,244 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-010-validar-adrs-creados/evidencias/RESUMEN-EJECUCION.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-010-validar-adrs-creados/evidencias/RESUMEN-EJECUCION.md` | 4d47bc7a | 4,893 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-010-validar-adrs-creados/evidencias/VALIDACION-INDICE.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-010-validar-adrs-creados/evidencias/VALIDACION-INDICE.md` | 95ab0d58 | 3,507 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-011-crear-subcarpetas-en-diseno/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-011-crear-subcarpetas-en-diseno/README.md` | 3b26c3db | 7,271 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-012-mover-api-rest-apis-a-diseno-api/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-012-mover-api-rest-apis-a-diseno-api/README.md` | ab412b08 | 10,189 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-013-crear-readme-diseno-api/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-013-crear-readme-diseno-api/README.md` | fb5e7d2a | 10,016 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-014-mover-arquitectura-a-diseno-arquitectura/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-014-mover-arquitectura-a-diseno-arquitectura/README.md` | 74927a46 | 8,689 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-015-crear-readme-diseno-arquitectura/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-015-crear-readme-diseno-arquitectura/README.md` | 2c918051 | 8,657 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-016-mover-permisos-a-diseno-permisos/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-016-mover-permisos-a-diseno-permisos/README.md` | d1992b5f | 4,656 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-017-crear-readme-diseno-permisos/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-017-crear-readme-diseno-permisos/README.md` | 310e8bf8 | 6,502 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-018-mover-diseno-detallado-a-diseno-detallado/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-018-mover-diseno-detallado-a-diseno-detallado/README.md` | 750e4b54 | 5,130 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-018-mover-diseno-detallado-a-diseno-detallado/evidencias/ANALISIS-REFERENCIAS.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-018-mover-diseno-detallado-a-diseno-detallado/evidencias/ANALISIS-REFERENCIAS.md` | 80699753 | 14,072 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-018-mover-diseno-detallado-a-diseno-detallado/evidencias/RESUMEN-EJECUCION.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-018-mover-diseno-detallado-a-diseno-detallado/evidencias/RESUMEN-EJECUCION.md` | 81df9701 | 11,453 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-018-mover-diseno-detallado-a-diseno-detallado/evidencias/VALIDACION-ENLACES.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-018-mover-diseno-detallado-a-diseno-detallado/evidencias/VALIDACION-ENLACES.md` | 374195dd | 17,315 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-019-crear-readme-diseno-detallado/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-019-crear-readme-diseno-detallado/README.md` | e3095c28 | 6,036 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-020-crear-diseno-database/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-020-crear-diseno-database/README.md` | 94ddfc92 | 6,671 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-021-mover-archivos-relacionados-bd/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-021-mover-archivos-relacionados-bd/README.md` | 4941a30f | 11,630 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-022-crear-readme-diseno-database/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-022-crear-readme-diseno-database/README.md` | c7dafcea | 8,405 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-023-actualizar-readme-principal-diseno/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-023-actualizar-readme-principal-diseno/README.md` | 79ed635d | 16,341 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-023-actualizar-readme-principal-diseno/evidencias/ANALISIS-REFERENCIAS.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-023-actualizar-readme-principal-diseno/evidencias/ANALISIS-REFERENCIAS.md` | 4ff725cd | 3,440 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-023-actualizar-readme-principal-diseno/evidencias/RESUMEN-EJECUCION.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-023-actualizar-readme-principal-diseno/evidencias/RESUMEN-EJECUCION.md` | c9bf6932 | 15,237 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-023-actualizar-readme-principal-diseno/evidencias/VALIDACION-ENLACES.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-023-actualizar-readme-principal-diseno/evidencias/VALIDACION-ENLACES.md` | 90e5fd26 | 6,436 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-024-validar-consolidacion-diseno/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-024-validar-consolidacion-diseno/README.md` | 5fe2ac29 | 22,252 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-025-crear-subcarpetas-planificacion/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-025-crear-subcarpetas-planificacion/README.md` | 486826b3 | 5,789 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-026-mover-feasibility/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-026-mover-feasibility/README.md` | e7b8a267 | 6,189 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-027-consolidar-planning-y-releases/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-027-consolidar-planning-y-releases/README.md` | 0d7a13cd | 9,784 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-028-mover-analisis-negocio/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-028-mover-analisis-negocio/README.md` | 7d44fd20 | 7,317 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-029-consolidar-analisis-general/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-029-consolidar-analisis-general/README.md` | 7fb14bc4 | 13,362 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-030-validar-consolidacion-planificacion/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-030-validar-consolidacion-planificacion/README.md` | 83c36508 | 15,867 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-031-catalogo-apis/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-031-catalogo-apis/README.md` | f7bc4e91 | 4,359 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-032-catalogo-servicios/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-032-catalogo-servicios/README.md` | 01b75446 | 5,462 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-033-catalogo-modelos/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-033-catalogo-modelos/README.md` | e6af0acd | 6,517 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-034-catalogo-endpoints/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-034-catalogo-endpoints/README.md` | 05900b3f | 8,670 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-035-proc-desarrollo-features/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-035-proc-desarrollo-features/README.md` | e883b53d | 10,771 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-036-proc-gestion-dependencias/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-036-proc-gestion-dependencias/README.md` | a4bc83fc | 12,909 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-037-indice-procesos/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-037-indice-procesos/README.md` | 378422b2 | 11,276 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-038-validar-procesos/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-038-validar-procesos/README.md` | 5602bd4c | 9,987 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-039-matriz-requisitos-tests/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-039-matriz-requisitos-tests/README.md` | be5d74bd | 14,647 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-040-matriz-requisitos-codigo/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-040-matriz-requisitos-codigo/README.md` | da44b89b | 17,274 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-041-actualizar-implementacion-scripts/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-041-actualizar-implementacion-scripts/README.md` | dd0c32b5 | 14,595 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-042-validar-trazabilidad/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-042-validar-trazabilidad/README.md` | db8f34d2 | 12,820 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-043-crear-plantilla-adr-backend/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-043-crear-plantilla-adr-backend/README.md` | 745a2e08 | 13,812 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-044-crear-plantilla-procedimiento-backend/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-044-crear-plantilla-procedimiento-backend/README.md` | 4bbcb970 | 19,952 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-045-consolidar-plantillas-existentes/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-045-consolidar-plantillas-existentes/README.md` | 3526589c | 19,624 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-046-crear-vision-backend-2025/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-046-crear-vision-backend-2025/README.md` | b42944e6 | 24,533 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-047-crear-roadmap-backend/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-047-crear-roadmap-backend/README.md` | 0754c011 | 33,990 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-048-crear-tdd-metodologia/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-048-crear-tdd-metodologia/README.md` | d3fb97de | 24,403 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-049-crear-clean-architecture/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-049-crear-clean-architecture/README.md` | ae52db0f | 9,641 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-050-crear-readme-metodologias/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-050-crear-readme-metodologias/README.md` | bdfc548f | 2,461 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-051-crear-referencias-tecnicas/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-051-crear-referencias-tecnicas/README.md` | 3f7be7ad | 3,219 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-052-crear-ejemplos-codigo/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-052-crear-ejemplos-codigo/README.md` | bb0186de | 5,514 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-053-crear-glosario-backend/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-053-crear-glosario-backend/README.md` | 432c3486 | 4,800 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-054-documentar-cicd-backend/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-054-documentar-cicd-backend/README.md` | 8a48ab5b | 12,915 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-055-validar-integridad-enlaces/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-055-validar-integridad-enlaces/README.md` | 3d80ea3d | 4,921 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-056-validar-readmes/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-056-validar-readmes/README.md` | 5843b56f | 6,945 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-057-validar-metadatos-yaml/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-057-validar-metadatos-yaml/README.md` | 311658ee | 8,595 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-058-validar-nomenclatura/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-058-validar-nomenclatura/README.md` | c86d9a2f | 9,654 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-059-eliminar-carpetas-legacy-vacias/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-059-eliminar-carpetas-legacy-vacias/README.md` | 8c1a3d21 | 10,014 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-060-actualizar-readme-principal/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-060-actualizar-readme-principal/README.md` | 00c24d0a | 9,938 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-061-actualizar-index/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-061-actualizar-index/README.md` | 11df5d87 | 12,287 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-062-crear-changelog/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-062-crear-changelog/README.md` | 497c11c4 | 14,981 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-063-crear-guia-navegacion-backend/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-063-crear-guia-navegacion-backend/README.md` | 6af26267 | 22,744 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-064-actualizar-gobernanza-readme/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-064-actualizar-gobernanza-readme/README.md` | cc5d5617 | 14,209 |
| `variants/temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-065-crear-documento-lecciones-aprendidas/README.md` | `temp-holding/FASE 01/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-065-crear-documento-lecciones-aprendidas/README.md` | a53f839f | 33,820 |
| `variants/temp-holding/FASE 01/docs/backend/qa/README.md` | `temp-holding/FASE 01/docs/backend/qa/README.md` | d1ef79ec | 199 |
| `variants/temp-holding/FASE 01/docs/backend/referencias/README.md` | `temp-holding/FASE 01/docs/backend/referencias/README.md` | 6ca3f6f7 | 3,008 |
| `variants/temp-holding/FASE 01/docs/backend/requirements_session_summary.md` | `temp-holding/FASE 01/docs/backend/requirements_session_summary.md` | 630a3335 | 16,617 |
| `variants/temp-holding/FASE 01/docs/backend/requisitos/README.md` | `temp-holding/FASE 01/docs/backend/requisitos/README.md` | e0208841 | 1,444 |
| `variants/temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/README.md` | `temp-holding/FASE 01/docs/backend/requisitos/atributos_calidad/README.md` | b2443d42 | 1,823 |
| `variants/temp-holding/FASE 01/docs/backend/requisitos/reglas_negocio/README.md` | `temp-holding/FASE 01/docs/backend/requisitos/reglas_negocio/README.md` | 332c1345 | 608 |
| `variants/temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/README.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_funcionales/README.md` | c6436272 | 794 |
| `variants/temp-holding/FASE 01/docs/backend/requisitos/requerimientos_negocio/README.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_negocio/README.md` | 17ad2ce1 | 660 |
| `variants/temp-holding/FASE 01/docs/backend/requisitos/requerimientos_usuario/README.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_usuario/README.md` | 8ede4f89 | 624 |
| `variants/temp-holding/FASE 01/docs/backend/requisitos/requerimientos_usuario/casos_uso/README.md` | `temp-holding/FASE 01/docs/backend/requisitos/requerimientos_usuario/casos_uso/README.md` | c43b9296 | 664 |
| `variants/temp-holding/FASE 01/docs/backend/sesiones/2025-11-11/analisis_cobertura_requisitos.md` | `temp-holding/FASE 01/docs/backend/sesiones/2025-11-11/analisis_cobertura_requisitos.md` | 07e8ddc4 | 12,552 |
| `variants/temp-holding/FASE 01/docs/backend/sesiones/2025-11-11/requirements_session_summary.md` | `temp-holding/FASE 01/docs/backend/sesiones/2025-11-11/requirements_session_summary.md` | 5e9868b2 | 16,505 |
| `variants/temp-holding/FASE 01/docs/backend/sesiones/README.md` | `temp-holding/FASE 01/docs/backend/sesiones/README.md` | 6dd9cf45 | 520 |
| `variants/temp-holding/FASE 01/docs/backend/solicitudes/README.md` | `temp-holding/FASE 01/docs/backend/solicitudes/README.md` | 85ab6388 | 345 |
| `variants/temp-holding/FASE 01/docs/backend/tareas/README.md` | `temp-holding/FASE 01/docs/backend/tareas/README.md` | 0cca84e4 | 325 |
| `variants/temp-holding/FASE 01/docs/backend/templates/README.md` | `temp-holding/FASE 01/docs/backend/templates/README.md` | 625a6826 | 2,878 |
| `variants/temp-holding/FASE 01/docs/backend/testing/README.md` | `temp-holding/FASE 01/docs/backend/testing/README.md` | aacac11b | 768 |
| `variants/temp-holding/FASE 01/docs/backend/trazabilidad/README.md` | `temp-holding/FASE 01/docs/backend/trazabilidad/README.md` | add8cd15 | 3,652 |
| `variants/temp-holding/FASE 01/docs/backend/vision_y_alcance/README.md` | `temp-holding/FASE 01/docs/backend/vision_y_alcance/README.md` | 00f94d22 | 3,960 |

