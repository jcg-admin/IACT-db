---
id: RUNBOOK-ETL-RETRY
estado: draft
propietario: equipo-devops
ultima_actualizacion: 2025-11-02
relacionados: ["DOC-DEVOPS-INDEX", "DOC-DIS-INDEX"]
---
# Runbook: Reprocesar ETL Fallido

## Propósito

Procedimiento para recuperar y reprocesar jobs de ETL que fallaron, asegurando integridad de datos y minimizando pérdida de información.

## Estado Actual

WARNING **Nota**: Este runbook es preparatorio. El sistema ETL está en desarrollo (Q1-Q2 2025).

## Cuándo Usar

- Job de ETL falla durante extracción, transformación o carga
- Alerta de monitoreo indica falla en procesamiento
- Datos faltantes detectados en base analítica
- Después de resolver problema de infraestructura (DB down, etc.)

## Pre-requisitos

- Acceso a logs del sistema ETL
- Acceso a base de datos PostgreSQL (analytics)
- Acceso a base de datos MariaDB (IVR)
- Entorno virtual Python activado
- Django management commands disponibles

## Identificar Causa de Falla

### 1. Revisar Logs

```bash
# Logs de Django
tail -f logs/django.log

# Filtrar errores ETL
grep "ETL" logs/django.log | grep "ERROR"

# Logs específicos de fecha
grep "2025-11-02" logs/etl.log
```

### 2. Revisar Estado en Base de Datos

```sql
-- Tabla de jobs ETL (ejemplo futuro)
SELECT *
FROM etl_job_status
WHERE status = 'FAILED'
ORDER BY created_at DESC
LIMIT 10;

-- Ver detalles de falla
SELECT job_id, error_message, stack_trace
FROM etl_job_status
WHERE job_id = 12345;
```

### 3. Categorizar Tipo de Falla

| Tipo | Descripción | Recuperable |
|------|-------------|-------------|
| **Conexión DB** | No puede conectar a IVR/Analytics | OK Sí |
| **Datos inválidos** | Datos IVR no cumplen schema | WARNING Requiere corrección |
| **Timeout** | Query tarda demasiado | OK Sí (con ajustes) |
| **Duplicados** | Datos ya existen en analytics | OK Sí (con verificación) |
| **Transformación** | Error en lógica de negocio | NO Requiere fix de código |
| **Espacio disco** | Sin espacio en servidor | OK Sí (después de limpieza) |

## Procedimiento de Recuperación

### Opción 1: Reprocesar por Fecha

```bash
# Activar entorno virtual
source .venv/bin/activate

# Reprocesar día específico
python manage.py process_etl --date 2025-11-02

# Reprocesar rango de fechas
python manage.py process_etl --start-date 2025-11-01 --end-date 2025-11-02

# Modo dry-run (sin escribir a DB)
python manage.py process_etl --date 2025-11-02 --dry-run
```

### Opción 2: Reprocesar por Job ID

```bash
# Reprocesar job específico
python manage.py retry_etl_job --job-id 12345

# Reprocesar múltiples jobs
python manage.py retry_etl_job --job-ids 12345,12346,12347

# Forzar reproceso (sobrescribe datos existentes)
python manage.py retry_etl_job --job-id 12345 --force
```

### Opción 3: Reprocesar Manualmente (Debugging)

```python
# Django shell
python manage.py shell

# Código Python
from etl.services import ETLOrchestrator
from datetime import date

orchestrator = ETLOrchestrator()

# Reprocesar fecha
target_date = date(2025, 11, 2)
result = orchestrator.process_date(target_date)

print(f"Procesadas: {result.processed_count}")
print(f"Fallidas: {result.failed_count}")
print(f"Errores: {result.errors}")
```

## Escenarios Específicos

### Escenario 1: Conexión a IVR Perdida

**Síntomas:**
```
ERROR: OperationalError: (2003, "Can't connect to MySQL server on '127.0.0.1:13306'")
```

**Pasos:**

1. Verificar que MariaDB está corriendo:
   ```bash
   ./scripts/verificar_servicios.sh
   ```

2. Si servicio down, reiniciar:
   ```bash
   vagrant ssh -c "sudo systemctl restart mariadb"
   ```

3. Esperar 30 segundos

4. Reprocesar:
   ```bash
   python manage.py process_etl --date 2025-11-02
   ```

### Escenario 2: Timeout en Query Grande

**Síntomas:**
```
ERROR: OperationalError: canceling statement due to statement timeout
```

**Pasos:**

1. Revisar tamaño de datos:
   ```sql
   -- En IVR DB
   SELECT COUNT(*)
   FROM calls
   WHERE DATE(start_time) = '2025-11-02';
   ```

2. Procesar en chunks más pequeños:
   ```bash
   # Por hora en vez de día completo
   python manage.py process_etl \
       --date 2025-11-02 \
       --chunk-size 1000 \
       --batch-mode hourly
   ```

3. O aumentar timeout (temporal):
   ```bash
   python manage.py process_etl \
       --date 2025-11-02 \
       --timeout 600  # 10 minutos
   ```

### Escenario 3: Datos Duplicados

**Síntomas:**
```
ERROR: IntegrityError: duplicate key value violates unique constraint "calls_call_id_key"
```

**Pasos:**

1. Verificar si datos ya existen:
   ```sql
   SELECT COUNT(*)
   FROM analytics_calls
   WHERE DATE(start_time) = '2025-11-02';
   ```

2. Si existen, decidir:

   **Opción A: Skip (datos correctos)**
   ```bash
   # No hacer nada, datos ya están
   echo "Datos ya procesados correctamente"
   ```

   **Opción B: Reemplazar (datos incorrectos)**
   ```bash
   # Borrar datos existentes
   python manage.py shell << EOF
   from analytics.models import Call
   from datetime import date
   target_date = date(2025, 11, 2)
   Call.objects.filter(start_time__date=target_date).delete()
   EOF

   # Reprocesar
   python manage.py process_etl --date 2025-11-02
   ```

### Escenario 4: Transformación Inválida

**Síntomas:**
```
ERROR: ValidationError: Invalid duration: -120
```

**Pasos:**

1. **NO reprocesar** inmediatamente

2. Revisar datos fuente:
   ```sql
   -- Encontrar registros problemáticos
   SELECT *
   FROM ivr.calls
   WHERE DATE(start_time) = '2025-11-02'
     AND duration < 0;
   ```

3. Decidir estrategia:

   **Opción A: Fix código**
   ```python
   # En transformer
   def transform_duration(raw_duration):
       # Agregar validación
       if raw_duration < 0:
           logger.warning(f"Invalid duration: {raw_duration}, using 0")
           return 0
       return raw_duration
   ```

   **Opción B: Skip registros inválidos**
   ```bash
   python manage.py process_etl \
       --date 2025-11-02 \
       --skip-invalid
   ```

4. Después de fix, reprocesar

## Verificación Post-Reproceso

### 1. Verificar Cantidad de Registros

```sql
-- Contar registros procesados
SELECT DATE(start_time) as date,
       COUNT(*) as total_calls
FROM analytics_calls
WHERE DATE(start_time) = '2025-11-02'
GROUP BY DATE(start_time);

-- Comparar con fuente
SELECT DATE(start_time) as date,
       COUNT(*) as total_calls
FROM ivr.calls
WHERE DATE(start_time) = '2025-11-02'
GROUP BY DATE(start_time);
```

**Esperado:** Números deben coincidir (o explicar diferencia).

### 2. Verificar Métricas Calculadas

```sql
-- Verificar que métricas se calcularon
SELECT *
FROM analytics_daily_metrics
WHERE date = '2025-11-02';
```

**Esperado:** Registro debe existir con valores razonables.

### 3. Smoke Tests

```bash
# Ejecutar tests de integración
pytest tests/integration/test_etl.py

# Test específico de fecha reprocesada
pytest tests/integration/test_etl.py::test_process_date_2025_11_02
```

### 4. Verificar Logs

```bash
# Revisar logs de procesamiento
grep "2025-11-02" logs/etl.log | grep "SUCCESS"
```

**Esperado:** Mensajes de éxito sin errores.

## Prevención de Futuras Fallas

### 1. Implementar Reintentos Automáticos

```python
# etl/orchestrator.py
from tenacity import retry, stop_after_attempt, wait_exponential

class ETLOrchestrator:
    @retry(
        stop=stop_after_attempt(3),
        wait=wait_exponential(multiplier=1, min=4, max=10)
    )
    def extract_data(self, date):
        # Lógica de extracción
        pass
```

### 2. Agregar Alertas

```python
# Notificar en Slack/Email cuando falla
if job.status == 'FAILED':
    send_alert(
        channel='#etl-alerts',
        message=f'ETL failed for date {job.date}: {job.error}'
    )
```

### 3. Circuit Breaker

```python
# Detener procesamiento si muchas fallas
if consecutive_failures > 5:
    circuit_breaker.open()
    logger.critical("Circuit breaker opened - too many failures")
    raise CircuitBreakerOpen()
```

### 4. Monitoreo Proactivo

```python
# Checks de salud
def health_check():
    checks = {
        'ivr_db_connection': check_ivr_connection(),
        'analytics_db_connection': check_analytics_connection(),
        'disk_space': check_disk_space(),
        'last_etl_success': check_last_success_time(),
    }
    return all(checks.values())
```

## Escalamiento

Si el problema persiste después de 3 intentos:

1. **Documentar:**
   - Job ID afectado
   - Fecha/hora de falla
   - Error messages completos
   - Stack traces

2. **Crear Issue en GitHub:**
   ```
   Título: [ETL] Falla persistente procesando 2025-11-02
   Labels: bug, etl, high-priority
   Asignado a: tech-lead
   ```

3. **Notificar:**
   - Slack: #tech-escalations
   - Email a tech lead
   - PagerDuty si fuera de horario

4. **Rollback Temporal:**
   ```bash
   # Revertir a última versión estable
   git checkout <last-stable-commit>
   python manage.py migrate
   systemctl restart iact-django
   ```

## Checklist de Recuperación

- [ ] Identificar causa raíz de falla
- [ ] Resolver problema de infraestructura (si aplica)
- [ ] Ejecutar dry-run de reproceso
- [ ] Reprocesar datos
- [ ] Verificar cantidad de registros procesados
- [ ] Verificar métricas calculadas
- [ ] Ejecutar smoke tests
- [ ] Revisar logs para confirmar éxito
- [ ] Documentar incidente en post-mortem
- [ ] Implementar prevención para futuras ocurrencias

## Referencias

- [Diseño Detallado - ETL](../../diseno_detallado/readme.md)
- [Arquitectura](../../arquitectura/readme.md)
- [Runbook: Verificar Servicios](verificar_servicios.md)

## Referencias Adicionales

**Nota**: El stub previo en `docs/implementacion/backend/devops/runbooks/` incluía referencias a:
- UC-REP-004: Caso de uso relacionado con reportes
- RQ-ANL-003: Requisito de análisis relacionado
- Comando `python manage.py check_etl --job-id` para validación

Estas referencias se mantendrán cuando los documentos de requisitos y casos de uso estén completos.

## Changelog

- 2025-11-02: Creación inicial (draft - ETL en desarrollo)
- 2025-11-04: Fusionado contenido de stub previo (referencias UC-REP-004, RQ-ANL-003)
