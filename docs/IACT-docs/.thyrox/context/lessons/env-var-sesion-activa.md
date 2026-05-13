---
id: L-003
titulo: Cambios en settings.json env vars no propagan a subagentes de sesión activa
categoria: Configuración
origen_wp: 2026-04-14-09-13-51-context-migration
origen_fase: FASE 35
fecha: 2026-04-14
---

## Contexto

El agente `deep-review hook-authoring.md` falló dos veces con stream idle
timeout. Tras el primer fallo, se aumentó `CLAUDE_STREAM_IDLE_TIMEOUT_MS`
de `120000` a `420000` en `settings.json` y se commiteó. Se relanzó el agente.

## Qué Pasó

El segundo agente falló igualmente (~303s) a pesar del cambio en `settings.json`.
La variable actualizada no tuvo efecto en la sesión activa.

## Causa Raíz

`CLAUDE_STREAM_IDLE_TIMEOUT_MS` definida en `settings.json → env` es leída
por el proceso de Claude Code **al arrancar la sesión**. Los subagentes
lanzados en una sesión activa heredan los valores del proceso padre —
el valor que tenía cuando la sesión arrancó, no el valor actual del archivo.

```
Sesión inicia → lee settings.json (TIMEOUT=120000) → proceso env=[TIMEOUT=120000]
                                                              │
Cambio en settings.json (TIMEOUT=420000)                      │ ← no propaga
                                                              │
Subagente lanzado → hereda env del padre → TIMEOUT=120000 ✗
```

El cambio en `settings.json` solo aplica a **sesiones nuevas**, no a
subagentes de la sesión activa.

## Solución Aplicada

Ninguna para la sesión activa — el cambio aplica a la próxima sesión.
El problema de `hook-authoring.md` se resolvió por otro camino (revisar
en contexto principal en lugar de subagente).

## Clave del Aprendizaje

**Los cambios a `env` en `settings.json` son para la próxima sesión, no para
la sesión actual.** Para cambiar un timeout en sesión activa, hay que pasar
la variable explícitamente en el comando del subagente o aceptar el límite
actual.

## Aplicación Futura

Si se necesita un timeout mayor en un subagente de la sesión activa:

```bash
# Workaround: pasar la variable directamente en el comando
CLAUDE_STREAM_IDLE_TIMEOUT_MS=420000 claude -p "tarea..."
```

O bien: estructurar la tarea del subagente para que sea más pequeña
(scope acotado), en lugar de depender de un timeout mayor.

Regla operacional: si un subagente falla por timeout, el fix de settings.json
aplica a la **próxima sesión**. El fix inmediato es reducir el scope de la tarea.

## Referencias

- WP: `.thyrox/context/work/2026-04-14-09-13-51-context-migration/`
- Análisis Ishikawa: sesión FASE 35
- Relacionado: L-004 (instrucciones sin bound como causa del timeout)
- Commit: `fix(settings): aumentar CLAUDE_STREAM_IDLE_TIMEOUT_MS 120s→420s`
