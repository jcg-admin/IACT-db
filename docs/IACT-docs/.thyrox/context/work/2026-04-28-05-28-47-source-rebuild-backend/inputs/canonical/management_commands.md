---
title: Django Management Commands - Guia Centralizada
date: 2025-11-13
domain: backend
status: active
---

# Django Management Commands - Guia Centralizada

**Autor**: Backend Team
**Fecha**: 2025-11-09
**Estado**: ACTIVO

## Indice

- [Resumen Ejecutivo](#resumen-ejecutivo)
- [Comandos Disponibles](#comandos-disponibles)
- [Uso y Ejemplos](#uso-y-ejemplos)
- [Troubleshooting](#troubleshooting)
- [Referencias](#referencias)

---

## Resumen Ejecutivo

El proyecto IACT incluye **5 management commands custom** de Django para operaciones administrativas y de mantenimiento:

| Comando | App | Proposito | Frecuencia |
|---------|-----|-----------|------------|
| `seed_permisos_granular` | users | Poblar permisos | Una vez (setup inicial) |
| `seed_configuraciones_default` | configuration | Poblar configuraciones | Una vez (setup inicial) |
| `run_etl` | etl | Ejecutar ETL | Programado (cron) |
| `apply_retention` | data_centralization | Aplicar retention | Programado (cron) |
| `profile_code` | common | Profiling de codigo | On-demand |

**Ubicacion**: `api/callcentersite/*/management/commands/*.py`

**Ejecucion**:
```bash
cd api/callcentersite
python manage.py <comando> [opciones]
```

---

## Comandos Disponibles

### 1. seed_permisos_granular

**App**: `users`
**Ubicacion**: `callcentersite/apps/users/management/commands/seed_permisos_granular.py`

**Proposito**: Poblar sistema de permisos granular con datos iniciales

**Datos creados**:
- **13 funciones** del sistema (usuarios, dashboards, configuracion, llamadas, tickets, etc.)
- **78 capacidades** granulares (crear, editar, eliminar, ver, etc.)
- **10 grupos funcionales** (administracion_usuarios, atencion_cliente, supervisor, etc.)
- **Relaciones funcion-capacidades** (N:M)
- **Relaciones grupo-capacidades** (N:M)

**Uso**:
```bash
python manage.py seed_permisos_granular
```

**Salida esperada**:
```
Iniciando seed de permisos granular...
Creando funciones...
Creando capacidades...
Creando grupos...
Asignando capacidades a grupos...
Seed completado exitosamente
```

**Transaccionalidad**: ATOMIC (todo o nada)

**Idempotencia**: NO - falla si datos ya existen

**Precondiciones**:
- Base de datos migrada (tablas de permisos creadas)
- Sin datos previos en: `funciones`, `capacidades`, `grupos_permisos`

**Postcondiciones**:
- Sistema de permisos completamente poblado
- Listo para asignar grupos a usuarios

**Casos de uso**:
1. Setup inicial de proyecto (post-migrations)
2. Re-seed despues de eliminar datos de permisos

**Referencia**: `docs/backend/requisitos/CATALOGO_GRUPOS_FUNCIONALES.md`

**Ejemplo completo**:
```bash
# Verificar que tablas existen
python manage.py showmigrations users

# Ejecutar seed
python manage.py seed_permisos_granular

# Verificar resultados
python manage.py shell
>>> from callcentersite.apps.users.models_permisos_granular import Funcion, Capacidad, GrupoPermiso
>>> Funcion.objects.count() # Esperado: 13
>>> Capacidad.objects.count() # Esperado: 78
>>> GrupoPermiso.objects.count() # Esperado: 10
```

**Troubleshooting**:
```
ERROR: IntegrityError - duplicate key value violates unique constraint
CAUSA: Datos ya existen
SOLUCION: Eliminar datos existentes o usar fresh database
```

---

### 2. seed_configuraciones_default

**App**: `configuration`
**Ubicacion**: `callcentersite/apps/configuration/management/commands/seed_configuraciones_default.py`

**Proposito**: Poblar configuraciones por defecto del sistema

**Categorias creadas**:
1. **Seguridad** (8 configuraciones)
 - session_timeout: 900 segundos
 - password_min_length: 8 caracteres
 - password_require_uppercase: true
 - password_require_numbers: true
 - password_require_special: true
 - max_login_attempts: 3
 - lockout_duration: 900 segundos
 - password_expiry_days: 90 dias

2. **Notificaciones** (5 configuraciones)
 - email_enabled: false
 - sms_enabled: false
 - push_enabled: true
 - notification_retention_days: 30
 - max_notifications_per_user: 100

3. **Llamadas** (6 configuraciones)
 - max_call_duration: 3600 segundos
 - enable_call_recording: true
 - recording_retention_days: 90
 - auto_pause_threshold: 300 segundos
 - enable_call_transfer: true
 - max_concurrent_calls: 50

4. **Tickets** (7 configuraciones)
 - auto_assignment_enabled: true
 - default_priority: medium
 - sla_critical: 1 hora
 - sla_high: 4 horas
 - sla_medium: 24 horas
 - sla_low: 72 horas
 - ticket_retention_days: 365

5. **Reportes** (5 configuraciones)
 - default_format: pdf
 - max_report_rows: 10000
 - report_generation_timeout: 300 segundos
 - enable_scheduled_reports: true
 - report_retention_days: 90

6. **Sistema** (6 configuraciones)
 - maintenance_mode: false
 - debug_mode: false
 - log_level: INFO
 - max_log_file_size: 100 MB
 - log_retention_days: 30
 - enable_profiling: false

7. **Integraciones** (3 configuraciones)
 - api_rate_limit: 100 req/min
 - api_timeout: 30 segundos
 - enable_webhooks: false

**Total**: ~40 configuraciones

**Uso**:
```bash
python manage.py seed_configuraciones_default
```

**Salida esperada**:
```
Iniciando seed de configuraciones por defecto...
Creando configuraciones de seguridad...
Creando configuraciones de notificaciones...
Creando configuraciones de llamadas...
Creando configuraciones de tickets...
Creando configuraciones de reportes...
Creando configuraciones de sistema...
Creando configuraciones de integraciones...
Seed completado: 40 configuraciones creadas
```

**Transaccionalidad**: ATOMIC

**Idempotencia**: SI (usa get_or_create)

**Precondiciones**:
- Tabla `configuracion` creada (migrations aplicadas)

**Postcondiciones**:
- Configuraciones disponibles para toda la aplicacion
- Sistema listo para operacion

**Casos de uso**:
1. Setup inicial post-migrations
2. Restaurar configuraciones borradas accidentalmente

**Referencia**: `docs/PLAN_MAESTRO_PRIORIDAD_02.md` (Tarea 9)

**Ejemplo completo**:
```bash
# Ejecutar seed
python manage.py seed_configuraciones_default

# Verificar configuraciones creadas
python manage.py shell
>>> from callcentersite.apps.configuration.models import Configuracion
>>> Configuracion.objects.filter(categoria='seguridad').count() # Esperado: 8
>>> config = Configuracion.objects.get(clave='seguridad.session_timeout')
>>> config.get_valor_typed() # Esperado: 900 (int)
```

**Modificar configuracion post-seed**:
```bash
python manage.py shell
>>> from callcentersite.apps.configuration.models import Configuracion
>>> config = Configuracion.objects.get(clave='seguridad.session_timeout')
>>> config.valor = '1800' # 30 minutos
>>> config.save()
```

---

### 3. run_etl

**App**: `etl`
**Ubicacion**: `callcentersite/apps/etl/management/commands/run_etl.py`

**Proposito**: Ejecutar proceso ETL completo manualmente

**Descripcion**:
El comando ejecuta el pipeline ETL que:
1. **Extrae** datos de base legacy (MariaDB - ivr_legacy)
2. **Transforma** datos segun reglas de negocio
3. **Carga** datos transformados a PostgreSQL (iact_analytics)

**Uso**:
```bash
python manage.py run_etl
```

**Salida esperada**:
```
Iniciando proceso ETL...
[INFO] Extrayendo datos de base legacy...
[INFO] Extraccion completada: 1500 registros
[INFO] Transformando datos...
[INFO] Transformacion completada: 1450 registros validos
[INFO] Cargando datos a analytics...
[INFO] Carga completada: 1450 registros insertados
Proceso ETL ejecutado correctamente
```

**Transaccionalidad**: Depende de implementacion en `etl.jobs.run_etl()`

**Idempotencia**: Depende de logica (idealmente SI)

**Precondiciones**:
- Base legacy (MariaDB) accesible
- Base analytics (PostgreSQL) accesible
- Tablas de destino creadas

**Postcondiciones**:
- Datos legacy sincronizados a analytics

**Casos de uso**:
1. Ejecucion manual de ETL (testing)
2. Re-procesar datos especificos
3. Backup/debugging

**Programacion (cron)**:
```bash
# Ejecutar cada hora
0 * * * * cd /path/to/project && python manage.py run_etl >> /var/log/etl.log 2>&1
```

**Referencia**: `docs/backend/arquitectura/etl.md`

**Ejemplo con logging**:
```bash
# Ejecutar con logging detallado
python manage.py run_etl --verbosity=2 2>&1 | tee etl_$(date +%Y%m%d_%H%M%S).log
```

**Troubleshooting**:
```
ERROR: OperationalError - database connection failed
CAUSA: Base legacy no accesible
SOLUCION: Verificar configuracion DATABASES['legacy']

ERROR: IntegrityError - duplicate key
CAUSA: Datos ya existen en analytics
SOLUCION: Implementar upsert logic o limpiar datos
```

---

### 4. apply_retention

**App**: `data_centralization`
**Ubicacion**: `callcentersite/data_centralization/management/commands/apply_retention.py`

**Proposito**: Aplicar politicas de retencion de datos

**Descripcion**:
Elimina datos antiguos segun politicas configuradas:
- Logs antiguos (> 30 dias)
- Notificaciones leidas (> 60 dias)
- Reportes generados (> 90 dias)
- Datos anonimizados (> 365 dias)

**Uso**:
```bash
python manage.py apply_retention
```

**Opciones**:
```bash
# Dry-run (no eliminar, solo mostrar)
python manage.py apply_retention --dry-run

# Forzar eliminacion sin confirmacion
python manage.py apply_retention --force

# Aplicar solo a tabla especifica
python manage.py apply_retention --table=audit_logs
```

**Salida esperada**:
```
Aplicando politicas de retencion...
[INFO] audit_logs: 1200 registros > 30 dias
[INFO] notifications: 450 registros > 60 dias
[INFO] reports: 230 registros > 90 dias
Total a eliminar: 1880 registros
¿Confirmar eliminacion? (yes/no): yes
Eliminando...
[SUCCESS] 1880 registros eliminados
Espacio liberado: 85 MB
```

**Transaccionalidad**: ATOMIC por tabla

**Idempotencia**: SI (puede ejecutarse multiples veces)

**Precondiciones**:
- Configuraciones de retencion definidas

**Postcondiciones**:
- Datos antiguos eliminados
- Espacio en disco liberado

**Casos de uso**:
1. Mantenimiento programado (semanal/mensual)
2. Liberar espacio en disco urgente
3. Compliance (GDPR - derecho al olvido)

**Programacion (cron)**:
```bash
# Ejecutar semanalmente (domingo 2 AM)
0 2 * * 0 cd /path/to/project && python manage.py apply_retention --force >> /var/log/retention.log 2>&1
```

**Troubleshooting**:
```
ERROR: No retention policies configured
CAUSA: Configuraciones ausentes
SOLUCION: Crear configuraciones de retencion

WARNING: Large deletion detected (> 10000 rows)
CAUSA: Retention no ejecutada por mucho tiempo
SOLUCION: Ejecutar en horario de bajo trafico
```

---

### 5. profile_code

**App**: `common`
**Ubicacion**: `callcentersite/apps/common/management/commands/profile_code.py`

**Proposito**: Profiling de codigo para analisis de performance

**Descripcion**:
Ejecuta profiling de codigo Python para identificar:
- Funciones lentas
- Cuellos de botella
- Queries N+1
- Llamadas innecesarias

**Uso**:
```bash
# Profiling de endpoint especifico
python manage.py profile_code --endpoint=/api/dashboard/ --method=GET

# Profiling de function Python
python manage.py profile_code --function=callcentersite.apps.analytics.services.calculate_metrics

# Profiling con parametros
python manage.py profile_code --endpoint=/api/reports/ --params='{"start_date":"2025-01-01"}'
```

**Opciones**:
```bash
--endpoint URL del endpoint a profilear
--method HTTP method (GET, POST, etc.)
--function Function Python a profilear
--params Parametros JSON
--iterations Numero de ejecuciones (default: 10)
--output Archivo de salida (default: stdout)
```

**Salida esperada**:
```
Profiling endpoint: /api/dashboard/ (GET)
Iterations: 10
==========================================
Function Calls Time (ms) % Total
callcentersite.services.calculate_stats 1 350.2 45.2%
django.db.backends.execute 120 280.5 36.2%
django.core.serializers 1 120.3 15.5%
...
==========================================
Total time: 775.2 ms
Avg per iteration: 77.5 ms
Recommendations:
- Consider caching calculate_stats results
- Optimize database queries (N+1 detected)
- Use select_related for foreign keys
```

**Transaccionalidad**: NO (solo lectura)

**Idempotencia**: SI (puede ejecutarse multiples veces)

**Precondiciones**:
- Endpoint o function a profilear existe
- Datos de prueba disponibles

**Postcondiciones**:
- Reporte de profiling generado

**Casos de uso**:
1. Debugging de performance issues
2. Optimizacion de endpoints lentos
3. Analisis de queries

**Referencia**: `docs/infraestructura/performance-tuning.md`

**Ejemplo completo**:
```bash
# Profiling de endpoint lento
python manage.py profile_code \
 --endpoint=/api/reports/call-analytics/ \
 --method=POST \
 --params='{"date_from":"2025-01-01","date_to":"2025-01-31"}' \
 --iterations=5 \
 --output=profiling_report.txt

# Ver reporte
cat profiling_report.txt
```

---

## Uso y Ejemplos

### Setup Inicial Completo

**Orden recomendado** para setup inicial:

```bash
cd api/callcentersite

# 1. Aplicar migraciones
python manage.py migrate

# 2. Poblar permisos granular
python manage.py seed_permisos_granular

# 3. Poblar configuraciones
python manage.py seed_configuraciones_default

# 4. Crear superuser
python manage.py createsuperuser

# 5. Verificar
python manage.py shell
>>> from callcentersite.apps.users.models_permisos_granular import Funcion
>>> Funcion.objects.count() # Esperado: 13
>>> from callcentersite.apps.configuration.models import Configuracion
>>> Configuracion.objects.count() # Esperado: ~40
```

---

### Ejecucion Programada (Cron)

**Archivo**: `/etc/cron.d/iact-django-commands`

```bash
# ETL cada hora
0 * * * * django_user cd /opt/iact/api/callcentersite && python manage.py run_etl >> /var/log/iact/etl.log 2>&1

# Retention semanal (domingo 2 AM)
0 2 * * 0 django_user cd /opt/iact/api/callcentersite && python manage.py apply_retention --force >> /var/log/iact/retention.log 2>&1

# Backup de configuraciones diario (lunes a viernes 3 AM)
0 3 * * 1-5 django_user cd /opt/iact/api/callcentersite && python manage.py dumpdata configuration --output=/backups/config_$(date +\%Y\%m\%d).json
```

---

### Docker Exec

**Ejecutar comandos en container Docker**:

```bash
# Con docker-compose
docker-compose exec app python manage.py seed_permisos_granular

# Con docker run
docker exec -it iact-backend python manage.py run_etl

# Con DevContainer (VS Code)
# Terminal dentro del DevContainer:
python manage.py profile_code --endpoint=/api/dashboard/
```

---

### Logging y Debugging

**Verbose output**:
```bash
# Django verbose level 2
python manage.py run_etl --verbosity=2

# Django verbose level 3 (max)
python manage.py seed_permisos_granular --verbosity=3
```

**Redireccion de logs**:
```bash
# Stdout + Stderr a archivo
python manage.py run_etl > etl.log 2>&1

# Stdout a archivo, Stderr a terminal
python manage.py run_etl > etl.log

# Tee (ver y guardar simultaneamente)
python manage.py apply_retention | tee retention_$(date +%Y%m%d).log
```

---

## Troubleshooting

### Comando no encontrado

**Sintoma**:
```
Unknown command: 'seed_permisos_granular'
```

**Causa**: App no en INSTALLED_APPS o comando mal escrito

**Solucion**:
```bash
# Verificar apps instaladas
python manage.py shell
>>> from django.conf import settings
>>> 'callcentersite.apps.users' in settings.INSTALLED_APPS # True?

# Listar comandos disponibles
python manage.py help
```

---

### Import Error

**Sintoma**:
```
ImportError: No module named 'callcentersite.apps.users'
```

**Causa**: PYTHONPATH no configurado o virtualenv no activado

**Solucion**:
```bash
# Activar virtualenv
source /opt/python-3.12.6/bin/activate # DevContainer
# O
source venv/bin/activate # Local

# Verificar instalacion
pip list | grep Django
```

---

### Database Error

**Sintoma**:
```
django.db.utils.OperationalError: FATAL: database does not exist
```

**Causa**: Base de datos no creada o configuracion incorrecta

**Solucion**:
```bash
# Verificar configuracion
python manage.py shell
>>> from django.conf import settings
>>> settings.DATABASES['default']

# Crear database
psql -U postgres -c "CREATE DATABASE iact_analytics;"

# Aplicar migraciones
python manage.py migrate
```

---

### Transaction Rollback

**Sintoma**:
```
django.db.transaction.TransactionManagementError: An error occurred in the current transaction
```

**Causa**: Error dentro de transaction.atomic()

**Solucion**:
```bash
# Ver error completo con verbosity
python manage.py seed_permisos_granular --verbosity=2 --traceback

# Limpiar transacciones pendientes
python manage.py shell
>>> from django.db import connection
>>> connection.close()
```

---

## Referencias

### Documentacion Interna

- [Migrations Strategy](migrations-strategy.md)
- [Configuration App](arquitectura/configuration.md)
- [Users App - Permisos Granulares](arquitectura/users.md)
- [ETL App](arquitectura/etl.md)

### Django Documentation

- [Writing Custom Management Commands](https://docs.djangoproject.com/en/4.2/howto/custom-management-commands/)
- [Transaction Management](https://docs.djangoproject.com/en/4.2/topics/db/transactions/)
- [Database Migrations](https://docs.djangoproject.com/en/4.2/topics/migrations/)

---

## Changelog

### v1.0.0 (2025-11-09)
- Version inicial de documentacion
- 5 management commands documentados
- Ejemplos de uso y troubleshooting
- Guia de setup inicial y cron jobs

---

**Ultima actualizacion**: 2025-11-09
**Mantenedor**: Backend Team
**Estado de documentacion**: COMPLETO
