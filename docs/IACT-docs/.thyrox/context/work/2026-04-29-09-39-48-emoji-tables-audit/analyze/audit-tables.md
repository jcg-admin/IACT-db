```yml
created_at: 2026-04-29 09:39:48
project: IACT-docs
work_package: 2026-04-29-09-39-48-emoji-tables-audit
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Tables Audit — Inventario por tipo

Scan automatizado con `/tmp/tables_audit.py` sobre 381 archivos
`.rst`.

## Resumen ejecutivo

| Tipo de tabla | Conteo | % | Mantenibilidad |
|---------------|-------:|---|----|
| `list-table` | **2108** | 99.4% | **Alta** (recomendada) |
| Grid table (`+---+---+`) | 9 | 0.4% | Baja (manual, pipes deben alinear) |
| Simple table (`=== ===`) | 4 | 0.2% | Media (rapida, sin celdas combinadas) |
| `csv-table` | 0 | 0% | — |
| **Total** | **2121** | 100% | — |

**Veredicto:** el corpus YA usa `list-table` como formato dominante
(99.4%). Las 13 tablas no-list-table son outliers que pueden
convertirse o quedar como excepcion documentada.

## Detalle Grid Tables (5 archivos, 9 tablas)

| Tablas | Archivo | Notas |
|-------:|---------|-------|
| 4 | `base_cognitiva/_fundamentos_conceptuales/FND_04_Trazabilidad.rst` | El de mayor concentracion |
| 2 | `normativa/gobernanza/ADR-DEVOPS-003-wasi-style-virtualization-importante-db.rst` | ADR migrado de temp-backup hoy |
| 1 | `arquitectura_tecnica/modulos/ARQ_MOD_002_USER_IDENTITY.rst` | — |
| 1 | `normativa/estandares/plantillas/TPL_UC_Actor_Secundario.rst` | — |
| 1 | `normativa/gobernanza/ADR-FRONT-010-typescript-adopcion-gradual.rst` | ADR migrado hoy |

**Nota:** las grid tables son **validas RST** y el build pasa
con 0 warnings. La conversion a `list-table` es mejora de
mantenibilidad, no requisito.

## Detalle Simple Tables (4 archivos, 4 tablas)

| Tablas | Archivo |
|-------:|---------|
| 1 | `normativa/gobernanza/ADR-FRONT-002-redux-toolkit-state-management.rst` |
| 1 | `normativa/gobernanza/ADR-QA-002-testing-strategy-jest-testing-library.rst` |
| 1 | `normativa/gobernanza/ADR-FRONT-010-typescript-adopcion-gradual.rst` |
| 1 | `normativa/gobernanza/ADR-FRONT-003-webpack-bundler.rst` |

Todas en ADRs migrados de temp-backup hoy. Pre-existian con
ese formato; nunca se tocaron.

## Recomendaciones

### P1 — Adoptar `list-table` como politica default (Baja prioridad)

El corpus ya esta a 99.4% en `list-table`. Las 13 tablas restantes
(0.6%) pueden:

1. Convertirse a `list-table` en una sesion dedicada (~30
   min de trabajo).
2. Quedar como estan si renderean OK y son contenido tecnico
   estable.

**No bloquea el build.** Es deuda tecnica menor.

### P2 — Documentar la convencion en STD_001 o STD_007

Aclarar que `list-table` es el formato preferido para tablas en
documentacion IACT. Razones:

- Mantenibilidad alta (estructura jerarquica, no requiere
  alinear caracteres).
- Tolerante a contenido multilinea en celdas.
- Permite `:widths:`, `:header-rows:`, `:stub-columns:`.
- Compatible con todos los outputs Sphinx (HTML, PDF, ePub).

Las grid tables y simple tables quedan **permitidas pero no
recomendadas**. csv-table como caso especial cuando la fuente es
externa (CSV file).

Esta aclaracion puede hacerse en un nuevo standard
`STD_008_Convencion_Tablas.rst` o como seccion en
`STD_001_Estandares_Documentacion_Sin_Emojis.rst` (renombrar a
algo mas amplio).

### P3 — Convertir Grid Tables outlier a `list-table` (opcional)

Si se quiere homogeneidad 100%, los 5 archivos identificados
arriba son los candidatos. Un script `fix_grid_table.py` ya
existe en `/tmp/` (creado en WP saneamiento md->rst). Pre-pilot
verifica si el contenido se preserva correctamente.

## Trazabilidad

- Script: `/tmp/tables_audit.py`
- WP relacionado:
  `2026-04-29-05-35-11-md-to-rst-saneamiento` — donde se
  convirtieron 97 grid tables malformadas a list-tables
  durante el saneamiento. Las 9 grid tables actuales son las
  que NO estaban malformadas (renderean OK).
