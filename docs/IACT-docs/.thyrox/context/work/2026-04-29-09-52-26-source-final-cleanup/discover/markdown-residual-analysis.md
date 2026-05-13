```yml
created_at: 2026-04-29 09:52:26
project: IACT-docs
work_package: 2026-04-29-09-52-26-source-final-cleanup
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Deep Analysis — Markdown Residual en archivos `.rst`

## Origen del problema

Cuando se ejecuto el saneamiento md->rst (WP
`2026-04-29-05-35-11`, 11 batches, 19222 issues -> 0), los
scripts atacaron las violaciones **sintacticas** que Sphinx
detectaba como warnings/errors:

- list-table column continuations (16637)
- bullet text wraps (909)
- section underlines indented (2568)
- grid tables malformadas (97)
- simple tables ruler mismatch (39)
- code-block::rst content perdido (52)
- sub-bullets off-by-one (145)
- rubric con body (12)

**Pero NO atacaron las violaciones semanticas**: contenido en
archivos `.rst` que sigue usando sintaxis **markdown** y NO
genera warnings de Sphinx porque markdown se renderiza como
texto literal o con interpretacion ambigua.

Tipico ejemplo: `MODELO_RBAC_IACT.rst` (1793 lineas) — el
archivo fue migrado de `.md` a `.rst` cambiando solo la
extension. El contenido sigue siendo markdown puro: HR `---`,
links `[text](url)`, anchors `[text](#anchor)`, blockquotes
`> text`. Sphinx no warning, pero el render HTML es
incorrecto/inconsistente.

## Patrones detectados

Scan automatizado con `/tmp/md_residual_audit.py` (filtra
falsos positivos: section underlines, codigo dentro de
code-block, etc.).

### Resultado

**22 archivos con 170 violaciones reales de sintaxis markdown.**

| Patron | Conteo | Archivos | RST equivalente |
|--------|-------:|---------:|-----------------|
| `md_hr_dashes` (`---`) | 69 | 6 | `----` (4+ chars) o transition `----` |
| `md_table_pipes` (`\| a \| b \|`) | 51 | 10 | `list-table` o `csv-table` |
| `md_html_br` (`<br>`) | 19 | 2 | linea blanca o `\` continuation |
| `md_link_inline` (`[t](u)`) | 14 | 3 | `:doc:` `:ref:` `\`text <url>\`_` |
| `md_anchor_ref` (`(#a)`) | 11 | 1 | `:ref:` con label |
| `md_blockquote` (`> text`) | 5 | 3 | `.. note::` o indentacion |
| `md_atx_heading` (`# text`) | 1 | 1 | section underline `===` |

### Top archivos afectados

| Violations | Archivo | Patrones |
|-----------:|---------|----------|
| **58** | `arquitectura_tecnica/rbac/MODELO_RBAC_IACT.rst` | hr, blockquote, link, anchor |
| 22 | `base_cognitiva/_fundamentos_conceptuales/FND_00_Contexto_y_Jerarquia.rst` | hr |
| 16 | `normativa/gobernanza/ADR-DEVOPS-003-wasi-style-virtualization-importante-db.rst` | tables (md migrado hoy) |
| 15 | `normativa/procedimientos/PROCED-GOB-004-crear-caso-uso.rst` | html_br |
| 12 | `normativa/procedimientos/procedimiento-analisis-seguridad.rst` | tables |
| 9 | `gestion/git-workflow.rst` | hr |
| 4 | `normativa/procedimientos/PROCED-GOB-002-actualizar_documentacion.rst` | blockquote, link |
| 4 | `normativa/procedimientos/procedimiento-trazabilidad-requisitos.rst` | tables |
| 4 | `normativa/estandares/plantillas/TPL_UC_Temporal_Schedulers.rst` | tables |
| 4 | `normativa/gobernanza/ADR-GOB-005-especificacion-casos-uso.rst` | html_br |
| 4 | `normativa/gobernanza/ADR-FRONT-010-typescript-adopcion-gradual.rst` | tables |

(11 archivos restantes con ≤3 violaciones cada uno.)

## Caso de estudio — MODELO_RBAC_IACT.rst (58 violaciones)

Es el archivo con mas violaciones, citado por el ejecutor como
ejemplo. Patrones presentes:

### 1. Horizontal rules `---`

```markdown
INTRODUCCION
============


---

Sistema IACT - IVR Analytics Customer Tracking
```

**Problema:** En RST, `---` puede interpretarse como section
underline si la longitud iguala al titulo de arriba. Si no,
Sphinx puede inferir transition (`====` o `----` de 4+ chars
como linea sola entre parrafos).

**Conversion correcta:**

```rst
INTRODUCCION
============


----

Sistema IACT - IVR Analytics Customer Tracking
```

(`----` con 4+ chars como transition.)

### 2. Markdown links inline `[text](url)`

```markdown
1. [Filosofía del Modelo](#1-filosofia)
2. [Arquitectura IACT](#2-arquitectura)
```

**Problema:** Sphinx renderiza esto como **texto literal con
corchetes** — NO genera link navegable.

**Conversion correcta** (anchor refs internos):

```rst
1. :ref:`Filosofía del Modelo <filosofia-del-modelo>`
2. :ref:`Arquitectura IACT <arquitectura-iact>`
```

Requires labels en cada section:

```rst
.. _filosofia-del-modelo:

Filosofía del Modelo
====================
```

### 3. Markdown blockquotes `> text`

```markdown
> **Los nombres de funciones describen QUÉ HACE la función**
```

**Problema:** Sphinx no entiende `> ` como blockquote markdown.

**Conversion correcta:**

```rst
.. epigraph::

   **Los nombres de funciones describen QUÉ HACE la función**
```

O usar indentacion simple:

```rst
   **Los nombres de funciones describen QUÉ HACE la función**
```

### 4. Anchor links `[text](#section-id)`

11 ocurrencias, todas en TOC inicial del documento.

```markdown
2. [Arquitectura IACT](#2-arquitectura)
```

**Conversion:** ya cubierta arriba (caso 2). El TOC manual
puede reemplazarse por `.. contents::`:

```rst
.. contents:: Indice
   :depth: 2
   :local:
```

Sphinx genera el TOC automaticamente desde los headings.

## Por que el scan inicial fallo

Mi scan inicial detectaba `~~text~~` como markdown
strikethrough con 1318 ocurrencias. **Eran falsos positivos**:
section underlines RST `~~~~~~~~~~~~` cuando el texto entre
dos underlines no contenia tildes.

```rst
1. Phase REQUIREMENTS                  <- titulo
~~~~~~~~~~~~~~~~~~~~~                  <- underline 1
                                       <- texto sin tildes
Actividades                            <- subtitulo
~~~~~~~~~~~                            <- underline 2
```

Mi regex `~~([^~]+)~~` matchea desde el final del underline 1
hasta el inicio del underline 2. Refinamiento:

```python
re.compile(r'(?<!~)~~(?!~)([^\n~]{1,120}?)(?<!~)~~(?!~)')
```

Restringe match a single line con max 120 chars sin tildes
adyacentes. Resultado: 0 strikethrough real. **Lecto
operativa: validar siempre los resultados de un scan
contra muestras del corpus antes de actuar.**

## Estrategia de remediacion

### Por patron y archivo

**Patrones simples (sustitucion mecanica):**

- `md_hr_dashes` (69 en 6 archivos): sed `s/^---\s*$/----/`
  para hacer transition RST.
- `md_html_br` (19 en 2 archivos): sed sustituir por linea
  blanca.

**Patrones complejos (per-archivo manual o asistido):**

- `md_link_inline` + `md_anchor_ref`: requieren context
  (saber a que apunta cada link).
- `md_blockquote`: requiere decidir si epigraph, note, o
  indentacion simple.
- `md_table_pipes`: convertir a list-table (script
  `/tmp/fix_grid_table.py` adaptado).

### Por archivo

Strategy fila-por-fila: cada archivo tiene 1-58 violaciones,
mayoria de un solo patron. Tasks atomicas T-NNN, una por
archivo (con su batch de patrones).

## Conexion con audits anteriores

Este audit completa la matriz de cumplimiento de `source/`:

| Audit | Estado | Pendiente |
|-------|--------|-----------|
| STD_007 naming | 100% cumple | — |
| temp-backup integration | resuelto | — |
| Sphinx references | 6 hyperlinks fixed | — |
| STD_001 emojis | 78 archivos pendientes | 1373 ocurrencias |
| Tables (list-table preferred) | 99.4% ya OK | 13 outliers opcional |
| **Markdown residual (este audit)** | **22 archivos pendientes** | **170 ocurrencias** |

Total a remediar: ~80 archivos unicos (overlap entre emoji
y markdown), ~1500 cambios atomicos posibles, agrupables en
~30-35 tareas T-NNN.

## Trazabilidad

- Script: `/tmp/md_residual_audit.py`
- Detalle JSON: `/tmp/md_residual.json`
- Caso ejemplo citado por ejecutor:
  `source/arquitectura_tecnica/rbac/MODELO_RBAC_IACT.rst`
- WPs predecesores: `2026-04-29-05-35-11-md-to-rst-saneamiento`,
  `2026-04-29-09-39-48-emoji-tables-audit`,
  `2026-04-29-06-56-16-source-compliance-audit`.
