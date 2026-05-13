---
id: TASK-REORG-INFRA-022
titulo: Mover Archivos Raiz a Carpetas Apropiadas
fase: FASE_2_REORGANIZACION_CRITICA
subcategoria: Reorganizacion de Archivos Raiz
prioridad: ALTA (P1)
duracion_estimada: 4 horas
estado: Pendiente
tipo: Reorganizacion
dependencias:
  - TASK-REORG-INFRA-020
  - TASK-REORG-INFRA-021
tecnica_prompting: Decomposed Prompting + Auto-CoT
fecha_creacion: 2025-11-18
autor: QA Infraestructura
tags:
  - reorganizacion
  - raiz
  - estructura
  - fase-2
---

# TASK-REORG-INFRA-022: Mover Archivos Raiz a Carpetas Apropiadas

## Descripción

Mover los 13 archivos restantes de la raíz `/docs/infraestructura/` a sus carpetas apropiadas según la categorización realizada en TASK-020, después de haber eliminado duplicados en TASK-021.

## Objetivo

Reorganizar la estructura de archivos moviendo todos los documentos de la raíz a carpetas especializadas, manteniendo solo `README.md` e `INDEX.md` en la raíz, según la nueva estructura organizacional del proyecto.

## Técnica de Prompting: Decomposed Prompting + Auto-CoT

### Aplicación de Decomposed Prompting

**Decomposed Prompting** descompone una tarea compleja en sub-tareas manejables, ejecutadas de forma secuencial con validación incremental.

#### Descomposición de la Tarea

```
TAREA COMPLEJA: Mover 13 archivos + Actualizar enlaces
↓
DESCOMPONER EN:
1. Categorizar archivos por destino (diseno/, adr/, procesos/, etc.)
2. Mover archivos por categoría
3. Actualizar enlaces internos en archivos movidos
4. Validar cada categoría antes de proceder a la siguiente
5. Verificación final de integridad
```

### Auto-CoT: Razonamiento para Categorización

#### Paso 1: Análisis de Categorías
```
RAZONAMIENTO:
Para cada archivo en raíz, determinar destino correcto:

¿Es un documento de diseño/arquitectura?
  → Mover a diseno/

¿Es un ADR (Architecture Decision Record)?
  → Mover a adr/

¿Es un proceso?
  → Mover a procesos/

¿Es un procedimiento operativo?
  → Mover a procedimientos/

¿Es documentación DevOps/CI-CD?
  → Mover a devops/

¿Es una especificación técnica?
  → Mover a carpeta temática (ej: cpython_precompilado/)
```

#### Paso 2: Matriz de Mapeo (ejemplo)
```
ARCHIVO → DESTINO → RAZÓN

canvas_devcontainer_host.md → diseno/canvas/
  ├─ Es un canvas de diseño
  └─ Debe estar con otros canvas

ADR-INFRA-XXX.md → adr/
  ├─ Es un Architecture Decision Record
  └─ Debe estar con otros ADRs

PROC-INFRA-XXX.md → procesos/
  ├─ Es un proceso documentado
  └─ Sigue nomenclatura PROC-INFRA-XXX
```

## Pasos de Ejecución

### 1. Identificar Archivos a Mover (30 min)

```bash
# Listar archivos en raíz (excluyendo los que deben quedar)
cd /home/user/IACT/docs/infraestructura
ls -1 | grep -v -E "^(README.md|INDEX.md|adr|checklists|devops|diseno|plantillas|procedimientos|procesos|qa|solicitudes)$"

# Crear matriz de mapeo
cat > /tmp/matriz-mapeo.txt << 'EOF'
# Matriz de Mapeo: Archivo → Destino
# Formato: archivo_origen.md → carpeta_destino/
EOF
```

**Auto-CoT - Razonamiento:**
```
Para cada archivo:
1. Leer nombre y contenido
2. Identificar tipo de documento
3. Mapear a carpeta destino
4. Documentar razón de mapeo
```

### 2. Mover Archivos por Categoría: Diseño (45 min)

**Categoría: Documentos de Diseño → diseno/**

```bash
# Mover canvas de diseño
git mv canvas_devcontainer_host.md diseno/canvas/
git mv canvas_pipeline_cicd_devcontainer.md diseno/canvas/
git mv canvas_*.md diseno/canvas/  # Si hay más canvas

# Mover documentos de arquitectura
git mv arquitectura_*.md diseno/arquitectura/  # Si existen

# Verificar movimiento
ls -la diseno/canvas/
git status
```

**Verificación de Categoría:**
- [ ] Archivos movidos correctamente
- [ ] Rutas de destino existen
- [ ] `git status` muestra renamed
- [ ] Contenido accesible en nueva ubicación

### 3. Mover Archivos por Categoría: ADRs (30 min)

**Categoría: ADRs → adr/**

```bash
# Mover ADRs si están en raíz
git mv ADR-INFRA-*.md adr/

# Verificar
ls -la adr/
git status
```

### 4. Mover Archivos por Categoría: Procesos (30 min)

**Categoría: Procesos → procesos/**

```bash
# Mover documentos de procesos
git mv PROC-INFRA-*.md procesos/

# Verificar
ls -la procesos/
git status
```

### 5. Mover Archivos por Categoría: Procedimientos (30 min)

**Categoría: Procedimientos → procedimientos/**

```bash
# Mover procedimientos operativos
git mv PROCED-INFRA-*.md procedimientos/

# Verificar
ls -la procedimientos/
git status
```

### 6. Mover Archivos por Categoría: DevOps (30 min)

**Categoría: DevOps/CI-CD → devops/**

```bash
# Mover documentos DevOps
git mv *pipeline*.md devops/  # Documentos de pipeline
git mv *ci-cd*.md devops/     # Documentos CI/CD

# Verificar
ls -la devops/
git status
```

### 7. Mover Archivos por Categoría: Especificaciones Técnicas (30 min)

**Categoría: Specs Técnicas → carpetas temáticas**

```bash
# Mover especificaciones a carpetas temáticas
git mv spec_*_cpython_*.md cpython_precompilado/
git mv spec_*_vagrant_*.md vagrant/  # Si existe carpeta
# ... otras especificaciones según tema

# Verificar
git status
```

### 8. Actualizar Enlaces Internos en Archivos Movidos (60 min)

**Para cada archivo movido, actualizar sus enlaces internos:**

```bash
# Ejemplo: Si canvas_devcontainer_host.md tenía:
# [Ver ADR](./ADR-INFRA-001.md)
#
# Actualizar a:
# [Ver ADR](../../adr/ADR-INFRA-001.md)

# Script para encontrar enlaces a actualizar
for file in $(git diff --name-only HEAD | grep "^diseno\|^adr\|^procesos"); do
  echo "Verificando enlaces en: $file"
  grep -n "\[.*\](\.\.*/.*\.md)" "$file" || echo "  Sin enlaces relativos"
done
```

**Auto-CoT - Razonamiento para Actualizar Enlaces:**
```
PARA CADA ARCHIVO MOVIDO:
  Ubicación anterior: /docs/infraestructura/archivo.md
  Ubicación nueva: /docs/infraestructura/categoria/archivo.md

  IMPACTO EN ENLACES:
  - Enlaces a archivos en raíz: ./otro.md → ../otro.md
  - Enlaces a archivos en carpetas: ./carpeta/doc.md → ../carpeta/doc.md
  - Enlaces desde nueva ubicación: Ajustar niveles ../

  ACCIÓN:
  1. Abrir archivo en editor
  2. Buscar todos los enlaces relativos: grep "\[.*\](.*/.*)"
  3. Calcular nueva ruta relativa
  4. Actualizar cada enlace
  5. Verificar que enlaces funcionan
```

### 9. Verificación Final (30 min)

```bash
# Verificar que solo README.md e INDEX.md quedan en raíz
cd /home/user/IACT/docs/infraestructura
ls -1 *.md

# Debe mostrar solo:
# INDEX.md
# README.md

# Verificar estado de Git
git status

# Debe mostrar múltiples "renamed: archivo.md -> categoria/archivo.md"

# Documentar en evidencias
ls -1 *.md > evidencias/archivos-raiz-final.txt
git status > evidencias/git-status-post-movimiento.txt
```

## Auto-CoT: Razonamiento Completo Documentado

### Análisis del Problema

```
SITUACIÓN INICIAL:
- 15 archivos en raíz de /docs/infraestructura/
- Solo README.md e INDEX.md deben quedarse
- 13 archivos necesitan moverse

DESAFÍOS:
1. Determinar destino correcto para cada archivo
2. Mantener integridad de enlaces
3. Preservar historial Git (usar git mv, no mv)
4. Actualizar referencias cruzadas

ESTRATEGIA:
- Categorizar archivos por tipo/propósito
- Mover por categoría (no todos a la vez)
- Validar cada categoría antes de continuar
- Actualizar enlaces incrementalmente
```

### Razonamiento por Categoría

```
CATEGORÍA: Canvas de Diseño
├─ Archivos: canvas_*.md
├─ Destino: diseno/canvas/
├─ Razón: Son documentos de diseño visual/conceptual
└─ Validación: Verificar que carpeta canvas/ existe

CATEGORÍA: ADRs
├─ Archivos: ADR-INFRA-*.md
├─ Destino: adr/
├─ Razón: Architecture Decision Records formales
└─ Validación: Verificar nomenclatura ADR-INFRA-XXX

CATEGORÍA: Procesos
├─ Archivos: PROC-INFRA-*.md
├─ Destino: procesos/
├─ Razón: Procesos operativos documentados
└─ Validación: Verificar nomenclatura PROC-INFRA-XXX

CATEGORÍA: Procedimientos
├─ Archivos: PROCED-INFRA-*.md
├─ Destino: procedimientos/
├─ Razón: Procedimientos paso a paso
└─ Validación: Verificar nomenclatura PROCED-INFRA-XXX

CATEGORÍA: DevOps
├─ Archivos: *pipeline*.md, *ci-cd*.md
├─ Destino: devops/
├─ Razón: Documentación CI/CD y pipelines
└─ Validación: Revisar contenido relacionado con DevOps
```

### Self-Consistency: Validación Cruzada

```
VERIFICACIÓN 1: ¿Todos los archivos tienen destino?
- Listar archivos en raíz
- Verificar que cada uno está en matriz de mapeo
- Confirmar que ninguno quedó sin categorizar

VERIFICACIÓN 2: ¿Los destinos existen?
- Verificar que carpetas destino fueron creadas (TASK-002)
- Confirmar permisos de escritura
- Validar estructura de subcarpetas

VERIFICACIÓN 3: ¿Los movimientos son reversibles?
- Backup existe (TASK-001)
- Usar git mv (no rm + add)
- Documentar cada movimiento

VERIFICACIÓN 4: ¿Enlaces están actualizados?
- Verificar enlaces internos en archivos movidos
- Buscar enlaces rotos: grep -r "](.*\.md)" docs/infraestructura/
- Validar que rutas relativas son correctas
```

## Criterios de Aceptación

- [ ] Los 13 archivos han sido movidos a sus carpetas apropiadas
- [ ] Solo `README.md` e `INDEX.md` permanecen en raíz
- [ ] Todos los movimientos usaron `git mv` (preservan historial)
- [ ] Enlaces internos en archivos movidos están actualizados
- [ ] `git status` muestra "renamed: X -> Y" para cada archivo
- [ ] Matriz de mapeo documentada en `evidencias/archivos-raiz-movidos.txt`
- [ ] Lista de enlaces actualizados en `evidencias/enlaces-actualizados-raiz.md`
- [ ] Sin archivos huérfanos en raíz
- [ ] Validación de cada categoría completada antes de proceder a siguiente

## Evidencias a Generar

### 1. evidencias/archivos-raiz-movidos.txt
```
# Archivos Movidos de Raíz a Carpetas Apropiadas
Fecha: 2025-11-18

## Matriz de Mapeo

### Categoría: Diseño (Canvas)
canvas_devcontainer_host.md → diseno/canvas/canvas_devcontainer_host.md
canvas_pipeline_cicd_devcontainer.md → diseno/canvas/canvas_pipeline_cicd_devcontainer.md

### Categoría: ADRs
ADR-INFRA-001-vagrant-devcontainer.md → adr/ADR-INFRA-001-vagrant-devcontainer.md
[... otros ADRs ...]

### Categoría: Procesos
PROC-INFRA-001-ciclo-vida-devcontainer.md → procesos/PROC-INFRA-001-ciclo-vida-devcontainer.md
[... otros procesos ...]

### Categoría: Procedimientos
PROCED-INFRA-001-provision-vm.md → procedimientos/PROCED-INFRA-001-provision-vm.md
[... otros procedimientos ...]

### Categoría: DevOps
pipeline_cicd_devcontainer.md → devops/pipeline_cicd_devcontainer.md
[... otros docs DevOps ...]

### Categoría: Especificaciones Técnicas
spec_cpython_001.md → cpython_precompilado/spec_cpython_001.md
[... otras specs ...]

## Resumen
Total archivos movidos: 13
Archivos en raíz final: 2 (README.md, INDEX.md)
```

### 2. evidencias/enlaces-actualizados-raiz.md
```markdown
# Enlaces Actualizados en Archivos Movidos

## Archivo: diseno/canvas/canvas_devcontainer_host.md

**Enlaces Originales → Enlaces Actualizados:**
- `[ADR](./ADR-INFRA-001.md)` → `[ADR](../../adr/ADR-INFRA-001.md)`
- `[Proceso](./PROC-INFRA-001.md)` → `[Proceso](../../procesos/PROC-INFRA-001.md)`

## Archivo: adr/ADR-INFRA-001-vagrant.md

**Enlaces Originales → Enlaces Actualizados:**
- `[Canvas](./canvas_devcontainer_host.md)` → `[Canvas](../diseno/canvas/canvas_devcontainer_host.md)`
- `[README](./README.md)` → `[README](../README.md)`

[... otros archivos ...]

## Resumen
- Total enlaces actualizados: XX
- Archivos con enlaces modificados: YY
```

### 3. evidencias/git-status-post-movimiento.txt
```
# Git Status Post-Movimiento

On branch feature/reorganizacion-infraestructura
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        renamed:    canvas_devcontainer_host.md -> diseno/canvas/canvas_devcontainer_host.md
        renamed:    canvas_pipeline_cicd_devcontainer.md -> diseno/canvas/canvas_pipeline_cicd_devcontainer.md
        renamed:    ADR-INFRA-001.md -> adr/ADR-INFRA-001.md
        [... más renamed ...]
```

## Dependencias

**Requiere completar:**
- TASK-REORG-INFRA-020: Identificar Archivos Raíz a Organizar
- TASK-REORG-INFRA-021: Eliminar Archivos Duplicados

**Desbloquea:**
- TASK-REORG-INFRA-023: Actualizar Enlaces a Archivos Movidos (validación completa de enlaces)

## Notas Importantes

[WARNING] **IMPORTANTE**: Usar SIEMPRE `git mv` en lugar de `mv` para preservar el historial de Git.

 **Tip**: Mover por categorías permite validación incremental y facilita reversión si hay errores.

 **Reversibilidad**:
```bash
# Si necesitas revertir un movimiento:
git checkout HEAD -- archivo_movido.md
# O revertir todos:
git reset --hard HEAD
```

 **Validación de Enlaces**:
```bash
# Encontrar todos los enlaces relativos en archivos movidos
find diseno/ adr/ procesos/ -name "*.md" -exec grep -H "](\.\.*/.*\.md)" {} \;
```

## Relación con Otras Tareas

```
TASK-020 (Identificar archivos raíz)
    ↓
TASK-021 (Eliminar duplicados)
    ↓
TASK-022 (Mover archivos) ← ESTA TAREA
    ↓
TASK-023 (Actualizar enlaces - validación global)
    ↓
TASK-024 (Validar reorganización completa)
```

## Referencias

- LISTADO-COMPLETO-TAREAS.md: Línea 875-908
- Git Best Practices: `git mv` preserva historial
- Estructura de carpetas: Definida en TASK-002
- Backup de seguridad: TASK-001
