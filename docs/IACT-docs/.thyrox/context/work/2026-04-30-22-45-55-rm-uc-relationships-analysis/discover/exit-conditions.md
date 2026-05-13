```yml
created_at: 2026-04-30 22:45:55
project: IACT-docs
work_package: 2026-04-30-22-45-55-rm-uc-relationships-analysis
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
```

# Exit Conditions — UC Relationships Analysis

Condiciones formales para cerrar este WP. Solo el ejecutor ordena
cierre (I-011); estas condiciones son los pre-requisitos verificables.

## Entregables publicados

- [ ] `discover/uc-inventory.md` — inventario completo cubre los 9
  clusters (auth, usr, acc, perm, rpt, alr, pip, aud, log).
- [ ] `discover/uc-relationships-analysis.md` — relaciones include /
  extend / generalización / dependencia con cita al `uc-*.rst` que las
  justifica.
- [ ] `analyze/uc-catalog-diagram.md` — diagrama consolidado por
  cluster + overview cross-cluster.
- [ ] `track/lessons-learned.md` — al cerrar.

## Calidad del inventario

- [ ] Cada UC tiene: id canónico (`UC_<CLUSTER>_<NN>`), título corto,
  actor primario, restricciones canónicas asociadas (CNST/BR), al
  menos una relación documentada con otro UC.
- [ ] Conteo del inventario coincide con `find source/requisitos/casos-uso/
  -name 'uc-*.rst' | wc -l`.

## Calidad del análisis de relaciones

- [ ] Cada relación cita el archivo `.rst` y la sección que la
  justifica (pre/post-condiciones, flujo, includes explícitos).
- [ ] Relaciones sin cita quedan listadas en sección "Candidatas
  pendientes" — no en el cuerpo principal.
- [ ] Las 4 hipótesis iniciales del wp-state están resueltas como
  OBSERVABLE / INFERRED / DESCARTADA. Ninguna queda SPECULATIVE.

## Calidad del diagrama consolidado

- [ ] Renderiza limpio en `make html` sin warnings PlantUML.
- [ ] Descompuesto por cluster (1 sub-diagrama por cluster) más un
  overview que muestra solo UCs ancla y dependencias transversales.
- [ ] Sintaxis PlantUML valida con `plantuml -checkonly`.

## Gates THYROX

- [ ] I-012 — ningún hallazgo SPECULATIVE en sección "Conclusiones".
- [ ] I-011 — cierre solo por orden explícita del ejecutor.
- [ ] I-013 — claims heredados del cajón metodológico se re-verifican
  contra los `uc-*.rst` reales antes de propagarse al análisis.

## Cierre

Cuando los checkboxes de arriba estén satisfechos y el ejecutor ordene
cierre, se actualizará `wp-state.md` con `closed_at` + `status:
Cerrado` y se promoverá entrada al `CHANGELOG.md` raíz si corresponde.
