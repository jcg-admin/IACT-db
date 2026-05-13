```yml
created_at: 2026-04-28 04:55:00
project: IACT-docs
work_package: 2026-04-28-01-58-08-source-rebuild-strategy
phase: Phase 6 — PLAN (artefacto de soporte — output de agente)
author: deep-review agent (invocado por orquestador)
status: Aprobado (input para plan.md)
version: 1.0.0
agent_id: ae6f93f7da985035b
invocation_bound: 5 artefactos · 6 ejes · ≤8 gaps · ≤500 palabras
```

# Deep-Review — Phase 5 STRATEGY → Phase 6 PLAN

Output del agente `deep-review` invocado el 2026-04-28 ~04:55 para
verificar cobertura entre Phase 5 STRATEGY (cerrada v2.0) y Phase 6
PLAN (a redactar). Insumo directo para `source-rebuild-strategy-plan.md`.

## Contexto de la invocación

- **Agente:** `.claude/agents/deep-review.md`
- **Bound:** 5 artefactos a leer, 6 ejes, ≤8 gaps, ≤500 palabras.
- **Artefactos analizados:**
  1. `strategy/source-rebuild-strategy-solution-strategy.md`
  2. `strategy/templates-inventory-analysis.md`
  3. `strategy/restricciones-divergence-analysis.md`
  4. `strategy/tech-stack-alignment-analysis.md`
  5. `discover/source-rebuild-strategy-analysis.md`

## Resultado del agente (verbatim)

### Cobertura ya buena (pasa al plan sin riesgo)

1. **Orden de los 16 WPs** — tabla en Decision 1
   (solution-strategy.md:286-303) es ejecutable tal cual.
2. **Stack técnico** — sección "Technology Stack" +
   tech-stack-alignment-analysis cubre el qué y el por qué del
   híbrido.
3. **Bridge plan / build verde** — Idea 2 + Decision 3 + Quality
   Goal 3 son consistentes y operacionales.
4. **Pre-condiciones inter-WP críticas** — restricciones→requisitos
   (Decision 7), estandares→requisitos (templates-inventory §3.4).
5. **F-04, F-05, F-NEW-1..7** — todos resueltos o asignados
   explícitamente en Traceability (líneas 868-916).

### Gaps detectados

#### G1 — ALTA · D-CNST-1..5 quedan huérfanas del plan

Las 5 sub-decisiones (restricciones-divergence §4.2: numeración,
huérfanas, v2.0.0 standalone, gap CNST_011, sub-categorías) no
aparecen en solution-strategy.md. Si el plan no las referencia
explícitamente, el WP-hijo `restricciones` puede abrir sin el
discover obligatorio (§4.1) y reinventar el análisis.
**Acción:** el plan debe listar las 5 D-CNST como decisiones
diferidas al WP-hijo, con link al análisis de soporte.

#### G2 — ALTA · F-NEW-2 (5 backups anidados de temp-holding) sin asignación clara

Discover §8 dice "Triage al inicio del primer WP de rebuild"
(= base_cognitiva), pero solution-strategy v2.0 nunca repite la
asignación. El WP base_cognitiva podría omitir el triage.
**Acción:** el plan debe asignar F-NEW-2 explícitamente al WP #1
base_cognitiva como pre-tarea.

#### G3 — ALTA · Criterio de cierre del WP-padre es ambiguo

Solution-strategy.md no define cuándo este WP-padre cierra. ¿Cuando
los 16 WPs-hijos cierran? ¿Cuando se aprueba el plan? El "Siguiente
Paso" (línea 965) sugiere que cierra al producir el plan, pero queda
implícito.
**Acción recomendada:** "WP-padre cierra al aprobarse
`plan/source-rebuild-strategy-plan.md`. Los 16 WPs-hijos son
artefactos externos referenciados, no entregables del padre."

#### G4 — MEDIA · Decision 8 (cada WP-hijo con ciclo THYROX propio) sin step operacional

Decision 8 dice "7 WPs hermanos con su propio
DISCOVER→...→TRACK" pero el conteo cambió a 16. Sin step en el
plan que liste el patrón de apertura de cada WP-hijo (template,
naming, parent-link), los 16 WPs pueden abrirse inconsistentemente.

#### G5 — MEDIA · Decision 11 (F-NEW-8 backend-django guideline) cruza WP boundaries

La acción vive en WP `bootstrap-hardening` (externo a los 16),
pero requisitos lo necesita antes de generar UCs DRF. El plan
necesita marcar esta dependencia cross-WP.

#### G6 — MEDIA · Decision 2 (cleanup de temp-backup) sin owner

Decision 2 dice "eliminación al cerrar el último WP de dominio
(CLEANUP)" pero no asigna a qué WP. ¿WP #15 risks-tech-debt?
¿WP #16 gestion? Ambiguo.

#### G7 — MEDIA · Idea 9 skeleton-first (3 archivos) sin contrato verificable

Decision 12 lista index/overview/conventions, pero no hay acceptance
criteria por WP-tech (qué entra en `overview.rst` de backend vs
frontend). Sin esto, los 8 WPs skeleton pueden producir 3 archivos
vacíos.

#### G8 — BAJA · "PROPUESTA_TEMPLATE_01..10.txt" como input obligatorio (templates §1.5) no escala al plan

Decision 6 menciona análisis previos pero no los 10 propuesta files.
Riesgo de omisión en WP estandares.

### Cross-WP handoffs críticos (para sección dependencies del plan)

1. **WP #2 estandares → WP #6 requisitos** — templates listos
   (templates-inventory §3.4, Decision 5).
2. **WP #4 restricciones → WP #6 requisitos** — CNSTs reconciliadas
   con tabla de mapeo viejo→nuevo (Decision 7, divergence §4.3).
3. **WP #1 base_cognitiva → todos** — vocabulario disponible
   (Decision 1).
4. **WP `bootstrap-hardening` (externo) → WP #8 backend** —
   backend-django.instructions activo (Decision 11).
5. **WP #7 arquitectura_tecnica → WP #8-11 tech** — architecture
   overview existe antes de skeleton-first cajones referencien
   decisiones.
6. **WP #15 (último tech) → cierre WP-padre** — cleanup temp-backup
   + verificar build con `-W` (Decision 3 implications).

### Riesgos a subir al plan principal (3 más críticos)

1. **CNST `requisitos` se rebuilda con CNSTs viejas** (divergence
   §5, riesgo 3) — bloqueante directo de WP #6.
2. **Pérdida de CNST huérfana** (divergence §5, riesgo 2) —
   silencioso, descubierto tarde.
3. **Versión de template obsoleta como canónica** (templates §5,
   riesgo 1) — propaga a todos los artefactos derivados.

Los demás 5 riesgos quedan en sus análisis (no son bloqueantes
inter-WP).

### Recomendaciones para `plan/source-rebuild-strategy-plan.md`

1. **Sección "Scope del WP-padre"** con criterio de cierre explícito
   (resuelve G3).
2. **Sección "16 WPs-hijos: naming, template, parent-link"**
   (resuelve G4).
3. **Sección "Decisiones diferidas a WPs-hijos"** listando
   D-CNST-1..5 + triage de templates + 7 variantes UC (resuelve G1, G8).
4. **Sección "Cross-WP dependencies"** con las 6 hard dependencies
   (G2, G5, G6).
5. **Sección "Acceptance criteria por tipo de WP"** — methodology /
   spec / tech-skeleton / lifecycle (resuelve G7).
6. **Sección "Riesgos del plan"** con los 3 críticos del bloque
   anterior.
7. **Sección "Pre-tareas asignadas"** — F-NEW-2 al WP #1, cleanup
   al WP #15, F-NEW-8 dependency-tracked al `bootstrap-hardening`.

**Recomendación final del agente:** iterar el plan incorporando
G1-G3 (alta) antes del gate Phase 6→7. G4-G7 (media) pueden
absorberse durante la redacción del plan sin re-abrir strategy.

---

## Cómo el plan absorbe estos hallazgos

| Gap | Sección del plan que lo resuelve |
|-----|-----------------------------------|
| G1 (D-CNST huérfanas) | "Decisiones diferidas a WPs-hijos" → "Diferidas a WP #4 normativa-restricciones" |
| G2 (F-NEW-2 sin asignación) | "Pre-tareas asignadas a WPs-hijos específicos" — fila WP #1 |
| G3 (cierre WP-padre ambiguo) | "Pre-condición de cierre del WP-padre" (sección dedicada) |
| G4 (apertura inconsistente de WPs) | "Los 16 WPs-hijos" tabla con naming/parent-link/dependencies |
| G5 (F-NEW-8 cross-WP) | "Cross-WP dependencies" → fila H4 |
| G6 (cleanup sin owner) | "Pre-tareas asignadas" — fila #15 risks-technical-debt |
| G7 (skeleton-first sin criterio) | "Acceptance criteria por tipo de WP-hijo" → bloque "Tech-skeleton WPs" |
| G8 (10 PROPUESTA_TEMPLATE) | "Decisiones diferidas a WPs-hijos" → "Diferidas a WP #2" (input obligatorio) |

Las 7 recomendaciones de secciones del agente están todas presentes
en el plan final.

---

## Nota metodológica — convención emergente

El ejecutor pidió guardar este output como artefacto separado para
preservar audit trail. Convención propuesta: outputs de agentes
invocados durante una fase se guardan en el directorio de la fase
con prefijo `{agent-name}-{descripcion}.md`. En este caso:
`plan/deep-review-strategy-to-plan.md`.

Esta convención no está formalizada en el SKILL todavía (gap
metodológico — registrar para futura mejora del framework).
