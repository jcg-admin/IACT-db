```yml
project: IACT-docs
work_package: 2026-04-30-19-30-24-token-consumption-analysis
created_at: 2026-04-30 19:30:24
current_phase: Phase 1 — DISCOVER
status: En espera (hold)
author: NestorMonroy
```

# WP — Análisis de consumo de tokens en sesiones IACT-docs

## Estado

**HOLD.** Este WP queda abierto pero sin ejecución hasta que el
ejecutor lo retome explícitamente (I-011). No abrir
``measure/`` ni ``analyze/`` hasta que se confirme el go.

## Motivo

Durante la sesión de generación de las guías metodológicas
(H7-H12 en ``source/requisitos/_metodologia-aplicacion/``)
el ejecutor observó un consumo elevado de tokens
(autoreportado: ~25% del context window en pocas vueltas).
El objetivo de este WP es entender la causa raíz para
introducir mitigaciones reproducibles, sin desviar el scope
actual (generación correcta de documentación de
``source/requisitos/*``).

## Scope (cuando se retome)

- IN: identificar drivers reales de consumo de tokens en este
  proyecto (resume del compact, recarga de
  ``.claude/rules/*``, listas de skills/agents,
  pegado de documentos largos, eco del summary).
- IN: diseñar mitigaciones aplicables al repo
  (configuración, hooks, convenciones de pegado, división de
  guías en paquetes más pequeños).
- OUT: cambios al binario de Claude Code o al harness.
- OUT: optimización de modelos o de pricing.
- OUT: continuar generando guías H13+ — eso pertenece al
  scope actual.

## Hipótesis iniciales (sin verificar)

1. El SessionStart hook recarga el listado completo de skills
   y agents en cada resume → input fijo por sesión.
2. ``.claude/rules/*.md`` se inyectan como project
   instructions en cada turno → input fijo por turno.
3. El compact summary repite parte del contenido pegado
   previamente (guías Schmuller H7-H12 ~8-12 KB cada una)
   → costo amortizado pero recurrente al re-resumir.
4. Las guías pegadas por el usuario se incluyen en el
   próximo summary, multiplicando su huella.

Todas las hipótesis son SPECULATIVE hasta que MEASURE
recoja datos reales.

## Próximos pasos (no ejecutar ahora)

- Phase 1 DISCOVER: levantar inventario de fuentes de input
  fijo (rules, hooks, plugin manifest) y medir su tamaño en
  caracteres / tokens estimados.
- Phase 2 MEASURE: registrar dos sesiones controladas — una
  con pegado mínimo y otra con pegado de guía completa —
  para aislar el delta atribuible al pegado vs al overhead
  estructural.
- Phase 3 ANALYZE: descomponer el consumo en (a) overhead
  estructural recurrente, (b) input puntual del turno, (c)
  amplificación por compact.

## Trazabilidad

- Origen: observación del ejecutor durante integración H7-H12.
- WP relacionado:
  ``2026-04-30-09-06-01-requisitos-update`` (scope activo).
- WP relacionado en hold:
  ``2026-04-30-15-54-58-cherry-pick-estructura-corporativa``.
- Reglas potencialmente afectadas: ninguna por ahora — este
  WP solo levanta análisis, no propone reglas todavía.

## Cierre

Este WP no se cierra por inferencia (I-011). Solo se cierra
cuando el ejecutor lo ordene explícitamente tras completar
las phases 1-3.
