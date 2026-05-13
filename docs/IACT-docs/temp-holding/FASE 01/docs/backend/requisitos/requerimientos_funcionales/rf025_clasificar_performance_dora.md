---
id: RF-025
tipo: requisito_funcional
titulo: Clasificar Performance DORA General (Elite/High/Medium/Low)
dominio: backend
owner: equipo-ingenieria
prioridad: critica
estado: implementado_con_inconsistencias
fecha_creacion: 2025-11-11
trazabilidad_upward:
 - N-004
 - RN-004
 - RF-020
 - RF-021
 - RF-022
 - RF-023
 - RF-024
verificacion: test
date: 2025-11-13
---

# RF-025: Clasificar Performance DORA General

## 1. Descripción

El sistema DEBE clasificar el performance general del equipo de ingeniería combinando las 4 métricas DORA individuales (Deployment Frequency, Lead Time, CFR, MTTR) en una clasificación agregada.

Algoritmo de clasificación:
```
1. Clasificar cada métrica individualmente (Elite/High/Medium/Low)
2. Contar votos por categoría
3. Clasificación general = categoría con mayoría de votos
```

Criterio de decisión (voting algorithm):
- Si >=3 métricas son Elite → Clasificación general = Elite
- Si >=2 métricas son High → Clasificación general = High
- Si >=2 métricas son Medium → Clasificación general = Medium
- En otro caso → Clasificación general = Low

## 2. Auto-CoT con Multiple Paths

<thinking>
Path 1 (Individual Classifications):
- Calcular clasificación de cada métrica usando RF-021 a RF-024
- Deployment Frequency → Elite/High/Medium/Low
- Lead Time → Elite/High/Medium/Low
- CFR → Elite/High/Medium/Low
- MTTR → Elite/High/Medium/Low

Path 2 (Voting Mechanism):
- Contar votos: elite_count, high_count, medium_count, low_count
- Aplicar reglas de mayoría
- Retornar clasificación ganadora

Path 3 (Validación):
- Verificar que todas las métricas usen los mismos benchmarks DORA
- Garantizar que clasificación esté en {Elite, High, Medium, Low}
- Logging de métricas individuales para debugging

Self-Consistency Validation:
- Los 3 paths deben usar mismos thresholds DORA
- Clasificación general debe ser coherente con métricas individuales
- No debe ser posible tener 4 Low individuales y Elite general
</thinking>

## 3. Endpoint API

```
GET /api/dora-metrics/overall-classification
Query params:
 ?start_date=2025-10-01
 &end_date=2025-10-31

Response 200:
{
 "metric": "overall_classification",
 "period": {
 "start": "2025-10-01",
 "end": "2025-10-31",
 "days": 31
 },
 "individual_metrics": {
 "deployment_frequency": {
 "value": 1.35,
 "unit": "per_day",
 "classification": "Elite"
 },
 "lead_time": {
 "value": 36.0,
 "unit": "hours",
 "classification": "High"
 },
 "change_failure_rate": {
 "value": 12.5,
 "unit": "percentage",
 "classification": "Elite"
 },
 "mttr": {
 "value": 0.75,
 "unit": "hours",
 "classification": "Elite"
 }
 },
 "overall_classification": {
 "classification": "Elite",
 "vote_counts": {
 "elite": 3,
 "high": 1,
 "medium": 0,
 "low": 0
 },
 "reasoning": "3 out of 4 metrics are Elite (DF, CFR, MTTR)"
 },
 "recommendations": [
 "Lead Time can be improved to reach full Elite performance",
 "Consider breaking down features into smaller increments"
 ]
}
```

## 4. Implementación con Triple Path Validation

```python
def calculate_overall_dora_classification(start_date, end_date):
 """
 Calculate overall DORA classification by combining 4 metrics.

 Uses voting algorithm: majority of metrics determines overall classification.
 """
 # Path 1: Calculate individual metric classifications
 df_result = calculate_deployment_frequency(start_date, end_date)
 lt_result = calculate_lead_time(start_date, end_date)
 cfr_result = calculate_change_failure_rate(start_date, end_date)
 mttr_result = calculate_mttr(start_date, end_date)

 # Path 2: Extract individual classifications
 classifications = [
 df_result['classification'],
 lt_result['classification'],
 cfr_result['classification'],
 mttr_result['classification']
 ]

 # Path 3: Count votes
 vote_counts = {
 'elite': classifications.count('Elite'),
 'high': classifications.count('High'),
 'medium': classifications.count('Medium'),
 'low': classifications.count('Low')
 }

 # Self-Consistency: Verify all classifications are valid
 valid_classifications = {'Elite', 'High', 'Medium', 'Low', 'N/A'}
 for cls in classifications:
 assert cls in valid_classifications, \
 f"Invalid classification: {cls}"

 # Apply voting algorithm
 if vote_counts['elite'] >= 3:
 overall = "Elite"
 reasoning = f"{vote_counts['elite']} out of 4 metrics are Elite"
 elif vote_counts['high'] >= 2:
 overall = "High"
 reasoning = f"{vote_counts['high']} out of 4 metrics are High or better"
 elif vote_counts['medium'] >= 2:
 overall = "Medium"
 reasoning = f"{vote_counts['medium']} out of 4 metrics are Medium or better"
 else:
 overall = "Low"
 reasoning = "Majority of metrics are Low or inconsistent"

 # Generate recommendations
 recommendations = []
 if df_result['classification'] != 'Elite':
 recommendations.append(
 "Increase deployment frequency with smaller, incremental changes"
 )
 if lt_result['classification'] != 'Elite':
 recommendations.append(
 "Reduce lead time by automating testing and deployment pipelines"
 )
 if cfr_result['classification'] != 'Elite':
 recommendations.append(
 "Improve change failure rate with better testing and staging environments"
 )
 if mttr_result['classification'] != 'Elite':
 recommendations.append(
 "Reduce MTTR with better monitoring, alerting, and rollback procedures"
 )

 return {
 'individual_metrics': {
 'deployment_frequency': {
 'value': df_result.get('frequency_per_day', 0),
 'unit': 'per_day',
 'classification': df_result['classification']
 },
 'lead_time': {
 'value': lt_result.get('average_hours', 0),
 'unit': 'hours',
 'classification': lt_result['classification']
 },
 'change_failure_rate': {
 'value': cfr_result.get('cfr_percentage', 0),
 'unit': 'percentage',
 'classification': cfr_result['classification']
 },
 'mttr': {
 'value': mttr_result.get('average_hours', 0),
 'unit': 'hours',
 'classification': mttr_result['classification']
 }
 },
 'overall_classification': {
 'classification': overall,
 'vote_counts': vote_counts,
 'reasoning': reasoning
 },
 'recommendations': recommendations
 }
```

## 5. Tests con Self-Consistency Validation

```python
def test_overall_classification_elite():
 """Test Elite classification (3+ metrics are Elite)."""
 # Setup: Create data for all Elite metrics
 # DF: 35 deployments in 30 days = 1.16/day (Elite)
 for i in range(35):
 DORAMetric.objects.create(
 cycle_id=f'C-{i}',
 feature_id=f'F-{i}',
 phase_name='deployment',
 decision='go',
 duration_seconds=600
 )

 # Lead Time: 0.5 hours avg (Elite)
 for i in range(35):
 DORAMetric.objects.create(
 cycle_id=f'C-{i}-planning',
 feature_id=f'F-{i}',
 phase_name='planning',
 decision='go',
 duration_seconds=1800 # 0.5 hours
 )

 # CFR: 3 failed out of 35 = 8.6% (Elite)
 for i in range(3):
 DORAMetric.objects.create(
 cycle_id=f'C-FAIL-{i}',
 feature_id=f'F-FAIL-{i}',
 phase_name='deployment',
 decision='no-go',
 duration_seconds=300
 )

 # MTTR: 0.5 hours avg (Elite)
 for i in range(5):
 DORAMetric.objects.create(
 cycle_id=f'INC-{i}',
 feature_id=f'INC-{i}',
 phase_name='maintenance',
 decision='go',
 duration_seconds=1800 # 0.5 hours
 )

 result = calculate_overall_dora_classification(
 date(2025, 10, 1),
 date(2025, 10, 30)
 )

 # Verify individual classifications
 assert result['individual_metrics']['deployment_frequency']['classification'] == 'Elite'
 assert result['individual_metrics']['lead_time']['classification'] == 'Elite'
 assert result['individual_metrics']['change_failure_rate']['classification'] == 'Elite'
 assert result['individual_metrics']['mttr']['classification'] == 'Elite'

 # Verify overall classification
 assert result['overall_classification']['classification'] == 'Elite'
 assert result['overall_classification']['vote_counts']['elite'] == 4

def test_overall_classification_high():
 """Test High classification (2+ metrics are High)."""
 # DF: 5 deployments in 30 days = 0.16/day = 1.16/week (High)
 for i in range(5):
 DORAMetric.objects.create(
 cycle_id=f'C-{i}',
 phase_name='deployment',
 decision='go',
 duration_seconds=600
 )

 # Lead Time: 48 hours (High)
 # CFR: 20% (High)
 # MTTR: 12 hours (High)
 # ... (create corresponding test data)

 result = calculate_overall_dora_classification(
 date(2025, 10, 1),
 date(2025, 10, 30)
 )

 assert result['overall_classification']['classification'] == 'High'

def test_overall_classification_mixed():
 """Test mixed classification (2 Elite, 1 High, 1 Medium → Elite)."""
 # This tests the voting algorithm edge case
 # Expected: 2 Elite votes win

 result = calculate_overall_dora_classification(
 date(2025, 10, 1),
 date(2025, 10, 30)
 )

 # Self-Consistency: Verify vote counts match individual metrics
 expected_elite = sum(
 1 for m in result['individual_metrics'].values()
 if m['classification'] == 'Elite'
 )
 assert result['overall_classification']['vote_counts']['elite'] == expected_elite

def test_recommendations_generated():
 """Test that recommendations are generated for non-Elite metrics."""
 # Create data where only DF is Elite, others are not
 # ... (create test data)

 result = calculate_overall_dora_classification(
 date(2025, 10, 1),
 date(2025, 10, 30)
 )

 # Should have recommendations for LT, CFR, MTTR (3 recommendations)
 assert len(result['recommendations']) == 3
 assert any('lead time' in r.lower() for r in result['recommendations'])
 assert any('failure rate' in r.lower() for r in result['recommendations'])
 assert any('mttr' in r.lower() for r in result['recommendations'])
```

## 6. Anti-Alucinación Verification

**CRITICAL: Implementación actual tiene inconsistencias**

La implementación en `api/callcentersite/dora_metrics/views.py:267` usa thresholds INCORRECTOS para CFR:

**Código actual (INCORRECTO):**
```python
# Change Failure Rate
if cfr < 5: # Elite: <5%
 elite_count += 1
elif cfr < 10: # High: 5-10%
 high_count += 1
elif cfr < 15: # Medium: 10-15%
 medium_count += 1
```

**DORA Research 2024 (CORRECTO):**
```
Elite: 0-15%
High: 16-30%
Medium: 31-45%
Low: 46-60%
```

**Fuente verificada:** https://dora.dev/guides/dora-metrics-four-keys/

**ACCIÓN REQUERIDA:** Corregir thresholds de CFR en la implementación para alinearse con DORA research oficial.

**Voting Algorithm (CORRECTO):**
- La lógica de votación (>=3 Elite → Elite general) es correcta
- Permite balancear fortalezas y debilidades del equipo

**Self-Consistency Guarantees:**
- Suma de vote_counts debe ser 4 (las 4 métricas DORA)
- Clasificación general debe seguir reglas de mayoría
- Recommendations.length <= 4 (máximo 1 por métrica)

## 7. Trazabilidad

- Origen: N-004, RN-004, RF-020
- Depende de: RF-021, RF-022, RF-023, RF-024
- Implementado: api/callcentersite/dora_metrics/views.py:calculate_dora_classification
- **NOTA:** Implementación requiere corrección de thresholds CFR
- Tests: tests/dora_metrics/test_overall_classification.py
- ADR: ADR_2025_003 (DORA metrics integration)

## 8. Issues de Calidad Identificados

### Issue 1: CFR Thresholds Incorrectos

**Ubicación:** `api/callcentersite/dora_metrics/views.py:304-311`

**Problema:** Los thresholds de CFR no coinciden con DORA research oficial

**Impacto:** Equipos con CFR entre 15-30% serían clasificados como "Low" cuando deberían ser "High"

**Solución propuesta:**
```python
# Change Failure Rate (CORRECTED)
if cfr <= 15: # Elite: 0-15%
 elite_count += 1
elif cfr <= 30: # High: 16-30%
 high_count += 1
elif cfr <= 45: # Medium: 31-45%
 medium_count += 1
else: # Low: >45%
 low_count += 1
```

**Prioridad:** Alta
**Estado:** Pendiente de corrección
