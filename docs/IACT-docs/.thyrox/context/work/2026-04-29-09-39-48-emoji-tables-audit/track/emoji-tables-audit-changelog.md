```yml
created_at: 2026-04-29 09:39:48
project: IACT-docs
work_package: 2026-04-29-09-39-48-emoji-tables-audit
phase: Phase 11 — TRACK/EVALUATE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP-changelog: emoji-tables-audit

## Added

- `wp-state.md`
- `analyze/audit-emoji.md` — 78 archivos con 1373 ocurrencias
  de emojis/iconos prohibidos por STD_001. Tabla de
  sustituciones recomendadas.
- `analyze/audit-tables.md` — inventario: 2108 list-tables
  (99.4%) + 9 grid + 4 simple + 0 csv. list-table dominante.
- `track/emoji-tables-audit-changelog.md`

## Hallazgos principales

### Emoji audit (STD_001)

- **78 archivos no cumplen STD_001** con 1373 ocurrencias.
- Top: `☐` (705) en checklists, `✓` (214) y `✅` (128) en
  status indicators, `🔴🟡🟢` (12+4+3) en severidad.
- 107 ocurrencias en STD_001 mismo son **excepcion legitima**
  (ejemplos dentro de code-block).
- Violaciones reales: ~1266 ocurrencias en 77 archivos.

### Tables audit

- list-table es ya el formato dominante (99.4%).
- Solo 13 tablas en formatos no-recomendados (9 grid + 4 simple)
  en 9 archivos.
- 0 csv-tables.
- Build pasa 0/0 (las grid/simple actuales son validas RST).

## Status de promocion a CHANGELOG.md raiz

No aplica. Auditoria pura, sin cambios en el corpus.

## Aceptado / no fixeado

Sin acciones de remediacion en este WP. Recomendaciones quedan
para WPs futuros:

- **Emoji cleanup (P1 alto)**: WP dedicado siguiendo
  `mechanical-bulk-edits.md` (Diagnose → Pilot → Measure →
  Apply → Regression check) con tabla de sustituciones.
- **Tables normalization (P3 opcional)**: convertir las 13
  grid/simple a list-table en sesion dedicada (~30 min).

## Trazabilidad

- Politicas auditadas:
  - `source/normativa/estandares/STD_001_Estandares_Documentacion_Sin_Emojis.rst`
  - Convencion tabla provista por el ejecutor (Sphinx RST: 4
    formatos, list-table preferido).
- Scripts: `/tmp/emoji_audit.py`, `/tmp/tables_audit.py`.
- WP relacionado: `2026-04-29-05-35-11-md-to-rst-saneamiento` —
  durante el saneamiento se convirtieron 97 grid tables
  malformadas a list-tables. Las 9 grid actuales son las que
  ya estaban bien formadas.
