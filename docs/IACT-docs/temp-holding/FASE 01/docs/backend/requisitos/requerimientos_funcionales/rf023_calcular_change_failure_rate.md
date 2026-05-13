---
id: RF-023
tipo: requisito_funcional
titulo: Calcular Change Failure Rate (CFR)
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

# RF-023: Calcular Change Failure Rate (CFR)

## 1. Descripción

El sistema DEBE calcular Change Failure Rate: porcentaje de deployments que resultan en fallo o requieren rollback.

Fórmula:
```
CFR = (COUNT(deployments WHERE decision='no-go') / COUNT(all deployments)) * 100
```

Clasificación DORA:
- Elite: 0-15%
- High: 16-30%
- Medium: 31-45%
- Low: 46-60%

## 2. Auto-CoT con Self-Consistency

<thinking>
Path 1: Contar deployments fallidos
- phase_name = 'deployment'
- decision = 'no-go'

Path 2: Contar total de deployments
- phase_name = 'deployment'
- decision IN ('go', 'no-go')

Path 3: Calcular ratio
- CFR = (fallidos / total) * 100

Validación Self-Consistency:
- Todos los paths deben usar mismo período
- Total deployments >= Deployments fallidos
- CFR debe estar entre 0 y 100
</thinking>

## 3. Endpoint API

```
GET /api/dora-metrics/change-failure-rate
Query params:
 ?start_date=2025-10-01
 &end_date=2025-10-31

Response 200:
{
 "metric": "change_failure_rate",
 "period": {
 "start": "2025-10-01",
 "end": "2025-10-31"
 },
 "deployments": {
 "total": 45,
 "successful": 42,
 "failed": 3
 },
 "cfr": {
 "percentage": 6.67,
 "classification": "Elite"
 },
 "failure_reasons": {
 "test_failures": 1,
 "integration_errors": 1,
 "rollback_required": 1
 },
 "trend": {
 "last_7_days": 5.0,
 "last_30_days": 6.67,
 "direction": "stable"
 }
}
```

## 4. Implementación con Validación

```python
def calculate_change_failure_rate(start_date, end_date):
 # Path 1: Count failed deployments
 failed_deployments = DORAMetric.objects.filter(
 phase_name='deployment',
 decision='no-go',
 created_at__gte=start_date,
 created_at__lte=end_date
 ).count()

 # Path 2: Count successful deployments
 successful_deployments = DORAMetric.objects.filter(
 phase_name='deployment',
 decision='go',
 created_at__gte=start_date,
 created_at__lte=end_date
 ).count()

 # Path 3: Calculate total and CFR
 total_deployments = failed_deployments + successful_deployments

 # Self-Consistency validation
 assert failed_deployments <= total_deployments, "Failed cannot exceed total"
 assert failed_deployments >= 0, "Failed must be non-negative"
 assert total_deployments >= 0, "Total must be non-negative"

 if total_deployments == 0:
 cfr_percentage = 0.0
 classification = "N/A"
 else:
 cfr_percentage = (failed_deployments / total_deployments) * 100

 # Classify according to DORA
 if cfr_percentage <= 15:
 classification = "Elite"
 elif cfr_percentage <= 30:
 classification = "High"
 elif cfr_percentage <= 45:
 classification = "Medium"
 else:
 classification = "Low"

 # Final validation
 assert 0 <= cfr_percentage <= 100, "CFR must be between 0 and 100"

 return {
 'total_deployments': total_deployments,
 'successful_deployments': successful_deployments,
 'failed_deployments': failed_deployments,
 'cfr_percentage': cfr_percentage,
 'classification': classification
 }
```

## 5. Tests con Edge Cases

```python
def test_cfr_elite_classification():
 """Test Elite classification (0-15% failure rate)."""
 # Create 100 deployments, 10 failed (10% CFR)
 for i in range(90):
 DORAMetric.objects.create(
 cycle_id=f'C-{i}',
 phase_name='deployment',
 decision='go',
 duration_seconds=600
 )

 for i in range(10):
 DORAMetric.objects.create(
 cycle_id=f'C-FAIL-{i}',
 phase_name='deployment',
 decision='no-go',
 duration_seconds=300
 )

 result = calculate_change_failure_rate(date.today(), date.today())

 assert result['total_deployments'] == 100
 assert result['failed_deployments'] == 10
 assert result['cfr_percentage'] == 10.0
 assert result['classification'] == 'Elite'

def test_cfr_no_deployments():
 """Test CFR when no deployments exist (edge case)."""
 result = calculate_change_failure_rate(
 date(2025, 1, 1),
 date(2025, 1, 1)
 )

 assert result['total_deployments'] == 0
 assert result['cfr_percentage'] == 0.0
 assert result['classification'] == 'N/A'

def test_cfr_all_failed():
 """Test CFR when all deployments failed (worst case)."""
 for i in range(10):
 DORAMetric.objects.create(
 cycle_id=f'C-FAIL-{i}',
 phase_name='deployment',
 decision='no-go',
 duration_seconds=300
 )

 result = calculate_change_failure_rate(date.today(), date.today())

 assert result['cfr_percentage'] == 100.0
 assert result['classification'] == 'Low'
```

## 6. Anti-Alucinación

**Verificado contra DORA Research:**
- Elite: 0-15% (NO 0-10%)
- High: 16-30% (NO 10-20%)
- Fuente: https://dora.dev/guides/dora-metrics-four-keys/

**Self-Consistency checks:**
- Failed <= Total (siempre)
- 0 <= CFR <= 100 (siempre)
- Classification matches percentage range

## 7. Trazabilidad

- Origen: N-004, RN-004, RF-020
- Implementado: api/callcentersite/dora_metrics/views.py:change_failure_rate_chart_data
- Tests: tests/dora_metrics/test_change_failure_rate.py
