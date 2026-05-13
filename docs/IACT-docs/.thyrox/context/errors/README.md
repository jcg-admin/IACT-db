# Error Tracking Index

Errores documentados durante el desarrollo de THYROX. Todos resueltos — sirven como referencia de anti-patterns para futuros proyectos.

| ERR | Descripción | Estado | Resolución |
|-----|-------------|--------|------------|
| 001 | Análisis no documentado en context/ | Resuelto | Work packages con analysis/ |
| 002 | Clasificación incorrecta de tamaño del proyecto | Resuelto | SKILL.md escalabilidad ref |
| 003 | Sin validación de specs | Resuelto | spec-quality-checklist.md.template |
| 004 | Sin constitution gates | Resuelto | Locked decisions en CLAUDE.md |
| 005 | Fases no ejecutables | Resuelto | Pasos numerados en SKILL.md |
| 006 | Saltar fases (reincidencia ERR-002) | Resuelto | "ANALYZE first" como locked decision |
| 019 | Cycles en vez de epics | Resuelto | Work packages con timestamp |
| 020 | Decisions sin ADR format | Resuelto | context/decisions/adr-NNN.md |
| 021 | Work-log vacío | Resuelto | Eliminado — git log + checkboxes suficiente |
| 022 | Work-log no actualizado | Resuelto | Eliminado junto con ERR-021 |
| 023 | Flujo confuso entre archivos | Resuelto | Covariancia + 3 niveles (SKILL>CLAUDE>README) |
| 024 | Archivar en vez de organizar | Resuelto | Organizar work packages existentes |
| 025 | Work packages sin timestamp real | Resuelto | `date +%Y-%m-%d-%H-%M-%S` obligatorio |
| 026 | Sin análisis de cuándo se usan references | Resuelto | References por dominio en SKILL.md |
| 027 | Sin mapping de cuándo se usan templates | Resuelto | references-templates-mapping.md |
| 028 | Commits retrasados después de crear archivos | Resuelto | Commit inmediato como convención |

| 029 | Phase 2 ejecutada sin seguir structure de solution-strategy.md | Resuelto | Rehecho con estructura completa; SKILL debería referenciar estructura |

**Template para nuevos errores:** `assets/error-report.md.template` (campos: Qué pasó / Por qué / Prevención / Insight)
