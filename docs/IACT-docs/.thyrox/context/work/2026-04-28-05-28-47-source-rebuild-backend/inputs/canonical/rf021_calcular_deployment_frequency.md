---
id: RF-021
tipo: requisito_funcional
titulo: Calcular Deployment Frequency (frecuencia de despliegues)
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

# RF-021: Calcular Deployment Frequency (frecuencia de despliegues)

## 1. Descripción

El sistema DEBE calcular la métrica Deployment Frequency (DF) según la definición de DORA research: número de deployments exitosos en un período de tiempo.

Fórmula:
```
Deployment Frequency = COUNT(deployments WHERE decision='go' AND phase='deployment') / period_days
```

Clasificación DORA:
- Elite: On-demand (múltiples por día)
- High: Entre 1/semana y 1/mes
- Medium: Entre 1/mes y 1/6 meses
- Low: Menos de 1/6 meses

## 2. Criterios de Aceptación

### Funcionales

1. **Calcular DF para período:**
 - DADO un período de fechas (start_date, end_date)
 - CUANDO se solicita Deployment Frequency
 - ENTONCES cuenta deployments exitosos (phase=deployment, decision=go)
 - Y divide por días del período

2. **Clasificación DORA:**
 - Retorna clasificación según benchmarks
 - Elite: DF >= 1/día
 - High: DF >= 1/semana
 - Medium: DF >= 1/mes
 - Low: DF < 1/mes

3. **Múltiples períodos:**
 - Soporta comparación de múltiples períodos
 - Retorna tendencia (mejorando/empeorando)

### No Funcionales

- Query completa en <500ms
- Soporte para hasta 10,000 registros

## 3. Endpoint API

```
GET /api/dora-metrics/deployment-frequency
Query params:
 ?start_date=2025-10-01
 &end_date=2025-10-31
 &compare_previous=true

Response 200:
{
 "metric": "deployment_frequency",
 "period": {
 "start": "2025-10-01",
 "end": "2025-10-31",
 "days": 31
 },
 "deployments": {
 "total": 45,
 "successful": 42,
 "failed": 3
 },
 "frequency": {
 "per_day": 1.35,
 "per_week": 9.5,
 "per_month": 42
 },
 "classification": "Elite",
 "previous_period": {
 "frequency": {"per_day": 0.8},
 "classification": "High"
 },
 "trend": "improving"
}
```

## 4. Implementación

```python
def calculate_deployment_frequency(start_date, end_date):
 # Auto-CoT reasoning
 # Step 1: Count successful deployments
 deployments = DORAMetric.objects.filter(
 phase_name='deployment',
 decision='go',
 created_at__gte=start_date,
 created_at__lte=end_date
 ).count()

 # Step 2: Calculate days in period
 period_days = (end_date - start_date).days + 1

 # Step 3: Calculate frequency per day
 frequency_per_day = deployments / period_days

 # Step 4: Classify according to DORA benchmarks
 if frequency_per_day >= 1:
 classification = "Elite"
 elif frequency_per_day >= 1/7: # 1 per week
 classification = "High"
 elif frequency_per_day >= 1/30: # 1 per month
 classification = "Medium"
 else:
 classification = "Low"

 return {
 'deployments': deployments,
 'period_days': period_days,
 'frequency_per_day': frequency_per_day,
 'classification': classification
 }
```

## 5. Tests

```python
def test_deployment_frequency_elite():
 # Create 35 successful deployments in 30 days
 for i in range(35):
 DORAMetric.objects.create(
 cycle_id=f'CYCLE-{i}',
 phase_name='deployment',
 decision='go',
 duration_seconds=600
 )

 result = calculate_deployment_frequency(
 start_date=date(2025, 10, 1),
 end_date=date(2025, 10, 30)
 )

 assert result['deployments'] == 35
 assert result['frequency_per_day'] > 1
 assert result['classification'] == 'Elite'
```

## 6. Trazabilidad

- Origen: N-004, RN-004, RF-020
- Implementado: api/callcentersite/dora_metrics/views.py:deployment_frequency_chart_data
- Tests: tests/dora_metrics/test_deployment_frequency.py
