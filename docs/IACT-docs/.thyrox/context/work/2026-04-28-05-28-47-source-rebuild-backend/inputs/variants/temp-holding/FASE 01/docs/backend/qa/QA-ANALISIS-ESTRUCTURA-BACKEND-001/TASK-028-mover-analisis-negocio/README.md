---
id: TASK-REORG-BACK-028
tipo: tarea
categoria: consolidacion
titulo: Mover analisis_negocio/
fase: FASE_3
prioridad: MEDIA
duracion_estimada: 5min
estado: pendiente
dependencias: ["TASK-REORG-BACK-027"]
---

# TASK-REORG-BACK-028: Mover analisis_negocio/

**Fase:** FASE 3 - Consolidacion
**Prioridad:** MEDIA
**Duracion Estimada:** 5 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Mover el contenido de docs/backend/analisis_negocio/ a docs/backend/planificacion/analisis_negocio/, consolidando los analisis de requisitos de negocio dentro de la estructura de planificacion.

---

## Prerequisitos

- [ ] TASK-027 completada (planning y releases consolidados)
- [ ] Carpeta docs/backend/analisis_negocio/ existe
- [ ] Carpeta docs/backend/planificacion/analisis_negocio/ existe y vacia
- [ ] Working directory limpio

---

## Pasos de Ejecucion

### Paso 1: Inventariar Contenido de analisis_negocio/
```bash
# Ver contenido completo
find docs/backend/analisis_negocio/ -type f

# Contar archivos
echo "Total archivos: $(find docs/backend/analisis_negocio/ -type f | wc -l)"

# Ver estructura
tree docs/backend/analisis_negocio/
```

**Resultado Esperado:** Listado completo de archivos y subcarpetas

### Paso 2: Verificar Destino Vacio
```bash
# Verificar que planificacion/analisis_negocio/ este vacio
ls -la docs/backend/planificacion/analisis_negocio/

# Contar archivos (debe ser 0 o solo .gitkeep)
find docs/backend/planificacion/analisis_negocio/ -type f ! -name '.gitkeep' | wc -l
```

**Resultado Esperado:** Carpeta vacia o solo .gitkeep presente

### Paso 3: Mover Contenido Completo
```bash
# Mover todo el contenido preservando estructura
mv docs/backend/analisis_negocio/* docs/backend/planificacion/analisis_negocio/

# Verificar que origen quedo vacio
ls -la docs/backend/analisis_negocio/
```

**Resultado Esperado:** Contenido movido, carpeta origen vacia

### Paso 4: Eliminar Carpeta Origen
```bash
# Eliminar carpeta analisis_negocio/ vieja
rm -rf docs/backend/analisis_negocio/

# Verificar eliminacion
ls -d docs/backend/analisis_negocio/ 2>/dev/null || \
 echo "Carpeta analisis_negocio/ eliminada OK"
```

**Resultado Esperado:** Carpeta analisis_negocio/ eliminada

### Paso 5: Verificar Contenido Movido
```bash
# Listar contenido en nuevo destino
find docs/backend/planificacion/analisis_negocio/ -type f ! -name '.gitkeep'

# Contar archivos movidos
echo "Archivos en destino: $(find docs/backend/planificacion/analisis_negocio/ -type f ! -name '.gitkeep' | wc -l)"

# Ver estructura
tree docs/backend/planificacion/analisis_negocio/
```

**Resultado Esperado:** Misma cantidad de archivos que en Paso 1

### Paso 6: Documentar Movimiento
```bash
# Crear registro de archivos movidos
echo "=== MOVIMIENTO analisis_negocio/ ===" > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/movimiento-analisis-negocio.txt

echo "Archivos movidos:" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/movimiento-analisis-negocio.txt
find docs/backend/planificacion/analisis_negocio/ -type f >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/movimiento-analisis-negocio.txt

echo -e "\nTotal: $(find docs/backend/planificacion/analisis_negocio/ -type f ! -name '.gitkeep' | wc -l) archivos" >> \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/movimiento-analisis-negocio.txt
```

**Resultado Esperado:** Archivo movimiento-analisis-negocio.txt creado

---

## Criterios de Exito

- [ ] Todo el contenido de analisis_negocio/ movido a planificacion/analisis_negocio/
- [ ] Carpeta origen docs/backend/analisis_negocio/ eliminada
- [ ] No hay perdida de archivos (conteo coincide)
- [ ] Estructura de subcarpetas preservada
- [ ] Movimiento documentado en movimiento-analisis-negocio.txt

---

## Validacion

```bash
# Verificar que origen no existe
if [ -d "docs/backend/analisis_negocio" ]; then
 echo "ERROR: Carpeta origen todavia existe"
else
 echo "OK: Carpeta origen eliminada"
fi

# Verificar que destino tiene contenido
count=$(find docs/backend/planificacion/analisis_negocio/ -type f ! -name '.gitkeep' | wc -l)
if [ $count -gt 0 ]; then
 echo "OK: Contenido presente en destino ($count archivos)"
else
 echo "WARN: Destino vacio o solo .gitkeep"
fi

# Verificar estructura
tree -L 2 docs/backend/planificacion/analisis_negocio/
```

**Salida Esperada:** Origen eliminado, destino con contenido

---

## Rollback

Si se necesita deshacer:
```bash
# Recrear carpeta origen
mkdir -p docs/backend/analisis_negocio/

# Mover contenido de vuelta
mv docs/backend/planificacion/analisis_negocio/* docs/backend/analisis_negocio/

# Limpiar destino
rm -rf docs/backend/planificacion/analisis_negocio/*
touch docs/backend/planificacion/analisis_negocio/.gitkeep
```

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Perdida de archivos en movimiento | MUY BAJA | CRITICO | Contar archivos antes/despues, tener backup |
| Destino no vacio | BAJA | MEDIO | Verificar destino antes de mover |
| Permisos insuficientes | MUY BAJA | MEDIO | Verificar permisos de escritura |
| Estructura interna no preservada | BAJA | ALTO | Usar mv recursivo |

---

## Evidencias a Capturar

1. Output de `tree docs/backend/analisis_negocio/` (antes)
2. Output de `tree docs/backend/planificacion/analisis_negocio/` (despues)
3. Archivo `movimiento-analisis-negocio.txt`
4. Confirmacion de eliminacion de carpeta origen

---

## Auto-CoT: Razonamiento Paso a Paso

**Chain of Thought 1:**
1. analisis_negocio/ contiene analisis de requisitos de negocio
2. Este tipo de analisis es parte de la fase de planificacion
3. TASK-025 creo planificacion/analisis_negocio/
4. Mover contenido mantiene coherencia tematica
5. Eliminar origen evita duplicacion

**Chain of Thought 2:**
1. Objetivo: consolidar todo en planificacion/
2. analisis_negocio/ es candidato claro (analisis inicial)
3. Movimiento directo sin renombrar (mismo nombre)
4. Verificar conteos para no perder informacion
5. Resultado: analisis de negocio consolidado

**Chain of Thought 3:**
1. Revisar contenido de analisis_negocio/
2. Confirmar que pertenece a fase de planificacion
3. Verificar destino vacio antes de mover
4. Ejecutar mv preservando toda la estructura
5. Validar con conteo y tree

**Self-Consistency:** Los 3 razonamientos convergen en mover analisis_negocio/ completo a planificacion/analisis_negocio/

---

## Notas

- Este movimiento es directo (mismo nombre en origen y destino)
- No requiere renombrado de archivos
- Preserva toda la estructura interna de analisis_negocio/
- analisis_negocio/ es fase previa a feasibility/ en el ciclo de planificacion
- Prioridad MEDIA porque no bloquea otras consolidaciones criticas

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Inventario de analisis_negocio/ documentado
- [ ] Destino verificado vacio
- [ ] Contenido movido completamente
- [ ] Carpeta origen eliminada
- [ ] Conteo de archivos coincide
- [ ] Estructura preservada
- [ ] Movimiento documentado en movimiento-analisis-negocio.txt
- [ ] Validacion exitosa
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
