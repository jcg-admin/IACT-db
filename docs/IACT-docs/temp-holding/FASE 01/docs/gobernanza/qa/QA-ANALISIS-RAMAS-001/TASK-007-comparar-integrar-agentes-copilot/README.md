---
id: TASK-QA-RAMAS-007
tipo: tarea
categoria: integracion_secundaria
titulo: Comparar e Integrar Agentes Copilot
fase: FASE_3
prioridad: P2_ALTA
duracion_estimada: 20min
estado: pendiente
dependencias: [TASK-QA-RAMAS-006]
---

# TASK-QA-RAMAS-007: Comparar e Integrar Agentes Copilot

**Fase:** FASE 3 - Integracion Secundaria
**Prioridad:** P2 - ALTA
**Duracion Estimada:** 20 minutos
**Responsable:** Desarrollador asignado
**Estado:** PENDIENTE
**Dependencias:** TASK-QA-RAMAS-006 (Validaciones API Integradas)

---

## Objetivo

Comparar versiones de .github/copilot/agents.json e integrar la version mas completa junto con el plan de ejecucion de expansion de agentes desde origin/feature/analyze-agents-in-/github-folder-18-45-40.

---

## Justificacion

Esta rama contiene exposicion completa de definiciones de agentes Copilot (255 lineas):
- Version potencialmente mas completa de .github/copilot/agents.json
- Plan de ejecucion para expansion de agentes (.agent/execplans/)
- Documentacion de analisis de agentes

**IMPORTANTE:** Requiere comparacion manual antes de integracion para evitar regresion.

---

## Prerequisitos

- [ ] TASK-QA-RAMAS-006 completada (Validaciones API integradas)
- [ ] Rama origen verificada: origin/feature/analyze-agents-in-/github-folder-18-45-40
- [ ] Archivo .github/copilot/agents.json existe en rama actual
- [ ] Directorio .agent/execplans/ existe (crear si necesario)

---

## Pasos de Ejecucion

### Paso 1: Verificar Rama Origen
```bash
# Ver commits unicos en rama origen
git log claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2..origin/feature/analyze-agents-in-/github-folder-18-45-40 --oneline

# Ver archivos que seran modificados/agregados
git diff --name-status claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2...origin/feature/analyze-agents-in-/github-folder-18-45-40
```

**Evidencia Esperada:**
- 1 archivo modificado (M): .github/copilot/agents.json
- 1 archivo nuevo (A): .agent/execplans/EXECPLAN_expand_copilot_agents.md

### Paso 2: Comparar Versiones de agents.json
```bash
# Crear diff temporal para analisis
git diff HEAD:.github/copilot/agents.json origin/feature/analyze-agents-in-/github-folder-18-45-40:.github/copilot/agents.json > /tmp/agents_diff.txt

# Mostrar diferencias
cat /tmp/agents_diff.txt

# Ver version actual
echo "=== VERSION ACTUAL ==="
cat .github/copilot/agents.json

# Ver version rama origen
echo "=== VERSION RAMA ORIGEN ==="
git show origin/feature/analyze-agents-in-/github-folder-18-45-40:.github/copilot/agents.json
```

**Analisis a Realizar:**
- [ ] Contar agentes en version actual
- [ ] Contar agentes en version rama origen
- [ ] Identificar agentes nuevos
- [ ] Identificar agentes eliminados
- [ ] Identificar configuraciones modificadas

### Paso 3: Validar JSON de Ambas Versiones
```bash
# Validar JSON actual (requiere jq)
if command -v jq &> /dev/null; then
    echo "=== Validando JSON actual ==="
    jq empty .github/copilot/agents.json 2>&1 && echo "OK: JSON valido" || echo "ERROR: JSON invalido"

    echo "=== Validando JSON rama origen ==="
    git show origin/feature/analyze-agents-in-/github-folder-18-45-40:.github/copilot/agents.json | jq empty 2>&1 && echo "OK: JSON valido" || echo "ERROR: JSON invalido"
else
    echo "ADVERTENCIA: jq no disponible - validacion manual requerida"
fi
```

**Validaciones:**
- [ ] Ambas versiones son JSON valido
- [ ] No hay errores de sintaxis

### Paso 4: Tomar Decision de Integracion

**DECISION CRITICA:** Basado en comparacion del Paso 2, elegir estrategia:

#### Opcion A: Version Rama Origen es Mas Completa
```bash
# Integrar version completa de agents.json + plan de ejecucion
git checkout origin/feature/analyze-agents-in-/github-folder-18-45-40 -- .github/copilot/agents.json
git checkout origin/feature/analyze-agents-in-/github-folder-18-45-40 -- .agent/execplans/EXECPLAN_expand_copilot_agents.md

git commit -m "feat(copilot): integrar definiciones completas de agentes

Cambios:
- Actualizar .github/copilot/agents.json con todas las definiciones
- Agregar .agent/execplans/EXECPLAN_expand_copilot_agents.md

Total: 255 lineas
Base: origin/feature/analyze-agents-in-/github-folder-18-45-40

Incluye:
- Definiciones completas de agentes Copilot
- Plan de ejecucion para expansion
- Analisis de agentes en carpeta .github
"
```

#### Opcion B: Version Actual es Mas Completa
```bash
# Solo integrar plan de ejecucion
git checkout origin/feature/analyze-agents-in-/github-folder-18-45-40 -- .agent/execplans/EXECPLAN_expand_copilot_agents.md

git commit -m "docs(copilot): agregar plan de ejecucion de expansion de agentes

Cambios:
- Agregar .agent/execplans/EXECPLAN_expand_copilot_agents.md

Mantener:
- .github/copilot/agents.json version actual (mas completa)
"
```

**Documentar Decision:** [Escribir aqui razon de decision]

### Paso 5: Verificar Archivos Integrados
```bash
# Verificar agents.json actualizado (si se integro)
cat .github/copilot/agents.json

# Verificar plan de ejecucion
cat .agent/execplans/EXECPLAN_expand_copilot_agents.md

# Validar JSON final
if command -v jq &> /dev/null; then
    jq . .github/copilot/agents.json > /dev/null && echo "OK: JSON valido" || echo "ERROR: JSON invalido"
fi
```

**Evidencia Esperada:**
- agents.json es JSON valido
- Plan de ejecucion existe en .agent/execplans/
- git status muestra working tree clean

### Paso 6: Contar Agentes en Version Final
```bash
# Contar agentes en version final (requiere jq)
if command -v jq &> /dev/null; then
    echo "Total de agentes:"
    jq '. | length' .github/copilot/agents.json

    echo "Nombres de agentes:"
    jq 'keys' .github/copilot/agents.json
fi
```

**Documentar:**
- Total agentes: __
- Nombres: [listar]

---

## Criterios de Exito

- [ ] Comparacion de agents.json completada
- [ ] Decision de integracion documentada
- [ ] JSON final es valido
- [ ] Plan de ejecucion integrado (.agent/execplans/EXECPLAN_expand_copilot_agents.md)
- [ ] No regresion en definiciones existentes
- [ ] git status muestra working tree clean
- [ ] 1 commit creado

---

## Validacion Post-Integracion

### Validacion 1: Verificar JSON Valido
```bash
# Validar sintaxis JSON
if command -v jq &> /dev/null; then
    jq empty .github/copilot/agents.json && echo "OK: JSON valido" || echo "ERROR: JSON invalido"
else
    # Validacion manual con Python
    python3 -c "import json; json.load(open('.github/copilot/agents.json'))" && echo "OK: JSON valido" || echo "ERROR: JSON invalido"
fi
```

**Resultado Esperado:** JSON valido sin errores

### Validacion 2: Verificar Estructura de Agentes
```bash
# Ver estructura de agentes (requiere jq)
if command -v jq &> /dev/null; then
    jq 'keys' .github/copilot/agents.json

    # Ver ejemplo de configuracion de un agente
    jq '.[keys[0]]' .github/copilot/agents.json
fi
```

**Validaciones:**
- [ ] Cada agente tiene configuracion valida
- [ ] No hay agentes vacios

### Validacion 3: Verificar Plan de Ejecucion
```bash
# Ver contenido del plan
head -50 .agent/execplans/EXECPLAN_expand_copilot_agents.md

# Verificar formato Markdown
file .agent/execplans/EXECPLAN_expand_copilot_agents.md
```

**Resultado Esperado:** Archivo Markdown con plan de expansion

### Validacion 4: Git History
```bash
# Ver commit creado
git log -1 --oneline

# Ver archivos del commit
git show --stat

# Ver diff de agents.json (si se modifico)
git show HEAD:.github/copilot/agents.json | head -50
```

**Evidencia Esperada:**
- 1 commit nuevo con mensaje descriptivo
- 1-2 archivos modificados/agregados

---

## Rollback

Si integracion presenta problemas:

### Opcion A: Revertir Commit
```bash
# Ver commit a revertir
git log -1 --oneline

# Revertir
git revert HEAD
```

### Opcion B: Reset a Backup
```bash
# Revertir al backup
git reset --hard backup-pre-consolidacion-2025-11-17
```

### Opcion C: Restaurar Solo agents.json
```bash
# Restaurar version anterior de agents.json
git checkout HEAD~1 -- .github/copilot/agents.json
git commit -m "revert: restaurar version anterior de agents.json"
```

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Conflicto en agents.json | MEDIA | MEDIO | Comparar manualmente antes de merge |
| Regresion en agentes | MEDIA | ALTO | Validar que version integrada es superset |
| JSON invalido | BAJA | ALTO | Validar con jq/python antes de commit |
| Perdida de configuracion | BAJA | ALTO | Documentar diferencias antes de integrar |

---

## Evidencias a Capturar

**Logs a Guardar:**
1. Output de git diff (comparacion de versiones)
2. Decision de integracion y razon
3. Output de jq (validacion JSON)
4. Total de agentes en version final
5. Output de git show (commit creado)

**Archivos Integrados/Modificados:**
- .github/copilot/agents.json (posiblemente modificado)
- .agent/execplans/EXECPLAN_expand_copilot_agents.md (nuevo)

**Decision Documentada:**
- Version elegida: [Actual / Rama Origen]
- Razon: [Explicar decision]
- Agentes agregados: [listar]
- Agentes eliminados: [listar]

---

## Notas Importantes

- Comparacion manual es CRITICA - no asumir version mas reciente es mejor
- Evitar perdida de definiciones de agentes existentes
- JSON invalido bloqueara funcionalidad de Copilot
- Plan de ejecucion es documentacion valiosa para futuras expansiones
- Rama origen puede eliminarse en FASE 5 tras esta integracion

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Comparacion de agents.json completada
- [ ] Decision de integracion documentada
- [ ] Version final de agents.json validada (JSON valido)
- [ ] Plan de ejecucion integrado
- [ ] No regresion en agentes existentes
- [ ] Total de agentes documentado
- [ ] Evidencias capturadas
- [ ] git status limpio
- [ ] FASE 3 completada - listo para FASE 4
- [ ] Tarea marcada como COMPLETADA

---

**Tarea creada:** 2025-11-17
**Ultima actualizacion:** 2025-11-17
**Version:** 1.0.0
**Estado:** PENDIENTE
