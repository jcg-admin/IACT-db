---
title: Feature Request - Sistema de Automatizacion Local con Scripts Shell
issue_number: IACT-AUTO-001
date: 2025-11-13
phase: planning
status: pending
domain: operaciones
priority: P1
story_points: 13
modelo_referencia: TFG-Server (solo como referencia tecnica)
---

# Feature Request: Sistema de Automatizacion Local con Scripts Shell

**Issue**: IACT-AUTO-001
**Domain**: Operaciones
**Phase**: FASE 1 - PLANNING
**Date**: 2025-11-13
**Priority**: P1 (High)
**Story Points**: 13 SP
**Estimated Duration**: 2-3 semanas

---

## Auto-CoT: Descomposicion Sistematica del Problema

### Step 1: Identificar el Problema

**Contexto Actual**:
- IACT tiene excelente estructura de documentacion (por dominios)
- IACT tiene agentes IA bien documentados
- IACT probablemente usa GitHub Actions para CI/CD
- IACT NO tiene sistema de scripts shell locales
- IACT NO tiene sistema de constitucion para agentes
- IACT NO tiene git hooks automaticos instalables

**Problema**:
- Dependencia de GitHub Actions (vendor lock-in)
- Sin validacion local antes de push
- Sin principios codificados para guiar agentes IA
- Sin pipeline CI/CD ejecutable offline
- Sin automatizacion de releases

### Step 2: Analizar Solucion (Modelo de Referencia)

**El sistema de automatizacion local (basado en patron de TFG-Server) ofrece**:
1. Sistema de scripts shell puro (`scripts/bash/`)
2. Pipeline CI/CD local completo
3. Sistema de constitucion para agentes IA (`memory/constitution.md`)
4. Git hooks automaticos (pre-commit, pre-push, post-commit)
5. Spec-driven development
6. Release automatizado con semantic versioning
7. Generacion de documentacion automatizada

**Componentes clave**:
- `ci-local.sh` - Pipeline CI/CD completo
- `release-local.sh` - Release automatizado
- `spec-hooks-install.sh` - Instalador de git hooks
- `constitution-evolution.sh` - Evolucion de principios
- `build-docs.sh` - Generacion de docs

### Step 3: Determinar Alcance de Adopcion

**Auto-CoT Sub-question**: ¿Adoptar todo o selectivamente?

**Analisis**:
- IACT tiene estructura docs superior a TFG-Server → NO adoptar estructura docs
- IACT necesita CI/CD local → SI adoptar scripts CI/CD
- IACT usa agentes IA → SI adoptar sistema constitucion
- IACT necesita validacion automatica → SI adoptar git hooks

**Conclusion**: Adopcion selectiva de componentes valiosos

### Step 4: Identificar Fases de Implementacion

**Fase 1** - Git Hooks (Alta prioridad, 3 SP):
- Validacion automatica antes de commit/push
- Rapido de implementar
- Alto valor inmediato

**Fase 2** - Sistema Constitucion (Media prioridad, 5 SP):
- Principios para agentes IA
- Evolucion basada en experiencia
- Complementa ADRs existentes

**Fase 3** - Scripts CI/CD (Baja-Media prioridad, 5 SP):
- Pipeline local ejecutable
- Independencia de GitHub Actions
- Offline-capable

---

## Self-Consistency: Validacion Multi-Enfoque

### Enfoque 1: Analisis de Necesidades (Bottom-Up)

**Pregunta**: ¿Que necesita IACT actualmente?

**Necesidades Identificadas**:
1. Validacion automatica local (evitar push de codigo roto)
2. Principios codificados para agentes IA (consistencia)
3. CI/CD ejecutable localmente (offline, rapido)
4. Releases automatizados (semver, changelog)
5. Independencia de plataformas cloud

**Prioridad**:
- ALTA: Git hooks (validacion)
- ALTA: Constitucion agentes (mejora calidad)
- MEDIA: CI/CD local (conveniencia)
- MEDIA: Release automatizado (frecuencia releases)

**Conclusion Enfoque 1**: Priorizar git hooks y constitucion.

### Enfoque 2: Analisis de Compatibilidad (Top-Down)

**Pregunta**: ¿Como encaja TFG-Server en estructura IACT?

**Mapeo Propuesto**:

| Componente TFG-Server | Ubicacion IACT | Compatibilidad |
|----------------------|----------------|----------------|
| `scripts/bash/` | `scripts/automatizacion/` | ALTA - nueva carpeta |
| `memory/constitution.md` | `docs/gobernanza/constitucion_agentes.md` | ALTA - encaja perfecto |
| `.git/hooks/` | `.git/hooks/` | ALTA - estandar Git |
| `docs/` | `docs/` (ya existe superior) | BAJA - no adoptar |
| `templates/` | `docs/gobernanza/plantillas/` | MEDIA - ya existe similar |

**Conclusion Enfoque 2**: Alta compatibilidad, adopcion sin romper estructura.

### Enfoque 3: Analisis ROI (Value-Based)

**Pregunta**: ¿Que componente da mas valor con menos esfuerzo?

**Matriz Valor/Esfuerzo**:

```
Alto Valor
│
│  [Git Hooks]         [Constitucion]
│      (3 SP)              (5 SP)
│
│                      [CI/CD Local]
│                          (5 SP)
│
│  [Docs Structure]    [Templates]
│      (N/A)              (2 SP)
│
└────────────────────────────────── Alto Esfuerzo
   Bajo Esfuerzo
```

**Quick Wins** (Alto Valor + Bajo Esfuerzo):
1. Git hooks - 3 SP, valor inmediato
2. Constitucion agentes - 5 SP, mejora calidad agentes

**Inversiones Estrategicas** (Alto Valor + Alto Esfuerzo):
3. CI/CD local - 5 SP, independencia de GitHub

**Evitar** (Bajo Valor):
4. Docs structure - IACT superior
5. Templates - IACT ya tiene en gobernanza

**Conclusion Enfoque 3**: Priorizar Quick Wins primero.

### Validacion de Consistencia

**Convergencia de los 3 enfoques**:
- ✅ PRIORIDAD ALTA: Git hooks (3 enfoques coinciden)
- ✅ PRIORIDAD ALTA: Sistema constitucion (3 enfoques coinciden)
- ✅ PRIORIDAD MEDIA: CI/CD local (2 de 3 enfoques)
- ❌ NO ADOPTAR: Estructura docs (3 enfoques coinciden)

**Confianza en decision**: 95% (alta convergencia)

---

## User Story

**As a** desarrollador/agente IA trabajando en IACT
**I want** sistema de automatizacion con scripts shell, git hooks y constitucion
**So that** puedo validar cambios localmente, seguir principios codificados y trabajar offline sin depender de GitHub Actions

### Acceptance Criteria

**AC1: Git Hooks Instalados y Funcionando**
- GIVEN un desarrollador clona el repositorio
- WHEN ejecuta `./scripts/automatizacion/install-hooks.sh`
- THEN git hooks se instalan en `.git/hooks/`
- AND pre-commit valida formato y sintaxis (< 5 segundos)
- AND pre-push ejecuta linting y tests (< 60 segundos)

**AC2: Sistema de Constitucion Activo**
- GIVEN existe `docs/gobernanza/constitucion_agentes.md`
- WHEN un agente IA toma decision de implementacion
- THEN consulta principios en constitucion
- AND decision alineada con principios documentados
- AND constitucion evoluciona basandose en experiencia

**AC3: Pipeline CI/CD Local Ejecutable**
- GIVEN un desarrollador quiere validar cambios localmente
- WHEN ejecuta `./scripts/automatizacion/ci-local.sh`
- THEN pipeline ejecuta: linting + tests + build + docs
- AND resultado en < 2 minutos
- AND funciona sin conexion a internet

**AC4: Release Automatizado Funcional**
- GIVEN commits siguen conventional commits
- WHEN ejecuta `./scripts/automatizacion/release.sh`
- THEN version calculada automaticamente (semver)
- AND CHANGELOG.md actualizado
- AND tag Git creado
- AND artefactos generados en `dist/`

**AC5: Documentacion de Sistema Completa**
- GIVEN desarrollador nuevo al sistema
- WHEN lee `docs/devops/automatizacion/README.md`
- THEN entiende como usar git hooks
- AND entiende como ejecutar CI local
- AND entiende como crear releases
- AND entiende sistema constitucion

**AC6: Integracion con Estructura IACT**
- GIVEN estructura de carpetas existente de IACT
- WHEN se adopta sistema automatizacion
- THEN NO rompe estructura de dominios existente
- AND scripts en `scripts/automatizacion/` (nueva carpeta)
- AND constitucion en `docs/gobernanza/` (carpeta existente)
- AND documentacion en `docs/devops/automatizacion/` (nueva)

---

## Operations Breakdown

### Operation 1: Crear Estructura Base

**Input**: Estructura IACT actual
**Output**: Carpetas para sistema automatizacion
**Estimated**: 0.5 SP

```
IACT---project/
├── scripts/
│   └── automatizacion/        # NUEVO
│       ├── ci/
│       ├── release/
│       └── hooks/
│
└── docs/
    ├── gobernanza/
    │   └── constitucion_agentes.md  # NUEVO
    │
    └── operaciones/
        └── automatizacion/    # NUEVO
            ├── README.md
            └── guias/
```

### Operation 2: Implementar Git Hooks

**Input**: Scripts de TFG-Server
**Output**: Git hooks funcionales en IACT
**Estimated**: 3 SP

**Sub-operaciones**:
1. Adaptar `spec-hooks-install.sh` para IACT
2. Implementar pre-commit hook (validacion rapida)
3. Implementar pre-push hook (CI completo)
4. Implementar post-commit hook (sincronizacion)
5. Documentar uso de hooks

### Operation 3: Crear Sistema Constitucion

**Input**: Experiencia actual con agentes IA en IACT
**Output**: Constitucion codificada
**Estimated**: 5 SP

**Sub-operaciones**:
1. Analizar decisiones actuales de agentes
2. Extraer principios y patrones
3. Codificar en `constitucion_agentes.md`
4. Crear script de evolucion de constitucion
5. Integrar con proceso de ADRs existente

### Operation 4: Implementar CI/CD Local

**Input**: Scripts de TFG-Server
**Output**: Pipeline CI/CD ejecutable localmente
**Estimated**: 5 SP

**Sub-operaciones**:
1. Adaptar `ci-local.sh` para IACT
2. Configurar linters (markdown, python, shell)
3. Integrar suite de tests existente
4. Agregar generacion de documentacion
5. Optimizar para velocidad (< 2 min)

### Operation 5: Implementar Release Automatizado

**Input**: Historial de commits
**Output**: Sistema de releases automatico
**Estimated**: 3 SP (incluido en Operation 4, no suma)

**Sub-operaciones**:
1. Adaptar scripts de release/
2. Configurar semantic versioning
3. Automatizar generacion de CHANGELOG
4. Crear paquetes distribución
5. Documentar proceso de release

### Operation 6: Documentar Sistema

**Input**: Sistema implementado
**Output**: Documentacion completa
**Estimated**: 2 SP (incluido en otras operaciones)

**Sub-operaciones**:
1. Crear README principal
2. Crear guias de uso por componente
3. Crear troubleshooting guide
4. Documentar integracion con IACT
5. Crear ejemplos de uso

---

## Technical Requirements

### TR-1: Compatibilidad con Estructura IACT

**Requisito**: No romper estructura de carpetas existente

**Implementacion**:
- Scripts en `scripts/automatizacion/` (nueva carpeta hermana de `scripts/coding/`)
- Constitucion en `docs/gobernanza/` (carpeta existente)
- Docs en `docs/devops/automatizacion/` (paralela a `docs/devops/git/`)

### TR-2: Git Hooks Configurables

**Requisito**: Hooks deben ser configurables por desarrollador

**Implementacion**:
- Variables de entorno para customizar comportamiento
- `.git-hooks-config` para configuracion local
- Bypass temporal con `--no-verify` disponible

Ejemplo:
```bash
# .git-hooks-config
SKIP_SLOW_TESTS=1
ENABLE_AUTO_FIX=1
STRICT_COMMITS=1
```

### TR-3: Constitucion Evolucionable

**Requisito**: Constitucion debe evolucionar con proyecto

**Implementacion**:
- Formato markdown para facil edicion
- Versionado en Git
- Script para proponer updates basados en commits/ADRs
- Proceso de review para cambios a constitucion

### TR-4: CI/CD Offline-Capable

**Requisito**: CI/CD debe funcionar sin internet

**Implementacion**:
- Todas las dependencias instalables localmente
- Sin llamadas a APIs externas requeridas
- Cache de dependencias
- Fallback graceful si servicios externos no disponibles

### TR-5: Integracion con Agentes IA Existentes

**Requisito**: Sistema debe integrarse con agentes IA de IACT

**Implementacion**:
- Constitucion en formato legible por agentes
- Scripts invocables por agentes
- Contexto compartido actualizable
- Logs estructurados para analisis

---

## Dependencies

### Internal Dependencies

**DEP-1: Estructura de Dominios IACT**
- Sistema debe respetar organizacion por dominios
- Status: SATISFECHO (estructura bien definida)

**DEP-2: ADRs Existentes**
- Constitucion debe complementar ADRs, no reemplazar
- Status: SATISFECHO (ADRs estandarizados recientemente)

**DEP-3: Agentes IA Documentados**
- Sistema constitucion debe considerar agentes existentes
- Status: SATISFECHO (45+ agentes documentados)

### External Dependencies

**DEP-4: Herramientas de Linting**
- markdownlint-cli2
- shellcheck
- ruff (Python)

**DEP-5: Herramientas de Testing**
- pytest
- coverage

**DEP-6: Git 2.30+**
- Para hooks avanzados

---

## Risk Assessment

### Risk 1: Resistencia al Cambio del Equipo

**Probability**: Medium (40%)
**Impact**: Medium
**Overall Risk**: MEDIUM (4/10)

**Mitigation**:
- Documentacion clara y ejemplos
- Demostracion de beneficios
- Adopcion gradual (empezar con git hooks)
- Training sessions si necesario

### Risk 2: Complejidad de Mantenimiento

**Probability**: Medium (30%)
**Impact**: Medium
**Overall Risk**: LOW-MEDIUM (3/10)

**Mitigation**:
- Scripts bien documentados
- Pruebas automatizadas de scripts
- Documentacion de troubleshooting
- Designar owner del sistema

### Risk 3: Conflicto con CI/CD Existente

**Probability**: Low (20%)
**Impact**: High
**Overall Risk**: MEDIUM (4/10)

**Mitigation**:
- Analizar CI/CD actual antes de implementar
- CI local complementa CI remoto, no reemplaza
- Mantener GitHub Actions como backup
- Migracion gradual si decide reemplazar

### Risk 4: Constitucion Mal Definida

**Probability**: Low (15%)
**Impact**: Medium
**Overall Risk**: LOW (2/10)

**Mitigation**:
- Empezar con principios basicos
- Evolucion iterativa
- Review por equipo senior
- Validacion con agentes antes de aplicar

### Risk 5: Hooks Demasiado Lentos

**Probability**: Low (10%)
**Impact**: Medium
**Overall Risk**: LOW (1/10)

**Mitigation**:
- Optimizar hooks (target: pre-commit < 5s, pre-push < 60s)
- Configuracion para skip checks lentos
- Bypass disponible con --no-verify
- Monitorear tiempos y optimizar

---

## Success Metrics

### M1: Adopcion de Git Hooks

**Metrica**: Porcentaje de desarrolladores usando hooks
**Target**: >= 90%
**Measurement**: Analisis de commits (formato, validaciones)

### M2: Reduccion de CI Remoto Fallido

**Metrica**: Porcentaje de pushes que pasan CI remoto en primer intento
**Baseline**: Establecer en mes 1
**Target**: +30% mejora respecto a baseline
**Measurement**: Analytics de GitHub Actions

### M3: Calidad de Decisiones de Agentes

**Metrica**: Porcentaje de implementaciones de agentes que pasan code review sin cambios mayores
**Baseline**: Establecer en mes 1
**Target**: +25% mejora respecto a baseline
**Measurement**: Review de PRs de agentes

### M4: Tiempo de Validacion Local

**Metrica**: Tiempo promedio para ejecutar `ci-local.sh`
**Target**: < 2 minutos
**Measurement**: Logs de ejecucion

### M5: Frecuencia de Releases

**Metrica**: Numero de releases por mes
**Baseline**: Establecer baseline actual
**Target**: +50% incremento (si releases automatizados reducen friccion)
**Measurement**: Git tags

### M6: Satisfaccion del Equipo

**Metrica**: Encuesta de satisfaccion con nuevo sistema
**Target**: >= 4/5 promedio
**Measurement**: Survey trimestral

---

## Implementation Phases (Summary)

### FASE 1: Git Hooks (Sprint 1 - 1 semana)
- Story Points: 3 SP
- Deliverable: Hooks instalables y funcionando
- Value: Validacion automatica inmediata

### FASE 2: Sistema Constitucion (Sprint 2 - 1.5 semanas)
- Story Points: 5 SP
- Deliverable: Constitucion codificada y evolucionable
- Value: Mejora calidad decisiones agentes

### FASE 3: CI/CD Local (Sprint 3 - 1.5 semanas)
- Story Points: 5 SP
- Deliverable: Pipeline local completo
- Value: Independencia de GitHub, velocidad

**Total**: 13 SP, 3-4 semanas (considerando overlap y testing)

---

## Next Phase

After PLANNING approval, proceed to:
- FASE 2 - FEASIBILITY: Technical feasibility analysis and GO/NO-GO decision

---

**Status**: PENDING APPROVAL
**Assigned To**: SDLC Agent - Automation Track
**Labels**: automation, git-hooks, constitution, ci-cd, P1
**Estimated Completion**: 2025-12-06 (3-4 semanas desde hoy)
**Dependencies**: Ninguna bloqueante
