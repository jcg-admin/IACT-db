```yml
project: IACT-docs
work_package: 2026-04-29-18-15-42-rbac-adr-superseding
sub_wp_of: 2026-04-29-17-52-15-modelo-rbac-improvement
program_id: Z.1
created_at: 2026-04-29 18:15:42
current_phase: Phase 1 — DISCOVER
flow: thyrox
methodology_step: workflow-discover
author: NestorMonroy
status: Activo
```

# Z.1 — RBAC ADR Superseding

## Contexto

Sub-WP del programa padre
`2026-04-29-17-52-15-modelo-rbac-improvement`. Aborda las
inconsistencias Inc-01, Inc-02, Inc-03 detectadas en el
deep-review del programa padre.

**Hereda de:** `discover/rbac-relations-deep-review.md` y
`discover/wp-reframing-vs-base-cognitiva.md` del programa padre.

## Problema concreto

3 ADRs aceptados (legacy noviembre 2025) violan el corpus normativo
vigente (abril 2026):

| ADR | Filename | Violación |
|-----|----------|-----------|
| **ADR-BACK-001** | `adr-back-001-grupos-funcionales-sin-jerarquia.rst` | Cita "19 funciones / 130+ capacidades"; usa "Capacidad" |
| **ADR-BACK-003** | `adr-back-003-orm-sql-hybrid-permissions.rst` | Tiene nota in-text "VALIDAR ESTA ESTRATEGIA"; usa "Capacidad" |
| **ADR-BACK-004** | `adr-back-004-sistema-permisos-sin-roles-jerarquicos.rst` | Tiene nota in-text "DOCUMENTAR MATRIZ RACI"; usa "Capacidad" |

Ground truth vigente:

- **modelo-rbac-iact v5.2.1**: 42 funciones + 10 grupos AGR + 3 SoD.
- **CNST-033**: vocabulario canónico "Función" / "Function";
  PROHIBIDA "Capacidad" / "Capacity".
- **ADR-GOB-008** (2026-04-29): coexistencia ACC ↔ PERM, declara
  D-RBAC-1 (vocabulario único) y D-RBAC-8 (migración Capacidad →
  Function).

## Objetivo

**Superseding formal** de los 3 ADR-BACK legacy con ADR(s) nuevo(s)
alineados al corpus vigente. **NO eliminar** los ADRs legacy —
preservar trazabilidad histórica con `:estado: Superseded by ...`.

## Acceptance criteria

- [ ] Decisión sobre ADR pattern: ¿1 ADR-GOB-NNN supersede a los 3?
      ¿O 3 ADR-BACK-NNN nuevos, uno por cada legacy?
- [ ] ADR(s) nuevo(s) creados, alineados a:
  - Vocabulario "Función" / "Function" (CNST-033)
  - Cifras "42 funciones / 10 grupos AGR / 3 SoD" (modelo v5.2.1)
  - Coexistencia ACC ↔ PERM (ADR-GOB-008)
- [ ] ADR-BACK-001/003/004: `:estado:` actualizado a "Superseded";
      sección "Superseded by" agregada al final con ref al ADR nuevo.
- [ ] Notas in-text "VALIDAR ESTA ESTRATEGIA" y "DOCUMENTAR MATRIZ
      RACI" resueltas (respondidas en los nuevos ADRs o explícitamente
      abandonadas).
- [ ] Cross-refs bidireccionales ADR nuevo ↔ modelo + CNST-033 +
      ADR-GOB-008.
- [ ] Build verde 0/0/0 con `SPHINX_NITPICKY=1`.
- [ ] No se rompen las refs entrantes a los ADR-BACK existentes
      (los lectores siguen llegando al ADR legacy y desde ahí saltan
      al nuevo via "Superseded by").

## Riesgos

| Riesgo | Mitigación |
|--------|-----------|
| 1 ADR vs 3 ADRs nuevos: decisión inmadura | Phase 5 STRATEGY decide |
| Refs `:doc:` rotas si renombramos algo | NO renombrar, solo actualizar `:estado:` y agregar sección |
| Notas in-text contienen requerimientos válidos (ej. matriz RACI) que se pierden | Análisis explícito en Phase 3 ANALYZE: ¿la nota tiene contenido válido o es noise? |

## Out of scope

- NO modificar el modelo-rbac-iact (eso es Z.2).
- NO reconciliar modelo ↔ ARQ_MOD_003 (eso es Z.3).
- NO cambiar refs entrantes (eso es Z.4 si aplica).

## Estructura del WP

```
2026-04-29-18-15-42-rbac-adr-superseding/
├── wp-state.md                      # este archivo
├── discover/
│   ├── adr-back-content-analysis.md # qué dicen exactamente los 3 ADR-BACK
│   └── notes-in-text-triage.md      # las notas "pendientes" — ¿valid o noise?
├── analyze/
│   └── superseding-strategy.md      # 1 ADR vs 3 nuevos
├── plan/
│   └── solution-plan.md
├── plan-execution/
│   └── adr-superseding-task-plan.md
└── track/
    └── adr-superseding-changelog.md
```

## Próximo paso

T-001 (Phase 1 DISCOVER): leer los 3 ADR-BACK completos y producir
`adr-back-content-analysis.md` con:
- Resumen ejecutivo de cada ADR
- Decisión que toma cada uno
- Cifras / vocabulario / supuestos
- Qué partes son recuperables vs descartables

T-002: triagear las 2 notas in-text — ¿son requerimientos válidos
que deben preservarse en el ADR nuevo, o ruido del workflow legacy?
