```yml
project: IACT-docs
work_package: 2026-04-29-06-56-16-source-compliance-audit
created_at: 2026-04-29 06:56:16
current_phase: Phase 3 — ANALYZE (audit completo)
flow: thyrox
methodology_step: workflow-analyze
author: NestorMonroy
status: Aprobado
```

# WP — Source Compliance Audit

## Proposito

Auditar `source/` contra 3 ejes:

1. **STD_007**: cumplimiento de la convencion de naming.
2. **Integracion temp-backup**: verificar que el contenido
   de `temp-backup/source-2026-04-28/` se migro correctamente
   a `source/` (sin perdidas no documentadas).
3. **Referencias Sphinx**: uso correcto de `:doc:`, `:ref:`,
   `:download:`, `:file:` en lugar de markdown links o paths
   crudos.

Salida: `analyze/audit-source-compliance.md` con hallazgos
clasificados por severidad.

## Acceptance criteria

- [x] Scan completo de `source/` para violaciones STD_007.
- [x] Diff temp-backup vs source con clasificacion de cada
      diferencia (renombrado / migrado / pendiente / gap).
- [x] Catalogo de patrones de referencia incorrectos.
- [x] Severidad asignada a cada hallazgo.
- [x] Recomendaciones accionables.

## Estado

**Cerrado**. Audit completo, sin acciones de cambio en este
WP — los hallazgos quedan como inputs para WPs futuros
(infrastructure, operations, debt resolution).
