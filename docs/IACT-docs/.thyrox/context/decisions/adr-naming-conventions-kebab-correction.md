```yml
type: ADR (Architecture Decision Record) — Correction
project: IACT-docs
status: Aprobado
created_at: 2026-04-29 15:30:00
decision_date: 2026-04-29
deciders: NestorMonroy
related_wp: 2026-04-29-14-56-40-std007-rename-cleanup
corrects: adr-naming-conventions-heterogeneity-accepted.md
supersedes: parcialmente al ADR original (mantiene contexto, invierte decisión)
```

# ADR — Naming Conventions Kebab Correction

## Contexto

Este ADR corrige `adr-naming-conventions-heterogeneity-accepted.md`
emitido el 2026-04-29 ~mañana (commit `c3c348e`). El ADR original
aceptó heterogeneidad de naming por categoría (5 dialectos
coexistiendo). El análisis posterior identificó que **la
heterogeneidad es daño estructural observable hoy**, no
deuda aceptable.

## Distinción importante: Corrección ≠ Revocación

Este NO es revocación arbitraria del ADR previo. Es **corrección
temprana con argumentación técnica documentada** dentro de las
primeras 24-48h, antes de que la deuda se consolide.

| Aspecto | Revocación arbitraria | Corrección temprana |
|---------|----------------------|---------------------|
| Temporalidad | Cualquier momento | Ventana <48h del original |
| Justificación | "Cambié de opinión" | Premisas invalidadas con análisis |
| Evidencia | Ninguna nueva | Análisis cuantitativo del corpus |
| Patrón | Norm churn | Proceso de revisión funcionando |

## Premisas del ADR original que se invalidaron

### Premisa 1 (invalidada): "0 incidentes de heterogeneidad"

El análisis del deep-dive original midió **incidentes de
runtime**. El observable correcto es **inconsistencia
estructural**:

```
$ ls source/normativa/gobernanza/
ADR-BACK-001-grupos-funcionales-sin-jerarquia.rst    (kebab)
ADR-GOB-008-rbac-coexistencia-acc-perm.rst           (kebab)
$ ls source/normativa/estandares/
STD_002_Nomenclatura_Proyecto.rst                    (snake+Pascal)
STD_007_Convencion_Naming.rst                        (snake+Pascal)
```

La inconsistencia es **observable hoy**, en cualquier `ls`.
No requiere monitoreo de 30-60 días.

### Premisa 2 (invalidada): "Costo masivo, beneficio especulativo"

El análisis original calculó costo de migración linealmente.
La realidad es **no lineal por refs cruzadas**:

- Hoy: 315 archivos violan el patrón + 370 refs `:doc:`/`:ref:`
  + 123 toctrees. Verificado con `find` + `grep` 2026-04-29.
- Proyección 600 archivos: ~470 violando + ~800 refs cruzadas.
- Cada archivo nuevo agrega N refs al corpus existente.

Migrar hoy: 315 renames. Migrar en 6 meses: ~470+ renames con
mucho mayor complejidad de refs. **El costo crece exponencial,
no linealmente.**

### Premisa 3 (invalidada): "Forward-only mitiga"

Forward-only **institucionaliza** dos convenciones permanentes.
Eso contradice el propósito del ADR original (resolver
heterogeneidad). No es mitigación, es perpetuación.

## Decisión nueva

**Patrón único universal:** `<prefix>-<NNN>-<descripcion-kebab>.rst`

| Tipo | Patrón | Ejemplo |
|------|--------|---------|
| Estándar numerado | `std-<NNN>-<desc>.rst` | `std-002-nomenclatura-proyecto.rst` |
| Caso de uso | `uc-<MOD>-<NN>-<desc>.rst` | `uc-auth-01-iniciar-sesion.rst` |
| Procedimiento | `proc-<MOD>-<NNN>-<desc>.rst` | `proc-dev-001-pipeline.rst` |
| Decisión arquitectónica | `adr-<MOD>-<NNN>-<desc>.rst` | `adr-back-001-grupos-funcionales.rst` |
| Plantilla | `tpl-<KEY>-<desc>.rst` | `tpl-adr-decisiones-arquitectonicas.rst` |
| Requisito funcional | `fr-<NNN>-<NN>-<desc>.rst` | `fr-010-01-listar-funciones.rst` |
| Guía sin numeración | `<desc-kebab>.rst` | `git-workflow.rst` |
| Punto de entrada | `index.rst` | (excepción Sphinx) |
| Directorio | `kebab-case` | `casos-uso/`, `arquitectura-tecnica/` |
| Directorio interno Sphinx | `_kebab-case` | `_metadata/`, `_static/` |

## Beneficios concretos

1. **Una regla universal**: minúsculas + guión medio. Sin
   excepciones por categoría.
2. **URLs Sphinx legibles** y alineadas con ecosistema (RTD,
   Django, Python, MkDocs, Hugo, Jekyll).
3. **Refs `:doc:`/`:ref:` sin fricciones**: case-sensitive
   resuelto al 100% lowercase.
4. **Cross-platform consistente**: macOS HFS+ y Windows NTFS
   case-insensitive ya no son riesgo.
5. **Affordance visual preservada**: `uc-001-...`,
   `adr-001-...`, `std-001-...` siguen siendo identificables
   por prefijo.
6. **Una sola regex de validación CI**.

## Costo asumido

- **315 archivos** renombrados via `git mv` (preserva historial).
- **18 directorios** renombrados (los `_*` Sphinx se preservan).
- **242 ocurrencias `:doc:`** + **128 ocurrencias `:ref:`**
  + **123 toctrees** + **~10 labels** actualizados.
- **Build verde 0/0/0** mantenido en cada batch.

> Cifras verificadas 2026-04-29 con `find source -type f -name '*.rst'
> ! -name 'index.rst' | awk -F/ '{print $NF}' | grep -E '[A-Z_]' | wc -l`
> y comandos análogos. Una iteración previa de este ADR citó
> 276/38/48 — eran estimaciones parciales y quedan corregidas aquí.

Operación concentrada en 1-2 sesiones, con script idempotente
+ PILOT en 1 archivo antes de bulk.

## Salvaguarda anti norm-churn

**Commitment de estabilidad: 30 días sin nuevas modificaciones
a STD_007 después de v2.0.0.**

Esta cláusula se documenta aquí explícitamente. Si en 30 días
aparece evidencia que justifique nueva modificación, debe
abrirse WP propio con deep-review previo, igual que este.

## Consecuencias

**Positivas:**
- Eliminada la inconsistencia estructural observable.
- Convención unificada para todo nuevo desarrollo.
- Costo de migración futura tendiendo a cero (regla establecida
  antes de crecimiento del corpus).

**Negativas mitigadas:**
- Refs externas (PRs históricos, marcadores en navegador) se
  rompen una vez. Documentación interna actualizada en mismo
  commit del rename.
- `git log --follow` puede degradar levemente; mitigación: rename
  PURO (sin tocar contenido) y commit consolidado.

## Referencias

- ADR original: `adr-naming-conventions-heterogeneity-accepted.md`
  (commit `c3c348e`).
- WP: `2026-04-29-14-56-40-std007-rename-cleanup`.
- STD_007: actualizado de v1.1.0 a **v2.0.0** en este WP.
- Análisis del corpus en `discover/std007-violations-inventory.md`
  del WP.
