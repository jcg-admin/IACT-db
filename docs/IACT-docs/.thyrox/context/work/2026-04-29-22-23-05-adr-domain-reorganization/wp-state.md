```yml
project: IACT-docs
work_package: 2026-04-29-22-23-05-adr-domain-reorganization
sub_wp_of: 2026-04-29-17-52-15-modelo-rbac-improvement
program_id: Z.1.A
created_at: 2026-04-29 22:23:05
closed_at: 2026-04-29 22:55:00
current_phase: Phase 11 — TRACK
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: Cerrado v1.0.0 — 12 ADRs movidos, build 0/0/0, Z.1 desbloqueado
```

# Z.1.A — ADR Domain Reorganization

## Origen

Decisión D-06 del Z.1 program (Interpretation A.3): los
`adr-MOD-*` viven en su directorio de dominio (no en
`source/normativa/gobernanza/` que es el catch-all actual).

## Scope

Mover 12 ADRs a sus directorios de dominio + crear 1 dir nuevo:

| Origen | Destino | Cant |
|--------|---------|-----:|
| `source/normativa/gobernanza/adr-back-*` (4 archivos) | `source/backend/` | 4 |
| `source/normativa/gobernanza/adr-front-*` (5 archivos) | `source/frontend/` | 5 |
| `source/normativa/gobernanza/adr-qa-*` (1 archivo) | `source/quality/` | 1 |
| `source/normativa/gobernanza/adr-devops-*` (2 archivos) | **`source/devops/` (NUEVO)** | 2 |
| `source/normativa/gobernanza/adr-gob-*` (8 archivos) | `source/normativa/gobernanza/` (queda — gob ES su módulo) | 0 |
| **Total movidos** | | **12** |

## Datos verificados (Phase 1 DISCOVER)

```bash
$ find source/normativa/gobernanza -name "adr-*" -exec basename {} \; | \
    sed -E 's/^adr-([a-z]+)-.*/\1/' | sort | uniq -c
   4 back
   2 devops
   5 front
   8 gob
   1 qa
```

```bash
$ for prefix in adr-back adr-front adr-qa adr-devops; do
    grep -rln ":doc:.*$prefix" source --include="*.rst" | wc -l
  done
0    # adr-back
0    # adr-front
0    # adr-qa
0    # adr-devops
```

**Hallazgo crítico:** 0 refs `:doc:` entrantes a los 12 ADRs a
mover. El move es **rename puro sin cascading refs**.

Verificaciones adicionales pendientes:
- Refs `:ref:` a labels de cada ADR
- Toctree entries en `normativa/gobernanza/index.rst`
- Toctree entries en `backend/index.rst`, `frontend/index.rst`,
  `quality/index.rst`, `gestion/...index.rst`
- Necesidad de crear `source/devops/index.rst` desde cero

## Acceptance criteria

- [ ] 4 adr-back-* en `source/backend/` con frontmatter actualizado.
- [ ] 5 adr-front-* en `source/frontend/`.
- [ ] 1 adr-qa-* en `source/quality/`.
- [ ] 2 adr-devops-* en `source/devops/` + `source/devops/index.rst`
      creado.
- [ ] Toctree de `normativa/gobernanza/index.rst` actualizado
      (remover entries movidos, dejar solo adr-gob-*).
- [ ] Toctree de cada destino actualizado con entries nuevos.
- [ ] Refs `:ref:` siguen funcionando (los labels viajan con el
      archivo).
- [ ] Build verde 0/0/0 con `SPHINX_NITPICKY=1`.
- [ ] STD-007 v2.0.2 §4 actualizado documentando esta convención
      ("ADRs viven en el directorio de su módulo").

## Riesgos

| Riesgo | Mitigación |
|--------|-----------|
| Toctrees de destino requieren orden alfabético | Inserir en orden y verificar build |
| `source/devops/` es dir nuevo: index + nav | PILOT con un solo ADR primero, validar |
| `:ref:` labels: ¿se preservan? | git mv NO toca contenido — labels viajan; verificación post-build |
| ADRs nuevos planeados (gob-009, back-006) ya consideran nueva ubicación? | ✓ — gob-009 va a gobernanza, back-006 va a backend (ya alineado con A.3) |

## Out of scope

- NO crear ADRs nuevos (eso es Z.1).
- NO supersede los ADR-BACK legacy (eso es Z.1).
- NO mover los adr-gob-* (gob ES su módulo).
- NO importar ADR-BACK-005 middleware desde temp-holding (eso es
  Z.1, ahora con destino actualizado a `source/backend/`).

## Estimación

~1.5-2h. 12 `git mv` + 6 toctree updates + 1 dir creation + 1
spec update + build verify.

## Próximo paso

Phase 5 STRATEGY directa (skip Phase 3 — el discover ya es claro)
+ Phase 8 PLAN-EXECUTION con T-NNN.
