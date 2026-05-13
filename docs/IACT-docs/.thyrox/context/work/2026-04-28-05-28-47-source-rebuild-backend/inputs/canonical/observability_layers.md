---
id: DOC-IMPL-OBSERVABILITY-LAYERS
tipo: arquitectura
categoria: implementacion
version: 1.0.0
fecha_creacion: 2025-11-06
propietario: arquitecto-senior
relacionados: ["ADR_2025_003", "DORA_SDLC_INTEGRATION_GUIDE.md", "ESTRATEGIA_IA.md"]
date: 2025-11-13
---

# Capas de Observabilidad - Proyecto IACT

Separacion clara entre metricas DORA, logs de aplicacion y logs de infraestructura.

**Version:** 1.0.0
**Fecha:** 2025-11-06

---

## Vision General

El proyecto IACT implementa **3 capas independientes** de observabilidad,
cada una con proposito, storage y audiencia diferentes.

**Proposito de este documento:**
Evitar confusion entre metricas DORA (proceso de desarrollo) y logs de
aplicacion/infraestructura (runtime del sistema).

---

## Capa 1: DORA Metrics (Proceso de Desarrollo)

### Proposito

Medir performance del EQUIPO y PIPELINE de desarrollo, no del sistema en produccion.

**Preguntas que responde:**
- Que tan rapido desplegamos features? (Deployment Frequency)
- Cuanto tarda un feature desde commit hasta produccion? (Lead Time)
- Cuantos deploys fallan o requieren rollback? (Change Failure Rate)
- Cuanto tardamos en recuperar de incidentes? (MTTR)

### Fuente de Datos

**NO son logs de runtime** - son eventos del CICLO DE DESARROLLO:

1. **Git events:**
 - Commits: `git log --since="30 days"`
 - PRs: GitHub API `/repos/owner/repo/pulls`
 - Merges: `git log --merges`

2. **CI/CD pipeline events:**
 - GitHub Actions workflows: `/.github/workflows/*.yml`
 - Workflow runs: GitHub API `/repos/owner/repo/actions/runs`
 - Deploy success/failure

3. **SDLC Agents:**
 - Planning: `DORAMetrics.start_cycle()`
 - Testing: `DORAMetrics.record_phase('testing', ...)`
 - Deployment: `DORAMetrics.record_phase('deployment', ...)`
 - Maintenance: `DORAMetrics.record_phase('maintenance', ...)`

4. **Issues con label "incident":**
 - Created: Incidente inicia
 - Closed: Incidente resuelto
 - Duration: `closed_at - created_at` = MTTR

### Storage

```
# Capa 1: DORA Metrics Storage
.dora_sdlc_metrics.json # Local (v1)
MySQL: dora_metrics table # Futuro (P0 - 8 SP)
Django Admin: /admin/dora/ # Futuro (P2 - 5 SP)
```

**Schema MySQL (futuro):**
```sql
CREATE TABLE dora_metrics (
 id BIGINT PRIMARY KEY AUTO_INCREMENT,
 cycle_id VARCHAR(50) UNIQUE NOT NULL,
 feature_id VARCHAR(50) NOT NULL,
 phase_name VARCHAR(50) NOT NULL,
 decision VARCHAR(20),
 duration_seconds DECIMAL(10,2),
 metadata JSON,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Formato de Datos

```json
{
 "cycle_id": "cycle-20251106-143000",
 "feature_id": "FEAT-001",
 "start_time": "2025-11-06T14:30:00Z",
 "phases": [
 {
 "phase": "planning",
 "decision": "go",
 "duration_seconds": 300.0,
 "timestamp": "2025-11-06T14:35:00Z"
 },
 {
 "phase": "testing",
 "decision": "go",
 "duration_seconds": 7200.0,
 "metadata": {
 "tests_passed": 95,
 "tests_failed": 5
 }
 }
 ],
 "metrics": {
 "lead_time": 1.25,
 "deployment_frequency": 0.50,
 "change_failure_rate": 5.0,
 "mttr": null
 }
}
```

### Acceso

- **Tech Lead:** Analizar performance equipo
- **Arquitecto:** Validar mejoras IA (PDCA)
- **DevOps Lead:** Optimizar CI/CD pipeline
- **Developers:** Ver metricas propias (opcional)

### Herramientas

```bash
# CLI
python scripts/ai/agents/dora_sdlc_integration.py
python scripts/dora_metrics.py --days 30

# PDCA automation
python scripts/ai/agents/pdca_automation_agent.py --auto-execute

# Futuro: Django Admin
https://iact.local/admin/dora/metrics/
```

### Retention

- **Default:** 90 dias
- **Configurable:** Per proyecto

---

## Capa 2: Application Logs (Business Logic)

### Proposito

Registrar comportamiento de la APLICACION Django en runtime (produccion, staging, dev).

**Preguntas que responde:**
- Que requests HTTP recibe la aplicacion?
- Que errores ocurren en business logic?
- Que queries SQL son lentas?
- Como se comportan los usuarios?

### Fuente de Datos

**Son logs de la aplicacion Django:**

1. **Django logging:**
 ```python
 import logging
 logger = logging.getLogger(__name__)

 logger.info("Usuario login exitoso", extra={'user_id': 123})
 logger.error("Pago fallido", extra={'order_id': 456, 'error': str(e)})
 ```

2. **Middleware logs:**
 - Request processing time
 - Response status codes
 - Authentication failures

3. **ORM query logs:**
 ```python
 # settings.py
 LOGGING = {
 'loggers': {
 'django.db.backends': {
 'level': 'DEBUG', # Log SQL queries
 }
 }
 }
 ```

4. **Celery task logs:**
 ```python
 @app.task
 def send_email(user_id):
 logger.info(f"Sending email to user {user_id}")
 ```

### Storage

```
# Capa 2: Application Logs Storage
logs/django.log # Django application
logs/celery.log # Celery tasks
logs/api.log # API requests/responses

# Futuro (si necesario):
MySQL: application_logs table # Structured logging
```

**Filesystem structure:**
```
logs/
 django.log # Rotated daily
 django.log.1
 django.log.2.gz
 celery.log
 celery.log.1
 api.log
```

### Formato de Datos

**Opcion 1: Plain text (actual)**
```
[2025-11-06 15:05:23] INFO [views.user] Usuario login exitoso user_id=123
[2025-11-06 15:05:24] ERROR [payments] Pago fallido order_id=456 error="Tarjeta rechazada"
```

**Opcion 2: JSON estructurado (recomendado futuro)**
```json
{
 "timestamp": "2025-11-06T15:05:23Z",
 "level": "INFO",
 "logger": "views.user",
 "message": "Usuario login exitoso",
 "user_id": 123,
 "request_id": "req-abc123"
}
```

### Acceso

- **Developers:** Debug aplicacion durante desarrollo
- **QA:** Validar comportamiento esperado
- **SRE:** Troubleshoot errores produccion
- **Support:** Investigar reportes usuarios

### Herramientas

```bash
# Ver logs en tiempo real
tail -f logs/django.log

# Buscar errores
grep ERROR logs/django.log

# Buscar por user_id
grep "user_id=123" logs/django.log

# Analizar queries lentas
grep "Slow query" logs/django.log | awk '{print $NF}' | sort | uniq -c
```

### Retention

- **Default:** 30 dias (logrotate)
- **Compresion:** Automatica (gzip)
- **Archivado:** Opcional (S3, backup)

---

## Capa 3: Infrastructure Logs (Sistema Operativo)

### Proposito

Registrar comportamiento del SISTEMA OPERATIVO y SERVICIOS (nginx, postgresql, mysql).

**Preguntas que responde:**
- Hay errores a nivel de SO?
- Nginx rechaza conexiones?
- PostgreSQL tiene queries lentas?
- Hay problemas de memoria/CPU?

### Fuente de Datos

**Son logs del sistema operativo:**

1. **Sistema operativo:**
 - `/var/log/syslog` - General system logs
 - `/var/log/kern.log` - Kernel logs
 - `/var/log/auth.log` - Authentication logs

2. **Nginx:**
 - `/var/log/nginx/access.log` - HTTP requests
 - `/var/log/nginx/error.log` - Nginx errors

3. **PostgreSQL:**
 - `/var/log/postgresql/postgresql-14-main.log`
 - Slow queries, connection errors, crashes

4. **MySQL:**
 - `/var/log/mysql/error.log`
 - `/var/log/mysql/slow-query.log`

5. **Cron jobs:**
 - `/var/log/cron.log`

### Storage

```
# Capa 3: Infrastructure Logs Storage
/var/log/syslog
/var/log/nginx/access.log
/var/log/postgresql/*.log
/var/log/mysql/*.log
```

**NO usar MySQL para infraestructura logs** - filesystem es mas apropiado.

### Formato de Datos

**Syslog format (RFC 3164):**
```
Nov 6 15:05:23 iact-server nginx[1234]: [error] upstream prematurely closed
Nov 6 15:05:23 iact-server postgres[5678]: ERROR: null value in column "user_id"
```

### Acceso

- **DevOps:** Troubleshoot infraestructura
- **SysAdmin:** Maintenance sistema operativo
- **SRE:** Investigar outages
- **Security:** Audit accesos/intentos intrusión

### Herramientas

```bash
# Ver logs sistema
sudo tail -f /var/log/syslog

# Nginx access log (ultimas 100 requests)
sudo tail -100 /var/log/nginx/access.log

# PostgreSQL slow queries
sudo grep "duration:" /var/log/postgresql/postgresql-14-main.log | \
 awk '{if ($10 > 1000) print}'

# Errores MySQL
sudo tail -f /var/log/mysql/error.log
```

### Retention

- **Default:** 30 dias (logrotate)
- **Configuracion:** `/etc/logrotate.d/*`
- **Rotation:** Daily, compress older than 1 day

---

## Ejemplo: Deploy Fallido - 3 Capas

Cuando deployment falla, cada capa captura informacion diferente:

### Capa 1: DORA Metrics (Proceso)

**Que registra:** Impacto en metricas de proceso

```json
{
 "cycle_id": "cycle-20251106-150000",
 "feature_id": "FEAT-001",
 "phase": "deployment",
 "decision": "failed",
 "duration_seconds": 45.0,
 "metrics": {
 "change_failure_rate": 15.0, // Deploy aumento CFR
 "mttr": 0.25 // 15 minutos para rollback
 }
}
```

**Para quien:** Tech Lead - "Nuestro CFR subio, que paso?"

### Capa 2: Application Logs (Django)

**Que registra:** Error especifico en aplicacion

```python
# logs/django.log
[2025-11-06 15:05:23] ERROR [deployment] Migration 0042 failed
[2025-11-06 15:05:23] ERROR [django.db] IntegrityError: Column 'user_id' cannot be null
[2025-11-06 15:05:23] INFO [deployment] Rollback initiated
[2025-11-06 15:05:30] INFO [deployment] Rollback completed successfully
```

**Para quien:** Developer - "Cual migration fallo? Necesito fixear"

### Capa 3: Infrastructure Logs (PostgreSQL)

**Que registra:** Error a nivel de base de datos

```bash
# /var/log/postgresql/postgresql-14-main.log
2025-11-06 15:05:23 ERROR: null value in column "user_id" violates not-null constraint
2025-11-06 15:05:23 DETAIL: Failing row contains (123, null, 'test@example.com')
2025-11-06 15:05:23 STATEMENT: INSERT INTO users (id, user_id, email) VALUES (123, NULL, 'test@example.com')

# /var/log/nginx/error.log
2025/11/06 15:05:23 [error] 1234#0: *5678 upstream prematurely closed connection
```

**Para quien:** DevOps - "PostgreSQL constraint violation, necesito revisar schema"

---

## Comparacion de Capas

| Aspecto | DORA Metrics | Application Logs | Infrastructure Logs |
|---------|--------------|------------------|---------------------|
| **Scope** | Proceso desarrollo | Aplicacion Django | Sistema operativo |
| **Objetivo** | Medir performance equipo | Debug aplicacion | Debug infraestructura |
| **Audiencia** | Tech Lead, Arquitecto | Developers, QA | DevOps, SysAdmin |
| **Storage** | MySQL `dora_metrics` | `logs/*.log` o MySQL | `/var/log/*` |
| **Formato** | JSON estructurado | Plain text o JSON | Syslog (RFC 3164) |
| **Retention** | 90 dias | 30 dias | 30 dias |
| **Rotation** | Manual/automated cleanup | logrotate daily | logrotate daily |
| **Acceso** | Django Admin dashboard | `tail -f`, `grep` | `sudo tail -f`, `journalctl` |
| **Uso principal** | PDCA, mejora continua | Debugging features | Troubleshooting infra |
| **Ejemplo query** | Lead Time promedio | Errores en view X | Conexiones rechazadas nginx |

---

## Integracion Entre Capas

Aunque independientes, las 3 capas se complementan:

### Flujo de Investigacion: Deploy Fallido

```
1. DORA Metrics (Capa 1):
 - Alerta: CFR subio de 5% a 15%
 - Ciclo: cycle-20251106-150000
 - Feature: FEAT-001

2. Application Logs (Capa 2):
 - Buscar: grep "cycle-20251106-150000" logs/django.log
 - Encontrar: Migration 0042 failed - IntegrityError user_id

3. Infrastructure Logs (Capa 3):
 - Buscar: grep "user_id" /var/log/postgresql/*.log
 - Encontrar: null value violates not-null constraint

4. Root Cause: Migration 0042 intento insertar user_id=NULL
5. Fix: Agregar default value en migration
6. Validation: Re-deploy, verificar DORA metrics mejoran
```

### Request ID Tracing (Futuro)

Para correlacionar logs entre capas:

```python
# Capa 2: Django genera request_id
request_id = "req-abc123"
logger.info("Processing request", extra={'request_id': request_id})

# Capa 1: DORA incluye request_id en metadata
dora_metrics.record_phase('deployment', 'go', 45.0, {
 'request_id': request_id
})

# Capa 3: Nginx incluye request_id en access.log
# (via header X-Request-ID)
```

---

## Recomendaciones de Implementacion

### Para DORA Metrics (Capa 1)

```python
# BIEN - Solo eventos de proceso
dora_metrics.record_phase('deployment', 'go', 45.0)

# MAL - No mezclar con logs de runtime
dora_metrics.record_phase('http_request', 'success', 0.5) # Esto es Capa 2
```

### Para Application Logs (Capa 2)

```python
# BIEN - Logging estructurado
logger.info("Payment processed", extra={
 'order_id': 123,
 'amount': 99.99,
 'user_id': 456
})

# MAL - Logging sin estructura
logger.info(f"Payment processed: {order_id}, {amount}, {user_id}")
```

### Para Infrastructure Logs (Capa 3)

```bash
# BIEN - Usar herramientas nativas
sudo tail -f /var/log/nginx/access.log

# MAL - Duplicar logs en aplicacion
logger.info("Nginx received request") # Ya esta en nginx access.log
```

---

## Roadmap de Mejoras

**Q4 2025:**
- [ ] Capa 1: MySQL storage para DORA metrics (P0 - 8 SP)
- [ ] Capa 2: JSON structured logging (P1 - 3 SP)
- [ ] Request ID tracing entre capas (P2 - 5 SP)

**Q1 2026:**
- [ ] Capa 1: Django Admin dashboards (P2 - 5 SP)
- [ ] Capa 2: MySQL application_logs table (P3 - 8 SP)
- [ ] Centralized log aggregation (P3 - 13 SP)

**Q2 2026:**
- [ ] Alerting basado en metricas DORA (P1 - 5 SP)
- [ ] Anomaly detection en logs aplicacion (P2 - 8 SP)
- [ ] Automated incident response (P2 - 8 SP)

---

## Referencias

- ADR_2025_003: Decision integracion DORA + SDLC
- DORA_SDLC_INTEGRATION_GUIDE.md: Implementacion Capa 1
- WORKFLOW_METRICAS_PROCESO.md: Uso operacional Capa 1
- Django Logging: https://docs.djangoproject.com/en/4.2/topics/logging/
- RFC 3164: Syslog Protocol
- DORA Report 2025: https://dora.dev/

---

**VERSION:** 1.0.0
**ULTIMA ACTUALIZACION:** 2025-11-06
**PROXIMA REVISION:** 2025-11-20
**ESTADO:** DOCUMENTACION COMPLETA
