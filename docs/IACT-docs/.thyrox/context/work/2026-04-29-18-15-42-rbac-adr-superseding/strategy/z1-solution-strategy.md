```yml
created_at: 2026-04-29 21:30:00
project: IACT-docs
work_package: 2026-04-29-18-15-42-rbac-adr-superseding
phase: Phase 5 — STRATEGY
author: NestorMonroy
status: Aprobado (con 1 punto pendiente: Interpretación A vs B)
version: 1.0.0
```

# Z.1 — Solution Strategy consolidada

## Decisiones aprobadas por el ejecutor

| # | Decisión | Estado |
|---|----------|--------|
| D-01 | Principio "source/ autocontenido + import histórico" | ✅ APROBADO |
| D-02 | Opción D: ubicación destino `source/gestion/evidencia/rbac-historia/` | ✅ APROBADO |
| D-03 | Plan ampliado de **8 archivos históricos** (vs 5 originales) | ✅ APROBADO |
| D-04 | Renombrar nuevo ADR técnico: adr-back-005 → **adr-back-006** | ✅ APROBADO |
| D-05 | ADR-BACK-005 middleware queda **out-of-scope de superseding**, pero se **importa** al corpus source/ | ✅ APROBADO |
| D-06 | Ubicación física de ADR-BACK-005 importado | ⚠️ PENDIENTE (ver "Punto pendiente") |

## Punto pendiente — D-06 ubicación ADR-BACK-005

| Interpretación | Ubicación | Pros | Contras |
|----------------|-----------|------|---------|
| **A — Literal** | `source/backend/adr-back-005-middleware-decoradores-permisos.rst` | Sigue instrucción literal "ponlo en backend" | Rompe convención (los adr-back-001..004 viven en `normativa/gobernanza/`) |
| **B — Convencional** (recomendada) | `source/normativa/gobernanza/adr-back-005-middleware-decoradores-permisos.rst` | Consistente con peers; ADRs son artefactos normativos | "ponlo en backend" se interpreta como "donde van los adr-back" |

**Default mientras se resuelve:** Interpretación B (consistente con
estructura existente). Cambiable si el ejecutor confirma A.

## Scope Z.1 consolidado

### Output 1 — ADRs nuevos (2)

| ID | Path | Supersede | Capa |
|----|------|-----------|------|
| `adr-gob-009-rbac-modelo-conceptual.rst` | `source/normativa/gobernanza/` | ADR-BACK-001 + ADR-BACK-004 | Conceptual (transversal) |
| `adr-back-006-rbac-estrategia-implementacion.rst` | `source/normativa/gobernanza/` | ADR-BACK-003 | Técnica (backend) |

### Output 2 — ADRs legacy actualizados (4)

| ADR legacy | Acción |
|------------|--------|
| ADR-BACK-001 grupos-funcionales-sin-jerarquia | `:estado: Superseded by adr-gob-009`; agregar sección "Superseded by" al final |
| ADR-BACK-003 orm-sql-hybrid-permissions | `:estado: Superseded by adr-back-006`; agregar sección |
| ADR-BACK-004 sistema-permisos-sin-roles-jerarquicos | `:estado: Superseded by adr-gob-009`; agregar sección |
| ADR-BACK-005 (importado nuevo) | `:estado: Vigente (legacy preservado)`; nota explicativa |

### Output 3 — Documentos históricos importados (8 + 1 ADR-BACK-005 = 9)

```
source/gestion/evidencia/rbac-historia/
├── index.rst                                              # entry-point del subdir
├── analisis-errores-modelo-rbac-v5-2-0.rst                # Change Impact (87 errores)
├── modelo-rbac-v4-0-roles-jerarquicos-deprecado.rst       # Baseline previo (resumen)
├── decisiones-modulos-8-vs-9-historico.rst                # Decision Log (PARTE 3)
├── gap-analysis-sistema-permisos-nov-2025.rst             # Gap Analysis nov 2025
├── discrepancia-rbac-correccion-ene-2026.rst              # Change Impact ene 2026
├── capacidades-vs-permisos-comparativo.rst                # Solution Recommendation (origen D-RBAC-1)
├── analisis-comparativo-rbac-v4-vs-br-iact.rst            # Genealogía v4 → v5
└── diseno-referencia-implementacion-permisos-legacy.rst   # Narrativa Modules/*.py
```

```
source/normativa/gobernanza/  (default — Interpretación B)
└── adr-back-005-middleware-decoradores-permisos.rst       # legacy preservado
```

### Output 4 — Cross-refs bidireccionales

- ADRs nuevos referencian:
  - Modelo vigente (`/arquitectura-tecnica/rbac/modelo-rbac-iact`)
  - CNST-029/030/031/032/033
  - ADR-GOB-008
  - ADRs legacy supersedidos
  - Documentos históricos en `gestion/evidencia/rbac-historia/`
- ADRs legacy supersedidos referencian al nuevo ADR que los supersede.
- Documentos históricos referencian ADRs nuevos como "spec vigente".

### Output 5 — Deuda diferida

- `DEBT-RBAC-RACI` registrado en `source/risks-technical-debt/deuda-tecnica-rebuild.rst` (matriz RACI sobre las 42 funciones, propuesta legítima de la nota in-text de ADR-BACK-004 pero out-of-scope de Z.1).

## Phases pendientes en Z.1

| Phase | Acción | Output |
|-------|--------|--------|
| Phase 5 STRATEGY | Confirmar D-06 + lock scope | este documento |
| Phase 6 PLAN | Definir scope explícito + roadmap | `plan/solution-plan.md` |
| Phase 8 PLAN-EXECUTION | Task plan T-NNN | `plan-execution/adr-superseding-task-plan.md` |
| Phase 9 PILOT (opcional) | Validar 1 ADR import como prueba | — |
| Phase 10 EXECUTE | Crear los 9 archivos históricos + 2 ADRs nuevos + actualizar 4 ADRs legacy + DEBT entry | commits Tim Pope |
| Phase 11 TRACK | Build verify 0/0/0 + changelog Z.1 | `track/adr-superseding-changelog.md` |

## Estimación tiempo Z.1 actualizada

| Bloque | Tiempo |
|--------|-------:|
| Bloque A — Crear `gestion/evidencia/rbac-historia/` con 8 archivos + index | 2.5-3.5h |
| Bloque B — Importar ADR-BACK-005 middleware legacy | 0.5h |
| Bloque C — Crear adr-gob-009 + adr-back-006 | 1.5-2h |
| Bloque D — Actualizar 4 ADRs legacy con `:estado: Superseded` + sección | 0.5h |
| Bloque E — DEBT entry + cross-refs + build verify + changelog | 1-1.5h |
| **Total** | **6-7.5h** |

## Riesgos del scope ampliado

| Riesgo | Mitigación |
|--------|-----------|
| Conversión MD → RST puede introducir warnings Sphinx | Build verify tras cada batch (cada 2-3 archivos) |
| 8 archivos + 1 ADR legacy = 9 nuevos en source/ | Separar por bloques + commits granulares |
| Bloque A (más grande) puede llevar más tiempo si conversión MD/TXT es compleja | PILOT en 1 archivo antes de bulk |
| Orden de import — algunos archivos referencian otros | Crear primero archivos sin deps + index al final |

## Política de safety (heredada del programa padre)

- Build verde 0/0/0 con `SPHINX_NITPICKY=1` tras cada bloque.
- Commits Tim Pope (≤72 ch subject + body con QUÉ y POR QUÉ).
- Cada archivo importado mantiene su `:fecha_creacion:` original
  (no la fecha de import) para preservar trazabilidad histórica
  real.
- Adaptación a Schema A canonical (STD-007 v2.0.2 §6).
- Nota visible "documento histórico — referencia para
  trazabilidad" en cada archivo importado.

## Próximo paso

Esperar confirmación de D-06 (Interpretación A o B) → escribir
Phase 6 PLAN + Phase 8 PLAN-EXECUTION (task plan T-NNN).
