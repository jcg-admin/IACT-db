```yml
created_at: 2026-04-20 13:52:30
project: THYROX
author: NestorMonroy
status: Borrador
```

# Calibration Framework — Mapeo Eval-type × Stage THYROX

## Tipos de evaluación

| Código | Tipo | Descripción |
|--------|------|-------------|
| G-1 | Peer review | Revisión por Claude en la misma sesión — sin ejecución de herramienta |
| G-2 | Tool-executed | Verificación mediante tool_use (Bash, Read, Grep) con output citado |
| G-3 | Human gate | Aprobación explícita del ejecutor humano requerida |
| G-4 | Automated | Script o hook ejecutado automáticamente |

## Mapeo Stage × Eval-type

| Stage | Tipo apropiado | Criterio mínimo | Método de verificación |
|-------|---------------|-----------------|------------------------|
| Stage 1 DISCOVER | G-1 + G-3 | ≥3 observaciones directas | Mapa epistémico en síntesis |
| Stage 2 BASELINE | G-2 + G-3 | baseline medible con herramienta | Bash output citado |
| Stage 3 DIAGNOSE | G-2 + G-3 | causa raíz con evidencia observable | Grep/Read output citado |
| Stage 4 CONSTRAINTS | G-1 + G-3 | restricciones verificadas | Revisión de fuentes |
| Stage 5 STRATEGY | G-1 + G-3 | decisión con alternativas evaluadas | Tabla de decisión |
| Stage 6 SCOPE | G-3 | scope aprobado por ejecutor | Aprobación explícita |
| Stage 7 DESIGN/SPECIFY | G-2 + G-3 | spec verificable con criterios | Given/When/Then |
| Stage 8 PLAN EXECUTION | G-4 + G-3 | task-plan con DAG coherente | validate-session-close.sh |
| Stage 9 PILOT/VALIDATE | G-2 + G-3 | PoC ejecutado y resultado citado | Bash output |
| Stage 10 IMPLEMENT | G-2 + G-4 | tests pasan, commits convencionales | CI + git log |
| Stage 11 TRACK/EVALUATE | G-2 + G-3 | métricas vs baseline medidas | Bash output |
| Stage 12 STANDARDIZE | G-3 | patrones aprobados para propagación | Aprobación explícita |

## Regla de confianza mínima

Cuando un gate tiene `confidence_threshold < 0.80` → el Eval-type debe ser G-2 o G-3, NO solo G-1.

La confianza se declara en la sección "Evidencia de respaldo" de cada artefacto de stage
(ver templates en `workflow-diagnose/assets/`, `workflow-strategy/assets/`, `workflow-decompose/assets/`).

| Confianza | Umbral | Eval-type mínimo |
|-----------|--------|-----------------|
| alta | ≥ 0.90 | G-1 suficiente para claims secundarios |
| media | 0.70–0.89 | G-2 requerido (tool_use ejecutado y citado) |
| baja | < 0.70 | G-2 + G-3 — el claim debe re-verificarse o descartarse |

## Cómo ejecutar G-2 (tool-executed)

Para que un claim sea PROVEN bajo G-2, el output debe citarse textualmente en el artefacto:

```markdown
**Evidencia G-2 (Bash):**
> $ grep -r "pattern" .claude/
> archivo.md:42: texto encontrado
```

Las siguientes herramientas cuentan como G-2:
- `Bash` — ejecución de comando shell con output reproducible
- `Read` — lectura de archivo con número de línea citado
- `Grep` — búsqueda con resultado citado (archivo + línea)
- `Glob` — listado de archivos con conteo verificado

Un claim que dice "el archivo contiene X" sin citar el output de Read o Grep es G-1 (peer review), no G-2.

## Nota sobre validate-session-close.sh

Actualmente opera como G-4 (automated) pero tiene efectividad ~30% como Stop hook.
Convertir a PreToolUse elevaría efectividad a 100%. Ver T-091 (deuda técnica).

Implicación: Stage 8 PLAN EXECUTION tiene G-4 como tipo apropiado, pero el G-4 real
es menos confiable que la documentación sugiere. Compensación actual: G-3 obligatorio
(el ejecutor humano valida el task-plan antes de avanzar).

## Relación con evidence-classification.md

Este framework define CUÁNDO verificar. El vocabulario de qué tipos de claim existen
vive en `.claude/references/evidence-classification.md` (PROVEN/INFERRED/SPECULATIVE).

La columna "Tipo" en la tabla "Evidencia de respaldo" de cada artefacto usa la terminología
de `evidence-classification.md`. El Eval-type de este framework determina si el claim
alcanza el umbral para avanzar el gate.
