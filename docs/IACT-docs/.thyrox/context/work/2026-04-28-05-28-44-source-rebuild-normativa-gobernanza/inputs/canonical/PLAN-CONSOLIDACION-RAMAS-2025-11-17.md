---
id: QA-PLAN-CONSOLIDACION-RAMAS-001
tipo: plan_accion
categoria: control_version
titulo: Plan de Consolidacion de Ramas Git - Proyecto IACT
fecha: 2025-11-17
hora: 21:57:38
version: 1.0.0
basado_en: QA-ANALISIS-RAMAS-001
rama_objetivo: claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2
estado: pendiente
horizonte_temporal: 1_semana
esfuerzo_total_horas: 2.5
---

# QA-PLAN-CONSOLIDACION-RAMAS-001: Plan de Consolidacion de Ramas Git

**ID:** QA-PLAN-CONSOLIDACION-RAMAS-001
**Fecha:** 2025-11-17 21:57:38
**Basado en:** QA-ANALISIS-RAMAS-001
**Rama Objetivo:** claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2
**Responsable:** Equipo de Desarrollo

---

## SECCION 1: RESUMEN EJECUTIVO

### Objetivo
Consolidar la rama `claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2` como la rama mas actualizada del proyecto mediante la integracion sistematica de 10 ramas con cambios unicos y la eliminacion de 7 ramas completamente integradas.

### Justificacion
Segun el analisis QA-ANALISIS-RAMAS-001:
- 17 ramas analizadas (excluyendo main y docs)
- 41% completamente integradas (listas para eliminacion)
- 59% con cambios unicos valiosos
- 5,500 lineas de codigo/documentacion pendientes de integracion

### Beneficios Esperados
1. Rama unica consolidada con todo el trabajo reciente
2. Reduccion de 70% en numero de ramas activas (de 17 a 5)
3. Sistema MCP registry funcional integrado
4. Documentacion de validaciones API completa
5. Estructura de proyecto mas limpia y mantenible

### Metricas de Exito
- Integracion exitosa de 6 archivos MCP (scripts/coding/ai/mcp/)
- Integracion de 6 archivos de validacion API
- Eliminacion de 12 ramas redundantes
- 0 conflictos sin resolver
- Todos los tests existentes pasando

---

## SECCION 2: FASES DEL PLAN

### FASE 1: PREPARACION (15 minutos)

#### Tarea 1.1: Crear Backup de Seguridad
**Prioridad:** CRITICA
**Duracion:** 5 min
**Responsable:** Desarrollador asignado

**Acciones:**
```bash
# Crear tag de backup antes de cualquier integracion
git tag -a backup-pre-consolidacion-2025-11-17 -m "Backup antes de consolidacion de ramas"
git push origin backup-pre-consolidacion-2025-11-17

# Verificar tag creado
git tag -l "backup-*"
```

**Criterio de Exito:**
- Tag creado localmente
- Tag pusheado al remoto
- Confirmacion visible en git tag -l

#### Tarea 1.2: Verificar Estado Limpio
**Prioridad:** CRITICA
**Duracion:** 5 min
**Responsable:** Desarrollador asignado

**Acciones:**
```bash
# Asegurar que rama objetivo esta limpia
git checkout claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2
git status

# Asegurar que esta actualizada
git fetch origin
git pull origin claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2
```

**Criterio de Exito:**
- git status muestra "working tree clean"
- Rama local sincronizada con remoto
- No hay cambios sin commit

#### Tarea 1.3: Validar Rama Base
**Prioridad:** ALTA
**Duracion:** 5 min
**Responsable:** Desarrollador asignado

**Acciones:**
```bash
# Verificar ultimo commit
git log -1 --oneline

# Verificar que tests pasan (si aplica)
# pytest tests/ || npm test || make test
```

**Criterio de Exito:**
- Ultimo commit es el esperado
- Tests base pasando (si aplica)

---

### FASE 2: INTEGRACION CRITICA - MCP REGISTRY (30 minutos)

#### Tarea 2.1: Integrar MCP Registry Completo
**Prioridad:** P1 - CRITICA
**Duracion:** 20 min
**Responsable:** Desarrollador asignado
**Rama origen:** origin/copilot/sub-pr-216-again

**Justificacion:**
Version mas completa del MCP registry (735 lineas) que incluye:
- Implementacion base del registry
- Memory stack completo
- Tests de casos borde (edge cases)
- Modernizacion de type annotations

**Acciones:**
```bash
# Integrar rama completa
git checkout claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2
git merge origin/copilot/sub-pr-216-again --no-ff -m "feat(mcp): integrate complete MCP registry with edge case tests

Integracion de sistema MCP registry completo:
- scripts/coding/ai/mcp/__init__.py
- scripts/coding/ai/mcp/memory.py
- scripts/coding/ai/mcp/registry.py
- scripts/coding/tests/ai/mcp/__init__.py
- scripts/coding/tests/ai/mcp/test_memory.py
- scripts/coding/tests/ai/mcp/test_registry.py

Total: 735 lineas (6 archivos nuevos)
Base: origin/copilot/sub-pr-216-again
"
```

**Verificacion Post-Integracion:**
```bash
# Verificar archivos creados
ls -la scripts/coding/ai/mcp/
ls -la scripts/coding/tests/ai/mcp/

# Verificar imports (si Python esta disponible)
# python -c "from scripts.coding.ai.mcp import registry, memory"

# Ejecutar tests MCP (si pytest disponible)
# pytest scripts/coding/tests/ai/mcp/ -v
```

**Criterios de Exito:**
- 6 archivos nuevos en sus ubicaciones correctas
- No hay conflictos de merge
- Imports funcionales (si Python disponible)
- Tests MCP pasan (si pytest disponible)

**Riesgos:**
- BAJO - Archivos nuevos, sin conflictos esperados

**Rollback:**
```bash
# Si falla, revertir merge
git merge --abort  # Si merge en progreso
git reset --hard backup-pre-consolidacion-2025-11-17  # Si merge completado
```

#### Tarea 2.2: Validar Estructura MCP
**Prioridad:** P1
**Duracion:** 10 min
**Responsable:** Desarrollador asignado

**Acciones:**
```bash
# Verificar estructura de directorios
tree scripts/coding/ai/mcp/ scripts/coding/tests/ai/mcp/

# Verificar contenido de __init__.py
cat scripts/coding/ai/mcp/__init__.py
cat scripts/coding/tests/ai/mcp/__init__.py

# Contar lineas integradas
wc -l scripts/coding/ai/mcp/*.py scripts/coding/tests/ai/mcp/*.py
```

**Criterios de Exito:**
- Estructura de paquetes Python correcta
- __init__.py presentes y no vacios
- Total lineas cercano a 735

---

### FASE 3: INTEGRACION SECUNDARIA - VALIDACIONES Y AGENTES (45 minutos)

#### Tarea 3.1: Integrar Validaciones API Callcentersite
**Prioridad:** P2 - ALTA
**Duracion:** 25 min
**Responsable:** Desarrollador asignado
**Rama origen:** origin/copilot/validate-api-callcenter-site

**Justificacion:**
Documentacion exhaustiva de validacion API callcentersite (1,962 lineas):
- Analisis completo de URLs
- Guia de correcciones menores
- Indices de validacion
- Resumen ejecutivo en espanol

**Acciones:**
```bash
# Integrar validaciones
git merge origin/copilot/validate-api-callcenter-site --no-ff -m "docs(backend): add comprehensive API callcentersite validation reports

Documentacion de validacion API callcentersite:
- ANALISIS_URLS_COMPLETO.md
- CORRECCIONES_MENORES.md
- INDICE_VALIDACION.md
- RESUMEN_VALIDACION.md
- VALIDACION_API_CALLCENTERSITE.md
- VALIDACION_RAPIDA.md

Total: 1,962 lineas (6 archivos)
"

# Reubicar archivos a estructura correcta
mkdir -p docs/backend/validaciones
git mv ANALISIS_URLS_COMPLETO.md docs/backend/validaciones/
git mv CORRECCIONES_MENORES.md docs/backend/validaciones/
git mv INDICE_VALIDACION.md docs/backend/validaciones/
git mv RESUMEN_VALIDACION.md docs/backend/validaciones/
git mv VALIDACION_API_CALLCENTERSITE.md docs/backend/validaciones/
git mv VALIDACION_RAPIDA.md docs/backend/validaciones/

git commit -m "refactor(docs): reubicar validaciones API a docs/backend/validaciones/"
```

**Criterios de Exito:**
- 6 archivos en docs/backend/validaciones/
- No archivos huerfanos en raiz del proyecto
- Commit separado para reubicacion

**Riesgos:**
- BAJO - Archivos de documentacion, sin codigo ejecutable

#### Tarea 3.2: Comparar e Integrar Agentes Copilot
**Prioridad:** P2 - ALTA
**Duracion:** 20 min
**Responsable:** Desarrollador asignado
**Rama origen:** origin/feature/analyze-agents-in-/github-folder-18-45-40

**Justificacion:**
Exposicion completa de definiciones de agentes Copilot (255 lineas):
- .github/copilot/agents.json (modificado)
- .agent/execplans/EXECPLAN_expand_copilot_agents.md (nuevo)

**Acciones:**
```bash
# PASO 1: Comparar versiones de agents.json
git diff HEAD:.github/copilot/agents.json origin/feature/analyze-agents-in-/github-folder-18-45-40:.github/copilot/agents.json > /tmp/agents_diff.txt

# PASO 2: Revisar diferencias manualmente
cat /tmp/agents_diff.txt

# PASO 3: Decidir estrategia de integracion
# Opcion A: Si version rama es mas completa
git checkout origin/feature/analyze-agents-in-/github-folder-18-45-40 -- .github/copilot/agents.json
git checkout origin/feature/analyze-agents-in-/github-folder-18-45-40 -- .agent/execplans/EXECPLAN_expand_copilot_agents.md
git commit -m "feat(copilot): integrar definiciones completas de agentes

Cambios:
- Actualizar .github/copilot/agents.json con todas las definiciones
- Agregar .agent/execplans/EXECPLAN_expand_copilot_agents.md

Total: 255 lineas
"

# Opcion B: Si version actual es mas completa
# Solo integrar el plan de ejecucion
git checkout origin/feature/analyze-agents-in-/github-folder-18-45-40 -- .agent/execplans/EXECPLAN_expand_copilot_agents.md
git commit -m "docs(copilot): agregar plan de ejecucion de expansion de agentes"
```

**Criterios de Exito:**
- Archivo agents.json mas completo integrado
- Plan de ejecucion agregado
- No regresion en definiciones existentes

**Riesgos:**
- MEDIO - Posible conflicto en agents.json
- Mitigacion: Comparar manualmente antes de integrar

---

### FASE 4: INTEGRACION MENOR - DOCUMENTACION (20 minutos)

#### Tarea 4.1: Integrar Mejoras DevContainer
**Prioridad:** P3 - MEDIA
**Duracion:** 10 min
**Responsable:** Desarrollador asignado
**Rama origen:** origin/feature/create-improvement-plan-for-.devcontainer-06-21-46

**Justificacion:**
Aclaraciones sobre compatibilidad Linux y Vagrant (cambio reciente del 2025-11-17)

**Acciones:**
```bash
# Integrar solo el archivo especifico
git checkout origin/feature/create-improvement-plan-for-.devcontainer-06-21-46 -- docs/infraestructura/devcontainer/README.md
git commit -m "docs(devcontainer): aclarar compatibilidad linux y vagrant

Mejoras en documentacion devcontainer:
- Aclaracion de compatibilidad con Linux
- Notas sobre integracion con Vagrant

Archivo: docs/infraestructura/devcontainer/README.md (+6 lineas)
"
```

**Criterios de Exito:**
- README actualizado con aclaraciones
- No perdida de contenido existente

**Riesgos:**
- BAJO - Solo documentacion

#### Tarea 4.2: Integrar Reporte de Integracion
**Prioridad:** P3 - MEDIA
**Duracion:** 10 min
**Responsable:** Desarrollador asignado
**Rama origen:** origin/claude/integration-analysis-011CV5YLxdEnu9YN3qpzGV2R

**Justificacion:**
Reporte de analisis de integracion de reorganizacion de docs (387 lineas)

**Acciones:**
```bash
# Integrar reporte
git checkout origin/claude/integration-analysis-011CV5YLxdEnu9YN3qpzGV2R -- INTEGRATION_ANALYSIS_REPORT.md

# Reubicar a carpeta QA
git mv INTEGRATION_ANALYSIS_REPORT.md docs/gobernanza/qa/

git commit -m "docs(qa): agregar reporte de analisis de integracion docs

Reporte de analisis de integracion de reorganizacion documentacion.

Archivo: docs/gobernanza/qa/INTEGRATION_ANALYSIS_REPORT.md (387 lineas)
"
```

**Criterios de Exito:**
- Reporte en docs/gobernanza/qa/
- No archivo huerfano en raiz

**Riesgos:**
- BAJO - Solo documentacion

---

### FASE 5: LIMPIEZA DE RAMAS (20 minutos)

#### Tarea 5.1: Eliminar Ramas Completamente Integradas
**Prioridad:** P4 - BAJA
**Duracion:** 15 min
**Responsable:** Desarrollador asignado

**Ramas a Eliminar (7 ramas remotas + 1 local):**

**Ramas Remotas:**
1. origin/claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R
2. origin/feature/analyze-agents-15-11-25-18-42
3. origin/feature/consolidate-rev-analysis-into-document-15-42-34
4. origin/copilot/investigate-api-issues
5. origin/copilot/sub-pr-203
6. origin/copilot/sub-pr-216 (subsumida por sub-pr-216-again)
7. origin/copilot/sub-pr-216-another-one (subsumida por sub-pr-216-again)

**Rama Local:**
8. claude/analyze-docs-integration-01PNuXsNnT4QMuKC6AXWJLFC

**Acciones:**
```bash
# Eliminar ramas remotas completamente integradas
git push origin --delete claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R
git push origin --delete feature/analyze-agents-15-11-25-18-42
git push origin --delete feature/consolidate-rev-analysis-into-document-15-42-34
git push origin --delete copilot/investigate-api-issues
git push origin --delete copilot/sub-pr-203

# Eliminar ramas MCP redundantes (ya integradas via sub-pr-216-again)
git push origin --delete copilot/sub-pr-216
git push origin --delete copilot/sub-pr-216-another-one

# Eliminar rama local
git branch -d claude/analyze-docs-integration-01PNuXsNnT4QMuKC6AXWJLFC
```

**Criterios de Exito:**
- 7 ramas remotas eliminadas
- 1 rama local eliminada
- git branch -r no muestra ramas eliminadas

**Riesgos:**
- NINGUNO - Ramas completamente integradas

#### Tarea 5.2: Eliminar Ramas Integradas en Fases Anteriores
**Prioridad:** P4
**Duracion:** 5 min
**Responsable:** Desarrollador asignado

**Ramas a Eliminar (4 ramas):**
1. origin/feature/implement-mcp-server-installation-and-configuration-05-50-55 (subsumida por P1)
2. origin/copilot/validate-api-callcenter-site (integrada en Fase 3)
3. origin/feature/analyze-agents-in-/github-folder-18-45-40 (integrada en Fase 3)
4. origin/feature/create-improvement-plan-for-.devcontainer-06-21-46 (integrada en Fase 4)

**Acciones:**
```bash
git push origin --delete feature/implement-mcp-server-installation-and-configuration-05-50-55
git push origin --delete copilot/validate-api-callcenter-site
git push origin --delete feature/analyze-agents-in-/github-folder-18-45-40
git push origin --delete feature/create-improvement-plan-for-.devcontainer-06-21-46
```

**Criterios de Exito:**
- 4 ramas eliminadas exitosamente
- Total 12 ramas eliminadas en Fase 5

**Riesgos:**
- NINGUNO - Trabajo ya integrado

---

### FASE 6: EVALUACION Y CIERRE (10 minutos)

#### Tarea 6.1: Evaluar Rama backup-final-con-index
**Prioridad:** P5 - EVALUACION
**Duracion:** 5 min
**Responsable:** Desarrollador asignado

**Acciones:**
```bash
# Revisar cambio en index.md
git show origin/backup-final-con-index-20251113-080213:docs/index.md

# Comparar con version actual
cat docs/index.md

# Decision:
# - Si actual es muy extenso y necesita simplificacion: integrar
# - Si actual esta bien: no integrar y eliminar rama
```

**Criterios de Decision:**
- Si docs/index.md tiene mas de 200 lineas: considerar simplificacion
- Si docs/index.md es conciso: mantener actual

**Accion Condicional:**
```bash
# Si se decide integrar
git checkout origin/backup-final-con-index-20251113-080213 -- docs/index.md
git commit -m "docs: simplificar index.md a version historica deprecada"
git push origin --delete backup-final-con-index-20251113-080213

# Si se decide no integrar
git push origin --delete backup-final-con-index-20251113-080213
```

#### Tarea 6.2: Evaluar Rama integration-analysis
**Prioridad:** P5
**Duracion:** 0 min (YA INTEGRADA en Fase 4)

**Estado:** Completada en Tarea 4.2
**Accion:** Eliminar rama ya integrada
```bash
git push origin --delete claude/integration-analysis-011CV5YLxdEnu9YN3qpzGV2R
```

#### Tarea 6.3: Sincronizar con develop
**Prioridad:** CRITICA
**Duracion:** 5 min
**Responsable:** Desarrollador asignado

**Acciones:**
```bash
# Push de rama consolidada
git push origin claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2

# Actualizar develop (si rama objetivo debe reflejarse en develop)
git checkout develop
git merge claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2 --no-ff -m "chore: consolidar cambios de ramas pendientes"
git push origin develop
```

**Criterios de Exito:**
- Rama objetivo pusheada
- develop actualizado (si aplica)

---

## SECCION 3: CRONOGRAMA

### Timeline Detallado

| Fase | Tareas | Duracion | Inicio | Fin | Dependencias |
|------|--------|----------|--------|-----|--------------|
| FASE 1 | Preparacion | 15 min | T+0 | T+15 | Ninguna |
| FASE 2 | MCP Registry | 30 min | T+15 | T+45 | Fase 1 |
| FASE 3 | Validaciones + Agentes | 45 min | T+45 | T+90 | Fase 2 |
| FASE 4 | Docs Menores | 20 min | T+90 | T+110 | Fase 3 |
| FASE 5 | Limpieza Ramas | 20 min | T+110 | T+130 | Fase 4 |
| FASE 6 | Evaluacion y Cierre | 10 min | T+130 | T+140 | Fase 5 |

**Tiempo Total:** 2 horas 20 minutos (140 minutos)

### Distribucion por Dia

**Opcion A: Ejecucion Completa (Recomendada)**
- Dia 1: Fases 1-6 completas (2.5 horas)
- Ventaja: Consolidacion inmediata, una sola sesion
- Riesgo: Requiere bloque continuo de tiempo

**Opcion B: Ejecucion Incremental**
- Dia 1: Fases 1-2 (45 min) - MCP Registry
- Dia 2: Fases 3-4 (65 min) - Validaciones y Docs
- Dia 3: Fases 5-6 (30 min) - Limpieza y Cierre
- Ventaja: Flexibilidad, pausas para validacion
- Riesgo: Mayor posibilidad de conflictos entre sesiones

---

## SECCION 4: MATRIZ DE RESPONSABILIDADES

### RACI (Responsable, Aprobador, Consultado, Informado)

| Tarea | Desarrollador | Tech Lead | Arquitecto | QA Lead |
|-------|--------------|-----------|-----------|---------|
| Fase 1: Preparacion | R | A | I | I |
| Fase 2: MCP Registry | R | A | C | I |
| Fase 3: Validaciones API | R | A | I | C |
| Fase 3: Agentes Copilot | R | A | C | I |
| Fase 4: Docs Menores | R | A | I | I |
| Fase 5: Limpieza Ramas | R | A | I | I |
| Fase 6: Evaluacion Final | R | A | C | C |

**Leyenda:**
- R: Responsable de ejecutar
- A: Aprobador final
- C: Consultado durante ejecucion
- I: Informado de resultados

---

## SECCION 5: RIESGOS Y MITIGACIONES

### Matriz de Riesgos

| ID | Riesgo | Probabilidad | Impacto | Severidad | Mitigacion | Plan Contingencia |
|----|--------|-------------|---------|-----------|-----------|-------------------|
| R1 | Conflicto en agents.json | MEDIA | BAJO | MEDIA | Comparar manualmente antes de merge | Revertir y resolver manualmente |
| R2 | Tests MCP fallan tras integracion | BAJA | MEDIO | MEDIA | Verificar imports y estructura | Revertir merge, investigar dependencias |
| R3 | Archivos validacion ensucian raiz | ALTA | BAJO | BAJA | Reubicar inmediatamente tras merge | Script automatico de limpieza |
| R4 | Eliminacion accidental de trabajo | MUY BAJA | ALTO | MEDIA | Tag backup antes de cualquier cambio | Restaurar desde backup tag |
| R5 | Perdida de conexion durante push | BAJA | BAJO | BAJA | Reintentar con backoff exponencial | Usar --force-with-lease para re-push |
| R6 | Conflicto de merge inesperado | BAJA | MEDIO | MEDIA | Revisar diff antes de merge | Usar git merge --abort y resolver manualmente |

### Plan de Rollback General

**Si falla cualquier fase:**
```bash
# Opcion 1: Abortar merge en progreso
git merge --abort

# Opcion 2: Revertir al backup (si merge completado)
git reset --hard backup-pre-consolidacion-2025-11-17

# Opcion 3: Revertir commits especificos
git revert <commit-hash>

# Opcion 4: Restaurar desde tag remoto
git fetch origin
git reset --hard origin/backup-pre-consolidacion-2025-11-17
```

---

## SECCION 6: CRITERIOS DE VALIDACION

### Checklist de Validacion Post-Integracion

**Estructura de Archivos:**
- [ ] scripts/coding/ai/mcp/ contiene 3 archivos (.py)
- [ ] scripts/coding/tests/ai/mcp/ contiene 3 archivos (test_.py)
- [ ] docs/backend/validaciones/ contiene 6 archivos (.md)
- [ ] .github/copilot/agents.json existe y es valido JSON
- [ ] .agent/execplans/EXECPLAN_expand_copilot_agents.md existe
- [ ] docs/gobernanza/qa/INTEGRATION_ANALYSIS_REPORT.md existe

**Control de Version:**
- [ ] Rama objetivo tiene 6+ commits nuevos
- [ ] Tag backup-pre-consolidacion-2025-11-17 existe
- [ ] No hay archivos huerfanos en raiz del proyecto
- [ ] git status muestra working tree clean

**Limpieza:**
- [ ] 12 ramas eliminadas del remoto
- [ ] 1 rama eliminada local
- [ ] git branch -r muestra solo ramas validas
- [ ] develop sincronizado (si aplica)

**Funcionalidad:**
- [ ] Tests MCP pasan (si pytest disponible)
- [ ] Imports Python funcionales (si Python disponible)
- [ ] JSON de agents.json es valido
- [ ] No regresiones en funcionalidad existente

### Comando de Validacion Automatica

```bash
#!/bin/bash
# Script de validacion post-consolidacion

echo "=== VALIDACION POST-CONSOLIDACION ==="
echo ""

# Validar archivos MCP
echo "1. Validando archivos MCP..."
if [ -d "scripts/coding/ai/mcp" ]; then
    echo "  OK: Directorio MCP existe"
    FILE_COUNT=$(ls scripts/coding/ai/mcp/*.py 2>/dev/null | wc -l)
    echo "  Archivos MCP: $FILE_COUNT (esperado: 3)"
else
    echo "  ERROR: Directorio MCP no existe"
fi

# Validar tests MCP
echo "2. Validando tests MCP..."
if [ -d "scripts/coding/tests/ai/mcp" ]; then
    echo "  OK: Directorio tests MCP existe"
    TEST_COUNT=$(ls scripts/coding/tests/ai/mcp/test_*.py 2>/dev/null | wc -l)
    echo "  Archivos test: $TEST_COUNT (esperado: 2)"
else
    echo "  ERROR: Directorio tests MCP no existe"
fi

# Validar validaciones API
echo "3. Validando documentacion API..."
if [ -d "docs/backend/validaciones" ]; then
    echo "  OK: Directorio validaciones existe"
    VAL_COUNT=$(ls docs/backend/validaciones/*.md 2>/dev/null | wc -l)
    echo "  Archivos validacion: $VAL_COUNT (esperado: 6)"
else
    echo "  ERROR: Directorio validaciones no existe"
fi

# Validar agents.json
echo "4. Validando agents.json..."
if [ -f ".github/copilot/agents.json" ]; then
    echo "  OK: agents.json existe"
    # Validar JSON (requiere jq)
    if command -v jq &> /dev/null; then
        if jq empty .github/copilot/agents.json 2>/dev/null; then
            echo "  OK: agents.json es JSON valido"
        else
            echo "  ERROR: agents.json tiene sintaxis invalida"
        fi
    fi
else
    echo "  ERROR: agents.json no existe"
fi

# Validar tag backup
echo "5. Validando tag backup..."
if git tag -l | grep -q "backup-pre-consolidacion-2025-11-17"; then
    echo "  OK: Tag backup existe"
else
    echo "  ERROR: Tag backup no existe"
fi

# Validar estado git
echo "6. Validando estado git..."
if git diff --quiet && git diff --cached --quiet; then
    echo "  OK: Working tree limpio"
else
    echo "  ADVERTENCIA: Hay cambios sin commit"
fi

# Contar ramas remotas
echo "7. Validando limpieza de ramas..."
REMOTE_BRANCHES=$(git branch -r | grep -v "main\|docs\|develop\|HEAD" | wc -l)
echo "  Ramas remotas activas: $REMOTE_BRANCHES (esperado: <=5)"

echo ""
echo "=== FIN VALIDACION ==="
```

---

## SECCION 7: COMUNICACION Y DOCUMENTACION

### Plan de Comunicacion

**Antes de Ejecucion:**
- [ ] Notificar a equipo sobre consolidacion planificada
- [ ] Reservar bloque de tiempo (2.5 horas)
- [ ] Confirmar que no hay trabajo en progreso en ramas a integrar

**Durante Ejecucion:**
- [ ] Actualizar status cada fase completada
- [ ] Notificar inmediatamente si hay bloqueos
- [ ] Documentar decisiones tomadas (ej: comparacion agents.json)

**Post-Ejecucion:**
- [ ] Enviar reporte de consolidacion completo
- [ ] Actualizar este plan con "estado: completado"
- [ ] Crear tag de release consolidada (opcional)
- [ ] Notificar a equipo que ramas fueron eliminadas

### Documentacion Resultante

**Archivos a Actualizar Post-Consolidacion:**
1. Este plan (QA-PLAN-CONSOLIDACION-RAMAS-001)
   - Marcar tareas completadas
   - Documentar decisiones tomadas
   - Actualizar metricas finales

2. Crear reporte de ejecucion
   - docs/gobernanza/qa/QA-PLAN-CONSOLIDACION-RAMAS-001/REPORTE-EJECUCION-2025-11-17.md
   - Incluir timestamp de cada fase
   - Documentar problemas encontrados y soluciones

3. Actualizar README principal (si aplica)
   - Mencionar nuevo sistema MCP integrado
   - Actualizar documentacion de validaciones API

---

## SECCION 8: METRICAS DE SEGUIMIENTO

### Metricas Pre-Consolidacion (Linea Base)

| Metrica | Valor Inicial |
|---------|---------------|
| Total ramas activas | 17 |
| Ramas completamente integradas | 7 (41%) |
| Ramas con cambios unicos | 10 (59%) |
| Commits unicos pendientes | 38 |
| Archivos unicos pendientes | 26 |
| Lineas de codigo pendientes | ~5,500 |
| Directorio MCP existe | NO |
| Directorio validaciones existe | NO |

### Metricas Post-Consolidacion (Objetivo)

| Metrica | Valor Objetivo |
|---------|----------------|
| Total ramas activas | 5 (70% reduccion) |
| Ramas integradas exitosamente | 10 |
| Ramas eliminadas | 12 |
| Commits nuevos en rama objetivo | 6-8 |
| Archivos MCP integrados | 6 |
| Archivos validacion integrados | 6 |
| Lineas integradas | ~5,500 |
| Directorio MCP existe | SI |
| Directorio validaciones existe | SI |
| Tests MCP pasando | SI (si pytest disponible) |

### Dashboard de Progreso

**Estado Actual: PENDIENTE**

```
Fase 1: [ ] Preparacion              (0/3 tareas)
Fase 2: [ ] MCP Registry              (0/2 tareas)
Fase 3: [ ] Validaciones + Agentes    (0/2 tareas)
Fase 4: [ ] Docs Menores              (0/2 tareas)
Fase 5: [ ] Limpieza Ramas            (0/2 tareas)
Fase 6: [ ] Evaluacion y Cierre       (0/3 tareas)

Progreso Total: 0% (0/14 tareas completadas)
Tiempo Estimado Restante: 2h 20min
```

**Actualizar tras cada fase completada**

---

## SECCION 9: LECCIONES APRENDIDAS (POST-EJECUCION)

**IMPORTANTE:** Completar esta seccion tras ejecutar el plan.

### Que Funciono Bien
- [A completar post-ejecucion]

### Que No Funciono
- [A completar post-ejecucion]

### Problemas Inesperados
- [A completar post-ejecucion]

### Mejoras para Futuras Consolidaciones
- [A completar post-ejecucion]

### Tiempo Real vs Estimado
- [A completar post-ejecucion]

---

## SECCION 10: PROXIMOS PASOS

### Acciones Inmediatas (Hoy)
1. Revisar y aprobar este plan
2. Reservar bloque de tiempo de 2.5 horas
3. Ejecutar Fase 1 (Preparacion) - 15 min
4. Ejecutar Fase 2 (MCP Registry) - 30 min

### Acciones Corto Plazo (Esta Semana)
5. Ejecutar Fases 3-4 (Validaciones + Docs) - 65 min
6. Ejecutar Fases 5-6 (Limpieza + Cierre) - 30 min
7. Crear reporte de ejecucion
8. Notificar a equipo de consolidacion completada

### Acciones Medio Plazo (Proximo Sprint)
9. Establecer politica de limpieza regular de ramas
10. Documentar sistema MCP integrado
11. Crear tests adicionales para MCP (si aplica)
12. Revisar validaciones API y aplicar correcciones

### Politicas a Implementar
13. Limpieza semanal de ramas merged
14. Nomenclatura consistente de ramas (feat/, fix/, docs/)
15. Integracion continua a develop
16. Analisis mensual de ramas como este

---

## SECCION 11: APROBACIONES

### Aprobadores Requeridos

| Rol | Nombre | Estado | Fecha | Notas |
|-----|--------|--------|-------|-------|
| Desarrollador Asignado | [Pendiente] | [ ] | YYYY-MM-DD | Ejecutara el plan |
| Tech Lead | [Pendiente] | [ ] | YYYY-MM-DD | Aprueba estrategia tecnica |
| Arquitecto | [Pendiente] | [ ] | YYYY-MM-DD | Aprueba integracion MCP |

### Firmas Digitales
```
Desarrollador: ________________________  Fecha: __________
Tech Lead:     ________________________  Fecha: __________
Arquitecto:    ________________________  Fecha: __________
```

---

## REFERENCIAS

### Documentos Relacionados
- QA-ANALISIS-RAMAS-001: Analisis base para este plan
- docs/gobernanza/metodologias/: Metodologias de desarrollo
- docs/gobernanza/procesos/: Procesos SDLC

### Herramientas Utilizadas
- Git 2.x
- Bash scripting
- pytest (opcional, para tests MCP)
- jq (opcional, para validacion JSON)

### Enlaces Utiles
- Repositorio: 2-Coatl/IACT---project
- Rama objetivo: claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2
- Tag backup: backup-pre-consolidacion-2025-11-17

---

**ID:** QA-PLAN-CONSOLIDACION-RAMAS-001
**Plan completado:** 2025-11-17 21:57:38
**Basado en:** QA-ANALISIS-RAMAS-001
**Proxima revision:** Post-ejecucion (estimar 2025-11-24)
**Version:** 1.0.0
**Estado:** PENDIENTE EJECUCION
