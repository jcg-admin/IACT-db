---
name: workflow-diagnose
description: "Use when doing deep analysis of a problem after initial discovery. Phase 3 ANALYZE — análisis sistemático de causa raíz por dominio. Crea sub-análisis en cajón analyze/ del WP."
allowed-tools: Read Glob Grep Bash
disable-model-invocation: true
effort: high
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "bash .claude/scripts/set-session-phase.sh 'Phase 3'"
updated_at: 2026-04-20 13:51:04
---

# /workflow-analyze — Stage 3: DIAGNOSE

Inicia o retoma Stage 3 DIAGNOSE del work package activo.

---

## Contexto de sesión

1. Identificar WP activo: `ls -t .thyrox/context/work/ | head -1`
2. Leer síntesis DISCOVER: `cat .thyrox/context/work/[WP]/discover/*-analysis.md`
3. Leer `context/now.md` — verificar `phase`
4. Verificar si ya existe contenido en `work/.../analyze/`:
   - Si existe con análisis completos → Phase 3 ya avanzó. Revisar pendientes.
5. Revisar MEASURE si se ejecutó: `ls work/.../measure/ 2>/dev/null`

---

## Fase a ejecutar: Phase 3 ANALYZE

Analizar en profundidad antes de definir estrategia previene soluciones a problemas equivocados.

**Enfoque:** Análisis sistemático por dominio. Cada dominio = subdirectorio dentro de `analyze/`.

### Patrones de análisis

1. **Root Cause Analysis (RCA)** — para problemas con causas conocidas
   - 5 Whys: preguntar "¿por qué?" 5 veces hasta llegar a la causa raíz
   - Fishbone/Ishikawa: categorizar causas (People, Process, Technology, Environment)

2. **Domain decomposition** — para problemas complejos con múltiples dimensiones
   - Dividir el espacio del problema en dominios independientes
   - Analizar cada dominio por separado con sub-documentos
   - Integrar hallazgos en síntesis cross-domain

3. **Architectural analysis** — para decisiones técnicas complejas
   - Patrones actuales vs patrones propuestos
   - Trade-offs: simplicidad vs extensibilidad, consistencia vs flexibilidad
   - Impacto en sistemas existentes

4. **Landscape analysis** — para entender el ecosistema
   - Inventario de opciones existentes
   - Comparación de alternativas con criterios explícitos
   - Identificación de brechas

### Estructura de artefactos

```
work/.../analyze/
├── {dominio1}/
│   ├── {nombre-descriptivo}.md     ← sub-análisis libre
│   └── {otro-subtema}.md
├── {dominio2}/
│   └── {nombre-descriptivo}.md
└── {dominio3}/
    └── {nombre-descriptivo}.md
```

Naming libre para documentos en cajón — no requieren prefijo `{nombre-wp}`.
Ejemplo: `analyze/architecture-patterns/multi-flow-detection.md`

### Ejecución

1. Identificar dominios relevantes basado en síntesis DISCOVER
2. Para cada dominio: crear subdirectorio + documento(s) de análisis
3. Cada documento usa el bloque de metadata estándar:

```yml
created_at: YYYY-MM-DD HH:MM:SS
project: [Nombre del proyecto]
work_package: YYYY-MM-DD-HH-MM-SS-nombre
phase: Phase 3 — ANALYZE
author: [Nombre]
status: Borrador
```

4. Crear síntesis cross-domain: `analyze/{nombre-wp}-analyze-synthesis.md`
5. Actualizar `{nombre-wp}-risk-register.md` con riesgos descubiertos

---

## Si el WP es un sistema agentic: verificar antes de avanzar Stage 3→4

Si el WP construye o diseña un sistema donde un agente toma decisiones autónomas, completar este checklist adicional antes del gate 3→4:

- [ ] **AP-01/02 — Callbacks sin side-effects**: ¿se analizó si los callbacks del sistema modifican estado externo de forma no controlada?
- [ ] **AP-03..06 — Type contracts en herramientas**: ¿los inputs y outputs de las herramientas del agente tienen contratos de tipo definidos?
- [ ] **AP-09..12 — Error handling**: ¿el análisis identificó si el sistema silencia excepciones en lugar de propagarlas correctamente?
- [ ] **AP-13..15 — Observabilidad**: ¿están definidas métricas de drift, latency y quality para evaluar el comportamiento del agente?

Si algún ítem está sin resolver, documentarlo como CR con status `SPECULATIVE` y marcarlo como bloqueante antes de avanzar.

Ver referencia: `workflow-strategy/references/agentic-system-design.md`

---

## Validaciones pre-gate

Antes de presentar el gate 3→4:
- Todos los dominios relevantes tienen análisis documentado
- Causas raíz identificadas (no solo síntomas)
- Riesgos nuevos registrados en risk-register
- Síntesis cross-domain creada

## Gate humano

⏸ STOP — Presentar hallazgos clave del análisis: causas raíz, dominios analizados, riesgos identificados.
Esperar confirmación explícita. NO continuar sin respuesta.
Al aprobar: actualizar `context/now.md::phase` a `Phase 4`.

---

## Exit criteria

Phase 3 completa cuando:
- `work/.../analyze/` tiene contenido por dominio
- Síntesis cross-domain existe
- `{nombre-wp}-risk-register.md` actualizado con hallazgos del análisis
- Usuario confirmó los hallazgos explícitamente en esta sesión

**Detectar:** Si `work/.../analyze/` tiene documentos, Phase 3 ya comenzó.
Al terminar: proponer `/thyrox:constraints` para Phase 4.

---

## Referencias de calibración

> Para análisis de flujos agentic con calibración real (6 patrones operacionales con evidencia de sesión): ver `.claude/references/agentic-calibration-workflow-example.md`
