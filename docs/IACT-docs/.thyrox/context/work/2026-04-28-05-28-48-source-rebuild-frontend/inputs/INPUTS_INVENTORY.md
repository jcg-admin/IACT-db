```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-48-source-rebuild-frontend
phase: Phase 1 — DISCOVER (input staging)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Inventory — WP frontend

Documentos pre-staged desde `temp-backup/` y `temp-holding/`. Solo estos archivos deben consultarse para el analisis de este WP — evita buscar en todo `temp-*`.

## Convencion

- `canonical/` — un solo archivo por concepto (MD5 deduplicado, preferencia: temp-backup > FASE 02 > FASE 01).
- `variants/` — archivos con mismo nombre pero contenido distinto, ruta espejo del origen para desambiguar.

## Resumen

- Canonicos: **31**
- Variantes: **15**
- Duplicados colapsados: **0**

- Tamano total stage: 269,707 bytes (263.4 KB)

## Canonicos

| Destino | Origen elegido | Hash | Bytes | Dups colapsados |
|---------|---------------|------|-------|----------------|
| `canonical/03_matrices_trazabilidad_iact.md` | `temp-holding/FASE 01/docs/frontend/analisis_negocio/marco_integrado/03_matrices_trazabilidad_iact.md` | d0740246 | 33,005 | 0 |
| `canonical/04_metodologia_analisis_iact.md` | `temp-holding/FASE 01/docs/frontend/analisis_negocio/marco_integrado/04_metodologia_analisis_iact.md` | 2454f9a4 | 23,748 | 0 |
| `canonical/ANALISIS_IDEMPOTENCIA_SCRIPTS.md` | `temp-holding/FASE 01/docs/frontend/ANALISIS_IDEMPOTENCIA_SCRIPTS.md` | dceeecf4 | 6,301 | 0 |
| `canonical/ANALISIS_REFACTORING_CPYTHON.md` | `temp-holding/FASE 01/docs/frontend/ANALISIS_REFACTORING_CPYTHON.md` | 3bd5f8dd | 36,218 | 0 |
| `canonical/INDEX.md` | `temp-holding/FASE 01/docs/frontend/INDEX.md` | a4ed8008 | 2,335 | 0 |
| `canonical/TASK-001-ejecutar_suite_completa_de_tests.md` | `temp-holding/FASE 01/docs/frontend/TASK-001-ejecutar_suite_completa_de_tests.md` | de8a0ce4 | 2,290 | 0 |
| `canonical/TASK-014-custom_dashboards_admin.md` | `temp-holding/FASE 01/docs/frontend/tareas/TASK-014-custom_dashboards_admin.md` | 97ad39d9 | 16,812 | 0 |
| `canonical/TASK-020-monitoring_dashboards.md` | `temp-holding/FASE 01/docs/frontend/tareas/TASK-020-monitoring_dashboards.md` | 290ad632 | 2,825 | 0 |
| `canonical/TODO.md` | `temp-holding/FASE 01/docs/frontend/arquitectura/TODO.md` | 80913bc4 | 6,748 | 0 |
| `canonical/UC-001-ejemplo.md` | `temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_usuario/casos_uso/UC-001-ejemplo.md` | d7695b7b | 1,014 | 0 |
| `canonical/UC-PERM-009_auditar_acceso.md` | `temp-holding/FASE 01/docs/frontend/UC-PERM-009_auditar_acceso.md` | 92e13e26 | 4,118 | 0 |
| `canonical/_necesidades_vinculadas.md` | `temp-holding/FASE 01/docs/frontend/requisitos/_necesidades_vinculadas.md` | 9fb78166 | 1,104 | 0 |
| `canonical/actores.md` | `temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_usuario/casos_uso/actores.md` | b9e891bd | 772 | 0 |
| `canonical/analisis_api_frontend.md` | `temp-holding/FASE 01/docs/frontend/arquitectura/analisis_api_frontend.md` | f8ecf1d0 | 15,526 | 0 |
| `canonical/calculos.md` | `temp-holding/FASE 01/docs/frontend/requisitos/reglas_negocio/calculos.md` | 17056f99 | 897 | 0 |
| `canonical/desencadenadores.md` | `temp-holding/FASE 01/docs/frontend/requisitos/reglas_negocio/desencadenadores.md` | e84e664b | 905 | 0 |
| `canonical/ejemplos_ui_design.md` | `temp-holding/FASE 01/docs/frontend/arquitectura/ejemplos_ui_design.md` | 3db84b71 | 8,633 | 0 |
| `canonical/estrategia_integracion_backend.md` | `temp-holding/FASE 01/docs/frontend/arquitectura/estrategia_integracion_backend.md` | 98303e38 | 7,925 | 0 |
| `canonical/hechos.md` | `temp-holding/FASE 01/docs/frontend/requisitos/reglas_negocio/hechos.md` | eda84c0e | 780 | 0 |
| `canonical/home.md` | `temp-holding/FASE 01/docs/frontend/arquitectura/home.md` | 86f4ef30 | 3,869 | 0 |
| `canonical/inferencias.md` | `temp-holding/FASE 01/docs/frontend/requisitos/reglas_negocio/inferencias.md` | d7dc3e84 | 898 | 0 |
| `canonical/integracion_permisos.md` | `temp-holding/FASE 01/docs/frontend/integracion_permisos.md` | 74b9937d | 24,689 | 0 |
| `canonical/microfrontends_canvas.md` | `temp-holding/FASE 01/docs/frontend/arquitectura/microfrontends_canvas.md` | 235e2748 | 13,678 | 0 |
| `canonical/perfiles_usuario.md` | `temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_usuario/perfiles_usuario.md` | e1509641 | 749 | 0 |
| `canonical/plantilla_ui_ux.md` | `temp-holding/FASE 01/docs/frontend/plantilla_ui_ux.md` | 62e333f3 | 460 | 0 |
| `canonical/restricciones.md` | `temp-holding/FASE 01/docs/frontend/requisitos/reglas_negocio/restricciones.md` | 1ae07cb1 | 908 | 0 |
| `canonical/rf010_pantalla_login.md` | `temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_funcionales/rf010_pantalla_login.md` | 86da70f1 | 1,589 | 0 |
| `canonical/rf011_cambio_password_ui.md` | `temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_funcionales/rf011_cambio_password_ui.md` | 4e8e6ed7 | 1,223 | 0 |
| `canonical/shared_webpack_configs.md` | `temp-holding/FASE 01/docs/frontend/arquitectura/shared_webpack_configs.md` | 228bb7ce | 5,376 | 0 |
| `canonical/template_requisito_stakeholder.md` | `temp-holding/FASE 01/docs/frontend/template_requisito_stakeholder.md` | b67d810d | 17,204 | 0 |
| `canonical/validacion_callcentersite_api.md` | `temp-holding/FASE 01/docs/frontend/arquitectura/validacion_callcentersite_api.md` | cf691cf4 | 8,970 | 0 |

## Variantes

| Destino | Origen | Hash | Bytes |
|---------|--------|------|-------|
| `variants/temp-holding/FASE 01/docs/frontend/README.md` | `temp-holding/FASE 01/docs/frontend/README.md` | 854b2e55 | 1,123 |
| `variants/temp-holding/FASE 01/docs/frontend/arquitectura/README.md` | `temp-holding/FASE 01/docs/frontend/arquitectura/README.md` | 0bc2ad88 | 3,417 |
| `variants/temp-holding/FASE 01/docs/frontend/checklists/README.md` | `temp-holding/FASE 01/docs/frontend/checklists/README.md` | e2657a9b | 2,410 |
| `variants/temp-holding/FASE 01/docs/frontend/diseno/README.md` | `temp-holding/FASE 01/docs/frontend/diseno/README.md` | f4da0839 | 2,259 |
| `variants/temp-holding/FASE 01/docs/frontend/diseno_detallado/README.md` | `temp-holding/FASE 01/docs/frontend/diseno_detallado/README.md` | 120f7c2b | 2,072 |
| `variants/temp-holding/FASE 01/docs/frontend/requisitos/README.md` | `temp-holding/FASE 01/docs/frontend/requisitos/README.md` | 55a26eaa | 573 |
| `variants/temp-holding/FASE 01/docs/frontend/requisitos/atributos_calidad/README.md` | `temp-holding/FASE 01/docs/frontend/requisitos/atributos_calidad/README.md` | 538b1982 | 1,847 |
| `variants/temp-holding/FASE 01/docs/frontend/requisitos/reglas_negocio/README.md` | `temp-holding/FASE 01/docs/frontend/requisitos/reglas_negocio/README.md` | 59407bd7 | 610 |
| `variants/temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_funcionales/README.md` | `temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_funcionales/README.md` | e48628d1 | 713 |
| `variants/temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_negocio/README.md` | `temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_negocio/README.md` | b07a465a | 618 |
| `variants/temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_usuario/README.md` | `temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_usuario/README.md` | f507b0cc | 625 |
| `variants/temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_usuario/casos_uso/README.md` | `temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_usuario/casos_uso/README.md` | 786db450 | 665 |
| `variants/temp-holding/FASE 01/docs/frontend/sesiones/README.md` | `temp-holding/FASE 01/docs/frontend/sesiones/README.md` | da5c8920 | 524 |
| `variants/temp-holding/FASE 01/docs/frontend/solicitudes/README.md` | `temp-holding/FASE 01/docs/frontend/solicitudes/README.md` | c30122f5 | 349 |
| `variants/temp-holding/FASE 01/docs/frontend/testing/README.md` | `temp-holding/FASE 01/docs/frontend/testing/README.md` | 1586964a | 333 |

