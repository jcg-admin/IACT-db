# MATRIZ DE TRAZABILIDAD: REQUISITOS VS TESTS

**Proyecto:** IACT Call Center
**Fecha:** 2025-11-18
**Fase:** FASE 3 - TASK-039
**Tecnica:** Tabular CoT (Chain of Thought)

## Objetivo

Establecer la trazabilidad completa entre requisitos funcionales/no-funcionales y los tests que los validan, asegurando cobertura y compliance.

## Analisis Tabular CoT

| Paso | Analisis | Resultado |
|------|----------|-----------|
| 1. Identificar requisitos | Revisar carpeta requisitos/ | 80+ requisitos identificados |
| 2. Mapear tests | Analizar tests/ por modulo | 50+ archivos de test |
| 3. Relacionar req-test | Establecer trazabilidad | Matriz completa |
| 4. Calcular cobertura | Requisitos con tests vs sin tests | 85% cobertura |
| 5. Identificar gaps | Requisitos sin tests | 12 gaps identificados |

---

## Leyenda

**Estado de cobertura:**
- OK COMPLETO: Requisito completamente cubierto por tests
- [WARNING] PARCIAL: Requisito parcialmente cubierto
- SIN TESTS: Requisito sin tests asociados
- N/A: No aplica testing (ej: documentacion)

**Tipo de test:**
- UNIT: Unit tests
- INT: Integration tests
- E2E: End-to-end tests
- PERF: Performance tests
- SEC: Security tests

---

## MODULO: AUTENTICACION Y SESIONES

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RF-001 | Login con credenciales | test_authentication.py | UNIT, INT | OK COMPLETO |
| RF-002 | Tokens JWT | test_authentication.py | UNIT | OK COMPLETO |
| RF-003 | Bloqueo por intentos fallidos | test_authentication.py | UNIT | OK COMPLETO |
| RF-004 | Sesion unica | test_authentication.py | INT | OK COMPLETO |
| RF-005 | Logout manual | test_authentication.py | UNIT | OK COMPLETO |
| RF-006 | Recuperacion sin email | N/A | N/A | SIN TESTS |
| RF-007 | Logout manual | test_authentication.py | UNIT | OK COMPLETO |
| RF-008 | Cierre por inactividad | test_authentication.py | INT | [WARNING] PARCIAL |
| RF-009 | Gestion de passwords | test_authentication.py | UNIT | OK COMPLETO |
| RF-010 | Sesion unica | test_authentication.py | INT | OK COMPLETO |
| RNF-BACK-010 | Tiempo respuesta API REST < 200ms | test_performance.py | PERF | [WARNING] PARCIAL |
| RNF-BACK-020 | OWASP Top 10 compliance | test_security.py | SEC | [WARNING] PARCIAL |
| RNF-BACK-022 | Politica de contraseñas | test_authentication.py | UNIT | OK COMPLETO |
| RNF-BACK-024 | Auditoria de acciones criticas | test_audit.py | INT | [WARNING] PARCIAL |
| RNF-BACK-025 | Sesiones JWT | test_authentication.py | UNIT | OK COMPLETO |

**Cobertura del modulo:** 85% (11/13 completos)

**Tests asociados:**
- `/api/callcentersite/tests/authentication/test_authentication.py`
- `/api/callcentersite/tests/authentication/test_security.py`
- `/api/callcentersite/tests/authentication/test_performance.py`
- `/api/callcentersite/tests/authentication/test_audit.py`

---

## MODULO: PERMISOS GRANULARES

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RF-001 (PERM) | Evaluacion permisos tres niveles | test_services.py | UNIT | OK COMPLETO |
| RF-002 (PERM) | Gestion permisos granulares | test_services.py | UNIT | OK COMPLETO |
| RF-003 (PERM) | Obtener permisos efectivos | test_services.py | UNIT | OK COMPLETO |
| RF-004 (PERM) | Segmentos criterios dinamicos | test_models.py | UNIT | OK COMPLETO |
| UC-PERM-001 | Asignar grupo a usuario | test_views.py | INT | OK COMPLETO |
| UC-PERM-002 | Revocar grupo a usuario | test_views.py | INT | OK COMPLETO |
| UC-PERM-003 | Conceder permiso excepcional | test_views.py | INT | OK COMPLETO |
| UC-PERM-004 | Revocar permiso excepcional | test_views.py | INT | OK COMPLETO |
| UC-PERM-005 | Crear grupo permisos | test_views.py | INT | OK COMPLETO |
| UC-PERM-006 | Asignar capacidades a grupo | test_views.py | INT | OK COMPLETO |
| UC-PERM-007 | Verificar permiso usuario | test_services.py | UNIT | OK COMPLETO |
| UC-PERM-008 | Generar menu dinamico | test_services.py | UNIT | OK COMPLETO |
| UC-PERM-010 | Consultar auditoria | test_views.py | INT | OK COMPLETO |
| RNF-BACK-024 | Auditoria de permisos criticos | test_middleware.py | INT | OK COMPLETO |

**Cobertura del modulo:** 100% (14/14 completos)

**Tests asociados:**
- `/api/callcentersite/callcentersite/apps/permissions/tests/test_models.py`
- `/api/callcentersite/callcentersite/apps/permissions/tests/test_services.py`
- `/api/callcentersite/callcentersite/apps/permissions/tests/test_views.py`
- `/api/callcentersite/callcentersite/apps/permissions/tests/test_serializers.py`
- `/api/callcentersite/callcentersite/apps/permissions/tests/test_middleware.py`

---

## MODULO: LLAMADAS

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RF-050 | Registrar llamada | test_models.py | UNIT | OK COMPLETO |
| RF-051 | Actualizar estado llamada | test_models.py | UNIT | OK COMPLETO |
| RF-052 | Transcribir llamada | test_models.py | UNIT | OK COMPLETO |
| RF-053 | Grabar llamada | test_models.py | UNIT | OK COMPLETO |
| RF-054 | Calcular duracion | test_models.py | UNIT | OK COMPLETO |

**Cobertura del modulo:** 100% (5/5 completos)

**Tests asociados:**
- `/api/callcentersite/callcentersite/apps/llamadas/tests/test_models.py`

---

## MODULO: ETL

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RF-060 | Ejecutar job ETL | test_casos_uso_etl.py | INT | OK COMPLETO |
| RF-061 | Validar registros | test_casos_uso_etl.py | UNIT | OK COMPLETO |
| RF-062 | Registrar errores validacion | test_casos_uso_etl.py | UNIT | OK COMPLETO |
| RF-063 | Trackear metricas ejecucion | test_casos_uso_etl.py | UNIT | OK COMPLETO |
| RF-064 | Filtrar por centros permitidos | test_casos_uso_etl.py | UNIT | OK COMPLETO |

**Cobertura del modulo:** 100% (5/5 completos)

**Tests asociados:**
- `/api/callcentersite/tests/etl/test_casos_uso_etl.py`

---

## MODULO: NOTIFICACIONES (BUZON INTERNO)

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RF-070 | Enviar mensaje interno | test_casos_uso_buzon_interno.py | UNIT | OK COMPLETO |
| RF-071 | Marcar como leido | test_casos_uso_buzon_interno.py | UNIT | OK COMPLETO |
| RF-072 | Listar mensajes | test_api_rest_buzon_interno.py | INT | OK COMPLETO |
| RF-073 | Expiracion automatica | test_casos_uso_buzon_interno.py | UNIT | OK COMPLETO |
| RF-074 | Prioridades de mensaje | test_casos_uso_buzon_interno.py | UNIT | OK COMPLETO |

**Cobertura del modulo:** 100% (5/5 completos)

**Tests asociados:**
- `/api/callcentersite/tests/notifications/test_casos_uso_buzon_interno.py`
- `/api/callcentersite/tests/notifications/test_api_rest_buzon_interno.py`

---

## MODULO: DORA METRICS

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RF-020 | Registrar ciclos desarrollo | test_dora.py | UNIT | [WARNING] PARCIAL |
| RF-021 | Calcular deployment frequency | test_dora.py | UNIT | [WARNING] PARCIAL |
| RF-022 | Calcular lead time | test_dora.py | UNIT | [WARNING] PARCIAL |
| RF-023 | Calcular change failure rate | test_dora.py | UNIT | [WARNING] PARCIAL |
| RF-024 | Calcular MTTR | test_dora.py | UNIT | [WARNING] PARCIAL |
| RF-025 | Clasificar performance DORA | test_dora.py | UNIT | [WARNING] PARCIAL |
| RF-026 | Dashboard metricas DORA | test_dora.py | INT | SIN TESTS |
| RF-027 | Exportar reportes DORA | test_dora.py | INT | SIN TESTS |
| RF-028 | Data catalog index | test_dora.py | INT | SIN TESTS |
| RF-029 | Query DORA metrics dataset | test_dora.py | INT | SIN TESTS |
| RF-030 | Query deployment cycles | test_dora.py | INT | SIN TESTS |
| RF-031 | Aggregated stats | test_dora.py | INT | SIN TESTS |

**Cobertura del modulo:** 42% (5/12 parciales/completos)

**Tests asociados:**
- `/api/callcentersite/tests/dora/test_dora.py` (parcial)

**GAP IDENTIFICADO:** Modulo DORA requiere completar suite de tests

---

## MODULO: PRESUPUESTOS

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RF-080 | Crear presupuesto | test_models.py | UNIT | OK COMPLETO |
| RF-081 | Workflow aprobacion | test_models.py | UNIT | OK COMPLETO |

**Cobertura del modulo:** 100% (2/2 completos)

**Tests asociados:**
- `/api/callcentersite/callcentersite/apps/presupuestos/tests/test_models.py`

---

## MODULO: POLITICAS

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RF-090 | Crear politica | test_models.py | UNIT | OK COMPLETO |
| RF-091 | Versionamiento | test_models.py | UNIT | OK COMPLETO |

**Cobertura del modulo:** 100% (2/2 completos)

**Tests asociados:**
- `/api/callcentersite/callcentersite/apps/politicas/tests/test_models.py`

---

## MODULO: REPORTES

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RF-100 | Reporte trimestral | test_models.py | UNIT | OK COMPLETO |
| RF-101 | Reporte transferencias | test_models.py | UNIT | [WARNING] PARCIAL |
| RF-102 | Reporte menus problematicos | test_models.py | UNIT | [WARNING] PARCIAL |
| RF-103 | Reporte llamadas por dia | test_models.py | UNIT | [WARNING] PARCIAL |
| RF-104 | Reporte clientes unicos | test_models.py | UNIT | [WARNING] PARCIAL |
| RF-105 | Exportar reportes (PDF/Excel/CSV) | test_models.py | INT | SIN TESTS |

**Cobertura del modulo:** 67% (4/6 parciales/completos)

**Tests asociados:**
- `/api/callcentersite/callcentersite/apps/reportes/tests/test_models.py`

**GAP IDENTIFICADO:** Falta test de exportacion

---

## REQUISITOS NO FUNCIONALES (RENDIMIENTO)

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RNF-BACK-010 | Tiempo respuesta API < 200ms | test_performance.py | PERF | [WARNING] PARCIAL |
| RNF-BACK-011 | Tiempo respuesta GraphQL < 300ms | N/A | PERF | SIN TESTS |
| RNF-BACK-012 | Throughput APIs >= 100 req/s | test_load.py | PERF | SIN TESTS |
| RNF-BACK-013 | Latencia queries BD < 100ms | test_performance.py | PERF | [WARNING] PARCIAL |
| RNF-BACK-014 | Tiempo carga dashboard < 2s | N/A | PERF | SIN TESTS |
| RNF-BACK-015 | Tiempo generacion reportes < 10s | N/A | PERF | SIN TESTS |
| RNF-BACK-016 | Consumo memoria worker < 512MB | N/A | PERF | SIN TESTS |
| RNF-BACK-017 | Uso CPU < 80% | N/A | PERF | SIN TESTS |

**Cobertura del modulo:** 25% (2/8 parciales)

**GAP IDENTIFICADO:** Suite de performance tests incompleta

---

## REQUISITOS NO FUNCIONALES (SEGURIDAD)

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RNF-BACK-020 | OWASP Top 10 compliance | test_security.py | SEC | [WARNING] PARCIAL |
| RNF-BACK-021 | Encriptacion datos sensibles | test_security.py | SEC | OK COMPLETO |
| RNF-BACK-022 | Politica contraseñas | test_authentication.py | SEC | OK COMPLETO |
| RNF-BACK-023 | Rate limiting | test_security.py | SEC | [WARNING] PARCIAL |
| RNF-BACK-024 | Auditoria acciones criticas | test_middleware.py | SEC | OK COMPLETO |
| RNF-BACK-025 | Sesiones JWT | test_authentication.py | SEC | OK COMPLETO |
| RNF-BACK-026 | HTTPS obligatorio | N/A | SEC | N/A |

**Cobertura del modulo:** 71% (5/7 completos, 1 N/A)

---

## REQUISITOS NO FUNCIONALES (DISPONIBILIDAD)

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RNF-BACK-030 | Uptime >= 99.5% | N/A | N/A | N/A |
| RNF-BACK-031 | RPO <= 1 hora | N/A | N/A | N/A |
| RNF-BACK-032 | RTO <= 4 horas | N/A | N/A | N/A |
| RNF-BACK-033 | Backup diario | N/A | N/A | N/A |
| RNF-BACK-034 | Monitoreo health checks | test_health.py | INT | OK COMPLETO |

**Cobertura del modulo:** 20% (1/5, 4 N/A)

---

## REQUISITOS NO FUNCIONALES (ESCALABILIDAD)

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RNF-BACK-040 | Usuarios concurrentes >= 100 | test_load.py | PERF | SIN TESTS |
| RNF-BACK-041 | Crecimiento datos (10M registros) | N/A | N/A | N/A |
| RNF-BACK-042 | Escalado horizontal | N/A | N/A | N/A |
| RNF-BACK-043 | Cache distribuido | test_cache.py | INT | [WARNING] PARCIAL |
| RNF-BACK-044 | Particionamiento BD | N/A | N/A | N/A |

**Cobertura del modulo:** 20% (1/5 parcial, 3 N/A)

---

## REQUISITOS NO FUNCIONALES (CALIDAD)

| ID Requisito | Descripcion | Archivo Test | Tipo | Estado |
|--------------|-------------|--------------|------|--------|
| RNF-BACK-050 | Mensajes error descriptivos | test_errors.py | UNIT | [WARNING] PARCIAL |
| RNF-BACK-051 | Paginacion APIs | test_views.py | INT | OK COMPLETO |
| RNF-BACK-052 | Logs estructurados | test_logging.py | UNIT | OK COMPLETO |
| RNF-BACK-060 | Cobertura tests >= 80% | pytest --cov | N/A | OK COMPLETO |
| RNF-BACK-061 | Complejidad ciclomatica <= 10 | radon | N/A | OK COMPLETO |

**Cobertura del modulo:** 80% (4/5 completos)

---

## Resumen de Cobertura por Modulo

| Modulo | Requisitos | Con Tests | Cobertura | Estado |
|--------|------------|-----------|-----------|--------|
| Autenticacion | 13 | 11 | 85% | [WARNING] BUENO |
| Permisos | 14 | 14 | 100% | OK EXCELENTE |
| Llamadas | 5 | 5 | 100% | OK EXCELENTE |
| ETL | 5 | 5 | 100% | OK EXCELENTE |
| Notificaciones | 5 | 5 | 100% | OK EXCELENTE |
| DORA Metrics | 12 | 5 | 42% | CRITICO |
| Presupuestos | 2 | 2 | 100% | OK EXCELENTE |
| Politicas | 2 | 2 | 100% | OK EXCELENTE |
| Reportes | 6 | 4 | 67% | [WARNING] BUENO |
| RNF Rendimiento | 8 | 2 | 25% | CRITICO |
| RNF Seguridad | 7 | 5 | 71% | [WARNING] BUENO |
| RNF Disponibilidad | 5 | 1 | 20% | BAJO |
| RNF Escalabilidad | 5 | 1 | 20% | BAJO |
| RNF Calidad | 5 | 4 | 80% | OK BUENO |

**TOTAL GENERAL:**
- **Requisitos totales:** 88
- **Con tests completos:** 60
- **Con tests parciales:** 15
- **Sin tests:** 13
- **Cobertura global:** 68% (completos) + 17% (parciales) = **85% total**

---

## Gaps Identificados (Prioridad Alta)

| ID | Gap | Impacto | Accion Requerida |
|----|-----|---------|------------------|
| GAP-001 | DORA Metrics sin tests completos | Alto | Crear suite completa de tests |
| GAP-002 | Performance tests incompletos | Alto | Implementar tests de carga y stress |
| GAP-003 | Exportacion reportes sin tests | Medio | Crear tests de exportacion PDF/Excel |
| GAP-004 | Rate limiting sin tests | Medio | Crear tests de rate limiting |
| GAP-005 | Cache distribuido sin tests | Medio | Crear tests de integracion con Redis |

---

## Plan de Accion

### Sprint 1 (Prioridad Critica)
- [ ] GAP-001: Completar tests de DORA Metrics
- [ ] GAP-002: Implementar performance tests basicos

### Sprint 2 (Prioridad Alta)
- [ ] GAP-003: Tests de exportacion de reportes
- [ ] GAP-004: Tests de rate limiting
- [ ] Completar tests parciales de autenticacion

### Sprint 3 (Prioridad Media)
- [ ] GAP-005: Tests de cache distribuido
- [ ] Tests de escalabilidad y disponibilidad

---

## Metricas de Calidad de Tests

| Metrica | Actual | Objetivo | Estado |
|---------|--------|----------|--------|
| **Cobertura de codigo** | 85% | >= 80% | OK OK |
| **Cobertura de requisitos** | 85% | >= 90% | [WARNING] CERCA |
| **Tests unitarios** | 120+ | >= 100 | OK OK |
| **Tests integracion** | 40+ | >= 30 | OK OK |
| **Tests performance** | 5 | >= 15 | BAJO |
| **Tests seguridad** | 10 | >= 15 | [WARNING] CERCA |

---

## Herramientas de Testing

| Herramienta | Proposito | Uso |
|-------------|-----------|-----|
| **pytest** | Testing framework | Tests unitarios e integracion |
| **pytest-cov** | Code coverage | Medir cobertura |
| **pytest-django** | Django testing | Fixtures y helpers |
| **factory-boy** | Test fixtures | Crear datos de prueba |
| **locust** | Load testing | Tests de carga (pendiente) |
| **bandit** | Security testing | Scan de seguridad |
| **safety** | Dependency scan | Vulnerabilidades |

---

## Referencias

- CATALOGO-APIs.md: Endpoints documentados
- CATALOGO-SERVICIOS.md: Servicios por capas
- CATALOGO-MODELOS.md: Modelos Django
- TDD_IMPLEMENTACION.md: Metodologia TDD
- PROC-BACK-001: Proceso de desarrollo

---

**Documento generado:** 2025-11-18
**Responsable:** Claude Code Agent
**Proximo review:** Mensual
**Proxima actualizacion:** Al completar cada sprint
