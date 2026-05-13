```yml
project: IACT-docs
work_package: 2026-04-29-05-35-11-md-to-rst-saneamiento
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: related (saneamiento post-rebuild)
created_at: 2026-04-29 05:35:11
current_phase: Cerrado (post-mortem)
flow: thyrox
methodology_step: documentation
author: NestorMonroy
status: Cerrado
```

# WP — Saneamiento md->rst (post-mortem documental)

## Proposito

Documentar el saneamiento sistematico del corpus `source/`
realizado el 2026-04-29 que llevo el build Sphinx de
**19222 issues -> 0 issues** (100%) en 11 batches commit.

Este WP no es de ejecucion — es **post-mortem**: archiva los
9 scripts de transformacion utilizados, explica por que cada
patron de bug existia, y deja la canalizacion lista para
re-uso si se importan mas archivos del mismo pipeline md->rst.

## Causa raiz unica

El conversor md->rst usado para producir el corpus
`source/` (originado en `temp-holding/FASE 01/docs/`) no
recalculo la indentacion como estructura semantica RST.

En **markdown** la indentacion es decorativa — espacios de
sangria visual sin valor sintactico salvo casos puntuales
(code blocks de 4 espacios).

En **RST** la indentacion **es la estructura**: cada nivel
define un contenedor logico (cell de tabla, contenido de
directiva, continuacion de bullet, scope de seccion).

El conversor copio texto preservando la indent visual del
markdown original sin agregar el offset semantico que RST
exige. Resultado: 19222 issues distribuidos en 8 patrones
sistematicos.

## Metricas finales

| Metrica | Antes | Despues | Delta |
|---------|-------|---------|-------|
| WARNING | 17257 | 0 | -17257 |
| ERROR | 1965 | 0 | -1965 |
| CRITICAL | 2581 | 0 | -2581 |
| **Total** | **19222** | **0** | **-100%** |

`build succeeded` con 0/0/0 confirmado en commit `0f884df`.

## Estructura del WP

```
2026-04-29-05-35-11-md-to-rst-saneamiento/
├── wp-state.md                          (este archivo)
├── scripts/                             (9 scripts py archivados)
│   ├── fix_listtable.py
│   ├── fix_bullet_wrap.py
│   ├── fix_section_underline.py
│   ├── fix_directive_content.py
│   ├── fix_grid_table.py
│   ├── fix_simple_table_v2.py
│   ├── fix_subbullet_v2.py
│   ├── fix_codeblock_rst.py
│   └── fix_rubric.py
├── discover/
│   ├── root-cause-analysis.md           (analisis de la causa raiz)
│   ├── patterns-catalog.md              (8 patrones y sus fixes)
│   └── scripts-reference.md             (doc por script)
└── track/
    ├── batches-log.md                   (log de los 11 batches)
    └── md-to-rst-saneamiento-changelog.md
```

## Scope

**In-scope:**
- Documentar 9 scripts py utilizados en saneamiento.
- Explicar cada patron de bug observado.
- Registrar el log de los 11 batches con commits.

**Out-of-scope:**
- Re-aplicar los fixes (ya aplicados).
- Migrar los scripts a herramienta canonica del proyecto
  (eso seria un WP futuro si se mantiene como tooling).
- Investigar el conversor md->rst original (no esta bajo
  control del proyecto).

## Trazabilidad de commits

Los 11 batches del saneamiento (orden cronologico):

```
e71a78d  Fix list-table column continuations
830d258  Fix bullet text continuations
45f640a  Fix section underlines indented more than title
0e14c10  Fix directive content indent + STD_007 README cleanup
c2b9ad7  Convert malformed grid tables to list-tables
16c20f2  Convert malformed RST simple tables to list-tables
546f10d  Fix off-by-one sub-bullet indents
29f6399  Fix code-block::rst lost content indent
fb6daf9  Re-apply list-table + directive-content fixes (cascade)
de48438  Fix rubric directives with indented body
0f884df  Final manual cleanup -> 0 WARN / 0 ERR / 0 CRIT
```

## Estado

**Cerrado.** Documentacion archivada para referencia futura.
