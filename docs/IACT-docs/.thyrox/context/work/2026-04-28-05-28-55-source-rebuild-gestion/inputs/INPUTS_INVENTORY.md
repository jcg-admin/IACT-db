```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-55-source-rebuild-gestion
phase: Phase 1 — DISCOVER (input staging)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Inventory — WP gestion

Documentos pre-staged desde `temp-backup/` y `temp-holding/`. Solo estos archivos deben consultarse para el analisis de este WP — evita buscar en todo `temp-*`.

## Convencion

- `canonical/` — un solo archivo por concepto (MD5 deduplicado, preferencia: temp-backup > FASE 02 > FASE 01).
- `variants/` — archivos con mismo nombre pero contenido distinto, ruta espejo del origen para desambiguar.

## Resumen

- Canonicos: **10**
- Variantes: **5**
- Duplicados colapsados: **0**

- Tamano total stage: 116,816 bytes (114.1 KB)

## Canonicos

| Destino | Origen elegido | Hash | Bytes | Dups colapsados |
|---------|---------------|------|-------|----------------|
| `canonical/Checklists del backend- README.rst` | `temp-backup/source-2026-04-28/gestion/pm/checklists/Checklists del backend- README.rst` | 99557367 | 3,683 | 0 |
| `canonical/Planificación y releases del frontend-README.rst` | `temp-backup/source-2026-04-28/gestion/pm/Planificación y releases del frontend-README.rst` | aefcb372 | 2,821 | 0 |
| `canonical/README.rst` | `temp-backup/source-2026-04-28/gestion/pm/checklists/README.rst` | 7418845e | 11,879 | 0 |
| `canonical/checklist_cambios_documentales.rst` | `temp-backup/source-2026-04-28/gestion/pm/checklists/checklist_cambios_documentales.rst` | b2ce0ac9 | 342 | 0 |
| `canonical/checklist_desarrollo.rst` | `temp-backup/source-2026-04-28/gestion/pm/checklists/checklist_desarrollo.rst` | 9997fc0b | 995 | 0 |
| `canonical/checklist_testing.rst` | `temp-backup/source-2026-04-28/gestion/pm/checklists/checklist_testing.rst` | dc8b90e6 | 326 | 0 |
| `canonical/checklist_trazabilidad_requisitos.rst` | `temp-backup/source-2026-04-28/gestion/pm/checklists/checklist_trazabilidad_requisitos.rst` | b814f8e4 | 487 | 0 |
| `canonical/deployment_plan.rst` | `temp-backup/source-2026-04-28/gestion/pm/deployment_plan.rst` | 831a8109 | 4,552 | 0 |
| `canonical/git-workflow.rst` | `temp-backup/source-2026-04-28/gestion/git-workflow.rst` | 7e58074f | 80,427 | 0 |
| `canonical/plantilla_adr.rst` | `temp-backup/source-2026-04-28/gestion/plantilla_adr.rst` | 8a531a66 | 5,132 | 0 |

## Variantes

| Destino | Origen | Hash | Bytes |
|---------|--------|------|-------|
| `variants/temp-backup/source-2026-04-28/gestion/evidencia/index.rst` | `temp-backup/source-2026-04-28/gestion/evidencia/index.rst` | 9b0d22d5 | 1,644 |
| `variants/temp-backup/source-2026-04-28/gestion/index.rst` | `temp-backup/source-2026-04-28/gestion/index.rst` | 36a23684 | 1,520 |
| `variants/temp-backup/source-2026-04-28/gestion/manuales_usuarios/index.rst` | `temp-backup/source-2026-04-28/gestion/manuales_usuarios/index.rst` | 1e21956b | 1,422 |
| `variants/temp-backup/source-2026-04-28/gestion/pm/checklists/index.rst` | `temp-backup/source-2026-04-28/gestion/pm/checklists/index.rst` | 93693e0c | 225 |
| `variants/temp-backup/source-2026-04-28/gestion/pm/index.rst` | `temp-backup/source-2026-04-28/gestion/pm/index.rst` | 254cf526 | 1,361 |

