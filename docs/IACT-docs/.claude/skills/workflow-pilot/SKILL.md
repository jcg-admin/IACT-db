---
name: workflow-pilot
description: "Use when you need to validate a solution with a PoC before full execution. Phase 9 PILOT/VALIDATE — confirma supuestos técnicos críticos con implementación mínima."
allowed-tools: Read Glob Grep Bash Write Edit
disable-model-invocation: true
effort: high
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "bash .claude/scripts/set-session-phase.sh 'Phase 9'"
updated_at: 2026-04-16 00:00:00
---

# /workflow-pilot — Phase 9: PILOT/VALIDATE

Inicia o retoma Phase 9 PILOT/VALIDATE del work package activo.

---

## Contexto de sesión

1. Identificar WP activo: `ls -t .thyrox/context/work/ | head -1`
2. Leer task-plan: `cat .thyrox/context/work/[WP]/plan-execution/*-task-plan.md`
3. Leer `context/now.md` — verificar `phase`
4. Identificar supuestos críticos no validados del task-plan
5. Verificar si ya existe `work/.../pilot/`:
   - Si existe con validación documentada → Phase 9 ya completó. Proponer `/thyrox:execute`.

---

## Cuándo usar Phase 9

Phase 9 es **opcional pero recomendada** cuando:
- Hay supuestos técnicos no probados en el task-plan
- La implementación involucra tecnologías nuevas o patrones no probados
- El riesgo de fallar en Phase 10 sería alto (ej. cambios de schema destructivos)
- La arquitectura propuesta nunca fue implementada en este proyecto
- Hay incertidumbre sobre la viabilidad técnica de la solución

**Omitir Phase 9** cuando:
- La solución usa tecnologías y patrones ya probados en el proyecto
- Los riesgos técnicos son bajos o inexistentes
- El WP es micro o pequeño con alta certeza de implementación

---

## Fase a ejecutar: Phase 9 PILOT/VALIDATE

Un PoC falla rápido y barato. Una ejecución completa falla lento y caro.

### Scope del PoC

El piloto NO es una implementación completa. Es la implementación MÍNIMA que:
1. Valida el supuesto más riesgoso
2. Demuestra que la arquitectura funciona end-to-end
3. Identifica blockers antes de la ejecución completa

**Típicamente 10-20% de la implementación total.**

### Proceso

1. **Identificar supuestos críticos**: del task-plan, ¿qué podría hacer fallar la implementación?
2. **Diseñar el mínimo experimento**: ¿cuál es la versión más pequeña que valida esto?
3. **Implementar PoC**: código de prueba (puede ser descartable)
4. **Validar resultado**: ¿el supuesto se cumple? ¿la arquitectura funciona?
5. **Documentar hallazgos**: ¿qué ajustar en el task-plan antes de ejecutar?

### Artefactos

REQUERIDO: `work/.../pilot/{nombre-wp}-pilot-report.md`

```yml
created_at: YYYY-MM-DD HH:MM:SS
project: [Nombre del proyecto]
work_package: YYYY-MM-DD-HH-MM-SS-nombre
phase: Phase 9 — PILOT/VALIDATE
author: [Nombre]
status: Borrador
```

Contenido:
- **Supuestos validados**: lista con resultado (VÁLIDO / INVÁLIDO / PARCIAL)
- **Hallazgos técnicos**: qué se aprendió durante el PoC
- **Ajustes al task-plan**: qué T-NNN necesitan modificarse antes de ejecutar
- **Blockers identificados**: problemas que deben resolverse antes de Phase 10
- **Decisión**: GO (proceder a Execute) / NO-GO (requiere revisión de estrategia)

---

## Validaciones pre-gate

Antes de presentar el gate 9→10:
- Todos los supuestos críticos validados (o decisión GO documentada a pesar de incertidumbre)
- Ajustes al task-plan documentados
- Decisión GO/NO-GO documentada con justificación

## Gate humano

⏸ STOP — Presentar resultado del piloto (supuestos validados, hallazgos, decisión GO/NO-GO).
Esperar confirmación explícita. NO continuar sin respuesta.
Al aprobar:
1. Actualizar `context/now.md::phase` a `Phase 10`
2. Si hay ajustes al task-plan: actualizar `*-task-plan.md` con los cambios

---

## Exit criteria

Phase 9 completa cuando:
- `work/.../pilot/{nombre-wp}-pilot-report.md` existe con decisión documentada
- Todos los supuestos críticos evaluados
- Task-plan ajustado si fue necesario
- Usuario confirmó la decisión GO/NO-GO en esta sesión

**Detectar:** Si `work/.../pilot/` tiene pilot-report con decisión, Phase 9 ya completó.
Al terminar: proponer `/thyrox:execute` para Phase 10.
