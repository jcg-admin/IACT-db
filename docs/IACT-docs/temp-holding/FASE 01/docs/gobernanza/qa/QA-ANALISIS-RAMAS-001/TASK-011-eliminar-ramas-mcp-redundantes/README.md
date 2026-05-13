---
id: TASK-QA-RAMAS-011
tipo: tarea
categoria: limpieza_ramas
titulo: Eliminar Ramas MCP Redundantes
fase: FASE_5
prioridad: P4_BAJA
duracion_estimada: 5min
estado: pendiente
dependencias: [TASK-QA-RAMAS-010]
---

# TASK-QA-RAMAS-011: Eliminar Ramas MCP Redundantes

**Fase:** FASE 5 - Limpieza de Ramas
**Prioridad:** P4 - BAJA
**Duracion Estimada:** 5 minutos
**Responsable:** Desarrollador asignado
**Estado:** PENDIENTE
**Dependencias:** TASK-QA-RAMAS-010 (Ramas Integradas Eliminadas)

---

## Objetivo

Eliminar 4 ramas remotas que fueron integradas durante las fases anteriores del plan de consolidacion (FASE 2, FASE 3, FASE 4), completando la limpieza sistematica del repositorio.

---

## Justificacion

Estas ramas contienen trabajo que ya fue **exitosamente integrado** en tareas previas:
- **TASK-004**: Integracion MCP registry completo
- **FASE 3**: Integracion de validaciones API y agentes
- **FASE 4**: Integracion de documentacion DevContainer

Al eliminarlas se completa el ciclo de consolidacion:
1. Analizar ramas (FASE 1)
2. Integrar contenido unico (FASES 2-4)
3. Eliminar ramas fuente (FASE 5)

---

## Prerequisitos

- [ ] TASK-QA-RAMAS-010 completada (ramas completamente integradas eliminadas)
- [ ] TASK-QA-RAMAS-004 completada (MCP registry integrado desde sub-pr-216-again)
- [ ] FASE 3 completada (validaciones API y agentes integrados)
- [ ] FASE 4 completada (docs DevContainer integrados)
- [ ] Confirmacion que contenido esta integrado en rama objetivo

---

## Ramas a Eliminar

### 1. origin/feature/implement-mcp-server-installation-and-configuration-05-50-55
**Integrada en:** TASK-QA-RAMAS-004 (FASE 2)
**Motivo:** Contenido de instalacion MCP subsumido por integracion completa de sub-pr-216-again
**Contenido:** Configuracion e instalacion MCP server
**Lineas:** ~150

### 2. origin/copilot/validate-api-callcenter-site
**Integrada en:** FASE 3 - Tarea 3.1
**Motivo:** Documentacion de validacion API callcentersite completamente integrada
**Contenido:** 6 archivos de validacion API (1,962 lineas)
**Archivos:**
- ANALISIS_URLS_COMPLETO.md
- CORRECCIONES_MENORES.md
- INDICE_VALIDACION.md
- RESUMEN_VALIDACION.md
- VALIDACION_API_CALLCENTERSITE.md
- VALIDACION_RAPIDA.md

### 3. origin/feature/analyze-agents-in-/github-folder-18-45-40
**Integrada en:** FASE 3 - Tarea 3.2
**Motivo:** Definiciones de agentes Copilot y plan de ejecucion integrados
**Contenido:**
- .github/copilot/agents.json (actualizado)
- .agent/execplans/EXECPLAN_expand_copilot_agents.md (nuevo)
**Lineas:** ~255

### 4. origin/feature/create-improvement-plan-for-.devcontainer-06-21-46
**Integrada en:** FASE 4 - Tarea 4.1
**Motivo:** Mejoras de documentacion DevContainer integradas
**Contenido:** docs/infraestructura/devcontainer/README.md (aclaraciones Linux/Vagrant)
**Lineas:** +6

---

## Pasos de Ejecucion

### Paso 1: Verificar Integracion Previa
```bash
# Verificar que TASK-004 fue completada (MCP integrado)
ls -la scripts/coding/ai/mcp/
# Esperado: 3 archivos .py

# Verificar que validaciones API fueron integradas (FASE 3)
ls -la docs/backend/validaciones/
# Esperado: 6 archivos .md

# Verificar que agentes Copilot fueron integrados (FASE 3)
cat .github/copilot/agents.json | head -20
ls -la .agent/execplans/EXECPLAN_expand_copilot_agents.md

# Verificar que docs DevContainer fueron actualizados (FASE 4)
git log --oneline -1 --grep="devcontainer"
```

**Resultado Esperado:** Todos los archivos/commits presentes, confirmando integracion exitosa

### Paso 2: Listar Ramas a Eliminar
```bash
# Verificar existencia de ramas
git branch -r | grep -E "feature/implement-mcp-server-installation-and-configuration-05-50-55|copilot/validate-api-callcenter-site|feature/analyze-agents-in-/github-folder-18-45-40|feature/create-improvement-plan-for-.devcontainer-06-21-46"
```

**Resultado Esperado:** 4 ramas listadas

### Paso 3: Eliminar Ramas MCP Redundantes
```bash
# Eliminar rama de instalacion MCP (subsumida por sub-pr-216-again)
git push origin --delete feature/implement-mcp-server-installation-and-configuration-05-50-55
```

**Resultado Esperado:** "Deleted remote-tracking branch"

### Paso 4: Eliminar Rama de Validacion API
```bash
# Eliminar rama de validaciones (contenido ya en docs/backend/validaciones/)
git push origin --delete copilot/validate-api-callcenter-site
```

**Resultado Esperado:** "Deleted remote-tracking branch"

### Paso 5: Eliminar Rama de Agentes Copilot
```bash
# Eliminar rama de analisis de agentes (contenido integrado)
git push origin --delete feature/analyze-agents-in-/github-folder-18-45-40
```

**Resultado Esperado:** "Deleted remote-tracking branch"

### Paso 6: Eliminar Rama de DevContainer
```bash
# Eliminar rama de mejoras DevContainer (docs ya integrados)
git push origin --delete feature/create-improvement-plan-for-.devcontainer-06-21-46
```

**Resultado Esperado:** "Deleted remote-tracking branch"

---

## Criterios de Exito

- [ ] 4 ramas remotas eliminadas exitosamente
- [ ] git branch -r no muestra ninguna de las ramas eliminadas
- [ ] Total de ramas eliminadas en FASE 5: 12 (8 en TASK-010 + 4 en TASK-011)
- [ ] Contenido de cada rama confirmado integrado antes de eliminacion

---

## Validacion Post-Eliminacion

### Validacion 1: Verificar Eliminacion de Ramas
```bash
# Actualizar referencias remotas
git fetch origin --prune

# Verificar que ramas no existen
git branch -r | grep -E "feature/implement-mcp-server-installation-and-configuration-05-50-55|copilot/validate-api-callcenter-site|feature/analyze-agents-in-/github-folder-18-45-40|feature/create-improvement-plan-for-.devcontainer-06-21-46"
```

**Resultado Esperado:** Sin resultados (todas eliminadas)

### Validacion 2: Verificar Contenido Integrado Permanece
```bash
# Validar MCP sigue presente
test -d scripts/coding/ai/mcp && echo "MCP: OK" || echo "MCP: MISSING"

# Validar validaciones API siguen presentes
test -d docs/backend/validaciones && echo "Validaciones: OK" || echo "Validaciones: MISSING"

# Validar agentes Copilot siguen presentes
test -f .github/copilot/agents.json && echo "Agents: OK" || echo "Agents: MISSING"
test -f .agent/execplans/EXECPLAN_expand_copilot_agents.md && echo "Execplan: OK" || echo "Execplan: MISSING"

# Validar docs DevContainer siguen presentes
test -f docs/infraestructura/devcontainer/README.md && echo "DevContainer: OK" || echo "DevContainer: MISSING"
```

**Resultado Esperado:** Todos: OK

### Validacion 3: Contar Ramas Finales
```bash
# Contar ramas remotas totales
TOTAL_REMOTE=$(git branch -r | grep -v "HEAD" | wc -l)
echo "Ramas remotas activas: $TOTAL_REMOTE"

# Comparar con objetivo (5 ramas finales)
if [ $TOTAL_REMOTE -le 5 ]; then
  echo "EXITO: Objetivo de 5 o menos ramas alcanzado"
else
  echo "PENDIENTE: Quedan $(($TOTAL_REMOTE - 5)) ramas por analizar"
fi
```

**Objetivo:** 5 o menos ramas activas (reduccion del 70%)

### Validacion 4: Resumen de Limpieza FASE 5
```bash
echo "=== RESUMEN FASE 5: LIMPIEZA DE RAMAS ==="
echo "TASK-010: 8 ramas eliminadas (7 remotas + 1 local)"
echo "TASK-011: 4 ramas eliminadas (4 remotas)"
echo "TOTAL ELIMINADAS: 12 ramas"
echo ""
echo "Metricas finales:"
echo "- Inicio: 17 ramas activas"
echo "- Eliminadas: 12 ramas"
echo "- Final: $TOTAL_REMOTE ramas activas"
echo "- Reduccion: $(( (12 * 100) / 17 ))%"
```

---

## Rollback

Si se necesita restaurar alguna rama eliminada:

### Opcion A: Restaurar desde Commit Hash
```bash
# Buscar commit hash de la rama (ejemplo)
git log --all --oneline | grep "mcp-server-installation"

# Restaurar rama
git push origin <commit-hash>:refs/heads/feature/implement-mcp-server-installation-and-configuration-05-50-55
```

### Opcion B: Buscar en Reflog
```bash
# Ver historial completo
git reflog show --all | grep "validate-api-callcenter-site"
```

### Opcion C: Restaurar desde Backup Tag
```bash
# Checkout al backup
git checkout backup-pre-consolidacion-2025-11-17

# Recrear rama
git checkout -b feature/analyze-agents-in-/github-folder-18-45-40
git push origin feature/analyze-agents-in-/github-folder-18-45-40
```

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Contenido no completamente integrado | MUY BAJA | MEDIO | Validacion paso 1 confirma integracion |
| Eliminar rama con contenido unico | MUY BAJA | ALTO | Cada rama verificada en fases previas |
| Fallo de conexion | BAJA | BAJO | Reintentar eliminacion |
| Referencia perdida sin backup | MUY BAJA | BAJO | Backup tag conservado 30 dias |

---

## Evidencias a Capturar

**Logs a Guardar:**
1. Output de validacion paso 1 (confirmacion integracion previa)
2. Output de git branch -r antes de TASK-011
3. Output de cada git push origin --delete
4. Output de validacion post-eliminacion (contenido integrado permanece)
5. Output de resumen FASE 5

**Metricas Finales:**
- Ramas eliminadas TASK-010: 8
- Ramas eliminadas TASK-011: 4
- Total eliminadas FASE 5: 12
- Ramas activas finales: __
- Reduccion porcentual: __%
- Objetivo alcanzado: SI / NO

---

## Notas Importantes

- **CRITICO**: Solo eliminar tras verificar integracion exitosa en paso 1
- Esta tarea **completa la FASE 5** del plan de consolidacion
- Las 4 ramas fueron integradas en fases anteriores con exito confirmado
- El contenido de cada rama ya esta en la rama objetivo
- Esta eliminacion cierra el ciclo: Analizar -> Integrar -> Eliminar
- Tras esta tarea, **FASE 6** (Evaluacion y Cierre) puede comenzar

---

## Relacion con Otras Tareas

**Precedida por:**
- TASK-QA-RAMAS-010: Eliminacion de ramas completamente integradas
- TASK-QA-RAMAS-004: Integracion MCP registry (FASE 2)
- FASE 3: Integracion validaciones API y agentes
- FASE 4: Integracion docs DevContainer

**Seguida por:**
- FASE 6: Evaluacion y Cierre
- Tarea 6.1: Evaluar rama backup-final-con-index
- Tarea 6.3: Sincronizar con develop

**Impacta en:**
- Metrica final: Reduccion del 70% en numero de ramas
- Dashboard de progreso: FASE 5 completada
- Seccion 8: Metricas post-consolidacion

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Integracion previa verificada (paso 1)
- [ ] 4 ramas remotas eliminadas
- [ ] Validacion contenido integrado permanece
- [ ] git fetch origin --prune ejecutado
- [ ] Metricas finales documentadas
- [ ] Resumen FASE 5 generado
- [ ] Evidencias capturadas
- [ ] **FASE 5 COMPLETA** - Listo para FASE 6
- [ ] Tarea marcada como COMPLETADA

---

**Tarea creada:** 2025-11-17
**Ultima actualizacion:** 2025-11-17
**Version:** 1.0.0
**Estado:** PENDIENTE
