```yml
created_at: 2026-04-30 04:47:31
project: IACT-docs
work_package: 2026-04-30-04-47-31-agent-invocation-protocol
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis del protocolo de invocación de agentes

> Caracterización del problema, hallazgos del hook anti-divergencia,
> y diseño del protocolo que el modelo debe aplicar
> automáticamente (sin intervención humana) para invocar agentes.

## 1. Problema observado

Durante el WP md-references-audit, el modelo intentó invocar
`deep-review` con un prompt que contenía:

- "Para **cada categoría**, determinar..."
- "Para **cada** uno de los 305 paths..."

El hook `bound-detector.py` bloqueó la invocación con el mensaje
OPTIONS_TEMPLATE listando 5 formas de añadir un bound.

El modelo entonces decidió ejecutar el deep-review manualmente
(con Bash + Read + Write) en lugar de:

(a) Reformular el prompt con bound y reintentar la invocación.
(b) Descomponer la tarea en N agentes paralelos con bounds
    individuales.

Ambos comportamientos (a) y (b) son superiores al ejecutar
manualmente — los agentes son herramientas diseñadas para
descargar context-window y procesamiento en paralelo.

## 2. Causa raíz identificada

**Inferencias sobre por qué el modelo NO auto-adapta:**

1. **Falta de instrucción explícita en CLAUDE.md** sobre el
   bound-detector y su comportamiento. El modelo descubre el
   hook al ser bloqueado, no antes.
2. **No hay heurística pre-flight** documentada para revisar
   patrones unbounded en el prompt antes de enviarlo.
3. **No hay política de fallback** documentada: cuando un
   agente es bloqueado, debe reintentarse adaptado (no
   ejecutar manualmente).
4. **Paralelización no está incentivada** explícitamente —
   el modelo tiende a un agente por defecto.

## 3. Catálogo de bounds válidos

El hook acepta como BOUND_SIGNALS los siguientes patrones:

### Español

- `máximo N` / `maximo N` / `máx N`
- `solo estos: [...]` / `solo [...]`
- `solamente`, `únicamente`
- `no más de N` / `no mas de N`
- `primeros N`
- `los N más [criterio]` (donde criterio es concreto)
- `hasta N`
- `límite de N` / `limite de N`

### Inglés

- `maximum`, `max`, `at most`
- `only these`
- `no more than N`
- `first N`
- `top N`

### NO aceptados (bound difuso)

- `relevantes`, `importantes`, `necesarios`, `apropiados`,
  `significativos`, `representativos`
- `los más [adjetivo abstracto]`
- `los principales`

## 4. Heurísticas de paralelización

### Cuándo enviar 1 agente

- La tarea tiene un único hilo de razonamiento.
- El input total cabe en context window del agente.
- Los outputs no son independientes entre sí.

### Cuándo enviar N agentes en paralelo

- La tarea se descompone en sub-tareas independientes.
- Cada sub-tarea tiene scope acotado naturalmente (un módulo,
  un dominio, un lote de archivos).
- Los outputs se consolidan al final por el orquestador.

### Patrón de sintaxis para N agentes simultáneos

En un solo mensaje del modelo, incluir múltiples invocaciones
del Agent tool dentro del mismo bloque de tool_use. Cada
invocación con `description`, `subagent_type` y `prompt` propios.
La plataforma ejecuta concurrentemente y devuelve resultados
juntos.

Pseudocódigo de la decisión:

```
si tarea es naturalmente partible en K subtareas independientes:
    si K <= 5: enviar K agentes en paralelo en un solo mensaje
    si 5 < K <= 20: descomponer en lotes, enviar 5 a la vez
    si K > 20: revisar si la descomposición es realmente útil
si tarea es atómica:
    enviar 1 agente
```

## 5. Protocolo automático del modelo (pre-flight check)

Antes de invocar Agent, el modelo debe:

### Paso 1 — Escaneo de unbounded signals

Buscar en el prompt los patrones `\bcada\b`, `\btodos los\b`,
`\bevery\b`, `\beach\b`, etc.

Si detectado, ir a Paso 2. Si no, ir a Paso 3.

### Paso 2 — Auto-corrección del prompt

Reformular añadiendo bound según el caso:

| Patrón detectado | Auto-corrección sugerida |
|------------------|---------------------------|
| "para cada X" | "para máximo N X (priorizados por [criterio])" |
| "todos los Y" | "los primeros N Y / solo: [Y1, Y2, ...]" |
| "cada archivo" | "máximo N archivos / archivos cuya métrica > X" |
| "exhaustivamente" | "máximo K iteraciones / hasta convergir en N puntos" |
| "analizar todo" | "analizar máximo N elementos top-priority" |

El bound numérico debe ser **realista** para el alcance del agente
(típicamente 5-50 según tipo de tarea).

### Paso 3 — Evaluación de paralelización

Preguntarse: ¿la tarea se puede dividir en K sub-tareas
independientes con bound natural?

Si sí y K es manejable (≤ 5-10), descomponer y enviar K agentes
en paralelo.

Si no, enviar 1 agente con el prompt corregido.

### Paso 4 — Invocar

Construir invocaciones con `description`, `subagent_type`,
`prompt` (con bound), y opcional `isolation`/`model`.

### Paso 5 — Consolidar

Recibir resultados de los agentes y consolidar manualmente o
con un agente orquestador (`task-synthesizer`).

## 6. Casos de prueba (input → output esperado)

### Caso 1: prompt original vs corregido

Input: "Analizar cada archivo del WP y determinar fixes."

Output esperado del modelo:
- Detecta "cada archivo" → unbounded.
- Pregunta: ¿cuántos archivos hay? Si 30, bound natural = 30.
- Reformula: "Analizar los 30 archivos del WP listados en
  /tmp/wp-files.txt y determinar fixes (máximo 30)."

### Caso 2: tarea naturalmente paralelizable

Input: "Auditar los 8 módulos RBAC para SRP."

Output esperado:
- Detecta partición natural: 8 módulos = 8 sub-tareas.
- Decide: 8 ≤ 10 → paralelizar.
- Envía 8 agentes en un solo mensaje, cada uno con scope
  "auditar SOLO MOD_X para SRP, máximo 10 funciones".
- Consolida los 8 outputs en un reporte unificado.

### Caso 3: bound difuso

Input: "Analizar las funciones más relevantes."

Output esperado:
- Detecta "más relevantes" → bound difuso.
- Pregunta clarificación al ejecutor o auto-define criterio:
  "las 5 funciones con mayor # de referencias cruzadas".
- Reformula y envía.

## 7. Implementación propuesta

Tres opciones para internalizar el protocolo en el modelo:

### A. Skill dedicada `agent-invocation-protocol`

Crear `.claude/skills/agent-invocation-protocol/SKILL.md` que
documente este protocolo. El modelo lo carga lazy cuando va a
invocar un agente.

**Pros:** modular, alineado con arquitectura THYROX.
**Contras:** lazy-load implica que el modelo puede saltarlo si
no detecta el trigger.

### B. Sección en CLAUDE.md

Agregar al `.claude/CLAUDE.md` una sección "Agent invocation
protocol" que se carga siempre.

**Pros:** garantía de carga, prioridad alta.
**Contras:** infla CLAUDE.md.

### C. Regla en `.claude/rules/`

Crear `.claude/rules/agent-invocation.md`. Las reglas se cargan
siempre al inicio.

**Pros:** carga siempre, junto a otras invariantes.
**Contras:** mismo de B.

**Recomendación:** opción C — regla siempre cargada, alineada con
otras invariantes del proyecto (`thyrox-invariants.md`,
`commit-conventions.md`).

## 8. Riesgos identificados

| Riesgo | Mitigación |
|--------|------------|
| Modelo aplica bounds artificiales que pierden información | Documentar criterios de bound realistas por tipo de tarea |
| Sobre-paralelización (lanzar 20 agentes innecesariamente) | Heurística "K ≤ 5-10" como guía |
| Output de agentes paralelos inconsistente | Especificar formato de salida común en cada prompt |
| Costo de consolidación post-paralelo | Usar `task-synthesizer` cuando K ≥ 4 |
| Model bypass del protocolo (ejecutar manualmente) | Rule explícita: "preferir Agent paralelizado sobre Bash+Read manuales para tareas analíticas" |

## 9. Métricas de éxito del WP

- Regla `.claude/rules/agent-invocation.md` documentada.
- 0 invocaciones bloqueadas por bound-detector tras la
  implementación (en sesiones de prueba).
- Paralelización aplicada en al menos 1 caso real (e.g. el
  fix de proc-gob-001 con 4 agentes paralelos).
- Documentación de aprendizaje registrada en
  `analyze/post-implementation-learnings.md`.

## 10. Decisiones para el ejecutor

1. ¿Aprueba protocolo formalizado? (vs dejarlo a improvisación
   del modelo).
2. ¿Opción A (skill) / B (CLAUDE.md) / C (rules)?
3. ¿Bound default por tipo de tarea (catálogo de "5 archivos
   por agente review", "10 secciones por análisis", etc.)?
4. ¿Implementar pre-flight check como hook adicional o solo
   como guideline?
5. ¿Documentar también qué NO paralelizar (e.g. tareas
   secuenciales por naturaleza)?
