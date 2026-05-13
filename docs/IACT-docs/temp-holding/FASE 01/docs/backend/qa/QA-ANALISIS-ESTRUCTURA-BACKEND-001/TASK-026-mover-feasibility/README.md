---
id: TASK-REORG-BACK-026
tipo: tarea
categoria: consolidacion
titulo: Mover feasibility/
fase: FASE_3
prioridad: ALTA
duracion_estimada: 5min
estado: pendiente
dependencias: ["TASK-REORG-BACK-025"]
---

# TASK-REORG-BACK-026: Mover feasibility/

**Fase:** FASE 3 - Consolidacion
**Prioridad:** ALTA
**Duracion Estimada:** 5 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Mover el contenido de docs/backend/feasibility/ a docs/backend/planificacion/feasibility/, consolidando los estudios de viabilidad dentro de la estructura de planificacion.

---

## Prerequisitos

- [ ] TASK-025 completada (subcarpetas en planificacion/ creadas)
- [ ] Carpeta docs/backend/feasibility/ existe
- [ ] Carpeta docs/backend/planificacion/feasibility/ existe y vacia
- [ ] Working directory limpio

---

## Pasos de Ejecucion

### Paso 1: Inventariar Contenido de feasibility/
```bash
# Ver contenido completo
find docs/backend/feasibility/ -type f

# Contar archivos
find docs/backend/feasibility/ -type f | wc -l
```

**Resultado Esperado:** Listado de archivos en feasibility/

### Paso 2: Verificar Destino Vacio
```bash
# Verificar que planificacion/feasibility/ este vacio
ls -la docs/backend/planificacion/feasibility/

# Debe estar vacio o solo tener .gitkeep
```

**Resultado Esperado:** Carpeta vacia o solo .gitkeep presente

### Paso 3: Mover Contenido
```bash
# Mover todo el contenido preservando estructura
mv docs/backend/feasibility/* docs/backend/planificacion/feasibility/

# Verificar que origin quedo vacio
ls -la docs/backend/feasibility/
```

**Resultado Esperado:** Contenido movido, carpeta origen vacia

### Paso 4: Eliminar Carpeta Origen
```bash
# Eliminar carpeta feasibility/ vieja
rm -rf docs/backend/feasibility/

# Verificar eliminacion
ls -d docs/backend/feasibility/ 2>/dev/null || echo "Carpeta eliminada OK"
```

**Resultado Esperado:** Carpeta feasibility/ eliminada

### Paso 5: Verificar Contenido Movido
```bash
# Listar contenido en nuevo destino
find docs/backend/planificacion/feasibility/ -type f

# Contar archivos movidos
find docs/backend/planificacion/feasibility/ -type f | wc -l
```

**Resultado Esperado:** Misma cantidad de archivos que en Paso 1

### Paso 6: Documentar Movimiento
```bash
# Crear registro de archivos movidos
find docs/backend/planificacion/feasibility/ -type f > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/movimiento-feasibility.txt

# Mostrar resumen
echo "Total archivos movidos: $(wc -l < docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/movimiento-feasibility.txt)"
```

**Resultado Esperado:** Archivo movimiento-feasibility.txt creado con listado

---

## Criterios de Exito

- [ ] Todo el contenido de feasibility/ movido a planificacion/feasibility/
- [ ] Carpeta origen docs/backend/feasibility/ eliminada
- [ ] No hay perdida de archivos (conteo coincide)
- [ ] Estructura de subcarpetas preservada
- [ ] Movimiento documentado en movimiento-feasibility.txt

---

## Validacion

```bash
# Verificar que origen no existe
if [ -d "docs/backend/feasibility" ]; then
 echo "ERROR: Carpeta origen todavia existe"
else
 echo "OK: Carpeta origen eliminada"
fi

# Verificar que destino tiene contenido
if [ "$(find docs/backend/planificacion/feasibility/ -type f | wc -l)" -gt 0 ]; then
 echo "OK: Contenido presente en destino"
else
 echo "ERROR: Destino vacio"
fi

# Comparar conteos
echo "Archivos en destino: $(find docs/backend/planificacion/feasibility/ -type f | wc -l)"
```

**Salida Esperada:** Origen eliminado, destino con contenido

---

## Rollback

Si se necesita deshacer:
```bash
# Recrear carpeta origen
mkdir -p docs/backend/feasibility/

# Mover contenido de vuelta
mv docs/backend/planificacion/feasibility/* docs/backend/feasibility/

# Limpiar destino
rm -rf docs/backend/planificacion/feasibility/*
touch docs/backend/planificacion/feasibility/.gitkeep
```

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Perdida de archivos en movimiento | MUY BAJA | CRITICO | Contar archivos antes/despues, tener backup |
| Destino no vacio | BAJA | MEDIO | Verificar destino antes de mover |
| Permisos insuficientes | MUY BAJA | MEDIO | Verificar permisos de escritura |
| Carpeta origen no existe | BAJA | BAJO | Verificar existencia en Paso 1 |

---

## Evidencias a Capturar

1. Output de `find docs/backend/feasibility/` (antes)
2. Output de `find docs/backend/planificacion/feasibility/` (despues)
3. Archivo `movimiento-feasibility.txt`
4. Confirmacion de eliminacion de carpeta origen

---

## Auto-CoT: Razonamiento Paso a Paso

**Chain of Thought 1:**
1. feasibility/ contiene estudios de viabilidad
2. Estos son parte de la fase de planificacion
3. TASK-025 creo planificacion/feasibility/
4. Mover contenido preserva organizacion tematica
5. Eliminar origen evita duplicacion

**Chain of Thought 2:**
1. Objetivo: consolidar en planificacion/
2. feasibility/ es candidato natural (nombre identico)
3. Movimiento directo sin renombrar
4. Verificar que no se pierdan archivos
5. Resultado: contenido consolidado

**Chain of Thought 3:**
1. Analizar contenido de feasibility/
2. Confirmar que pertenece a planificacion
3. Verificar destino vacio antes de mover
4. Ejecutar mv preservando estructura
5. Validar con conteo de archivos

**Self-Consistency:** Los 3 razonamientos convergen en mover feasibility/ completo a planificacion/feasibility/

---

## Notas

- Este movimiento es directo (mismo nombre en origen y destino)
- No requiere renombrado de archivos
- Preserva toda la estructura interna de feasibility/
- Es el primer contenido real que ingresa a planificacion/

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Inventario de feasibility/ documentado
- [ ] Contenido movido completamente
- [ ] Carpeta origen eliminada
- [ ] Conteo de archivos coincide
- [ ] Movimiento documentado en movimiento-feasibility.txt
- [ ] Validacion exitosa
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
