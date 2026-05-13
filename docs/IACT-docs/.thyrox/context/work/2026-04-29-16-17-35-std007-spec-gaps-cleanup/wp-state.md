```yml
project: IACT-docs
work_package: 2026-04-29-16-17-35-std007-spec-gaps-cleanup
created_at: 2026-04-29 16:17:35
closed_at: 2026-04-29 17:35:00
current_phase: Phase 11 — TRACK
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: Cerrado v1.0.0 — todos los F-01..F-13 resueltos, build 0/0/0
```

# WP — STD_007 Spec Gaps Cleanup

## Origen

WP previo `2026-04-29-14-56-40-std007-rename-cleanup` (cerrado) migró
el corpus a STD_007 v2.0.0 → v2.0.1 (315 archivos + 21 dirs +
módulos REQ/DOC + STDs 008/009 numerados). Deep-review adversarial
posterior identificó **6 hallazgos** que rompen el claim de "100%
cumplimiento". Este WP los aborda + busca hallazgos adicionales.

## Hallazgos a abordar (deep-review previo)

| F-NN | Severidad | Resumen | Cant |
|------|-----------|---------|-----:|
| F-01 | MAJOR | Archivos `procedimiento-*` sin `<MOD>-<NNN>` | 9 |
| F-02 | MAJOR | Prefijo `arq-mod-NNN-` no documentado en spec | 8 |
| F-03 | MAJOR | Módulos `adr-back/front`, `rnf-proc` no documentados | 0 archivos, hueco en spec |
| F-04 | INFO | `:artefacto:` mantiene PascalCase legacy | ~150 |
| F-05 | INFO | Duplicados de filename en distintos paths | 3 pares |
| F-06 | INFO | Guías sin prefijo en `normativa/estandares/` | 3 |

## Hallazgos adicionales detectados en este WP

| F-NN | Severidad | Resumen | Cant |
|------|-----------|---------|-----:|
| F-07 | MAJOR | Archivos sin frontmatter `.. meta::` | 37 |
| F-08 | MAJOR | Archivos sin `:version:` en metadata | 35 |
| F-09 | MAJOR | Archivos sin `:fecha_creacion:` | 133 |
| F-10 | CRITICAL | Archivos parcialmente convertidos de MD (formato híbrido) | ≥2 RNF |
| F-11 | INFO | 0 anchor labels duplicados | ✓ clean |
| F-12 | INFO | 0 archivos huérfanos en toctrees | ✓ clean |

## Acceptance criteria

- [ ] F-01: 9 archivos `procedimiento-*` re-clasificados a
      `proc-<MOD>-<NNN>-<desc>.rst`.
- [ ] F-02: 8 archivos `arq-mod-NNN-*` re-clasificados o spec
      actualizado.
- [ ] F-03: STD_007 §4 documenta módulos para `adr-` y `rnf-`.
- [ ] F-04: STD_007 §2 clarifica que `:artefacto:` queda fuera
      de scope (código semántico, no filename).
- [ ] F-05: documentar política para duplicados (¿prohibido?
      ¿permitido con caveat de refs absolutas?).
- [ ] F-06: re-clasificar 3 guías sin prefijo en
      `normativa/estandares/` (¿mover de directorio? ¿asignar prefijo?).
- [ ] F-07/F-08/F-09: archivos sin metadata estandarizada
      remediados.
- [ ] F-10: archivos híbridos MD/RST convertidos a RST puro
      con frontmatter `.. meta::`.
- [ ] STD_007 v2.0.1 → v2.0.2 (PATCH) consolidando todos los
      gaps de spec.
- [ ] Build verde 0/0/0 con `SPHINX_NITPICKY=1`.
- [ ] Commitment de 30 días NO se reinicia (v2.0.2 sigue siendo
      compatible con v2.0.0).

## Riesgos

| Riesgo | Mitigación |
|--------|-----------|
| Reclasificación F-01 con MOD incorrecto | Proponer mapeo y aprobar antes de bulk |
| F-10 (híbridos MD/RST) puede requerir reescritura semántica, no solo metadata | Inspeccionar contenido caso por caso |
| F-07/F-08/F-09 conteos pueden incluir archivos legítimamente sin frontmatter (guías cortas) | Distinguir entre "debe tener" vs "puede no tener" |

## Estructura del WP

```
2026-04-29-16-17-35-std007-spec-gaps-cleanup/
├── wp-state.md                                 # este archivo
├── discover/
│   ├── deep-review-findings-inventory.md       # F-01..F-12 detallado
│   └── metadata-coverage-audit.md              # F-07/08/09/10 detalle
├── analyze/                                    # análisis por finding
├── plan/                                       # solution strategy
├── plan-execution/                             # task plan + scripts
└── track/                                      # closure
```
