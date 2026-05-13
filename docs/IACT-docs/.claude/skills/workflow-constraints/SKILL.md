---
name: workflow-constraints
description: "Use when you need to document technical, business or platform constraints before designing a solution. Phase 4 CONSTRAINTS — documenta restricciones que delimitan el espacio de soluciones."
allowed-tools: Read Glob Grep Bash
disable-model-invocation: true
effort: medium
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "bash .claude/scripts/set-session-phase.sh 'Phase 4'"
updated_at: 2026-04-16 00:00:00
---

# /workflow-constraints — Phase 4: CONSTRAINTS

Inicia o retoma Phase 4 CONSTRAINTS del work package activo.

---

## Contexto de sesión

1. Identificar WP activo: `ls -t .thyrox/context/work/ | head -1`
2. Leer síntesis DISCOVER y ANALYZE: `cat .thyrox/context/work/[WP]/discover/*-analysis.md`
3. Revisar análisis existente: `ls .thyrox/context/work/[WP]/analyze/ 2>/dev/null`
4. Leer `context/now.md` — verificar `phase`
5. Verificar si ya existe `work/.../constraints/`:
   - Si existe con restricciones documentadas → Phase 4 ya completó. Proponer `/thyrox:strategy`.

---

## Fase a ejecutar: Phase 4 CONSTRAINTS

Documentar restricciones antes de diseñar la estrategia evita propuestas inviables.

### Tipos de restricciones

**Técnicas:**
- Stack tecnológico requerido/prohibido
- Versiones mínimas de dependencias
- Compatibilidad requerida (browsers, OS, DBs)
- Límites de performance (latencia máx, memoria máx)
- APIs o protocolos obligatorios

**De plataforma Claude Code:**
- Context window: 200k tokens con lazy-load de skills
- Skill budget Level 1: ~250 chars/skill, ~8.7k total con MCP Tool Search
- `paths:` en SKILL.md está roto — usar `globs:` como workaround
- `skills:` en agentes inyecta full content (no lazy)
- Auto-invocación: 56% success rate — no confiable para instrucciones críticas

**De negocio:**
- Fechas límite / plazos
- Presupuesto / recursos disponibles
- Aprobaciones requeridas antes de implementar
- Regulaciones o compliance aplicables

**De arquitectura (ADRs existentes):**
- Decisiones arquitectónicas previas que no se pueden revertir
- Patrones establecidos en el proyecto
- Restricciones de `constitution.md` si existe

**De datos:**
- Datos que no pueden migrarse / modificarse
- Backward compatibility requerida
- Contratos de API con sistemas externos

### Artefactos

REQUERIDO: `work/.../constraints/{nombre-wp}-constraints.md`

Usar template `assets/constraints.md.template` si existe.

```yml
created_at: YYYY-MM-DD HH:MM:SS
project: [Nombre del proyecto]
work_package: YYYY-MM-DD-HH-MM-SS-nombre
phase: Phase 4 — CONSTRAINTS
author: [Nombre]
status: Borrador
```

Estructura del documento:
- **Restricciones técnicas**: lista con impacto en cada una
- **Restricciones de negocio**: lista con nivel (HARD/SOFT)
- **Restricciones de plataforma**: lista con workarounds conocidos
- **Restricciones arquitectónicas**: ADRs aplicables
- **Espacio de soluciones permitido**: qué ESTÁ permitido (delimitar positivamente)

---

## Validaciones pre-gate

Antes de presentar el gate 4→5:
- Todas las categorías de restricciones revisadas (incluso si la lista está vacía)
- Restricciones HARD separadas de SOFT
- Espacio de soluciones delimitado positivamente
- ADRs existentes revisados

## Gate humano

⏸ STOP — Presentar lista de restricciones por categoría y el espacio de soluciones permitido.
Esperar confirmación explícita. NO continuar sin respuesta.
Al aprobar: actualizar `context/now.md::phase` a `Phase 5`.

---

## Exit criteria

Phase 4 completa cuando:
- `work/.../constraints/{nombre-wp}-constraints.md` existe
- Restricciones HARD claramente identificadas
- Espacio de soluciones documentado
- Usuario confirmó las restricciones en esta sesión

**Detectar:** Si `work/.../constraints/` tiene contenido, Phase 4 ya comenzó.
Al terminar: proponer `/thyrox:strategy` para Phase 5.
