---
id: RF-020
tipo: requisito_funcional
titulo: Registrar ciclos de desarrollo con fases DORA
dominio: backend
owner: equipo-ingenieria
prioridad: critica
estado: implementado
fecha_creacion: 2025-11-11
trazabilidad_upward:
 - N-004 # Metricas DORA para performance ciclo desarrollo
 - RN-004 # Sistema metricas DORA performance ingenieria
verificacion: test
date: 2025-11-13
---

# RF-020: Registrar ciclos de desarrollo con fases DORA

## 1. Descripción del Requisito

El sistema DEBE permitir registrar ciclos completos de desarrollo de software, capturando información de cada fase del ciclo de vida (planning, testing, deployment, maintenance) con sus tiempos de duración, decisiones tomadas, y metadata relevante.

## 2. Justificación

Para calcular las métricas DORA (Deployment Frequency, Lead Time, CFR, MTTR), el sistema necesita datos históricos de ciclos de desarrollo completos. Cada ciclo debe registrar:

- **cycle_id**: Identificador único del ciclo
- **feature_id**: Feature o issue siendo desarrollada
- **phase_name**: Fase del ciclo (planning, testing, deployment, maintenance)
- **decision**: Decisión tomada (go, no-go, review, blocked)
- **duration_seconds**: Duración de la fase en segundos
- **metadata**: Información adicional (developer, branch, commit_sha, etc.)
- **created_at**: Timestamp de creación

Estos datos permiten calcular:
- **Deployment Frequency**: Contar deployments exitosos por período
- **Lead Time**: Suma de duraciones desde planning hasta deployment
- **Change Failure Rate**: Ratio deployments con decision=no-go vs total
- **MTTR**: Duración promedio de fase maintenance

## 3. Criterios de Aceptación

### 3.1 Funcionales

1. **Registro de ciclo:**
 - DADO un nuevo ciclo de desarrollo
 - CUANDO se registra con cycle_id, feature_id, phase_name, decision, duration_seconds
 - ENTONCES el sistema almacena el ciclo en tabla `dora_metrics`
 - Y retorna código HTTP 201 Created

2. **Validaciones:**
 - cycle_id DEBE ser único (constraint en DB)
 - phase_name DEBE ser uno de: planning, testing, deployment, maintenance
 - decision DEBE ser uno de: go, no-go, review, blocked
 - duration_seconds DEBE ser >= 0
 - feature_id DEBE ser no vacío

3. **Metadata opcional:**
 - metadata puede contener campos JSON arbitrarios
 - Campos recomendados: developer, branch, commit_sha, tags, notes
 - Sin metadata, se almacena objeto JSON vacío

4. **Timestamps automáticos:**
 - created_at se genera automáticamente con timestamp actual
 - Timezone: UTC

### 3.2 No Funcionales

1. **Performance:**
 - Registro de ciclo completa en <100ms (P95)
 - Soporte para 100+ ciclos concurrentes

2. **Persistencia:**
 - Datos almacenados en PostgreSQL (tabla dora_metrics)
 - Retention: 3 años (configurable)

3. **Idempotencia:**
 - Registrar mismo cycle_id múltiples veces retorna 409 Conflict
 - No se permite actualizar ciclos existentes (immutable)

## 4. Especificación Técnica

### 4.1 Endpoint API

```
POST /api/dora-metrics/cycles/
```

**Request Body:**
```json
{
 "cycle_id": "CYCLE-2025-1111-001",
 "feature_id": "FEAT-123",
 "phase_name": "testing",
 "decision": "go",
 "duration_seconds": 1800.5,
 "metadata": {
 "developer": "john.doe",
 "branch": "feature/authentication",
 "commit_sha": "a1b2c3d4",
 "tags": ["security", "authentication"],
 "notes": "All tests passed"
 }
}
```

**Response 201 Created:**
```json
{
 "id": 12345,
 "cycle_id": "CYCLE-2025-1111-001",
 "feature_id": "FEAT-123",
 "phase_name": "testing",
 "decision": "go",
 "duration_seconds": 1800.5,
 "metadata": {
 "developer": "john.doe",
 "branch": "feature/authentication",
 "commit_sha": "a1b2c3d4",
 "tags": ["security", "authentication"],
 "notes": "All tests passed"
 },
 "created_at": "2025-11-11T15:30:00Z"
}
```

**Response 400 Bad Request:**
```json
{
 "error": "validation_error",
 "detail": {
 "phase_name": ["Must be one of: planning, testing, deployment, maintenance"],
 "duration_seconds": ["Must be >= 0"]
 }
}
```

**Response 409 Conflict:**
```json
{
 "error": "duplicate_cycle",
 "detail": "Cycle with cycle_id=CYCLE-2025-1111-001 already exists"
}
```

### 4.2 Modelo de Datos

```python
# api/callcentersite/dora_metrics/models.py
class DORAMetric(models.Model):
 cycle_id = models.CharField(max_length=50, unique=True)
 feature_id = models.CharField(max_length=50)
 phase_name = models.CharField(max_length=50) # planning, testing, deployment, maintenance
 decision = models.CharField(max_length=20) # go, no-go, review, blocked
 duration_seconds = models.DecimalField(max_digits=10, decimal_places=2)
 metadata = models.JSONField(default=dict)
 created_at = models.DateTimeField(default=timezone.now)

 class Meta:
 db_table = "dora_metrics"
 ordering = ["-created_at"]
 indexes = [
 models.Index(fields=["phase_name"]),
 models.Index(fields=["feature_id"]),
 models.Index(fields=["created_at"]),
 ]
```

### 4.3 Serializer

```python
# api/callcentersite/dora_metrics/serializers.py
class DORAMetricSerializer(serializers.ModelSerializer):
 class Meta:
 model = DORAMetric
 fields = ['id', 'cycle_id', 'feature_id', 'phase_name', 'decision',
 'duration_seconds', 'metadata', 'created_at']
 read_only_fields = ['id', 'created_at']

 def validate_phase_name(self, value):
 valid_phases = ['planning', 'testing', 'deployment', 'maintenance']
 if value not in valid_phases:
 raise serializers.ValidationError(
 f"Must be one of: {', '.join(valid_phases)}"
 )
 return value

 def validate_decision(self, value):
 valid_decisions = ['go', 'no-go', 'review', 'blocked']
 if value not in valid_decisions:
 raise serializers.ValidationError(
 f"Must be one of: {', '.join(valid_decisions)}"
 )
 return value

 def validate_duration_seconds(self, value):
 if value < 0:
 raise serializers.ValidationError("Must be >= 0")
 return value
```

### 4.4 View

```python
# api/callcentersite/dora_metrics/views.py
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def dora_metrics_create(request):
 """Register a new DORA metric cycle."""
 serializer = DORAMetricSerializer(data=request.data)

 if serializer.is_valid():
 try:
 serializer.save()
 return Response(serializer.data, status=status.HTTP_201_CREATED)
 except IntegrityError:
 return Response({
 'error': 'duplicate_cycle',
 'detail': f"Cycle with cycle_id={request.data.get('cycle_id')} already exists"
 }, status=status.HTTP_409_CONFLICT)

 return Response({
 'error': 'validation_error',
 'detail': serializer.errors
 }, status=status.HTTP_400_BAD_REQUEST)
```

## 5. Ejemplos de Uso

### 5.1 Registrar Fase Planning

```bash
curl -X POST https://api.iact.example.com/api/dora-metrics/cycles/ \
 -H "Authorization: Bearer $TOKEN" \
 -H "Content-Type: application/json" \
 -d '{
 "cycle_id": "CYCLE-2025-1111-001",
 "feature_id": "FEAT-123",
 "phase_name": "planning",
 "decision": "go",
 "duration_seconds": 7200,
 "metadata": {
 "developer": "jane.smith",
 "epic": "EP-45",
 "story_points": 8
 }
 }'
```

### 5.2 Registrar Fase Testing

```bash
curl -X POST https://api.iact.example.com/api/dora-metrics/cycles/ \
 -H "Authorization: Bearer $TOKEN" \
 -H "Content-Type: application/json" \
 -d '{
 "cycle_id": "CYCLE-2025-1111-002",
 "feature_id": "FEAT-123",
 "phase_name": "testing",
 "decision": "go",
 "duration_seconds": 1800,
 "metadata": {
 "developer": "jane.smith",
 "test_coverage": 95.2,
 "tests_passed": 47,
 "tests_failed": 0
 }
 }'
```

### 5.3 Registrar Fase Deployment

```bash
curl -X POST https://api.iact.example.com/api/dora-metrics/cycles/ \
 -H "Authorization: Bearer $TOKEN" \
 -H "Content-Type: application/json" \
 -d '{
 "cycle_id": "CYCLE-2025-1111-003",
 "feature_id": "FEAT-123",
 "phase_name": "deployment",
 "decision": "go",
 "duration_seconds": 600,
 "metadata": {
 "developer": "jane.smith",
 "commit_sha": "a1b2c3d4e5f6",
 "branch": "feature/authentication",
 "environment": "production",
 "deployment_time": "2025-11-11T15:30:00Z"
 }
 }'
```

### 5.4 Registrar Fase Maintenance (Incident)

```bash
curl -X POST https://api.iact.example.com/api/dora-metrics/cycles/ \
 -H "Authorization: Bearer $TOKEN" \
 -H "Content-Type: application/json" \
 -d '{
 "cycle_id": "CYCLE-2025-1111-004",
 "feature_id": "FEAT-123",
 "phase_name": "maintenance",
 "decision": "go",
 "duration_seconds": 3600,
 "metadata": {
 "developer": "john.doe",
 "incident_id": "INC-789",
 "incident_type": "performance_degradation",
 "resolution": "optimized_query"
 }
 }'
```

## 6. Casos de Prueba

### 6.1 Test: Registro Exitoso

```python
def test_create_dora_metric_success():
 """Test successful creation of DORA metric."""
 data = {
 'cycle_id': 'TEST-CYCLE-001',
 'feature_id': 'FEAT-999',
 'phase_name': 'testing',
 'decision': 'go',
 'duration_seconds': 1234.5,
 'metadata': {'developer': 'test_user'}
 }

 response = client.post('/api/dora-metrics/cycles/', data, format='json')

 assert response.status_code == 201
 assert response.data['cycle_id'] == 'TEST-CYCLE-001'
 assert response.data['phase_name'] == 'testing'
 assert 'created_at' in response.data
```

### 6.2 Test: Validación Phase Name Inválido

```python
def test_create_dora_metric_invalid_phase():
 """Test validation error for invalid phase_name."""
 data = {
 'cycle_id': 'TEST-CYCLE-002',
 'feature_id': 'FEAT-999',
 'phase_name': 'invalid_phase', # INVALID
 'decision': 'go',
 'duration_seconds': 100
 }

 response = client.post('/api/dora-metrics/cycles/', data, format='json')

 assert response.status_code == 400
 assert 'phase_name' in response.data['detail']
```

### 6.3 Test: Duplicate Cycle ID

```python
def test_create_dora_metric_duplicate_cycle():
 """Test 409 Conflict for duplicate cycle_id."""
 data = {
 'cycle_id': 'TEST-CYCLE-003',
 'feature_id': 'FEAT-999',
 'phase_name': 'testing',
 'decision': 'go',
 'duration_seconds': 100
 }

 # First creation
 response1 = client.post('/api/dora-metrics/cycles/', data, format='json')
 assert response1.status_code == 201

 # Second creation (duplicate)
 response2 = client.post('/api/dora-metrics/cycles/', data, format='json')
 assert response2.status_code == 409
 assert 'duplicate_cycle' in response2.data['error']
```

## 7. Dependencias

### 7.1 Internas

- **Authentication**: Usuario debe estar autenticado (IsAuthenticated)
- **Database**: Tabla `dora_metrics` debe existir (migration aplicada)

### 7.2 Externas

- **Ninguna**: No requiere servicios externos

## 8. Seguridad

### 8.1 Autenticación

- REQUERIDA: Token JWT válido
- Endpoint protegido con `@permission_classes([IsAuthenticated])`

### 8.2 Autorización

- Cualquier usuario autenticado puede registrar ciclos DORA
- No se requiere permiso especial (operación de escritura de métricas)

### 8.3 Validación de Entrada

- Validación de tipos de datos (CharField, DecimalField, JSONField)
- Validación de enums (phase_name, decision)
- Validación de constraints (duration >= 0)
- Protection contra SQL Injection (ORM de Django)

### 8.4 Auditabilidad

- Timestamp `created_at` automático
- Metadata puede incluir `developer` para auditoría
- Logs de aplicación registran todas las creaciones

## 9. Trazabilidad

### 9.1 Upward (Origen)

- **N-004**: Métricas DORA para mejorar performance ciclo desarrollo
- **RN-004**: Sistema métricas DORA performance ingeniería

### 9.2 Downward (Implementación)

- **Código**: `api/callcentersite/dora_metrics/models.py` (línea 9-30)
- **API View**: `api/callcentersite/dora_metrics/views.py` (función `dora_metrics_create`)
- **Tests**: `api/callcentersite/dora_metrics/tests.py`
- **ADR**: ADR_2025_003 (Integración DORA Metrics con SDLC Agents)

### 9.3 Sideward (Relacionados)

- **RF-021**: Calcular Deployment Frequency (usa datos de RF-020)
- **RF-022**: Calcular Lead Time (usa datos de RF-020)
- **RF-023**: Calcular Change Failure Rate (usa datos de RF-020)
- **RF-024**: Calcular MTTR (usa datos de RF-020)

## 10. Referencias

- **ADR_2025_003**: Integración DORA Metrics con SDLC Agents
- **DORA Research**: https://dora.dev/
- **Código implementado**: api/callcentersite/dora_metrics/
- **Django Models**: https://docs.djangoproject.com/en/4.2/topics/db/models/
- **Django REST Framework**: https://www.django-rest-framework.org/

## 11. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0 | 2025-11-11 | Requirements Analysis | Creación inicial - Documentación para código existente |

---

**Estado**: Implementado
**Verificación**: Tests unitarios en `tests/dora_metrics/test_create.py`
**Owner**: equipo-ingenieria
