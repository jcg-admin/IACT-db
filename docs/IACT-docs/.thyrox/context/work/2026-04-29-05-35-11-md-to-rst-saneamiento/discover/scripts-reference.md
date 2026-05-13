```yml
created_at: 2026-04-29 05:35:11
project: IACT-docs
work_package: 2026-04-29-05-35-11-md-to-rst-saneamiento
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Scripts Reference — Saneamiento md->rst

9 scripts archivados en `../scripts/`. Todos:
- Reciben archivo o directorio como argumento (recursivo).
- Son **idempotentes** (segunda corrida = 0 cambios).
- Modifican archivos in-place.
- No tienen dependencias externas (solo stdlib Python 3.11+).

Uso general:

```bash
python3 fix_<name>.py source/        # apply to all .rst recursively
python3 fix_<name>.py path/to/file.rst   # single file
```

Orden recomendado de aplicacion (dependencias):

```
1. fix_listtable.py
2. fix_section_underline.py
3. fix_bullet_wrap.py
4. fix_subbullet_v2.py
5. fix_grid_table.py
6. fix_simple_table_v2.py
7. fix_directive_content.py
8. fix_codeblock_rst.py
9. fix_rubric.py
```

`make clean && make html` despues de cada script para
verificar delta antes de seguir.

---

## fix_listtable.py

**Pattern:** P1 (list-table column continuations)
**Volumen tipico:** ~17000 issues
**Lineas:** 116

### Que hace

Detecta bloques `.. list-table::` y arregla:

1. **Column continuations** rotas: lineas `<RI>- Y` al mismo
   indent que `<RI>* -` (row marker), re-indentadas a
   `<RI>  - Y` (+2 espacios).

2. **Text continuations** dentro de cell: lineas de texto
   plano al mismo indent que el row marker, re-indentadas
   a `<RI>    text` (+4 espacios para alinear con texto
   post-`- `).

### Heuristica clave

Solo aplica si la primera continuacion vista es del tipo
broken (`<RI>- Y`). Si la tabla ya esta bien formada
(`<RI>  - Y`), no se toca. Esto preserva tablas correctas
y evita regresion en mixed-format files.

### Idempotencia

Garantizada. Segunda corrida: 0 cambios porque la deteccion
falla — ya no hay `<RI>- ` al mismo indent que `<RI>* -`.

---

## fix_section_underline.py

**Pattern:** P2 (section underlines indented)
**Volumen tipico:** ~2500 criticals
**Lineas:** 65

### Que hace

Para cada linea que es solo `=`/`-`/`~`/`^`/etc. (>=3 chars),
verifica si la linea anterior (titulo) tiene MENOS indent.
Si si, re-indenta el underline al indent del titulo.

```rst
ANTES:                  DESPUES:
1. Proposito            1. Proposito
   ------------         ------------
```

### Heuristica clave

Lo opuesto al "subir" hubiera sido detectar y "bajar" el
titulo, pero eso afectaria estructura. Bajar el underline
es siempre seguro: el char de underline no tiene contenido,
solo dimensiona el title.

---

## fix_bullet_wrap.py

**Pattern:** P3 (bullet text continuations)
**Volumen tipico:** ~900 warnings
**Lineas:** 130

### Que hace

Detecta `<I>- text` y siguiente line a indent en
`[len(I), len(I) + marker_len)`. Re-indenta a
`len(I) + marker_len` para alinear con texto post-marker.

### Heuristica clave (hibrida)

Sin tracking de estado, el script mata bullets reales.
Con tracking conservador, mata texto inline.

Solucion hibrida:

```python
if in_bullet:
    # Trust regex — already established list scope
    is_real_bullet = (cur_indent >= bullet_indent)
else:
    # Strict context check
    is_real_bullet = is_valid_bullet_start(prev_line)
```

Donde `is_valid_bullet_start` exige que la linea anterior
sea blanca, header, directive, o bullet a igual/menor indent.

Sin esto: 36 falsos positivos (regression `Unexpected indentation`).
Con esto: 1 falso positivo (residual fixable manual).

---

## fix_subbullet_v2.py

**Pattern:** P4 (sub-bullets off-by-one)
**Volumen tipico:** 100-150 warnings
**Lineas:** 95

### Que hace

Para cada bullet/enum line `<I>- text`:
- Si la siguiente line es `<I+N>- ...` con `0 < N < marker_len`:
  re-indenta a `<I+marker_len>`.
- Continua re-indentando subsequent bullets al mismo `<I+N>`
  hasta ver linea no-blanca a indent <= parent_indent.

### Por que v2

`fix_subbullet.py` (v1) usaba stack de niveles abiertos y
era demasiado agresivo: produjo regresion 374 -> 13838
warnings (39x peor). Revertido.

v2 es no-stack, parent-by-parent:
- Detecta solo el caso off-by-1 a off-by-(marker_len - 1).
- No intenta tracking jerarquico complejo.
- Mucho mas conservador.

---

## fix_grid_table.py

**Pattern:** P5 (grid tables malformed)
**Volumen tipico:** ~100 errors
**Lineas:** 165

### Que hace

Parsea grid tables (`+---+---+` rulers + `|...|` rows) y
las reescribe como `.. list-table::` con `:header-rows: 1`
si detecta header ruler (`===`).

### Por que convertir, no fix in-place

Grid tables exigen alineamiento exacto entre rulers y pipes.
Cuando el conversor md->rst comprimio cells, los pipes
quedan desplazados — recuperar el alineamiento original es
imposible (informacion perdida).

list-table no tiene este problema: los anchos son
declarativos (`:widths:` opcional), las cells son bullets
sueltos.

### Heuristica de cell merge

Cells multi-linea (cuando un valor de columna se extiende a
varias lineas entre 2 rulers) se fusionan con espacio entre
fragmentos.

---

## fix_simple_table_v2.py

**Pattern:** P7 (simple tables ruler mismatch)
**Volumen tipico:** ~40 errors
**Lineas:** 175

### Que hace

Parsea simple tables (`=== ===` rulers) y convierte a
list-tables.

### Heuristica para 2-col tables (token-based)

Cuando los anchos del ruler no matchean con el contenido,
position-based slicing produce mid-word splits. v2 usa:

- Header `Token1 Token2` -> col1 = primer token, col2 = resto.
- Body row -> primer N tokens = col1, resto = col2.

### Heuristica para 3+ col tables (position-based)

Para tablas con 3+ columnas, fallback a slicing posicional
del primer ruler. Funciona cuando el contenido SI sigue el
alineamiento (caso minoritario).

### Limitacion conocida

Tablas con anchos completamente perdidos requieren fix
manual (~3-4 archivos del corpus). v1 (`fix_simple_table.py`)
tambien archivado pero deprecado por sus garbage outputs.

---

## fix_directive_content.py

**Pattern:** complemento de P6 — content de directivas a
mismo indent que la directiva
**Volumen tipico:** ~60 issues
**Lineas:** 130

### Que hace

Para directivas en lista canonica (code, code-block,
list-table, note, warning, tip, etc.), re-indenta el
contenido a `directive_indent + 3` cuando esta a indent
incorrecto (= directive_indent o menor pero >= directive_indent).

### Heuristica clave

Distingue:
- Options del directive (`<DI>   :option: value`) — no
  tocar.
- Blank lines — pasan tal cual.
- Content lines — re-indentar.

### Salida del scope

Cuando ve linea con indent < directive_indent, salir.
Cuando ve linea a indent == directive_indent que parece
sibling (e.g. otra directiva), salir.

---

## fix_codeblock_rst.py

**Pattern:** P6 (code-block::rst lost content)
**Volumen tipico:** ~50 issues
**Lineas:** 95

### Que hace

Especifico para `.. code-block:: rst` — donde el contenido
es ejemplo de codigo RST. El conversor md->rst perdio el
+3 indent estandar, asi que las directivas internas
(`.. list-table::`, `::`, etc.) eran procesadas como
directivas reales.

Re-indenta lineas de contenido a `>= directive_indent + 3`,
hasta encontrar:
- Linea blanca seguida por content a indent < directive_indent
- Bullet marker `- ` al directive_indent (sibling list)

### Por que es separado de fix_directive_content.py

Code-block::rst tiene scope mucho mas largo (ejemplos
completos de RST con multiples directivas internas).
fix_directive_content sale del scope tan pronto como ve
linea a indent <= di_len. fix_codeblock_rst aguanta el
scope hasta sibling explicito.

---

## fix_rubric.py

**Pattern:** P8 (rubric con body indentado)
**Volumen tipico:** 12 errors
**Lineas:** 70

### Que hace

`rubric` solo acepta titulo inline. Lineas indentadas
despues son ERROR. El script de-indenta esas lineas a
columna del rubric (= no es content del rubric, es
parrafo regular siguiente).

```rst
ANTES:                            DESPUES:
.. rubric:: Title                 .. rubric:: Title

   Body content                   Body content
```

### Heuristica clave

Solo dedent — no eliminar el rubric. El rubric es valido
como title-decorator inline; el problema era el body
indentado adyacente.
