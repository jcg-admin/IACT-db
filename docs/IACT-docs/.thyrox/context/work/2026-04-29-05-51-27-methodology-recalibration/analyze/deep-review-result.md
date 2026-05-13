```yml
created_at: 2026-04-29 05:51:27
project: IACT-docs
work_package: 2026-04-29-05-51-27-methodology-recalibration
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Deep-Review Result — Recalibracion Adversarial

Output verbatim del agente `deep-dive` invocado por Claude
contra su propia recalibracion metodologica del 2026-04-29.

## Input enviado al agente

Resumen:
- Contexto factual de la sesion saneamiento md->rst
  (19222 -> 0 issues en 11 commits).
- Costos concretos del skip de fases (3 reverts, cascade
  batch 9, STD_007 violado 2x, 36 zombies).
- Mi recalibracion propuesta (micro-ciclo de 5 pasos como
  I-017 en `thyrox-invariants.md`).
- Critica del ejecutor: "que te fuerce a usar la metodologia,
  a veces no es tan conveniente, a menos que realmente como
  en tu caso, la siguas y realices bien las conversiones,
  que ese fue el problema principal, al querer mover o
  copiar archivos de las referencias, no lo hiciste bien".

## Veredicto del agente (verbatim)

### 1. ¿TRACK fue lo que "hicimos bien"?

**Veredicto: FALSE (parcialmente).**

TRACK del **artefacto target** (`source/` via `make html`)
si funciono — el feedback loop de 30s detecto las 3
regresiones (374->13838 warnings) y permitio revertir. Eso
es real.

Pero TRACK como capa metodologica abarca **side effects del
proceso**, no solo el output del build. Los 36 procesos
zombie acumulados 3-4h son evidencia directa de TRACK
ciego: `run_in_background` + `until grep ...; do sleep N;
done` con stdout redirigido a `/tmp/buildN.txt` mientras el
`.output` del background quedaba vacio significa que
durante horas no verificaste el estado del sistema en el
que estabas operando. `ps aux | grep make` una vez por hora
habria detectado la fuga.

Reformulacion honesta: TRACK funciono en el **eje del
artefacto** (warnings count), fallo en el **eje de
infraestructura** (procesos, fs, recursos). Decir "TRACK lo
hicimos bien" es seleccion de metrica conveniente.

### 2. ¿El problema fue saltar fases?

**Veredicto: FALSE en su forma fuerte; UNCERTAIN en su forma
debil.**

Revision por caso:

- **STD_007 violado 2 veces:** no es falta de DISCOVER —
  el estandar existia y era leible. Es falta de **lectura
  del estandar antes de la operacion especifica**. Eso no
  es "fase faltante", es checklist de file op. Una fase
  DISCOVER previa de 30 min no garantiza que al renombrar
  archivo N+50 horas despues recuerdes la regla de sufijos.
  El ejecutor tiene razon aqui.

- **3 reverts de scripts:** PILOT (probar en 1 archivo)
  habria detectado los 374->13838. Esto si es falla
  metodologica genuina — pero es PILOT puntual, no las 12
  fases. Confunde "saltar PILOT especifico" con "saltar
  metodologia completa".

- **Cascade batch 9:** NO es falla de PLAN. Fix-then-rebuild
  en codebases con issues enmascarados es comportamiento
  esperado del problema, no del proceso. Ningun PLAN
  ex-ante puede enumerar issues que solo aparecen despues
  de fixear los que los enmascaran. Atribuirlo a falta de
  PLAN es racionalizacion post-hoc.

El ejecutor tiene razon parcial: 2/3 ejemplos son ejecucion,
no metodologia. Tu tesis "saltar fases causo X" no resiste
el detalle.

### 3. ¿I-017 es la respuesta correcta?

**Veredicto: FALSE — es over-engineering.**

Argumentos contra que tu mismo enumeras son validos y
subestimados:

- I-009 establece que `.claude/rules/` carga **siempre, no
  lazy**. Cada invariante consume context budget
  permanentemente, en cada sesion, para todo trabajo. Un
  micro-ciclo aplicable a "trabajo mecanico repetitivo" no
  merece ese costo. La regla I-009 misma advierte: "usarlos
  SOLO para reglas criticas globales".
- Las invariantes existentes (I-001..I-014) son
  **prohibitivas** o **estructurales** (no crear plan sin
  DISCOVER, markdown only, timestamp real). I-017 seria
  **prescriptiva de proceso** para un subdominio (trabajo
  mecanico). Categoria incorrecta.
- El problema que pretende resolver (PILOT antes de aplicar
  global) es resoluble por un skill o reference cargado
  on-demand cuando el contexto lo amerite, no por carga
  permanente.
- Convertir lecciones puntuales en invariantes globales es
  un anti-patron conocido: invariant bloat. Cada sesion
  paga el costo, pocas sesiones obtienen el beneficio.

**Alternativa correcta:** una reference
`.claude/skills/thyrox/references/mechanical-bulk-edits.md`
cargada cuando el trabajo califica (>N archivos, edits
scriptables). O simplemente un check en el SKILL existente:
"¿pilot en 1 archivo?". No invariante.

### 4. ¿Cual fue la causa raiz real?

**Veredicto sobre las hipotesis:**

- **H1 (falta de adherencia metodologica) — FALSE como
  causa raiz.** Es la narrativa mas comoda porque sugiere
  solucion estructural ("agregue invariante"). No resiste
  el analisis caso por caso (punto 2).

- **H2 (calidad de ejecucion en file ops) — TRUE como
  causa principal.** STD_007 violado 2 veces es exactamente
  esto. El ejecutor lo detecto tu no — eso es disciplina
  operativa, no fase faltante.

- **H3 (mezcla — skip amplifico errores) — TRUE pero
  secundaria.** PILOT habria reducido los reverts de
  scripts. Pero no habria salvado STD_007 ni los zombies.

- **H4 (diseño de tooling: `until grep` sin timeout) — TRUE
  e independiente.** Bug de patron de uso del tool,
  ortogonal a metodologia. Ninguna fase THYROX previene
  esto; ninguna lo causa.

**Causa raiz honesta:** combinacion H2 + H4. Ejecucion
apresurada en operaciones discretas (renames, scripts
globales sin pilot, monitoreo de procesos). El ejecutor
identifico esto correctamente. Tu tesis original (H1) es
atribucion sistemica de un problema operativo — sesgo de
"si falle, fallo el proceso" cuando la verdad es "falle en
pasos concretos que el proceso no cubre granularmente".

### 5. ¿I-016 (background tasks) responde correctamente?

**Veredicto: UNCERTAIN, leaning FALSE.**

No tengo el texto de I-016 a la vista en este contexto, asi
que el analisis es estructural:

- Si I-016 prescribe "siempre usar timeout en background
  bash + verificar `ps` periodicamente" -> es una regla
  operativa correcta pero **no merece ser invariante
  global**. Aplica solo cuando se usa `run_in_background`,
  que es un subset pequeño del trabajo. Misma critica que
  I-017: carga permanente para problema puntual.
- Si I-016 prohibe el patron `until grep ...; do sleep N;
  done` con redireccion dual -> es prohibitiva (categoria
  correcta de invariante) pero hipersespecifica. ¿Que % de
  sesiones usa este patron? Probablemente <5%.
- El zombie problem es un **bug de uso de tool** en una
  sesion. Convertirlo en invariante para todas las sesiones
  futuras es sobreajuste a una experiencia singular. La
  respuesta proporcionada seria: documentar el patron en
  una reference de Bash tool usage, no en `.claude/rules/`.

**Evidencia que faltaria para confirmar:** texto exacto de
I-016 + frecuencia historica del patron problematico en
este repo. Sin eso, alta probabilidad de over-engineering
por reaccion.

## Conclusion del agente

**No agregar I-017. Y considerar revertir/relocalizar I-016.**

Razones:

1. La causa raiz de la sesion md->rst fue **ejecucion
   operativa** (H2 + H4), no falta de metodologia (H1).
   Codificar I-017 trata el sintoma equivocado.

2. `.claude/rules/` carga siempre (I-009). El costo de
   context window de una invariante es perpetuo; el
   beneficio de I-017 aplica solo a trabajo mecanico bulk,
   que es una fraccion del trabajo total.

3. El ejecutor te dio la pista correcta: el problema fue
   **mover/copiar archivos desde references sin cuidado**,
   no falta de fases. Tu propuesta no responde a esa
   critica — la elude convirtiendola en oportunidad de
   proceso.

4. Patron estructural detectado: **realismo performativo
   metodologico** — cuando algo falla, agregar regla. Esto
   infla el sistema sin atacar la disciplina operativa, que
   no es codificable en un invariante.

**Accion recomendada:** documentar la leccion como reference
on-demand (`mechanical-bulk-edits.md` y
`bash-background-tasks.md` en
`.claude/skills/thyrox/references/`), no como invariante.
Mantener `.claude/rules/` para reglas verdaderamente
globales y prohibitivas. Aceptar que algunas lecciones son
operativas y no se solucionan con mas estructura — se
solucionan con leer el estandar antes de renombrar el
archivo.
