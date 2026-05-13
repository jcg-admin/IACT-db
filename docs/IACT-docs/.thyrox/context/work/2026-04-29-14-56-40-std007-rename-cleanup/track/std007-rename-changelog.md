```yml
created_at: 2026-04-29 16:30:00
project: IACT-docs
work_package: 2026-04-29-14-56-40-std007-rename-cleanup
phase: Phase 11 — TRACK
author: NestorMonroy
status: Cerrado
version: 1.0.0
```

# WP Changelog — STD_007 Rename Cleanup (v2.0.0 universal kebab)

## Resumen

Migración del corpus `source/` al patrón universal STD_007 v2.0.0
`<prefix>-<NNN>-<descripcion-kebab>.rst` minúsculas. Reemplaza la
heterogeneidad de 5 dialectos previa por una sola regla.

## Métricas finales (verificadas)

| Métrica | Cantidad |
|---------|---------:|
| Archivos `.rst` renombrados | 315 |
| Directorios públicos renombrados | 18 |
| Directorios `_*` Sphinx con kebab interno | 3 |
| Refs `:doc:` + toctree + labels actualizadas | 370+ |
| Commits estructurales | 10 |
| Tiempo total ejecución | 1 sesión |
| Build status final | verde 0/0/0 con `SPHINX_NITPICKY=1` |

## Added

- ADR `adr-naming-conventions-kebab-correction.md` — corrección
  temprana del ADR original con argumentación técnica
  (premisas invalidadas, salvaguarda 30 días).
- Script `plan-execution/scripts/migrate-naming.py` — migrador
  idempotente con `--dry-run`, `--pilot`, `--domain`, `--execute`.
- Script `plan-execution/scripts/fix-broken-refs.py` — fixer
  post-hoc para toctree/`:doc:` que el migrador no captura
  cuando hay rename de directorio padre.

## Changed

- `STD_007_Convencion_Naming.rst` v1.1.0 → v2.0.0 — bump MAJOR.
  §3 reescrito como "Reglas Universales", §4 colapsa los 5
  dialectos en un solo patrón con prefijo, §5 directorios kebab
  con excepción `_*` Sphinx, §8.2 nuevo "Commitment de
  estabilidad 30 días".
- 315 archivos `.rst` renombrados via `git mv` (preserva
  historial). Distribución por categoría:
  - UC: 59 (incluye 11 dirs `UC_NNN_*` → `uc-NNN-*`)
  - Sin prefijo (guías, checklists): 54
  - FR: 45
  - CNST: 33
  - TPL: 28
  - BR: 20
  - ADR: 20
  - PROCED: 14
  - PROC: 10
  - FND: 8
  - STD: 6
  - META: 5
  - SBVR: 5
  - MTM: 3
  - TXM: 3
  - RNF: 2
- 18 directorios públicos renombrados:
  `arquitectura_tecnica`, `base_cognitiva`, `requisitos_funcionales`,
  `requisitos_no_funcionales`, `casos_uso`, `reglas_negocio`,
  `manuales_usuarios`, 11× `UC_NNN_*` (todos en
  `requisitos_funcionales/`).
- 3 directorios `_*` con kebab interno preservando `_`:
  `_taxonomias_y_metamodelos`, `_ontologia_sbvr`,
  `_fundamentos_conceptuales`.

## Removed

- 4 archivos `index.rst` huérfanos eliminados durante la migración
  (sub-directorios consolidados que ya no requerían entry-point
  separado: `requisitos_funcionales/access/UC_011_*`,
  `requisitos_funcionales/auth/`, `_taxonomias_y_metamodelos/taxonomias`).

## Aceptado / no fixeado

- Refs externas en navegador / GitHub Pages históricos: se
  rompen una vez. Aceptadas como deuda transitoria — el
  beneficio estructural supera el costo.
- `git log --follow` de archivos renombrados puede degradar
  levemente. Mitigación aplicada: rename PURO (sin tocar
  contenido) en cada `git mv`.

## Status de promoción a CHANGELOG.md raíz

Pendiente del próximo merge a `main` con bump de versión.
Cuando llegue el merge, promover entradas relevantes:

- **STD_007 v2.0.0**: Cambio MAJOR — convención de naming
  unificada universal kebab-lowercase. 315 archivos + 18 dirs
  renombrados. Refs actualizadas en cascada. Build sin
  warnings.
- **ADR adr-naming-conventions-kebab-correction**: ADR de
  corrección, distinguido de revocación arbitraria por
  ventana <48h + análisis cuantitativo + commitment 30 días.

## Lecciones aprendidas

1. **Mapeo dir+file en cascada:** el migrador inicial calculaba
   `file_map` con paths PRE-rename, pero el ref-update pass los
   procesa POST-rename de directorios. Resultado: toctrees con
   paths relativos no resolvían cuando el dir padre había
   cambiado. Solución: post-hoc `fix-broken-refs.py` que detecta
   targets inexistentes y prueba la versión kebab.
2. **PILOT vale el costo:** descubrió la ausencia de soporte
   para refs relativas en toctrees antes del bulk. Ahorró
   reverter cientos de archivos.
3. **Dominio por dominio > big-bang:** 8 commits granulares
   permitieron build-verify entre cada batch. Si algo se hubiera
   roto en el dominio N, los 1..N-1 ya estaban verdes y commiteados.
4. **`SPHINX_NITPICKY=1` como gate:** sin nitpicky el build
   succeede aunque haya refs huérfanas. Usar siempre nitpicky
   en gates de migración estructural.

## Commitment activo (vigente hasta 2026-05-29)

**30 días sin nuevas modificaciones a STD_007** — STD_007
v2.0.0 §8.2. Si surge evidencia que justifique nueva
modificación, abrir WP propio con deep-review previo.

## Commits del WP (10 total)

1. `cba89ec` — Add ADR correcting STD_007 to universal kebab pattern
2. `ca2f3b1` — Update STD_007 to v2.0.0 universal kebab pattern
3. `b4b1dea` — Add migration script and recalibrate inventory to v2.0.0
4. `2e3b39f` — Fix script and apply PILOT rename for STD_006
5. `e0953fb` — Migrate normativa/estandares to v2.0.0 kebab pattern
6. `c0860bf` — Migrate normativa/procedimientos to v2.0.0 kebab pattern
7. `0899834` — Migrate normativa/gobernanza to v2.0.0 kebab pattern
8. `dfd4d0e` — Migrate requisitos to v2.0.0 kebab pattern
9. `e7e017d` — Migrate arquitectura_tecnica to v2.0.0 kebab pattern
10. `8210236` — Migrate gestion to v2.0.0 kebab pattern
11. `c049dde` — Migrate base_cognitiva to v2.0.0 kebab pattern
12. `b69e937` — Migrate normativa/restricciones to v2.0.0 kebab pattern
