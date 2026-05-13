```yml
type: Work Package State
version: 1.0
created_at: 2026-04-22 21:15:30
updated_at: 2026-04-22 21:15:30
wp_id: 2026-04-22-21-15-30-phase1-discover-iact-docs
epic: FASE 1 — DISCOVER IACT-docs
stage: 1
stage_name: DISCOVER
flow: null
methodology_step: null
status: in_progress
owner: claude
blockers: []
agents:
  - id: deep-dive
    type: adversarial
    status: pending
    output_file: iact-docs-deep-dive.md
  - id: calibration
    type: agentic-reasoning
    status: pending
    output_file: iact-docs-calibration.md
```

# Work Package: Phase 1 DISCOVER — IACT-docs

## Propósito

Análisis inicial de la documentación IACT-docs mediante agentes adversariales en paralelo. Objetivo: validar calidad epistémica y calibración de contenido documentado.

## Entrada (Input)

**Fuente:** `/source/` — 5 dominios semánticos, 3.6 MB de contenido Sphinx RST

**Dominios:**
1. **Requisitos** — funcionales, no-funcionales, casos de uso
2. **Arquitectura técnica** — diseño, despliegue, detalles
3. **Normativa** — estándares, gobernanza, procedimientos
4. **Base cognitiva** — ontología SBVR, glosario, taxonomías
5. **Gestión** — PM, evidencia, plantillas ADR

## Salida esperada (Output)

1. `iact-docs-deep-dive.md` — Análisis adversarial por dominio
   - Contradicciones estructurales
   - Claims sin respaldo
   - Saltos lógicos
   - Patrones de riesgo

2. `iact-docs-calibration.md` — Calibración epistémica
   - Ratio global
   - Distribución por dominio (CAD)
   - Recomendaciones por fase

## Fases Phase 1

- [ ] Preparar `input.md` (verbatim, sin comprimir)
- [ ] Lanzar agentes en paralelo: deep-dive + calibration
- [ ] Validar outputs
- [ ] Commitear artefactos
- [ ] Actualizar ROADMAP.md
- [ ] Cierre Phase 1 → Phase 2 BASELINE

## Notas

Convención CLAUDE.md: input.md preserva claims técnicos, conclusiones, código completo. No comprimir — calidad del análisis depende de completitud de input.
