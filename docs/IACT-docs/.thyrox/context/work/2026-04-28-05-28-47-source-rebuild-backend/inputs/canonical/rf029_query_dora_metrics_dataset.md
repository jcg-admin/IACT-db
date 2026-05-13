---
id: RF-029
tipo: requisito_funcional
titulo: Query DORA Metrics Dataset con Filtros
dominio: backend
owner: equipo-ingenieria
prioridad: alta
estado: implementado
fecha_creacion: 2025-11-11
trazabilidad_upward:
 - N-004
 - RN-004
 - RF-020
 - RF-028
dora_capability: "6. AI-accessible Internal Data (DORA 2025)"
verificacion: test
date: 2025-11-13
---

# RF-029: Query DORA Metrics Dataset con Filtros

## 1. Descripción

El sistema DEBE proporcionar un endpoint de query para acceder al dataset de DORA metrics con filtros por período (days), fase (phase_name), y feature (feature_id), retornando datos estructurados optimizados para análisis por IA.

Filtros disponibles:
```
- days: Número de días hacia atrás (default: 30, max: 365)
- phase_name: Filter por fase SDLC (development, testing, deployment, incident, recovery)
- feature_id: Filter por feature específico
```

Response incluye:
```
- query: Parámetros ejecutados y timestamp
- metadata: total_records, date_range
- data: Array de métricas en formato JSON
```

## 2. Auto-CoT

<thinking>
Path 1: Build query con filtros opcionales
- Base query: created_at >= cutoff_date
- Si phase_name: añadir filter phase_name=value
- Si feature_id: añadir filter feature_id=value
- Combinar con Q objects (Django ORM)

Path 2: Execute query y serialize
- Order by created_at DESC (más recientes primero)
- Select fields relevantes (no password, no internal IDs)
- Convert datetime to ISO8601 para JSON

Path 3: Return structured response
- Include query params (for reproducibility)
- Include metadata (record count, date range)
- Include data array

Self-Consistency:
- metadata.total_records == len(data)
- All timestamps in ISO8601 format
- date_range.start <= all record timestamps <= date_range.end
</thinking>

## 3. Endpoint API

```
GET /api/dora/data-catalog/dora-metrics/
Query params:
 ?days=30 # Optional, default 30
 &phase_name=deployment # Optional
 &feature_id=FEAT-123 # Optional

Response 200:
{
 "query": {
 "days": 30,
 "phase_name": "deployment",
 "feature_id": null,
 "executed_at": "2025-11-11T14:30:00Z"
 },
 "metadata": {
 "total_records": 45,
 "date_range": {
 "start": "2025-10-12T00:00:00Z",
 "end": "2025-11-11T14:30:00Z"
 }
 },
 "data": [
 {
 "cycle_id": "cycle-2025-045",
 "feature_id": "FEAT-123",
 "phase_name": "deployment",
 "decision": "approved",
 "duration_seconds": 1200.5,
 "created_at": "2025-11-11T12:00:00Z"
 },
 // ... more records
 ]
}
```

## 4. Implementación

```python
from datetime import timedelta
from typing import Dict, Any, Optional
from django.utils import timezone
from django.db.models import Q
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
from rest_framework.decorators import throttle_classes
from .models import DORAMetric
from .throttling import BurstRateThrottle, SustainedRateThrottle

class DataQueryEngine:
 """Query engine for AI-accessible data."""

 @staticmethod
 def query_dora_metrics(
 days: int = 30,
 phase_name: Optional[str] = None,
 feature_id: Optional[str] = None
 ) -> Dict[str, Any]:
 """
 Query DORA metrics with filters.

 Args:
 days: Number of days to query (1-365)
 phase_name: Optional filter by phase
 feature_id: Optional filter by feature

 Returns:
 Dict with metrics data and metadata
 """
 # Path 1: Build query
 start_date = timezone.now() - timedelta(days=days)

 query = Q(created_at__gte=start_date)
 if phase_name:
 query &= Q(phase_name=phase_name)
 if feature_id:
 query &= Q(feature_id=feature_id)

 # Path 2: Execute and serialize
 metrics = DORAMetric.objects.filter(query).order_by('-created_at')

 data = list(metrics.values(
 'cycle_id',
 'feature_id',
 'phase_name',
 'decision',
 'duration_seconds',
 'created_at'
 ))

 # Convert datetimes to ISO format
 for item in data:
 if 'created_at' in item:
 item['created_at'] = item['created_at'].isoformat()

 # Path 3: Build response
 response = {
 "query": {
 "days": days,
 "phase_name": phase_name,
 "feature_id": feature_id,
 "executed_at": timezone.now().isoformat()
 },
 "metadata": {
 "total_records": len(data),
 "date_range": {
 "start": start_date.isoformat(),
 "end": timezone.now().isoformat()
 }
 },
 "data": data
 }

 # Self-Consistency: Verify record count
 assert response["metadata"]["total_records"] == len(response["data"])

 return response

@require_http_methods(["GET"])
@throttle_classes([BurstRateThrottle, SustainedRateThrottle])
def data_catalog_dora_metrics(request):
 """
 GET /api/dora/data-catalog/dora-metrics/ - Query DORA metrics data.

 Query parameters:
 - days: Number of days to query (default: 30)
 - phase_name: Filter by phase (optional)
 - feature_id: Filter by feature (optional)

 Returns structured DORA metrics data for AI analysis.
 """
 days = int(request.GET.get('days', 30))
 phase_name = request.GET.get('phase_name')
 feature_id = request.GET.get('feature_id')

 # Validate days parameter
 if not 1 <= days <= 365:
 return JsonResponse(
 {"error": "days must be between 1 and 365"},
 status=400
 )

 result = DataQueryEngine.query_dora_metrics(
 days=days,
 phase_name=phase_name,
 feature_id=feature_id
 )

 return JsonResponse(result)
```

## 5. Tests

```python
def test_query_dora_metrics_no_filters(self):
 """Test querying without filters returns all recent metrics."""
 # Create test data
 for i in range(5):
 DORAMetric.objects.create(
 cycle_id=f'C-{i}',
 feature_id=f'F-{i}',
 phase_name='deployment',
 decision='approved',
 duration_seconds=1200
 )

 response = self.client.get('/api/dora/data-catalog/dora-metrics/?days=30')
 data = response.json()

 self.assertEqual(response.status_code, 200)
 self.assertEqual(data['metadata']['total_records'], 5)
 self.assertEqual(len(data['data']), 5)

def test_query_dora_metrics_with_phase_filter(self):
 """Test filtering by phase_name."""
 # Create mixed data
 DORAMetric.objects.create(cycle_id='C-1', phase_name='deployment', decision='approved', duration_seconds=1200)
 DORAMetric.objects.create(cycle_id='C-2', phase_name='testing', decision='approved', duration_seconds=600)
 DORAMetric.objects.create(cycle_id='C-3', phase_name='deployment', decision='approved', duration_seconds=1200)

 response = self.client.get('/api/dora/data-catalog/dora-metrics/?phase_name=deployment')
 data = response.json()

 self.assertEqual(data['metadata']['total_records'], 2)
 # All records should be deployment phase
 for record in data['data']:
 self.assertEqual(record['phase_name'], 'deployment')

def test_query_dora_metrics_with_feature_filter(self):
 """Test filtering by feature_id."""
 DORAMetric.objects.create(cycle_id='C-1', feature_id='FEAT-123', phase_name='deployment', decision='approved', duration_seconds=1200)
 DORAMetric.objects.create(cycle_id='C-2', feature_id='FEAT-456', phase_name='deployment', decision='approved', duration_seconds=1200)

 response = self.client.get('/api/dora/data-catalog/dora-metrics/?feature_id=FEAT-123')
 data = response.json()

 self.assertEqual(data['metadata']['total_records'], 1)
 self.assertEqual(data['data'][0]['feature_id'], 'FEAT-123')

def test_query_dora_metrics_invalid_days(self):
 """Test validation of days parameter."""
 response = self.client.get('/api/dora/data-catalog/dora-metrics/?days=1000')
 self.assertEqual(response.status_code, 400)

def test_query_dora_metrics_self_consistency(self):
 """Test metadata.total_records matches data array length."""
 DORAMetric.objects.create(cycle_id='C-1', phase_name='deployment', decision='approved', duration_seconds=1200)

 response = self.client.get('/api/dora/data-catalog/dora-metrics/')
 data = response.json()

 # Self-Consistency check
 self.assertEqual(data['metadata']['total_records'], len(data['data']))
```

## 6. Criterios de Aceptación

1. **Query sin filtros:** Retorna últimos 30 días de todas las métricas
2. **Query con phase_name:** Solo retorna métricas de esa fase
3. **Query con feature_id:** Solo retorna métricas de ese feature
4. **Query combinado:** Todos los filtros aplican simultáneamente
5. **Validación:** days debe estar en rango 1-365
6. **Throttling:** Respetar rate limits (10 req/min burst, 100 req/hour sustained)

## 7. Trazabilidad

- Origen: N-004, RN-004, RF-020, RF-028
- Implementado:
 - Class: api/callcentersite/dora_metrics/data_catalog.py:DataQueryEngine
 - View: api/callcentersite/dora_metrics/views.py:data_catalog_dora_metrics
- Tests: tests/dora_metrics/test_data_query_engine.py
