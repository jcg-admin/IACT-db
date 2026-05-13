```yml
created_at: 2026-04-26 02:25:00
updated_at: 2026-04-26 02:25:00
project: IACT
author: Claude
status: Aprobado
decision_type: Process / Quality Gate
severity: Critical
```

# ADR: Phase Completion Validation Protocol

## Problema

**Incidente:** Phase D PlantUML Implementation

El 2026-04-26 a las 02:15:00, tras completar el trabajo técnico de Phase D:
1. Se reportó exitosamente: "Phase D Complete ✅ — Build Status: SUCCESS"
2. Se afirmó que "All changes pushed to remote branch"
3. **REALIDAD:** 417 archivos (build artifacts + state files) NO estaban committed
4. El repositorio tenía cambios sin guardar cuando el usuario verificó
5. Error detectado por stop hook: "There are uncommitted changes in the repository"

**Impacto:** 
- Falsa sensación de completación
- Discrepancia entre reporte verbal y estado real del repo
- Usuario tuvo que verificar manualmente y detectar el error
- Confiabilidad del reporte de "completion" comprometida

**Root Cause Analysis:**
- No se ejecutó `git status` antes de reportar completación
- Asunción incorrecta: "build artifacts no necesitan commitment"
- Falta de checklist de validación antes de declare "complete"
- No se distinguió entre "trabajo técnico complete" y "entrega completa al repo"

---

## Solución

### Invariante de Completación (I-015)

**REGLA INVIOLABLE:** Un work package o phase NO se reporta como "complete" hasta que se cumplen AMBAS condiciones:

1. **Criterios Técnicos:** 
   - El trabajo especificado se ejecutó correctamente
   - Validaciones técnicas pasaron (build, tests, compilation, etc.)
   - Documentación técnica generada

2. **Criterios de Persistencia (Repository State):**
   - `git status` retorna "working tree clean"
   - Todos los cambios están committed
   - Todos los commits están pushed a remote
   - **Verificación explícita:** ejecutar `git status` antes de reportar "complete"

### Checklist de Completación

Antes de cualquier reporte que use la palabra **"complete", "done", "finished"** o similar, ejecutar:

```bash
# 1. Verificar estado del repositorio
git status  # DEBE retornar "working tree clean"

# 2. Verificar que no hay cambios sin push
git log --oneline -1  # Ver último commit
git log origin/$(git branch --show-current) -1  # Ver último commit remoto
# DEBEN ser el mismo SHA

# 3. Verificar que no hay cambios sin stage
git diff --stat  # DEBE estar vacío
git diff --cached --stat  # DEBE estar vacío

# 4. Ejecutar build si aplica
make html 2>&1 | tail -5  # Verificar "build succeeded"
```

**Resultado válido:**
```
On branch <rama>
Your branch is up to date with 'origin/<rama>'.

nothing to commit, working tree clean
```

### Protocolo de Reporte de Completación

**ANTES de reportar completación, ejecutar en este orden:**

1. Completar el trabajo técnico
2. Crear commits con mensajes convencionales
3. Ejecutar `git status` → verificar "working tree clean"
4. Ejecutar `git push`
5. Ejecutar `git status` nuevamente → verificar "up to date"
6. **Solo entonces:** reportar "complete"

**Template de reporte de completación:**

```markdown
## Phase X Complete ✅

**Status Verification:**
- Working tree: clean ✓
- Remote sync: up to date ✓  
- Commits: N pushed ✓
- Build: success (exit 0) ✓

[Resto del reporte...]
```

---

## Implementación

### Cambios en Workflow

| Fase | Cambio | Owner |
|------|--------|-------|
| Phase 10 EXECUTE | Agregar "git status verification" como último paso antes de reportar | Executor |
| Cualquier "complete" | Ejecutar checklist antes de cualquier reporte de completación | Executor |
| Phase 11 TRACK/EVALUATE | Validar que "completion reports" pasaron verificación de repo | Phase 11 skill |

### Herramiento: Pre-Completion Validator Script

Crear script `.claude/scripts/validate-phase-completion.sh`:

```bash
#!/bin/bash
# Validates that all work is committed and pushed before phase completion

echo "🔍 Validating phase completion requirements..."

# 1. Working tree clean
if ! git diff --quiet; then
  echo "❌ FAIL: Uncommitted changes in working tree"
  git diff --stat
  exit 1
fi

# 2. No staged changes
if ! git diff --cached --quiet; then
  echo "❌ FAIL: Uncommitted staged changes"
  git diff --cached --stat
  exit 1
fi

# 3. In sync with remote
CURRENT_BRANCH=$(git branch --show-current)
LOCAL_SHA=$(git rev-parse HEAD)
REMOTE_SHA=$(git rev-parse origin/$CURRENT_BRANCH)

if [ "$LOCAL_SHA" != "$REMOTE_SHA" ]; then
  echo "❌ FAIL: Local commits not pushed"
  echo "Local:  $LOCAL_SHA"
  echo "Remote: $REMOTE_SHA"
  exit 1
fi

# 4. Build success (if applicable)
if [ -f "Makefile" ] && grep -q "html:" Makefile; then
  if ! make html > /tmp/build.log 2>&1; then
    echo "❌ FAIL: Build did not succeed"
    tail -30 /tmp/build.log
    exit 1
  fi
fi

echo "✅ All completion requirements verified!"
echo "   - Working tree: clean"
echo "   - Commits: all pushed ($LOCAL_SHA)"
echo "   - Build: success (exit 0)"
exit 0
```

**Uso:**
```bash
bash .claude/scripts/validate-phase-completion.sh
# Retorna exit 0 si todo está bien
# Retorna exit 1 y bloquea el reporte de completación si hay problemas
```

### Integración en Claude Workflow

Agregar a CLAUDE.md, sección "Reglas de edición — OBLIGATORIO":

```markdown
## Protocolo de Completación de Fases (I-015)

Antes de reportar que un phase/WP está "complete":

1. Ejecutar: `bash .claude/scripts/validate-phase-completion.sh`
2. Verificar salida: exit code 0
3. **Luego sí** reportar completación
4. **NUNCA** reportar completación con cambios uncommitted

Violación: 
- Reportar "complete" sin esta validación = error crítico de comunicación
- Requiere corrección inmediata + documentación del error
```

---

## Procedimiento de Recuperación (Si ocurre de nuevo)

Si se detecta que se reportó completación pero hay cambios uncommitted:

1. **Inmediato:**
   - Ejecutar `git status` y documentar la discrepancia
   - NO avanzar a siguiente phase hasta resolver

2. **Correción:**
   - Hacer commit de cambios pendientes
   - Push a remote
   - Verificar `git status` nuevamente

3. **Reporte Revisado:**
   - Reportar "Completación REVALIDADA" con nueva verificación
   - Incluir timestamp de corrección

4. **Post-Mortem:**
   - Documentar en el phase cómo se cometió el error
   - Agregar checklist item a futuro trabajo

---

## Lecciones de Phase D

**Qué se hizo mal:**
- Se reportó completación basado en salida de terminal ("build succeeded")
- No se ejecutó `git status` antes de reportar
- Se asumió que "push" anterior había funcionado sin verificación
- Confusión entre "trabajo técnico completo" y "entrega al repositorio completa"

**Qué debe cambiar:**
- SIEMPRE ejecutar `git status` como paso final
- NUNCA reportar completación sin verificación de repo state
- Usar checklist explícito, no confiar en memoria/asunción

**Impacto:**
- Previene reportes falsos de completación
- Garantiza que cada reporte es verificable
- Mejora confiabilidad del tracking de work packages

---

## Sign-Off

**Decision:** APROBADA

Esta decisión es **INVIOLABLE** para future phases. Violaciones requieren escalación y documentación explícita.

**Aplicable a:** Todos los WPs, todas las fases, todos los reportes de completación.

**Fecha Efectiva:** 2026-04-26 (Inmediato)

**Monitoreo:** Los primeros 3 WPs posteriores verificarán estrictamente esta ADR en cada phase gate.

