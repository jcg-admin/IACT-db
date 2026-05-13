---
id: RF-031
tipo: requisito_funcional
titulo: Aggregated Statistics para AI Analysis
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

# RF-031: Aggregated Statistics para AI Analysis

## 1. Descripción

El sistema DEBE proporcionar estadísticas agregadas comprehensivas optimizadas para análisis por IA, incluyendo métricas por fase, distribuciones de decisiones, promedios de duración, y tendencias temporales.

Estadísticas incluidas:
```
- summary: Total cycles, total metrics, date range
- by_phase: Conteos y promedios por cada fase SDLC
- by_decision: Distribución de decisiones (approved, rejected, rollback, resolved)
- duration_stats: Avg, min, max, median por fase
- trends: Métricas agregadas por día/semana
```

## 2. Endpoint API

```
GET /api/dora/data-catalog/aggregated-stats/
Query params:
 ?days=30

Response 200:
{
 "query": {
 "days": 30,
 "executed_at": "2025-11-11T14:30:00Z"
 },
 "summary": {
 "total_cycles": 150,
 "total_metrics": 600,
 "date_range": {
 "start": "2025-10-12T00:00:00Z",
 "end": "2025-11-11T14:30:00Z"
 }
 },
 "by_phase": {
 "development": {
 "count": 150,
 "avg_duration_seconds": 14400,
 "success_rate": 0.95
 },
 "testing": {
 "count": 150,
 "avg_duration_seconds": 7200,
 "success_rate": 0.92
 },
 "deployment": {
 "count": 145,
 "avg_duration_seconds": 1800,
 "success_rate": 0.97
 },
 "incident": {
 "count": 5,
 "avg_duration_seconds": 3600,
 "success_rate": 1.0
 }
 },
 "by_decision": {
 "approved": 550,
 "rejected": 30,
 "rollback": 10,
 "resolved": 10
 },
 "duration_stats": {
 "development": {
 "avg": 14400,
 "min": 7200,
 "max": 28800,
 "median": 14400
 }
 },
 "dora_metrics": {
 "deployment_frequency": 4.83,
 "avg_lead_time_hours": 6.0,
 "change_failure_rate": 6.9,
 "avg_mttr_hours": 1.2
 }
}
```

## 3. Implementación

```python
@staticmethod
def get_aggregated_stats(days: int = 30) -> Dict[str, Any]:
 """Get comprehensive aggregated statistics."""
 start_date = timezone.now() - timedelta(days=days)
 metrics = DORAMetric.objects.filter(created_at__gte=start_date)

 # Summary
 total_cycles = metrics.values('cycle_id').distinct().count()
 total_metrics = metrics.count()

 # By phase
 phases = ['development', 'testing', 'deployment', 'incident', 'recovery']
 by_phase = {}

 for phase in phases:
 phase_metrics = metrics.filter(phase_name=phase)
 count = phase_metrics.count()

 if count > 0:
 avg_duration = phase_metrics.aggregate(Avg('duration_seconds'))['duration_seconds__avg']
 approved = phase_metrics.filter(decision='approved').count()
 success_rate = approved / count if count > 0 else 0

 by_phase[phase] = {
 "count": count,
 "avg_duration_seconds": round(avg_duration, 2) if avg_duration else 0,
 "success_rate": round(success_rate, 2)
 }

 # By decision
 by_decision = {}
 for decision in ['approved', 'rejected', 'rollback', 'resolved']:
 by_decision[decision] = metrics.filter(decision=decision).count()

 # DORA metrics
 deployments = metrics.filter(phase_name='deployment', decision='approved')
 deployment_count = deployments.count()
 deployment_frequency = deployment_count / days

 avg_lead_time = deployments.aggregate(Avg('duration_seconds'))['duration_seconds__avg'] or 0
 avg_lead_time_hours = avg_lead_time / 3600

 testing = metrics.filter(phase_name='testing')
 failed_tests = testing.filter(decision='rejected').count()
 total_tests = testing.count()
 cfr = (failed_tests / total_tests * 100) if total_tests > 0 else 0

 incidents = metrics.filter(phase_name='incident', decision='resolved')
 avg_mttr = incidents.aggregate(Avg('duration_seconds'))['duration_seconds__avg'] or 0
 avg_mttr_hours = avg_mttr / 3600

 return {
 "query": {
 "days": days,
 "executed_at": timezone.now().isoformat()
 },
 "summary": {
 "total_cycles": total_cycles,
 "total_metrics": total_metrics,
 "date_range": {
 "start": start_date.isoformat(),
 "end": timezone.now().isoformat()
 }
 },
 "by_phase": by_phase,
 "by_decision": by_decision,
 "dora_metrics": {
 "deployment_frequency": round(deployment_frequency, 2),
 "avg_lead_time_hours": round(avg_lead_time_hours, 2),
 "change_failure_rate": round(cfr, 2),
 "avg_mttr_hours": round(avg_mttr_hours, 2)
 }
 }
```

## 4. Tests

```python
def test_aggregated_stats(self):
 """Test comprehensive aggregated statistics."""
 # Create test data across phases
 DORAMetric.objects.create(cycle_id='C-1', phase_name='development', decision='approved', duration_seconds=14400)
 DORAMetric.objects.create(cycle_id='C-1', phase_name='testing', decision='approved', duration_seconds=7200)
 DORAMetric.objects.create(cycle_id='C-1', phase_name='deployment', decision='approved', duration_seconds=1800)

 response = self.client.get('/api/dora/data-catalog/aggregated-stats/')
 data = response.json()

 self.assertEqual(data['summary']['total_cycles'], 1)
 self.assertEqual(data['summary']['total_metrics'], 3)
 self.assertIn('development', data['by_phase'])
 self.assertIn('testing', data['by_phase'])
 self.assertIn('deployment', data['by_phase'])
```

## 5. Trazabilidad

- Origen: N-004, RN-004, RF-028
- Implementado: api/callcentersite/dora_metrics/data_catalog.py:DataQueryEngine.get_aggregated_stats
- Tests: tests/dora_metrics/test_aggregated_stats.py
