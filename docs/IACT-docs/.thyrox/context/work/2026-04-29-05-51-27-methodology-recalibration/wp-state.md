```yml
project: IACT-docs
work_package: 2026-04-29-05-51-27-methodology-recalibration
parent_wp: 2026-04-29-05-35-11-md-to-rst-saneamiento
parent_relationship: meta-analysis (recalibracion post-mortem del WP de saneamiento)
created_at: 2026-04-29 05:51:27
current_phase: Cerrado
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: Cerrado
```

# WP — Methodology Recalibration (post-saneamiento)

## Proposito

Recalibrar la atribucion de causa raiz de los fallos
ocurridos durante el WP de saneamiento md->rst (2026-04-29
05:35:11), y corregir las decisiones de codificacion
metodologica que se tomaron en caliente al final de esa
sesion.

Este WP es **meta-analisis**: no toca `source/`, no produce
codigo de aplicacion. Produce decisiones sobre que reglas
viven en `.claude/rules/` (carga siempre) vs
`.claude/skills/thyrox/references/` (lazy on-demand), y por
que.

## Origen del WP

Al final del saneamiento md->rst, el ejecutor levanto dos
problemas operativos:

1. **STD_007 violado 2 veces** durante el cleanup de READMEs
   (commits `dbf1798` y `0e14c10`). Resuelto solo tras
   feedback del ejecutor.

2. **36 procesos bash zombie** acumulados durante 3-4h por
   combinar `run_in_background` con `until grep ...; do
   sleep N; done` sin timeout, mientras el archivo task
   `.output` quedaba vacio por redireccion a `/tmp/buildN.txt`.

Mi respuesta fue agregar dos invariantes globales:

- `I-016 Background tasks` (commit `9150c15`)
- Propuesta de `I-017 Micro-ciclo metodologico` (no
  commiteada, en discusion)

El ejecutor cuestiono si **forzar metodologia via
invariante es la respuesta correcta**, sugiriendo que el
problema principal fue **calidad de ejecucion al mover/
copiar archivos desde references**, no falta de fases.

Para validar, se invoco al agente `deep-dive` con analisis
adversarial. Resultado: mi recalibracion estaba equivocada
en lo central.

## Acceptance criteria

- [x] WP creado con timestamp real.
- [x] Hallazgos del deep-review documentados verbatim
      en `analyze/deep-review-result.md`.
- [x] Causa raiz real (H2+H4) registrada en
      `discover/root-cause-real.md`.
- [x] Sesgo detectado ("realismo performativo
      metodologico") documentado.
- [ ] Plan de correccion en `plan/correction-plan.md`
      con 4 acciones (NO commit I-017, relocalizar I-016,
      crear 2 references on-demand, ajustar `.claude/rules/`
      criterios).
- [ ] Ejecutor aprueba el plan antes de ejecutar.

## Scope

**In-scope:**
- Documentar deep-review verbatim.
- Documentar causa raiz real.
- Plan de correccion (relocalizar I-016, crear references
  on-demand, NO codificar I-017).

**Out-of-scope:**
- Ejecutar las correcciones (separado, tras aprobacion).
- Modificar artefactos del WP de saneamiento (es historia,
  no se reescribe).

## Estado

**Borrador.** Pending aprobacion del plan por el ejecutor.
