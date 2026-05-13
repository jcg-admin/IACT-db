```yml
type: Reference (lazy-load on-demand)
applies_when: Antes de codificar nueva invariante en .claude/rules/ o agregar regla coercitiva
created_at: 2026-04-29 05:51:27
status: Aprobado
version: 1.0.0
```

# Methodology Bias Watch

Cargar esta reference **antes** de proponer agregar una nueva invariante
en `.claude/rules/`, una validacion coercitiva, o un check obligatorio
post-falla.

## Sesgo: realismo performativo metodologico

Cuando algo falla en una sesion, la respuesta default es agregar una
regla al sistema (invariante, check, validacion). Esto se siente como
"aprender de la falla" pero a menudo es **atribucion sistemica de un
problema operativo**.

### Sintomas

- Convertir lecciones puntuales en invariantes globales.
- Justificar la regla con "esto no debe volver a pasar" sin medir
  frecuencia historica del bug.
- Racionalizar fallas operativas (disciplina, lectura de docs, cuidado
  en operaciones discretas) como "fallas de proceso" para sugerir
  solucion estructural.
- Proponer reglas prescriptivas (cuando hacer X) en categoria de
  invariantes prohibitivas (no hacer Y).

### Costo del sesgo

- `.claude/rules/` infla con cada sesion problematica.
- Cada invariante consume context budget permanentemente (I-009
  establece carga siempre, no lazy).
- El sistema se vuelve menos manejable, no mas.
- Las invariantes verdaderamente criticas se diluyen entre las
  hiperespecificas.

Anti-patron equivalente en software: agregar feature flag para cada
bug en vez de fixear la causa.

## Diagnostico — 4 preguntas antes de codificar

Antes de agregar una invariante en `.claude/rules/`, responder:

1. **¿La falla es operativa o estructural?**
   - Operativa: disciplina, lectura de docs, cuidado en operaciones
     discretas.
   - Estructural: regla del sistema o flujo que faltaba.

2. **¿Que % de sesiones futuras tocara esta regla?**
   - <10%: probablemente no merece carga permanente.
   - >50%: candidato a invariante.

3. **¿La regla es prohibitiva o prescriptiva?**
   - Prohibitiva ("no hacer X"): categoria correcta para
     `.claude/rules/`.
   - Prescriptiva ("cuando A, hacer B"): categoria correcta para
     `references/` lazy-load.

4. **¿Existe ya una regla equivalente?**
   - Si: reforzar la existente, no agregar duplicado.

### Decision rule

Si la respuesta a (1) es "operativa", a (2) es "<10%", o a (3) es
"prescriptiva" -> usar `references/`, no `.claude/rules/`.

Solo agregar a `.claude/rules/` si **las 4 preguntas** apuntan a
invariante.

## Anti-patron relacionado: respuesta a signals no-input

Variante operativa del mismo sesgo. Claude responde texto a
mensajes del sistema que NO son input del usuario — hooks de
validacion, notifications de tareas background, system reminders
informativos.

**Sintoma:** loop entre el modelo y el sistema. Cada respuesta
gatilla otro evento; cada evento gatilla otra respuesta.

**Caso historico (sesion IACT-docs 2026-04-29):** tras cierre
correcto de la sesion, el `Stop` hook empezo a emitir feedback
"No stderr output" (validacion pasada = todo limpio = no
accion). Claude respondio con "." o texto corto a cada uno. Cada
respuesta termino el turno -> nuevo Stop hook -> nueva respuesta.
~90 iteraciones antes de intervencion del ejecutor.

**Regla:** un mensaje del sistema sin accion requerida no debe
generar texto user-facing. Identificadores comunes:
- `Stop hook feedback: ... No stderr output` (validacion OK)
- `<task-notification status="completed">` (background OK)
- `<system-reminder>` puramente informativos
- `[Request interrupted by user]` (cancelacion limpia)

Si el mensaje no contiene pregunta, instruccion o problema a
resolver, **no responder**. El silencio es la respuesta correcta.

**Conexion con I-016:** mismo principio que background tasks —
no combinar mecanismos que no componen. Hook output + text
response = loop. Background task notification + manual poller =
loop. La leccion abstracta: identificar que signals son
**terminales** (informativos, no requieren respuesta).

## Caso historico

Sesion IACT-docs 2026-04-29: tras saneamiento md->rst exitoso (19222
issues -> 0), Claude propuso 2 invariantes para "no repetir las
fallas":

- **I-016 (background tasks):** regla de uso del Bash tool con
  `run_in_background`. Aplica a <5% de sesiones. **Categoria
  incorrecta** (operativa, no estructural). Movida a
  `references/bash-background-tasks.md`.

- **I-017 (micro-ciclo metodologico):** prescripcion de proceso para
  trabajo mecanico bulk. **Categoria incorrecta** (prescriptiva, no
  prohibitiva). Movida a `references/mechanical-bulk-edits.md`.

Deep-review adversarial revelo el sesgo. El ejecutor lo identifico
primero con la frase: *"que te fuerce a usar la metodologia, a veces
no es tan conveniente, a menos que realmente como en tu caso, la
sigas y realices bien las conversiones, que ese fue el problema
principal, al querer mover o copiar archivos de las referencias, no
lo hiciste bien"*.

Ver:
- `.thyrox/context/work/2026-04-29-05-51-27-methodology-recalibration/`
- `.thyrox/context/work/2026-04-29-05-35-11-md-to-rst-saneamiento/`

## Que SI es codificable como invariante

Reglas **prohibitivas estructurales** o **decisiones locked** del
proyecto:
- "Markdown only" (I-003) — prohibe formato.
- "Conventional Commits obligatorio" (I-005) — prohibe formato libre.
- "Un WP solo se cierra cuando el ejecutor lo ordena" (I-011) —
  prohibe cierre por inferencia.
- "Claims SPECULATIVE no avanzan gates" (I-012) — prohibe inferencia
  no respaldada.

Estas son reglas que **alteran el contrato del sistema**, no
disciplina operativa.

## Que NO es codificable como invariante

Disciplina de oficio:
- Leer el estandar ANTES de hacer un rename (no despues).
- Probar script en 1 archivo ANTES de aplicar global.
- `ps aux | grep` periodico cuando se acumulan tasks background.

Esto es disciplina, no proceso. Un humano que ya lo sabe lo hace; un
humano (o IA) que no lo sabe necesita **referencia consultable**, no
**regla coercitiva**.

## Por que vive en references/, no en .claude/rules/

Meta-decision: si la regla "no codifiques disciplina como invariante"
fuera invariante, seria recursivamente sospechosa. Vive como
reference para que se cargue **cuando se considera codificar otra
invariante**, no en cada sesion.

Decision documentada en WP
`2026-04-29-05-51-27-methodology-recalibration/plan/correction-plan.md`
(accion A4).
