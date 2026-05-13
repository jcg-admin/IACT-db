```yml
created_at: 2026-04-29 09:17:01
project: IACT-docs
work_package: 2026-04-29-09-17-01-std007-naming-recalibration
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inventario actual del corpus por patron de naming

381 archivos `.rst` en `source/`. Distribucion por convencion:

## Tabla de inventario

| Patron actual | Conteo | % | Cumple STD_007 actual |
|---------------|--------|---|---|
| snake+PascalCase (`UC/BR/CNST/STD/TPL/META/FND/SBVR/MTM/TXM/GOB/BReq/RNF`) | 217 | 56.9% | §4.1 |
| kebab puro (`ADR/PROCED/PROC + descriptivos`) | 34 | 8.9% | §4.2 |
| `FR-NNN.NN_snake` (mixed) | 45 | 11.8% | §4.3 |
| Guias kebab puras (general docs) | 46 | 12.1% | §4.4 |
| `index.rst` | 47 | 12.3% | §4.5 |
| Otros (uncategorized) | 0 | 0% | — |

## Implicancia para la propuesta del ejecutor

Adoptar **snake+PascalCase universal** afectaria:

| Categoria | Conteo | Necesita rename |
|-----------|--------|-----------------|
| §4.1 (snake+Pascal) | 217 | NO — ya cumple el patron propuesto |
| §4.2 (kebab) | 34 | **SI** |
| §4.3 (mixed FR) | 45 | **SI** (mixed -> snake+Pascal) |
| §4.4 (guias kebab) | 46 | **SI** |
| `index.rst` | 47 | NO (excepcion) |
| **Total a renombrar** | **125** | **32.8% del corpus** |

## Costo estimado

- 125 archivos renombrados.
- Toctree en ~47 `index.rst` necesita actualizarse.
- ~217 ocurrencias de `:doc:` y ~126 de `:ref:` a auditar y
  posiblemente actualizar (los que apunten a archivos
  renombrados).
- Tests: `make clean && make html` debe seguir verde
  (politica 0/0).
- Riesgo: cada rename es 1 commit potencial; con tests por
  batch, ~10-15 batches.

## Inventario STD_007 contradicciones detectadas

### Contradiccion 1 — §3.3 "Mezcla de Separadores" vs §4.2

§3.3 dice:

> NO mezclar `-` y `_` en el mismo nombre **a menos que** la
> mezcla siga la estructura: `<PREFIX-CON-HYPHEN>_<descripcion-con-cualquiera>`.
>
> Permitido (estructural):
> - `ADR-BACK-001-grupos-funcionales-sin-jerarquia.rst` (kebab puro)

Esto crea ambiguedad:
- §3.3 cita `ADR-BACK-001-grupos-funcionales-sin-jerarquia.rst`
  como ejemplo de "kebab puro" que es un permiso GENERAL.
- §4.2 establece el mismo archivo como ejemplo de un patron
  ESPECIFICO `<PREFIX>-<MOD>-<NNN>-<desc-kebab>.rst`.

Resultado: un autor leyendo §3.3 puede interpretar que kebab
puro esta permitido en general; un autor leyendo §4.2 entiende
que solo aplica a 4 prefijos (ADR, PROCED, PROC, RNF).

### Contradiccion 2 — §4.2 vs §4.3

§4.2 prescribe kebab puro en la descripcion:
`PROC-DEV-001-pipeline-trabajo-iact.rst`.

§4.3 (FR) prescribe mixed: `FR-010.01_Listar_funciones_disponibles.rst`
(prefijo kebab `FR-NNN.NN`, descripcion snake_case con
PascalCase).

No es contradiccion logica, pero **dos sub-tipos de
"artefactos con prefijo+numeracion" tienen reglas distintas**
sin justificacion clara.

### Contradiccion 3 — Verificacion empirica del corpus

Inventario muestra que 34 archivos siguen kebab (§4.2) y 45
siguen FR-snake (§4.3). Es decir: **AMBAS reglas se aplican y
cumplen en el corpus actual**. La unificacion propuesta
romperia 79 archivos que actualmente cumplen.
