```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-52-source-rebuild-onboarding
phase: Phase 1 — DISCOVER (input staging)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Inventory — WP onboarding

Documentos pre-staged desde `temp-backup/` y `temp-holding/`. Solo estos archivos deben consultarse para el analisis de este WP — evita buscar en todo `temp-*`.

## Convencion

- `canonical/` — un solo archivo por concepto (MD5 deduplicado, preferencia: temp-backup > FASE 02 > FASE 01).
- `variants/` — archivos con mismo nombre pero contenido distinto, ruta espejo del origen para desambiguar.

## Resumen

- Canonicos: **8**
- Variantes: **0**
- Duplicados colapsados: **0**

- Tamano total stage: 56,720 bytes (55.4 KB)

## Canonicos

| Destino | Origen elegido | Hash | Bytes | Dups colapsados |
|---------|---------------|------|-------|----------------|
| `canonical/CHANGELOG.md` | `temp-holding/FASE 01/docs/CHANGELOG.md` | c24679bc | 4,533 | 0 |
| `canonical/CONTRIBUTING.md` | `temp-holding/FASE 01/docs/CONTRIBUTING.md` | c5684f0b | 10,792 | 0 |
| `canonical/INDEX.md` | `temp-holding/FASE 01/docs/INDEX.md` | 2f88f009 | 10,315 | 0 |
| `canonical/README.md` | `temp-holding/FASE 01/docs/README.md` | 594111b7 | 3,010 | 0 |
| `canonical/SETUP.md` | `temp-holding/FASE 01/docs/SETUP.md` | 00eeb432 | 6,814 | 0 |
| `canonical/conf.py` | `temp-backup/source-2026-04-28/conf.py` | a28c021e | 12,722 | 0 |
| `canonical/index.rst` | `temp-backup/source-2026-04-28/index.rst` | 2d8065ea | 1,655 | 0 |
| `canonical/mkdocs.yml` | `temp-holding/FASE 01/docs/mkdocs.yml` | 7e392e45 | 6,879 | 0 |

