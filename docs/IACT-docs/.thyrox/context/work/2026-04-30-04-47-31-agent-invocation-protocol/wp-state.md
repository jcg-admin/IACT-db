```yml
project: IACT-docs
work_package: 2026-04-30-04-47-31-agent-invocation-protocol
created_at: 2026-04-30 04:47:31
current_phase: Phase 1 — DISCOVER
flow: thyrox
methodology_step: workflow-discover
author: NestorMonroy
status: Activo
```

# WP — Protocolo de invocación de agentes (auto-adaptación + paralelización)

## Origen

Durante el WP `md-references-audit` (Phase 3 ANALYZE) se intentó
invocar al agente `deep-review` para analizar 305 archivos
faltantes. La invocación fue **bloqueada por el hook
`.claude/scripts/bound-detector.py`** porque el prompt contenía
la palabra "cada" sin bound numérico explícito.

El ejecutor identificó dos problemas:

1. **El modelo no auto-adapta el prompt** al hook anti-divergencia.
   Debería detectar señales unbounded (`cada`, `todos`, `every`,
   `each`, etc.) y reformular automáticamente añadiendo bounds.

2. **El modelo no aprovecha paralelización** cuando un task se
   puede dividir en N sub-tareas independientes ejecutables en
   paralelo (1..N agentes simultáneos en un solo mensaje).

## Objetivo

Producir un **protocolo de invocación de agentes** que el modelo
sigue automáticamente. Cubre:

1. Auto-adaptación de prompts al `bound-detector.py`.
2. Decisión de cuándo paralelizar (1 agente vs N agentes).
3. Patrones de descomposición de tareas grandes.
4. Manejo de outputs paralelos (consolidación).

## Entregables esperados

1. Análisis del hook `bound-detector.py`: patrones, lógica, edge cases.
2. Catálogo de bounds válidos.
3. Heurísticas de paralelización.
4. Protocolo accionable para el modelo (pre-flight check + auto-corrección + decisión paralelización).
5. Casos de prueba: prompts mal formados con corrección automática.

## Hallazgos preliminares

### Hook bound-detector.py (167 líneas)

Lógica del hook:

1. Si `tool_name != "Agent"` → allow inmediato.
2. Detectar UNBOUNDED_SIGNALS:
   - Español: todos los, todas las, cada uno, cada archivo, cualquier, exhaustivamente, completamente, sin limite
   - Inglés: every, each, all, process all, read all, analyze all, for each, for every
3. Si NO hay unbounded → allow.
4. Si hay unbounded, buscar BOUND_SIGNALS que compensen:
   - Español: maximo, max, solo estos, unicamente, no mas de, primeros N, los N mas, hasta N, limite de N
   - Inglés: maximum, max, only these, top N, at most
5. Si bound claro presente → allow.
6. Si bound difuso ("relevantes", "importantes", "los mas") → deny con DIFFUSE_TEMPLATE.
7. Si no hay bound en absoluto → deny con OPTIONS_TEMPLATE listando 5 alternativas.

### Patrones de paralelización viables

Claude Code permite enviar N tool calls en un solo mensaje. Para
agentes paralelos, se usa la sintaxis multi-tool en el mismo
bloque function_calls. La tooling permite ejecución concurrente
si los agentes son independientes.

Ejemplos de tareas paralelizables:

- Analizar N módulos del modelo RBAC (1 agente por módulo).
- Categorizar 305 archivos en 5-10 lotes (1 agente por lote).
- Investigar 8 carpetas distintas de temp-holding en paralelo.

## Plan general

1. **Phase 2 MEASURE**: extraer estadísticas del hook (cuantas
   veces ha disparado, qué patrones más comunes).
2. **Phase 3 ANALYZE**: caracterizar la causa raíz — por qué el
   modelo no auto-adapta, qué señal le falta.
3. **Phase 4 CONSTRAINTS**: declarar política en CLAUDE.md /
   en una skill nueva (`agent-invocation-protocol`).
4. **Phase 5 STRATEGY**: protocolo formal con pre-flight check.
5. **Phase 6 PLAN**: actualizar CLAUDE.md o crear skill dedicada.
6. **Phase 8 EXECUTE**: implementar.

## Trazabilidad

- WP padre/origen: `2026-04-30-04-11-28-md-references-audit`
- Bloqueo causante: `.claude/scripts/bound-detector.py`
- Documento donde se mencionó: respuesta del modelo posterior al
  bloqueo, sección "Cómo invocar el agent correctamente la
  próxima vez".

## Próximo paso

Cuando se reanude: Phase 3 ANALYZE — protocolo formal de
auto-adaptación y casos de prueba.
