---
id: TASK-REORG-BACK-016
tipo: tarea
categoria: consolidacion-diseno
titulo: Mover permisos/ a diseno/permisos/
fase: FASE_2
prioridad: ALTA
duracion_estimada: 5min
estado: pendiente
dependencias: ["TASK-REORG-BACK-011"]
---

# TASK-REORG-BACK-016: Mover permisos/ a diseno/permisos/

**Fase:** FASE 2 - Consolidacion diseno/
**Prioridad:** ALTA
**Duracion Estimada:** 5 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Mover toda la documentacion del sistema de permisos de docs/backend/permisos/ a docs/backend/diseno/permisos/ para consolidar diseno.

---

## Auto-CoT: Razonamiento Paso a Paso

### Pensamiento 1: Naturaleza de permisos/
- **Observacion:** permisos/ contiene diseno del sistema de autorizacion
- **Razonamiento:** Diseno de permisos es parte del diseno arquitectonico
- **Conclusion:** Debe estar bajo diseno/ para coherencia
- **Beneficio:** Todos los disenos centralizados

### Pensamiento 2: Importancia de permisos
- Sistema de permisos es critico para seguridad
- Roles, politicas y reglas de acceso
- Documentacion debe ser facil de encontrar
- Relacion con arquitectura y APIs

---

## Prerequisitos

- [ ] TASK-011 completada
- [ ] docs/backend/diseno/permisos/ existe y vacia
- [ ] docs/backend/permisos/ existe con contenido
- [ ] Backup creado

---

## Pasos de Ejecucion

### Paso 1: Analizar Contenido
```bash
echo "=== Contenido de permisos/ ==="
find docs/backend/permisos/ -type f 2>/dev/null | sort

FILES=$(find docs/backend/permisos/ -type f 2>/dev/null | wc -l)
echo "Total archivos: $FILES"
```

**Resultado Esperado:** Inventario de archivos

### Paso 2: Verificar Destino Vacio
```bash
DEST=$(find docs/backend/diseno/permisos/ -type f ! -name ".gitkeep" 2>/dev/null | wc -l)
[ "$DEST" -eq 0 ] && echo "OK: Destino vacio" || { echo "ERROR: Destino tiene archivos"; exit 1; }
```

**Resultado Esperado:** Destino vacio

### Paso 3: Mover Contenido
```bash
if [ -d "docs/backend/permisos" ] && [ "$(ls -A docs/backend/permisos)" ]; then
 git mv docs/backend/permisos/* docs/backend/diseno/permisos/ 2>&1 | tee \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/log-movimiento-permisos.txt
else
 echo "ERROR: permisos/ no existe o vacia"
 exit 1
fi
```

**Resultado Esperado:** Archivos movidos

### Paso 4: Verificar Movimiento
```bash
DEST_COUNT=$(find docs/backend/diseno/permisos/ -type f | wc -l)
echo "Archivos en destino: $DEST_COUNT / Esperado: $FILES"

ORIGEN=$(find docs/backend/permisos/ -type f ! -name ".gitkeep" 2>/dev/null | wc -l)
[ "$ORIGEN" -eq 0 ] && echo "OK: Origen vacio" || echo "WARN: Origen tiene $ORIGEN archivos"
```

**Resultado Esperado:** Archivos en destino, origen vacio

### Paso 5: Documentar
```bash
cat > docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/registro-movimiento-permisos-TASK-016.md << EOF
---
tarea: TASK-016
fecha: 2025-11-18
---

# Movimiento: permisos/ -> diseno/permisos/

## Totales
- Archivos origen: $FILES
- Archivos destino: $DEST_COUNT
- Status: $([ "$FILES" -eq "$DEST_COUNT" ] && echo "OK" || echo "REVISAR")

## Git
\`\`\`
$(git diff --staged --name-status | grep "permisos" | grep "^R")
\`\`\`
EOF
```

**Resultado Esperado:** Registro creado

---

## Criterios de Exito

- [ ] Archivos movidos a diseno/permisos/
- [ ] Origen vacio
- [ ] Git renames registrados
- [ ] Conteo coincide
- [ ] Documentacion generada

---

## Validacion

```bash
# Origen vacio
COUNT=$(find docs/backend/permisos/ -type f ! -name ".gitkeep" 2>/dev/null | wc -l)
[ "$COUNT" -eq 0 ] && echo "OK: Origen vacio" || echo "ERROR: $COUNT archivos restantes"

# Destino poblado
DEST=$(find docs/backend/diseno/permisos/ -type f ! -name ".gitkeep" | wc -l)
[ "$DEST" -gt 0 ] && echo "OK: $DEST archivos en destino" || echo "ERROR: Destino vacio"

# Git status
git diff --staged --name-status | grep "permisos" | grep "^R" && echo "OK: Renames detectados"
```

**Salida Esperada:** Todas las validaciones OK

---

## Self-Consistency

- [ ] Conteo origen = destino
- [ ] Git muestra renames
- [ ] Coherente con plan

---

## Rollback

```bash
git reset HEAD docs/backend/diseno/permisos/
git reset HEAD docs/backend/permisos/
git checkout HEAD -- docs/backend/permisos/
git checkout HEAD -- docs/backend/diseno/permisos/
```

---

## Notas

- Usar git mv siempre
- Documentar para trazabilidad
- No eliminar carpeta origen aun

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
- [ ] En git staging
- [ ] Marcada COMPLETADA

---

**Tarea creada:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
