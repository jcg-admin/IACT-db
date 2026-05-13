```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-01-58-08-source-rebuild-strategy
phase: Phase 11 — TRACK (post-cierre — input routing)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Routing Map — temp-holding/temp-backup → WPs hijos

Mapeo central de documentos en `temp-backup/` y `temp-holding/` a su WP-hijo destino. Cuando se abre un WP-hijo nuevo, sus inputs ya estan pre-staged en `inputs/canonical/` o `inputs/variants/`.

## Resumen por WP

| WP | Canonicos | Variantes | Total |
|----|-----------|-----------|-------|
| base-cognitiva | 234 | 41 | 275 |
| normativa-estandares | 33 | 2 | 35 |
| normativa-procedimientos | 82 | 0 | 82 |
| normativa-restricciones | 35 | 0 | 35 |
| normativa-gobernanza | 349 | 74 | 423 |
| requisitos | 185 | 20 | 205 |
| arquitectura-tecnica | 117 | 7 | 124 |
| backend | 277 | 126 | 403 |
| frontend | 31 | 15 | 46 |
| infrastructure | 205 | 236 | 441 |
| databases | 5 | 0 | 5 |
| operations | 203 | 4 | 207 |
| onboarding | 8 | 0 | 8 |
| quality | 6 | 0 | 6 |
| risks-technical-debt | 1 | 0 | 1 |
| gestion | 10 | 5 | 15 |

**Total candidatos enrutados:** 2311

## Reglas de enrutamiento aplicadas

- `temp-backup/source-2026-04-28/base_cognitiva/` → **base-cognitiva**
- `temp-backup/source-2026-04-28/normativa/estandares/` → **normativa-estandares**
- `temp-backup/source-2026-04-28/normativa/procedimientos/` → **normativa-procedimientos**
- `temp-backup/source-2026-04-28/normativa/restricciones/` → **normativa-restricciones**
- `temp-backup/source-2026-04-28/normativa/` → **normativa-gobernanza**
- `temp-backup/source-2026-04-28/requisitos/` → **requisitos**
- `temp-backup/source-2026-04-28/arquitectura_tecnica/` → **arquitectura-tecnica**
- `temp-backup/source-2026-04-28/plantuml-guide/` → **arquitectura-tecnica**
- `temp-backup/source-2026-04-28/gestion/` → **gestion**
- `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/` → **base-cognitiva**
- `temp-holding/FASE 02/base_cognitiva/normativa/estandares/` → **normativa-estandares**
- `temp-holding/FASE 02/base_cognitiva/normativa/restricciones/` → **normativa-restricciones**
- `temp-holding/FASE 02/base_cognitiva/normativa/` → **normativa-gobernanza**
- `temp-holding/FASE 02/base_cognitiva/utilidades/` → **normativa-estandares**
- `temp-holding/FASE 02/originales/RESTRICCIONES_COMPLETAS` → **normativa-restricciones**
- `temp-holding/FASE 02/originales/FND_` → **base-cognitiva**
- `temp-holding/FASE 02/originales/META_` → **base-cognitiva**
- `temp-holding/FASE 02/originales/SBVR_` → **base-cognitiva**
- `temp-holding/FASE 02/originales/TXM_` → **base-cognitiva**
- `temp-holding/FASE 02/originales/MTM_` → **base-cognitiva**
- `temp-holding/FASE 02/originales/` → **base-cognitiva**
- `temp-holding/FASE 02/tmp_work/` → **base-cognitiva**
- `temp-holding/project/risks` → **risks-technical-debt**
- `temp-holding/project/decisions` → **normativa-gobernanza**
- `temp-holding/project/quality` → **quality**
- `temp-holding/FASE 01/docs/backend/.*[Ee][Tt][Ll].*\.md` → **databases**
- `temp-holding/FASE 01/docs/backend/.*mysql.*\.md` → **databases**
- `temp-holding/FASE 01/docs/backend/plantilla_etl` → **databases**
- `temp-holding/FASE 01/docs/backend/TASK-005-sistema_de_metrics_interno_mysql` → **databases**
- `temp-holding/FASE 01/docs/backend/TASK-028-etl_pipeline_automation` → **databases**
- `temp-holding/FASE 01/STD_` → **normativa-estandares**
- `temp-holding/FASE 01/NOM_` → **normativa-estandares**
- `temp-holding/FASE 01/CNST_05_` → **normativa-restricciones**
- `temp-holding/FASE 01/PLAN_MAESTRO_` → **normativa-estandares**
- `temp-holding/FASE 01/CLEAN CODE NAMING` → **normativa-estandares**
- `temp-holding/FASE 01/ANALISIS_COMPLETO_PROYECTO_RST` → **base-cognitiva**
- `temp-holding/FASE 01/ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO` → **base-cognitiva**
- `temp-holding/FASE 01/ARQUITECTURA_DOCUMENTAL` → **arquitectura-tecnica**
- `temp-holding/FASE 01/Call Center Dashboard - Arquitectura` → **arquitectura-tecnica**
- `temp-holding/FASE 01/ETL - Documentación` → **databases**
- `temp-holding/FASE 01/BASE_COGNITIVA/` → **base-cognitiva**
- `temp-holding/FASE 01/CNST RESTRICCIONES/` → **normativa-restricciones**
- `temp-holding/FASE 01/STD ` → **normativa-estandares**
- `temp-holding/FASE 01/PROC_Procedimientos/` → **normativa-procedimientos**
- `temp-holding/FASE 01/TLP_Templates/` → **normativa-estandares**
- `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/` → **arquitectura-tecnica**
- `temp-holding/FASE 01/Casos de Uso/` → **requisitos**
- `temp-holding/FASE 01/BR_ Busines Requirements/` → **requisitos**
- `temp-holding/FASE 01/FR_Requisitos_Funcionales/` → **requisitos**
- `temp-holding/FASE 01/Ingeniería de Requerimientos/` → **requisitos**
- `temp-holding/FASE 01/modulos/` → **requisitos**
- `temp-holding/FASE 01/RBAC/` → **arquitectura-tecnica**
- `temp-holding/FASE 01/docs/backend/db/` → **databases**
- `temp-holding/FASE 01/docs/backend/` → **backend**
- `temp-holding/FASE 01/docs/frontend/` → **frontend**
- `temp-holding/FASE 01/docs/devops/` → **infrastructure**
- `temp-holding/FASE 01/docs/infraestructura/` → **infrastructure**
- `temp-holding/FASE 01/docs/operaciones/` → **operations**
- `temp-holding/FASE 01/docs/gobernanza/` → **normativa-gobernanza**
- `temp-holding/FASE 01/docs/trazabilidad/` → **normativa-gobernanza**
- `temp-holding/FASE 01/docs/PRODUCTO_DASHBOARD_ANALYTICS/` → **requisitos**
- `temp-holding/FASE 01/docs/scripts/` → **operations**
- `temp-holding/FASE 01/docs/SETUP\.md` → **onboarding**
- `temp-holding/FASE 01/docs/CONTRIBUTING\.md` → **onboarding**
- `temp-holding/FASE 01/docs/INDEX\.md` → **onboarding**
- `temp-holding/FASE 01/docs/README` → **onboarding**
- `temp-holding/FASE 01/docs/CHANGELOG\.md` → **onboarding**
- `temp-holding/FASE 01/docs/CODEOWNERS` → **normativa-gobernanza**
- `temp-holding/FASE 01/docs/Makefile` → **quality**
- `temp-holding/FASE 01/docs/pytest\.ini` → **quality**
- `temp-holding/FASE 01/docs/requirements\.txt` → **backend**
- `temp-holding/FASE 01/docs/mkdocs\.yml` → **onboarding**
- `temp-holding/Modules/` → **backend**
- `temp-backup/source-2026-04-28/conf\.py` → **onboarding**
- `temp-backup/source-2026-04-28/index\.rst` → **onboarding**
- `temp-holding/RBAC/` → **arquitectura-tecnica**
- `temp-holding/GENERACION_DOCUMENTACION/ANALISIS_PROFUNDO_RBAC` → **arquitectura-tecnica**
- `temp-holding/GENERACION_DOCUMENTACION/MAPA_RBAC` → **arquitectura-tecnica**
- `temp-holding/GENERACION_DOCUMENTACION/CONTENIDO_DEL_BACKUP` → **base-cognitiva**
- `temp-holding/GENERACION_DOCUMENTACION/PLAN_MAESTRO_GENERACION` → **base-cognitiva**
- `temp-holding/GENERACION_DOCUMENTACION/PLAN_REGENERACION` → **base-cognitiva**
- `temp-holding/GENERACION_DOCUMENTACION/FASE 0/` → **base-cognitiva**
- `temp-holding/GENERACION_DOCUMENTACION/FASE 1/` → **requisitos**
- `temp-holding/GENERACION_DOCUMENTACION/FASE 2/` → **arquitectura-tecnica**
- `temp-holding/GENERACION_DOCUMENTACION/FASE 3` → **backend**
- `temp-holding/GENERACION_DOCUMENTACION/FASE 10/` → **operations**
- `temp-holding/GENERACION_DOCUMENTACION/FASE 11/` → **quality**
- `temp-holding/GENERACION_DOCUMENTACION/FASE 12/` → **operations**
- `temp-holding/GENERACION_DOCUMENTACION/FASE 13/` → **operations**
- `temp-holding/GENERACION_DOCUMENTACION/` → **base-cognitiva**

## Exclusiones

- `IACT_Backup_Completo_2026-01-11-old`
- `IACT_Backup_Completo_2026-01-11/`
- `TMP_COMPLETO_2026-01-13_OK/`
- `TMP_COMPLETO_IACT_2026-01-13_2/`
- `TMP_COMPLETO_2026-01-13/`
- `Sphinx (documentation generator)`

## Preferencia de canonicos (orden)

1. `temp-backup/source-2026-04-28/`
2. `temp-holding/FASE 02/`
3. `temp-holding/FASE 01/`
4. `temp-holding/RBAC/`
5. `temp-holding/GENERACION_DOCUMENTACION/`
