```yml
project: IACT-docs
work_package: 2026-04-28-05-28-54-source-rebuild-risks-technical-debt
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #15 of 16 (tech-skeleton + closure tasks)
created_at: 2026-04-28 05:28:54
current_phase: Phase 11 — TRACK (CERRADO v1)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO v1 — 2026-04-29 (estructura minima creada en source/)
```

# WP-hijo #15 — Source Rebuild: risks-technical-debt

## Propósito

Crear cajón nuevo `source/risks-technical-debt/` para tech debt log
y risks register **PUBLICADO** (visible al sitio, distinto del
`.thyrox/context/technical-debt.md` interno). Estructura
**skeleton-first**.

**Adicional crítico:** este WP-hijo es **el último tech** y absorbe
las tareas de cierre del rebuild técnico (cleanup temp-* +
recuperar `-W`).

## Capa

**Tech (skeleton-first)** (capa 2) + tareas de cierre del rebuild.

## Pre-condiciones

- WPs #8-14 cerrados (es el último tech, depende de todos los
  previos).

## Decisiones del padre que aplican

- **Idea 9 + Decision 9 + 10 + 12.**
- **Decision 3 final:** recuperar `sphinx-build -W` exit 0 acá.
- **CLEANUP del padre:** eliminar `temp-backup/` y `temp-holding/`
  acá.

## Pre-tareas absorbidas (CRÍTICAS)

| Pre-tarea | Acción esperada en Phase 10 EXECUTE de este WP |
|-----------|------------------------------------------------|
| **Cleanup `temp-backup/source-2026-04-28/`** | Eliminar el directorio tras verificar que ningún archivo de `source/` lo referencia. |
| **Cleanup `temp-holding/`** | Eliminar el directorio tras verificar que ningún archivo de `source/` lo referencia. |
| **Recuperar `sphinx-build -W`** | Verificar build verde con `-W` exit 0. Hito final del rebuild macro. |
| **Re-verificar `.gitignore`** | Asegurar que `temp-*` quedan limpios. |

## Acceptance criteria del cajón

- ✅ 3 archivos skeleton: `index.rst`, `technical-debt.rst`,
  `risks-register.rst`.
- ✅ `technical-debt.rst`: lista TD pública con prioridad.
- ✅ `risks-register.rst`: riesgos técnicos abiertos del producto.
- ✅ Versión 1.0.0.

## Acceptance criteria de las tareas de cierre

- ✅ `temp-backup/` eliminado.
- ✅ `temp-holding/` eliminado.
- ✅ `find source -type f -name "*.rst" | xargs grep -l "temp-backup\|temp-holding"` → 0 resultados.
- ✅ `make clean && uv run sphinx-build -W -b html source/ build/html` → exit 0.

## Alcance

**In-scope:** Cajón skeleton + cleanup + recuperar -W.

**Out-of-scope:** TD/risks específicos del producto (se incorporan
en el sitio incrementalmente).

## Estado

**Borrador (no iniciado).** Spawneado por T-022.
