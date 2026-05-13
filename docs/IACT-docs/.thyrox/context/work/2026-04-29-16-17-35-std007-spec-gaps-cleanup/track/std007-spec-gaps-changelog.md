```yml
created_at: 2026-04-29 17:35:00
project: IACT-docs
work_package: 2026-04-29-16-17-35-std007-spec-gaps-cleanup
phase: Phase 11 — TRACK
author: NestorMonroy
status: Cerrado
version: 1.0.0
```

# WP Changelog — STD_007 Spec Gaps Cleanup

## Resumen

WP cierra los 13 findings F-01..F-13 detectados por deep-review
adversarial sobre el WP previo `std007-rename-cleanup`. Bump
STD_007 v2.0.1 → v2.0.2 (PATCH compatible) + 9 file renames + 51
schema migrations + 35 metadata blocks agregados + 2 archivos
F-10 críticos reparados.

## Re-audit final (T-019)

| Finding | Resultado |
|---------|----------:|
| F-01 (procedimiento-* sin MOD-NNN) | **0** ✓ |
| F-02 (arq-mod-* documentado) | ✓ doc |
| F-03 (adr/rnf modules documentados) | ✓ doc |
| F-04 (alcance :artefacto: clarificado) | ✓ doc |
| F-05 (regla filenames únicos) | ✓ doc |
| F-06 (guías sin prefijo en estandares/) | ✓ doc |
| F-07 (sin .. meta::) | **0** ✓ |
| F-08 (sin :version:) | **0** ✓ |
| F-09 (sin fecha) | **0** ✓ |
| F-10 (híbridos MD/RST) | **0** ✓ |
| F-11 (anchor labels dups) | **0** ✓ |
| F-12 (archivos huérfanos) | **0** ✓ |
| F-13 (schema legacy UC) | **0** ✓ |
| Build SPHINX_NITPICKY=1 | **0/0/0** ✓ |
| Hard checks (uppercase/underscore) | **0** ✓ |

## Métricas finales

| Métrica | Cant |
|---------|-----:|
| Archivos físicamente renombrados (F-01) | 9 |
| Archivos con migración de schema (F-13) | 51 |
| Archivos con .. meta:: agregado (F-07) | 35 |
| Archivos F-10 críticos reparados | 2 |
| Archivos con campo `:fecha:` → `:fecha_creacion:` | 45 |
| Archivos modificados total | ~140 |
| Commits Tim Pope | 6 |
| Build verde tras cada commit | 6/6 |

## Added

- ADR `adr-std007-spec-gaps-fix.md` — 7 decisiones
  arquitectónicas fundamentando v2.0.2.
- STD_007 §3.5 (regla filenames únicos + 3 excepciones).
- STD_007 §4 ampliado: prefijo `arq` con módulo `mod`; tablas
  de módulos para `adr-` y `rnf-`.
- STD_007 §5.4 (guías sin prefijo en directorios temáticos).
- STD_007 §6 (nuevo) — Schema canónico de metadata YAML +
  deprecación schema legacy UC.
- 35 archivos con frontmatter `.. meta::` canónico (12 ADRs,
  6 checklists, 5 plantuml-guide, 3 gestion, 1 plantilla, 8 misc).
- Scripts en `plan-execution/scripts/`:
  - `rename-procedimientos.py` — F-01 mapping.
  - `update-procedimiento-refs.py` — refs cascade F-01.
  - `migrate-uc-schema.py` — F-13 mapping legacy → canonical.
  - `add-meta-block.py` — F-07/08/09 meta block insertion.

## Changed

- `STD_007_Convencion_Naming.rst` v2.0.1 → **v2.0.2** (PATCH
  compatible).
- 9 procedimiento-* renombrados a proc-<MOD>-<NNN>:
  - 2 → proc-dev-003/004 (desarrollo-local, diseno-tecnico)
  - 2 → proc-qa-003/004 (analisis-seguridad, qa)
  - 2 → proc-gob-011/012 (gestion-cambios, revision-documental)
  - 1 → proc-ops-003 (instalacion-entorno)
  - 1 → proc-devops-002 (release)
  - 1 → proc-req-019 (trazabilidad-requisitos)
- 51 archivos UC/FR migrados de schema legacy a canonical:
  - `:uc_id:` → `:artefacto:`
  - `:date:` → `:fecha_creacion:`
  - `:status:` → `:estado:`
  - `:module:` → `:subdominio:`
  - `:project:` → eliminado
- 45 archivos FR: `:fecha:` (singular) → `:fecha_creacion:`.
- 2 archivos rnf-proc: título legacy `<NAME>.md` reemplazado por
  frontmatter `.. meta::` + título RST canónico.

## Removed

- Schema legacy UC del corpus (preservado solo en STD_007 §6.3
  como documentación de campo deprecado).
- 9 archivos `procedimiento-<desc>.rst` sin clasificación
  (re-clasificados a proc-<MOD>-<NNN>).
- 2 títulos legacy `RNF-PROC-NNN_NAME.md` (artefactos del
  saneamiento md→rst incompleto).

## Aceptado / no fixeado

- 8 archivos `arq-mod-NNN-*` mantienen el prefijo `arq-` —
  reinterpretado y documentado en STD_007 v2.0.2 §4 como
  prefijo canónico `arq` con módulo `mod`.
- 3 guías en `normativa/estandares/` (`guia-estilo`,
  `estandares-codigo`, `shell-scripting-guide`) mantienen
  formato sin prefijo — autorizadas explícitamente en §5.4 por
  `:tipo: Guia`.
- 3 pares de filenames duplicados (`conventions.rst`,
  `overview.rst`, `etl-pipeline.rst`) preservados en sus paths
  paralelos — autorizados explícitamente como excepción en §3.5.

## Status de promoción a CHANGELOG.md raíz

Pendiente del próximo merge a `main` con bump de versión.
Cuando llegue el merge, promover entradas relevantes:

- **STD_007 v2.0.2**: PATCH spec gaps closure — 7 decisiones
  documentadas en ADR. Schema canónico de metadata YAML
  formalizado. 9 procedimientos re-clasificados, 51 schemas
  migrados, 35 archivos con metadata agregada.
- **ADR adr-std007-spec-gaps-fix**: ADR de cierre de gaps tras
  deep-review adversarial.

## Lecciones aprendidas

1. **Deep-review adversarial encuentra lo que la verificación
   automatizada del build no detecta.** Build verde 0/0/0 es
   condición necesaria pero NO suficiente. Sphinx acepta
   metadata heterogénea, schemas inconsistentes, y títulos
   legacy mientras el RST sea sintácticamente válido.

2. **Recalibración de cifras durante el WP es saludable.**
   F-09 inicial = 133 (sobreestimado por solo medir
   `:fecha_creacion:`); real = 74 + 45 con `:fecha:`. F-07 =
   29 vs 37 inicial (variación por línea de scan). El triaje
   evitó trabajo redundante.

3. **F-10 (híbridos MD/RST) fue menor de lo temido (5 → 2 reales).**
   Las heurísticas iniciales generaron falsos positivos por
   ejemplos intencionales en bloques `.. code:: markdown`.

4. **F-13 (schema split) emergió DURANTE el WP**, no en el
   inventory inicial. Surge porque archivos UC nunca fueron
   considerados al definir el schema canónico — 49 archivos
   tenían su propio formato. Resolución: documentar el schema
   canónico explícitamente (§6) + migración 1:1.

5. **Mapping explícito > transformación heurística.** Para F-01
   y F-13, el script con mapping explícito por nombre fue
   100% predecible. Para F-15, la inferencia de campos del
   path/filename funcionó pero requería defaults seguros.

6. **`.. meta::` block como prefijo del archivo es safe.**
   Insertar al inicio NO rompe la estructura RST (Sphinx
   acepta meta como primer elemento). Build verde tras los 35.

## Commitment activo (sin cambio)

**30 días sin modificar STD_007** vigente desde v2.0.0
(commitment NO se reinicia en v2.0.1 ni v2.0.2 que son PATCH
compatibles). Cierre del commitment: **2026-05-29**.

## Commits del WP

```
f704a6c — Open WP std007-spec-gaps-cleanup with findings inventory
a5f9c7b — Document findings execution order in WP analyze
a634e23 — Complete Block A — Measure & Analyze for spec-gaps WP
2635dda — Bump STD_007 to v2.0.2 closing spec gaps F-01..F-13
5946129 — Migrate F-01: 9 procedimiento-* to proc-MOD-NNN-* canonical
41cae6c — Fix F-10: replace literal .md titles with proper RST frontmatter
4852e24 — Migrate F-13: 51 legacy UC schema to canonical metadata
3ab5484 — Add canonical .. meta:: blocks to 35 files + fix :fecha: legacy
3083a01 — Close WP std007-spec-gaps-cleanup with all F-01..F-13 resolved
```

9 commits del scope formal.

## Post-closure adjustments

Tras el cierre formal del WP (commit `3083a01`), se ejecutaron 2
revisiones adicionales sobre el mismo scope que produjeron correcciones
sin reabrir formalmente el WP. Documentadas aquí para trazabilidad.

### Hot-fix 1 (`cb5d19d`) — Bugs detectados por deep-review post-cierre

Segundo deep-review adversarial detectó 3 bugs introducidos por las
migraciones del scope:

| Bug | Severidad | Origen | Resolución |
|-----|-----------|--------|------------|
| 8 archivos `arq-mod-*` con DOBLE `.. meta::` | MAJOR | T-015 add-meta-block.py usaba `head -3` y no detectó meta interno preexistente en línea ~22 | Script de fix dropea bloque insertado, normaliza el original (kebab dominio, hyphen artefacto, Aprobado state) |
| 45 archivos FR sin `:clasificacion:` | MAJOR | T-014 migrate-uc-schema.py no agregaba este default (sí lo hacía add-meta-block.py) | Sed agrega `:clasificacion: Interno` después de `:autor:` |
| 2 plantuml/ejemplos con `:tipo: Caso de Uso` incorrecto | MINOR | T-014 aplicó defaults legacy UC a 2 archivos plantuml | Manual fix a `:tipo: Test/Ejemplo` + `:dominio: plantuml-guide` + agregar `:artefacto:` |

Falsos positivos confirmados (sin acción): A-02, A-09, A-24, A-25, A-26.

Build verificado tras los fixes: 0 warnings con SPHINX_NITPICKY=1.

### Hot-fix 2 (`b748039`) — Cold rebuild detectó renumber inconsistencies

`make clean && make html` detectó **2 warnings** que el build incremental
había ocultado (cache parcial sobre headers ya renderizados):

```
std-007-convencion-naming.rst:701: WARNING: Title underline too short.
```

Origen: bump v2.0.2 renumeró §6→§7→§8→§9→§10 pero NO actualizó:

- Subrayado de `10. Cumplimiento` (15 chars vs título 16)
- 6 subsecciones con numeración antigua: §7.1/§7.2/§7.3 (ahora §8.x —
  Convención de Idioma), §8.1/§8.2/§8.3 (ahora §9.x — Decisiones de
  Gobernanza), §9.1/§9.2 (ahora §10.x — Cumplimiento)

Fix: extender underline + renumerar las 6 subsecciones.

### Verificación exhaustiva del cold rebuild

```bash
make clean && SPHINX_NITPICKY=1 SPHINXOPTS="-W --keep-going" make html
# build succeeded. Exit code: 0
```

| Métrica | Valor |
|---------|-------|
| Tiempo cold rebuild | 2m19s |
| Líneas log build | 64 |
| `grep -ci warning` | **0** |
| `grep -ci error` | **0** |
| `grep -ciE 'severe\|critical'` | **0** |
| Frase final del log | `build succeeded.` (sin sufijo "with N warnings") |
| Exit code con `-W --keep-going` | **0** |

`-W` convierte CUALQUIER warning en error. Exit 0 = literalmente
cero warnings en el corpus.

### Lección aprendida

**Cold rebuilds son obligatorios después de renumeración estructural
de un documento.** Builds incrementales con cache parcial ocultan
warnings sobre headers ya renderizados que cambian de tamaño/estructura
en la edición.

**Política propuesta para el flujo:** todo bump MAJOR/MINOR de un STD
debe cerrar con `make clean && SPHINX_NITPICKY=1 make html` antes del
commit final. PATCH bumps que solo cambian texto inline pueden seguir
con incremental.

## Commits totales (incluyendo post-closure)

```
f704a6c, a5f9c7b, a634e23, 2635dda, 5946129, 41cae6c, 4852e24,
3ab5484, 3083a01 — scope formal del WP (9)
cb5d19d, b748039  — post-closure adjustments (2)
```

**11 commits totales.**
