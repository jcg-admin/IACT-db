# THYROX Core Invariants

> Reglas que NUNCA cambian. Cargadas automáticamente en cada sesión.
> Estas son decisiones bloqueadas — no re-discutir, no omitir.

## I-001: DISCOVER antes de planificar

NUNCA crear un plan sin haber completado Phase 1 DISCOVER.
El work package debe existir antes de cualquier artefacto de planificación.

```
INCORRECTO: Empezar con task-plan.md sin discover/*-analysis.md
CORRECTO:   discover/*-analysis.md → strategy → plan → task-plan.md
```

## I-002: Git como única persistencia

CERO archivos backup. CERO copias `.bak`, `.old`, `-v2`, etc.
El historial de git es la única fuente de verdad para versiones anteriores.

```
PROHIBIDO: archivo.md.bak, archivo-old.md, archivo_v2.md
CORRECTO:  git history para versiones anteriores
```

## I-003: Markdown únicamente

Sin bases de datos, sin formatos propietarios, sin JSON/YAML como artefactos de trabajo.
Los artefactos del WP son siempre `.md`.

## I-004: Work packages con timestamp real

El timestamp del WP viene siempre del sistema: `date +%Y-%m-%d-%H-%M-%S`
NUNCA inventado, estimado, ni copiado de otro WP.

```
CORRECTO: 2026-04-15-08-29-58-plugin-distribution/
PROHIBIDO: 2026-04-15-00-00-00-plugin-distribution/ (timestamp inventado)
```

## I-005: Conventional Commits obligatorio

Formato: `type(scope): description`

Tipos: `feat` `fix` `refactor` `docs` `chore` `test` `perf`
Scope: nombre del WP o componente afectado

```
CORRECTO:  feat(plugin-distribution): add workflow-measure skill
PROHIBIDO: "added measure skill" / "update" / "WIP"
```

## I-006: 12 fases THYROX — no SDLC

Las fases de THYROX son propias del framework, NO son SDLC.
SDLC (Planning→Maintenance) es una metodología separada documentada en analyze/sdlc/.

Fases THYROX: DISCOVER → MEASURE → ANALYZE → CONSTRAINTS → STRATEGY →
              PLAN → DESIGN/SPECIFY → PLAN EXECUTION → PILOT/VALIDATE →
              EXECUTE → TRACK/EVALUATE → STANDARDIZE

## I-007: allowed-tools en cada skill

Todo SKILL.md de workflow debe tener `allowed-tools` explícito.
Mínimo: `Read Glob Grep Bash`
NUNCA omitir — es requerido para la quality gate (2pts de 14).

## I-008: description con "Use when..."

La descripción de todo SKILL.md debe seguir el patrón trigger:
`"Use when [condición]. Phase N NOMBRE — [qué hace]"`

Auto-invocación tiene 56% éxito rate sin este patrón → NO confiable.

## I-009: .claude/rules/ carga SIEMPRE (no lazy)

A diferencia de skills (lazy-load), los archivos en `.claude/rules/` cargan
incondicionalmente en cada sesión. Usarlos SOLO para reglas críticas globales.
Reglas por contexto: usar `globs:` en el frontmatter (NO `paths:` — está roto).

## I-010: Metadata estándar para documentos WP

```yml
created_at: YYYY-MM-DD HH:MM:SS
project: [Nombre del proyecto]
work_package: YYYY-MM-DD-HH-MM-SS-nombre
phase: Phase N — PHASE_NAME
author: [Nombre]
status: Borrador | En revisión | Aprobado
```

Usar bloques \`\`\`yml \`\`\` — NUNCA `---` YAML frontmatter en artefactos WP.

## I-011: Un WP solo se cierra cuando el ejecutor lo ordena explícitamente

NUNCA cerrar un work package por inferencia — ni por tareas completadas al 100%,
ni por "Próximo: Stage 11", ni por resumen de sesión anterior.

```
PROHIBIDO: cerrar WP porque task-plan tiene todas las tareas [x]
PROHIBIDO: cerrar WP porque now.md dice "Próximo: Stage 11 TRACK"
CORRECTO:  esperar instrucción explícita del ejecutor: "cierra el WP" / "ejecuta Stage 11"
```

Un WP puede contener múltiples iniciativas y ángulos de trabajo. El ejecutor
es el único que sabe cuándo el WP está realmente completo.

## I-012: Claims SPECULATIVE no avanzan gates

Un claim clasificado como SPECULATIVE (sin observable de origen en evidence-classification.md)
no puede ser fundamento de una decisión de Stage gate. Si el gate requiere claim OBSERVABLE
o INFERRED, el WP permanece en el stage actual hasta que el claim se respalde o se descarte.

```
PROHIBIDO: gate aprobado basado en "se espera que..." sin observable de origen
CORRECTO:  gate bloqueado hasta obtener claim OBSERVABLE o INFERRED explícito
```

Valores y claims de fuentes con contradicción interna demostrada tampoco son propagables.
Ver `prohibited-claims-registry.md` para lista. Ver `evidence-classification.md` para protocolo.

## I-013: Context pruning en gates Stage→Stage

Al avanzar de Stage N a Stage N+1, los claims con Confianza=baja y Origen=heredado
de stages anteriores deben ser explícitamente descartados o re-verificados.
No propagarlos implícitamente al siguiente stage sin marcarlos como "pendiente de re-verificación".

```
PROHIBIDO: propagar claims heredados sin re-verificar al siguiente stage
CORRECTO:  marcar claims heredados con "pendiente:re-verificar" o descartarlos explícitamente
```

## I-014: Framework mismatch en insumos externos

Cuando un documento analizado contiene fases numeradas (FASE N, Phase N, Stage N),
NO interpretar esas fases como stages del WP activo en THYROX.
Registrar como hallazgo de Stage 1 DISCOVER con nota: "FASE N en documento externo ≠ Stage N del WP".

```
PROHIBIDO: saltar Stage 4 porque el documento externo analizado menciona "FASE 4 completada"
CORRECTO:  nota en discover/-analysis.md: "el documento usa FASE 4 con semántica propia, no aplica al WP"
```

<!-- I-016 RELOCALIZADO. Era una regla de uso de Bash con run_in_background
     (aplicable a <5% de las sesiones). Movido a:
     .claude/skills/thyrox/references/bash-background-tasks.md
     Ver decision en:
     .thyrox/context/work/2026-04-29-05-51-27-methodology-recalibration/
     plan/correction-plan.md (accion A1).
     Razon: .claude/rules/ carga siempre (I-009); regla de tool especifico
     no merece costo permanente de context budget. -->

