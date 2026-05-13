```yml
created_at: 2026-04-29 05:35:11
project: IACT-docs
work_package: 2026-04-29-05-35-11-md-to-rst-saneamiento
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Root Cause Analysis — md->rst Conversion Bugs

## Hipotesis (origen)

El corpus `source/` proviene de una conversion automatica
md->rst desde `temp-holding/FASE 01/docs/`. El conversor (no
identificado, pero presumiblemente `pandoc` o similar)
preservo la indentacion visual del markdown sin entender
que RST trata indentacion como estructura semantica.

## Diferencia fundamental md vs rst

### Markdown — indentacion decorativa

```markdown
- bullet
text continuation       ← no importa el indent
- another bullet
```

Markdown normaliza el contenido independiente del indent
para casi todos los casos. Solo unos pocos contextos usan
indent (code blocks de 4 espacios, listas anidadas con
spaces opcionales).

### RST — indentacion estructural

```rst
- bullet
  text continuation     ← MUST align with text after marker

  - sub-bullet at +2

next paragraph at base level
```

En RST cada nivel de indent abre un contenedor logico.
Salir del indent cierra el contenedor. La indentacion es
sintaxis, no presentacion.

## Evidencia que es bug del conversor (no errores humanos)

1. **Volumen**: 19222 issues totales — incompatible con
   autoria humana en un corpus de ~700 archivos.

2. **Uniformidad**: cada patron es identico en miles de
   archivos. Humanos generan ruido aleatorio, no patrones
   sistematicos.

3. **Predictibilidad**: 8 scripts simples corrigen 99.8%
   de los issues. Si fueran errores humanos, los fixes
   no serian factorizables.

4. **Co-ocurrencia**: aparecen en archivos provenientes
   del staging md (`temp-holding/FASE 01/docs/`), no en
   archivos creados directamente como `.rst`. Los
   skeleton WPs #8 (backend) y #9 (frontend) creados
   manualmente como rst tienen 0 warnings.

5. **Distribucion**: los warnings se concentran en
   archivos densos en estructura (UC, FR, plantillas,
   procedimientos) — exactamente donde un conversor
   torpe se rompe mas.

## Por que el conversor fallo

El conversor probablemente uso una de estas estrategias
incorrectas:

### A. Mantener indent visual del md

Md authors usan indents arbitrarios para legibilidad.
Conversor copio esos indents tal cual a rst, sin recalcular
el offset semantico que rst exige (target = parent_indent +
marker_length + 1).

Ejemplo:
```
md:                          rst (incorrecto):           rst (correcto):
- bullet                     - bullet                    - bullet
  cont                       cont                          cont
```

### B. Compresion espacial en simple tables

Markdown tables son `| col | col |` — el conversor
genero RST simple tables (`=== ===`) donde los anchos
de columna del ruler no matchean el ancho real del
contenido.

Ejemplo:
```
md original (markdown table):
| Capa     | Tecnologia |
|----------|------------|
| Frontend | React      |

rst generado (incorrecto):
================ ============
Capa Tecnologia
================ ============
Frontend React
================ ============

(la informacion de columna se perdio en la fusion)
```

### C. Inconsistencia con grid tables

Grid tables (`+---+---+` / `|...|`) requieren que pipes
y plus-signs alineen exactamente por columna. El
conversor genero rulers correctos pero pipes en filas
de contenido en posiciones que no matchean — resultado:
Sphinx falla con "Malformed table".

### D. Section headers en bloques indentados

Cuando un heading md (`## X`) estaba dentro de un bloque
indentado (lista, blockquote), el conversor genero el
heading rst (`X\n----`) preservando el indent del
bloque pero sin alinear el title con el underline.

```
md:                        rst (incorrecto):
- list item:               - list item:
  ## Subtitle                Subtitle
                             ----
```

El underline a indent 2, title a indent 2 visualmente,
pero "Subtitle" empieza en col 4 (despues de `- ` del
bullet) mientras `----` empieza en col 2. Mismatch.

### E. Code-block content indent perdido

`.. code-block:: lang` requiere body a indent +3 minimo.
El conversor preservo indent visual del fenced ``` md
block pero no agrego los 3 espacios.

## Patrones identificados (8 total)

Ver `patterns-catalog.md` para detalle de cada uno con
fix correspondiente.

| # | Patron | Volumen | Script |
|---|--------|---------|--------|
| 1 | list-table column continuations | 17797 | fix_listtable.py |
| 2 | section underlines indented | 2568 | fix_section_underline.py |
| 3 | bullet text continuations | 909 | fix_bullet_wrap.py |
| 4 | sub-bullets off-by-one | 145 | fix_subbullet_v2.py |
| 5 | grid tables malformed | 97 | fix_grid_table.py |
| 6 | code-block::rst content | 52 | fix_codeblock_rst.py |
| 7 | simple tables ruler mismatch | 39 | fix_simple_table_v2.py |
| 8 | rubric with body | 12 | fix_rubric.py |
| - | residual edge cases | 37 | manual |

## Leccion operativa

**Cualquier corpus convertido con el mismo pipeline tendra
los mismos bugs.** Los scripts en `scripts/` son la
canalizacion post-conversion que faltaba en el pipeline
original.

Si en el futuro se importan mas archivos via md->rst:

1. Aplicar los scripts en orden:
   ```
   fix_listtable.py
   fix_section_underline.py
   fix_bullet_wrap.py
   fix_subbullet_v2.py
   fix_grid_table.py
   fix_simple_table_v2.py
   fix_codeblock_rst.py
   fix_directive_content.py
   fix_rubric.py
   ```

2. `make clean && make html` despues de cada script,
   verificar delta antes de pasar al siguiente.

3. Casos residuales heterogeneos requieren fix manual
   (estimado <2% del volumen).

## Anti-patrones detectados durante el saneamiento

- **`plantuml_syntax_error_image = True`**: tolerar errores
  contradice politica 0/0. Removido. Ver commit `9289895`.

- **Heuristica estricta de bullet detection sin tracking
  de estado `in_bullet`**: rompe bullets reales que
  siguen a continuaciones de texto. Ver commit revertido
  durante batch 2.

- **Sub-bullet stack-based con re-indent agresivo**:
  produjo regresion masiva (374 -> 13838 warnings). Ver
  revert durante batch antes de fix_subbullet_v2.py.

- **Position-based slicing para tablas con anchos
  perdidos**: irrecuperable, slicing produce mid-word
  splits. Solucion: token-based heuristics (1er token
  = col1) o fix manual.
