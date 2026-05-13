---
title: Plan de Reorganizacion - Adoptar Estructura TFG-Server en IACT
date: 2025-11-13
source_model: TFG-server (estructura de referencia)
target_project: IACT---project
status: planning
---

# Plan de Reorganizacion: Adoptar Estructura de Documentacion TFG-Server

**Modelo de Referencia**: TFG-server (estructura docs/)
**Proyecto a Reorganizar**: IACT---project
**Fecha**: 2025-11-13
**Estado**: Planificacion

---

## 1. Analisis de Estructuras

### 1.1 Estructura Actual IACT---project

```
IACT---project/docs/devops/git/
├── README.md                           # Entry point, roadmap
├── planificacion/                      # SDLC docs
│   ├── ISSUE_GIT_DOCS_REORGANIZATION.md
│   ├── FEASIBILITY_ANALYSIS_GIT_DOCS.md
│   ├── HLD_GIT_DOCS_REORGANIZATION.md
│   ├── LLD_GIT_DOCS_REORGANIZATION.md
│   ├── TESTING_PLAN_GIT_DOCS.md
│   ├── DEPLOYMENT_PLAN_GIT_DOCS.md
│   └── MAINTENANCE_PLAN_GIT_DOCS.md
│
├── nivel_1_basico/
│   └── GIT_GITHUB_GUIA_INICIO.md
│
├── nivel_2_intermedio/
│   └── FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
│
└── nivel_3_avanzado/
    └── MERGE_STRATEGY_NO_COMMON_ANCESTOR.md
```

### 1.2 Estructura TFG-Server (Destino)

```
TFG-server/docs/
├── analisis/                    # Requisitos y analisis
├── diseno_solucion/            # Arquitectura y diseno
├── devops/                     # Automatizacion y CI/CD
│   ├── README.md
│   ├── automatizacion_ci_cd.md  # Guia existente
│   └── [AQUI: git/]            # NUEVO - Guias Git
│
└── anexos/                     # Material complementario
```

**Ubicacion Propuesta**: `TFG-server/docs/devops/git/`

**Razon**: El directorio `devops/` ya existe para automatizacion. Las guias Git complementan la automatizacion CI/CD existente.

---

## 2. Estrategia de Integracion

### 2.1 Opcion A: Copia Directa (RECOMENDADA)

**Descripcion**: Copiar toda la estructura `git/` de IACT a TFG-Server

**Pasos**:
```bash
# 1. Navegar a TFG-server
cd /path/to/TFG-server

# 2. Copiar estructura completa
cp -r /home/user/IACT---project/docs/devops/git/ docs/devops/

# 3. Adaptar referencias especificas de IACT a TFG-Server
# (ver seccion 2.3)
```

**Ventajas**:
- Mantiene toda la estructura de 3 niveles
- Incluye SDLC completo para referencia
- No requiere modificar contenido tecnico

**Desventajas**:
- Algunas referencias pueden ser especificas de IACT
- Necesita adaptacion de ejemplos

### 2.2 Opcion B: Symlink (NO RECOMENDADA)

**Descripcion**: Crear symlink desde TFG-server a IACT---project

**Razon de NO recomendar**: Proyectos diferentes, repositorios diferentes, no deben acoplarse.

### 2.3 Adaptaciones Necesarias

**Cambios Requeridos** (Opcion A):

1. **Referencias a Scripts**:

En IACT---project:
```markdown
# Ejecutar validacion completa
./scripts/bash/ci-local.sh
```

En TFG-Server:
```markdown
# Ejecutar validacion completa
./scripts/bash/ci-local.sh  # (mismo script, TFG-Server ya lo tiene)
```
NOTA: TFG-Server ya tiene estos scripts segun README compartido.

2. **Referencias a Convenciones**:

Ambos proyectos siguen Conventional Commits, no requiere cambios.

3. **Referencias de Branch Naming**:

IACT usa: `feature/XXX-descripcion`
TFG-Server: Verificar convencion (probablemente igual)

Si diferente, actualizar seccion "Convenciones de Nombres de Ramas" en nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md

4. **Contexto Especifico**:

Ejemplos en MERGE_STRATEGY_NO_COMMON_ANCESTOR.md mencionan:
```
branch_source: claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R
```

Cambiar a:
```
branch_source: [tu-branch-nombre]
```
(Hacer ejemplos genericos)

---

## 3. Actualizacion del Indice TFG-Server

### 3.1 Actualizar docs/README.md (Principal)

**Seccion a Agregar** (despues de DevOps):

```markdown
### 3. [DevOps y Automatizacion](devops/)
Infraestructura, automatizacion y procesos CI/CD.

**Contenido principal:**
- **[Automatizacion CI/CD](devops/automatizacion_ci_cd.md)**: Guia completa de automatizacion
- **[Git/GitHub - Guias por Nivel](devops/git/)**: Documentacion jerarquica de workflows Git
  - Nivel 1 - Basico: Comandos esenciales para nuevos desarrolladores
  - Nivel 2 - Intermedio: Sync con develop, conflictos complejos
  - Nivel 3 - Avanzado: Casos especiales (merge sin ancestro comun)
  - Roadmap de aprendizaje y matriz de decisiones
```

### 3.2 Actualizar docs/devops/README.md (Si Existe)

Agregar seccion:

```markdown
## Guias Git/GitHub

Para trabajar eficientemente con Git en TFG-Server, consulta nuestras guias organizadas por nivel de experiencia:

- **[Documentacion Git Completa](git/README.md)** - Entry point con roadmap de aprendizaje

- **Nivel 1 - Basico** (0-6 meses experiencia)
  - [Guia de Inicio](git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md)
  - Comandos fundamentales, workflows diarios, convenciones

- **Nivel 2 - Intermedio** (6+ meses experiencia)
  - [Flujo de Sync con Develop](git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md)
  - Feature branches de larga duracion, conflictos complejos

- **Nivel 3 - Avanzado** (1+ años experiencia)
  - [Estrategia para Merge sin Ancestro Comun](git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md)
  - Cherry-pick, casos especiales

**Inicio Rapido**: Si eres nuevo, comienza con [Nivel 1 - Basico](git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md)
```

---

## 4. Integracion con Automatizacion Existente

### 4.1 Referencias Cruzadas

**En automatizacion_ci_cd.md**:

Agregar seccion sobre Git workflows:

```markdown
## Pre-requisitos: Conocimientos de Git

Antes de trabajar con la automatizacion, asegurate de dominar:

- Comandos basicos de Git: Ver [Guia de Inicio Git](git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md)
- Sync con develop: Ver [Flujo de Sync](git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md)
- Convenciones de commits: Conventional Commits (documentado en guias Git)

**Roadmap de aprendizaje Git**: [git/README.md](git/README.md)
```

**En git/README.md**:

Agregar referencia a automatizacion:

```markdown
## Integracion con Automatizacion CI/CD

Este proyecto utiliza scripts de automatizacion que se integran con los workflows Git:

- **Git Hooks**: Se instalan automaticamente con `./scripts/bash/spec-hooks-install.sh`
- **Validacion Pre-Push**: Los hooks ejecutan tests antes de push
- **CI Local**: Ejecuta `./scripts/bash/ci-local.sh` para validacion completa

**Documentacion completa**: [Automatizacion CI/CD](../automatizacion_ci_cd.md)
```

### 4.2 Git Hooks y Guias

**Conexion**:
- Git hooks (spec-hooks-install.sh) validan convenciones
- Guias Git documentan esas convenciones
- Bi-direccional: hooks mencionan guias, guias mencionan hooks

**Ejemplo en hook**:
```bash
# En pre-commit hook
if ! check_branch_naming; then
  echo "ERROR: Nombre de branch invalido"
  echo "Ver convenciones: docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md#convenciones-de-nombres-de-ramas"
  exit 1
fi
```

---

## 5. Procedimiento de Integracion

### PASO 1: Preparar TFG-Server (5 min)

```bash
cd /path/to/TFG-server
git checkout -b docs/integrate-git-guides
git pull origin main  # Asegurar actualizado
```

### PASO 2: Copiar Estructura (2 min)

```bash
# Desde directorio TFG-server
cp -r /home/user/IACT---project/docs/devops/git/ docs/devops/

# Verificar copia exitosa
ls -R docs/devops/git/
```

### PASO 3: Adaptar Contenido (1 hora)

1. **Actualizar frontmatter** en nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md:
   - Cambiar `branch_source` y `branch_target` a valores genericos o removerlos
   - Cambiar ejemplos de "IACT---project" a "TFG-server" o hacer genericos

2. **Revisar scripts de validacion**:
   - Actualizar paths si necesario (probablemente no, usa relative paths)

3. **Revisar referencias a scripts**:
   - Verificar que scripts mencionados existen en TFG-server
   - Segun README compartido: ci-local.sh, spec-hooks-install.sh existen

### PASO 4: Actualizar Indices (30 min)

1. Actualizar `docs/README.md` (principal)
2. Actualizar `docs/devops/README.md` (si existe, sino crear)
3. Actualizar `docs/devops/automatizacion_ci_cd.md` con referencias cruzadas

### PASO 5: Validar (15 min)

```bash
# Ejecutar validation script
./docs/devops/git/planificacion/validate-git-docs.sh

# Verificar links manualmente
# (Abrir cada guia, verificar cross-references funcionan)
```

### PASO 6: Commit y Push (10 min)

```bash
git add docs/

git commit -m "$(cat <<'EOF'
docs(devops): integrate hierarchical Git documentation

Add comprehensive Git/GitHub guides organized in 3 levels:
- Level 1 (Basic): Essential commands, workflows, conventions
- Level 2 (Intermediate): Sync with develop, complex conflicts
- Level 3 (Advanced): Special cases, merge without common ancestor

Features:
- Learning roadmap for progressive skill development
- Decision matrix for quick guide discovery
- Cross-references between guides
- Integrated with existing CI/CD automation
- Full SDLC documentation (planning, design, testing, deployment, maintenance)

Source: IACT---project docs/devops/git/
Adapted for: TFG-server environment

Benefits:
- Faster onboarding for new developers
- Reduced support questions on Git workflows
- Clear progression path from beginner to advanced
- Foundation for future Git automation agents

Integration:
- Located in docs/devops/git/ (complements CI/CD automation)
- Cross-referenced with automatizacion_ci_cd.md
- Compatible with existing git hooks (spec-hooks-install.sh)

Metadata:
- Domain: devops
- Format: Markdown (no emojis policy)
- Test Coverage: 100% (30/30 tests passing in source)
EOF
)"

git push -u origin docs/integrate-git-guides
```

### PASO 7: Create Pull Request

1. Ir a GitHub TFG-server
2. Crear PR desde `docs/integrate-git-guides` a `main`
3. Titulo: "docs(devops): integrate hierarchical Git documentation"
4. Descripcion: Copiar del commit message + agregar screenshots si aplica
5. Solicitar review

---

## 6. Validacion Post-Integracion

### Checklist:

- [ ] Estructura `docs/devops/git/` existe con 4 subdirectorios
- [ ] README.md principal actualizado con seccion Git
- [ ] docs/devops/README.md actualizado (o creado)
- [ ] Cross-referencias entre automatizacion_ci_cd.md y git/ funcionan
- [ ] Validation script ejecuta sin errores
- [ ] Todos los links internos funcionan
- [ ] Ejemplos adaptados a TFG-Server (no menciones a IACT especificas)
- [ ] No hay emojis en documentacion
- [ ] Frontmatter YAML valido en todas las guias

---

## 7. Mantenimiento Sincronizado

### Pregunta: Mantener sincronizados IACT y TFG-Server?

**Opcion A: Repositorios Independientes**
- Cada proyecto mantiene su version
- Actualizaciones se aplican manualmente a ambos
- Permite customizacion por proyecto
- **RECOMENDADA**

**Opcion B: Fuente Unica**
- Mantener guias en un repo, ambos proyectos referencian
- Mas complejo de configurar
- No recomendado para proyectos independientes

**Decision**: Opcion A - Mantener copias independientes, sincronizar manualmente cuando hay updates importantes.

### Proceso de Sincronizacion (Si Necesario):

1. Cuando se actualiza guia en IACT:
   - Determinar si update aplica a TFG-Server
   - Si aplica: Replicar cambio manualmente
   - Commit en TFG-Server con referencia a commit de IACT

2. Cuando se actualiza guia en TFG-Server:
   - Determinar si update aplica a IACT
   - Si aplica: Replicar cambio manualmente
   - Commit en IACT con referencia a commit de TFG-Server

---

## 8. Diferencias Potenciales Entre Proyectos

### Areas a Verificar:

**Branch Naming Conventions**:
- IACT: `feature/XXX-descripcion`
- TFG-Server: [VERIFICAR - probablemente igual]
- Accion: Si diferente, actualizar seccion correspondiente

**Commit Message Format**:
- IACT: Conventional Commits
- TFG-Server: Conventional Commits (confirmado en README)
- Accion: No requiere cambios

**Git Hooks**:
- IACT: [Verificar si tiene hooks instalados]
- TFG-Server: Tiene spec-hooks-install.sh
- Accion: Mencionar hooks de TFG-Server en guias

**Workflow Principal** (main vs develop):
- IACT: Parece usar develop como branch principal para features
- TFG-Server: [VERIFICAR - probablemente main protegido]
- Accion: Si diferente, actualizar ejemplos

---

## 9. Mejoras Especificas para TFG-Server

### Oportunidades de Adaptacion:

1. **Agregar Seccion: Git con Scripts de Automatizacion**
   - Como usar ci-local.sh antes de push
   - Como interpretar errores de git hooks
   - Troubleshooting cuando hooks bloquean commits

2. **Agregar Guia: Workflow para Documentacion**
   - Especifico para updates de docs/
   - Como validar documentacion antes de commit
   - Convenciones especificas de TFG-Server

3. **Agregar Ejemplos TFG-Server**:
   - Reemplazar ejemplos genericos con casos reales del proyecto
   - Branch names reales usados
   - Commits reales como ejemplos

---

## 10. Timeline Estimado

| Paso | Duracion | Responsable |
|------|----------|-------------|
| 1. Preparar TFG-Server | 5 min | Desarrollador |
| 2. Copiar estructura | 2 min | Desarrollador |
| 3. Adaptar contenido | 1 hora | Desarrollador |
| 4. Actualizar indices | 30 min | Desarrollador |
| 5. Validar | 15 min | Desarrollador |
| 6. Commit y push | 10 min | Desarrollador |
| 7. Create PR | 10 min | Desarrollador |
| 8. Review y merge | 30 min | Tech Lead |
| **TOTAL** | **~2.5 horas** | |

---

## 11. Riesgos y Mitigaciones

### Riesgo 1: Contenido Desactualizado Rapidamente

**Riesgo**: Guias se desactualizan si workflows de TFG-Server cambian

**Mitigacion**:
- Incluir plan de mantenimiento (ya esta en MAINTENANCE_PLAN)
- Asignar owner en TFG-Server para mantenimiento trimestral
- Mencionar en onboarding que docs pueden estar levemente desactualizadas

### Riesgo 2: Confusion Entre Proyectos

**Riesgo**: Desarrolladores que trabajan en ambos proyectos se confunden

**Mitigacion**:
- Adaptar ejemplos especificos a cada proyecto
- Mencionar claramente el proyecto en frontmatter
- Mantener estructura identica (facilita transferencia de conocimiento)

### Riesgo 3: Links Rotos en Copia

**Riesgo**: Al copiar, relative links pueden romperse

**Mitigacion**:
- Validation script detecta links rotos
- Revisar manualmente todos los cross-references
- Probar en GitHub preview antes de merge

---

## 12. Beneficios de la Integracion

**Para TFG-Server**:
- Documentacion Git completa sin esfuerzo desde cero
- Estructura probada (100% tests passing en IACT)
- Complementa automatizacion CI/CD existente
- Acelera onboarding de nuevos desarrolladores
- Reduce preguntas sobre Git en canales de soporte

**Para el Equipo**:
- Conocimiento reutilizable entre proyectos
- Estandarizacion de workflows Git
- Base para futuros proyectos

**Para Mantenimiento**:
- Plan de mantenimiento ya definido
- Validation scripts listos para uso
- Troubleshooting guide incluido

---

## 13. Proximos Pasos Despues de Integracion

1. **Promover Documentacion**:
   - Anunciar en equipo que guias Git estan disponibles
   - Incluir en onboarding de nuevos desarrolladores
   - Mencionar en README principal del proyecto

2. **Metricas**:
   - Establecer baseline de preguntas Git en canales de soporte
   - Medir reduccion despues de 1 mes
   - Ajustar contenido segun feedback

3. **Mejoras Continuas**:
   - Agregar ejemplos especificos de TFG-Server
   - Crear guia adicional si se identifica gap
   - Mantener sincronizado con evolucio

n de workflows

---

**Status**: PLAN COMPLETO
**Recomendacion**: Proceder con integracion usando Opcion A (Copia Directa)
**Esfuerzo Estimado**: 2.5 horas
**Beneficio**: Alto (documentacion completa sin desarrollo desde cero)
**Proximo Paso**: Ejecutar PASO 1-7 del procedimiento de integracion
