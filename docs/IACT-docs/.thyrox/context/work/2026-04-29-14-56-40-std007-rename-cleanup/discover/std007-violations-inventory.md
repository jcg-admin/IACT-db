```yml
created_at: 2026-04-29 14:56:40
updated_at: 2026-04-29 16:00:00
project: IACT-docs
work_package: 2026-04-29-14-56-40-std007-rename-cleanup
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado (recalibrado contra STD_007 v2.0.0)
version: 2.0.0
```

# STD_007 Violations Inventory — recalibrado contra v2.0.0

> **v1.0.0** registró 23 violaciones contra el patrón heterogéneo
> previo (5 dialectos). **v2.0.0** recalibra contra el patrón
> único `<prefix>-<NNN>-<descripcion-kebab>.rst` minúsculas.

## Cifras verificadas (2026-04-29)

| Métrica | Cantidad | Comando de verificación |
|--------:|---------:|-------------------------|
| Archivos `.rst` totales | 401 | `find source -type f -name "*.rst" \| wc -l` |
| `index.rst` (preservados) | 48 | `find source -type f -name "index.rst" \| wc -l` |
| **Archivos a renombrar** | **315** | `find source -type f -name "*.rst" ! -name "index.rst" \| awk -F/ '{print $NF}' \| grep -E '[A-Z_]' \| wc -l` |
| Directorios totales | 64 | `find source -type d \| wc -l` |
| Directorios `_*` (preservados) | 6 | `find source -type d -name "_*" \| wc -l` |
| **Directorios a renombrar** | **18** | `find source -type d \| awk -F/ '{print $NF}' \| grep -vE '^_' \| grep -E '[A-Z_]' \| wc -l` |
| `:doc:` refs | 242 | `grep -rn ":doc:" source --include="*.rst" \| wc -l` |
| `:ref:` refs | 128 | `grep -rn ":ref:" source --include="*.rst" \| wc -l` |
| Toctree blocks | 123 | `grep -rn "toctree::" source --include="*.rst" \| wc -l` |

## Transformación canónica

```
NOMBRE_VIEJO.rst              → nombre-viejo.rst
PROC-DEV-001-pipe_trab.rst    → proc-dev-001-pipe-trab.rst
UC_ACC_01_Asignar_Func.rst    → uc-acc-01-asignar-func.rst
FR-010.01_Listar_func.rst     → fr-010-01-listar-func.rst
arquitectura_tecnica/         → arquitectura-tecnica/
UC_001_Iniciar_Sesion/        → uc-001-iniciar-sesion/
```

**Reglas de transformación:**

1. Lowercase total (`A-Z` → `a-z`).
2. Underscore → hyphen (`_` → `-`) en descripciones.
3. Punto entre número y sub-número → hyphen (`.` → `-`) — solo
   aplica a FR (único caso conocido).
4. Excepciones preservadas:
   - `index.rst` (palabra simple ya en minúsculas).
   - Directorios con prefijo `_` (`_static/`, `_templates/`,
     `_metadata/`, etc.) — el prefijo `_` se preserva, el resto
     del nombre se transforma a kebab-case.

## Categorías de violación (por tipo de prefijo)

> Conteos exactos por categoría se generan en runtime con
> `scripts/migrate-naming.py --dry-run --by-category`.

Categorías esperadas según prefijo:

- `STD_*` (estándares numerados snake+Pascal)
- `UC_*` (casos de uso)
- `BR_*`, `BReq_*`, `CNST_*`, `META_*`, `FND_*`, `SBVR_*`, `MTM_*`,
  `TXM_*`, `GOB_*`, `TPL_*` (artefactos snake+Pascal)
- `ADR-*-*-*`, `PROCED-*-*-*`, `PROC-*-*-*`, `RNF-*-*-*` (kebab
  con uppercase prefix/MOD)
- `FR-NNN.NN_*` (mixed con punto)
- Guías sin prefijo con `_` (`shell_scripting_guide.rst`,
  `plantilla_adr.rst`, `checklist_*.rst`, `deployment_plan.rst`)

## Riesgos específicos del scope ampliado

| Riesgo | Mitigación |
|--------|-----------|
| 315 renames + 370 refs + 123 toctrees → ventana grande de error | Script idempotente con `--dry-run`, PILOT, batches verificados |
| `git mv` masivo puede saturar índice en 1 commit | Particionar por dominio: estandares, requisitos, arquitectura, etc. |
| Directorios renombrados invalidan paths absolutos en toctrees | Renames bottom-up + rewrite de toctrees en mismo commit |
| `:ref:` con labels case-sensitive | Los labels son independientes del filename — no requieren rename salvo que la propia label esté mal escrita |
| Refs externas (PRs históricos, GitHub Pages) | Aceptar como deuda transitoria documentada |

## Verificación cruzada

Files PASAN hard checks (§3.2 de STD_007 v2.0.0):

- 0 espacios
- 0 tildes/eñe
- 0 paréntesis
- 0 versión en filename
- 0 > 100 chars

**Lo que violan:** uppercase + underscore en descripciones — la
nueva regla universal §3.1 los prohíbe.
