---
id: PROC-DEV-001
tipo: proceso
categoria: desarrollo
subcategoria: sdlc
version: 1.0.0
fecha_creacion: 2025-11-17
autor: Claude Code (Sonnet 4.5)
estado: activo
aprobado_por: pendiente
relacionados: ["PROC-SDLC-001", "GUIA-001"]
---

# PROCESO: Pipeline de Trabajo IACT

## Objetivo

Definir el flujo completo de trabajo desde que se identifica un requerimiento hasta que se deploya a producción, asegurando calidad, trazabilidad y cumplimiento de estándares del proyecto IACT.

---

## Alcance

### Incluye
- Flujo completo de desarrollo (feature request → producción)
- Análisis y diseño de soluciones
- Implementación de código
- Testing (unit, integration, E2E)
- Code review
- Deployment (staging → producción)
- Monitoreo post-deployment

### NO Incluye
- Gestión de incidentes en producción (ver PROC-INCIDENT-RESPONSE-001)
- Onboarding de nuevos desarrolladores (ver PROC-ONBOARDING-001)
- Gestión de releases (ver PROC-RELEASE-MANAGEMENT-001)

---

## Roles Involucrados

| Rol | Responsabilidades |
|-----|-------------------|
| **Product Owner** | Define requisitos, prioriza backlog, aprueba features |
| **Tech Lead** | Revisa diseño, aprueba PRs críticos, define arquitectura |
| **Developer** | Implementa código, escribe tests, hace code reviews |
| **QA Engineer** | Define tests E2E, valida en staging, smoke tests |
| **DevOps** | Configura pipelines CI/CD, ejecuta deployments, monitorea |

---

## Entradas (Inputs)

1. **Issue en GitHub** con:
   - Descripción del requerimiento
   - Criterios de aceptación
   - Prioridad asignada
   - Labels apropiados

2. **Contexto del Proyecto**:
   - Documentación de arquitectura
   - ADRs relevantes
   - Restricciones (RNF-002: NO Redis, etc.)

3. **Recursos**:
   - Tiempo estimado
   - Developer asignado
   - Ambiente de desarrollo configurado

---

## Salidas (Outputs)

1. **Feature funcionando en producción**
2. **Tests pasando** (coverage >= 80%)
3. **Documentación actualizada**
4. **ADR** (si hay decisión arquitectónica)
5. **Changelog actualizado**
6. **Métricas DORA registradas**

---

## FLUJO DEL PIPELINE

### ETAPA 1: ANÁLISIS Y PLANIFICACIÓN

**Objetivo**: Entender el requerimiento y diseñar la solución

**Duración estimada**: 2-4 horas

**Actividades**:

1. **Analizar Issue**
   - Leer descripción completa
   - Identificar dependencias
   - Estimar complejidad (story points)
   - Identificar riesgos

2. **Diseñar Solución**
   - Revisar ADRs relacionados
   - Identificar componentes afectados
   - Diseñar modelos/servicios/views necesarios
   - Definir estructura de tests

3. **Crear Branch**
   - Nomenclatura: `feature/ISSUE-123-descripcion-breve`
   - Desde: `main` o `develop` (según estrategia de branching)
   - Comando: `git checkout -b feature/ISSUE-123-descripcion`

**Criterios de Salida**:
- [ ] Diseño técnico claro
- [ ] Branch creado
- [ ] Componentes identificados
- [ ] Estimación de tiempo realista

**Procedimientos Relacionados**:
- PROCED-ANALIZAR-REQUISITOS-001
- PROCED-CREAR-BRANCH-001

---

### ETAPA 2: IMPLEMENTACIÓN

**Objetivo**: Escribir código que cumpla los requisitos

**Duración estimada**: 4-16 horas (según complejidad)

**Actividades**:

1. **Escribir Tests (TDD - Red Phase)**
   - Tests unitarios primero
   - Tests de integración
   - Verificar que tests fallan (RED)

2. **Implementar Código (TDD - Green Phase)**
   - Modelos Django
   - Services (lógica de negocio)
   - Serializers (DRF)
   - Views/ViewSets (endpoints)
   - Verificar que tests pasan (GREEN)

3. **Refactorizar (TDD - Refactor Phase)**
   - Mejorar legibilidad
   - Eliminar duplicación
   - Aplicar SOLID principles
   - Tests siguen pasando

4. **Ejecutar Linters**
   ```bash
   black callcentersite/
   isort callcentersite/
   flake8 callcentersite/
   ```

5. **Verificar Coverage**
   ```bash
   pytest --cov=callcentersite --cov-report=term --cov-fail-under=80
   ```

**Criterios de Salida**:
- [ ] Tests unitarios pasan
- [ ] Tests de integración pasan
- [ ] Coverage >= 80%
- [ ] Linters pasan (black, isort, flake8)
- [ ] No hay TODOs pendientes críticos

**Procedimientos Relacionados**:
- PROCED-TDD-RED-GREEN-REFACTOR-001
- PROCED-EJECUTAR-TESTS-001
- PROCED-EJECUTAR-LINTERS-001

---

### ETAPA 3: CODE REVIEW PREPARATION

**Objetivo**: Preparar código para revisión por pares

**Duración estimada**: 30 minutos - 1 hora

**Actividades**:

1. **Commit Changes**
   - Conventional Commits:
     ```
     feat(users): agregar validacion de permisos granulares

     - Implementar servicio de verificacion de capacidades
     - Agregar tests unitarios para edge cases
     - Actualizar documentacion de API

     Closes #123
     ```

2. **Push to Remote**
   ```bash
   git push -u origin feature/ISSUE-123-descripcion
   ```

3. **Crear Pull Request**
   - Título: `feat(users): agregar validacion de permisos granulares`
   - Descripción con template:
     ```markdown
     ## Descripción
     Breve descripción del cambio.

     ## Tipo de cambio
     - [x] Feature nueva
     - [ ] Bug fix
     - [ ] Refactoring

     ## Checklist
     - [x] Tests pasan
     - [x] Coverage >= 80%
     - [x] Linters pasan
     - [x] Documentación actualizada

     ## Capturas (si aplica)
     Screenshots/videos si hay UI.

     Closes #123
     ```

4. **Asignar Reviewers**
   - Mínimo: 2 reviewers
   - Al menos 1 reviewer senior/tech lead

**Criterios de Salida**:
- [ ] PR creado con descripción completa
- [ ] Reviewers asignados
- [ ] Labels asignados (feature, priority, etc.)
- [ ] CI/CD pipeline triggered

**Procedimientos Relacionados**:
- PROCED-CREAR-PULL-REQUEST-001
- PROCED-CONVENTIONAL-COMMITS-001

---

### ETAPA 4: CODE REVIEW

**Objetivo**: Validar calidad del código por pares

**Duración estimada**: 2-8 horas (incluye iteraciones)

**Actividades**:

1. **Revisión Automatizada (CI/CD)**
   - Backend CI (pytest, coverage, linters)
   - Frontend CI (Jest, ESLint)
   - Security scan (Bandit, npm audit)
   - Todos los checks deben pasar

2. **Revisión Manual por Reviewers**
   - Verificar:
     - Cumple requisitos del issue
     - Código legible y mantenible
     - Tests adecuados
     - No hay code smells
     - Cumple estándares del proyecto
     - No viola ADRs

3. **Feedback y Correcciones**
   - Reviewers dejan comentarios
   - Developer corrige
   - Push de correcciones
   - Re-review si necesario

4. **Aprobación**
   - Mínimo 2 aprobaciones
   - Todos los comentarios resueltos
   - CI/CD verde

**Criterios de Salida**:
- [ ] 2+ aprobaciones recibidas
- [ ] Todos los checks CI/CD verdes
- [ ] Todos los comentarios resueltos
- [ ] Conflicts resueltos (si existen)

**Procedimientos Relacionados**:
- PROCED-CODE-REVIEW-001
- PROCED-RESOLVER-COMENTARIOS-PR-001

---

### ETAPA 5: MERGE Y DEPLOYMENT A STAGING

**Objetivo**: Integrar cambios y desplegar a ambiente de staging

**Duración estimada**: 15-30 minutos

**Actividades**:

1. **Merge to Main/Develop**
   - Método: Squash and Merge (preferido) o Merge Commit
   - Eliminar branch feature después de merge
   - Generar tag si es release

2. **Deployment Automático a Staging**
   - Trigger: Merge a `develop` branch
   - CI/CD ejecuta:
     ```yaml
     - Ejecutar migraciones (staging DB)
     - Deploy de aplicación (staging server)
     - Smoke tests automáticos
     - Notificar en Slack/Discord
     ```

3. **Verificación Manual en Staging**
   - QA Engineer valida funcionalidad
   - Product Owner valida requisitos
   - Smoke tests manuales

**Criterios de Salida**:
- [ ] Código mergeado a main/develop
- [ ] Deploy a staging exitoso
- [ ] Smoke tests pasan
- [ ] Feature validada por QA

**Procedimientos Relacionados**:
- PROCED-MERGE-PR-001
- PROCED-DEPLOY-STAGING-001
- PROCED-SMOKE-TESTS-001

---

### ETAPA 6: DEPLOYMENT A PRODUCCIÓN

**Objetivo**: Desplegar feature a producción de forma segura

**Duración estimada**: 30 minutos - 1 hora

**Pre-requisitos**:
- Feature validada en staging
- Aprobación de Product Owner
- Ventana de deployment disponible
- Backup de BD completado

**Actividades**:

1. **Pre-Deployment Checklist**
   - [ ] Backup de base de datos completado
   - [ ] Changelog actualizado
   - [ ] Release notes preparadas
   - [ ] Rollback plan definido
   - [ ] Equipo notificado

2. **Ejecutar Deployment**
   ```bash
   # Manual trigger o automático desde main
   - Activar maintenance mode (si necesario)
   - Ejecutar migraciones en producción
   - Deploy de aplicación
   - Smoke tests automáticos
   - Desactivar maintenance mode
   ```

3. **Validación Post-Deployment**
   - Smoke tests manuales
   - Verificar logs (sin errores)
   - Verificar métricas (response time, error rate)
   - Validar feature funciona en producción

4. **Monitoreo (primeras 2 horas)**
   - Observar error rate
   - Observar response times
   - Revisar logs de aplicación
   - Estar listo para rollback si necesario

**Criterios de Salida**:
- [ ] Deploy a producción exitoso
- [ ] Smoke tests pasan
- [ ] Métricas normales (error rate, response time)
- [ ] Feature funcionando en producción
- [ ] Equipo notificado del deployment exitoso

**Procedimientos Relacionados**:
- PROCED-DEPLOY-PRODUCCION-001
- PROCED-ROLLBACK-001 (si falla)
- PROCED-POST-DEPLOYMENT-MONITORING-001

---

### ETAPA 7: POST-DEPLOYMENT

**Objetivo**: Validar éxito y cerrar ciclo

**Duración estimada**: 30 minutos

**Actividades**:

1. **Actualizar Issue**
   - Marcar como completado
   - Agregar link a PR
   - Agregar link a deployment
   - Cerrar issue

2. **Actualizar Documentación**
   - Actualizar README si aplica
   - Actualizar API docs si aplica
   - Crear/actualizar ADR si hay decisión arquitectónica

3. **Registrar Métricas DORA**
   - Lead Time for Changes
   - Deployment Frequency
   - Mean Time to Recovery (si hubo incidente)
   - Change Failure Rate

4. **Retrospectiva (opcional)**
   - Qué salió bien
   - Qué mejorar
   - Lecciones aprendidas

**Criterios de Salida**:
- [ ] Issue cerrado
- [ ] Documentación actualizada
- [ ] Métricas DORA registradas
- [ ] Retrospectiva documentada (si aplica)

**Procedimientos Relacionados**:
- PROCED-CERRAR-ISSUE-001
- PROCED-ACTUALIZAR-DOCS-001
- PROCED-REGISTRAR-METRICAS-DORA-001

---

## DIAGRAMA DE FLUJO

```
[Issue en GitHub]
        ↓
[ETAPA 1: Análisis]
  - Analizar requisitos
  - Diseñar solución
  - Crear branch
        ↓
[ETAPA 2: Implementación]
  - TDD: Red → Green → Refactor
  - Ejecutar linters
  - Verificar coverage
        ↓
[ETAPA 3: PR Preparation]
  - Commit con Conventional Commits
  - Push a remote
  - Crear Pull Request
        ↓
[ETAPA 4: Code Review]
  - CI/CD automático
  - Revisión manual por pares
  - Correcciones si necesario
  - Aprobación (2+ reviewers)
        ↓
[ETAPA 5: Merge & Deploy Staging]
  - Merge a main/develop
  - Deploy automático a staging
  - Validación por QA
        ↓
    ¿Aprobado?
    ├─ NO → Corregir en nueva iteración
    └─ SI ↓
[ETAPA 6: Deploy Producción]
  - Pre-deployment checklist
  - Ejecutar deployment
  - Smoke tests
  - Monitoreo (2 horas)
        ↓
    ¿Exitoso?
    ├─ NO → Rollback (PROCED-ROLLBACK-001)
    └─ SI ↓
[ETAPA 7: Post-Deployment]
  - Cerrar issue
  - Actualizar docs
  - Registrar métricas DORA
        ↓
[Feature en Producción]
```

---

## MÉTRICAS DEL PROCESO

### KPIs Principales

| Métrica | Target | Medición |
|---------|--------|----------|
| **Lead Time for Changes** | < 3 días | Desde commit hasta producción |
| **Deployment Frequency** | 2-3 por semana | Deployments a producción |
| **Change Failure Rate** | < 15% | % deployments que requieren rollback |
| **Time to Restore** | < 2 horas | Tiempo para recuperar de fallo |
| **Code Review Time** | < 24 horas | Desde PR hasta merge |
| **Test Coverage** | >= 80% | Coverage de tests unitarios |

### Métricas Secundarias

- Tiempo promedio por etapa
- Número de iteraciones en code review
- Número de bugs post-deployment
- Satisfacción del equipo con el proceso

---

## VARIACIONES DEL PROCESO

### Hotfix (Bug Crítico en Producción)

**Diferencias**:
- Branch desde: `main` (no desde develop)
- Nomenclatura: `hotfix/ISSUE-123-descripcion`
- Code review: 1 reviewer (acelerado)
- Deploy directo a producción (skip staging)
- Merge back a main Y develop

**Duración**: 2-4 horas end-to-end

---

### Refactoring (Sin Nueva Funcionalidad)

**Diferencias**:
- Branch: `refactor/descripcion`
- Tests deben seguir pasando (no agregar nuevos)
- Code review enfocado en mejora de calidad
- Puede no requerir QA validation

---

### Spike (Investigación Técnica)

**Diferencias**:
- Branch: `spike/descripcion`
- Output: Documento de hallazgos (no código en producción)
- No requiere tests exhaustivos
- No requiere deployment

---

## HERRAMIENTAS Y TECNOLOGÍAS

### Control de Versiones
- **Git**: Control de versiones
- **GitHub**: Hosting, PRs, Issues, Actions

### CI/CD
- **GitHub Actions**: 25 workflows configurados
- **pytest**: Testing backend
- **Jest**: Testing frontend
- **Black/isort/flake8**: Linters Python

### Deployment
- **Vagrant**: Ambiente local
- **DevContainer**: Desarrollo en contenedor
- (Producción: TBD - definir stack de deployment)

### Monitoreo
- **Logs**: python-json-logger
- **Métricas DORA**: Scripts en `dora_metrics/`

---

## EXCEPCIONES Y CASOS ESPECIALES

### Caso 1: Feature Requiere ADR

**Trigger**: Decisión arquitectónica significativa

**Acción**:
1. Crear ADR en `docs/gobernanza/adr/ADR-XXX-titulo.md`
2. Agregar ADR al PR description
3. Requiere aprobación de Tech Lead o Arquitecto
4. Documentar decisión ANTES de implementar

---

### Caso 2: Feature Requiere Migración de BD

**Trigger**: Cambios en modelos Django

**Acción**:
1. Generar migración: `python manage.py makemigrations`
2. Revisar migración generada
3. Probar rollback: `python manage.py migrate app_name <numero_anterior>`
4. Incluir migración en PR
5. Documentar rollback strategy en PR

---

### Caso 3: Feature Bloquea a Otros Developers

**Trigger**: Branch de larga duración (>3 días)

**Acción**:
1. Comunicar en daily standup
2. Dividir feature en sub-features más pequeñas
3. Merge incremental con feature flags
4. Mantener sincronizado con main (merge main → feature diario)

---

## ROLES Y RESPONSABILIDADES DETALLADAS

### Developer

**En cada etapa**:
- ETAPA 1: Analizar y diseñar
- ETAPA 2: Implementar código y tests
- ETAPA 3: Crear PR
- ETAPA 4: Responder a comentarios de reviewers
- ETAPA 5-7: Monitorear deployment (si on-call)

---

### Code Reviewer

**Responsabilidades**:
- Revisar en < 24 horas
- Verificar:
  - Código legible
  - Tests adecuados
  - Cumple estándares
  - No viola ADRs
- Dejar comentarios constructivos
- Aprobar o solicitar cambios

---

### QA Engineer

**Responsabilidades**:
- Validar en staging
- Ejecutar smoke tests
- Reportar bugs encontrados
- Aprobar para producción

---

### DevOps

**Responsabilidades**:
- Configurar pipelines CI/CD
- Ejecutar deployments (si manual)
- Monitorear métricas post-deployment
- Ejecutar rollback si necesario

---

### Tech Lead

**Responsabilidades**:
- Revisar diseño arquitectónico
- Aprobar PRs complejos/críticos
- Aprobar ADRs
- Resolver disputes en code reviews

---

## TROUBLESHOOTING

### Problema: CI/CD Falla en PR

**Causa común**: Tests fallan, linters no pasan

**Solución**:
1. Revisar logs de GitHub Actions
2. Ejecutar localmente:
   ```bash
   pytest
   black --check callcentersite/
   flake8 callcentersite/
   ```
3. Corregir errores
4. Push de correcciones
5. CI/CD se re-ejecuta automáticamente

---

### Problema: Merge Conflicts

**Causa común**: Branch desactualizado con main

**Solución**:
1. Actualizar branch local:
   ```bash
   git checkout feature/ISSUE-123
   git fetch origin
   git merge origin/main
   ```
2. Resolver conflicts manualmente
3. Ejecutar tests (asegurar que siguen pasando)
4. Push de resolución:
   ```bash
   git push origin feature/ISSUE-123
   ```

---

### Problema: Deployment Falla en Staging

**Causa común**: Migración de BD falla

**Solución**:
1. Revisar logs de deployment
2. Verificar migración localmente
3. Si migración es problema:
   - Corregir migración
   - Crear nueva PR con fix
   - Re-deploy
4. Si problema es otro:
   - Rollback a versión anterior
   - Investigar causa raíz
   - Crear hotfix si necesario

---

## MEJORA CONTINUA

### Retrospectivas Mensuales

**Agenda**:
1. Revisar métricas del mes
2. Qué funcionó bien
3. Qué no funcionó
4. Acciones de mejora
5. Actualizar este proceso si necesario

---

### Revisión de Proceso (Trimestral)

**Verificar**:
- Métricas DORA
- Satisfacción del equipo
- Bottlenecks identificados
- Nuevas herramientas/técnicas disponibles
- Actualizar proceso según aprendizajes

---

## REFERENCIAS

- [Guía: Procesos vs Procedimientos](../guias/DIFERENCIA_PROCESOS_PROCEDIMIENTOS.md)
- [ADR-002: Estrategia de Branching](../adr/ADR-002-branching-strategy.md)
- [ADR-056: Agentic Design Principles](../adr/ADR-056-agentic-design-principles.md)
- [Guía de Estilo](../GUIA_ESTILO.md)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

## CHANGELOG

### v1.0.0 (2025-11-17)
- Versión inicial del proceso
- Definición de 7 etapas
- Métricas DORA incluidas
- Casos especiales documentados

---

**Próxima revisión**: 2025-12-17 (1 mes)
**Responsable**: Tech Lead + Equipo de Desarrollo
**Aprobación pendiente**: Product Owner, Tech Lead, DevOps Lead
