```yml
created_at: 2026-04-29 05:51:27
project: IACT-docs
work_package: 2026-04-29-05-51-27-methodology-recalibration
phase: Phase 6 — PLAN
author: NestorMonroy
status: Borrador (pending aprobacion)
version: 1.0.0
```

# Plan de Correccion

4 acciones, en orden, sin commit hasta aprobacion.

## A1 — Relocalizar I-016 (background tasks)

**Estado actual:** I-016 commiteado en
`.claude/rules/thyrox-invariants.md` (commit `9150c15`).

**Decision:** moverlo a
`.claude/skills/thyrox/references/bash-background-tasks.md`
(lazy load).

**Justificacion:** I-016 es regla de uso de tool especifico
(`Bash` con `run_in_background`), aplicable a <5% de las
sesiones. No merece carga permanente en context window.

**Pasos:**
1. Crear `references/bash-background-tasks.md` con el
   contenido actual de I-016 + ejemplos.
2. Eliminar la seccion `## I-016` de
   `thyrox-invariants.md`.
3. Agregar nota en SKILL.md indicando que la reference se
   carga on-demand cuando se usa `run_in_background`.

**Riesgo:** ninguno. La regla sigue accesible cuando aplica;
solo deja de cargar cuando no aplica.

## A2 — NO agregar I-017

**Estado actual:** propuesto pero no commiteado.

**Decision:** descartar la propuesta.

**Justificacion:** ver `analyze/deep-review-result.md`
seccion 3 — over-engineering, categoria incorrecta de
invariante (prescriptiva de proceso vs prohibitiva
estructural).

**Pasos:** ninguno (no hay nada que revertir, solo no
ejecutar la propuesta).

## A3 — Crear `mechanical-bulk-edits.md`

**Estado actual:** no existe.

**Decision:** crear `.claude/skills/thyrox/references/
mechanical-bulk-edits.md` con el micro-ciclo de 5 pasos
como guia on-demand.

**Justificacion:** la leccion de los 3 reverts (PILOT
puntual habria evitado 374->13838 warnings) si tiene valor
documental. Pero no en `.claude/rules/`.

**Contenido propuesto:**

```markdown
# Mechanical Bulk Edits — Micro-cycle

Aplicable cuando: edit afecta >10 archivos, regla
expresable como regex/AST transform, ground truth
verificable (build, tests, linter).

## Micro-cycle de 5 pasos

1. **Diagnose**: 1-2 samples del bug, regla en una linea,
   estimacion de volumen total.
2. **Pilot**: aplicar a 1 archivo aislado, medir delta
   antes/despues, verificar NO daño nuevo.
3. **Measure baseline**: contar issues totales antes de
   aplicar global.
4. **Apply + Measure**: aplicar global, comparar delta vs
   baseline.
5. **If regression > 0**: revert, refinar; else commit con
   `Refs: WP-id`.

## Anti-patron documentado

Sesion IACT-docs 2026-04-29: 3 scripts de fix aplicados
global sin PILOT. Cada uno produjo regresion (374->13838
warnings o falsos positivos). Costo: ~20 min revertir +
re-escribir cada uno.

PILOT en 1 archivo (30s) habria detectado los 3 antes de
tocar el resto del corpus.
```

**Pasos:**
1. Crear el archivo con el contenido anterior.
2. Anclar en SKILL.md o en `references/conventions.md`
   referencia "ver cuando trabajo califica".

## A4 — Documentar el sesgo en `references/`

**Decision:** crear
`.claude/skills/thyrox/references/methodology-bias-watch.md`
con el sesgo "realismo performativo metodologico"
documentado.

**Justificacion:** el sesgo no es exclusivo de mi sesion;
otros instances de Claude pueden caer en lo mismo.
Documentar el patron evita repetirlo.

**Contenido propuesto:**

```markdown
# Methodology Bias Watch

## Sesgo: realismo performativo metodologico

Cuando algo falla en una sesion, la respuesta default es
agregar una regla al sistema (invariante, check, validacion).

### Sintomas
- Convertir lecciones puntuales en invariantes globales.
- Justificar la regla con "esto no debe volver a pasar"
  sin medir frecuencia historica del bug.
- Racionalizar fallas operativas como "fallas de proceso"
  para sugerir solucion estructural.

### Diagnostico
Antes de codificar una nueva invariante en
`.claude/rules/`, responder:

1. ¿La falla es operativa (disciplina) o estructural
   (proceso)?
2. ¿Que % de sesiones futuras tocara esta regla?
3. ¿La regla es prohibitiva (correcto en `.claude/rules/`)
   o prescriptiva (mejor en `references/`)?
4. ¿Existe ya una regla equivalente?

Si la respuesta a 1 es "operativa", a 2 es "<10%", o a 3
es "prescriptiva" -> usar `references/`, no
`.claude/rules/`.

### Caso historico
Sesion IACT-docs 2026-04-29: tras saneamiento md->rst,
propuse 2 invariantes (I-016 background tasks, I-017
micro-ciclo). Deep-review revelo que ambas eran
over-engineering. Causa real: disciplina operativa, no
falta de proceso.

Ver:
- `.thyrox/context/work/2026-04-29-05-51-27-methodology-recalibration/`
- WP saneamiento: `2026-04-29-05-35-11-md-to-rst-saneamiento`
```

## Orden de ejecucion (tras aprobacion)

1. A1 (relocalizar I-016) — cambio destructivo, antes que todo.
2. A3 (crear mechanical-bulk-edits.md).
3. A4 (crear methodology-bias-watch.md).
4. Cerrar este WP con commit que referencia las 4 acciones.

A2 es no-action, no requiere step.

## Aprobacion pendiente

Este plan no se ejecuta hasta que el ejecutor lo apruebe
explicitamente. Razon: la decision de NO codificar I-017 y
de relocalizar I-016 toca el sistema de gobernanza del
proyecto y debe ser explicita.
