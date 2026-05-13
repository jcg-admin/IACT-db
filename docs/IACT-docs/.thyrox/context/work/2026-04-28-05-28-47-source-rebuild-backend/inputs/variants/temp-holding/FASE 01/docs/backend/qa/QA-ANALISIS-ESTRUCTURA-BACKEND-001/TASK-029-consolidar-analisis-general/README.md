---
id: TASK-REORG-BACK-029
tipo: tarea
categoria: consolidacion
titulo: Consolidar analisis/ General
fase: FASE_3
prioridad: MEDIA
duracion_estimada: 20min
estado: pendiente
dependencias: ["TASK-REORG-BACK-028"]
---

# TASK-REORG-BACK-029: Consolidar analisis/ General

**Fase:** FASE 3 - Consolidacion
**Prioridad:** MEDIA
**Duracion Estimada:** 20 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Analizar y consolidar el contenido de docs/backend/analisis/ clasificandolo entre planificacion/analisis_negocio/, planificacion/feasibility/, o manteniendo una carpeta analisis/ independiente si contiene analisis tecnicos que no corresponden a planificacion.

---

## Prerequisitos

- [ ] TASK-028 completada (analisis_negocio/ movido)
- [ ] Carpeta docs/backend/analisis/ existe
- [ ] Subcarpetas en planificacion/ disponibles
- [ ] Working directory limpio

---

## Pasos de Ejecucion

### Paso 1: Inventariar y Analizar Contenido de analisis/
```bash
# Ver contenido completo con detalles
find docs/backend/analisis/ -type f -exec ls -lh {} \;

# Ver estructura
tree docs/backend/analisis/

# Contar archivos
echo "Total archivos: $(find docs/backend/analisis/ -type f | wc -l)"

# Buscar patrones de contenido
echo -e "\n=== Analisis de nombres de archivos ==="
find docs/backend/analisis/ -type f -name "*negocio*"
find docs/backend/analisis/ -type f -name "*feasibility*" -o -name "*viabilidad*"
find docs/backend/analisis/ -type f -name "*tecnico*" -o -name "*arquitectura*"
```

**Resultado Esperado:** Inventario detallado con patrones identificados

### Paso 2: Clasificar Contenido Manualmente
```bash
# Crear archivo de clasificacion para revision manual
echo "=== CLASIFICACION CONTENIDO analisis/ ===" > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/clasificacion-analisis.txt

echo -e "\n[A_REVISAR] Archivos encontrados:" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/clasificacion-analisis.txt
find docs/backend/analisis/ -type f >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/clasificacion-analisis.txt

echo -e "\n[INSTRUCCIONES]" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/clasificacion-analisis.txt
echo "- Archivos de requisitos/negocio -> planificacion/analisis_negocio/" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/clasificacion-analisis.txt
echo "- Archivos de viabilidad/feasibility -> planificacion/feasibility/" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/clasificacion-analisis.txt
echo "- Archivos tecnicos/arquitectura -> mantener en analisis/ o mover a arquitectura/" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/clasificacion-analisis.txt
```

**Resultado Esperado:** Archivo de clasificacion creado para revision

### Paso 3: Identificar Subcarpetas en analisis/
```bash
# Listar subcarpetas
find docs/backend/analisis/ -mindepth 1 -type d

# Analizar contenido de cada subcarpeta
for dir in $(find docs/backend/analisis/ -mindepth 1 -type d); do
 echo "=== $dir ==="
 ls -la "$dir"
 echo ""
done
```

**Resultado Esperado:** Estructura de subcarpetas identificada

### Paso 4: Ejecutar Consolidacion Basica (Auto-clasificacion)
```bash
# Crear carpetas de trabajo temporal
mkdir -p /tmp/clasificacion-analisis/{negocio,feasibility,tecnico}

# Auto-clasificar por patrones de nombre
find docs/backend/analisis/ -type f -iname "*negocio*" -o -iname "*requisito*" -o -iname "*requirement*" | \
 while read file; do
 echo "NEGOCIO: $file" >> docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/clasificacion-auto.txt
 done

find docs/backend/analisis/ -type f -iname "*feasibility*" -o -iname "*viabilidad*" -o -iname "*factibilidad*" | \
 while read file; do
 echo "FEASIBILITY: $file" >> docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/clasificacion-auto.txt
 done

find docs/backend/analisis/ -type f -iname "*tecnico*" -o -iname "*arquitectura*" -o -iname "*technical*" | \
 while read file; do
 echo "TECNICO: $file" >> docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/clasificacion-auto.txt
 done
```

**Resultado Esperado:** Archivos clasificados automaticamente por patrones

### Paso 5: Mover Contenido Clasificado
```bash
# Mover archivos de negocio
find docs/backend/analisis/ -type f -iname "*negocio*" -o -iname "*requisito*" | \
 while read file; do
 mv "$file" docs/backend/planificacion/analisis_negocio/
 done

# Mover archivos de feasibility
find docs/backend/analisis/ -type f -iname "*feasibility*" -o -iname "*viabilidad*" | \
 while read file; do
 mv "$file" docs/backend/planificacion/feasibility/
 done

# Contar archivos restantes
remaining=$(find docs/backend/analisis/ -type f | wc -l)
echo "Archivos restantes en analisis/: $remaining"
```

**Resultado Esperado:** Archivos clasificados movidos, algunos pueden quedar en analisis/

### Paso 6: Decidir sobre Carpeta analisis/ Restante
```bash
# Verificar si quedan archivos
remaining=$(find docs/backend/analisis/ -type f ! -name '.gitkeep' | wc -l)

if [ $remaining -eq 0 ]; then
 echo "analisis/ vacio, se eliminara"
 rm -rf docs/backend/analisis/
else
 echo "analisis/ tiene $remaining archivos restantes, se mantiene"
 echo "DECISION: Mantener analisis/ para contenido tecnico/arquitectura" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/decision-analisis.txt
 find docs/backend/analisis/ -type f >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/decision-analisis.txt
fi
```

**Resultado Esperado:** Decision documentada sobre analisis/

### Paso 7: Validar Consolidacion
```bash
# Contar archivos en destinos
echo "=== RESUMEN CONSOLIDACION ===" > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/resumen-consolidacion-analisis.txt

echo "Archivos en planificacion/analisis_negocio/:" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/resumen-consolidacion-analisis.txt
find docs/backend/planificacion/analisis_negocio/ -type f ! -name '.gitkeep' | wc -l >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/resumen-consolidacion-analisis.txt

echo -e "\nArchivos en planificacion/feasibility/:" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/resumen-consolidacion-analisis.txt
find docs/backend/planificacion/feasibility/ -type f ! -name '.gitkeep' | wc -l >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/resumen-consolidacion-analisis.txt

echo -e "\nArchivos restantes en analisis/ (si existe):" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/resumen-consolidacion-analisis.txt
find docs/backend/analisis/ -type f ! -name '.gitkeep' 2>/dev/null | wc -l >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/resumen-consolidacion-analisis.txt || echo "0" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/resumen-consolidacion-analisis.txt
```

**Resultado Esperado:** Resumen completo de consolidacion

### Paso 8: Documentar Decisiones y Movimientos
```bash
# Crear reporte final completo
echo "=== CONSOLIDACION analisis/ COMPLETADA ===" > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/consolidacion-analisis-final.txt

echo -e "\nArchivos movidos a planificacion/analisis_negocio/:" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/consolidacion-analisis-final.txt
find docs/backend/planificacion/analisis_negocio/ -type f -newer docs/backend/qa/ >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/consolidacion-analisis-final.txt 2>/dev/null || echo "Ver inventario completo" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/consolidacion-analisis-final.txt

echo -e "\nArchivos movidos a planificacion/feasibility/:" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/consolidacion-analisis-final.txt
find docs/backend/planificacion/feasibility/ -type f -newer docs/backend/qa/ >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/consolidacion-analisis-final.txt 2>/dev/null || echo "Ver inventario completo" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/consolidacion-analisis-final.txt

cat docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/resumen-consolidacion-analisis.txt
```

**Resultado Esperado:** Documentacion completa de la consolidacion

---

## Criterios de Exito

- [ ] Contenido de analisis/ inventariado completamente
- [ ] Archivos clasificados por tipo (negocio, feasibility, tecnico)
- [ ] Archivos de negocio movidos a planificacion/analisis_negocio/
- [ ] Archivos de feasibility movidos a planificacion/feasibility/
- [ ] Decision documentada sobre archivos tecnicos restantes
- [ ] Carpeta analisis/ eliminada o justificada su permanencia
- [ ] No hay perdida de archivos
- [ ] Consolidacion documentada completamente

---

## Validacion

```bash
# Verificar clasificacion completa
total_original=$(cat docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/clasificacion-analisis.txt | grep "docs/backend/analisis/" | wc -l)
echo "Total archivos originales: $total_original"

# Contar archivos movidos + restantes
movidos_negocio=$(grep "NEGOCIO:" docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/clasificacion-auto.txt 2>/dev/null | wc -l)
movidos_feasibility=$(grep "FEASIBILITY:" docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/clasificacion-auto.txt 2>/dev/null | wc -l)
restantes=$(find docs/backend/analisis/ -type f ! -name '.gitkeep' 2>/dev/null | wc -l)

echo "Movidos a negocio: $movidos_negocio"
echo "Movidos a feasibility: $movidos_feasibility"
echo "Restantes en analisis/: $restantes"
echo "Total contabilizado: $((movidos_negocio + movidos_feasibility + restantes))"

# Verificar estructura final
tree -L 2 docs/backend/planificacion/
if [ -d "docs/backend/analisis" ]; then
 tree docs/backend/analisis/
fi
```

**Salida Esperada:** Todos los archivos contabilizados, ninguno perdido

---

## Rollback

Si se necesita deshacer:
```bash
# Recrear carpeta analisis/ si fue eliminada
mkdir -p docs/backend/analisis/

# Mover archivos de vuelta (identificar por timestamp o metadata)
# NOTA: Rollback complejo, usar backup de git si es necesario

# Alternativa: usar git
git checkout HEAD -- docs/backend/analisis/
git checkout HEAD -- docs/backend/planificacion/analisis_negocio/
git checkout HEAD -- docs/backend/planificacion/feasibility/
```

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Clasificacion incorrecta de archivos | MEDIA | ALTO | Revisar manualmente archivos ambiguos |
| Perdida de archivos | MUY BAJA | CRITICO | Contar antes/despues, tener backup |
| Archivos con multiples categorias | MEDIA | MEDIO | Priorizar categoria mas relevante |
| Contenido tecnico en analisis/ | ALTA | BAJO | Documentar decision de mantener/mover |

---

## Evidencias a Capturar

1. Archivo `clasificacion-analisis.txt` (inventario inicial)
2. Archivo `clasificacion-auto.txt` (clasificacion automatica)
3. Archivo `decision-analisis.txt` (decision sobre carpeta restante)
4. Archivo `resumen-consolidacion-analisis.txt` (resumen final)
5. Archivo `consolidacion-analisis-final.txt` (documentacion completa)

---

## Auto-CoT: Razonamiento Paso a Paso

**Chain of Thought 1:**
1. analisis/ puede contener multiples tipos de analisis
2. Necesidad de clasificar por tipo: negocio, viabilidad, tecnico
3. Archivos de negocio pertenecen a planificacion/analisis_negocio/
4. Archivos de viabilidad pertenecen a planificacion/feasibility/
5. Archivos tecnicos pueden quedarse en analisis/ o moverse a arquitectura/
6. Resultado: contenido clasificado correctamente

**Chain of Thought 2:**
1. Objetivo: consolidar lo relacionado con planificacion
2. Fuente: analisis/ (contenido mixto)
3. Destinos: planificacion/analisis_negocio/, planificacion/feasibility/, analisis/ (tecnico)
4. Criterio: analizar nombres y contenido de archivos
5. Ejecutar movimientos preservando estructura

**Chain of Thought 3:**
1. Inventariar analisis/ completamente
2. Identificar patrones en nombres (negocio, feasibility, tecnico)
3. Clasificar automaticamente cuando sea claro
4. Revisar manualmente archivos ambiguos
5. Mover a destinos correspondientes
6. Documentar decision sobre archivos restantes

**Self-Consistency:** Los 3 razonamientos convergen en clasificar analisis/ por tipo y consolidar en planificacion/ lo relacionado

---

## Notas

- Esta es la tarea mas compleja de consolidacion (requiere clasificacion)
- Duracion estimada incluye revision manual de archivos ambiguos
- Prioridad MEDIA porque no bloquea otras tareas criticas
- Puede requerir decision de Tech Lead sobre archivos tecnicos
- Si analisis/ tiene mucho contenido tecnico, puede mantenerse como carpeta independiente
- Considerar crear docs/backend/arquitectura/ si hay mucho contenido tecnico

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Inventario completo de analisis/ documentado
- [ ] Contenido clasificado por tipo
- [ ] Archivos de negocio movidos a planificacion/analisis_negocio/
- [ ] Archivos de feasibility movidos a planificacion/feasibility/
- [ ] Decision sobre archivos tecnicos documentada
- [ ] Carpeta analisis/ eliminada o justificada
- [ ] Conteo de archivos verificado (ninguno perdido)
- [ ] Consolidacion documentada completamente
- [ ] Validacion exitosa
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
