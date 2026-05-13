---
id: RF-024
tipo: requisito_funcional
titulo: Calcular Mean Time to Recovery (MTTR)
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

# RF-024: Calcular Mean Time to Recovery (MTTR)

## 1. Descripción

El sistema DEBE calcular MTTR: tiempo promedio para recuperarse de un fallo en producción.

Fórmula:
```
MTTR = AVG(duration_seconds de phase='maintenance') / 3600 # en horas
```

Clasificación DORA:
- Elite: <1 hora
- High: <1 día
- Medium: 1 día - 1 semana
- Low: >1 semana

## 2. Auto-CoT con Multiple Paths

<thinking>
Path 1 (Análisis de datos):
- maintenance phase = recuperación de incidente
- duration_seconds = tiempo desde detección hasta resolución
- Necesito filtrar solo ciclos de maintenance exitosos (decision=go)

Path 2 (Cálculo estadístico):
- MTTR = promedio de duraciones
- También calcular: median, p95, min, max
- Convertir segundos a horas

Path 3 (Clasificación):
- Comparar avg_hours contra benchmarks DORA
- Determinar clasificación Elite/High/Medium/Low

Validación Self-Consistency:
- Los 3 paths deben usar mismos datos
- avg >= min y avg <= max (siempre)
- Classification coherente con avg_hours
</thinking>

## 3. Endpoint API

```
GET /api/dora-metrics/mttr
Query params:
 ?start_date=2025-10-01
 &end_date=2025-10-31

Response 200:
{
 "metric": "mean_time_to_recovery",
 "period": {
 "start": "2025-10-01",
 "end": "2025-10-31"
 },
 "mttr": {
 "average_hours": 0.75,
 "median_hours": 0.5,
 "p95_hours": 2.5,
 "min_hours": 0.1,
 "max_hours": 4.0
 },
 "classification": "Elite",
 "incidents_resolved": 15,
 "incidents_by_severity": {
 "critical": 2,
 "high": 5,
 "medium": 8
 },
 "fastest_recovery": {
 "feature_id": "INC-123",
 "duration_hours": 0.1,
 "resolution": "cache_clear"
 },
 "slowest_recovery": {
 "feature_id": "INC-456",
 "duration_hours": 4.0,
 "resolution": "database_migration"
 }
}
```

## 4. Implementación con Triple Path Validation

```python
def calculate_mttr(start_date, end_date):
 # Path 1: Get all maintenance cycles (incident recoveries)
 maintenance_cycles = DORAMetric.objects.filter(
 phase_name='maintenance',
 decision='go', # Only successful recoveries
 created_at__gte=start_date,
 created_at__lte=end_date
 )

 if not maintenance_cycles.exists():
 return {
 'average_hours': 0.0,
 'classification': 'N/A',
 'incidents_resolved': 0
 }

 # Path 2: Extract durations and convert to hours
 durations_hours = [
 cycle.duration_seconds / 3600
 for cycle in maintenance_cycles
 ]

 # Path 3: Calculate statistics
 avg_hours = statistics.mean(durations_hours)
 median_hours = statistics.median(durations_hours)
 p95_hours = numpy.percentile(durations_hours, 95)
 min_hours = min(durations_hours)
 max_hours = max(durations_hours)

 # Self-Consistency: Validate statistical coherence
 assert min_hours <= avg_hours <= max_hours, \
 f"Invalid stats: min={min_hours}, avg={avg_hours}, max={max_hours}"
 assert min_hours <= median_hours <= max_hours, \
 f"Invalid median: min={min_hours}, median={median_hours}, max={max_hours}"

 # Classify according to DORA
 if avg_hours < 1:
 classification = "Elite"
 elif avg_hours < 24:
 classification = "High"
 elif avg_hours < 24 * 7: # 1 week
 classification = "Medium"
 else:
 classification = "Low"

 # Get incident details for reporting
 fastest = maintenance_cycles.order_by('duration_seconds').first()
 slowest = maintenance_cycles.order_by('-duration_seconds').first()

 return {
 'average_hours': round(avg_hours, 2),
 'median_hours': round(median_hours, 2),
 'p95_hours': round(p95_hours, 2),
 'min_hours': round(min_hours, 2),
 'max_hours': round(max_hours, 2),
 'classification': classification,
 'incidents_resolved': len(durations_hours),
 'fastest_recovery': {
 'feature_id': fastest.feature_id,
 'duration_hours': round(fastest.duration_seconds / 3600, 2)
 },
 'slowest_recovery': {
 'feature_id': slowest.feature_id,
 'duration_hours': round(slowest.duration_seconds / 3600, 2)
 }
 }
```

## 5. Tests con Self-Consistency Validation

```python
def test_mttr_elite_classification():
 """Test Elite classification (<1 hour MTTR)."""
 # Create 10 maintenance cycles with avg 45 minutes
 durations = [1800, 2100, 2400, 2700, 3000, 3300, 1500, 1800, 2400, 3000]

 for i, duration in enumerate(durations):
 DORAMetric.objects.create(
 cycle_id=f'INC-{i}',
 feature_id=f'INC-{i}',
 phase_name='maintenance',
 decision='go',
 duration_seconds=duration
 )

 result = calculate_mttr(date.today(), date.today())

 # Verify statistics
 assert result['incidents_resolved'] == 10
 assert result['average_hours'] < 1.0 # Elite threshold
 assert result['classification'] == 'Elite'

 # Self-Consistency: min <= avg <= max
 assert result['min_hours'] <= result['average_hours'] <= result['max_hours']
 assert result['min_hours'] <= result['median_hours'] <= result['max_hours']

def test_mttr_no_incidents():
 """Test MTTR when no incidents occurred (edge case)."""
 result = calculate_mttr(
 date(2025, 1, 1),
 date(2025, 1, 31)
 )

 assert result['incidents_resolved'] == 0
 assert result['average_hours'] == 0.0
 assert result['classification'] == 'N/A'

def test_mttr_statistical_coherence():
 """Test that statistics are coherent (Self-Consistency)."""
 # Create incidents with known durations
 DORAMetric.objects.create(
 cycle_id='INC-1', feature_id='INC-1',
 phase_name='maintenance', decision='go',
 duration_seconds=3600 # 1 hour
 )
 DORAMetric.objects.create(
 cycle_id='INC-2', feature_id='INC-2',
 phase_name='maintenance', decision='go',
 duration_seconds=7200 # 2 hours
 )
 DORAMetric.objects.create(
 cycle_id='INC-3', feature_id='INC-3',
 phase_name='maintenance', decision='go',
 duration_seconds=10800 # 3 hours
 )

 result = calculate_mttr(date.today(), date.today())

 # Expected: avg = 2 hours, median = 2 hours
 assert result['average_hours'] == 2.0
 assert result['median_hours'] == 2.0
 assert result['min_hours'] == 1.0
 assert result['max_hours'] == 3.0

 # Self-Consistency checks
 assert result['min_hours'] <= result['average_hours'] <= result['max_hours']
 assert result['min_hours'] <= result['median_hours'] <= result['max_hours']
```

## 6. Anti-Alucinación Verification

**DORA Research Benchmarks (Verified):**
- Elite: <1 hour (NOT <30 minutes)
- High: <1 day (NOT <12 hours)
- Medium: <1 week (NOT <3 days)
- Low: >1 week

**Fuente:** https://dora.dev/guides/dora-metrics-four-keys/

**Self-Consistency Guarantees:**
- min <= avg <= max (enforced by assertion)
- min <= median <= max (enforced by assertion)
- Classification matches avg_hours range
- No incidents => MTTR = 0, classification = N/A

## 7. Trazabilidad

- Origen: N-004, RN-004, RF-020
- Implementado: api/callcentersite/dora_metrics/views.py:mttr_chart_data
- Tests: tests/dora_metrics/test_mttr.py
- ADR: ADR_2025_003 (DORA metrics integration)
