---
id: TASK-REORG-BACK-021
tipo: tarea
categoria: consolidacion-diseno
titulo: Mover Archivos Relacionados BD
fase: FASE_2
prioridad: MEDIA
duracion_estimada: 15min
estado: pendiente
dependencias: ["TASK-REORG-BACK-020"]
---

# TASK-REORG-BACK-021: Mover Archivos Relacionados BD

**Fase:** FASE 2 - Consolidacion diseno/
**Prioridad:** MEDIA
**Duracion Estimada:** 15 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Identificar y mover todos los archivos dispersos relacionados con diseno de base de datos a docs/backend/diseno/database/ para consolidacion completa.

---

## Auto-CoT: Razonamiento Paso a Paso

### Pensamiento 1: Donde pueden estar archivos de BD
- **Ubicaciones posibles:**
 - Archivos sueltos en docs/backend/
 - En carpetas de diseno/detallado/
 - En docs/backend/modelos/ (si existe)
 - Diagramas ERD dispersos

### Pensamiento 2: Que archivos buscar
- **Patrones de archivo:**
 - `*.sql` (esquemas, no codigo de migraciones)
 - `*schema*`, `*esquema*`
 - `*erd*`, `*ERD*`
 - `*database*`, `*db*`, `*BD*`
 - `*modelo*`, `*model*`
 - Diagramas: `*.png`, `*.svg` con nombres relacionados a BD

### Pensamiento 3: Como identificar correctamente
- No mover CODIGO (migrations/ del backend)
- Solo DOCUMENTACION de diseno
- Esquemas, diagramas, especificaciones
- Distinguir entre docs y codigo fuente

### Pensamiento 4: Estrategia de busqueda
1. Buscar por patron de nombre de archivo
2. Buscar por extension (.sql, .dbml, etc)
3. Buscar por contenido (grep)
4. Revisar carpetas candidatas manualmente

---

## Prerequisitos

- [ ] TASK-020 completada (database/ verificada)
- [ ] docs/backend/diseno/database/ existe y vacia
- [ ] Backup creado (TASK-001)

---

## Pasos de Ejecucion

### Paso 1: Buscar Archivos SQL (Documentacion, no codigo)
```bash
echo "=== Buscando archivos .sql en docs/backend/ ==="
find docs/backend/ -name "*.sql" -type f 2>/dev/null | grep -v "diseno/database" | sort

# Guardar lista
find docs/backend/ -name "*.sql" -type f 2>/dev/null | grep -v "diseno/database" > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/archivos-sql-encontrados.txt

SQL_COUNT=$(wc -l < docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/archivos-sql-encontrados.txt)
echo "Archivos .sql encontrados: $SQL_COUNT"
```

**Resultado Esperado:** Lista de archivos .sql

### Paso 2: Buscar Archivos con Patrones de BD
```bash
echo "=== Buscando archivos con patrones de BD ==="

# Buscar por nombre
find docs/backend/ -type f \( \
 -iname "*schema*" -o \
 -iname "*esquema*" -o \
 -iname "*erd*" -o \
 -iname "*database*" -o \
 -iname "*modelo*" -o \
 -iname "*model*" \
\) 2>/dev/null | grep -v "diseno/database" | sort > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/archivos-bd-patron.txt

BD_PATTERN_COUNT=$(wc -l < docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/archivos-bd-patron.txt)
echo "Archivos con patron BD: $BD_PATTERN_COUNT"

cat docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/archivos-bd-patron.txt
```

**Resultado Esperado:** Lista de archivos con patrones de BD

### Paso 3: Buscar Diagramas de BD
```bash
echo "=== Buscando diagramas de BD ==="

# Buscar imagenes con nombres relacionados a BD
find docs/backend/ -type f \( -name "*.png" -o -name "*.svg" -o -name "*.jpg" \) 2>/dev/null | \
 grep -iE "(schema|esquema|erd|database|modelo|db)" | \
 grep -v "diseno/database" | sort > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/diagramas-bd.txt

DIAGRAM_COUNT=$(wc -l < docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/diagramas-bd.txt)
echo "Diagramas de BD: $DIAGRAM_COUNT"

cat docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/diagramas-bd.txt
```

**Resultado Esperado:** Lista de diagramas

### Paso 4: Consolidar Lista de Archivos a Mover
```bash
# Combinar todas las listas (sin duplicados)
cat docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/archivos-sql-encontrados.txt \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/archivos-bd-patron.txt \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/diagramas-bd.txt | \
 sort -u > docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/archivos-bd-consolidado.txt

TOTAL_BD=$(wc -l < docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/archivos-bd-consolidado.txt)
echo "Total archivos BD a mover: $TOTAL_BD"

echo "=== Archivos a mover ==="
cat docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/archivos-bd-consolidado.txt
```

**Resultado Esperado:** Lista consolidada sin duplicados

### Paso 5: Revisar Manualmente y Confirmar
```bash
echo "=== IMPORTANTE: Revisar lista antes de mover ==="
echo "Verificar que son DOCUMENTOS, no CODIGO fuente"
echo ""
echo "Presione Enter para continuar con movimiento, o Ctrl+C para cancelar"
# read -p "Confirmar? "
```

**Resultado Esperado:** Revision manual completada

### Paso 6: Mover Archivos a diseno/database/
```bash
# Mover cada archivo usando git mv
if [ -f "docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/archivos-bd-consolidado.txt" ]; then
 while IFS= read -r file; do
 if [ -f "$file" ]; then
 # Obtener nombre base del archivo
 BASENAME=$(basename "$file")

 # Mover con git mv
 echo "Moviendo: $file -> docs/backend/diseno/database/$BASENAME"
 git mv "$file" "docs/backend/diseno/database/$BASENAME" 2>&1 | tee -a \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/log-movimiento-bd.txt
 fi
 done < docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/archivos-bd-consolidado.txt
else
 echo "INFO: No hay archivos para mover"
fi
```

**Resultado Esperado:** Archivos movidos con git mv

### Paso 7: Organizar en Subcarpetas (Opcional)
```bash
# Si hay muchos archivos, organizarlos en subcarpetas
cd docs/backend/diseno/database/

# Crear subcarpetas si no existen
mkdir -p esquemas migraciones modelos erd optimizacion

# Mover archivos a subcarpetas apropiadas
# Esquemas SQL
find . -maxdepth 1 -name "*.sql" -type f -exec git mv {} esquemas/ \; 2>/dev/null

# Diagramas ERD
find . -maxdepth 1 \( -name "*erd*" -o -name "*ERD*" \) -type f -exec git mv {} erd/ \; 2>/dev/null

# Modelos
find . -maxdepth 1 \( -name "*model*" -o -name "*modelo*" \) -type f -exec git mv {} modelos/ \; 2>/dev/null

cd -
```

**Resultado Esperado:** Archivos organizados en subcarpetas

### Paso 8: Verificar Movimiento
```bash
# Contar archivos en destino
MOVED_COUNT=$(find docs/backend/diseno/database/ -type f ! -name ".gitkeep" ! -name "README.md" | wc -l)
echo "Archivos en diseno/database/: $MOVED_COUNT"
echo "Esperado: $TOTAL_BD"

# Verificar en git
git diff --staged --name-status | grep "database" | grep "^R"
```

**Resultado Esperado:** Archivos en destino y en git staging

### Paso 9: Documentar Movimiento
```bash
cat > docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/registro-movimiento-bd-TASK-021.md << EOF
---
tarea: TASK-021
fecha: 2025-11-18
---

# Movimiento de Archivos Relacionados BD -> diseno/database/

## Archivos Identificados

### Archivos .sql
Total: $SQL_COUNT

### Archivos con patron BD
Total: $BD_PATTERN_COUNT

### Diagramas
Total: $DIAGRAM_COUNT

## Total Consolidado (sin duplicados)
Archivos a mover: $TOTAL_BD

## Archivos Movidos
\`\`\`
$(cat docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/archivos-bd-consolidado.txt)
\`\`\`

## Estado Final
Archivos en diseno/database/: $MOVED_COUNT
Git renames: $(git diff --staged --name-status | grep "database" | grep "^R" | wc -l)

## Organizacion
- esquemas/ - Archivos .sql de esquemas
- erd/ - Diagramas ERD
- modelos/ - Documentacion de modelos
- migraciones/ - Docs de migraciones (no codigo)
- optimizacion/ - Indices, performance
EOF

cat docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/registro-movimiento-bd-TASK-021.md
```

**Resultado Esperado:** Registro completo

---

## Criterios de Exito

- [ ] Todos los archivos .sql (docs) identificados
- [ ] Archivos con patrones BD identificados
- [ ] Diagramas de BD identificados
- [ ] Lista consolidada sin duplicados
- [ ] Archivos movidos a diseno/database/
- [ ] Organizados en subcarpetas (opcional)
- [ ] Movimientos en git staging
- [ ] Documentacion completa del movimiento

---

## Validacion

```bash
# Validacion 1: Archivos en destino
DEST=$(find docs/backend/diseno/database/ -type f ! -name ".gitkeep" ! -name "README.md" | wc -l)
if [ "$DEST" -gt 0 ]; then
 echo "OK: $DEST archivos en database/"
else
 echo "INFO: No se encontraron archivos para mover"
fi

# Validacion 2: Git renames
RENAMES=$(git diff --staged --name-status | grep "database" | grep "^R" | wc -l)
echo "Git renames: $RENAMES"

# Validacion 3: No quedan archivos BD dispersos
echo "=== Verificar que no quedan archivos BD fuera de database/ ==="
find docs/backend/ -name "*.sql" -type f 2>/dev/null | grep -v "diseno/database" || echo "OK: No quedan .sql fuera"

# Validacion 4: Estructura de subcarpetas
if [ -d "docs/backend/diseno/database/esquemas" ]; then
 echo "OK: Subcarpeta esquemas/ creada"
fi
if [ -d "docs/backend/diseno/database/erd" ]; then
 echo "OK: Subcarpeta erd/ creada"
fi
```

**Salida Esperada:** Archivos consolidados, git OK

---

## Self-Consistency: Verificacion de Coherencia

### Verificacion 1: Solo Documentacion
- [ ] No se movio codigo fuente de migraciones
- [ ] Solo documentos de diseno
- [ ] Archivos apropiados para docs/

### Verificacion 2: Busqueda Completa
- [ ] Busqueda por extension (.sql, etc)
- [ ] Busqueda por patron de nombre
- [ ] Busqueda de diagramas
- [ ] Revision manual realizada

### Verificacion 3: Organizacion Logica
- [ ] Subcarpetas semanticas
- [ ] Archivos agrupados correctamente
- [ ] Facil navegacion

---

## Rollback

```bash
# Ver archivos movidos
git diff --staged --name-status | grep "database"

# Deshacer movimientos
git reset HEAD docs/backend/diseno/database/
# Resetear archivos origen
git diff --staged --name-status | grep "^R.*database" | awk '{print $3}' | \
 xargs -I {} dirname {} | xargs -I {} git reset HEAD {}

# Restaurar
git checkout HEAD -- docs/backend/diseno/database/
# Y restaurar origenes...
```

**ADVERTENCIA:** Rollback complejo, usar backup

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Mover codigo en vez de docs | MEDIA | ALTO | Revision manual de lista |
| No encontrar todos los archivos | MEDIA | MEDIO | Multiples estrategias de busqueda |
| Archivos con mismo nombre | BAJA | MEDIO | Usar subcarpetas, renombrar si necesario |
| Perder referencias | MEDIA | MEDIO | Documentar, TASK posterior actualizara links |

---

## Evidencias a Capturar

1. archivos-sql-encontrados.txt
2. archivos-bd-patron.txt
3. diagramas-bd.txt
4. archivos-bd-consolidado.txt
5. log-movimiento-bd.txt
6. registro-movimiento-bd-TASK-021.md
7. Output de git status

---

## Notas

- **CRITICO:** Distinguir entre DOCUMENTACION y CODIGO
- No mover carpeta backend/src/migrations/ (es codigo)
- Solo mover DOCS de esquemas, diagramas, especificaciones
- Si hay dudas sobre un archivo, consultar antes de mover
- Usar subcarpetas para organizacion
- Documentar exhaustivamente para trazabilidad
- Esta tarea puede requerir juicio manual

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Archivos .sql (docs) identificados
- [ ] Patrones BD buscados
- [ ] Diagramas identificados
- [ ] Lista consolidada generada
- [ ] Revision manual completada
- [ ] Archivos movidos exitosamente
- [ ] Organizados en subcarpetas
- [ ] Validaciones OK
- [ ] Documentacion completa
- [ ] En git staging
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
