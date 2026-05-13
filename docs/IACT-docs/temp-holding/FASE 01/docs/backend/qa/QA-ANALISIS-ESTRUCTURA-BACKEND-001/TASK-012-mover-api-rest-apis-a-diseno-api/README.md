---
id: TASK-REORG-BACK-012
tipo: tarea
categoria: consolidacion-diseno
titulo: Mover api/ y rest_apis/ a diseno/api/
fase: FASE_2
prioridad: ALTA
duracion_estimada: 10min
estado: pendiente
dependencias: ["TASK-REORG-BACK-011"]
---

# TASK-REORG-BACK-012: Mover api/ y rest_apis/ a diseno/api/

**Fase:** FASE 2 - Consolidacion diseno/
**Prioridad:** ALTA
**Duracion Estimada:** 10 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Consolidar toda la documentacion de diseno de APIs moviendo el contenido de docs/backend/api/ y docs/backend/rest_apis/ a la nueva ubicacion centralizada docs/backend/diseno/api/.

---

## Auto-CoT: Razonamiento Paso a Paso

### Pensamiento 1: Por que consolidar estas carpetas
- **Observacion:** Tenemos api/ y rest_apis/ separadas
- **Problema:** Duplicacion semantica, confusion sobre donde documentar
- **Solucion:** Unificar en diseno/api/ para claridad
- **Resultado:** Una sola fuente de verdad para documentacion de APIs

### Pensamiento 2: Como mover sin perder informacion
- Verificar contenido de ambas carpetas origen
- Identificar posibles conflictos de nombres
- Usar git mv para preservar historial
- Validar que no se pierdan archivos

### Pensamiento 3: Estrategia de consolidacion
- Mover api/* a diseno/api/
- Mover rest_apis/* a diseno/api/
- Si hay conflictos, agregar prefijo descriptivo
- Verificar que carpetas origen quedan vacias

---

## Prerequisitos

- [ ] TASK-011 completada (subcarpetas creadas)
- [ ] docs/backend/diseno/api/ existe y esta vacia
- [ ] Backup creado (TASK-001)
- [ ] Working directory limpio
- [ ] No hay cambios sin commit

---

## Pasos de Ejecucion

### Paso 1: Analizar Contenido Actual
```bash
# Ver contenido de api/
echo "=== Contenido de api/ ==="
find docs/backend/api/ -type f 2>/dev/null | sort

# Ver contenido de rest_apis/
echo "=== Contenido de rest_apis/ ==="
find docs/backend/rest_apis/ -type f 2>/dev/null | sort

# Contar archivos
API_COUNT=$(find docs/backend/api/ -type f 2>/dev/null | wc -l)
REST_COUNT=$(find docs/backend/rest_apis/ -type f 2>/dev/null | wc -l)
echo "Total archivos en api/: $API_COUNT"
echo "Total archivos en rest_apis/: $REST_COUNT"
```

**Resultado Esperado:** Listado completo de archivos a mover

### Paso 2: Verificar Conflictos de Nombres
```bash
# Listar nombres de archivos en ambas carpetas
find docs/backend/api/ -type f -exec basename {} \; | sort > /tmp/api_files.txt
find docs/backend/rest_apis/ -type f -exec basename {} \; | sort > /tmp/rest_apis_files.txt

# Buscar duplicados
comm -12 /tmp/api_files.txt /tmp/rest_apis_files.txt

# Si hay duplicados, documentarlos
comm -12 /tmp/api_files.txt /tmp/rest_apis_files.txt > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/conflictos-nombres-api.txt
```

**Resultado Esperado:** Identificar conflictos si existen

### Paso 3: Mover Contenido de api/
```bash
# Mover todo el contenido de api/ a diseno/api/
if [ -d "docs/backend/api" ] && [ "$(ls -A docs/backend/api)" ]; then
 git mv docs/backend/api/* docs/backend/diseno/api/ 2>&1 | tee -a \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/log-movimiento-api.txt
else
 echo "SKIP: api/ no existe o esta vacia"
fi
```

**Resultado Esperado:** Archivos movidos con git mv

### Paso 4: Mover Contenido de rest_apis/
```bash
# Mover todo el contenido de rest_apis/ a diseno/api/
if [ -d "docs/backend/rest_apis" ] && [ "$(ls -A docs/backend/rest_apis)" ]; then
 git mv docs/backend/rest_apis/* docs/backend/diseno/api/ 2>&1 | tee -a \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/log-movimiento-rest-apis.txt
else
 echo "SKIP: rest_apis/ no existe o esta vacia"
fi
```

**Resultado Esperado:** Archivos movidos con git mv

### Paso 5: Resolver Conflictos (si existen)
```bash
# Si hubo conflictos en Paso 4, resolverlos manualmente
# Ejemplo: renombrar archivos con prefijo
# git mv docs/backend/diseno/api/README.md docs/backend/diseno/api/README-rest-apis.md
```

**Resultado Esperado:** Todos los conflictos resueltos

### Paso 6: Verificar Movimiento Completo
```bash
# Contar archivos en destino
DEST_COUNT=$(find docs/backend/diseno/api/ -type f | wc -l)
echo "Total archivos en diseno/api/: $DEST_COUNT"
echo "Esperado: $((API_COUNT + REST_COUNT))"

# Verificar que carpetas origen estan vacias (ignorar .gitkeep)
echo "=== Verificar api/ vacia ==="
ls -la docs/backend/api/

echo "=== Verificar rest_apis/ vacia ==="
ls -la docs/backend/rest_apis/
```

**Resultado Esperado:** Todos los archivos en destino, origenes vacios

### Paso 7: Verificar Estado de Git
```bash
# Ver cambios en git
git status | grep -E "(renamed|deleted|new file)"

# Ver listado de renames
git status --short | grep "^R"
```

**Resultado Esperado:** Git muestra movimientos como renames

### Paso 8: Documentar Movimiento
```bash
# Crear registro de archivos movidos
cat > docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/registro-movimiento-api-TASK-012.md << 'EOF'
---
tarea: TASK-012
fecha: 2025-11-18
tipo: movimiento
---

# Registro de Movimiento: api/ y rest_apis/ -> diseno/api/

## Archivos Movidos

### Desde api/
$(git diff --staged --name-status | grep "docs/backend/api" | grep "^R")

### Desde rest_apis/
$(git diff --staged --name-status | grep "docs/backend/rest_apis" | grep "^R")

## Totales
- Archivos desde api/: $API_COUNT
- Archivos desde rest_apis/: $REST_COUNT
- Total movidos: $DEST_COUNT
- Conflictos resueltos: $(wc -l < docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/conflictos-nombres-api.txt)

EOF
```

**Resultado Esperado:** Registro completo del movimiento

---

## Criterios de Exito

- [ ] Todos los archivos de api/ movidos a diseno/api/
- [ ] Todos los archivos de rest_apis/ movidos a diseno/api/
- [ ] Carpetas origen (api/, rest_apis/) vacias (solo .gitkeep si existe)
- [ ] Movimientos registrados en git como renames
- [ ] No hay archivos perdidos (conteo coincide)
- [ ] Conflictos de nombres resueltos
- [ ] Documentacion del movimiento generada

---

## Validacion

```bash
# Validacion 1: Verificar que origenes estan vacios
for dir in api rest_apis; do
 COUNT=$(find docs/backend/$dir/ -type f ! -name ".gitkeep" 2>/dev/null | wc -l)
 if [ "$COUNT" -eq 0 ]; then
 echo "OK: $dir/ vacio"
 else
 echo "ERROR: $dir/ todavia tiene $COUNT archivos"
 fi
done

# Validacion 2: Verificar que destino tiene archivos
DEST_COUNT=$(find docs/backend/diseno/api/ -type f ! -name ".gitkeep" | wc -l)
if [ "$DEST_COUNT" -gt 0 ]; then
 echo "OK: diseno/api/ tiene $DEST_COUNT archivos"
else
 echo "ERROR: diseno/api/ esta vacio"
fi

# Validacion 3: Verificar renames en git
RENAME_COUNT=$(git diff --staged --name-status | grep "^R" | wc -l)
echo "Archivos registrados como rename: $RENAME_COUNT"

# Validacion 4: Verificar que no hay archivos sin staging
UNSTAGED=$(git ls-files --others --exclude-standard docs/backend/diseno/api/ | wc -l)
if [ "$UNSTAGED" -eq 0 ]; then
 echo "OK: Todos los archivos en staging"
else
 echo "WARNING: $UNSTAGED archivos sin staging"
fi
```

**Salida Esperada:**
- Carpetas origen vacias
- Carpeta destino poblada
- Movimientos en git staging
- Sin archivos huerfanos

---

## Self-Consistency: Verificacion de Coherencia

### Verificacion 1: Integridad de Archivos
- [ ] Numero de archivos origen = numero de archivos destino
- [ ] No hay archivos duplicados en destino
- [ ] Nombres de archivos preservados (o conflictos resueltos)

### Verificacion 2: Coherencia con Plan
- [ ] Coincide con MAPEO-MIGRACION-BACKEND
- [ ] Ubicacion destino correcta (diseno/api/)
- [ ] Carpetas origen segun especificacion

### Verificacion 3: Estado de Git
- [ ] Todos los movimientos son renames (no delete + add)
- [ ] No hay archivos untracked inesperados
- [ ] Working tree limpio excepto staged changes

---

## Rollback

Si se necesita deshacer:
```bash
# Ver cambios staged
git diff --staged --name-status | grep "^R"

# Deshacer movimientos (antes de commit)
git reset HEAD docs/backend/diseno/api/
git reset HEAD docs/backend/api/
git reset HEAD docs/backend/rest_apis/

# Restaurar archivos a ubicaciones originales
git checkout HEAD -- docs/backend/api/
git checkout HEAD -- docs/backend/rest_apis/
git checkout HEAD -- docs/backend/diseno/api/

# Verificar rollback
git status
```

**ADVERTENCIA:** Solo ejecutar rollback ANTES de hacer commit

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Conflictos de nombres | MEDIA | MEDIO | Detectar en Paso 2, resolver manualmente |
| Perdida de archivos | BAJA | CRITICO | Validar conteo antes y despues |
| Historial git perdido | BAJA | MEDIO | Usar git mv siempre, nunca cp + rm |
| Archivos sin staging | BAJA | BAJO | Verificar git status al final |
| Permisos insuficientes | MUY BAJA | MEDIO | Verificar permisos de escritura antes |

---

## Evidencias a Capturar

1. Listado de archivos en api/ y rest_apis/ (antes)
2. Listado de archivos en diseno/api/ (despues)
3. Output de git status mostrando renames
4. Archivo conflictos-nombres-api.txt (si aplica)
5. Logs de movimiento (log-movimiento-api.txt, log-movimiento-rest-apis.txt)
6. Registro completo en registro-movimiento-api-TASK-012.md

---

## Notas

- Usar SIEMPRE git mv para preservar historial
- Si una carpeta origen no existe, SKIP sin error
- Si una carpeta origen esta vacia, SKIP sin error
- Los conflictos de nombres deben resolverse manualmente
- Documentar TODOS los movimientos para trazabilidad
- No eliminar carpetas origen todavia (TASK posterior)
- Si hay .gitkeep en origen, dejarlo (no mover)

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Contenido analizado y documentado
- [ ] Conflictos de nombres identificados y resueltos
- [ ] Archivos de api/ movidos exitosamente
- [ ] Archivos de rest_apis/ movidos exitosamente
- [ ] Validaciones pasadas (conteo, git status)
- [ ] Self-Consistency checks OK
- [ ] Evidencias capturadas
- [ ] Registro de movimiento creado
- [ ] Cambios en git staging (no committed)
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
