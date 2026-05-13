---
id: TASK-REORG-INFRA-021
titulo: Eliminar Archivos Duplicados
fase: FASE_2_REORGANIZACION_CRITICA
subcategoria: Limpieza de Archivos Raiz
prioridad: CRITICA (P0)
duracion_estimada: 1 hora
estado: Pendiente
tipo: Limpieza
dependencias:
  - TASK-REORG-INFRA-020
tecnica_prompting: Chain-of-Verification (CoVE)
fecha_creacion: 2025-11-18
autor: QA Infraestructura
tags:
  - duplicados
  - limpieza
  - raiz
  - fase-2
---

# TASK-REORG-INFRA-021: Eliminar Archivos Duplicados

## Descripción

Eliminar 2 archivos duplicados identificados en la raíz de `/docs/infraestructura/`:
- `index.md` (duplicado de `INDEX.md`)
- `spec_infra_001_cpython_precompilado.md` (duplicado en carpeta `cpython_precompilado/`)

Esta tarea es parte crítica de la limpieza de archivos en raíz para mantener una estructura organizada y libre de redundancias.

## Objetivo

Eliminar archivos duplicados de forma segura, preservando la versión correcta de cada archivo y documentando el proceso de eliminación.

## Técnica de Prompting: Chain-of-Verification (CoVE)

### Aplicación de CoVE

**Chain-of-Verification (CoVE)** es una técnica que valida cada paso antes de proceder al siguiente, reduciendo errores en operaciones críticas de eliminación.

#### Paso 1: Verificación Inicial
```
RAZONAMIENTO:
Antes de eliminar cualquier archivo, debo:
1. Verificar que realmente son duplicados
2. Comparar contenido byte por byte
3. Identificar cuál versión es la correcta
4. Confirmar que no hay enlaces externos apuntando solo a la versión a eliminar

VERIFICACIÓN:
- ¿Son archivos idénticos? → Ejecutar diff
- ¿Cuál tiene más enlaces? → Buscar referencias
- ¿Cuál sigue convenciones? → Validar nomenclatura
```

#### Paso 2: Decisión de Versión a Preservar
```
RAZONAMIENTO:
Para index.md vs INDEX.md:
- INDEX.md sigue convención de mayúsculas para archivos principales
- Verificar cuál tiene más referencias en documentación
- Preservar el que cumple con estándares del proyecto

Para spec_infra_001_cpython_precompilado.md:
- Verificar si la versión en carpeta cpython_precompilado/ es más actualizada
- Confirmar que contiene la misma información o superior
```

#### Paso 3: Eliminación Segura
```
VERIFICACIÓN PRE-ELIMINACIÓN:
- [ ] Backup creado (TASK-001)
- [ ] Diff ejecutado y comparado
- [ ] Enlaces verificados
- [ ] Versión correcta identificada

ELIMINACIÓN:
git rm <archivo-duplicado>

VERIFICACIÓN POST-ELIMINACIÓN:
- [ ] Archivo eliminado correctamente
- [ ] Versión correcta preservada
- [ ] Sin enlaces rotos
```

## Pasos de Ejecución

### 1. Verificar Duplicados (15 min)

```bash
# Verificar index.md vs INDEX.md
cd /home/user/IACT/docs/infraestructura
diff index.md INDEX.md

# Verificar spec_infra_001_cpython_precompilado.md
diff spec_infra_001_cpython_precompilado.md cpython_precompilado/spec_infra_001_cpython_precompilado.md

# Buscar referencias a cada archivo
grep -r "index\.md" .
grep -r "INDEX\.md" .
grep -r "spec_infra_001_cpython_precompilado" .
```

**Auto-CoT - Razonamiento:**
- Si `diff` muestra diferencias, analizar cuál versión es más completa
- Si son idénticos, aplicar convenciones del proyecto para decidir
- Documentar cualquier diferencia encontrada

### 2. Identificar Versión a Preservar (10 min)

**Criterios de Decisión:**
- Cumplimiento de convenciones de nomenclatura
- Cantidad de referencias en documentación
- Completitud del contenido
- Ubicación más lógica según estructura

**Documentar en**: `evidencias/verificacion-duplicados.md`

### 3. Ejecutar Eliminación (20 min)

```bash
# Eliminar duplicados (ajustar según verificación)
git rm index.md  # Si INDEX.md es la versión correcta
git rm spec_infra_001_cpython_precompilado.md  # Si versión en carpeta es correcta

# Documentar eliminación
echo "Eliminados:" > evidencias/duplicados-eliminados.txt
git status >> evidencias/duplicados-eliminados.txt
```

### 4. Verificar Eliminación (15 min)

```bash
# Verificar que archivos fueron eliminados
ls -la /home/user/IACT/docs/infraestructura/ | grep -E "index|spec_infra"

# Verificar que versión correcta existe
test -f INDEX.md && echo "INDEX.md preservado" || echo "ERROR: INDEX.md no existe"
test -f cpython_precompilado/spec_infra_001_cpython_precompilado.md && echo "spec preservado" || echo "ERROR: spec no existe"

# Verificar enlaces no rotos (si hay referencias)
grep -r "index\.md" . || echo "Sin referencias a index.md - OK"
```

## Auto-CoT: Razonamiento Documentado

### Análisis del Problema
```
PREGUNTA: ¿Por qué existen duplicados?
HIPÓTESIS:
1. Cambio de convención de nomenclatura (minúsculas → MAYÚSCULAS)
2. Reorganización previa incompleta
3. Migración de contenido a carpetas especializadas

IMPACTO:
- Confusión para usuarios/desarrolladores
- Posibles enlaces rotos futuros
- Dificultad en mantenimiento
- Espacio innecesario en repositorio

SOLUCIÓN:
Eliminar duplicados preservando versión que:
- Cumple convenciones actuales
- Tiene más referencias
- Está en ubicación correcta según nueva estructura
```

### Validación de Coherencia (Self-Consistency)
```
VERIFICACIÓN CRUZADA:
1. ¿La eliminación afecta otras tareas?
   → Verificar TASK-020 (identificación raíz)
   → Verificar TASK-022 (movimiento archivos)

2. ¿Hay enlaces que actualizar?
   → Será manejado por TASK-023 (actualizar enlaces)

3. ¿Es reversible la operación?
   → Sí, gracias a TASK-001 (backup completo)
```

## Criterios de Aceptación

- [ ] Los 2 archivos duplicados han sido eliminados correctamente
- [ ] La versión correcta de cada archivo está preservada
- [ ] Se ejecutó `diff` para confirmar que son duplicados exactos o versión en carpeta es superior
- [ ] Documentación completa en `evidencias/verificacion-duplicados.md`
- [ ] Lista de archivos eliminados en `evidencias/duplicados-eliminados.txt`
- [ ] No hay enlaces rotos como resultado de la eliminación
- [ ] Cambios confirmados con `git status`

## Evidencias a Generar

### 1. evidencias/verificacion-duplicados.md
```markdown
# Verificación de Archivos Duplicados

## index.md vs INDEX.md

**Comparación:**
- Resultado de diff: [IDENTICO/DIFERENTE]
- Tamaño: index.md (XXX bytes) vs INDEX.md (YYY bytes)
- Referencias encontradas:
  - index.md: N referencias
  - INDEX.md: M referencias

**Decisión:** Preservar [INDEX.md] porque [razón]

## spec_infra_001_cpython_precompilado.md

**Ubicaciones:**
- /docs/infraestructura/spec_infra_001_cpython_precompilado.md
- /docs/infraestructura/cpython_precompilado/spec_infra_001_cpython_precompilado.md

**Comparación:**
- Resultado de diff: [IDENTICO/DIFERENTE]
- Contenido más completo: [ubicación]

**Decisión:** Preservar versión en [cpython_precompilado/] porque [razón]
```

### 2. evidencias/duplicados-eliminados.txt
```
# Archivos Duplicados Eliminados
Fecha: 2025-11-18

## Archivos Eliminados:
1. index.md → Preservado: INDEX.md
2. spec_infra_001_cpython_precompilado.md → Preservado: cpython_precompilado/spec_infra_001_cpython_precompilado.md

## Comando Git:
git rm index.md
git rm spec_infra_001_cpython_precompilado.md

## Verificación:
[output de git status]
```

## Dependencias

**Requiere completar:**
- TASK-REORG-INFRA-020: Identificar Archivos Raíz a Organizar

**Desbloquea:**
- TASK-REORG-INFRA-022: Mover Archivos Raíz a Carpetas Apropiadas

## Notas Importantes

[WARNING] **CRÍTICO - P0**: Esta tarea debe completarse antes de mover archivos (TASK-022) para evitar conflictos.

 **Tip**: Usar `git rm` en lugar de `rm` para que Git rastree la eliminación.

 **Reversibilidad**: Si se eliminó archivo incorrecto, recuperar desde TASK-001 backup o `git checkout HEAD~1 -- <archivo>`.

## Relación con Otras Tareas

- **TASK-020** → Identificó estos duplicados
- **TASK-021** (esta) → Elimina duplicados
- **TASK-022** → Moverá archivos restantes (sin duplicados)
- **TASK-023** → Actualizará enlaces si es necesario

## Referencias

- LISTADO-COMPLETO-TAREAS.md: Línea 840-873
- Convenciones: INDEX.md, README.md en MAYÚSCULAS para archivos principales
- Git Best Practices: Usar `git rm` para eliminar archivos versionados
