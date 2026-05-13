---
id: TASK-REORG-BACK-014
tipo: tarea
categoria: consolidacion-diseno
titulo: Mover arquitectura/ a diseno/arquitectura/
fase: FASE_2
prioridad: ALTA
duracion_estimada: 5min
estado: pendiente
dependencias: ["TASK-REORG-BACK-011"]
---

# TASK-REORG-BACK-014: Mover arquitectura/ a diseno/arquitectura/

**Fase:** FASE 2 - Consolidacion diseno/
**Prioridad:** ALTA
**Duracion Estimada:** 5 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Mover toda la documentacion arquitectonica de docs/backend/arquitectura/ a docs/backend/diseno/arquitectura/ para centralizar documentacion de diseno.

---

## Auto-CoT: Razonamiento Paso a Paso

### Pensamiento 1: Por que mover arquitectura/
- **Observacion:** arquitectura/ contiene decisiones de diseno arquitectonico
- **Razonamiento:** El diseno arquitectonico es parte del diseno general
- **Conclusion:** Debe estar bajo diseno/arquitectura/ para mejor organizacion
- **Beneficio:** Jerarquia clara: diseno > arquitectura

### Pensamiento 2: Como preservar integridad
- Usar git mv para mantener historial
- Verificar que no se pierdan archivos
- Validar estructura de subdirectorios
- Confirmar que destino esta vacio antes de mover

### Pensamiento 3: Impacto del movimiento
- Referencias internas pueden romperse
- Links desde otros documentos deben actualizarse (TASK posterior)
- Estructura de carpetas debe mantenerse
- ADRs y diagramas deben permanecer juntos

---

## Prerequisitos

- [ ] TASK-011 completada (subcarpetas creadas)
- [ ] docs/backend/diseno/arquitectura/ existe y esta vacia
- [ ] docs/backend/arquitectura/ existe con contenido
- [ ] Backup creado (TASK-001)
- [ ] Working directory limpio

---

## Pasos de Ejecucion

### Paso 1: Analizar Contenido de arquitectura/
```bash
# Ver estructura completa de arquitectura/
echo "=== Estructura de arquitectura/ ==="
find docs/backend/arquitectura/ -type f 2>/dev/null | sort

# Contar archivos y subdirectorios
FILES=$(find docs/backend/arquitectura/ -type f 2>/dev/null | wc -l)
DIRS=$(find docs/backend/arquitectura/ -mindepth 1 -type d 2>/dev/null | wc -l)
echo "Total archivos: $FILES"
echo "Total subdirectorios: $DIRS"
```

**Resultado Esperado:** Inventario completo de contenido

### Paso 2: Verificar Destino Vacio
```bash
# Verificar que diseno/arquitectura/ esta vacio
DEST_FILES=$(find docs/backend/diseno/arquitectura/ -type f ! -name ".gitkeep" 2>/dev/null | wc -l)
if [ "$DEST_FILES" -eq 0 ]; then
 echo "OK: Destino vacio, listo para mover"
else
 echo "ERROR: Destino ya tiene $DEST_FILES archivos"
 exit 1
fi
```

**Resultado Esperado:** Destino vacio

### Paso 3: Mover Contenido
```bash
# Mover todo el contenido de arquitectura/ a diseno/arquitectura/
if [ -d "docs/backend/arquitectura" ] && [ "$(ls -A docs/backend/arquitectura)" ]; then
 git mv docs/backend/arquitectura/* docs/backend/diseno/arquitectura/ 2>&1 | tee \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/log-movimiento-arquitectura.txt
else
 echo "ERROR: arquitectura/ no existe o esta vacia"
 exit 1
fi
```

**Resultado Esperado:** Archivos movidos con git mv

### Paso 4: Verificar Movimiento Completo
```bash
# Contar archivos en destino
DEST_COUNT=$(find docs/backend/diseno/arquitectura/ -type f | wc -l)
echo "Archivos en destino: $DEST_COUNT"
echo "Esperado: $FILES"

# Verificar que origen esta vacio
ORIGEN_REMAINING=$(find docs/backend/arquitectura/ -type f ! -name ".gitkeep" 2>/dev/null | wc -l)
if [ "$ORIGEN_REMAINING" -eq 0 ]; then
 echo "OK: Origen vacio"
else
 echo "WARNING: Origen aun tiene $ORIGEN_REMAINING archivos"
fi
```

**Resultado Esperado:** Todos los archivos en destino, origen vacio

### Paso 5: Verificar Estructura de Subdirectorios
```bash
# Verificar que subdirectorios se movieron correctamente
echo "=== Subdirectorios en destino ==="
find docs/backend/diseno/arquitectura/ -type d | sort
```

**Resultado Esperado:** Estructura de directorios preservada

### Paso 6: Verificar Estado de Git
```bash
# Ver cambios en git
git status | grep -E "(renamed|deleted)"

# Contar renames
RENAME_COUNT=$(git diff --staged --name-status | grep "^R" | grep "arquitectura" | wc -l)
echo "Archivos renombrados: $RENAME_COUNT"
```

**Resultado Esperado:** Git muestra movimientos como renames

### Paso 7: Documentar Movimiento
```bash
cat > docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/registro-movimiento-arquitectura-TASK-014.md << EOF
---
tarea: TASK-014
fecha: 2025-11-18
tipo: movimiento
---

# Registro de Movimiento: arquitectura/ -> diseno/arquitectura/

## Archivos Movidos
\`\`\`
$(git diff --staged --name-status | grep "arquitectura" | grep "^R")
\`\`\`

## Totales
- Archivos en origen: $FILES
- Subdirectorios: $DIRS
- Archivos movidos: $DEST_COUNT
- Status: $([ "$FILES" -eq "$DEST_COUNT" ] && echo "OK" || echo "REVISAR")

## Timestamp
$(date -Iseconds)
EOF
```

**Resultado Esperado:** Registro completo del movimiento

---

## Criterios de Exito

- [ ] Todos los archivos de arquitectura/ movidos a diseno/arquitectura/
- [ ] Estructura de subdirectorios preservada
- [ ] Carpeta origen (arquitectura/) vacia (solo .gitkeep si existe)
- [ ] Movimientos registrados en git como renames
- [ ] Conteo de archivos coincide (origen = destino)
- [ ] Log de movimiento generado

---

## Validacion

```bash
# Validacion 1: Origen vacio
COUNT=$(find docs/backend/arquitectura/ -type f ! -name ".gitkeep" 2>/dev/null | wc -l)
if [ "$COUNT" -eq 0 ]; then
 echo "OK: arquitectura/ vacio"
else
 echo "ERROR: arquitectura/ aun tiene $COUNT archivos"
fi

# Validacion 2: Destino poblado
DEST=$(find docs/backend/diseno/arquitectura/ -type f ! -name ".gitkeep" | wc -l)
if [ "$DEST" -gt 0 ]; then
 echo "OK: diseno/arquitectura/ tiene $DEST archivos"
else
 echo "ERROR: diseno/arquitectura/ esta vacio"
fi

# Validacion 3: Git renames
RENAMES=$(git diff --staged --name-status | grep "^R" | grep "arquitectura" | wc -l)
echo "Git renames detectados: $RENAMES"

# Validacion 4: Preservacion de estructura
echo "=== Verificar subdirectorios preservados ==="
# Listar subdirectorios en destino
find docs/backend/diseno/arquitectura/ -type d | sort
```

**Salida Esperada:**
- Origen vacio
- Destino poblado
- Renames en git
- Estructura preservada

---

## Self-Consistency: Verificacion de Coherencia

### Verificacion 1: Integridad de Archivos
- [ ] Conteo origen = conteo destino
- [ ] Estructura de directorios identica
- [ ] Nombres de archivos preservados

### Verificacion 2: Coherencia con Plan
- [ ] Ubicacion destino segun PLAN-REORGANIZACION
- [ ] Carpeta origen correcta
- [ ] Jerarquia logica (diseno > arquitectura)

### Verificacion 3: Estado de Git
- [ ] Todos los movimientos son renames
- [ ] No hay archivos untracked
- [ ] Staged changes correctos

---

## Rollback

Si se necesita deshacer:
```bash
# Deshacer movimientos (antes de commit)
git reset HEAD docs/backend/diseno/arquitectura/
git reset HEAD docs/backend/arquitectura/

# Restaurar a estado original
git checkout HEAD -- docs/backend/arquitectura/
git checkout HEAD -- docs/backend/diseno/arquitectura/

# Verificar
git status
```

**ADVERTENCIA:** Solo ejecutar rollback ANTES de hacer commit

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Perdida de archivos | BAJA | CRITICO | Validar conteo antes/despues |
| Estructura rota | BAJA | ALTO | Verificar subdirectorios |
| Historial perdido | BAJA | MEDIO | Usar git mv siempre |
| Referencias rotas | MEDIA | MEDIO | Documentar para TASK posterior de actualizacion |

---

## Evidencias a Capturar

1. Listado de archivos en arquitectura/ (antes)
2. Listado de archivos en diseno/arquitectura/ (despues)
3. Output de git status mostrando renames
4. Log log-movimiento-arquitectura.txt
5. Registro registro-movimiento-arquitectura-TASK-014.md

---

## Notas

- Usar SIEMPRE git mv para preservar historial
- Verificar que subdirectorios se muevan correctamente
- Si arquitectura/ no existe, reportar error (no SKIP)
- Documentar TODOS los movimientos
- No eliminar carpeta origen todavia (TASK posterior)
- ADRs y diagramas C4 deben permanecer juntos

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Contenido de arquitectura/ analizado
- [ ] Archivos movidos exitosamente
- [ ] Estructura de subdirectorios preservada
- [ ] Validaciones pasadas
- [ ] Self-Consistency checks OK
- [ ] Evidencias capturadas
- [ ] Registro de movimiento creado
- [ ] Cambios en git staging
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
