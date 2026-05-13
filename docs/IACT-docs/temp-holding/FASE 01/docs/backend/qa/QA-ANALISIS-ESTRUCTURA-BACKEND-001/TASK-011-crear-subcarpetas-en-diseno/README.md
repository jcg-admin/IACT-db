---
id: TASK-REORG-BACK-011
tipo: tarea
categoria: consolidacion-diseno
titulo: Crear Subcarpetas en diseno/
fase: FASE_2
prioridad: ALTA
duracion_estimada: 5min
estado: pendiente
dependencias: ["TASK-REORG-BACK-005"]
---

# TASK-REORG-BACK-011: Crear Subcarpetas en diseno/

**Fase:** FASE 2 - Consolidacion diseno/
**Prioridad:** ALTA
**Duracion Estimada:** 5 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Crear la estructura de subcarpetas dentro de docs/backend/diseno/ para consolidar toda la documentacion de diseno en una ubicacion centralizada.

---

## Auto-CoT: Razonamiento Paso a Paso

### Pensamiento 1: Por que consolidar diseno/
- **Problema:** Documentacion de diseno dispersa en multiples carpetas
- **Solucion:** Centralizar en diseno/ con subcarpetas semanticas
- **Beneficio:** Facilita navegacion y mantenimiento

### Pensamiento 2: Que subcarpetas necesitamos
- `api/` - Diseno de APIs REST y endpoints
- `arquitectura/` - Decisiones arquitectonicas y diagramas
- `permisos/` - Sistema de permisos y autorizacion
- `detallado/` - Diseno detallado de componentes
- `database/` - Diseno de base de datos y esquemas

### Pensamiento 3: Validacion de consistencia
- Verificar que nombres sean descriptivos
- Asegurar que no existen carpetas duplicadas
- Confirmar permisos de escritura

---

## Prerequisitos

- [ ] TASK-005 completada (plan de migracion documentado)
- [ ] Carpeta docs/backend/diseno/ existe
- [ ] Working directory limpio
- [ ] Permisos de escritura en docs/backend/diseno/

---

## Pasos de Ejecucion

### Paso 1: Verificar Carpeta Base
```bash
# Confirmar que diseno/ existe
ls -ld docs/backend/diseno/

# Ver contenido actual
ls -la docs/backend/diseno/
```

**Resultado Esperado:** Carpeta diseno/ existe

### Paso 2: Crear Subcarpetas
```bash
# Crear estructura de subcarpetas
mkdir -p docs/backend/diseno/{api,arquitectura,permisos,detallado,database}
```

**Resultado Esperado:** 5 subcarpetas creadas

### Paso 3: Verificar Creacion
```bash
# Listar subcarpetas creadas
ls -d docs/backend/diseno/*

# Contar subcarpetas
ls -d docs/backend/diseno/*/ | wc -l
# Esperado: 5
```

**Resultado Esperado:** 5 subcarpetas listadas correctamente

### Paso 4: Verificar Permisos
```bash
# Verificar permisos de escritura
for dir in api arquitectura permisos detallado database; do
 if [ -w "docs/backend/diseno/$dir" ]; then
 echo "OK: $dir - permisos correctos"
 else
 echo "ERROR: $dir - sin permisos de escritura"
 fi
done
```

**Resultado Esperado:** Todas las subcarpetas con permisos de escritura

### Paso 5: Documentar Estructura
```bash
# Crear listado de subcarpetas
tree docs/backend/diseno/ -L 1 > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/estructura-diseno-subcarpetas.txt

# Alternativa si tree no esta disponible
ls -R docs/backend/diseno/ > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/estructura-diseno-subcarpetas.txt
```

**Resultado Esperado:** Archivo estructura-diseno-subcarpetas.txt creado

---

## Criterios de Exito

- [ ] 5 subcarpetas creadas en docs/backend/diseno/
- [ ] Nombres de subcarpetas siguen convencion (minusculas, sin espacios)
- [ ] Todas las subcarpetas tienen permisos de escritura
- [ ] Estructura documentada en estructura-diseno-subcarpetas.txt
- [ ] No hay errores de permisos o duplicados

---

## Validacion

```bash
# Validacion 1: Contar subcarpetas
COUNT=$(ls -d docs/backend/diseno/*/ 2>/dev/null | wc -l)
if [ "$COUNT" -eq 5 ]; then
 echo "OK: 5 subcarpetas creadas"
else
 echo "ERROR: Se esperaban 5 subcarpetas, se encontraron $COUNT"
fi

# Validacion 2: Verificar nombres exactos
EXPECTED="api arquitectura permisos detallado database"
for dir in $EXPECTED; do
 if [ -d "docs/backend/diseno/$dir" ]; then
 echo "OK: $dir existe"
 else
 echo "ERROR: $dir NO existe"
 fi
done

# Validacion 3: Verificar que son directorios vacios
for dir in api arquitectura permisos detallado database; do
 COUNT=$(ls -A docs/backend/diseno/$dir | wc -l)
 echo "Contenido de $dir: $COUNT archivos"
done
```

**Salida Esperada:**
- 5 subcarpetas creadas
- Todos los nombres coinciden
- Directorios vacios (por ahora)

---

## Self-Consistency: Verificacion de Coherencia

### Verificacion 1: Consistencia de Nombres
- [ ] Todos los nombres en minusculas
- [ ] Sin espacios ni caracteres especiales
- [ ] Nombres semanticos y descriptivos

### Verificacion 2: Consistencia de Estructura
- [ ] Todas las subcarpetas al mismo nivel
- [ ] No hay anidamiento innecesario
- [ ] Estructura plana y facil de navegar

### Verificacion 3: Consistencia con Plan
- [ ] Coincide con PLAN-REORGANIZACION-ESTRUCTURA-BACKEND
- [ ] Alineado con estructura de docs/gobernanza/
- [ ] Cumple con convencion de nombres del proyecto

---

## Rollback

Si se necesita deshacer:
```bash
# Eliminar subcarpetas SI ESTAN VACIAS
rm -rf docs/backend/diseno/{api,arquitectura,permisos,detallado,database}

# Verificar eliminacion
ls docs/backend/diseno/
# Esperado: carpeta vacia o solo con archivos previos
```

**ADVERTENCIA:** NO ejecutar rollback si ya se movieron archivos a estas carpetas

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Subcarpeta ya existe con contenido | BAJA | BAJO | mkdir -p no sobrescribe |
| Permisos insuficientes | MUY BAJA | MEDIO | Verificar permisos antes de crear |
| Nombre incorrecto de subcarpeta | BAJA | BAJO | Seguir listado exacto |
| Conflicto con archivos existentes | BAJA | MEDIO | Verificar contenido antes de crear |

---

## Evidencias a Capturar

1. Output de `ls -d docs/backend/diseno/*/`
2. Output de script de validacion
3. Archivo `estructura-diseno-subcarpetas.txt`
4. Screenshot de arbol de directorios (opcional)

---

## Listado de Subcarpetas a Crear

1. **api/** - Documentacion de diseno de APIs REST
 - Endpoints, contratos, swagger/openapi
 - Migrara contenido de: api/, rest_apis/

2. **arquitectura/** - Decisiones arquitectonicas
 - ADRs, diagramas C4, patrones
 - Migrara contenido de: arquitectura/

3. **permisos/** - Sistema de permisos y autorizacion
 - Roles, politicas, reglas de acceso
 - Migrara contenido de: permisos/

4. **detallado/** - Diseno detallado de componentes
 - Especificaciones tecnicas detalladas
 - Migrara contenido de: diseno_detallado/

5. **database/** - Diseno de base de datos
 - Esquemas, migraciones, modelos
 - Consolidara archivos dispersos relacionados con BD

---

## Notas

- Esta tarea es preparatoria para las tareas TASK-012 a TASK-022
- NO mover archivos en esta tarea, solo crear estructura
- Las subcarpetas deben estar vacias tras esta tarea
- Validar que mkdir -p no genere errores
- En caso de problemas, consultar con Tech Lead antes de continuar

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] 5 subcarpetas creadas en docs/backend/diseno/
- [ ] Validacion OK con scripts
- [ ] Permisos verificados
- [ ] Estructura documentada en estructura-diseno-subcarpetas.txt
- [ ] Self-Consistency checks pasados
- [ ] No hay errores en git status
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
