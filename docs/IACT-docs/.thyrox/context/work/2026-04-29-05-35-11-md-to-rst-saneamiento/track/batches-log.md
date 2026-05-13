```yml
created_at: 2026-04-29 05:35:11
project: IACT-docs
work_package: 2026-04-29-05-35-11-md-to-rst-saneamiento
phase: Phase 11 — TRACK/EVALUATE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Batches Log — Saneamiento Cronologico

11 batches commiteados secuencialmente. Cada batch: clean
build + script(s) + clean rebuild + commit. Logs de cada
batch en `build-logs/`.

---

## Batch 1 — `e71a78d` (list-table column continuations)

- **Script:** `fix_listtable.py`
- **Archivos modificados:** 283
- **Snapshot:** `build-logs/01-after-listtable.log`

| Metrica | Antes | Despues | Delta |
|---------|-------|---------|-------|
| WARN | 17257 | 1283 | -15974 |
| ERR | 1965 | 142 | -1823 |
| CRIT | 20 | 13 | -7 |

Mayor batch del proyecto. 96% de los issues iniciales eran
de este patron.

---

## Batch 2 — `830d258` (bullet text continuations)

- **Script:** `fix_bullet_wrap.py` (heuristica hibrida)
- **Archivos modificados:** 330

| Metrica | Antes | Despues | Delta |
|---------|-------|---------|-------|
| WARN | 1283 | 374 | -909 |
| ERR | 142 | 142 | 0 |
| CRIT | 13 | 5 | -8 |

Nota: primer intento con heuristica estricta produjo 36
falsos positivos (`Unexpected indentation`). Revertido. La
heuristica hibrida (segundo intento) tuvo solo 1 falso
positivo, fixeado manualmente.

---

## Batch 3 — `45f640a` (section underlines)

- **Script:** `fix_section_underline.py`
- **Archivos modificados:** 286

| Metrica | Antes | Despues | Delta |
|---------|-------|---------|-------|
| WARN | 374 | 374 | 0 |
| ERR | 142 | 142 | 0 |
| CRIT | 2581 | 13 | -2568 |

Eliminado 99.5% de los CRITICAL. Estos eran "Unexpected
section title" — docutils no podia construir el doctree de
los archivos afectados, generando cascada de side-effects.
Resolverlos simplifica radicalmente el analisis del estado
restante.

---

## Batch 4 — `0e14c10` (directive content + STD_007 readme)

- **Scripts:** `fix_directive_content.py` + manual renames
- **Archivos modificados:** 67

| Metrica | Antes | Despues | Delta |
|---------|-------|---------|-------|
| WARN | 374 | 315 | -59 |
| ERR | 142 | 122 | -20 |
| CRIT | 13 | 5 | -8 |

Atencion al feedback STD_007 en este batch:

User detecto que `*-readme.rst` files preservaban el
sufijo prohibido. Renames:
- `planificacion-releases-frontend-readme.rst` -> `planificacion-releases-frontend.rst`
- `checklists-backend-readme.rst` -> `checklists-backend.rst`
- `README.rst` -> `checklists-pm.rst`

Leccion: cuando un estandar declara un nombre como prohibido,
no es problema de transliteracion sino de proposito del
archivo. Renombrar preservando sufijo problematico = no
haber leido la regla.

---

## Batch 5 — `c2b9ad7` (grid tables -> list-tables)

- **Script:** `fix_grid_table.py`
- **Archivos modificados:** 43

| Metrica | Antes | Despues | Delta |
|---------|-------|---------|-------|
| WARN | 315 | 312 | -3 |
| ERR | 122 | 64 | -58 |
| CRIT | 5 | 5 | 0 |

97 -> 39 malformed table errors (-58). Los 39 restantes
eran simple tables, no grid tables.

---

## Batch 6 — `16c20f2` (simple tables -> list-tables)

- **Script:** `fix_simple_table_v2.py` + manual fix de
  index.rst
- **Archivos modificados:** 27

| Metrica | Antes | Despues | Delta |
|---------|-------|---------|-------|
| WARN | 312 | 320 | +8 |
| ERR | 64 | 23 | -41 |
| CRIT | 5 | 5 | 0 |

Nota: warnings subieron levemente (+8) por celdas
reformateadas que generaron formatting issues menores.
Compensado en batches posteriores.

39 -> 0 malformed tables.

---

## Batch 7 — `546f10d` (sub-bullets off-by-one)

- **Script:** `fix_subbullet_v2.py` (despues de revert de v1)
- **Archivos modificados:** 113

| Metrica | Antes | Despues | Delta |
|---------|-------|---------|-------|
| WARN | 320 | 175 | -145 |
| ERR | 23 | 23 | 0 |
| CRIT | 5 | 5 | 0 |

Nota: v1 (`fix_subbullet.py`) era stack-based agresiva:
374 -> 13838 warnings. Revertido. v2 es conservadora —
solo arregla off-by-1 a off-by-(marker_len-1).

---

## Batch 8 — `29f6399` (code-block::rst lost content)

- **Script:** `fix_codeblock_rst.py`
- **Archivos modificados:** 37

| Metrica | Antes | Despues | Delta |
|---------|-------|---------|-------|
| WARN | 175 | 132 | -43 |
| ERR | 23 | 19 | -4 |
| CRIT | 5 | 0 | -5 |

CRITICAL = 0 alcanzado. Los 5 CRIT remanentes hasta este
batch venian de archivos donde el code-block::rst escapaba
y producia broken sections.

---

## Batch 9 — `fb6daf9` (cascade re-application)

- **Scripts:** `fix_directive_content.py` + `fix_listtable.py`
  re-aplicados
- **Archivos modificados:** 37 + 25

| Metrica | Antes | Despues | Delta |
|---------|-------|---------|-------|
| WARN | 132 | 36 | -96 |
| ERR | 19 | 13 | -6 |
| CRIT | 0 | 0 | 0 |

El batch 8 destapo nuevos casos de directivas con contenido
mal indentado que el batch 4 originalmente no detecto
(estaban enmascarados por cascade de errores superiores).
Re-aplicacion idempotente fue suficiente.

---

## Batch 10 — `de48438` (rubric con body)

- **Script:** `fix_rubric.py`
- **Archivos modificados:** 12

| Metrica | Antes | Despues | Delta |
|---------|-------|---------|-------|
| WARN | 36 | 36 | 0 |
| ERR | 13 | 1 | -12 |
| CRIT | 0 | 0 | 0 |

Patron unico en plantillas (TPL_*): rubric con body
indentado. ERROR Limpia 12 de 13 errors. Solo queda 1
error en TPL_UC_Actor_Secundario (cell con nested bullets
mismatching column count).

---

## Batch 11 — `0f884df` (manual cleanup -> 0/0/0)

- **Tipo:** Manual case-by-case
- **Archivos modificados:** 18

| Metrica | Antes | Despues | Delta |
|---------|-------|---------|-------|
| WARN | 36 | 0 | -36 |
| ERR | 1 | 0 | -1 |
| CRIT | 0 | 0 | 0 |

Casos heterogeneos no convertibles algoritmicamente.
Detalles del fix por archivo en commit message.

`build succeeded` con 0/0/0 confirmado.

---

## Resumen final

| Batch | Commit | WARN | ERR | CRIT | Total |
|-------|--------|------|-----|------|-------|
| - (baseline) | - | 17257 | 1965 | 20 | 19242 |
| 1 | e71a78d | 1283 | 142 | 13 | 1438 |
| 2 | 830d258 | 374 | 142 | 5 | 521 |
| 3 | 45f640a | 374 | 142 | 13 | 529 (note 1) |
| 4 | 0e14c10 | 315 | 122 | 5 | 442 |
| 5 | c2b9ad7 | 312 | 64 | 5 | 381 |
| 6 | 16c20f2 | 320 | 23 | 5 | 348 |
| 7 | 546f10d | 175 | 23 | 5 | 203 |
| 8 | 29f6399 | 132 | 19 | 0 | 151 |
| 9 | fb6daf9 | 36 | 13 | 0 | 49 |
| 10 | de48438 | 36 | 1 | 0 | 37 |
| 11 | 0f884df | 0 | 0 | 0 | **0** |

**Note 1:** El conteo CRIT en batch 3 se midio antes vs
despues del fix de section underlines. Los 2568 CRIT que
vimos en pre-saneamiento (b6791aets.output) incluian
"Unexpected section title" CRIT que el batch 3 elimino.
Diferencia con el log baseline (20 CRIT) es porque el
baseline.log filtra solo lineas con "WARNING|ERROR|CRITICAL"
exact match — algunos CRIT venian con prefijo distinto
("CRITICAL: Unexpected section title or transition").

Total reduccion: **-100%** en 11 commits.
