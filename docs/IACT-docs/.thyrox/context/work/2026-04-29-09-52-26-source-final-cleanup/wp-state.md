```yml
project: IACT-docs
work_package: 2026-04-29-09-52-26-source-final-cleanup
created_at: 2026-04-29 09:52:26
current_phase: Phase 8 — PLAN EXECUTION (task-plan listo)
flow: thyrox
methodology_step: workflow-decompose
author: NestorMonroy
status: Listo para ejecucion
```

# WP — Source Final Cleanup

## Proposito

Ejecutar las correcciones identificadas en los 3 audits previos
hasta que el corpus `source/` cumpla con todas las normas y el
build siga verde 0/0/0.

3 audits insumo:

1. **WP `2026-04-29-06-56-16-source-compliance-audit`**: STD_007
   100% cumple. Gaps de integracion temp-backup ya resueltos
   en commit `c3c348e`.
2. **WP `2026-04-29-09-39-48-emoji-tables-audit`**:
   - 78 archivos con 1373 ocurrencias de emojis (STD_001).
   - 13 tablas grid/simple en 9 archivos (no recomendado).
3. **Este WP — markdown residual audit**: 22 archivos con 170
   ocurrencias de sintaxis markdown sin convertir.

## Acceptance criteria

- [ ] 22 archivos con markdown residual: convertidos a sintaxis
      rst pura.
- [ ] 78 archivos con emojis: limpiados segun tabla de
      sustitucion (excepto STD_001 que es excepcion legitima).
- [ ] 13 tablas grid/simple: convertidas a `list-table`
      (opcional — solo si reduce mantenibilidad).
- [ ] Build final: `make clean && make html` -> 0 WARN /
      0 ERR / 0 CRIT.
- [ ] Cada batch sigue el micro-ciclo de
      `mechanical-bulk-edits.md`: Diagnose → Pilot → Measure
      baseline → Apply → Regression check.

## Estructura

```
2026-04-29-09-52-26-source-final-cleanup/
├── wp-state.md                          (este archivo)
├── discover/
│   └── markdown-residual-analysis.md    (deep analysis)
├── plan-execution/
│   └── source-final-cleanup-task-plan.md (T-NNN tasks)
└── track/
    └── (changelog post-execucion)
```

## Estado

**Listo para ejecucion** via task-executor en loop. Cada T-NNN
es atomica: editar archivo(s) → build verify → commit → tick.
