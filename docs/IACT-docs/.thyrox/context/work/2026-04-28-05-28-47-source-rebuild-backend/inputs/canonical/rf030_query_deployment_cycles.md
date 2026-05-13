---
id: RF-030
tipo: requisito_funcional
titulo: Query Deployment Cycles Dataset
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

# RF-030: Query Deployment Cycles Dataset

## 1. Descripción

El sistema DEBE proporcionar un endpoint para consultar deployment cycles agregados, agrupando métricas por cycle_id y calculando duración total, conteo de fases, y estado de fallo.

Datos agregados por ciclo:
```
- cycle_id: Identificador único del ciclo
- feature_id: Feature asociado
- start_time, end_time: Timestamps de inicio y fin
- total_duration_hours: Duración total en horas
- phases_count: Número de fases ejecutadas
- failed: Boolean indicando si el deployment falló
```

Filtros:
```
- days: Período de tiempo (default: 30)
- failed_only: Solo deployments fallidos (default: false)
```

## 2. Endpoint API

```
GET /api/dora/data-catalog/deployment-cycles/
Query params:
 ?days=30
 &failed_only=false

Response 200:
{
 "query": {
 "days": 30,
 "failed_only": false,
 "executed_at": "2025-11-11T14:30:00Z"
 },
 "metadata": {
 "total_cycles": 45,
 "failed_cycles": 3
 },
 "data": [
 {
 "cycle_id": "cycle-2025-045",
 "feature_id": "FEAT-123",
 "start_time": "2025-11-11T10:00:00Z",
 "end_time": "2025-11-11T12:00:00Z",
 "total_duration_hours": 2.0,
 "phases_count": 4,
 "failed": false
 }
 ]
}
```

## 3. Implementación

```python
@staticmethod
def query_deployment_cycles(
 days: int = 30,
 failed_only: bool = False
) -> Dict[str, Any]:
 """Query deployment cycles aggregated by cycle_id."""
 start_date = timezone.now() - timedelta(days=days)

 # Get all deployment metrics in period
 deployments = DORAMetric.objects.filter(
 phase_name='deployment',
 created_at__gte=start_date
 )

 # Group by cycle_id
 cycles = {}
 for metric in deployments:
 cycle_id = metric.cycle_id

 if cycle_id not in cycles:
 # Get all phases for this cycle
 cycle_metrics = DORAMetric.objects.filter(cycle_id=cycle_id)

 # Detect failure: has incident phase OR rollback decision
 has_incident = cycle_metrics.filter(phase_name='incident').exists()
 has_rollback = cycle_metrics.filter(decision='rollback').exists()
 failed = has_incident or has_rollback

 # Skip non-failed if failed_only filter active
 if failed_only and not failed:
 continue

 # Calculate total duration
 first_metric = cycle_metrics.order_by('created_at').first()
 last_metric = cycle_metrics.order_by('-created_at').first()

 if first_metric and last_metric:
 duration = (last_metric.created_at - first_metric.created_at).total_seconds() / 3600
 else:
 duration = 0

 cycles[cycle_id] = {
 "cycle_id": cycle_id,
 "feature_id": metric.feature_id,
 "start_time": first_metric.created_at.isoformat() if first_metric else None,
 "end_time": last_metric.created_at.isoformat() if last_metric else None,
 "total_duration_hours": round(duration, 2),
 "phases_count": cycle_metrics.count(),
 "failed": failed
 }

 return {
 "query": {
 "days": days,
 "failed_only": failed_only,
 "executed_at": timezone.now().isoformat()
 },
 "metadata": {
 "total_cycles": len(cycles),
 "failed_cycles": sum(1 for c in cycles.values() if c['failed'])
 },
 "data": list(cycles.values())
 }
```

## 4. Tests

```python
def test_query_deployment_cycles(self):
 """Test deployment cycles aggregation."""
 # Create cycle with 3 phases
 DORAMetric.objects.create(cycle_id='C-1', feature_id='F-1', phase_name='development', decision='approved', duration_seconds=7200)
 DORAMetric.objects.create(cycle_id='C-1', feature_id='F-1', phase_name='testing', decision='approved', duration_seconds=3600)
 DORAMetric.objects.create(cycle_id='C-1', feature_id='F-1', phase_name='deployment', decision='approved', duration_seconds=1800)

 response = self.client.get('/api/dora/data-catalog/deployment-cycles/')
 data = response.json()

 self.assertEqual(data['metadata']['total_cycles'], 1)
 cycle = data['data'][0]
 self.assertEqual(cycle['cycle_id'], 'C-1')
 self.assertEqual(cycle['phases_count'], 3)
 self.assertFalse(cycle['failed'])

def test_query_failed_deployments_only(self):
 """Test filtering only failed deployments."""
 # Successful cycle
 DORAMetric.objects.create(cycle_id='C-1', phase_name='deployment', decision='approved', duration_seconds=1200)
 # Failed cycle (has incident)
 DORAMetric.objects.create(cycle_id='C-2', phase_name='deployment', decision='approved', duration_seconds=1200)
 DORAMetric.objects.create(cycle_id='C-2', phase_name='incident', decision='resolved', duration_seconds=600)

 response = self.client.get('/api/dora/data-catalog/deployment-cycles/?failed_only=true')
 data = response.json()

 self.assertEqual(data['metadata']['total_cycles'], 1)
 self.assertEqual(data['metadata']['failed_cycles'], 1)
 self.assertTrue(data['data'][0]['failed'])
```

## 5. Trazabilidad

- Origen: N-004, RN-004, RF-028
- Implementado: api/callcentersite/dora_metrics/data_catalog.py:DataQueryEngine.query_deployment_cycles
- Tests: tests/dora_metrics/test_deployment_cycles.py
