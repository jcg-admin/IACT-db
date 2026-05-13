```yml
created_at: 2026-04-27 05:26:20
updated_at: 2026-04-27 21:00:00
project: IACT-docs
work_package: 2026-04-27-05-26-20-zero-warnings-build
phase: Phase 11 — TRACK/EVALUATE
author: NestorMonroy
status: Borrador
```

# WP Changelog — zero-warnings-build

> Registro completo de cambios del WP. Política dos-niveles: este archivo
> se actualiza durante el WP; CHANGELOG.md raíz solo en merge a `main` con
> bump de versión.

## Resultado

| Métrica | Baseline | Final | Δ |
|---------|----------|-------|---|
| WARNING | 306 | **0** | -306 |
| ERROR | 173 | **0** | -173 |
| **TOTAL** | **479** | **0** | **-479** |
| `sphinx-build -W` exit | (would fail) | 0 | ✅ |
| `make clean && make html` exit | 0 (con warnings) | 0 (limpio) | ✅ |

## Added

- `source/normativa/restricciones/CNST_012_RBAC_Flat_SoD_Permisos.rst`
  (1097 líneas) — consolidación canónica del Modelo RBAC IACT v5.2.2:
  42 funciones atómicas, 10 grupos, 3 reglas SoD, permisos temporales,
  schema DDL de referencia. Decisiones D1-D6 aplicadas.
- 6 archivos `index.rst` nuevos para directorios huérfanos (ahora con
  toctree y enlazados al padre):
  - `arquitectura_tecnica/arquitectura/patrones/index.rst`
  - `base_cognitiva/_taxonomias_y_metamodelos/metamodelos/index.rst`
  - `base_cognitiva/_taxonomias_y_metamodelos/taxonomias/index.rst`
  - `gestion/pm/checklists/index.rst`
  - `requisitos/requisitos_funcionales/access/index.rst`
  - `requisitos/requisitos_funcionales/access/UC_010_Asignar_Funciones/index.rst`
  - `requisitos/requisitos_funcionales/access/UC_011_Revocar_Funciones/index.rst`
- `discover/zero-warnings-build-analysis.md` — Phase 1 DISCOVER con
  inventario completo de 479 issues categorizados.
- `discover/constraints-input/INVENTORY.md` — registro de los 6 CNST_*
  recibidos como input del ejecutor.
- `discover/constraints-input/cnst-catalog-analysis.md` — análisis
  comparativo entre catálogo existente (10 CNST) y 6 inputs recibidos.

## Changed

### Tablas convertidas a `.. list-table::` (Sphinx-compliant)

10 grid tables anchas con texto wrapped vertical (carácter por columna)
fueron reescritas como list-tables para resolver malformed-table errors
e inline-literal-without-end-string warnings:

- `PROC-DEV-001` Roles Involucrados (6 filas)
- `PROC-DEV-002` RACI matrix (8 cols × 7 roles)
- `PROC-GOB-001` Matriz Procedimiento × Workflow × Template (7 filas)
- `PROC-GOB-001` Matriz Templates por Categoría (5 filas)
- `PROC-GOB-008` Roles Responsabilidades (5 filas)
- `PROCED-GOB-002` Severidad Documental (4 filas)
- `Diagramas de Referencia README` UC seq table (3 filas)
- `git-workflow` Error Matrix (12 filas, recovery cheatsheet)
- `Gobernanza del Frontend README` (5 filas)
- `PROC-QA-002` actividades_garantia (1 fila — fix backticks rotos)

### Toctrees agregados a 21 directorios

`.. toctree:: :hidden:` agregado a `index.rst` de los 21 directorios
con archivos huérfanos. Sacó de `[toc.not_included]` a 167 archivos:

- `normativa/procedimientos/` (75 entradas)
- `normativa/gobernanza/` (23 entradas)
- `arquitectura_tecnica/arquitectura/` (8 entradas)
- `requisitos/objetivos/` (5)
- `gestion/pm/checklists/` (6)
- `base_cognitiva/_ontologia_sbvr/` (5)
- `requisitos/casos_uso/auth/` (5)
- y 14 más...

### Refs y labels

- 47 etiquetas duplicadas renombradas con prefijo de filename
  (`validación-N`, `objetivo-del-paso-N`, etc.) en 8 archivos.
- ~80 patrones `WORD_` (acronyms con underscore al final) escapados
  como `WORD\_` para evitar interpretación como hyperlink reference.
  Acronyms cubiertos: BR, BReq, UC, FR, TXM, MTM, STD, CNST, ADR, TPL,
  SBVR, NFR, META, GOB, FND, RTM, PROC, AUT, USR, ACC, PIP, ALR, AUD,
  LOG, GLOS, MDL, VIEW, COV, DSC, ARQ, DEP, etc.
- Cross-refs agregadas: `BR_006` → `cnst-012`, `MTM_03` → `cnst-012` y
  `br-006`.

### Sintaxis RST

- 13 títulos con underline corto extendidos usando visual-width
  (incluye emojis y caracteres East Asian Wide).
- 23 inserciones de blank-line antes de bloques que rompían bullet
  lists / block-quotes / line-blocks (con detección de tablas y
  directivas para no romper estructuras válidas).
- 24 inserciones de blank-line antes de listas enumeradas anidadas
  (a. b. c.) bajo dash-lists.
- `markdown` tables (`| col |---|`) convertidas a `.. list-table::` en
  3 archivos donde no estaban dentro de `.. code:: markdown` blocks.
- `pyproject.toml` y demás archivos: 7 paths de `!include` PlantUML
  corregidos (`../../../_static` → `../../_static`).

### Configuración

- 4 list-tables con `:widths:` mal declarado corregidas (columnas
  declaradas vs. cells reales).
- 3 list-tables con filas incompletas completadas con cells faltantes.
- 1 `.. code:: markdown` vacío removido (PROCED-GOB-004).
- 1 `--------` transition mal pegado a tabla separado con blank line
  (PROC-DEV-002).
- 1 referencia `raw-latex` (path Windows mal escapado) reemplazada por
  literal en ADR-BACK-002.

## Aceptado / no fixeado

Ningún issue queda sin fixear — `0 warnings, 0 errors`.

## Status de promoción a CHANGELOG.md raíz

Pendiente de merge `feature/repository-diagnostics → develop → main`.
Cuando ocurra:
- Promover entrada bajo `## [X.Y.Z] — YYYY-MM-DD` (decidir bump según
  alcance del paquete completo del WP — incluye también el WP
  repository-diagnostics).
- Sugerencia: minor bump (1.0.0 → 1.1.0) por adición CNST-012, plugin
  manifest, ROADMAP/CHANGELOG, scripts setup, RBAC consolidation.

## Verificación final

```bash
$ source .venv/bin/activate
$ make clean && sphinx-build -W -b html -d build/doctrees source build/html
build succeeded.
$ echo $?
0
```

## Commits del WP

| SHA | Subject |
|-----|---------|
| `e5df309` | Open WP zero-warnings-build, Phase 1 DISCOVER |
| `edf72b3` | Sync session state to zero-warnings-build WP |
| `a7cf0f2` | Sync session state after constraints inventory |
| `011bc72` | Document CNST catalog analysis (existing vs new input) |
| `e4fc207` | Add CNST-012 RBAC consolidated catalog and wire toctree |
| `0805965` | Reduce build warnings from 468 to ~53 — sweep batch 1 |
| `e0dc016` | Reach 0 warnings — convert broken grid tables to list-tables |
