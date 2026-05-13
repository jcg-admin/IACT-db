```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-50-source-rebuild-databases
phase: Phase 1 — DISCOVER (input staging)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Inventory — WP databases

Documentos pre-staged desde `temp-backup/` y `temp-holding/`. Solo estos archivos deben consultarse para el analisis de este WP — evita buscar en todo `temp-*`.

## Convencion

- `canonical/` — un solo archivo por concepto (MD5 deduplicado, preferencia: temp-backup > FASE 02 > FASE 01).
- `variants/` — archivos con mismo nombre pero contenido distinto, ruta espejo del origen para desambiguar.

## Resumen

- Canonicos: **5**
- Variantes: **0**
- Duplicados colapsados: **1**

- Tamano total stage: 105,063 bytes (102.6 KB)

## Canonicos

| Destino | Origen elegido | Hash | Bytes | Dups colapsados |
|---------|---------------|------|-------|----------------|
| `canonical/ETL - Documentación Completa - IACT Call Center Analytics Dashboard  - 271025 - df3c.md` | `temp-holding/FASE 01/ETL - Documentación Completa - IACT Call Center Analytics Dashboard  - 271025 - df3c.md` | b882d302 | 73,442 | 0 |
| `canonical/TASK-005-sistema_de_metrics_interno_mysql.md` | `temp-holding/FASE 01/docs/backend/TASK-005-sistema_de_metrics_interno_mysql.md` | 23034bce | 2,546 | 0 |
| `canonical/TASK-028-etl_pipeline_automation.md` | `temp-holding/FASE 01/docs/backend/TASK-028-etl_pipeline_automation.md` | 83d20f13 | 3,900 | 0 |
| `canonical/etl.md` | `temp-holding/FASE 01/docs/backend/diseno/arquitectura/etl.md` | 26d7486e | 547 | 0 |
| `canonical/plantilla_etl_job.md` | `temp-holding/FASE 01/docs/backend/plantilla_etl_job.md` | 582af627 | 24,628 | 1 |

