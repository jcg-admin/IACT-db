```yml
project: IACT-docs
work_package: 2026-04-28-05-28-55-source-rebuild-gestion
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #16 of 16 (last — lifecycle)
created_at: 2026-04-28 05:28:55
current_phase: Phase 11 — TRACK (CERRADO v1)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO v1 — 2026-04-29 (estructura minima creada en source/)
```

# WP-hijo #16 — Source Rebuild: gestion (Lifecycle expandido)

## Propósito

Reconstruir `source/gestion/` expandido con sub-cajones de
**project lifecycle** (capa 3 de la arquitectura v2.0): charter,
roadmap, OKRs, épicas, sprints, releases, retrospectives, team.

## Capa

**Lifecycle** (capa 3) — único WP de esta capa.

## Pre-condiciones

- WP #15 cerrado (es el último WP — todos los demás listos).

## Decisiones del padre que aplican

- **Idea 8 (3 dimensiones — gestion es la dimensión lifecycle).**
- **Decision 9 (gestion expandido con sub-cajones).**
- **Decision 13 (source/ ↔ .thyrox/ separados):** ningún archivo
  de `gestion/` se auto-genera desde `.thyrox/context/work/`. Todo
  contenido es escrito a mano por el ejecutor.

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Inventario actual de gestion/** | source/gestion/ existe (15 archivos) — `pm/`, `plantilla_adr.rst`, etc. Triage para reorganización. |
| **Sub-cajones a crear** | charter/, roadmap/, okrs/, epicas/, sprints/, releases/, retrospectives/, team/. Cada uno con `index.rst` + mínimo 1 archivo de contenido. |
| **Decisión por sub-cajón** | Qué nivel de detalle se publica, frecuencia de actualización, owner. |
| **Verificar independencia source ↔ .thyrox** | grep en `gestion/` post-rebuild: 0 referencias a `.thyrox/context/work/`. |

## Acceptance criteria

- ✅ Sub-cajones creados con `index.rst`.
- ✅ charter/ contiene project charter del producto IACT.
- ✅ roadmap/ contiene roadmap publicable (puede ser distinto/
  resumido del ROADMAP.md raíz que es de iniciativas internas).
- ✅ epicas/ contiene resumen publicable de épicas relevantes
  para stakeholders externos (escrito a mano, no auto-generado).
- ✅ releases/ contiene release notes técnicas (distintas del
  CHANGELOG.md).
- ✅ retrospectives/ contiene lessons-learned públicas.
- ✅ team/ contiene organización + roles publicables.
- ✅ Cero refs a `.thyrox/`.
- ✅ Versión 1.0.0 en metadata.

## Alcance

**In-scope:** Sub-cajones lifecycle con contenido inicial.

**Out-of-scope:** Auto-generación desde `.thyrox/`. News/anuncios
externos (no aplica al scope per D-V2-7).

## Estado

**Borrador (no iniciado).** Spawneado por T-023.

---

**Tras el cierre de este WP, el WP-padre `source-rebuild-strategy`
puede cerrarse (T-025..T-033 del task plan del padre).**
