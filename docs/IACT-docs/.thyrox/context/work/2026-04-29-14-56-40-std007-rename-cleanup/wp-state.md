```yml
project: IACT-docs
work_package: 2026-04-29-14-56-40-std007-rename-cleanup
created_at: 2026-04-29 14:56:40
closed_at: 2026-04-29 16:30:00
current_phase: Phase 11 — TRACK
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: Cerrado v1.0.0 — migración completa, build 0/0/0
```

# WP — STD_007 Rename Cleanup (audit profundo categorías §4.x)

## Origen

Auditorias previas (`source-compliance-audit` 2026-04-29-06-56-16)
verificaron HARD checks de STD_007 §3.x (caracteres prohibidos,
tildes, eñe, longitud, README) y reportaron 100% cumplimiento.

**El audit profundo de hoy** detecta violaciones de los patrones
ESPECÍFICOS por categoría de artefacto (§4.1-§4.5):

| Categoría | Sección STD_007 | Archivos irregulares | Acción |
|-----------|-----------------|---------------------:|--------|
| STD sin número | §4.1 | 2 | Asignar número o consolidar |
| PROCED/PROC/RNF con `_` en descripción | §4.2 | 15 | Renombrar `_` → `-` |
| Guías sin prefijo con `_` | §4.4 | 6 | Renombrar `_` → `-` |
| **Total** | | **23** | |

## Patrón canónico violado

§4.2: `<PREFIX>-<MOD>-<NNN>-<descripcion-en-kebab>.rst`
- "kebab puro minúsculas" en la descripción
- Patrón actual incorrecto: descripción con `_` (mixed)

§4.4: `<descripcion-en-kebab-case>.rst`
- 100% lowercase + hyphens
- Patrón actual incorrecto: descripción con `_`

## Acceptance criteria

- [ ] 23 archivos renombrados al patrón correcto.
- [ ] Toctrees en `index.rst` afectados actualizados.
- [ ] Referencias `:doc:` y `:ref:` que apunten a archivos
      renombrados actualizadas.
- [ ] Build verde 0/0/0 mantenido (incluyendo `nitpicky=True`).
- [ ] Cada rename via `git mv` (preserva historial).

## Riesgos

| Riesgo | Mitigación |
|--------|-----------|
| Refs externas (links GitHub Pages, marcadores) rotas | Documentar redirects o aceptar como deuda transitoria |
| `git mv` puede romper `git log --follow` si el contenido cambia | Hacer rename PURO, sin tocar contenido en mismo commit |
| Toctree refs no encontradas (build rompe) | PILOT en 1 archivo + verify build antes de bulk |

## Estructura

```
2026-04-29-14-56-40-std007-rename-cleanup/
├── wp-state.md
├── discover/
│   └── std007-violations-inventory.md   (lista exacta)
├── plan/
│   └── rename-strategy.md               (orden, comandos)
├── plan-execution/
│   └── std007-rename-task-plan.md       (T-NNN)
└── track/
```

## Estado

**Listo para ejecucion**, pendiente aprobacion explicita del
ejecutor (cambios estructurales: 23 renames + toctrees + refs).
