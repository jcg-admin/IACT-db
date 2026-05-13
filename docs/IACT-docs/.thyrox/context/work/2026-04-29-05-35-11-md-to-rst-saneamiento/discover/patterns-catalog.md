```yml
created_at: 2026-04-29 05:35:11
project: IACT-docs
work_package: 2026-04-29-05-35-11-md-to-rst-saneamiento
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Patterns Catalog — md->rst Conversion Bugs

8 patrones sistematicos identificados, con muestra del bug y
fix correspondiente.

---

## P1 — list-table column continuations

**Volumen:** 16637 warnings + 1804 errors = 18441 (96% del total)
**Script:** `fix_listtable.py`
**Bug type:** WARNING `Bullet list ends without a blank line; unexpected unindent` + ERROR `Error parsing content block for the "list-table" directive: exactly one bullet list expected`

### Antes (incorrecto)

```rst
.. list-table::
 :widths: 60 20 20
 :header-rows: 1

 * - Responsabilidad
 - UC Relacionado          ← WRONG: same indent as `*`
 - CNST Aplicable          ← parsed as new bullet, not col continuation
 * - Validar credenciales
 - UC_001
 - CNST_005
```

### Despues (correcto)

```rst
.. list-table::
 :widths: 60 20 20
 :header-rows: 1

 * - Responsabilidad
   - UC Relacionado        ← +2 spaces (alinea con texto post `* `)
   - CNST Aplicable
 * - Validar credenciales
   - UC_001
   - CNST_005
```

### Tambien fix de text continuations dentro de cell

```rst
ANTES:                              DESPUES:
 * - CNST_001                        * - CNST_001
 - **Comunicaciones Prohibidas**:      - **Comunicaciones Prohibidas**:
 No enviar email...                      No enviar email...        ← +4 spaces
```

---

## P2 — Section underlines indented more than title

**Volumen:** 2568 criticals (`Unexpected section title`)
**Script:** `fix_section_underline.py`
**Bug type:** CRITICAL `Unexpected section title`

### Antes (incorrecto)

```rst
1. Proposito
   ------------    ← underline a indent 3, titulo a indent 0
```

### Despues (correcto)

```rst
1. Proposito
------------
```

---

## P3 — Bullet text continuations

**Volumen:** 909 warnings
**Script:** `fix_bullet_wrap.py`
**Bug type:** WARNING `Bullet list ends without a blank line; unexpected unindent`

### Antes (incorrecto)

```rst
- ``arquitectura/`` — overview, observability, storage, data
 centralization, design patterns       ← WRONG (mismo indent que `-`)
- ``despliegue/`` — deployment topologies
```

### Despues (correcto)

```rst
- ``arquitectura/`` — overview, observability, storage, data
  centralization, design patterns      ← +2 spaces
- ``despliegue/`` — deployment topologies
```

### Heuristica hibrida (clave)

Para distinguir bullets reales de texto inline tipo
`- UC-001 - UC-002` mid-paragraph:

- Si ya estamos `in_bullet`: confiar en regex.
- Si NO estamos `in_bullet`: exigir contexto valido
  (linea anterior blanca, header, directive, o bullet).

Sin esta heuristica, el script genera 36 falsos positivos.

---

## P4 — Sub-bullets off-by-one indent

**Volumen:** 145 warnings
**Script:** `fix_subbullet_v2.py`
**Bug type:** WARNING `Bullet list ends without a blank line`

### Antes (incorrecto)

```rst
- **Follow Semantic Versioning 2.0.0**:
 - MAJOR: Breaking changes      ← indent 1 (parent es indent 0)
 - MINOR: New features
 - PATCH: Bug fixes
- **Never use leading zeros**
```

### Despues (correcto)

```rst
- **Follow Semantic Versioning 2.0.0**:
  - MAJOR: Breaking changes     ← indent 2 (alinea con texto del parent)
  - MINOR: New features
  - PATCH: Bug fixes
- **Never use leading zeros**
```

### Heuristica conservadora (clave)

Solo re-indenta si:
- Sub-bullet a indent en (parent_indent, parent_target_text_col).
- Sale del scope al ver linea no-blanca a indent <= parent_indent.

Version inicial (`fix_subbullet.py` v1) era stack-based agresiva
y produjo regresion de 374 -> 13838 warnings. Reverted.

---

## P5 — Grid tables malformed

**Volumen:** 97 errors
**Script:** `fix_grid_table.py`
**Bug type:** ERROR `Malformed table`

### Antes (incorrecto)

```rst
+-----------------------------------+---------------------+-------------------------------------------+
| Characteristic | Valid Examples | Invalid Examples |    ← pipes no alinean con +
+===================================+=====================+===========================================+
| Case | kebab-case | ``GitWorkflow``, |
| | | ``Git Workflow``, ``GITWORKFLOW`` |
+-----------------------------------+---------------------+-------------------------------------------+
```

### Despues (convertido a list-table tolerante)

```rst
.. list-table::
   :header-rows: 1

   * - Characteristic
     - Valid Examples
     - Invalid Examples
   * - Case
     - kebab-case
     - ``GitWorkflow``, ``Git Workflow``, ``GITWORKFLOW``
```

Estrategia: convertir grid tables a list-tables — ambas son
RST validas pero list-tables son tolerantes a anchos de
columna inconsistentes.

---

## P6 — code-block::rst lost content indent

**Volumen:** 52 issues (warnings + errors mixed)
**Script:** `fix_codeblock_rst.py`
**Bug type:** WARNING/ERROR varies — list-tables internas que
escapan al code-block scope

### Antes (incorrecto)

```rst
- **Accion**: Listar codigos HTTP:

 .. code-block:: rst

    **Codigos de Estado:**

 .. list-table::                    ← WRONG: parsed as REAL directive
 :header-rows: 1                    ← (no es contenido del code-block)

 * - Codigo
 - Significado
```

### Despues (correcto)

```rst
- **Accion**: Listar codigos HTTP:

 .. code-block:: rst

    **Codigos de Estado:**

    .. list-table::                 ← +3 indent: ahora es contenido
       :header-rows: 1

       * - Codigo
         - Significado
```

---

## P7 — Simple tables ruler mismatch

**Volumen:** 39 errors (`Malformed table`)
**Script:** `fix_simple_table_v2.py`
**Bug type:** ERROR `Malformed table`

### Antes (incorrecto)

```rst
================ ========================================================
Capa Tecnología                                ← contenido compresado
================ ========================================================
Frontend React + Webpack
Backend Django REST Framework (Python 3.11+)
================ ========================================================
```

Los anchos de columna del ruler (16 chars + 56 chars) no
matchean con el contenido real (`Capa Tecnologia` = 15 chars total).

### Despues (convertido a list-table)

```rst
.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Capa
     - Tecnología
   * - Frontend
     - React + Webpack
   * - Backend
     - Django REST Framework (Python 3.11+)
```

### Heuristica para 2-col tables (clave)

Token-based split:
- Header tokens (separados por single space) -> 1 token = col1.
- Body row -> primer N tokens = col1, resto = col2.

Para 3+ col tables: position-based slicing del ruler original
(funciona si el contenido sigue alineacion del ruler).

---

## P8 — rubric directive with indented body

**Volumen:** 12 errors (`Error in "rubric" directive`)
**Script:** `fix_rubric.py`
**Bug type:** ERROR `Error in "rubric" directive`

### Antes (incorrecto)

```rst
.. rubric:: Metadata sugerida para la instancia

   Cuando se crea una instancia a partir de esta plantilla,
   se sugiere declarar el siguiente bloque de metadata:
```

`rubric` solo acepta titulo inline, NO body. El body indentado
genera error.

### Despues (correcto)

```rst
.. rubric:: Metadata sugerida para la instancia

Cuando se crea una instancia a partir de esta plantilla,
se sugiere declarar el siguiente bloque de metadata:
```

(body de-indentado a column 0 — paragrafo regular siguiente
al rubric).

---

## Categorias residuales (manual)

**Volumen:** 37 issues
**Fix:** manual case-by-case

Casos heterogeneos no convertibles algoritmicamente:

- ASCII flowcharts compresados (1 caso, STD_001)
- Tablas con anchos completamente perdidos (3 casos en
  shell-scripting-guide y guia-completa-desarrollo)
- Nested bullets en list-table cells generando row item
  count mismatch (TPL_UC_Actor_Secundario)
- Continuation lines indentadas a +1 instead +2 (residuo
  de fix_bullet_wrap heuristica conservadora)
- code-block::text con contenido y bloque inline mezclado
  (TPL_UC_CRUD_Operaciones, PROC-DEV-001)

Ver commit `0f884df` para listado completo.
