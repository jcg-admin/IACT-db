---
id: RF-022
tipo: requisito_funcional
titulo: Calcular Lead Time for Changes
dominio: backend
owner: equipo-ingenieria
prioridad: critica
estado: implementado
fecha_creacion: 2025-11-11
trazabilidad_upward:
 - N-004
 - RN-004
 - RF-020
verificacion: test
date: 2025-11-13
---

# RF-022: Calcular Lead Time for Changes

## 1. Descripción

El sistema DEBE calcular Lead Time: tiempo transcurrido desde que se inicia el desarrollo (phase=planning) hasta que se despliega (phase=deployment).

Fórmula:
```
Lead Time = SUM(duration_seconds de todas las fases del ciclo) / 3600 # en horas
```

Clasificación DORA:
- Elite: <1 hora
- High: 1 día - 1 semana
- Medium: 1 semana - 1 mes
- Low: 1 mes - 6 meses

## 2. Auto-CoT Reasoning

<thinking>
Para calcular Lead Time necesito:
1. Agrupar ciclos por feature_id
2. Ordenar fases por timestamp
3. Sumar duraciones: planning + testing + deployment
4. Convertir a horas
5. Calcular promedio para el período
6. Clasificar según benchmarks DORA

Edge cases:
- Ciclos incompletos (sin deployment): excluir
- Múltiples ciclos para mismo feature: considerar último
- Fases fuera de orden: ordenar por timestamp
</thinking>

## 3. Endpoint API

```
GET /api/dora-metrics/lead-time
Query params:
 ?start_date=2025-10-01
 &end_date=2025-10-31

Response 200:
{
 "metric": "lead_time",
 "period": {
 "start": "2025-10-01",
 "end": "2025-10-31"
 },
 "lead_time": {
 "average_hours": 48.5,
 "median_hours": 36.0,
 "p95_hours": 120.0,
 "min_hours": 2.5,
 "max_hours": 240.0
 },
 "classification": "High",
 "features_analyzed": 42,
 "distribution": {
 "< 1 hour": 3,
 "1-24 hours": 15,
 "1-7 days": 20,
 "7-30 days": 4
 }
}
```

## 4. Implementación con Self-Consistency

```python
def calculate_lead_time(start_date, end_date):
 # Path 1: Query all cycles for features with deployment
 features_with_deployment = DORAMetric.objects.filter(
 phase_name='deployment',
 decision='go',
 created_at__gte=start_date,
 created_at__lte=end_date
 ).values_list('feature_id', flat=True).distinct()

 lead_times = []

 for feature_id in features_with_deployment:
 # Path 2: Get all phases for this feature
 phases = DORAMetric.objects.filter(
 feature_id=feature_id,
 created_at__gte=start_date,
 created_at__lte=end_date
 ).order_by('created_at')

 # Path 3: Sum durations
 total_duration_seconds = sum(p.duration_seconds for p in phases)
 lead_time_hours = total_duration_seconds / 3600
 lead_times.append(lead_time_hours)

 # Self-Consistency: Verify all paths agree
 assert len(lead_times) == len(features_with_deployment)

 # Calculate statistics
 avg_lead_time = statistics.mean(lead_times)
 median_lead_time = statistics.median(lead_times)
 p95_lead_time = numpy.percentile(lead_times, 95)

 # Classify according to DORA
 if avg_lead_time < 1:
 classification = "Elite"
 elif avg_lead_time < 24 * 7: # 1 week
 classification = "High"
 elif avg_lead_time < 24 * 30: # 1 month
 classification = "Medium"
 else:
 classification = "Low"

 return {
 'average_hours': avg_lead_time,
 'median_hours': median_lead_time,
 'p95_hours': p95_lead_time,
 'classification': classification,
 'features_analyzed': len(lead_times)
 }
```

## 5. Tests con Self-Consistency

```python
def test_lead_time_calculation():
 # Create cycle with 3 phases
 feature_id = 'FEAT-001'

 # Planning: 2 hours
 DORAMetric.objects.create(
 cycle_id='C1', feature_id=feature_id,
 phase_name='planning', decision='go',
 duration_seconds=7200
 )

 # Testing: 1 hour
 DORAMetric.objects.create(
 cycle_id='C2', feature_id=feature_id,
 phase_name='testing', decision='go',
 duration_seconds=3600
 )

 # Deployment: 0.5 hours
 DORAMetric.objects.create(
 cycle_id='C3', feature_id=feature_id,
 phase_name='deployment', decision='go',
 duration_seconds=1800
 )

 result = calculate_lead_time(date.today(), date.today())

 # Self-Consistency: Verify calculation
 expected_hours = (7200 + 3600 + 1800) / 3600 # 3.5 hours
 assert abs(result['average_hours'] - expected_hours) < 0.01
 assert result['classification'] == 'High' # <24 hours
```

## 6. Trazabilidad

- Origen: N-004, RN-004, RF-020
- Implementado: api/callcentersite/dora_metrics/views.py:lead_time_trends_chart_data
- Tests: tests/dora_metrics/test_lead_time.py
