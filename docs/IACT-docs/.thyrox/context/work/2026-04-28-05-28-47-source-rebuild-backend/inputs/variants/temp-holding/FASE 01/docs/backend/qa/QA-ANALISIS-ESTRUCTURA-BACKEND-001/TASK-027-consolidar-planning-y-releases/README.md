---
id: TASK-REORG-BACK-027
tipo: tarea
categoria: consolidacion
titulo: Consolidar planning/ y planificacion_y_releases/
fase: FASE_3
prioridad: ALTA
duracion_estimada: 15min
estado: pendiente
dependencias: ["TASK-REORG-BACK-026"]
---

# TASK-REORG-BACK-027: Consolidar planning/ y planificacion_y_releases/

**Fase:** FASE 3 - Consolidacion
**Prioridad:** ALTA
**Duracion Estimada:** 15 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Consolidar el contenido de docs/backend/planning/ y docs/backend/planificacion_y_releases/ en las subcarpetas docs/backend/planificacion/planning/ y docs/backend/planificacion/releases/, organizando por tipo de planificacion.

---

## Prerequisitos

- [ ] TASK-026 completada (feasibility/ movido)
- [ ] Carpetas planning/ y planificacion_y_releases/ existen
- [ ] Subcarpetas planificacion/planning/ y planificacion/releases/ existen
- [ ] Working directory limpio

---

## Pasos de Ejecucion

### Paso 1: Inventariar Contenido de planning/
```bash
# Listar contenido de planning/
find docs/backend/planning/ -type f

# Contar archivos
echo "Total archivos en planning/: $(find docs/backend/planning/ -type f | wc -l)"
```

**Resultado Esperado:** Listado completo de archivos en planning/

### Paso 2: Inventariar Contenido de planificacion_y_releases/
```bash
# Listar contenido de planificacion_y_releases/
find docs/backend/planificacion_y_releases/ -type f

# Contar archivos
echo "Total archivos en planificacion_y_releases/: $(find docs/backend/planificacion_y_releases/ -type f | wc -l)"
```

**Resultado Esperado:** Listado completo de archivos en planificacion_y_releases/

### Paso 3: Analizar y Clasificar Contenido
```bash
# Crear analisis de contenido
echo "=== ANALISIS DE CONTENIDO ===" > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/analisis-planning-releases.txt

echo "Archivos en planning/:" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/analisis-planning-releases.txt
find docs/backend/planning/ -type f >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/analisis-planning-releases.txt

echo -e "\nArchivos en planificacion_y_releases/:" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/analisis-planning-releases.txt
find docs/backend/planificacion_y_releases/ -type f >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/analisis-planning-releases.txt
```

**Resultado Esperado:** Archivo analisis-planning-releases.txt creado

### Paso 4: Mover Contenido de planning/
```bash
# Mover todo planning/ a planificacion/planning/
mv docs/backend/planning/* docs/backend/planificacion/planning/

# Verificar movimiento
echo "Archivos movidos de planning/: $(find docs/backend/planificacion/planning/ -type f | wc -l)"
```

**Resultado Esperado:** Contenido de planning/ movido

### Paso 5: Procesar planificacion_y_releases/
```bash
# Identificar archivos relacionados con releases
# (asumiendo que tienen "release" en el nombre o path)
find docs/backend/planificacion_y_releases/ -type f -iname "*release*" | \
 while read file; do
 mv "$file" docs/backend/planificacion/releases/
 done

# Mover el resto a planning/
find docs/backend/planificacion_y_releases/ -type f | \
 while read file; do
 mv "$file" docs/backend/planificacion/planning/
 done
```

**Resultado Esperado:** Contenido clasificado y movido segun tipo

### Paso 6: Eliminar Carpetas Origen
```bash
# Eliminar planning/ vieja
rm -rf docs/backend/planning/

# Eliminar planificacion_y_releases/ vieja
rm -rf docs/backend/planificacion_y_releases/

# Verificar eliminacion
ls -d docs/backend/planning/ docs/backend/planificacion_y_releases/ 2>/dev/null || \
 echo "Carpetas origen eliminadas OK"
```

**Resultado Esperado:** Ambas carpetas origen eliminadas

### Paso 7: Verificar Contenido Consolidado
```bash
# Contar archivos en destinos
echo "Archivos en planificacion/planning/: $(find docs/backend/planificacion/planning/ -type f ! -name '.gitkeep' | wc -l)"
echo "Archivos en planificacion/releases/: $(find docs/backend/planificacion/releases/ -type f ! -name '.gitkeep' | wc -l)"

# Verificar total
total_origen=$(($(find docs/backend/planning/ -type f 2>/dev/null | wc -l) + $(find docs/backend/planificacion_y_releases/ -type f 2>/dev/null | wc -l)))
total_destino=$(($(find docs/backend/planificacion/planning/ -type f ! -name '.gitkeep' | wc -l) + $(find docs/backend/planificacion/releases/ -type f ! -name '.gitkeep' | wc -l)))

echo "Total origen (antes): almacenar manualmente"
echo "Total destino (despues): $total_destino"
```

**Resultado Esperado:** Todos los archivos contabilizados

### Paso 8: Documentar Consolidacion
```bash
# Crear reporte final
echo "=== CONSOLIDACION COMPLETADA ===" > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/consolidacion-planning-releases.txt

echo "Archivos en planificacion/planning/:" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/consolidacion-planning-releases.txt
find docs/backend/planificacion/planning/ -type f >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/consolidacion-planning-releases.txt

echo -e "\nArchivos en planificacion/releases/:" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/consolidacion-planning-releases.txt
find docs/backend/planificacion/releases/ -type f >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/consolidacion-planning-releases.txt
```

**Resultado Esperado:** Archivo consolidacion-planning-releases.txt creado

---

## Criterios de Exito

- [ ] Todo el contenido de planning/ consolidado en planificacion/planning/
- [ ] Contenido de planificacion_y_releases/ clasificado correctamente
- [ ] Archivos de releases en planificacion/releases/
- [ ] Archivos de planning en planificacion/planning/
- [ ] Carpetas origen eliminadas
- [ ] No hay perdida de archivos
- [ ] Consolidacion documentada

---

## Validacion

```bash
# Verificar que origenes no existen
for dir in planning planificacion_y_releases; do
 if [ -d "docs/backend/$dir" ]; then
 echo "ERROR: docs/backend/$dir todavia existe"
 else
 echo "OK: docs/backend/$dir eliminado"
 fi
done

# Verificar que destinos tienen contenido
for subdir in planning releases; do
 count=$(find docs/backend/planificacion/$subdir/ -type f ! -name '.gitkeep' | wc -l)
 if [ $count -gt 0 ]; then
 echo "OK: planificacion/$subdir tiene $count archivos"
 else
 echo "WARN: planificacion/$subdir esta vacio"
 fi
done

# Verificar estructura completa
tree -L 2 docs/backend/planificacion/
```

**Salida Esperada:** Origenes eliminados, destinos con contenido

---

## Rollback

Si se necesita deshacer:
```bash
# Recrear carpetas origen
mkdir -p docs/backend/planning/
mkdir -p docs/backend/planificacion_y_releases/

# Mover contenido de vuelta desde planning/
mv docs/backend/planificacion/planning/* docs/backend/planning/

# Mover contenido de vuelta desde releases/
mv docs/backend/planificacion/releases/* docs/backend/planificacion_y_releases/

# Limpiar destinos
rm -rf docs/backend/planificacion/planning/*
rm -rf docs/backend/planificacion/releases/*
touch docs/backend/planificacion/planning/.gitkeep
touch docs/backend/planificacion/releases/.gitkeep
```

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Clasificacion incorrecta releases vs planning | MEDIA | MEDIO | Revisar manualmente archivos con "release" en nombre |
| Perdida de archivos | MUY BAJA | CRITICO | Contar archivos antes/despues, tener backup |
| Conflictos de nombres | BAJA | MEDIO | Verificar duplicados antes de mover |
| Estructura interna no preservada | BAJA | ALTO | Usar mv recursivo correctamente |

---

## Evidencias a Capturar

1. Archivo `analisis-planning-releases.txt` (antes)
2. Archivo `consolidacion-planning-releases.txt` (despues)
3. Output de validacion de conteos
4. Output de `tree docs/backend/planificacion/`

---

## Auto-CoT: Razonamiento Paso a Paso

**Chain of Thought 1:**
1. planning/ contiene planificacion general de proyectos
2. planificacion_y_releases/ mezcla planning + releases
3. Necesidad de separar por tipo de contenido
4. Archivos con "release" van a releases/
5. El resto va a planning/
6. Resultado: contenido clasificado correctamente

**Chain of Thought 2:**
1. Objetivo: consolidar en planificacion/
2. Fuentes: planning/ + planificacion_y_releases/
3. Destinos: planificacion/planning/ + planificacion/releases/
4. Criterio de clasificacion: nombre/path con "release"
5. Mover y eliminar origenes

**Chain of Thought 3:**
1. Analizar contenido de ambas carpetas origen
2. Identificar patrones de clasificacion
3. Mover planning/ completo a planificacion/planning/
4. Clasificar planificacion_y_releases/ dinamicamente
5. Validar con conteos y estructura

**Self-Consistency:** Los 3 razonamientos convergen en consolidar ambas carpetas clasificando por tipo de contenido

---

## Notas

- Esta tarea requiere clasificacion manual si hay ambiguedad
- Archivos con "release" en nombre/path van a releases/
- El resto va a planning/ por defecto
- Revisar manualmente si hay contenido critico en planificacion_y_releases/
- Duracion estimada incluye tiempo de revision

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Inventario de planning/ documentado
- [ ] Inventario de planificacion_y_releases/ documentado
- [ ] Contenido de planning/ movido a planificacion/planning/
- [ ] Contenido de planificacion_y_releases/ clasificado y movido
- [ ] Ambas carpetas origen eliminadas
- [ ] Conteo de archivos verificado
- [ ] Consolidacion documentada
- [ ] Validacion exitosa
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
