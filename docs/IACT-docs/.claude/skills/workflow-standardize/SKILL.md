---
name: workflow-standardize
description: "Use when closing a work package and propagating learnings to the system. Phase 12 STANDARDIZE — documenta patrones reutilizables y actualiza guidelines del proyecto."
allowed-tools: Read Glob Grep Bash Write Edit
disable-model-invocation: true
effort: medium
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "bash .claude/scripts/set-session-phase.sh 'Phase 12'"
updated_at: 2026-04-20 13:43:15
---

# /workflow-standardize — Phase 12: STANDARDIZE

Inicia o retoma Phase 12 STANDARDIZE del work package activo.

---

## Contexto de sesión

1. Identificar WP activo: `ls -t .thyrox/context/work/ | head -1`
2. Leer lecciones aprendidas: `cat .thyrox/context/work/[WP]/track/*-lessons-learned.md`
3. Verificar changelog: `cat .thyrox/context/work/[WP]/track/*-changelog.md`
4. Leer `context/now.md` — verificar `phase`
5. Revisar: `bash .claude/scripts/project-status.sh`

---

## Fase a ejecutar: Phase 12 STANDARDIZE

Sin standardize, cada WP aprende de forma aislada. Con standardize, el proyecto mejora estructuralmente.

**En ejecución paralela:** Phase 12 es single-agent por diseño. El coordinador propaga
patrones al sistema y actualiza guidelines como único escritor.

### Qué standardizar

1. **Patrones técnicos reutilizables** — identificar en las lecciones aprendidas
   - Código que se puede extraer a utilidad compartida
   - Configuraciones que deberían ser el default
   - Patrones de testing que aplican a módulos similares

2. **Actualizaciones a guidelines** — en `.thyrox/guidelines/`
   - Nuevas convenciones descubiertas durante el WP
   - Correcciones a guías existentes
   - Patrones anti-pattern documentados

3. **Actualizaciones a skills** — si el WP modificó procesos
   - ¿Cambió cómo se hace DISCOVER? → actualizar workflow-discover/SKILL.md
   - ¿Nuevo tipo de análisis? → agregar a workflow-analyze/SKILL.md (Phase 3) o workflow-discover/SKILL.md (Phase 1)
   - ¿Nueva plantilla de artefacto? → agregar a assets/
   - Si el WP descubrió anti-patrones de código agentic → actualizar `.thyrox/guidelines/agentic-python.instructions.md`
     con las nuevas reglas y `.claude/agents/agentic-validator.md` con los nuevos APs.
   - Al registrar correcciones aplicadas durante el WP, usar la taxonomía de fix:
     - `fix-completo` — el comportamiento del código cambió (lógica, retorno, flujo de control)
     - `fix-parcial(documentación)` — solo cambió descripción/comentario/docstring, el código no
     - `fix-pendiente` — el problema fue identificado pero no corregido en este WP

4. **Actualizaciones a ADRs** — si hay decisiones arquitectónicas permanentes
   - Crear ADR en `.thyrox/context/decisions/`
   - Registrar la decisión con justificación

5. **Actualización de ROADMAP.md** — marcar WP como completado, linkear próximos

### Artefactos

REQUERIDO: `work/.../standardize/{nombre-wp}-patterns.md`

```yml
created_at: YYYY-MM-DD HH:MM:SS
project: [Nombre del proyecto]
work_package: YYYY-MM-DD-HH-MM-SS-nombre
phase: Phase 12 — STANDARDIZE
author: [Nombre]
status: Borrador
```

Contenido:
- **Patrones adoptados**: lista de patrones que se propagan al sistema
- **Updates a guidelines**: qué archivos se modificaron y por qué
- **Updates a skills**: qué skills se actualizaron
- **ADRs creados**: lista de nuevas decisiones arquitectónicas permanentes
- **Próximos WPs sugeridos**: qué trabajo deriva de este WP

### Cierre del WP

**REQUERIDO al cerrar WP — actualizar archivos de estado:**

| Archivo | Acción |
|---------|--------|
| `context/now.md` | Ejecutar: `bash .claude/scripts/close-wp.sh` |
| `context/focus.md` | Actualizar: completado + sin WP activo |
| `context/project-state.md` | Ejecutar: `bash .claude/scripts/update-state.sh` |

```bash
bash .claude/scripts/validate-session-close.sh
bash .claude/scripts/project-status.sh
```

---

## Validaciones pre-cierre

Antes de marcar Phase 12 completa:
- Patrones identificados y documentados (aunque la lista esté vacía)
- Guidelines actualizadas si corresponde
- Skills actualizados si corresponde
- ADRs creados si corresponde
- ROADMAP.md actualizado
- `validate-session-close.sh` pasa sin errores

## Gate humano

⏸ STOP — Presentar lista de patrones y actualizaciones al sistema.
Esperar confirmación explícita. NO continuar sin respuesta.
Al aprobar:
1. Ejecutar cierre de WP
2. Actualizar archivos de estado
3. Commit final con tipo `chore(standardize): cierre FASE N`

---

## Exit criteria

Phase 12 completa cuando:
- `work/.../standardize/{nombre-wp}-patterns.md` existe
- Guidelines/skills/ADRs actualizados si corresponde
- `validate-session-close.sh` pasa
- Archivos de estado actualizados: `now.md`, `focus.md`, `project-state.md`
- No quedaron archivos temporales fuera de `context/work/`

**La FASE cierra cuando Phase 12 STANDARDIZE completa** — `now.md::phase` → `null`, `now.md::current_work` → `null`.
