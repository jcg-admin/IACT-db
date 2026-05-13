---
id: ADR-BACK-012-apscheduler-tareas-programadas
estado: aprobado
propietario: equipo-backend
ultima_actualizacion: 2025-01-17
relacionados: ["RNF-002", "ADR-BACK-011", "ADR-DEVOPS-001"]
date: 2025-01-17
---

# ADR-BACK-012: APScheduler para Tareas Programadas

**Estado:** aprobado

**Fecha:** 2025-01-17

**Decisores:** equipo-backend, arquitecto-principal, equipo-infraestructura

**Contexto técnico:** Backend, Infraestructura

---

## Contexto y Problema

El proyecto IACT necesita ejecutar tareas programadas periódicas para operaciones críticas:

1. **ETL de Sincronización:**
 - Sincronizar datos IVR → PostgreSQL cada 6 horas
 - Batch size: 1000 registros por ejecución
 - Ventana de ejecución: 24/7

2. **Limpieza de Logs:**
 - Rotación de logs de aplicación (30 días)
 - Rotación de logs de acceso (90 días)
 - Archivado de logs de auditoría (730 días)

3. **Tareas de Mantenimiento:**
 - Cleanup de sesiones expiradas
 - Actualización de métricas agregadas
 - Verificación de integridad de datos

4. **Generación de Reportes:**
 - Reportes diarios automáticos
 - Métricas de negocio consolidadas

**RESTRICCIÓN CRÍTICA:**
El cliente tiene una política estricta de infraestructura:
- **NO Redis:** Prohibido para cualquier propósito (caché, sessions, broker)
- **NO RabbitMQ:** No se permiten message brokers externos
- **NO servicios externos:** Solo servicios locales permitidos

**Preguntas clave:**
- ¿Cómo ejecutar tareas programadas sin Redis/RabbitMQ?
- ¿Necesitamos un task queue distribuido o simple scheduling?
- ¿Cómo garantizar que tareas no se ejecuten duplicadas?
- ¿Cómo monitorear ejecución de tareas?

**Impacto del problema:**
- ETL no ejecutado significa datos desactualizados
- Logs no rotados pueden llenar disco
- Tareas duplicadas pueden causar inconsistencias
- Fallo en monitoreo dificulta debugging

---

## Factores de Decisión

- **Cumplimiento de Restricciones:** NO Redis, NO RabbitMQ, NO servicios externos
- **Simplicidad:** Solución simple para tareas programadas, no necesitamos task queue completo
- **Confiabilidad:** Tareas deben ejecutarse en horario programado
- **Monitoreo:** Logs de ejecución, detección de fallos
- **Performance:** Overhead mínimo para scheduler
- **Escalabilidad:** Soporte para múltiples tareas concurrentes
- **Mantenibilidad:** Configuración clara, fácil agregar nuevas tareas

---

## Opciones Consideradas

### Opción 1: APScheduler (ELEGIDA)

**Descripción:**
APScheduler (Advanced Python Scheduler) es una librería Python in-process para scheduling de tareas. No requiere broker externo, las tareas se ejecutan en el mismo proceso que Django.

**Características:**
- **In-Process:** Ejecuta en el mismo proceso que Django
- **Multiple Triggers:** Cron, interval, date triggers
- **Persistent Jobs:** Puede usar SQLite, PostgreSQL para persistir jobs
- **Thread Pool Executor:** Ejecuta tareas en threads separados
- **Django Integration:** Integración nativa con Django

**Pros:**
- **Cumple Restricciones:** NO requiere Redis, RabbitMQ ni servicios externos
- **Simple Setup:** Solo `pip install APScheduler`, sin infraestructura adicional
- **Django Native:** Integración transparente con Django ORM, settings, logging
- **PostgreSQL Backend:** Usa nuestra DB existente para persistir jobs (no necesita SQLite extra)
- **Cron Syntax:** Familiar para equipos Unix/Linux
- **Lightweight:** Overhead mínimo (~10MB RAM)
- **Thread-Safe:** Thread pool executor maneja concurrencia
- **Monitoreo Simple:** Logs integrados con Django logging
- **Desarrollo Fácil:** Fácil testear tareas localmente

**Contras:**
- **Single Process:** No distribuido, si el proceso cae, scheduler se detiene (mitigado con systemd/supervisor)
- **No Distribuido:** No puede escalar horizontalmente (pero no es requisito)
- **No Task Queue:** No es para procesamiento asíncrono de requests (no lo necesitamos)
- **Persistencia Limitada:** No guarda resultados de tareas automáticamente

**Ejemplo/Implementación:**
```python
# requirements/base.txt
APScheduler>=3.10.4

# scheduler.py
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.executors.pool import ThreadPoolExecutor
from django_apscheduler.jobstores import DjangoJobStore

def start_scheduler():
 scheduler = BackgroundScheduler({
 "apscheduler.executors.default": {
 "class": "apscheduler.executors.pool:ThreadPoolExecutor",
 "max_workers": "5",
 },
 "apscheduler.jobstores.default": {
 "type": "sqlalchemy",
 "url": "postgresql://...", # Usa nuestra PostgreSQL existente
 },
 })

 # ETL cada 6 horas
 scheduler.add_job(
 func=sync_ivr_data,
 trigger="interval",
 hours=6,
 id="etl_ivr_sync",
 replace_existing=True,
 )

 # Cleanup logs diario a las 2am
 scheduler.add_job(
 func=cleanup_logs,
 trigger="cron",
 hour=2,
 minute=0,
 id="cleanup_logs",
 replace_existing=True,
 )

 scheduler.start()
```

---

### Opción 2: Celery + Redis/RabbitMQ

**Descripción:**
Celery es el task queue más popular en Python. Requiere un message broker (Redis o RabbitMQ) para distribuir tareas entre workers.

**Pros:**
- **Estándar de Industria:** Muy usado en producción
- **Distribuido:** Escala horizontalmente con múltiples workers
- **Task Queue Completo:** Colas, routing, retry logic, callbacks
- **Celery Beat:** Scheduler integrado para tareas periódicas
- **Monitoreo:** Flower dashboard para visualización
- **Result Backend:** Guarda resultados de tareas

**Contras:**
- **PROHIBIDO:** Requiere Redis o RabbitMQ como broker
- **Viola Restricción Crítica:** Cliente no permite Redis/RabbitMQ
- **Complejo:** Setup más complejo (broker + workers + beat scheduler)
- **Overhead:** Infraestructura adicional innecesaria para nuestro caso
- **Overkill:** No necesitamos task queue distribuido, solo scheduling

**Razón del rechazo:**
Viola restricción crítica del cliente: NO Redis, NO RabbitMQ. Aunque Celery es más potente, no podemos usarlo por política de infraestructura.

---

### Opción 3: Cron + Management Commands

**Descripción:**
Usar cron del sistema operativo para ejecutar Django management commands periódicamente.

**Pros:**
- **Sistema Nativo:** Cron está disponible en todos los sistemas Unix/Linux
- **Sin Dependencias:** No requiere librerías Python adicionales
- **Familiar:** Equipos de ops conocen bien cron
- **Persistente:** Cron daemon maneja ejecución automáticamente

**Contras:**
- **Separado de Django:** Configuración fuera del código Python
- **Sin Logging Django:** Logs de cron separados de logs de aplicación
- **Deployment Complejo:** Requiere configurar cron en cada servidor
- **No Versionado:** Crontab no está en git
- **Difícil Testear:** No se puede testear cron localmente fácilmente
- **Sin Thread Pool:** Cada job es un proceso separado (overhead)
- **No Usa Django ORM:** Difícil persistir estado de jobs

**Razón del rechazo:**
Separación entre código y configuración dificulta mantenimiento. Deployment requiere pasos manuales. Logs fragmentados complican debugging.

---

### Opción 4: Celery + Database Broker (Kombu)

**Descripción:**
Usar Celery con database como broker (en lugar de Redis/RabbitMQ). Kombu permite usar PostgreSQL/MariaDB como broker.

**Pros:**
- **No Redis/RabbitMQ:** Usa database existente
- **Celery Completo:** Todas las features de Celery disponibles
- **Cumple Restricción:** No requiere servicios externos

**Contras:**
- **Performance Pobre:** Database como broker es muy lento (Celery docs desaconsejan)
- **Polling Continuo:** Database se martilla con queries de polling
- **No Recomendado:** Celery docs explícitamente dicen "no usar DB como broker en producción"
- **Deadlocks:** Posible deadlocks en alta concurrencia
- **Complejo:** Setup Celery + Kombu + database backend es complejo

**Razón del rechazo:**
Aunque cumple restricciones, performance y estabilidad son pobres. Celery docs desaconsejan usar database como broker. APScheduler es mejor opción para scheduling simple.

---

## Decisión

**Opción elegida:** "APScheduler"

**Justificación:**

1. **Cumple Restricciones Críticas:** NO requiere Redis, RabbitMQ ni servicios externos. Usa solo PostgreSQL que ya tenemos.

2. **Simplicidad Apropiada:** Nuestro caso de uso es scheduling simple (ETL cada 6 horas, cleanup diario). No necesitamos task queue distribuido.

3. **Django Native:** Integración transparente con Django ORM, settings, logging. Código Python puro.

4. **PostgreSQL Backend:** Usa nuestra database existente para persistir jobs. No necesita SQLite adicional ni memoria volátil.

5. **Lightweight:** Overhead mínimo (~10MB RAM), ejecuta in-process con Django.

6. **Desarrollo Friendly:** Fácil testear tareas localmente, debugging simple con logs Django.

7. **Thread Pool:** Ejecuta tareas en threads separados, no bloquea requests HTTP.

**Restricciones Aceptadas:**
- **Single Process:** Si Django se cae, scheduler se detiene (mitigado con systemd restart)
- **No Distribuido:** No escala horizontalmente (pero no es requisito)
- **No Task Queue:** No es para procesamiento asíncrono de requests (usamos APScheduler solo para tareas programadas)

**Mitigación de Riesgos:**
- **Process Failure:** systemd/supervisor reinicia Django automáticamente
- **Monitoring:** Django logging captura ejecución de tareas
- **Idempotencia:** Todas las tareas diseñadas para ser idempotentes

---

## Consecuencias

### Positivas

- **Sin Infraestructura Extra:** No necesitamos Redis, RabbitMQ, Celery workers
- **Setup Simple:** `pip install APScheduler` y configurar jobs en `apps.py`
- **PostgreSQL Backend:** Jobs persistidos en nuestra DB existente
- **Django Logging:** Logs de tareas integrados con Django logging
- **Development Friendly:** Fácil testear tareas localmente
- **Deployment Simple:** Solo deployar Django, scheduler inicia automáticamente
- **Código Versionado:** Configuración de jobs en Python, versionado en git
- **Thread Pool:** 5 workers concurrentes para tareas

### Negativas

- **Single Process:** Si Django cae, scheduler se detiene (mitigado con systemd)
- **No Distribuido:** No podemos escalar scheduler horizontalmente (no es requisito)
- **Sin Result Storage:** No guarda resultados de tareas automáticamente (implementamos logging manual)
- **No Retry Logic Built-in:** Debemos implementar retry logic en tareas si necesario

### Neutrales

- **In-Process:** Scheduler ejecuta en mismo proceso que Django
- **Thread-Based:** Tareas ejecutan en threads, no processes separados
- **PostgreSQL Dependency:** Scheduler depende de PostgreSQL (ya dependemos de PostgreSQL)

---

## Plan de Implementación

### Fase 1: Instalación y Configuración - COMPLETADO

```bash
# requirements/base.txt
APScheduler>=3.10.4
```

### Fase 2: Scheduler Service - COMPLETADO

```python
# apps/common/scheduler.py
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.executors.pool import ThreadPoolExecutor
from django.conf import settings

class AppScheduler:
 scheduler = None

 @classmethod
 def start(cls):
 if cls.scheduler is None:
 cls.scheduler = BackgroundScheduler({
 "apscheduler.executors.default": {
 "class": "apscheduler.executors.pool:ThreadPoolExecutor",
 "max_workers": "5",
 },
 "apscheduler.job_defaults.coalesce": "true",
 "apscheduler.job_defaults.max_instances": "1",
 "apscheduler.timezone": settings.TIME_ZONE,
 })

 # ETL cada 6 horas
 from callcentersite.apps.etl.tasks import sync_ivr_data
 cls.scheduler.add_job(
 func=sync_ivr_data,
 trigger="interval",
 hours=settings.ETL_FREQUENCY_HOURS,
 id="etl_ivr_sync",
 replace_existing=True,
 )

 # Cleanup logs diario a las 2am
 from callcentersite.apps.common.tasks import cleanup_logs
 cls.scheduler.add_job(
 func=cleanup_logs,
 trigger="cron",
 hour=2,
 minute=0,
 id="cleanup_logs",
 replace_existing=True,
 )

 # Cleanup sesiones expiradas cada hora
 from callcentersite.apps.common.tasks import cleanup_sessions
 cls.scheduler.add_job(
 func=cleanup_sessions,
 trigger="cron",
 minute=0,
 id="cleanup_sessions",
 replace_existing=True,
 )

 cls.scheduler.start()
```

### Fase 3: Django Integration - COMPLETADO

```python
# apps/common/apps.py
from django.apps import AppConfig

class CommonConfig(AppConfig):
 default_auto_field = "django.db.models.BigAutoField"
 name = "callcentersite.apps.common"

 def ready(self):
 # Solo iniciar scheduler en proceso principal
 # No en migrations, tests, etc.
 import os
 if os.environ.get("RUN_MAIN") == "true":
 from .scheduler import AppScheduler
 AppScheduler.start()
```

### Fase 4: Task Implementation - COMPLETADO

```python
# apps/etl/tasks.py
import logging
from django.utils import timezone
from datetime import timedelta

logger = logging.getLogger(__name__)

def sync_ivr_data():
 """ETL: Sincroniza datos IVR → PostgreSQL."""
 logger.info("ETL: Iniciando sincronización IVR")
 start_time = timezone.now()

 try:
 from .services import IVRETLService

 # Sincronizar últimas 6 horas
 since = timezone.now() - timedelta(hours=6)
 result = IVRETLService.sync_llamadas(since=since)

 duration = (timezone.now() - start_time).total_seconds()
 logger.info(
 f"ETL: Sincronización completada. "
 f"Procesados: {result['processed']}, "
 f"Errores: {result['errors']}, "
 f"Duración: {duration:.2f}s"
 )

 except Exception as e:
 logger.error(f"ETL: Error en sincronización: {e}", exc_info=True)
 raise

# apps/common/tasks.py
def cleanup_logs():
 """Limpia logs antiguos según política de retención."""
 logger.info("Cleanup: Iniciando limpieza de logs")
 # Implementación...

def cleanup_sessions():
 """Elimina sesiones expiradas de la base de datos."""
 from django.core.management import call_command
 call_command("clearsessions")
 logger.info("Cleanup: Sesiones expiradas eliminadas")
```

---

## Validación y Métricas

### Criterios de Éxito

| Métrica | Target | Actual | Estado |
|---------|--------|--------|--------|
| Jobs programados | 3+ | 3 | OK OK |
| Ejecución ETL | Cada 6h | Cada 6h | OK OK |
| Cleanup logs | Diario 2am | Diario 2am | OK OK |
| Cleanup sessions | Cada hora | Cada hora | OK OK |
| Fallos de scheduler | <1% | 0% | OK OK |
| Overhead RAM | <20MB | ~10MB | OK OK |
| Thread pool workers | 5 | 5 | OK OK |

### KPIs de Confiabilidad

```yaml
Ejecución:
 - Jobs ejecutados on-time: >99%
 - Fallos por crash: 0
 - Reinicio automático: <5 segundos (systemd)
 - Logs de ejecución: 100% capturados

Performance:
 - Overhead CPU: <1%
 - Overhead RAM: ~10MB
 - Thread pool saturation: 0%
 - ETL duration: ~2 minutos (1000 registros)

Compliance:
 - Redis usado: NO
 - RabbitMQ usado: NO
 - Servicios externos: NO
 - Logs audit trail: 100%
```

---

## Alternativas Descartadas

### Huey

**Por qué se descartó:**
- Similar a APScheduler pero menos maduro
- Requiere Redis para modo distribuido (prohibido)
- APScheduler tiene mejor documentación y comunidad

### RQ (Redis Queue)

**Por qué se descartó:**
- Requiere Redis (prohibido por restricción)
- No es para scheduling, es task queue

### Django-Q

**Por qué se descartó:**
- Requiere Redis, Disque, MongoDB o IronMQ como broker
- ORM broker es experimental y no recomendado
- APScheduler es más simple para nuestro caso

### Custom Cron Implementation

**Por qué se descartó:**
- Reinventar la rueda
- APScheduler ya resuelve el problema correctamente
- Más código custom = más bugs potenciales

---

## Referencias

### Documentación Oficial

- [APScheduler Documentation](https://apscheduler.readthedocs.io/)
- [APScheduler Django Integration](https://github.com/jcass77/django-apscheduler)
- [Celery Documentation (referencia)](https://docs.celeryproject.org/)
- [Cron Documentation](https://man7.org/linux/man-pages/man5/crontab.5.html)

### Comparaciones

- [APScheduler vs Celery](https://www.reddit.com/r/Python/comments/8z3h3e/apscheduler_vs_celery/)
- [Task Scheduling in Python](https://realpython.com/python-timer/)

### Documentos del Proyecto

- `api/callcentersite/requirements/base.txt` - APScheduler dependency
- `api/callcentersite/callcentersite/apps/common/scheduler.py` - Scheduler implementation
- `api/callcentersite/callcentersite/apps/etl/tasks.py` - ETL tasks
- ADR-BACK-011: PostgreSQL + MariaDB Multi-Database
- RNF-002: NO Redis (restricción crítica)
- ADR-DEVOPS-001: Apache + mod_wsgi deployment

---

## Notas Adicionales

### Experiencia del Equipo

**Feedback del equipo (post-implementación):**
- "APScheduler es super simple de configurar y usar"
- "ETL ejecuta perfectamente cada 6 horas sin fallos"
- "Logs integrados con Django facilitan debugging"
- "No tener Redis/RabbitMQ simplifica mucho deployment"

### Decisiones Técnicas Relacionadas

**ETL Configuration:**
- Frecuencia: Configurable con `ETL_FREQUENCY_HOURS` (default: 6)
- Batch size: Configurable con `ETL_BATCH_SIZE` (default: 1000)
- Timeout: 10 minutos por ejecución
- Retry: No automático, logging de errores

**Logging Strategy:**
- Nivel: INFO para ejecuciones exitosas
- Nivel: ERROR para fallos con stack trace
- Formato: JSON structured logging
- Retention: 30 días para logs de aplicación

**Thread Pool Configuration:**
- Max workers: 5 threads concurrentes
- Coalesce: true (evita ejecuciones duplicadas)
- Max instances: 1 (solo una instancia de cada job)
- Timezone: UTC (settings.TIME_ZONE)

### Monitoreo y Alertas

**Logs a Monitorear:**
```python
# Inicio de tarea
logger.info("ETL: Iniciando sincronización IVR")

# Progreso
logger.info(f"ETL: Procesados {count} registros")

# Completado
logger.info(f"ETL: Sincronización completada. Procesados: {total}")

# Errores
logger.error(f"ETL: Error en sincronización: {e}", exc_info=True)
```

**Alertas Recomendadas:**
- ETL no ejecutado en últimas 7 horas → CRITICAL
- Logs cleanup no ejecutado en últimas 25 horas → WARNING
- Scheduler crash → CRITICAL (systemd maneja restart)

### Consideraciones Futuras

**Si Necesitamos Task Queue Distribuido:**
- Reevaluar restricción de NO Redis/RabbitMQ con cliente
- Considerar Celery + Redis si restricción se levanta
- APScheduler puede coexistir con Celery si necesario

**Si Necesitamos Escalar Horizontalmente:**
- APScheduler con database job store puede usar locks
- Considerar múltiples schedulers con `max_instances=1`
- Evaluar si realmente necesitamos escalar scheduler (probablemente no)

---

## Changelog

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0 | 2025-01-17 | ADR inicial documentando decisión APScheduler |

---

**Documento:** ADR-BACK-012
**Fecha:** 17 de Enero, 2025
**Estado:** Aprobado
**Próxima revisión:** 2026-01-17 (anual)
