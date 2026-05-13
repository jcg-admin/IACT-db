---
titulo: Indice Maestro de ADRs del Proyecto IACT
descripcion: Indice completo de todas las Architecture Decision Records del proyecto
fecha_actualizacion: 2025-11-16
estado: Activo
version: 2.0
---

# Indice Maestro de ADRs

Este documento contiene el indice completo de todas las decisiones arquitectonicas (Architecture Decision Records) del proyecto IACT.

**Ultima actualizacion**: 2025-11-16
**Total ADRs**: 27

---

## Sistema de Numeracion

**Formato Estandar**: `ADR-{NNN}-{descripcion-con-guiones}.md`

- **NNN**: Numero secuencial de tres digitos (001-999)
- **descripcion**: Descripcion corta en kebab-case (guiones)
- Prefijo ADR siempre en UPPERCASE
- Ejemplos:
  - `ADR-001-vagrant-mod-wsgi.md`
  - `ADR-012-sistema_permisos_sin_roles_jerarquicos.md` (formato legacy con underscores)
  - `ADR-040-schema_validator_agent.md`

**Rangos de Numeracion**:
- **001-021**: ADRs de arquitectura general y dominios (Backend, Frontend, Infraestructura, Gobernanza)
- **022-039**: DISPONIBLES (18 numeros)
- **040-045**: ADRs de agentes de automatizacion
- **046-059**: DISPONIBLES (14 numeros)
- **060+**: Siguiente bloque disponible

---

## Indice por Numero

### ADR-001: Vagrant mod_wsgi
**Ubicacion**: `adr/ADR-001-vagrant-mod-wsgi.md`
**Fecha**: 2025-11-13
**Estado**: Aceptado e Implementado
**Dominio**: Infraestructura
**Propietario**: @equipo-infraestructura

**Resumen**: Entorno de desarrollo con Vagrant y VirtualBox usando mod_wsgi.

**Contexto**: Replica infraestructura de produccion (PostgreSQL + MariaDB) para desarrollo local.

---

### ADR-002: Suite Calidad Codigo
**Ubicacion**: `adr/ADR-002-suite-calidad-codigo.md`
**Fecha**: 2025-11-04
**Estado**: Aceptado
**Dominio**: Gobernanza
**Propietario**: @equipo-gobernanza @equipo-qa

**Resumen**: Suite de herramientas de calidad de codigo con Ruff, MyPy y Pre-commit.

**Contexto**: Estandarizar calidad de codigo en todo el proyecto con herramientas automatizadas.

---

### ADR-003: DORA SDLC Integration
**Ubicacion**: `adr/ADR-003-dora-sdlc-integration.md`
**Fecha**: 2025-11-06
**Estado**: Aceptado
**Dominio**: Gobernanza
**Propietario**: @equipo-gobernanza

**Resumen**: Integracion de metricas DORA con agentes SDLC.

**Contexto**: Medir impacto de agentes IA en performance de entrega usando metricas DORA (Deployment Frequency, Lead Time, Change Failure Rate, Time to Restore).

**Relacionado**: FASES_IMPLEMENTACION_IA.md, ESTRATEGIA_IA.md, AGENTES_SDLC.md

---

### ADR-004: Centralized Log Storage
**Ubicacion**: `adr/ADR-004-centralized-log-storage.md`
**Fecha**: 2025-11-06
**Estado**: Propuesta
**Dominio**: Infraestructura
**Propietario**: @equipo-infraestructura

**Resumen**: Almacenamiento centralizado de logs en Cassandra.

**Contexto**: Propuesta de sistema de logs centralizado para observabilidad.

**Relacionado**: ADR-003 (DORA metrics), OBSERVABILITY_LAYERS.md

---

### ADR-005: Grupos Funcionales Sin Jerarquia
**Ubicacion**: `adr/ADR-005-grupos-funcionales-sin-jerarquia.md`
**Fecha**: 2025-11-07
**Estado**: Aceptado
**Dominio**: Backend
**Propietario**: @equipo-backend

**Resumen**: Sistema de permisos con grupos funcionales sin jerarquia.

**Contexto**: Escalar modelo de permisos granulares para 19 funciones, 130+ capacidades, sin roles rigidos.

**Relacionado**: ADR-017, RF-001, RF-002, RF-003, RF-004

---

### ADR-006: Configuracion Dinamica Sistema
**Ubicacion**: `adr/ADR-006-configuracion-dinamica-sistema.md`
**Fecha**: 2025-11-09
**Estado**: Aceptado
**Dominio**: Backend
**Propietario**: @equipo-backend

**Resumen**: Sistema de configuracion dinamica persistida en base de datos.

**Contexto**: Permitir configuracion flexible del sistema sin redeployments.

**Relacionado**: ADR-005

---

### ADR-007: Git Hooks Validation Strategy
**Ubicacion**: `adr/ADR-007-git-hooks-validation-strategy.md`
**Fecha**: 2025-11-09
**Estado**: Aceptado
**Dominio**: Gobernanza
**Propietario**: @equipo-gobernanza

**Resumen**: Estrategia de validacion con Git Hooks.

**Contexto**: Asegurar calidad de codigo antes de commits y pushes.

**Relacionado**: ADR-002, ADR-008

---

### ADR-008: Workflow Validation Shell Migration
**Ubicacion**: `adr/ADR-008-workflow-validation-shell-migration.md`
**Fecha**: 2025-11-09
**Estado**: Aceptado
**Dominio**: Gobernanza
**Propietario**: @equipo-gobernanza

**Resumen**: Workflow de validacion para migracion de scripts shell a CI/CD.

**Contexto**: Migrar validaciones de Git Hooks a pipelines de CI/CD.

**Relacionado**: ADR-007

---

### ADR-009: Frontend Postponement
**Ubicacion**: `adr/ADR-009-frontend-postponement.md`
**Fecha**: 2025-11-09
**Estado**: Aceptado
**Dominio**: Frontend
**Propietario**: @equipo-frontend

**Resumen**: Postergacion de implementacion de frontend React.

**Contexto**: Priorizar backend y APIs antes de desarrollo frontend completo.

**Relacionado**: ADR-015, ADR-016, ADR-018, ADR-019, ADR-020

---

### ADR-010: ORM SQL Hybrid Permissions
**Ubicacion**: `adr/ADR-010-orm-sql-hybrid-permissions.md`
**Fecha**: 2025-11-09
**Estado**: Aceptado
**Dominio**: Backend
**Propietario**: @equipo-backend

**Resumen**: Estrategia hibrida ORM + SQL para sistema de permisos.

**Contexto**: Optimizar consultas complejas de permisos usando SQL directo cuando Django ORM es ineficiente.

**Relacionado**: ADR-005, ADR-017, UC-PERM-001

---

### ADR-011: WASI Style Virtualization
**Ubicacion**: `adr/ADR-011-wasi-style-virtualization.md`
**Fecha**: 2025-11-12
**Estado**: Aceptado
**Dominio**: Infraestructura
**Propietario**: @equipo-infraestructura

**Resumen**: Virtualizacion estilo WASI para entornos de base de datos.

**Contexto**: Sandbox de bases de datos para desarrollo y testing.

---

### ADR-012: Sistema Permisos Sin Roles Jerarquicos
**Ubicacion**: `adr/ADR-012-sistema_permisos_sin_roles_jerarquicos.md`
**Fecha**: 2025-11-07
**Estado**: Aceptado e Implementado
**Dominio**: Backend
**Propietario**: @equipo-backend

**Resumen**: Sistema de permisos granular sin roles jerarquicos.

**Contexto**: Implementacion de permisos basados en capacidades, no en roles Admin/Supervisor/Agent.

**Relacionado**: ADR-005, ADR-017

**Nota**: Version legacy del documento, ver ADR-017 para version consolidada.

---

### ADR-013: Distribucion Artefactos Strategy
**Ubicacion**: `adr/ADR-013-distribucion-artefactos-strategy.md`
**Fecha**: 2025-11-13
**Estado**: Activo
**Dominio**: Infraestructura
**Propietario**: @equipo-infraestructura

**Resumen**: Estrategia de distribucion de artefactos CPython precompilados via GitHub Releases.

**Contexto**: Distribuir binarios de CPython (50-80MB) sin inflar repositorio Git.

**Decision**: Usar GitHub Releases (gratis, versionado, no infla repo) vs Git LFS (limitado, caro) o S3 (complejo).

**Relacionado**: SPEC_INFRA_001, ADR-059

---

### ADR-014: Organizacion Proyecto por Dominio
**Ubicacion**: `adr/ADR-014-organizacion-proyecto-por-dominio.md`
**Fecha**: 2025-11-06
**Estado**: Activo
**Dominio**: Gobernanza
**Propietario**: @equipo-gobernanza

**Resumen**: Organizacion de documentacion y codigo por dominios (backend, frontend, infraestructura, gobernanza).

**Contexto**: Estructurar proyecto por dominios para escalabilidad y separacion de concerns.

**Impacto**: Afecta estructura completa de `docs/` y organizacion de ADRs.

---

### ADR-015: Frontend Modular Monolith
**Ubicacion**: `adr/ADR-015-frontend-modular-monolith.md`
**Fecha**: 2025-11-06
**Estado**: Aceptado (Suspendido por ADR-009)
**Dominio**: Frontend
**Propietario**: @equipo-frontend

**Resumen**: Arquitectura de monolito modular para frontend React.

**Contexto**: Frontend como Single Page Application modular con lazy loading.

**Relacionado**: ADR-009 (suspension), ADR-021

**Nota**: Implementacion suspendida, documentacion preservada para futuro.

---

### ADR-016: Redux Toolkit State Management
**Ubicacion**: `adr/ADR-016-redux-toolkit-state-management.md`
**Fecha**: 2025-11-06
**Estado**: Aceptado (Suspendido por ADR-009)
**Dominio**: Frontend
**Propietario**: @equipo-frontend

**Resumen**: Uso de Redux Toolkit para manejo de estado en React.

**Contexto**: State management centralizado con Redux Toolkit y RTK Query.

**Relacionado**: ADR-009 (suspension), ADR-015

**Nota**: Implementacion suspendida, documentacion preservada para futuro.

---

### ADR-017: Sistema Permisos Sin Roles Jerarquicos
**Ubicacion**: `adr/ADR-017-sistema-permisos-sin-roles-jerarquicos.md`
**Fecha**: 2025-11-13
**Estado**: Activo
**Dominio**: Backend
**Propietario**: @equipo-backend

**Resumen**: Sistema de permisos granular SIN roles jerarquicos, basado en grupos funcionales y capacidades combinables.

**Filosofia Central**:
- NO mas etiquetas jerarquicas (Admin, Supervisor, Agent)
- SI grupos descriptivos ("Atencion al Cliente", "Gestion de Equipos")
- Permisos combinables (multiples grupos por usuario)

**Implementacion**: 8 tablas DB, 16 capacidades, 18 endpoints REST, 21 tests E2E

**Relacionado**:
- ADR-005 (grupos funcionales)
- ADR-010 (estrategia hibrida)
- ADR-012 (version legacy)
- prioridad_01_estructura_base_datos.md
- UC-PERM-001 a UC-PERM-010

**Impacto**: CRITICA - Base del sistema de autorizacion completo

---

### ADR-018: Webpack Bundler
**Ubicacion**: `adr/ADR-018-webpack-bundler.md`
**Fecha**: 2025-11-06
**Estado**: Aceptado (Suspendido por ADR-009)
**Dominio**: Frontend
**Propietario**: @equipo-frontend

**Resumen**: Uso de Webpack 5 como bundler para frontend React.

**Contexto**: Webpack vs Vite - elegido por ecosystem maduro, code splitting avanzado, configuracion explícita.

**Contras aceptados**: Dev server ~2-3s rebuild (vs <100ms Vite)

**Relacionado**: ADR-009 (suspension), ADR-015, ADR-019

**Nota**: Implementacion suspendida, reevaluar Vite en Q2 2026.

---

### ADR-019: Testing Strategy Jest Testing Library
**Ubicacion**: `adr/ADR-019-testing-strategy-jest-testing-library.md`
**Fecha**: 2025-11-06
**Estado**: Aceptado (Suspendido por ADR-009)
**Dominio**: Frontend
**Propietario**: @equipo-frontend @equipo-qa

**Resumen**: Estrategia de testing con Jest y React Testing Library.

**Contexto**: Jest + React Testing Library vs Vitest vs Mocha+Chai - elegido por ecosystem maduro, Testing Library filosofia ("test como usuario").

**Targets**: 80% coverage statements, <30s test suite

**Relacionado**: ADR-009 (suspension), ADR-016, ADR-018

**Nota**: Implementacion suspendida, documentacion preservada para futuro.

---

### ADR-020: Servicios Resilientes
**Ubicacion**: `adr/ADR-020-servicios-resilientes.md`
**Fecha**: 2025-11-09
**Estado**: Aceptado
**Dominio**: Frontend
**Propietario**: @equipo-frontend

**Resumen**: Capa de servicios resilientes con contratos y telemetria.

**Contexto**: Frontend depende de backend incompleto sin DB persistente. Vistas clave usan mocks sin contrato uniforme.

**Decision**:
- Contrato comun via `createResilientService`
- Degradacion controlada a mocks con `fetchWithFallback`
- Telemetria de origen (API vs mock) con `recordMockUsage`
- Flags de integridad `UI_BACKEND_<DOMINIO>_SOURCE`

**Relacionado**: ADR-009, ADR-015

---

### ADR-021: Arquitectura Microfrontends
**Ubicacion**: `adr/ADR-021-arquitectura-microfrontends.md`
**Fecha**: 2025-11-09
**Estado**: Rechazado
**Dominio**: Frontend
**Propietario**: @equipo-frontend

**Resumen**: Arquitectura de microfrontends basada en App Shell unificado.

**Contexto**: Evaluacion de Unified SPA con App Shell vs Linked Pages vs Server Routing para colaboracion entre equipos.

**Decision**: NO adoptada tras contrastar con ADR-015 (modular monolith) y ADR-009 (postponement).

**Relacionado**: ADR-015, ADR-009

**Nota**: Documento conservado como analisis de opciones para futuro posible.

---

### ADR-040: Schema Validator Agent
**Ubicacion**: `adr/ADR-040-schema_validator_agent.md`
**Fecha**: 2025-11-13
**Estado**: Implementado
**Dominio**: Automatizacion
**Propietario**: @equipo-automatizacion
**Tags**: [automation, validation, tdd, sdlc]

**Resumen**: Agente validador de esquemas de configuracion.

**Contexto**: Validar estructuras YAML/JSON de configuracion en CI/CD.

**Implementacion**: 23 tests passing, validacion de schemas con Pydantic.

**Relacionado**: ADR-042, ADR-045

---

### ADR-041: DevContainer Validator Agent
**Ubicacion**: `adr/ADR-041-devcontainer_validator_agent.md`
**Fecha**: 2025-11-13
**Estado**: Implementado
**Dominio**: Automatizacion
**Propietario**: @equipo-automatizacion
**Parent ADR**: ADR-036

**Resumen**: Agente validador de configuraciones DevContainer.

**Contexto**: Validar devcontainer.json y features en desarrollo.

**Implementacion**: 51 tests passing, validacion de configuraciones Dev Container.

**Relacionado**: ADR-040, ADR-045

---

### ADR-042: Metrics Collector Agent
**Ubicacion**: `adr/ADR-042-metrics_collector_agent.md`
**Fecha**: 2025-11-13
**Estado**: Implementado
**Dominio**: Automatizacion
**Propietario**: @equipo-automatizacion
**Tags**: [tdd, sdlc, automation, metrics]

**Resumen**: Agente recolector de metricas de desarrollo.

**Contexto**: Recolectar metricas DORA y de calidad de codigo.

**Implementacion**: 25 tests passing, integracion con ADR-003.

**Relacionado**: ADR-003 (DORA metrics), ADR-045

---

### ADR-043: Coherence Analyzer Agent
**Ubicacion**: `adr/ADR-043-coherence_analyzer_agent.md`
**Fecha**: 2025-11-13
**Estado**: Implementado
**Dominio**: Automatizacion
**Propietario**: @equipo-automatizacion

**Resumen**: Agente analizador de coherencia UI/API.

**Contexto**: Validar coherencia entre interfaces de usuario y contratos API.

**Implementacion**: 50 tests passing, analisis de contratos OpenAPI vs componentes React.

**Relacionado**: ADR-020, ADR-045

---

### ADR-044: Constitution Validator Agent
**Ubicacion**: `adr/ADR-044-constitution_validator_agent.md`
**Fecha**: 2025-11-13
**Estado**: Implementado
**Dominio**: Automatizacion
**Propietario**: @equipo-automatizacion

**Resumen**: Agente validador de consistencia constitucional del proyecto.

**Contexto**: Validar cumplimiento de principios y estandares definidos en constitucion del proyecto.

**Implementacion**: 50+ tests, 95% coverage, validacion de ADRs, READMEs, codigo.

**Relacionado**: ADR-002, ADR-014, ADR-045

---

### ADR-045: CI Pipeline Orchestrator Agent
**Ubicacion**: `adr/ADR-045-ci_pipeline_orchestrator_agent.md`
**Fecha**: 2025-11-13
**Estado**: Implementado
**Dominio**: Automatizacion
**Propietario**: @equipo-automatizacion
**Tags**: [automation, ci-cd, orchestration]

**Resumen**: Agente orquestador de pipeline de CI/CD.

**Contexto**: Coordinar ejecucion de todos los agentes de validacion en CI/CD.

**Implementacion**: 52 tests passing, orquestacion de ADR-040 a ADR-044.

**Relacionado**: ADR-040, ADR-041, ADR-042, ADR-043, ADR-044, ADR-008

---

## Indice por Dominio

### Backend (5 ADRs)
- **ADR-005**: Grupos Funcionales Sin Jerarquia (Aceptado)
- **ADR-006**: Configuracion Dinamica Sistema (Aceptado)
- **ADR-010**: ORM SQL Hybrid Permissions (Aceptado)
- **ADR-012**: Sistema Permisos Sin Roles Jerarquicos (Aceptado e Implementado)
- **ADR-017**: Sistema Permisos Sin Roles Jerarquicos (Activo)

### Frontend (7 ADRs)
- **ADR-009**: Frontend Postponement (Aceptado)
- **ADR-015**: Frontend Modular Monolith (Aceptado - Suspendido)
- **ADR-016**: Redux Toolkit State Management (Aceptado - Suspendido)
- **ADR-018**: Webpack Bundler (Aceptado - Suspendido)
- **ADR-019**: Testing Strategy Jest Testing Library (Aceptado - Suspendido)
- **ADR-020**: Servicios Resilientes (Aceptado)
- **ADR-021**: Arquitectura Microfrontends (Rechazado)

### Infraestructura (4 ADRs)
- **ADR-001**: Vagrant mod_wsgi (Aceptado e Implementado)
- **ADR-004**: Centralized Log Storage (Propuesta)
- **ADR-011**: WASI Style Virtualization (Aceptado)
- **ADR-013**: Distribucion Artefactos Strategy (Activo)

### Gobernanza (5 ADRs)
- **ADR-002**: Suite Calidad Codigo (Aceptado)
- **ADR-003**: DORA SDLC Integration (Aceptado)
- **ADR-007**: Git Hooks Validation Strategy (Aceptado)
- **ADR-008**: Workflow Validation Shell Migration (Aceptado)
- **ADR-014**: Organizacion Proyecto por Dominio (Activo)

### Automatizacion (6 ADRs)
- **ADR-040**: Schema Validator Agent (Implementado)
- **ADR-041**: DevContainer Validator Agent (Implementado)
- **ADR-042**: Metrics Collector Agent (Implementado)
- **ADR-043**: Coherence Analyzer Agent (Implementado)
- **ADR-044**: Constitution Validator Agent (Implementado)
- **ADR-045**: CI Pipeline Orchestrator Agent (Implementado)

---

## Indice por Estado

### Aceptado (11 ADRs - 40.7%)
- **ADR-002**: Suite Calidad Codigo
- **ADR-003**: DORA SDLC Integration
- **ADR-005**: Grupos Funcionales Sin Jerarquia
- **ADR-006**: Configuracion Dinamica Sistema
- **ADR-007**: Git Hooks Validation Strategy
- **ADR-008**: Workflow Validation Shell Migration
- **ADR-009**: Frontend Postponement
- **ADR-010**: ORM SQL Hybrid Permissions
- **ADR-011**: WASI Style Virtualization
- **ADR-020**: Servicios Resilientes

### Aceptado e Implementado (2 ADRs - 7.4%)
- **ADR-001**: Vagrant mod_wsgi
- **ADR-012**: Sistema Permisos Sin Roles Jerarquicos

### Aceptado - Suspendido (4 ADRs - 14.8%)
- **ADR-015**: Frontend Modular Monolith (suspendido por ADR-009)
- **ADR-016**: Redux Toolkit State Management (suspendido por ADR-009)
- **ADR-018**: Webpack Bundler (suspendido por ADR-009)
- **ADR-019**: Testing Strategy Jest Testing Library (suspendido por ADR-009)

### Activo (3 ADRs - 11.1%)
- **ADR-013**: Distribucion Artefactos Strategy
- **ADR-014**: Organizacion Proyecto por Dominio
- **ADR-017**: Sistema Permisos Sin Roles Jerarquicos

### Implementado (6 ADRs - 22.2%)
- **ADR-040**: Schema Validator Agent
- **ADR-041**: DevContainer Validator Agent
- **ADR-042**: Metrics Collector Agent
- **ADR-043**: Coherence Analyzer Agent
- **ADR-044**: Constitution Validator Agent
- **ADR-045**: CI Pipeline Orchestrator Agent

### Propuesta (1 ADR - 3.7%)
- **ADR-004**: Centralized Log Storage

### Rechazado (1 ADR - 3.7%)
- **ADR-021**: Arquitectura Microfrontends

---

## Estadisticas

**Total ADRs**: 27

**Por Dominio**:
- Backend: 5 (18.5%)
- Frontend: 7 (25.9%)
- Infraestructura: 4 (14.8%)
- Gobernanza: 5 (18.5%)
- Automatizacion: 6 (22.2%)

**Por Estado**:
- Aceptado: 11 (40.7%)
- Aceptado e Implementado: 2 (7.4%)
- Aceptado - Suspendido: 4 (14.8%)
- Activo: 3 (11.1%)
- Implementado: 6 (22.2%)
- Propuesta: 1 (3.7%)
- Rechazado: 1 (3.7%)

**ADRs Activos** (Aceptado + Aceptado e Implementado + Activo + Implementado): 22 (81.5%)
**ADRs Suspendidos**: 4 (14.8%)
**ADRs Propuesta**: 1 (3.7%)
**ADRs Rechazados**: 1 (3.7%)

**Gaps en Numeracion**:
- ADR-022 a ADR-039: 18 numeros disponibles
- ADR-046 a ADR-059: 14 numeros disponibles
- **Total numeros disponibles**: 32

**Criticidad** (basado en relaciones e impacto):
- CRITICA: 3 ADRs (ADR-017 Sistema Permisos, ADR-003 DORA, ADR-014 Organizacion)
- ALTA: 24 ADRs

---

## Relacionados con Sistema de Permisos

**ADRs Principales**:
- **ADR-017**: Sistema Permisos Sin Roles Jerarquicos (filosofia consolidada, activo)
- **ADR-012**: Sistema Permisos Sin Roles Jerarquicos (version legacy, implementado)
- **ADR-005**: Grupos Funcionales Sin Jerarquia (implementacion)
- **ADR-010**: ORM SQL Hybrid Permissions (optimizacion)

**Documentos Relacionados**:
- prioridad_01_estructura_base_datos.md (8 tablas DB)
- prioridad_02_funciones_core.md (16 capacidades, 3 funciones)
- IMPLEMENTACION_PERMISOS_GRANULAR.md (guia implementacion)
- UC-PERM-001 a UC-PERM-010 (casos de uso)

**Impacto**: Base del sistema de autorizacion completo del proyecto.

---

## Relacionados con Frontend

**ADRs de Arquitectura**:
- **ADR-015**: Frontend Modular Monolith (suspendido)
- **ADR-021**: Arquitectura Microfrontends (rechazado)

**ADRs de Tecnologia**:
- **ADR-016**: Redux Toolkit State Management (suspendido)
- **ADR-018**: Webpack Bundler (suspendido)
- **ADR-019**: Testing Strategy Jest Testing Library (suspendido)
- **ADR-020**: Servicios Resilientes (activo)

**ADR de Planificacion**:
- **ADR-009**: Frontend Postponement (suspension de implementacion)

**Nota**: Frontend postponed por ADR-009. Documentacion preservada para futuro desarrollo.

---

## Relacionados con Agentes de Automatizacion

**ADRs de Agentes** (todos implementados):
- **ADR-040**: Schema Validator Agent (validacion de schemas)
- **ADR-041**: DevContainer Validator Agent (validacion de devcontainers)
- **ADR-042**: Metrics Collector Agent (metricas DORA)
- **ADR-043**: Coherence Analyzer Agent (coherencia UI/API)
- **ADR-044**: Constitution Validator Agent (validacion constitucional)
- **ADR-045**: CI Pipeline Orchestrator Agent (orquestacion)

**Integracion**: Todos los agentes orquestados por ADR-045 en pipeline CI/CD.

**Metricas**: 201+ tests passing, coverage >90%, integracion completa con CI/CD.

---

## Como Crear un Nuevo ADR

### 1. Determinar Numero Secuencial

**Siguiente numero disponible**: **ADR-060**

**Rangos disponibles**:
- ADR-022 a ADR-039 (18 numeros) - para ADRs generales
- ADR-046 a ADR-059 (14 numeros) - para ADRs generales
- ADR-060+ - nuevos ADRs

**Recomendacion**: Usar ADR-060 para siguiente ADR general, reservar 022-039 y 046-059 para futura reorganizacion si es necesario.

### 2. Usar Plantilla

**Ubicacion**: `docs/gobernanza/plantilla_adr.md`

**Estructura minima**:
```yaml
---
id: ADR-XXX
titulo: Titulo del ADR
fecha: YYYY-MM-DD
estado: Propuesta | Aceptado | Implementado | Rechazado | Suspendido
dominio: backend | frontend | infraestructura | gobernanza | automatizacion
decision_makers:
  - @equipo-X
tags: [tag1, tag2, tag3]
---

# ADR-XXX: Titulo del ADR

## Estado

**Estado** - Fecha

## Contexto

[Describir el problema o necesidad]

## Decisión

[Describir la decision tomada]

## Consecuencias

### Positivas
[Beneficios]

### Negativas
[Contras y mitigaciones]

## Alternativas Rechazadas

[Opciones evaluadas y descartadas]

## Referencias

[Enlaces a documentos relacionados]

## Decisiones Relacionadas

[ADRs relacionados]
```

### 3. Formato de Nombre de Archivo

**Formato**: `ADR-{NNN}-{descripcion-kebab-case}.md`

**Ejemplos**:
- `ADR-060-rate-limiting-api.md`
- `ADR-061-database-migration-strategy.md`
- `ADR-062-authentication-oauth2.md`

**Reglas**:
- Numero de 3 digitos (060, 061, 062, ...)
- Descripcion en kebab-case (guiones, no underscores)
- Prefijo ADR en UPPERCASE
- Extension .md

### 4. Ubicar en Dominio Correcto

**Directorios por dominio**:
- Backend: `docs/gobernanza/adr/` (por convencion actual)
- Frontend: `docs/gobernanza/adr/`
- Infraestructura: `docs/gobernanza/adr/`
- Gobernanza: `docs/gobernanza/adr/`
- Automatizacion: `docs/gobernanza/adr/`

**Nota**: Todos los ADRs actualmente en `docs/gobernanza/adr/` centralizado. El campo `dominio` en frontmatter clasifica el dominio.

### 5. Actualizar Este Indice

Agregar entrada en:
1. **Indice por Numero** (con detalles completos)
2. **Indice por Dominio** (en seccion correspondiente)
3. **Indice por Estado** (en seccion correspondiente)
4. **Estadisticas** (actualizar conteos y porcentajes)

### 6. Actualizar CODEOWNERS

Agregar propietarios en `.github/CODEOWNERS`:

```
# ADR-060: Rate Limiting API
docs/gobernanza/adr/ADR-060-rate-limiting-api.md @equipo-backend @arquitecto-senior
```

### 7. Referenciar en Documentos

Actualizar documentos relacionados con link al nuevo ADR:
- Especificaciones tecnicas
- Casos de uso
- Otros ADRs relacionados
- CHANGELOG.md si aplica

### 8. Validar con Agentes

Ejecutar validaciones automaticas:
```bash
# Validar schema del ADR
python scripts/agents/schema_validator.py docs/gobernanza/adr/ADR-060-*.md

# Validar consistencia constitucional
python scripts/agents/constitution_validator.py

# Ejecutar suite completa de validacion
python scripts/agents/ci_pipeline_orchestrator.py --validate-adrs
```

---

## Referencias

- **Plantilla ADR**: `docs/gobernanza/plantilla_adr.md`
- **CODEOWNERS**: `.github/CODEOWNERS`
- **Metodologia**: `docs/gobernanza/marco_integrado/04_metodologia_analisis_iact.md`
- **Constitucion Proyecto**: `docs/gobernanza/constitucion/`

---

**Ultima actualizacion**: 2025-11-16
**Responsable**: @arquitecto-senior @tech-lead
**Proxima revision**: 2025-12-16
**Actualizacion**: Rebuild completo escaneando todos los ADR files, 27 ADRs documentados.
