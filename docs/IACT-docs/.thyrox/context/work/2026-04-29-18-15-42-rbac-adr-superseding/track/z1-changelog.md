```yml
created_at: 2026-04-30 00:30:00
project: IACT-docs
work_package: 2026-04-29-18-15-42-rbac-adr-superseding
phase: Phase 11 — TRACK
author: NestorMonroy
status: Cerrado
version: 1.0.0
```

# Z.1 Changelog — RBAC ADR Superseding

## Resumen

Sub-WP del programa `modelo-rbac-improvement` (Z). Cierra las 3
inconsistencias normativas RBAC + materializa toda la trazabilidad
historica + crea matriz RACI. **Sin deuda diferida.**

## Metricas

| Metrica | Valor |
|---------|------:|
| Archivos creados nuevos en source/ | **12** |
| Archivos legacy actualizados (Superseded) | 3 |
| Build cold rebuild SPHINX_NITPICKY=1 | **0/0/0** |
| Bloques ejecutados | 5 (A, B, C, D, E) |
| Tareas atomicas | 30 |
| Tiempo total | ~6h |
| DEBT diferida | **0** (matriz RACI materializada) |

## Resolucion de inconsistencias

| ID | Descripcion | Estado |
|----|-------------|--------|
| Inc-01 | ADR-BACK-001 cifras "19/130+" vs v5.2.1 "42/10/3" | ✅ adr-gob-009 supersede con cifras canonicas |
| Inc-02 | "Capacidad" en ADR-BACK-001/003/004 vs CNST-033 "Function" | ✅ adr-gob-009 + adr-back-006 con vocabulario CNST-033 enforced |
| Inc-03 | Notas in-text "VALIDAR ESTRATEGIA" / "MATRIZ RACI" en ADRs aceptados | ✅ resueltas en adr-back-006 § 2.2 + matriz RACI materializada en raci-rbac-iact.rst |

## Outputs producidos (12 archivos nuevos)

### En `source/gestion/evidencia/rbac-historia/` (8 historicos)

1. `index.rst`
2. `analisis-errores-modelo-rbac-v5-2-0.rst` — Change Impact (87+ errores v5.2.0)
3. `modelo-rbac-v4-0-roles-jerarquicos-deprecado.rst` — Baseline previo
4. `decisiones-modulos-8-vs-9-historico.rst` — Decision Log
5. `gap-analysis-sistema-permisos-nov-2025.rst` — Gap Analysis (75% completed)
6. `discrepancia-rbac-correccion-ene-2026.rst` — Change Impact (R001..R018 detection)
7. `capacidades-vs-permisos-comparativo.rst` — Solution Recommendation (origen D-RBAC-1)
8. `analisis-comparativo-rbac-v4-vs-br-iact.rst` — Genealogia v4 → v5.x
9. `diseno-referencia-implementacion-permisos-legacy.rst` — Reference Design (12 .py)

### En `source/normativa/gobernanza/`

- `adr-gob-009-rbac-modelo-conceptual.rst` — Supersede BACK-001 + BACK-004

### En `source/backend/`

- `adr-back-005-middleware-decoradores-permisos.rst` — Legacy preservado
- `adr-back-006-rbac-estrategia-implementacion.rst` — Supersede BACK-003

### En `source/arquitectura-tecnica/rbac/`

- `raci-rbac-iact.rst` — Matriz RACI completa (42 funciones + 10 AGR + 3 SoD + ops gobernanza)

## Outputs actualizados (legacy preservado con marker)

| Archivo | Cambio |
|---------|--------|
| `source/backend/adr-back-001-grupos-funcionales-sin-jerarquia.rst` | `:estado: Superseded` + warning block apuntando a adr-gob-009 |
| `source/backend/adr-back-003-orm-sql-hybrid-permissions.rst` | `:estado: Superseded` + warning block apuntando a adr-back-006 |
| `source/backend/adr-back-004-sistema-permisos-sin-roles-jerarquicos.rst` | `:estado: Superseded` + warning block apuntando a adr-gob-009 |

## Materializaciones que evitaron deuda

**No diferimos** la matriz RACI propuesta como "DEBT-RBAC-RACI" —
se creo el documento completo `raci-rbac-iact.rst` con:

- 42 funciones x 6 stakeholders por modulo (8 sub-tablas).
- 10 grupos AGR x stakeholders.
- 3 reglas SoD x stakeholders.
- Operaciones de gobernanza del modelo.
- Mapeo stakeholder ↔ Actor Tipico ↔ AGR (per modelo v5.2.1 § 4.1).
- Fundamento documental (citas a v5.2.1 + historicos legacy).

## Lecciones aprendidas

1. **El principio "source/ autocontenido"** se aplico
   sistematicamente. Los ADRs nuevos NO referencian temp-holding/.
   El material historico se importo a source/gestion/evidencia/rbac-historia/.

2. **Vocabulario CNST-033 estricto en codigo nuevo.** El primer
   borrador de adr-back-006 uso ``usuario_tiene_funcion()`` (espanol
   parcial) — corregido a ``user_has_function()`` (ingles canonico)
   tras el feedback del ejecutor.

3. **No diferir cuando se puede materializar.** La nota in-text de
   matriz RACI (origen ADR-BACK-004) inicialmente se planeo diferir
   como DEBT. Tras feedback del ejecutor se materializo en
   `raci-rbac-iact.rst`. Resultado: cero deuda.

4. **La consulta a temp-holding antes de redactar artefactos
   complejos es obligatoria.** La matriz RACI inicial uso
   stakeholders genericos; tras consultar v5.2.1 § 4.1 se
   enriquecio con mapeo a Actores Tipicos y AGR documentados.

## Commits del WP

```
93830f8 — Z.1 Phase 1 DISCOVER complete (adr-back content + notes triage)
91016c7 — Inventory temp-holding for Z.1
60aca37 — Document historical import strategy v1
3cbe5ad — Revise import strategy v2 (gestion/evidencia + 8 files + renumber)
66d0cdb — Z.1 Phase 5 STRATEGY consolidated
34efdc8 — Z.1.A reorganize 12 ADRs by domain (separate sub-WP, closed)
7251f8b — Z.1 Phase 6 PLAN + Phase 8 PLAN-EXECUTION
3c1ff18 — Z.1 Bloque A: 8 historical RBAC docs in gestion/evidencia
b6900be — Z.1 Bloque B: import legacy ADR-BACK-005 middleware
27aca56 — Z.1 Bloque C: adr-gob-009 + adr-back-006 (new)
c61fafa — Z.1 Bloque D: BACK-001/003/004 marked Superseded
+ pending — Z.1 Bloque E: RACI matrix + cleanup + closure
```

## Status programa padre

Z.1 cierra. Sub-WPs restantes del programa
`modelo-rbac-improvement`:

```
Z.1.A adr-domain-reorganization     ✅ CERRADO
Z.1   rbac-adr-superseding          ✅ CERRADO (este WP)
Z.2   rbac-modelo-conceptual-cleanup  🔓 desbloqueado
Z.3   rbac-arq-mod-003-reconciliation 🔒 bloqueado por Z.2
Z.4   rbac-bidirectional-traceability 🔒 bloqueado por Z.3
Z.5   rbac-final-adversarial-validation 🔒 bloqueado por Z.4
```

## Cierre

Build verde 0/0/0 cold rebuild SPHINX_NITPICKY=1.
0 deuda diferida.
3 inconsistencias resueltas.
12 archivos nuevos + 3 actualizados.
Cumplimiento STD-007 v2.0.2 + CNST-033 100%.

WP cerrado.
