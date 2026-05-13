---
id: TASK-028-etl-pipeline-automation
tipo: documentacion_arquitectura
categoria: arquitectura
prioridad: P3
story_points: 5
estado: completado
fecha_inicio: 2025-11-07
fecha_fin: 2025-11-07
asignado: backend-lead
relacionados: ["TASK-005", "TASK-017"]
date: 2025-11-13
---

# TASK-028: ETL Pipeline Automation

Automatizacion de pipeline ETL con Django management commands y cron.

## Arquitectura ETL

```
Sources → Extract → Transform → Load → Destinations
 ↓ ↓ ↓ ↓ ↓
GitHub Python Validate Django MySQL
Logs Parser Clean ORM Cassandra
```

## Técnicas de Prompt Engineering para Agente

Las siguientes técnicas deben aplicarse al ejecutar esta tarea con un agente:

1. **Task Decomposition** (structuring_techniques.py)
 - Dividir el diseno arquitectonico en componentes manejables

2. **Code Generation** (fundamental_techniques.py)
 - Generar implementaciones base para componentes arquitectonicos

3. **Expert Prompting** (specialized_techniques.py)
 - Aplicar conocimiento experto de arquitectura Django y patrones de diseno

4. **Constitutional AI** (optimization_techniques.py)
 - Validar que el diseno cumpla con restricciones y mejores practicas

5. **Meta-prompting** (structuring_techniques.py)
 - Generar prompts especializados para cada componente del sistema

Agente recomendado: SDLCDesignAgent o FeatureAgent
## Implementacion (Django Management Commands)

### 1. Extract Command

```python
# management/commands/etl_extract.py
from django.core.management.base import BaseCommand

class Command(BaseCommand):
 def handle(self, *args, **options):
 # Extract from GitHub API, logs, etc
 data = extract_from_github()
 save_to_staging(data)
```

### 2. Transform Command

```python
# management/commands/etl_transform.py
class Command(BaseCommand):
 def handle(self, *args, **options):
 # Validate and clean data
 staging_data = load_from_staging()
 cleaned = validate_and_transform(staging_data)
 save_transformed(cleaned)
```

### 3. Load Command

```python
# management/commands/etl_load.py
class Command(BaseCommand):
 def handle(self, *args, **options):
 # Load to MySQL/Cassandra
 transformed_data = load_transformed()
 DORAMetric.objects.bulk_create(transformed_data)
```

## Orquestacion con Cron

```bash
# Crontab entry - Ejecutar ETL diario 1 AM
0 1 * * * cd /home/user/IACT---project/api/callcentersite && python manage.py etl_extract && python manage.py etl_transform && python manage.py etl_load >> /var/log/iact/etl.log 2>&1
```

**Alternativa:** Script wrapper
```bash
# scripts/run_etl_pipeline.sh
#!/bin/bash
python manage.py etl_extract || exit 1
python manage.py etl_transform || exit 2
python manage.py etl_load || exit 3
```

## Error Handling

### Retry Logic

```python
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=4, max=10))
def extract_from_api():
 response = requests.get(API_URL)
 response.raise_for_status()
 return response.json()
```

### Dead Letter Queue

```python
# Si falla despues de 3 reintentos
failed_records.append({
 'data': record,
 'error': str(exception),
 'timestamp': timezone.now()
})
# Save to dead_letter_queue table
```

## Monitoring

### Notifications

```python
# Al completar ETL
from dora_metrics.alerts import critical_alert

if etl_failed:
 critical_alert.send(
 sender=None,
 message="ETL pipeline failed",
 context={'stage': stage, 'error': error}
 )
```

### Metrics

Track en MySQL:
```python
ETLRun.objects.create(
 pipeline='dora_metrics',
 status='success',
 records_processed=1000,
 duration_seconds=45,
 started_at=start_time,
 completed_at=timezone.now()
)
```

## Compliance

[OK] NO usa Airflow (evita dependencia externa, RNF-002 compliant)
[OK] Self-hosted con Django + cron
[OK] Simple y mantenible

---

**VERSION:** 1.0.0
**ESTADO:** COMPLETADO
**STORY POINTS:** 5 SP
**FECHA:** 2025-11-07
