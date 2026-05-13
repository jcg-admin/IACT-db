# TASK-039: Crear MATRIZ-requisitos-tests.md

## Información General
- **Fase**: FASE 3 - Trazabilidad
- **Duración Estimada**: 40 minutos
- **Prioridad**: ALTA
- **Tipo**: Matriz de Trazabilidad
- **Metodología**: Auto-CoT + Self-Consistency + Tabular CoT

## Objetivo
Crear una matriz de trazabilidad que vincule requisitos funcionales con casos de test, asegurando cobertura completa y bidireccional.

## Auto-CoT: Razonamiento en Cadena

### Paso 1: Identificación de Requisitos
**Pregunta**: ¿Qué requisitos funcionales tiene el backend?
**Razonamiento**:
- Revisar documentación de producto
- Analizar user stories
- Examinar especificaciones de API
- Identificar features implementadas

### Paso 2: Inventario de Tests
**Pregunta**: ¿Qué tests existen actualmente?
**Razonamiento**:
- Buscar archivos test_*.py
- Analizar test cases
- Clasificar por tipo (unitario, integración, E2E)
- Identificar coverage actual

### Paso 3: Mapeo Bidireccional
**Pregunta**: ¿Cómo vincular requisitos con tests?
**Razonamiento**:
- Requisito → Tests que lo validan
- Test → Requisitos que cubre
- Identificar gaps de cobertura
- Priorizar tests faltantes

## Tabular CoT: Estructura de Análisis

| Etapa | Acción | Herramienta | Salida Esperada |
|-------|--------|-------------|-----------------|
| 1. Requisitos | Extraer requisitos funcionales | Grep/Read | Lista de requisitos |
| 2. Tests | Identificar tests existentes | Glob/Grep | Inventario de tests |
| 3. Mapeo | Vincular requisitos-tests | Análisis | Matriz preliminar |
| 4. Gaps | Identificar requisitos sin tests | Comparación | Lista de gaps |
| 5. Documentación | Crear matriz tabular | Tabular CoT | MATRIZ-requisitos-tests.md |

## Self-Consistency: Validación Cruzada

### Verificación 1: Cobertura Completa
- ¿Todos los requisitos tienen al menos 1 test?
- ¿Los requisitos críticos tienen múltiples tests?
- ¿Hay tests huérfanos (sin requisito asociado)?

### Verificación 2: Trazabilidad Bidireccional
- ¿Cada requisito lista sus tests?
- ¿Cada test lista sus requisitos?
- ¿Las referencias son consistentes?

### Verificación 3: Priorización
- ¿Los requisitos de alta prioridad tienen cobertura alta?
- ¿Los gaps están priorizados?
- ¿El roadmap de testing es realista?

## Estructura del Entregable: MATRIZ-requisitos-tests.md

```markdown
# Matriz de Trazabilidad: Requisitos → Tests

## Metadata
- **Fecha**: 2025-11-18
- **Versión**: 1.0
- **Owner**: QA Lead
- **Última Actualización**: 2025-11-18

## Resumen Ejecutivo

| Métrica | Valor |
|---------|-------|
| Total Requisitos | 45 |
| Requisitos con Tests | 38 (84%) |
| Requisitos sin Tests | 7 (16%) |
| Total Tests | 142 |
| Tests Unitarios | 89 (63%) |
| Tests Integración | 41 (29%) |
| Tests E2E | 12 (8%) |
| Cobertura Promedio | 82% |

## Matriz: Requisitos → Tests

### Módulo: Autenticación

#### REQ-AUTH-001: Login de Usuario
- **Descripción**: Usuario puede autenticarse con email y password
- **Prioridad**: CRÍTICA
- **Status**: [OK] Implementado

**Tests que cubren este requisito:**
| ID Test | Tipo | Archivo | Descripción | Status |
|---------|------|---------|-------------|--------|
| test_user_login_success | Unitario | tests/auth/test_login.py:15 | Login exitoso con credenciales válidas | [OK] PASS |
| test_user_login_invalid_password | Unitario | tests/auth/test_login.py:28 | Login falla con password incorrecta | [OK] PASS |
| test_user_login_invalid_email | Unitario | tests/auth/test_login.py:41 | Login falla con email no existente | [OK] PASS |
| test_user_login_inactive_account | Unitario | tests/auth/test_login.py:54 | Login falla con cuenta inactiva | [OK] PASS |
| test_login_api_endpoint | Integración | tests/api/test_auth_api.py:20 | Endpoint /api/v1/auth/login funciona | [OK] PASS |
| test_login_flow_e2e | E2E | tests/e2e/test_auth_flow.py:10 | Flujo completo de login | [OK] PASS |

**Cobertura**: 95% | **Casos de Prueba**: 6 | **Status**: [OK] Completo

---

#### REQ-AUTH-002: Logout de Usuario
- **Descripción**: Usuario autenticado puede cerrar sesión
- **Prioridad**: ALTA
- **Status**: [OK] Implementado

**Tests que cubren este requisito:**
| ID Test | Tipo | Archivo | Descripción | Status |
|---------|------|---------|-------------|--------|
| test_user_logout_success | Unitario | tests/auth/test_logout.py:12 | Logout exitoso | [OK] PASS |
| test_logout_invalidates_token | Unitario | tests/auth/test_logout.py:25 | Token se invalida tras logout | [OK] PASS |
| test_logout_api_endpoint | Integración | tests/api/test_auth_api.py:45 | Endpoint /api/v1/auth/logout funciona | [OK] PASS |

**Cobertura**: 88% | **Casos de Prueba**: 3 | **Status**: [OK] Completo

---

#### REQ-AUTH-003: Registro de Usuario
- **Descripción**: Nuevo usuario puede registrarse con email y password
- **Prioridad**: CRÍTICA
- **Status**: [OK] Implementado

**Tests que cubren este requisito:**
| ID Test | Tipo | Archivo | Descripción | Status |
|---------|------|---------|-------------|--------|
| test_user_registration_success | Unitario | tests/auth/test_registration.py:18 | Registro exitoso | [OK] PASS |
| test_registration_duplicate_email | Unitario | tests/auth/test_registration.py:32 | Falla con email duplicado | [OK] PASS |
| test_registration_weak_password | Unitario | tests/auth/test_registration.py:45 | Falla con password débil | [OK] PASS |
| test_registration_invalid_email | Unitario | tests/auth/test_registration.py:58 | Falla con email inválido | [OK] PASS |
| test_registration_api_endpoint | Integración | tests/api/test_auth_api.py:65 | Endpoint /api/v1/auth/register funciona | [OK] PASS |

**Cobertura**: 92% | **Casos de Prueba**: 5 | **Status**: [OK] Completo

---

#### REQ-AUTH-004: Recuperación de Password
- **Descripción**: Usuario puede recuperar password olvidado vía email
- **Prioridad**: ALTA
- **Status**: [OK] Implementado

**Tests que cubren este requisito:**
| ID Test | Tipo | Archivo | Descripción | Status |
|---------|------|---------|-------------|--------|
| test_password_reset_request | Unitario | tests/auth/test_password_reset.py:15 | Solicitud de reset exitosa | [OK] PASS |
| test_password_reset_email_sent | Unitario | tests/auth/test_password_reset.py:28 | Email de reset se envía | [OK] PASS |
| test_password_reset_confirm | Unitario | tests/auth/test_password_reset.py:41 | Reset con token válido | [OK] PASS |
| test_password_reset_invalid_token | Unitario | tests/auth/test_password_reset.py:54 | Falla con token inválido | [OK] PASS |

**Cobertura**: 85% | **Casos de Prueba**: 4 | **Status**: [OK] Completo

---

### Módulo: Usuarios

#### REQ-USER-001: Listar Usuarios
- **Descripción**: Admin puede listar todos los usuarios con paginación
- **Prioridad**: MEDIA
- **Status**: [OK] Implementado

**Tests que cubren este requisito:**
| ID Test | Tipo | Archivo | Descripción | Status |
|---------|------|---------|-------------|--------|
| test_list_users_as_admin | Unitario | tests/users/test_list.py:12 | Admin puede listar usuarios | [OK] PASS |
| test_list_users_pagination | Unitario | tests/users/test_list.py:25 | Paginación funciona correctamente | [OK] PASS |
| test_list_users_forbidden | Unitario | tests/users/test_list.py:38 | Usuario normal no puede listar | [OK] PASS |
| test_list_users_api | Integración | tests/api/test_users_api.py:15 | Endpoint GET /api/v1/users funciona | [OK] PASS |

**Cobertura**: 78% | **Casos de Prueba**: 4 | **Status**: [OK] Completo

---

#### REQ-USER-002: Actualizar Perfil
- **Descripción**: Usuario puede actualizar su propio perfil
- **Prioridad**: ALTA
- **Status**: [WARNING] Implementado parcialmente

**Tests que cubren este requisito:**
| ID Test | Tipo | Archivo | Descripción | Status |
|---------|------|---------|-------------|--------|
| test_update_own_profile | Unitario | tests/users/test_profile.py:20 | Usuario actualiza su perfil | [OK] PASS |
| test_update_profile_api | Integración | tests/api/test_users_api.py:45 | Endpoint PUT /api/v1/users/me funciona | [OK] PASS |

**Cobertura**: 65% | **Casos de Prueba**: 2 | **Status**: [WARNING] Incompleto

**Tests Faltantes:**
- [ ] Test de validación de avatar (imagen)
- [ ] Test de actualización de campos protegidos
- [ ] Test de concurrencia

---

### Módulo: Productos

#### REQ-PROD-001: Crear Producto
- **Descripción**: Staff puede crear nuevos productos
- **Prioridad**: CRÍTICA
- **Status**: [OK] Implementado

**Tests que cubren este requisito:**
| ID Test | Tipo | Archivo | Descripción | Status |
|---------|------|---------|-------------|--------|
| test_create_product_as_staff | Unitario | tests/products/test_create.py:18 | Staff crea producto exitosamente | [OK] PASS |
| test_create_product_validation | Unitario | tests/products/test_create.py:31 | Validación de campos | [OK] PASS |
| test_create_product_forbidden | Unitario | tests/products/test_create.py:44 | Usuario normal no puede crear | [OK] PASS |
| test_create_product_api | Integración | tests/api/test_products_api.py:20 | Endpoint POST /api/v1/products funciona | [OK] PASS |

**Cobertura**: 89% | **Casos de Prueba**: 4 | **Status**: [OK] Completo

---

#### REQ-PROD-002: Buscar Productos
- **Descripción**: Cualquier usuario puede buscar productos por nombre o categoría
- **Prioridad**: ALTA
- **Status**: [ERROR] No Implementado

**Tests que cubren este requisito:**
| ID Test | Tipo | Archivo | Descripción | Status |
|---------|------|---------|-------------|--------|
| - | - | - | Sin tests | [ERROR] N/A |

**Cobertura**: 0% | **Casos de Prueba**: 0 | **Status**: [ERROR] Sin Implementar

**Tests Requeridos:**
- [ ] Test de búsqueda por nombre
- [ ] Test de búsqueda por categoría
- [ ] Test de búsqueda con filtros
- [ ] Test de búsqueda con paginación
- [ ] Test de búsqueda API endpoint

---

## Matriz Inversa: Tests → Requisitos

### tests/auth/test_login.py

| Test | Línea | Requisitos Cubiertos | Tipo |
|------|-------|---------------------|------|
| test_user_login_success | 15 | REQ-AUTH-001 | Unitario |
| test_user_login_invalid_password | 28 | REQ-AUTH-001 | Unitario |
| test_user_login_invalid_email | 41 | REQ-AUTH-001 | Unitario |
| test_user_login_inactive_account | 54 | REQ-AUTH-001 | Unitario |

### tests/auth/test_logout.py

| Test | Línea | Requisitos Cubiertos | Tipo |
|------|-------|---------------------|------|
| test_user_logout_success | 12 | REQ-AUTH-002 | Unitario |
| test_logout_invalidates_token | 25 | REQ-AUTH-002 | Unitario |

### tests/auth/test_registration.py

| Test | Línea | Requisitos Cubiertos | Tipo |
|------|-------|---------------------|------|
| test_user_registration_success | 18 | REQ-AUTH-003 | Unitario |
| test_registration_duplicate_email | 32 | REQ-AUTH-003 | Unitario |
| test_registration_weak_password | 45 | REQ-AUTH-003 | Unitario |
| test_registration_invalid_email | 58 | REQ-AUTH-003 | Unitario |

## Análisis de Gaps (Brechas de Cobertura)

### Requisitos Sin Tests

| Requisito | Prioridad | Módulo | Esfuerzo Estimado | Fecha Objetivo |
|-----------|-----------|--------|-------------------|----------------|
| REQ-PROD-002 | ALTA | Productos | 6 horas | 2025-11-25 |
| REQ-ORDER-005 | MEDIA | Pedidos | 4 horas | 2025-12-01 |
| REQ-NOTIF-001 | BAJA | Notificaciones | 3 horas | 2025-12-10 |

### Requisitos con Cobertura Insuficiente (< 70%)

| Requisito | Cobertura Actual | Objetivo | Tests Faltantes | Prioridad |
|-----------|------------------|----------|-----------------|-----------|
| REQ-USER-002 | 65% | 80% | 3 | ALTA |
| REQ-PROD-004 | 58% | 75% | 4 | MEDIA |
| REQ-ORDER-003 | 62% | 80% | 3 | ALTA |

### Tests sin Requisito Asociado (Huérfanos)

| Test | Archivo | Descripción | Acción Requerida |
|------|---------|-------------|------------------|
| test_legacy_import | tests/utils/test_legacy.py:45 | Test de funcionalidad legacy | Documentar requisito o eliminar |
| test_experimental_feature | tests/features/test_exp.py:12 | Feature experimental | Crear REQ-EXP-001 o eliminar |

## Roadmap de Testing

### Sprint Actual (2025-11-18 a 2025-12-01)
- [ ] Completar tests de REQ-USER-002 (3 tests)
- [ ] Implementar tests de REQ-PROD-002 (5 tests)
- [ ] Mejorar cobertura de REQ-ORDER-003

### Próximo Sprint (2025-12-02 a 2025-12-15)
- [ ] Implementar tests de REQ-ORDER-005
- [ ] Completar tests de REQ-PROD-004
- [ ] Auditoría de tests huérfanos

### Q1 2026
- [ ] Implementar tests de REQ-NOTIF-001
- [ ] Alcanzar 90% cobertura en módulos críticos
- [ ] Automatizar generación de matriz

## Métricas de Calidad

### Por Módulo

| Módulo | Requisitos | Con Tests | % Cobertura | Tests Total |
|--------|------------|-----------|-------------|-------------|
| Autenticación | 5 | 5 | 100% | 28 |
| Usuarios | 8 | 7 | 87% | 35 |
| Productos | 12 | 10 | 83% | 48 |
| Pedidos | 10 | 8 | 80% | 39 |
| Notificaciones | 10 | 8 | 80% | 12 |
| **TOTAL** | **45** | **38** | **84%** | **142** |

### Por Prioridad

| Prioridad | Requisitos | Con Tests | % Cobertura |
|-----------|------------|-----------|-------------|
| CRÍTICA | 12 | 12 | 100% |
| ALTA | 18 | 16 | 89% |
| MEDIA | 10 | 7 | 70% |
| BAJA | 5 | 3 | 60% |

### Por Tipo de Test

| Tipo | Cantidad | % del Total | Cobertura Promedio |
|------|----------|-------------|-------------------|
| Unitario | 89 | 63% | 85% |
| Integración | 41 | 29% | 78% |
| E2E | 12 | 8% | 72% |

## Herramientas

- **pytest**: Framework de testing
- **pytest-cov**: Cobertura de código
- **pytest-django**: Testing para Django
- **factory-boy**: Generación de fixtures
- **faker**: Datos de prueba

## Referencias
- backend/tests/
- docs/requirements/
- docs/backend/CATALOGO-ENDPOINTS.md
- docs/backend/qa/TEST-STRATEGY.md

## Changelog
- v1.0 (2025-11-18): Versión inicial con 45 requisitos y 142 tests
```

## Entregables
- [ ] MATRIZ-requisitos-tests.md creado
- [ ] Todos los requisitos inventariados
- [ ] Todos los tests mapeados
- [ ] Matriz bidireccional completa
- [ ] Gaps de cobertura identificados
- [ ] Roadmap de testing creado
- [ ] Validación Self-Consistency completada

## Criterios de Aceptación
1. [OK] Matriz completa requisitos → tests
2. [OK] Matriz inversa tests → requisitos
3. [OK] Formato tabular utilizado (Tabular CoT)
4. [OK] Cobertura por módulo calculada
5. [OK] Gaps identificados y priorizados
6. [OK] Roadmap de testing incluido
7. [OK] Métricas de calidad calculadas

## Notas
- Buscar requisitos en: docs/requirements/, user stories
- Buscar tests en: backend/tests/, tests/
- Usar pytest para obtener listado de tests
- Calcular cobertura con pytest-cov
- Priorizar gaps según criticidad del requisito
