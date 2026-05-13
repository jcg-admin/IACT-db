```yml
created_at: 2026-04-29 16:50:00
project: IACT-docs
work_package: 2026-04-29-16-17-35-std007-spec-gaps-cleanup
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# F-06 — Guías sin prefijo en `normativa/estandares/`

## Hechos verificados (T-003)

3 archivos sustantivos en `source/normativa/estandares/` sin
prefijo `std-` ni `tpl-`:

| Archivo | Líneas | Frontmatter | `:tipo:` | Refs in |
|---------|-------:|-------------|----------|---------|
| `guia-estilo.rst` | 898 | ✓ Schema A | `Guia` | index.rst:77 |
| `estandares-codigo.rst` | 656 | ✓ Schema A | `Guia` | index.rst:78 |
| `shell-scripting-guide.rst` | 1076 | ✓ Schema A | `Guia` | index.rst:79 |

Todos tienen frontmatter completo y son referenciados desde
`normativa/estandares/index.rst` en su propio toctree
(probablemente `:caption: Guías técnicas`).

## Análisis

Estos NO son violaciones reales de STD_007 §3 (kebab-lowercase ✓).
La "violación" percibida es categorial: el directorio
`estandares/` se asume contenga solo STDs formales numerados o
plantillas TPL.

**Pero** los archivos:

- Declaran `:tipo: Guia` explícitamente.
- No tienen ID `STD_XXX` ni son plantillas.
- Son largos y sustantivos (656-1076 líneas).
- Complementan a los STDs formales (estilo, código, shell).

Son **guías normativas** legítimas en el directorio.

## Opciones evaluadas

| Op | Acción | Costo físico | Beneficio |
|----|--------|-------------:|-----------|
| **A** | Dejar como está + documentar excepción en STD_007 v2.0.2 §4 | 0 renames | preserva refs, reconoce el tipo `Guia` legítimo en `estandares/` |
| B | Asignar prefijo `gui-NNN-*` | 3 renames + refs | introduce prefijo nuevo no documentado |
| C | Mover a `source/normativa/guias/` (nuevo dir) | 3 moves + refs + toctree + dir creation | rompe afinidad temática con STDs |

## Decisión: Opción A

Documentar en STD_007 v2.0.2 §4 (sección "Guías sin prefijo"):

> Los archivos sin prefijo (`<descripcion-kebab>.rst`) pueden
> vivir en directorios temáticos junto a artefactos numerados
> cuando son **guías normativas** complementarias. La
> distinción categorial vive en el campo `:tipo:` del
> frontmatter (`:tipo: Guia` vs `:tipo: Estándar`), no en el
> directorio.

## Acción concreta para Bloque B

Agregar a STD_007 v2.0.2 §4 una nota explícita autorizando
guías sin prefijo en directorios temáticos. Sin renames.

## Cierre del finding

F-06 → **resuelto sin acción física** (decisión de spec
en Bloque B).
