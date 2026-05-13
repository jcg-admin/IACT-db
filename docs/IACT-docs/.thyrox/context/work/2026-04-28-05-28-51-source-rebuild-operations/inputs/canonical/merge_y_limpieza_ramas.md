---
id: RUNBOOK-GIT-MERGE-CLEANUP
estado: activo
propietario: equipo-devops
ultima_actualizacion: 2025-11-05
relacionados: ["PROC-CAMBIOS", "PROC-RELEASE"]
date: 2025-11-13
---
# Runbook: Merge y Limpieza de Ramas

## Propósito

Procedimiento para sincronizar ramas principales del repositorio (develop, docs, devcontainer, main) y eliminar ramas obsoletas, manteniendo una estructura de ramas limpia y organizada.

## Cuándo Usar

- Después de múltiples Pull Requests mergeados a develop
- Cuando se detectan ramas feature obsoletas sin actividad
- Como parte del proceso de release
- Para consolidar cambios de develop en ramas principales
- Cuando el número de ramas supera las 4 principales esperadas

## Pre-requisitos

- Acceso al repositorio con permisos de push
- Git instalado y configurado
- Conocimiento del estado actual de cada rama
- Backup reciente del repositorio (opcional pero recomendado)

## Estructura de Ramas Objetivo

El repositorio debe mantener únicamente 4 ramas principales:

- **develop**: Rama principal de desarrollo (base para features)
- **docs**: Documentación sincronizada con develop
- **devcontainer**: Configuración de contenedores sincronizada con develop
- **main**: Rama de producción sincronizada con develop

## Procedimiento

### Fase 1: Análisis y Preparación

#### 1.1 Verificar Estado Actual

```bash
# Actualizar referencias remotas
git fetch origin

# Listar todas las ramas
git branch -a

# Ver diferencias entre ramas principales
git rev-list --left-right --count origin/docs...develop
git rev-list --left-right --count origin/devcontainer...develop
git rev-list --left-right --count origin/main...develop
```

**Interpretación del output**:
- Primera columna: commits únicos en la primera rama
- Segunda columna: commits únicos en develop
- Si primera columna = 0 y segunda > 0: rama desactualizada, necesita merge

#### 1.2 Identificar Ramas Obsoletas

```bash
# Listar ramas feature remotas
git branch -r | grep 'origin/installer/'

# Listar ramas claude remotas
git branch -r | grep 'origin/claude/'

# Ver última actividad de cada rama
git for-each-ref --sort=-committerdate refs/remotes/origin/ \
  --format='%(committerdate:short) %(refname:short)'
```

**Criterios para eliminar**:
- Ramas feature mergeadas (0 commits únicos vs develop)
- Ramas claude de sesiones anteriores
- Ramas sin actividad por más de 30 días (verificar con equipo)

#### 1.3 Documentar Estado Inicial

Crear registro en `docs/qa/registros/YYYY_MM_DD_merge_ramas.md`:

```markdown
Fecha: YYYY-MM-DD
Ramas actuales: X
Ramas a eliminar: Y
Rama base: develop (commit: xxxxxx)
```

### Fase 2: Sincronización de Ramas Principales

#### 2.1 Sincronizar Rama docs

```bash
# Crear/cambiar a rama docs local
git checkout -b docs origin/docs

# Merge desde develop
git merge develop --no-edit

# Verificar resultado
git log --oneline -5
```

**Resultado esperado**: Fast-forward merge (si docs estaba desactualizada)

#### 2.2 Sincronizar Rama devcontainer

```bash
# Crear/cambiar a rama devcontainer local
git checkout -b devcontainer origin/devcontainer

# Merge desde develop
git merge develop --no-edit

# Verificar resultado
git log --oneline -5
```

**Resultado esperado**: Fast-forward merge

#### 2.3 Sincronizar Rama main

```bash
# Crear/cambiar a rama main local
git checkout -b main origin/main

# Merge desde develop
# Nota: puede requerir --allow-unrelated-histories en primera sincronización
git merge develop --no-edit

# Si falla con "refusing to merge unrelated histories":
git merge develop --allow-unrelated-histories --no-edit

# Verificar resultado
git log --oneline --graph -10
```

**Resultado esperado**: Merge commit o fast-forward

#### 2.4 Push de Ramas Actualizadas

IMPORTANTE: Solo ejecutar si tienes permisos de push a ramas principales.

```bash
# Push de docs
git checkout docs
git push -u origin docs

# Push de devcontainer
git checkout devcontainer
git push -u origin devcontainer

# Push de main
git checkout main
git push -u origin main
```

**Manejo de errores comunes**:

| Error | Causa | Solución |
|-------|-------|----------|
| HTTP 403 | Sin permisos | Solicitar permisos o usar rama claude/* |
| Already up-to-date | Rama ya actualizada | Continuar con siguiente rama |
| Conflicts | Cambios divergentes | Resolver conflictos manualmente |

### Fase 3: Eliminación de Ramas Obsoletas

#### 3.1 Eliminar Ramas Feature Remotas

```bash
# Método A: Eliminar una por una
git push origin --delete feature/nombre-rama

# Método B: Eliminar múltiples
git push origin --delete \
  feature/rama1 \
  feature/rama2 \
  feature/rama3
```

**Precaución**: Verificar que las ramas están mergeadas antes de eliminar.

Verificación antes de eliminar:
```bash
# Ver si rama está mergeada en develop
git branch -r --merged origin/develop | grep feature/nombre-rama
```

#### 3.2 Eliminar Ramas Claude Remotas

```bash
# Eliminar ramas de sesiones anteriores
# NO eliminar la rama actual de trabajo
git push origin --delete claude/sesion-antigua-1
git push origin --delete claude/sesion-antigua-2
```

#### 3.3 Limpieza Local

```bash
# Cambiar a develop antes de eliminar ramas locales
git checkout develop

# Eliminar ramas principales locales (se recrearán cuando sea necesario)
git branch -D docs devcontainer main

# Eliminar ramas feature locales
git branch | grep 'feature/' | xargs -r git branch -D

# Eliminar ramas claude locales obsoletas
git branch -D claude/sesion-antigua-1
git branch -D claude/sesion-antigua-2
```

#### 3.4 Actualizar Referencias

```bash
# Eliminar referencias a ramas remotas eliminadas
git fetch --prune origin

# Verificar limpieza
git branch -r
```

### Fase 4: Verificación Final

#### 4.1 Verificar Estructura de Ramas

```bash
# Listar ramas remotas
git branch -r | sort
```

**Output esperado** (solo 4 ramas):
```
origin/develop
origin/devcontainer
origin/docs
origin/main
```

#### 4.2 Verificar Sincronización

```bash
# Verificar que todas las ramas están actualizadas
git fetch origin

# Ver estado de cada rama
for branch in docs devcontainer main; do
  echo "=== $branch ==="
  git log --oneline origin/$branch -5
done
```

#### 4.3 Verificar Working Tree

```bash
git checkout develop
git status
```

**Output esperado**:
```
On branch develop
Your branch is up to date with 'origin/develop'.

nothing to commit, working tree clean
```

## Uso del Script Automatizado

Se proporciona el script `cleanup_branches.sh` para automatizar el proceso:

### Ubicación

```
scripts/cleanup_branches.sh
```

### Ejecución

```bash
# Hacer ejecutable (si es necesario)
chmod +x scripts/cleanup_branches.sh

# Ejecutar
./scripts/cleanup_branches.sh
```

### Funcionamiento

El script guía paso a paso con confirmaciones:
1. Push de ramas principales
2. Eliminación de ramas feature
3. Eliminación de ramas claude
4. Limpieza local
5. Verificación final

**Responder 'y' a cada pregunta para completar el proceso.**

## Solución de Problemas

### Problema: Error 403 al hacer push

```
error: RPC failed; HTTP 403 curl 22
```

**Causa**: Sin permisos de escritura en rama protegida

**Solución**:
1. Verificar permisos en GitHub/GitLab
2. Usar rama alternativa (claude/*)
3. Solicitar permisos al administrador

### Problema: Rama ya eliminada

```
error: unable to delete 'feature/xxx': remote ref does not exist
```

**Causa**: Rama ya fue eliminada previamente

**Solución**: Ignorar y continuar con siguiente rama

### Problema: No se puede eliminar rama local

```
error: Cannot delete branch 'xxx' checked out at 'xxx'
```

**Causa**: Intentando eliminar rama actualmente en uso

**Solución**:
```bash
git checkout develop
git branch -D xxx
```

### Problema: Cambios no commiteados

```
error: Your local changes would be overwritten by checkout
```

**Solución**:
```bash
# Opción A: Guardar cambios
git stash
git checkout develop
git stash pop

# Opción B: Descartar cambios (precaución)
git checkout -- .
git checkout develop
```

### Problema: Merge conflicts

```
CONFLICT (content): Merge conflict in file.txt
```

**Solución**:
```bash
# Revisar archivos en conflicto
git status

# Editar archivos manualmente
# Buscar marcadores: <<<<<<< ======= >>>>>>>

# Después de resolver
git add .
git commit -m "merge: resolver conflictos de merge"
```

## Post-Ejecución

### Documentar Resultado

Actualizar registro en `docs/qa/registros/YYYY_MM_DD_merge_ramas.md`:

```markdown
Estado final:
- Ramas remotas: 4 (develop, docs, devcontainer, main)
- Ramas eliminadas: X feature/*, Y claude/*
- Commits mergeados: Z
- Problemas encontrados: [descripción]
```

### Notificar al Equipo

Informar en canal de desarrollo:
```
Limpieza de ramas completada:
- Sincronizadas: docs, devcontainer, main con develop
- Eliminadas: X ramas obsoletas
- Estructura: 4 ramas principales
- Detalles: docs/qa/registros/YYYY_MM_DD_merge_ramas.md
```

## Mantenimiento Preventivo

### Frecuencia Recomendada

- **Sincronización de ramas**: Después de cada release
- **Limpieza de ramas feature**: Semanal
- **Limpieza de ramas claude**: Después de cada sesión
- **Auditoría completa**: Mensual

### Automatización

Considerar crear GitHub Action para:
- Detectar ramas obsoletas
- Notificar ramas sin actividad > 30 días
- Sugerir limpieza mensual

## Comandos de Referencia

```bash
# Ver todas las ramas
git branch -a

# Ver ramas remotas
git branch -r

# Ver ramas locales
git branch

# Ver historial
git log --oneline --graph --all -20

# Ver diferencias entre ramas
git diff develop..main

# Actualizar referencias
git fetch --prune origin

# Ver estado
git status

# Ver ramas mergeadas
git branch -r --merged origin/develop

# Ver última actividad
git for-each-ref --sort=-committerdate refs/remotes/
```

## Referencias

- Procedimiento de Gestión de Cambios: `docs/gobernanza/procesos/procedimiento_gestion_cambios.md`
- Procedimiento de Release: `docs/gobernanza/procesos/procedimiento_release.md`
- Registros de QA: `docs/qa/registros/`
- Scripts: `scripts/`

---

Última actualización: 2025-11-05
Versión: 1.0.0
