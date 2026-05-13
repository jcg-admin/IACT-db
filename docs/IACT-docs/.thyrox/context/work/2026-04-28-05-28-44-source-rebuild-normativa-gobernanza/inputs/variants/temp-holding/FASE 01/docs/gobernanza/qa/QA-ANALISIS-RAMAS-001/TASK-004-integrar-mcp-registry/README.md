---
id: TASK-QA-RAMAS-004
tipo: tarea
categoria: integracion_critica
titulo: Integrar MCP Registry Completo
fase: FASE_2
prioridad: P1_CRITICA
duracion_estimada: 20min
estado: pendiente
dependencias: [TASK-QA-RAMAS-003]
---

# TASK-QA-RAMAS-004: Integrar MCP Registry Completo

**Fase:** FASE 2 - Integracion Critica
**Prioridad:** P1 - CRITICA
**Duracion Estimada:** 20 minutos
**Responsable:** Desarrollador asignado
**Estado:** PENDIENTE
**Dependencias:** TASK-QA-RAMAS-003 (Rama Base Validada)

---

## Objetivo

Integrar el sistema MCP (Model Context Protocol) registry completo desde la rama origin/copilot/sub-pr-216-again, que incluye implementacion base, memory stack, tests de casos borde y type annotations modernizadas.

---

## Justificacion

Esta rama contiene la version mas completa del MCP registry (735 lineas):
- Implementacion base del registry
- Memory stack completo
- Tests de casos borde (edge cases)
- Modernizacion de type annotations (PEP 585)
- Mejor coverage que otras versiones (sub-pr-216, sub-pr-216-another-one)

---

## Prerequisitos

- [ ] TASK-QA-RAMAS-003 completada (rama base validada)
- [ ] Rama origen verificada: origin/copilot/sub-pr-216-again
- [ ] No existen conflictos esperados (archivos nuevos)

---

## Pasos de Ejecucion

### Paso 1: Verificar Rama Origen
```bash
# Ver commits unicos en rama origen
git log claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2..origin/copilot/sub-pr-216-again --oneline

# Ver archivos que seran agregados
git diff --name-status claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2...origin/copilot/sub-pr-216-again
```

**Evidencia Esperada:**
- 5 commits unicos
- 6 archivos nuevos (A = added):
  - scripts/coding/ai/mcp/__init__.py
  - scripts/coding/ai/mcp/memory.py
  - scripts/coding/ai/mcp/registry.py
  - scripts/coding/tests/ai/mcp/__init__.py
  - scripts/coding/tests/ai/mcp/test_memory.py
  - scripts/coding/tests/ai/mcp/test_registry.py

### Paso 2: Merge de Rama MCP
```bash
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

Incluye:
- Implementacion base MCP registry
- Memory stack completo
- Tests de casos borde
- Type annotations modernizadas (PEP 585)
"
```

**Evidencia Esperada:**
- Merge exitoso sin conflictos
- Mensaje "6 files changed, 735 insertions(+)"

### Paso 3: Verificar Archivos Creados
```bash
# Verificar directorios creados
ls -la scripts/coding/ai/mcp/
ls -la scripts/coding/tests/ai/mcp/

# Contar archivos
find scripts/coding/ai/mcp/ -name "*.py" | wc -l  # Esperado: 3
find scripts/coding/tests/ai/mcp/ -name "*.py" | wc -l  # Esperado: 3
```

**Evidencia Esperada:**
- Directorio scripts/coding/ai/mcp/ existe con 3 archivos
- Directorio scripts/coding/tests/ai/mcp/ existe con 3 archivos

### Paso 4: Verificar Estructura de Paquetes Python
```bash
# Ver contenido de __init__.py
cat scripts/coding/ai/mcp/__init__.py
cat scripts/coding/tests/ai/mcp/__init__.py
```

**Evidencia Esperada:**
- Ambos __init__.py existen y no estan vacios
- Contienen imports o definiciones correctas

### Paso 5: Contar Lineas Integradas
```bash
wc -l scripts/coding/ai/mcp/*.py scripts/coding/tests/ai/mcp/*.py
```

**Evidencia Esperada:**
- Total cercano a 735 lineas

---

## Criterios de Exito

- [ ] Merge exitoso sin conflictos
- [ ] 6 archivos nuevos creados
- [ ] 2 directorios nuevos creados (mcp/ y tests/ai/mcp/)
- [ ] __init__.py presentes en ambos directorios
- [ ] Total lineas cercano a 735
- [ ] git status muestra working tree clean (tras commit)

---

## Validacion Post-Integracion

### Validacion 1: Estructura de Directorios
```bash
tree scripts/coding/ai/mcp/ scripts/coding/tests/ai/mcp/ || \
ls -R scripts/coding/ai/mcp/ scripts/coding/tests/ai/mcp/
```

### Validacion 2: Imports Python (si Python disponible)
```bash
# Validar que modulos se pueden importar
python3 -c "from scripts.coding.ai.mcp import registry" 2>&1
python3 -c "from scripts.coding.ai.mcp import memory" 2>&1
```

**Resultado Esperado:** Sin errores de import O mensaje "No module named 'scripts'" (aceptable si PYTHONPATH no configurado)

### Validacion 3: Tests MCP (si pytest disponible)
```bash
# Ejecutar tests MCP
pytest scripts/coding/tests/ai/mcp/ -v 2>&1 || echo "pytest no disponible"
```

**Resultado Esperado:** Tests pasan O pytest no instalado (aceptable)

### Validacion 4: Git History
```bash
# Ver merge commit creado
git log -1 --oneline

# Ver archivos del merge
git show --stat
```

**Evidencia Esperada:**
- Merge commit con mensaje correcto
- 6 archivos en el commit

---

## Rollback

Si merge falla o presenta problemas:

### Opcion A: Abortar Merge (si merge en progreso)
```bash
git merge --abort
```

### Opcion B: Revertir Merge (si merge completado)
```bash
# Ver hash del merge commit
git log -1 --oneline

# Revertir al backup
git reset --hard backup-pre-consolidacion-2025-11-17
```

### Opcion C: Revertir Solo Merge Commit
```bash
git revert -m 1 HEAD
```

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Conflictos inesperados | MUY BAJA | MEDIO | Archivos nuevos, conflicto improbable |
| Imports Python fallan | BAJA | BAJO | Normal si PYTHONPATH no configurado |
| Tests MCP fallan | BAJA | MEDIO | Investigar dependencias faltantes |
| Estructura incorrecta | MUY BAJA | MEDIO | Validar __init__.py presentes |

---

## Evidencias a Capturar

**Screenshots/Logs:**
1. Output de git merge (6 files changed, 735 insertions)
2. Output de ls -la scripts/coding/ai/mcp/
3. Output de ls -la scripts/coding/tests/ai/mcp/
4. Output de wc -l (total lineas)
5. Output de pytest (si disponible)

**Archivos Generados:**
- scripts/coding/ai/mcp/__init__.py
- scripts/coding/ai/mcp/memory.py
- scripts/coding/ai/mcp/registry.py
- scripts/coding/tests/ai/mcp/__init__.py
- scripts/coding/tests/ai/mcp/test_memory.py
- scripts/coding/tests/ai/mcp/test_registry.py

---

## Notas Importantes

- Esta es la integracion MAS CRITICA del plan
- Version sub-pr-216-again es la mas completa (735 lineas vs 629/633)
- Tras esta tarea, eliminar ramas MCP redundantes en TASK-011
- Sistema MCP es base para futuras automatizaciones

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Merge exitoso
- [ ] 6 archivos MCP creados
- [ ] Estructura de paquetes Python correcta
- [ ] __init__.py presentes y validos
- [ ] Tests ejecutados (si pytest disponible)
- [ ] Evidencias capturadas
- [ ] git status limpio
- [ ] Tarea marcada como COMPLETADA

---

**Tarea creada:** 2025-11-17
**Ultima actualizacion:** 2025-11-17
**Version:** 1.0.0
**Estado:** PENDIENTE
