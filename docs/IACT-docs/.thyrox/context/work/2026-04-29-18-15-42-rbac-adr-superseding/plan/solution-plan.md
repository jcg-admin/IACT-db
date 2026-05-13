```yml
created_at: 2026-04-29 23:00:00
project: IACT-docs
work_package: 2026-04-29-18-15-42-rbac-adr-superseding
phase: Phase 6 — PLAN
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Z.1 — Solution Plan

## Pre-condiciones cumplidas

- ✅ Z.1.A cerrado (ADRs reorganizados a su dominio).
- ✅ STRATEGY consolidada (`strategy/z1-solution-strategy.md`).
- ✅ Decisiones D-01 a D-06 aprobadas (D-06 = Interpretación A.3).
- ✅ Build verde 0/0/0 con corpus reorganizado.

## Scope final (lock)

### In-scope

1. **8 documentos históricos** importados en
   `source/gestion/evidencia/rbac-historia/`:
   - `analisis-errores-modelo-rbac-v5-2-0.rst`
   - `modelo-rbac-v4-0-roles-jerarquicos-deprecado.rst`
   - `decisiones-modulos-8-vs-9-historico.rst`
   - `gap-analysis-sistema-permisos-nov-2025.rst`
   - `discrepancia-rbac-correccion-ene-2026.rst`
   - `capacidades-vs-permisos-comparativo.rst`
   - `analisis-comparativo-rbac-v4-vs-br-iact.rst`
   - `diseno-referencia-implementacion-permisos-legacy.rst`
   - `index.rst`

2. **1 ADR legacy importado** en `source/backend/`:
   - `adr-back-005-middleware-decoradores-permisos.rst`

3. **2 ADRs nuevos** alineados a v5.2.1 + CNST-033:
   - `source/normativa/gobernanza/adr-gob-009-rbac-modelo-conceptual.rst`
   - `source/backend/adr-back-006-rbac-estrategia-implementacion.rst`

4. **4 ADRs legacy** marcados `:estado: Superseded` con sección
   "Superseded by":
   - `source/backend/adr-back-001-grupos-funcionales-sin-jerarquia.rst`
   - `source/backend/adr-back-003-orm-sql-hybrid-permissions.rst`
   - `source/backend/adr-back-004-sistema-permisos-sin-roles-jerarquicos.rst`
   - (BACK-002 NO se supersede — es sobre configuración dinámica,
     fuera del scope RBAC).

5. **DEBT-RBAC-RACI** registrado en
   `source/risks-technical-debt/deuda-tecnica-rebuild.rst`.

6. **Cross-refs bidireccionales** entre ADRs nuevos, modelo,
   CNSTs, históricos.

### Out-of-scope

- NO modificar `modelo-rbac-iact.rst` (es Z.2).
- NO reconciliar modelo ↔ ARQ_MOD_003 (es Z.3).
- NO supersede ADR-BACK-002 (no es RBAC core).
- NO migrar el código Python `temp-holding/Modules/*.py` como
  archivos `.py` — solo narrativa RST.

## Roadmap por bloques

### Bloque A — Historical imports (`gestion/evidencia/rbac-historia/`)

**Pre-condición:** ninguna.

**Estrategia:** PILOT con 1 archivo, validar conversión MD→RST,
luego bulk.

**Orden:**
1. PILOT: `analisis-errores-modelo-rbac-v5-2-0.rst` (~14 KB → ~280 líneas).
2. Bulk 7 archivos restantes.
3. `index.rst` al final (entry-point con toctree completo).
4. Build verify entre PILOT y bulk.

**Estimación:** 2.5-3.5h.

### Bloque B — ADR-BACK-005 middleware import (`source/backend/`)

**Pre-condición:** Bloque A no requiere — independiente.

**Estrategia:** import directo del archivo legacy con conversión
MD→RST + frontmatter Schema A. Marcar `:estado: Vigente (legacy
preservado)` con nota visible.

**Estimación:** 0.5h.

### Bloque C — ADRs nuevos (gob-009 + back-006)

**Pre-condición:** Bloque A cerrado (los nuevos referencian a
los históricos importados).

**Estrategia:**
1. `adr-gob-009-rbac-modelo-conceptual.rst` (supersede BACK-001 +
   BACK-004; conceptual, transversal, en gobernanza).
2. `adr-back-006-rbac-estrategia-implementacion.rst` (supersede
   BACK-003; técnico, en backend).

Cross-refs: modelo + CNST-029..033 + ADR-GOB-008 + 8 históricos
+ BACK-001/003/004 legacy + nota de matriz RACI diferida.

**Estimación:** 1.5-2h.

### Bloque D — Mark BACK-001/003/004 as Superseded

**Pre-condición:** Bloque C cerrado (los ADRs nuevos deben existir
para apuntar `Superseded by`).

**Estrategia:** edición de cada uno:
- `:estado: Superseded`
- Sección "Superseded by" al final apuntando al ADR nuevo.
- Conservar contenido legacy intacto (preservación histórica).

**Estimación:** 0.5h.

### Bloque E — DEBT + toctrees + build verify + changelog

**Pre-condición:** Bloques A-D cerrados.

**Estrategia:**
1. DEBT-RBAC-RACI en `risks-technical-debt/deuda-tecnica-rebuild.rst`.
2. Update toctrees:
   - `source/gestion/evidencia/index.rst` (agregar rbac-historia).
   - `source/backend/index.rst` (agregar 005 + 006 al toctree ADRs).
   - `source/normativa/gobernanza/index.rst` (agregar 009 al toctree ADRs).
3. Cold rebuild verify SPHINX_NITPICKY=1 → 0/0/0.
4. Changelog Z.1.

**Estimación:** 1-1.5h.

## Estimación total

| Bloque | Tiempo |
|--------|-------:|
| A — Históricos | 2.5-3.5h |
| B — Middleware import | 0.5h |
| C — ADRs nuevos | 1.5-2h |
| D — Superseded markers | 0.5h |
| E — DEBT + toctrees + verify + changelog | 1-1.5h |
| **Total** | **6-8h** |

## Política de safety

- Build verde 0/0/0 con SPHINX_NITPICKY=1 al cierre de cada bloque.
- Commits Tim Pope granulares por sub-tarea (~10-15 commits totales).
- Cada doc importado preserva su `:fecha_creacion:` original en
  metadata (trazabilidad histórica real).
- Cada doc importado lleva nota visible "documento histórico".
- Cross-refs verificadas con grep antes de cierre.

## Próximo paso

Phase 8 PLAN-EXECUTION: descomponer en task plan T-NNN.
