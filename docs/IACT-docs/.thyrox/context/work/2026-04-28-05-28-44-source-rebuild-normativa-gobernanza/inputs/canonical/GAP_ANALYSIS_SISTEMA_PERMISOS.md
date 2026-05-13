---
id: GAP-ANALYSIS-PERMISOS
tipo: analisis_tecnico
estado: en_progreso
fecha: 2025-11-09
owner: equipo-backend
prioridad: alta
---

# Análisis de Brechas (GAP Analysis) - Sistema de Permisos Granular

## Resumen Ejecutivo

Este documento analiza el estado actual de implementación del Sistema de Permisos Granular y documenta las brechas (gaps) identificadas entre lo implementado y lo requerido para un sistema completo y production-ready.

**Estado general**: 75% completado

## 1. Estado Actual - Lo que SÍ está implementado

### 1.1 Base de Datos (100% completo)
- [OK] 8 modelos Django (`models_permisos_granular.py`)
  - Funcion, Capacidad, FuncionCapacidad
  - GrupoPermiso, GrupoCapacidad
  - UsuarioGrupo, PermisoExcepcional
  - AuditoriaPermiso
- [OK] 2 vistas SQL optimizadas
  - `vista_capacidades_usuario`
  - `vista_grupos_usuario`
- [OK] 5 funciones SQL nativas (PostgreSQL)
  - `usuario_tiene_permiso()`
  - `obtener_capacidades_usuario()`
  - `obtener_grupos_usuario()`
  - `verificar_permiso_y_auditar()`
  - `obtener_menu_usuario()`
- [OK] 3 migraciones Django
  - `0001_initial_permisos_granular.py`
  - `0002_create_permission_views.py`
  - `0003_create_permission_functions.py`
- [OK] Índices optimizados para queries frecuentes

**Archivos**:
- `api/callcentersite/callcentersite/apps/users/models_permisos_granular.py` (378 líneas)
- `api/callcentersite/callcentersite/apps/users/migrations/000{1,2,3}_*.py` (700+ líneas)

---

### 1.2 Service Layer (100% completo)
- [OK] `UserManagementService` con 6 métodos
  - `usuario_tiene_permiso()` - Verificación de permiso
  - `asignar_grupo_a_usuario()` - Asignación de grupos
  - `revocar_grupo_de_usuario()` - Revocación de grupos
  - `obtener_capacidades_de_usuario()` - Lista de capacidades
  - `otorgar_permiso_excepcional()` - Permisos temporales
  - `obtener_grupos_de_usuario()` - Grupos activos
- [OK] Validaciones de negocio
- [OK] Auditoría integrada

**Archivos**:
- `api/callcentersite/callcentersite/apps/users/services_permisos_granular.py` (450 líneas)

---

### 1.3 REST API (100% completo)
- [OK] 6 serializers completos (550 líneas)
  - Funcion (list, detail, create/update)
  - Capacidad (list, detail, create/update)
  - GrupoPermiso (list, detail, create/update)
  - PermisoExcepcional (list, detail, create)
  - AuditoriaPermiso (read-only)
  - Verificacion (custom responses)
- [OK] 6 ViewSets con CRUD completo (700 líneas)
  - FuncionViewSet
  - CapacidadViewSet
  - GrupoPermisoViewSet
  - PermisoExcepcionalViewSet
  - AuditoriaPermisoViewSet
  - VerificacionPermisoViewSet
- [OK] Endpoints de verificación usando SQL functions
  - GET /api/permisos/verificar/:id/capacidades/
  - GET /api/permisos/verificar/:id/tiene-permiso/?capacidad=X
  - GET /api/permisos/verificar/:id/menu/
  - GET /api/permisos/verificar/:id/grupos/
- [OK] Configuración de URLs con router DRF

**Archivos**:
- `api/callcentersite/callcentersite/apps/users/serializers_permisos.py` (550 líneas)
- `api/callcentersite/callcentersite/apps/users/views_permisos.py` (700 líneas)
- `api/callcentersite/callcentersite/apps/users/urls_permisos.py` (35 líneas)

---

### 1.4 Tests (80% completo)
- [OK] 50+ test cases para REST API (800 líneas)
  - Tests de CRUD para todos los recursos
  - Tests de filtros y query params
  - Tests de autenticación
  - Tests de casos de error
  - Tests de verificación con SQL functions
- [PENDING] Tests de integración con SQL views
- [PENDING] Tests de performance automatizados
- [PENDING] Tests de carga

**Archivos**:
- `api/callcentersite/tests/permisos_api/test_rest_api_permisos.py` (800 líneas)

---

### 1.5 Documentación (70% completo)
- [OK] ADR completo (453 líneas)
  - Decisión de estrategia híbrida ORM + SQL
  - Reglas de cuándo usar cada enfoque
  - Benchmarks esperados
- [OK] Documentación de arquitectura (600 líneas)
  - Descripción de 8 modelos
  - Descripción de vistas SQL
  - Descripción de funciones SQL
  - Ejemplos de uso
- [OK] Script de benchmarks (315 líneas)
  - Comparación ORM vs SQL
  - Estadísticas (min, max, mean, median, p95, p99)
- [PENDING] Casos de uso detallados
- [PENDING] Diagramas UML
- [PENDING] OpenAPI/Swagger spec
- [PENDING] Guía de integración frontend

**Archivos**:
- `docs/adr/ADR_2025_010-orm-sql-hybrid-permissions.md` (453 líneas)
- `docs/backend/arquitectura/permisos-granular.md` (600 líneas)
- `scripts/benchmarks/benchmark_permisos_orm_vs_sql.py` (315 líneas)

---

## 2. Brechas Identificadas (GAPs)

### 2.1 Documentación de Casos de Uso (CRÍTICO)
**Gap**: Faltan casos de uso detallados siguiendo estándares UML 2.5

**Lo que falta**:
1. UC-PERM-001: Asignar Grupo de Permisos a Usuario ← **EN PROGRESO**
2. UC-PERM-002: Revocar Grupo de Permisos de Usuario
3. UC-PERM-003: Otorgar Permiso Excepcional
4. UC-PERM-004: Verificar Permiso de Usuario
5. UC-PERM-005: Crear Grupo de Permisos
6. UC-PERM-006: Asignar Capacidades a Grupo
7. UC-PERM-007: Consultar Auditoría de Accesos
8. UC-PERM-008: Generar Menú Dinámico por Permisos
9. UC-PERM-009: Crear Función y Capacidades
10. UC-PERM-010: Activar/Desactivar Capacidades

**Formato requerido**:
- Frontmatter YAML con trazabilidad
- Formato dos columnas (Actor | Sistema)
- Flujos alternos y de excepción
- Precondiciones y postcondiciones
- Reglas de negocio vinculadas
- Requisitos especiales (rendimiento, seguridad)

**Prioridad**: ALTA
**Estimación**: 2 días (10 casos de uso × 2 horas)
**Responsable**: equipo-backend + business-analyst

---

### 2.2 Diagramas UML (CRÍTICO)
**Gap**: Faltan diagramas UML para visualización del sistema

**Lo que falta**:

#### 2.2.1 Diagrama ER (Entity-Relationship)
- Mostrar las 8 tablas del sistema
- Relaciones (1:N, N:M)
- Cardinalidades
- Claves primarias y foráneas

**Archivo esperado**: `docs/anexos/diagramas/database/permisos_granular_er.puml`

#### 2.2.2 Diagramas de Casos de Uso (por cada UC)
- Actores (stick figures)
- Casos de uso (óvalos)
- Relaciones (asociación, include, extend)

**Archivos esperados**: `docs/anexos/diagramas/casos_de_uso/UC-PERM-00{1-10}.puml` (10 archivos)

#### 2.2.3 Diagramas de Secuencia (por cada UC)
- Interacción actor-sistema-base de datos
- Llamadas a funciones SQL
- Flujo temporal de eventos

**Archivos esperados**: `docs/anexos/diagramas/secuencia/UC-PERM-00{1-10}_seq.puml` (10 archivos)

#### 2.2.4 Diagramas de Actividad (por cada UC)
- Flujo de control completo
- Decisiones (diamond nodes)
- Flujos alternos visualizados

**Archivos esperados**: `docs/anexos/diagramas/actividad/UC-PERM-00{1-10}_act.puml` (10 archivos)

#### 2.2.5 Diagrama de Arquitectura (Capas)
- Capa de presentación (Frontend)
- Capa de API (REST endpoints)
- Capa de servicio (UserManagementService)
- Capa de datos (ORM + SQL functions)
- Capa de persistencia (PostgreSQL)

**Archivo esperado**: `docs/anexos/diagramas/arquitectura/permisos_granular_arquitectura.puml`

#### 2.2.6 Diagrama de Componentes
- Componentes del sistema
- Interfaces entre componentes
- Dependencias

**Archivo esperado**: `docs/anexos/diagramas/componentes/permisos_granular_componentes.puml`

**Prioridad**: ALTA
**Estimación**: 1.5 días (32 diagramas)
**Responsable**: arquitecto-software + equipo-backend

---

### 2.3 OpenAPI/Swagger Specification (ALTA)
**Gap**: Falta especificación OpenAPI 3.0 para documentación interactiva

**Lo que falta**:
- Archivo `openapi_permisos.yaml` con:
  - Definición de todos los 30+ endpoints
  - Schemas de requests/responses
  - Ejemplos de payloads
  - Códigos de error documentados
  - Autenticación (JWT Bearer)
  - Tags y agrupación lógica

**Formato esperado**:
```yaml
openapi: 3.0.3
info:
  title: Sistema de Permisos Granular API
  version: 1.0.0
  description: API REST para gestión de permisos basada en grupos
paths:
  /api/permisos/grupos/:
    get:
      summary: Listar grupos de permisos
      tags: [Grupos]
      ...
```

**Beneficios**:
- Documentación interactiva con Swagger UI
- Generación automática de clientes (TypeScript, Python)
- Validación de contratos API
- Testing automatizado con Postman/Newman

**Prioridad**: ALTA
**Estimación**: 1 día
**Responsable**: equipo-backend

---

### 2.4 Decorators y Middleware (ALTA)
**Gap**: Faltan decorators y middleware para simplificar protección de endpoints

**Lo que falta**:

#### 2.4.1 Decorator @require_permission
```python
@require_permission('sistema.administracion.usuarios.ver')
def listar_usuarios(request):
    # Verificación automática, no manual
    ...
```

#### 2.4.2 Middleware de Auditoría Automática
```python
class AuditMiddleware:
    """Audita automáticamente todos los accesos a endpoints protegidos"""
    ...
```

#### 2.4.3 Permission Mixin para ViewSets
```python
class PermissionRequiredViewSet(viewsets.ModelViewSet):
    required_permission = 'sistema.administracion.grupos.ver'
    ...
```

**Archivo esperado**: `api/callcentersite/callcentersite/apps/users/permissions.py` (200 líneas)

**Prioridad**: ALTA
**Estimación**: 0.5 días
**Responsable**: equipo-backend

---

### 2.5 Django Management Commands (MEDIA)
**Gap**: Faltan comandos de gestión para operaciones administrativas

**Lo que falta**:

#### 2.5.1 Comando: seed_permisos
```bash
python manage.py seed_permisos [--reset]
```
Crea grupos y capacidades base del sistema.

#### 2.5.2 Comando: assign_admin_permisos
```bash
python manage.py assign_admin_permisos <user_id>
```
Asigna todos los permisos de administrador a un usuario.

#### 2.5.3 Comando: audit_permisos
```bash
python manage.py audit_permisos [--usuario <id>] [--desde <fecha>]
```
Muestra auditoría de permisos con filtros.

#### 2.5.4 Comando: export_permisos
```bash
python manage.py export_permisos --output permisos.json
```
Exporta configuración de permisos a JSON.

#### 2.5.5 Comando: import_permisos
```bash
python manage.py import_permisos --input permisos.json
```
Importa configuración desde JSON.

**Archivos esperados**: `api/callcentersite/callcentersite/apps/users/management/commands/*.py` (5 archivos, ~500 líneas)

**Prioridad**: MEDIA
**Estimación**: 1 día
**Responsable**: equipo-backend

---

### 2.6 Script de Seed/Inicialización (ALTA)
**Gap**: Falta script para inicializar datos base del sistema

**Lo que falta**:
```python
# scripts/seed_permisos_base.py

# Crea:
# - 15 funciones base (dashboards, usuarios, reportes, etc)
# - 50 capacidades (ver, crear, editar, eliminar por función)
# - 8 grupos estándar:
#   - administradores_sistema
#   - supervisores
#   - operadores
#   - analistas
#   - auditores
#   - soporte_tecnico
#   - readonly
#   - guest
```

**Archivo esperado**: `scripts/seed_permisos_base.py` (300 líneas)

**Prioridad**: ALTA (bloqueante para testing en entornos nuevos)
**Estimación**: 0.5 días
**Responsable**: equipo-backend

---

### 2.7 Documentación de Integración Frontend (ALTA)
**Gap**: Falta guía para desarrolladores frontend

**Lo que falta**:

#### 2.7.1 Guía de Integración
```markdown
# Integración del Sistema de Permisos - Frontend

## 1. Autenticación
- Obtener token JWT
- Incluir en headers: Authorization: Bearer <token>

## 2. Verificación de Permisos en Cliente
- Endpoint: GET /api/permisos/verificar/:id/capacidades/
- Caché en localStorage
- Refresh cada 5 minutos

## 3. Protección de Componentes React
<PermissionGate permission="sistema.vistas.dashboards.ver">
  <Dashboard />
</PermissionGate>

## 4. Menú Dinámico
- Endpoint: GET /api/permisos/verificar/:id/menu/
- Construcción automática de navbar

## 5. Manejo de Errores
- 401 Unauthorized → Redirect login
- 403 Forbidden → Mostrar mensaje
```

#### 2.7.2 Cliente TypeScript
```typescript
// lib/permisos-client.ts
export class PermisosClient {
  async getCapacidades(userId: number): Promise<string[]>
  async tienePermiso(userId: number, capacidad: string): Promise<boolean>
  async getMenu(userId: number): Promise<MenuNode[]>
}
```

#### 2.7.3 Hooks de React
```typescript
// hooks/usePermisos.ts
export function usePermisos() {
  const { hasPermission, loading, error } = ...
  return { hasPermission, loading, error }
}

// Uso:
const { hasPermission } = usePermisos()
if (hasPermission('sistema.vistas.dashboards.ver')) {
  // Mostrar dashboard
}
```

**Archivos esperados**:
- `docs/frontend/integracion_permisos.md` (200 líneas)
- `frontend/lib/permisos-client.ts` (150 líneas)
- `frontend/hooks/usePermisos.ts` (100 líneas)
- `frontend/components/PermissionGate.tsx` (50 líneas)

**Prioridad**: ALTA
**Estimación**: 1 día
**Responsable**: equipo-frontend + equipo-backend

---

### 2.8 Tests Adicionales (MEDIA)
**Gap**: Faltan algunos tipos de tests

**Lo que falta**:

#### 2.8.1 Tests de Performance Automatizados
```python
# tests/performance/test_permisos_performance.py
def test_verificacion_permiso_performance():
    """Verifica que verificación sea < 10ms (p95)"""
    times = []
    for _ in range(1000):
        start = time.perf_counter()
        usuario_tiene_permiso(user_id, capacidad)
        times.append((time.perf_counter() - start) * 1000)

    p95 = statistics.quantiles(times, n=20)[18]
    assert p95 < 10.0, f"P95 = {p95:.2f}ms (esperado < 10ms)"
```

#### 2.8.2 Tests de Integración SQL
```python
# tests/integration/test_permisos_sql_views.py
def test_vista_capacidades_usuario_accuracy():
    """Verifica que vista SQL retorna mismo resultado que ORM"""
    # Resultado ORM
    caps_orm = set(UserManagementService.obtener_capacidades_de_usuario(user_id))

    # Resultado SQL
    with connection.cursor() as cursor:
        cursor.execute("SELECT obtener_capacidades_usuario(%s)", [user_id])
        caps_sql = set(cursor.fetchone()[0])

    assert caps_orm == caps_sql
```

#### 2.8.3 Tests de Carga
```python
# tests/load/test_permisos_load.py
import locust

class PermisoLoadTest(locust.HttpUser):
    @task
    def verificar_permiso(self):
        self.client.get(f"/api/permisos/verificar/{user_id}/tiene-permiso/?capacidad=X")
```

**Archivos esperados**:
- `tests/performance/test_permisos_performance.py` (200 líneas)
- `tests/integration/test_permisos_sql_views.py` (300 líneas)
- `tests/load/test_permisos_load.py` (150 líneas)

**Prioridad**: MEDIA
**Estimación**: 1 día
**Responsable**: equipo-qa

---

### 2.9 Django Admin Integration (MEDIA)
**Gap**: Faltan interfaces de Django Admin para gestión visual

**Lo que falta**:
```python
# admin.py
@admin.register(GrupoPermiso)
class GrupoPermisoAdmin(admin.ModelAdmin):
    list_display = ['codigo', 'nombre', 'categoria', 'nivel_riesgo', 'activo']
    list_filter = ['categoria', 'nivel_riesgo', 'activo']
    search_fields = ['codigo', 'nombre']
    filter_horizontal = ['capacidades']
```

**Archivo esperado**: `api/callcentersite/callcentersite/apps/users/admin_permisos.py` (200 líneas)

**Prioridad**: MEDIA
**Estimación**: 0.5 días
**Responsable**: equipo-backend

---

### 2.10 Monitoring y Métricas (BAJA)
**Gap**: Falta integración con sistema de monitoreo

**Lo que falta**:
- Métricas de Prometheus:
  - `permisos_verificaciones_total{capacidad, resultado}`
  - `permisos_verificacion_duration_seconds{percentile}`
  - `permisos_asignaciones_total{grupo, usuario}`
- Dashboard de Grafana con:
  - Gráfica de verificaciones/segundo
  - P50/P95/P99 de latencia
  - Top 10 capacidades más verificadas
  - Alertas cuando p95 > 50ms

**Archivos esperados**:
- `monitoring/prometheus/permisos_metrics.py` (100 líneas)
- `monitoring/grafana/permisos_dashboard.json` (500 líneas)

**Prioridad**: BAJA
**Estimación**: 1 día
**Responsable**: equipo-devops

---

## 3. Resumen de Prioridades

| Gap | Prioridad | Estimación | Bloqueante | Responsable |
|-----|-----------|------------|------------|-------------|
| 2.1 Casos de Uso | CRÍTICO | 2 días | NO | backend + BA |
| 2.2 Diagramas UML | CRÍTICO | 1.5 días | NO | arquitecto |
| 2.3 OpenAPI Spec | ALTA | 1 día | NO | backend |
| 2.4 Decorators | ALTA | 0.5 días | NO | backend |
| 2.5 Management Commands | MEDIA | 1 día | NO | backend |
| 2.6 Seed Script | ALTA | 0.5 días | SÍ | backend |
| 2.7 Docs Frontend | ALTA | 1 día | SÍ | frontend + backend |
| 2.8 Tests Adicionales | MEDIA | 1 día | NO | qa |
| 2.9 Django Admin | MEDIA | 0.5 días | NO | backend |
| 2.10 Monitoring | BAJA | 1 día | NO | devops |

**Total estimado**: 10.5 días persona

---

## 4. Plan de Acción Recomendado

### Sprint 1 (Semana 1) - BLOCKERS + CRÍTICO
**Objetivo**: Completar bloqueantes y elementos críticos

1. **Día 1-2**: GAP 2.6 Seed Script (BLOCKER)
   - Crear script de inicialización
   - Datos base: 15 funciones, 50 capacidades, 8 grupos
   - Testing en ambiente dev

2. **Día 3**: GAP 2.7 Docs Frontend (BLOCKER)
   - Guía de integración completa
   - Cliente TypeScript
   - Hooks de React
   - Componente PermissionGate

3. **Día 4-5**: GAP 2.1 Casos de Uso (CRÍTICO)
   - Completar 10 casos de uso
   - Formato estandarizado UML 2.5
   - Trazabilidad completa

### Sprint 2 (Semana 2) - ALTA PRIORIDAD
**Objetivo**: Completar documentación y herramientas

4. **Día 6-7**: GAP 2.2 Diagramas UML (CRÍTICO)
   - Diagrama ER
   - 10 diagramas de casos de uso
   - 10 diagramas de secuencia
   - 10 diagramas de actividad
   - Diagrama de arquitectura
   - Diagrama de componentes

5. **Día 8**: GAP 2.3 OpenAPI Spec (ALTA)
   - Especificación OpenAPI 3.0
   - Swagger UI deployment
   - Generación de clientes

6. **Día 9**: GAP 2.4 Decorators + 2.5 Management Commands (ALTA + MEDIA)
   - Decorators @require_permission
   - Middleware de auditoría
   - 5 management commands

### Sprint 3 (Semana 3) - MEDIA/BAJA PRIORIDAD
**Objetivo**: Pulir y optimizar

7. **Día 10**: GAP 2.8 Tests Adicionales + 2.9 Django Admin (MEDIA)
   - Tests de performance
   - Tests de integración SQL
   - Django Admin interfaces

8. **Día 11**: GAP 2.10 Monitoring (BAJA)
   - Métricas Prometheus
   - Dashboard Grafana
   - Alertas

---

## 5. Criterios de Completitud

El Sistema de Permisos Granular se considera 100% completo cuando:

### Implementación
- [OK] Modelos de base de datos creados y migrados
- [OK] Vistas SQL optimizadas funcionando
- [OK] Funciones SQL nativas operativas
- [OK] Service layer con lógica de negocio
- [OK] REST API completa con serializers y viewsets
- [OK] URLs configuradas y enrutamiento correcto

### Calidad
- [OK] 50+ tests unitarios pasando
- [PENDING] Tests de integración SQL pasando
- [PENDING] Tests de performance validando SLA
- [PENDING] Tests de carga confirmando escalabilidad

### Documentación
- [OK] ADR documentando decisión de arquitectura
- [OK] Documentación técnica de arquitectura
- [PARTIAL] Casos de uso completos (1/10)
- [PENDING] Diagramas UML (0/32)
- [PENDING] OpenAPI spec (0/1)
- [PENDING] Guía de integración frontend (0/1)

### Herramientas
- [PENDING] Seed script funcional
- [PENDING] Management commands operativos
- [PENDING] Decorators y middleware deployados
- [PENDING] Django Admin configurado

### Operaciones
- [PENDING] Monitoring y métricas activas
- [PENDING] Dashboards de Grafana desplegados
- [PENDING] Alertas configuradas
- [PENDING] Runbook de troubleshooting

---

## 6. Métricas de Completitud

| Categoría | Completitud | Tareas | Pendientes |
|-----------|-------------|--------|------------|
| Implementación | 100% | 6/6 | 0 |
| Calidad | 80% | 4/5 | 1 |
| Documentación | 40% | 2/5 | 3 |
| Herramientas | 0% | 0/4 | 4 |
| Operaciones | 0% | 0/4 | 4 |
| **TOTAL** | **75%** | **12/16** | **4** |

---

## 7. Riesgos Identificados

### 7.1 Riesgo: Falta de documentación dificulta onboarding
**Severidad**: MEDIA
**Mitigación**: Priorizar casos de uso y diagramas (Sprint 1-2)

### 7.2 Riesgo: Frontend no puede integrar sin guía
**Severidad**: ALTA
**Mitigación**: Crear docs de integración ASAP (Día 3)

### 7.3 Riesgo: Testing en nuevos ambientes requiere seed manual
**Severidad**: MEDIA
**Mitigación**: Crear seed script (Día 1-2)

### 7.4 Riesgo: Sin monitoring, problemas de performance no detectados
**Severidad**: BAJA
**Mitigación**: Implementar monitoring (Sprint 3)

---

## 8. Conclusiones

### Lo que está BIEN
- La implementación técnica es sólida (100%)
- El diseño híbrido ORM+SQL es correcto
- La arquitectura escala bien
- Los tests básicos cubren casos importantes

### Lo que FALTA
- Documentación de casos de uso y diagramas
- Herramientas de gestión (seed, commands)
- Integración con frontend documentada
- Monitoring y observabilidad

### Próximos Pasos Inmediatos
1. Crear seed script (BLOCKER)
2. Documentar integración frontend (BLOCKER)
3. Completar casos de uso (CRÍTICO)
4. Generar diagramas UML (CRÍTICO)

---

**Fecha de análisis**: 2025-11-09
**Analista**: Claude (IA Agent)
**Próxima revisión**: 2025-11-16 (1 semana)
