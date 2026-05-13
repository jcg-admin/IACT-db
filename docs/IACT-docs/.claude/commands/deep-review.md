---
name: Deep Review
description: Analiza cobertura entre artefactos de fases consecutivas del WP activo, o realiza un análisis profundo de referencias externas para identificar patrones arquitectónicos
---

# /thyrox:deep-review

Invoca el agente `deep-review` para análisis de cobertura de fases o de referencias externas.

## Uso

**Modo 1 — Antes de avanzar de Phase N a Phase N+1:**
```
/thyrox:deep-review
```
Analiza si el artefacto de Phase N+1 cubre TODO el scope del artefacto de Phase N.
Reporta gaps, items faltantes, y recomienda si es seguro avanzar al gate.

**Modo 2 — Análisis de referencia externa:**
```
/thyrox:deep-review [path/to/reference]
```
Analiza documentación externa (README, specs, repos) para identificar patrones
arquitectónicos no cubiertos en [`../references/`](../references/).

## Cuándo usar

- ⏸ Antes de cada gate de fase (Phase 3→4, Phase 4→5, etc.) para verificar trazabilidad completa
- Cuando el usuario pide "deep-review de la phase anterior"
- Cuando se quiere analizar patrones en documentación externa (claude-howto, docs oficiales, repos)

## Output

El agente reporta gaps específicos con file:line exacta, y recomienda si avanzar o iterar.
NO edita ni crea archivos — es análisis puro.
