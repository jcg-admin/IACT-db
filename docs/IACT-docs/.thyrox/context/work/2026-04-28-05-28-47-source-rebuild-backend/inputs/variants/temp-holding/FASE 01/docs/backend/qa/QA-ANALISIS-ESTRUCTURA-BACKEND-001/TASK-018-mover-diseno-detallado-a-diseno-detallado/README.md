---
id: TASK-REORG-BACK-018
tipo: tarea
categoria: consolidacion-diseno
titulo: Mover diseno_detallado/ a diseno/detallado/
fase: FASE_2
prioridad: ALTA
duracion_estimada: 5min
estado: pendiente
dependencias: ["TASK-REORG-BACK-011"]
---

# TASK-REORG-BACK-018: Mover diseno_detallado/ a diseno/detallado/

**Fase:** FASE 2 - Consolidacion diseno/
**Prioridad:** ALTA
**Duracion Estimada:** 5 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Mover docs/backend/diseno_detallado/ a docs/backend/diseno/detallado/ consolidando documentacion de diseno detallado y simplificando nombre de carpeta.

---

## Auto-CoT: Razonamiento Paso a Paso

### Pensamiento 1: Por que renombrar
- **Observacion:** diseno_detallado/ tiene guion bajo
- **Problema:** Inconsistente con convencion de nombres
- **Solucion:** Renombrar a detallado/ bajo diseno/
- **Beneficio:** Consistencia y jerarquia clara

### Pensamiento 2: Diseno detallado vs alto nivel
- Diseno detallado complementa arquitectura
- Especificaciones tecnicas granulares
- Documentacion de componentes especificos
- Debe estar bajo diseno/ para coherencia

---

## Prerequisitos

- [ ] TASK-011 completada
- [ ] docs/backend/diseno/detallado/ existe y vacia
- [ ] docs/backend/diseno_detallado/ existe
- [ ] Backup creado

---

## Pasos de Ejecucion

### Paso 1: Analizar Contenido
```bash
echo "=== Contenido de diseno_detallado/ ==="
find docs/backend/diseno_detallado/ -type f 2>/dev/null | sort

FILES=$(find docs/backend/diseno_detallado/ -type f 2>/dev/null | wc -l)
DIRS=$(find docs/backend/diseno_detallado/ -mindepth 1 -type d 2>/dev/null | wc -l)
echo "Archivos: $FILES, Subdirectorios: $DIRS"
```

**Resultado Esperado:** Inventario completo

### Paso 2: Verificar Destino
```bash
DEST=$(find docs/backend/diseno/detallado/ -type f ! -name ".gitkeep" 2>/dev/null | wc -l)
[ "$DEST" -eq 0 ] && echo "OK: Destino vacio" || { echo "ERROR: Destino tiene archivos"; exit 1; }
```

**Resultado Esperado:** Destino vacio

### Paso 3: Mover Contenido
```bash
if [ -d "docs/backend/diseno_detallado" ] && [ "$(ls -A docs/backend/diseno_detallado)" ]; then
 git mv docs/backend/diseno_detallado/* docs/backend/diseno/detallado/ 2>&1 | tee \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/log-movimiento-diseno-detallado.txt
else
 echo "ERROR: diseno_detallado/ no existe o vacia"
 exit 1
fi
```

**Resultado Esperado:** Archivos movidos

### Paso 4: Verificar Movimiento
```bash
DEST_COUNT=$(find docs/backend/diseno/detallado/ -type f | wc -l)
echo "Destino: $DEST_COUNT / Esperado: $FILES"

ORIGEN=$(find docs/backend/diseno_detallado/ -type f ! -name ".gitkeep" 2>/dev/null | wc -l)
[ "$ORIGEN" -eq 0 ] && echo "OK: Origen vacio" || echo "WARN: $ORIGEN archivos restantes"
```

**Resultado Esperado:** Conteo coincide

### Paso 5: Verificar Git
```bash
git diff --staged --name-status | grep "diseno" | grep "^R"
RENAMES=$(git diff --staged --name-status | grep "^R" | grep "diseno" | wc -l)
echo "Renames detectados: $RENAMES"
```

**Resultado Esperado:** Renames en git

### Paso 6: Documentar
```bash
cat > docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/registro-movimiento-diseno-detallado-TASK-018.md << EOF
---
tarea: TASK-018
fecha: 2025-11-18
---

# Movimiento: diseno_detallado/ -> diseno/detallado/

## Totales
- Archivos: $FILES
- Subdirectorios: $DIRS
- Movidos: $DEST_COUNT
- Status: $([ "$FILES" -eq "$DEST_COUNT" ] && echo "OK" || echo "REVISAR")

## Git Renames
\`\`\`
$(git diff --staged --name-status | grep "diseno" | grep "^R")
\`\`\`
EOF
```

**Resultado Esperado:** Registro creado

---

## Criterios de Exito

- [ ] Archivos movidos a diseno/detallado/
- [ ] Estructura preservada
- [ ] Origen vacio
- [ ] Git renames
- [ ] Documentacion generada

---

## Validacion

```bash
# Origen vacio
COUNT=$(find docs/backend/diseno_detallado/ -type f ! -name ".gitkeep" 2>/dev/null | wc -l)
[ "$COUNT" -eq 0 ] && echo "OK: Origen vacio" || echo "ERROR: $COUNT archivos"

# Destino poblado
DEST=$(find docs/backend/diseno/detallado/ -type f ! -name ".gitkeep" | wc -l)
[ "$DEST" -gt 0 ] && echo "OK: $DEST archivos" || echo "ERROR: Destino vacio"

# Git renames
git diff --staged --name-status | grep "^R" | grep "detallado" && echo "OK: Renames"
```

**Salida Esperada:** Validaciones OK

---

## Self-Consistency

- [ ] Conteo origen = destino
- [ ] Estructura preservada
- [ ] Git renames correctos
- [ ] Nombre simplificado (sin guion bajo)

---

## Rollback

```bash
git reset HEAD docs/backend/diseno/detallado/
git reset HEAD docs/backend/diseno_detallado/
git checkout HEAD -- docs/backend/diseno_detallado/
git checkout HEAD -- docs/backend/diseno/detallado/
```

---

## Notas

- Simplifica nombre (diseno_detallado -> detallado)
- Jerarquia mas clara bajo diseno/
- No eliminar carpeta origen todavia

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Archivos movidos
- [ ] Validaciones OK
- [ ] Registro creado
- [ ] En staging
- [ ] Marcada COMPLETADA

---

**Tarea creada:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
