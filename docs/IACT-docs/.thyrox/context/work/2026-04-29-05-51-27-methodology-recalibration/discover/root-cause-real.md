```yml
created_at: 2026-04-29 05:51:27
project: IACT-docs
work_package: 2026-04-29-05-51-27-methodology-recalibration
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Causa Raiz Real (post deep-review)

## Hipotesis evaluadas

| Hipotesis | Veredicto | Evidencia |
|---|---|---|
| H1: Falta de adherencia metodologica | **FALSE como causa raiz** | 2 de 3 ejemplos no son fases faltantes — son fallas operativas dentro o fuera del scope de cualquier fase THYROX |
| H2: Calidad de ejecucion en file ops desde references | **TRUE — causa principal** | STD_007 violado 2x consecutivas; renames mecanicos sin re-leer el estandar |
| H3: Skip amplifico errores | TRUE pero secundaria | PILOT especifico habria evitado los 3 reverts de scripts; pero no habria salvado STD_007 ni los zombies |
| H4: Diseño de tooling (until grep sin timeout) | **TRUE e independiente** | Bug de patron de uso del Bash tool, ortogonal a fases |

## Causa raiz honesta

**H2 + H4** — ejecucion apresurada en operaciones discretas:

1. **Renames mecanicos sin checklist**
   (`Planificación...frontend-README.rst -> planificacion-...-frontend-readme.rst`):
   transformacion mecanica que preservo el sufijo `-readme`
   prohibido. STD_007 era leible y existia. La falla fue
   **no leer el estandar antes de la operacion**, no
   "saltar fase DISCOVER".

2. **Scripts globales sin PILOT en 1 archivo**:
   3 reverts (374->13838 warnings) por aplicar global antes
   de validar. Aqui si hubo falla metodologica, pero
   especifica (PILOT puntual), no sistemica (12 fases).

3. **`until grep ...; do sleep N; done` sin timeout**
   combinado con redireccion `> /tmp/buildN.txt` que
   vaciaba el task `.output`: 36 procesos zombie en 3-4h.
   Ninguna fase THYROX previene este patron. Es bug de
   uso del tool.

4. **Falta de monitoreo de infra durante el trabajo**
   (TRACK falso): zero `ps aux` en 3 horas. Una verificacion
   de `ps` por hora habria detectado la fuga. TRACK
   funciono en el artefacto (`make html`), fallo en infra.

## Sesgo detectado

**Realismo performativo metodologico**:
Cuando algo falla en una sesion, la respuesta default es
agregar una regla al sistema (invariante, check, validacion).

Sintomas:
- Convertir lecciones puntuales en invariantes globales.
- Justificar la regla con "esto no debe volver a pasar"
  sin medir frecuencia historica del bug.
- Racionalizar fallas operativas como "fallas de proceso"
  para sugerir solucion estructural.

Costo:
- `.claude/rules/` infla con cada sesion problematica.
- Cada invariante consume context budget permanentemente
  (I-009 establece carga siempre, no lazy).
- El sistema se vuelve menos manejable, no mas.

Anti-patron equivalente en software: agregar feature flag
para cada bug en vez de fixear la causa.

## Que NO es codificable en una invariante

Disciplina operativa:
- Leer el estandar ANTES de hacer el rename (no despues).
- Probar script en 1 archivo ANTES de aplicar global.
- `ps aux | grep` periodico cuando se acumulan tasks
  background.

Esto es **disciplina de oficio**, no proceso. Un humano que
ya lo sabe lo hace; un humano que no lo sabe necesita
documento de referencia, no regla coercitiva.

## Lo que SI es codificable

Reglas **prohibitivas estructurales** o **decisiones
locked**:
- "Markdown only" (I-003) — prohibe formato.
- "Conventional Commits obligatorio" (I-005) — prohibe
  formato libre.
- "Un WP solo se cierra cuando el ejecutor lo ordena"
  (I-011) — prohibe cierre por inferencia.

Reglas que tratan disciplina operativa (I-016 background
tasks, I-017 micro-ciclo) son **categoria incorrecta** para
`.claude/rules/`.

## Implicaciones para este proyecto

1. **NO agregar I-017** — la propuesta era over-engineering.

2. **Relocalizar I-016** — moverlo de
   `.claude/rules/thyrox-invariants.md` a
   `.claude/skills/thyrox/references/bash-background-tasks.md`
   (lazy load on-demand).

3. **Crear `mechanical-bulk-edits.md`** como reference
   on-demand con el micro-ciclo de 5 pasos, NO como
   invariante.

4. **Auditar `.claude/rules/` periodicamente** para
   detectar invariantes que son disciplina operativa
   disfrazada de regla estructural.

5. **Documentar el sesgo "realismo performativo
   metodologico"** como meta-leccion (este propio WP).
