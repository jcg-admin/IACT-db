---
id: PLAN-MEJORA-IACT-2025-01-17
tipo: plan_accion
titulo: Plan de Mejora del Proyecto IACT - Q1 2025
fecha: 2025-01-17
version: 1.0.0
estado: activo
basado_en: ANALISIS-PROYECTO-2025-01-17
horizonte_temporal: 3_meses
esfuerzo_total_horas: 342
fte_requerido: 2.1
---

# Plan de Mejora del Proyecto IACT - Q1 2025

## Resumen Ejecutivo

Este plan de acción detalla las tareas de mejora del proyecto IACT para los próximos 3 meses, basado en el [Análisis Exhaustivo](ANALISIS-PROYECTO-2025-01-17.md) realizado el 2025-01-17.

### Objetivos del Plan

1. **Completar requisitos críticos**: 30 RNF, 20 RN, 10 RNEG
2. **Aumentar cobertura testing**: Backend 62%→80%, Frontend 31%→60%
3. **Generar documentación técnica faltante**: API Reference, ER diagrams, threat model
4. **Consolidar arquitectura**: Resolver inconsistencias, diagramas arquitectónicos

### Métricas de Éxito

| Métrica | Baseline | Target | KPI |
|---------|----------|--------|-----|
| **RNF documentados** | 4 | 34 | +30 RNF |
| **Cobertura backend** | 62% | 80% | +18% |
| **Cobertura frontend** | 31% | 60% | +29% |
| **Apps sin tests** | 9 | 0 | -9 apps |
| **Diagramas ER** | 1 | 5 | +4 diagramas |
| **API Reference** | NO | SÍ | Endpoint /api/schema/ |

### Esfuerzo Total

- **Total horas**: 342 horas
- **FTE requerido**: 2.1 FTE durante 3 meses
- **Distribución**: Mes 1 (170h), Mes 2 (92h), Mes 3 (80h)

---

## Fase 1: Fundamentos Críticos (Mes 1)

**Objetivo**: Completar gaps críticos en requisitos, testing y documentación técnica

**Duración**: 4 semanas
**Esfuerzo**: 170 horas
**FTE**: ~1 FTE

### Semana 1-2: Requisitos y API (72 horas)

#### Tarea 1.1: Documentar 30 RNF Backend
**Prioridad**: CRÍTICA
**Esfuerzo**: 40 horas
**Responsable**: Arquitecto + QA
**Entregable**: 30 archivos RNF en `/docs/backend/requisitos/atributos_calidad/`

**Subtareas**:
1. Performance (8 RNF - 10h):
   - RNF-BACK-010: Tiempo respuesta API REST (< 200ms p95)
   - RNF-BACK-011: Tiempo respuesta GraphQL (< 300ms p95)
   - RNF-BACK-012: Throughput mínimo (100 req/s)
   - RNF-BACK-013: Tiempo carga dashboard (< 2s)
   - RNF-BACK-014: Tiempo generación reportes (< 5s hasta 1000 registros)
   - RNF-BACK-015: Latencia WebSocket (< 50ms)
   - RNF-BACK-016: Tiempo consulta analytics (< 1s)
   - RNF-BACK-017: Batch processing (>= 10,000 llamadas/min)

2. Seguridad (7 RNF - 9h):
   - RNF-BACK-020: OWASP Top 10 compliance
   - RNF-BACK-021: Encriptación datos en reposo (AES-256)
   - RNF-BACK-022: Encriptación datos en tránsito (TLS 1.3+)
   - RNF-BACK-023: Password policy (12+ caracteres, complejidad)
   - RNF-BACK-024: Session timeout (15 min inactividad)
   - RNF-BACK-025: Rate limiting (100 req/min por IP)
   - RNF-BACK-026: Auditoría accesos (100% operaciones críticas)

3. Disponibilidad (5 RNF - 6h):
   - RNF-BACK-030: Uptime >= 99.9% (SLA)
   - RNF-BACK-031: RPO (Recovery Point Objective) <= 1 hora
   - RNF-BACK-032: RTO (Recovery Time Objective) <= 4 horas
   - RNF-BACK-033: Backup diario automático
   - RNF-BACK-034: Disaster recovery plan documentado

4. Escalabilidad (5 RNF - 6h):
   - RNF-BACK-040: Usuarios concurrentes (>= 100)
   - RNF-BACK-041: Crecimiento datos (>= 1M llamadas/mes)
   - RNF-BACK-042: Escalabilidad horizontal (stateless APIs)
   - RNF-BACK-043: Connection pooling DB (min 10, max 50)
   - RNF-BACK-044: Cache hit ratio (>= 80% para permisos)

5. Usabilidad (3 RNF - 4h):
   - RNF-BACK-050: API error messages (JSON RFC 7807)
   - RNF-BACK-051: Paginación estándar (max 100 items/page)
   - RNF-BACK-052: Filtros dinámicos (>= 5 campos por endpoint)

6. Mantenibilidad (2 RNF - 5h):
   - RNF-BACK-060: Cobertura tests (>= 80%)
   - RNF-BACK-061: Complejidad ciclomática (< 10 por función)

**Plantilla**: `docs/gobernanza/templates/RNF-template.md`
**Procedimiento**: `docs/gobernanza/procedimientos/PROCED-GOB-002-actualizar-documentacion.md`

#### Tarea 1.2: Generar API Reference con drf-spectacular
**Prioridad**: CRÍTICA
**Esfuerzo**: 8 horas
**Responsable**: Backend Lead
**Entregable**: Endpoint `/api/schema/` con OpenAPI 3.0 schema

**Subtareas**:
1. Configurar drf-spectacular en settings (1h)
2. Agregar docstrings a ViewSets (4h)
3. Configurar schemas personalizados (2h)
4. Generar documentación Swagger UI (1h)

**Código**:
```python
# callcentersite/settings/base.py
INSTALLED_APPS += ['drf_spectacular']

REST_FRAMEWORK = {
    'DEFAULT_SCHEMA_CLASS': 'drf_spectacular.openapi.AutoSchema',
}

SPECTACULAR_SETTINGS = {
    'TITLE': 'IACT API',
    'DESCRIPTION': 'IVR Analytics & Customer Tracking',
    'VERSION': '1.0.0',
}

# callcentersite/urls.py
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

urlpatterns += [
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema')),
]
```

#### Tarea 1.3: Tests para ivr_legacy (App Crítica)
**Prioridad**: CRÍTICA
**Esfuerzo**: 24 horas
**Responsable**: Backend Developer
**Entregable**: `tests/ivr_legacy/test_*.py` con cobertura >= 70%

**Subtareas**:
1. Setup tests ivr_legacy (2h)
2. Tests modelos (6h)
3. Tests integración BD MariaDB (8h)
4. Tests lógica de negocio (6h)
5. Tests edge cases (2h)

**Estructura**:
```
tests/ivr_legacy/
├── __init__.py
├── test_models.py          # Models IVR
├── test_queries.py         # Consultas read-only
├── test_integration.py     # Integración MariaDB
└── test_business_logic.py  # Lógica negocio
```

### Semana 3-4: Cobertura Testing y Requisitos (98 horas)

#### Tarea 1.4: Aumentar Cobertura Frontend a 60%
**Prioridad**: ALTA
**Esfuerzo**: 32 horas
**Responsable**: Frontend Developer
**Entregable**: Tests para componentes críticos con >= 60% coverage

**Subtareas**:
1. Tests ProtectedRoute.tsx (4h)
2. Tests PermissionGate.tsx (4h)
3. Tests usePermisos.ts (6h)
4. Tests permisos-client.ts (6h)
5. Tests api.config.ts (2h)
6. Tests MockDataNotice.jsx (2h)
7. Tests módulos adicionales (8h)

**Framework**: Jest + Testing Library

#### Tarea 1.5: Documentar 10 RNEG Backend
**Prioridad**: ALTA
**Esfuerzo**: 20 horas
**Responsable**: Business Analyst + Backend Lead
**Entregable**: 10 archivos RNEG en `/docs/backend/requisitos/requerimientos_negocio/`

**RNEG a documentar**:
1. RNEG-BACK-010: Analítica IVR tiempo real
2. RNEG-BACK-020: Auditoría completa accesos
3. RNEG-BACK-030: Integración IVR legacy seamless
4. RNEG-BACK-040: Dashboard métricas DORA
5. RNEG-BACK-050: Gestión permisos granulares
6. RNEG-BACK-060: Reportes personalizables
7. RNEG-BACK-070: Notificaciones tiempo real
8. RNEG-BACK-080: Exportación datos (Excel, PDF)
9. RNEG-BACK-090: Configuración dinámica sistema
10. RNEG-BACK-100: ETL automatizado IVR

**Plantilla**: Seguir estructura ADR-GOB-005 (Jerarquía RNEG)

#### Tarea 1.6: Documentar 20 RN Backend
**Prioridad**: ALTA
**Esfuerzo**: 30 horas
**Responsable**: Business Analyst + Backend Lead
**Entregable**: 20 archivos RN clasificados

**RN por tipo** (según ADR-GOB-006):

**Cálculos (5 RN)**:
- RN-CALL-010: Cálculo AHT (Average Handle Time)
- RN-CALL-020: Cálculo ACW (After Call Work)
- RN-CALL-030: Cálculo SLA (Service Level Agreement)
- RN-CALL-040: Cálculo FCR (First Call Resolution)
- RN-CALL-050: Cálculo ocupación agentes

**Restricciones (7 RN)**:
- RN-PERM-010: Usuario debe tener capacidad activa
- RN-PERM-020: Grupo debe estar activo
- RN-CALL-060: Llamada solo puede transferirse si está en curso
- RN-CALL-070: Agente solo puede atender si está disponible
- RN-CONFIG-010: Configuración solo modif por administradores
- RN-AUTH-010: Sesión única por usuario
- RN-AUDIT-010: Auditoría no puede eliminarse

**Desencadenadores (5 RN)**:
- RN-CALL-080: Si llamada > 5 min, entonces alerta supervisor
- RN-CALL-090: Si SLA < 80%, entonces notificar gerente
- RN-PERM-030: Si permiso revocado, entonces invalidar cache
- RN-AUTH-020: Si 3 intentos fallidos, entonces bloquear cuenta
- RN-ALERT-010: Si sistema indisponible, entonces notificar DevOps

**Inferencias (2 RN)**:
- RN-CALL-100: Si llamada sin notas, entonces FCR = false
- RN-PERM-040: Si usuario sin grupos, entonces sin acceso

**Hechos (1 RN)**:
- RN-CALL-110: Cada llamada tiene exactamente un agente asignado

**Plantillas**: `docs/gobernanza/templates/RN-*-template.md`

#### Tarea 1.7: Crear Diagramas ER Módulos Core
**Prioridad**: ALTA
**Esfuerzo**: 16 horas
**Responsable**: Arquitecto BD
**Entregable**: 3 diagramas ER PlantUML

**Diagramas**:
1. `CLASS-BACK-020-modelo-llamadas.puml` (6h):
   - Tablas: Llamada, Cliente, Agente, Equipo, EstadoLlamada
   - Relaciones: 1:N, N:M
   - Constraints

2. `CLASS-BACK-030-modelo-analytics.puml` (5h):
   - Tablas: Metrica, Dashboard, Widget, Reporte
   - Relaciones con Llamada, Agente

3. `CLASS-BACK-040-modelo-etl.puml` (5h):
   - Tablas: ETLJob, ETLLog, IVRDataStaging
   - Integración IVR legacy

**Herramienta**: PlantUML
**Referencia**: GUIA-GOB-009

---

## Fase 2: Consolidación (Mes 2)

**Objetivo**: Consolidar arquitectura, threat model, tests apps secundarias

**Duración**: 4 semanas
**Esfuerzo**: 92 horas
**FTE**: ~0.6 FTE

### Semana 5-6: Diagramas y Seguridad (44 horas)

#### Tarea 2.1: Diagramas Secuencia UC-CALL
**Prioridad**: MEDIA
**Esfuerzo**: 12 horas
**Responsable**: Arquitecto
**Entregable**: 4 diagramas PlantUML

**Diagramas**:
1. `SEQ-CALL-001-registrar-llamada.puml` (3h)
2. `SEQ-CALL-002-atender-llamada.puml` (3h)
3. `SEQ-CALL-003-transferir-llamada.puml` (3h)
4. `SEQ-CALL-004-generar-reporte.puml` (3h)

**Template**: Seguir formato GUIA-GOB-009 (Diagramas Secuencia)

#### Tarea 2.2: Consolidar Apps configuracion/configuration
**Prioridad**: MEDIA
**Esfuerzo**: 8 horas
**Responsable**: Backend Lead
**Entregable**: App única `configuracion`

**Subtareas**:
1. Auditar diferencias entre apps (2h)
2. Migrar modelos a app única (3h)
3. Actualizar imports proyecto (2h)
4. Tests migración (1h)

#### Tarea 2.3: Documentar Threat Model Seguridad
**Prioridad**: ALTA
**Esfuerzo**: 24 horas
**Responsable**: Security Engineer + Arquitecto
**Entregable**: `docs/backend/seguridad/THREAT_MODEL.md`

**Contenido**:
1. Assets (bases datos, APIs, sesiones)
2. Threat actors (externos, internos)
3. Attack vectors (SQL injection, XSS, CSRF, etc.)
4. Security controls (authentication, authorization, encryption)
5. Risk matrix (likelihood × impact)
6. Mitigation strategies

**Framework**: STRIDE (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege)

### Semana 7-8: Tests Apps Secundarias (48 horas)

#### Tarea 2.4: Tests para analytics
**Prioridad**: MEDIA
**Esfuerzo**: 16 horas
**Responsable**: Backend Developer
**Target**: Cobertura >= 60%

**Tests**:
- Models analytics
- Views analytics
- Lógica cálculo métricas
- Integración con llamadas

#### Tarea 2.5: Tests para alertas
**Prioridad**: MEDIA
**Esfuerzo**: 16 horas
**Responsable**: Backend Developer
**Target**: Cobertura >= 60%

**Tests**:
- Models alertas
- Sistema notificaciones
- Triggers alertas
- Integración con configuración

#### Tarea 2.6: Tests para metricas
**Prioridad**: MEDIA
**Esfuerzo**: 16 horas
**Responsable**: Backend Developer
**Target**: Cobertura >= 60%

**Tests**:
- Models métricas
- Agregaciones métricas
- Reportes métricas
- Integración con dashboard

---

## Fase 3: Mejoras Adicionales (Mes 3)

**Objetivo**: Documentación avanzada, onboarding, deployment

**Duración**: 4 semanas
**Esfuerzo**: 80 horas
**FTE**: ~0.5 FTE

### Semana 9-12: Documentación y Guías (80 horas)

#### Tarea 3.1: Frontend Architecture Deep Dive
**Prioridad**: BAJA
**Esfuerzo**: 16 horas
**Responsable**: Frontend Architect
**Entregable**: `docs/frontend/arquitectura/DEEP_DIVE.md`

**Contenido**:
1. Arquitectura microfrontends
2. Lazy loading strategy
3. Code splitting
4. Bundle optimization
5. State management patterns
6. Service layer patterns

#### Tarea 3.2: Onboarding Videos/Tutoriales
**Prioridad**: BAJA
**Esfuerzo**: 40 horas
**Responsable**: Tech Lead
**Entregable**: 5 videos + transcripciones

**Videos**:
1. Setup ambiente desarrollo (30 min)
2. Arquitectura backend Django (45 min)
3. Frontend React + Redux (45 min)
4. Testing strategy (30 min)
5. Deployment workflow (30 min)

**Herramientas**: OBS Studio, Loom, YouTube

#### Tarea 3.3: Deployment Guides Producción
**Prioridad**: BAJA
**Esfuerzo**: 24 horas
**Responsable**: DevOps
**Entregable**: 3 guías deployment

**Guías**:
1. `DEPLOY_PRODUCCION.md` (10h):
   - Checklist pre-deployment
   - Scripts deployment
   - Validaciones post-deployment
   - Rollback procedure

2. `BLUE_GREEN_DEPLOYMENT.md` (8h):
   - Estrategia blue-green
   - Traffic switching
   - Health checks

3. `DISASTER_RECOVERY.md` (6h):
   - Backup restoration
   - Database recovery
   - Service restoration

---

## Tareas Paralelas (Todo el Trimestre)

### Tarea P.1: Generar Diagramas PlantUML Adicionales
**Prioridad**: MEDIA
**Esfuerzo**: Distribuido durante 3 meses
**Responsable**: Arquitecto (asignación semanal)

**Diagramas a generar**:
1. `COMP-BACK-001-arquitectura-general.puml`: Vista componentes backend
2. `COMP-BACK-002-integracion-ivr.puml`: Integración IVR legacy
3. `DEPLOY-IACT-001-arquitectura-produccion.puml`: Deployment diagram
4. `PKG-BACK-001-estructura-apps.puml`: Paquetes Django

### Tarea P.2: Validar Trazabilidad con Scripts
**Prioridad**: MEDIA
**Esfuerzo**: 1 hora semanal durante 3 meses
**Responsable**: QA

**Script**: `scripts/validar-trazabilidad.sh`

**Validaciones**:
- Referencias upward/downward
- IDs únicos
- Artefactos huérfanos
- Referencias rotas

### Tarea P.3: Documentar Restricciones en ADRs de Dominio
**Prioridad**: MEDIA
**Esfuerzo**: Distribuido durante 3 meses
**Responsable**: Arquitecto

**ADRs a crear**:
1. `ADR-BACK-010-django-orm-decision.md`: Por qué Django ORM
2. `ADR-BACK-011-postgresql-mariadb-multi-db.md`: Estrategia multi-DB
3. `ADR-BACK-012-apscheduler-no-celery.md`: Por qué APScheduler
4. `ADR-FRONT-010-typescript-gradual-adoption.md`: Estrategia TS
5. `ADR-QA-010-pytest-framework.md`: Por qué pytest

---

## Cronograma Visual

```
Mes 1 (Fundamentos Críticos)
├── Semana 1-2 (72h)
│   ├── 30 RNF (40h)              ████████████████████
│   ├── API Reference (8h)        ████
│   └── Tests ivr_legacy (24h)    ████████████
│
└── Semana 3-4 (98h)
    ├── Cobertura frontend (32h)  ████████████████
    ├── 10 RNEG (20h)             ██████████
    ├── 20 RN (30h)               ███████████████
    └── Diagramas ER (16h)        ████████

Mes 2 (Consolidación)
├── Semana 5-6 (44h)
│   ├── Diagramas UC-CALL (12h)   ██████
│   ├── Consolidar apps (8h)      ████
│   └── Threat model (24h)        ████████████
│
└── Semana 7-8 (48h)
    ├── Tests analytics (16h)     ████████
    ├── Tests alertas (16h)       ████████
    └── Tests metricas (16h)      ████████

Mes 3 (Mejoras)
└── Semana 9-12 (80h)
    ├── Frontend deep dive (16h)  ████████
    ├── Onboarding videos (40h)   ████████████████████
    └── Deployment guides (24h)   ████████████
```

---

## KPIs y Seguimiento

### Métricas Semanales

| Semana | RNF | RNEG | RN | Coverage Backend | Coverage Frontend | Tests Apps |
|--------|-----|------|----|-----------------|--------------------|------------|
| 1-2 | +30 | 0 | 0 | 62% → 65% | 31% | -1 (ivr_legacy) |
| 3-4 | 0 | +10 | +20 | 65% → 70% | 31% → 60% | 0 |
| 5-6 | 0 | 0 | 0 | 70% | 60% | 0 |
| 7-8 | 0 | 0 | 0 | 70% → 78% | 60% | -3 (analytics, alertas, metricas) |
| 9-12 | 0 | 0 | 0 | 78% → 80% | 60% | -5 (apps restantes) |

### Dashboard de Progreso

Ubicación: `docs/gobernanza/qa/DASHBOARD_PROGRESO.md`

**Contenido**:
- Progreso por fase (%)
- Horas completadas vs planeadas
- Riesgos identificados
- Blockers activos
- Next steps

**Actualización**: Semanal (viernes)

---

## Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| **Backend developer no disponible Mes 1** | Media | Alto | Priorizar ivr_legacy, posponer apps secundarias |
| **Frontend coverage 60% no alcanzable en 32h** | Media | Medio | Reducir target a 50%, extender a Mes 2 |
| **Threat model requiere > 24h** | Alta | Medio | Priorizar STRIDE básico, iterar en Mes 3 |
| **Consolidación apps más compleja** | Media | Bajo | Duplicar app si migración riesgosa |
| **Videos onboarding requieren > 40h** | Media | Bajo | Reducir a 3 videos, priorizar setup + arquitectura |

---

## Aprobaciones y Sign-off

| Rol | Nombre | Aprobación | Fecha |
|-----|--------|------------|-------|
| **Product Owner** | [Pendiente] | [ ] | YYYY-MM-DD |
| **Tech Lead** | [Pendiente] | [ ] | YYYY-MM-DD |
| **Arquitecto** | [Pendiente] | [ ] | YYYY-MM-DD |
| **QA Lead** | [Pendiente] | [ ] | YYYY-MM-DD |

---

## Próximos Pasos Inmediatos

1. **Revisar plan con stakeholders** (2 horas)
2. **Asignar responsables a cada tarea** (1 hora)
3. **Crear issues GitHub para Mes 1** (2 horas)
4. **Kickoff Mes 1 con equipo** (1 hora)
5. **Ejecutar Tarea 1.1: Documentar 30 RNF** (inicio inmediato)

---

**Plan generado**: 2025-01-17
**Basado en**: ANALISIS-PROYECTO-2025-01-17.md
**Próxima revisión**: 2025-01-24 (fin Semana 1)
**Versión**: 1.0.0
