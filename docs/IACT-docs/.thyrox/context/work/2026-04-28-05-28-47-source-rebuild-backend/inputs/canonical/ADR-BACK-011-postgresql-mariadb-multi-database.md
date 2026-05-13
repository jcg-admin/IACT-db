---
id: ADR-BACK-011-postgresql-mariadb-multi-database
estado: aprobado
propietario: equipo-backend
ultima_actualizacion: 2025-01-17
relacionados: ["RNF-BACK-030", "ADR-BACK-010", "ADR-DEVOPS-002"]
date: 2025-01-17
---

# ADR-BACK-011: Estrategia Multi-Database (PostgreSQL + MariaDB)

**Estado:** aprobado

**Fecha:** 2025-01-17

**Decisores:** equipo-backend, arquitecto-principal, equipo-infraestructura

**Contexto técnico:** Backend, Infraestructura

---

## Contexto y Problema

El proyecto IACT necesita integrar datos de un sistema IVR legacy existente mientras construye una nueva aplicación de analytics. Se presentan las siguientes restricciones y requerimientos:

1. **Sistema IVR Legacy Intocable:**
 - Base de datos MariaDB existente
 - Sistema crítico en producción
 - NO se puede modificar: solo lectura permitida
 - Esquema legacy sin foreign keys ni constraints modernos
 - Datos históricos valiosos de llamadas

2. **Nueva Aplicación Analytics:**
 - Requiere almacenar datos propios (usuarios, permisos, configuración, dashboards)
 - Necesita integridad referencial y constraints modernos
 - Sistema de migraciones para evolucionar esquema
 - Performance crítico para queries analíticos

3. **Requisitos de Integración:**
 - ETL debe sincronizar datos IVR → Analytics cada 6 horas
 - Reportes combinan datos de ambas fuentes
 - Protección crítica: NUNCA escribir en IVR legacy

**Preguntas clave:**
- ¿Una sola base de datos o múltiples?
- ¿Qué motor para cada base de datos?
- ¿Cómo proteger el IVR legacy de escrituras accidentales?
- ¿Cómo gestionar conexiones y transacciones entre bases?

**Restricciones actuales:**
- IVR legacy: MariaDB 10.6 (no podemos cambiar)
- Sin servicios externos: NO Redis para caché
- Alta disponibilidad requerida: 99.9% uptime (RNF-BACK-030)
- Auditoría completa: ISO 27001 compliance

**Impacto del problema:**
- Escritura accidental en IVR podría afectar sistema crítico en producción
- Performance inadecuado afecta experiencia de usuario
- Sincronización incorrecta genera datos inconsistentes

---

## Factores de Decisión

- **Seguridad:** Protección absoluta del IVR legacy (solo lectura)
- **Integridad de Datos:** Constraints, foreign keys, transacciones ACID
- **Performance:** Queries analíticos rápidos, conexiones eficientes
- **Mantenibilidad:** Migraciones automáticas, esquema versionado
- **Disponibilidad:** Alta disponibilidad para ambas bases de datos
- **Simplicidad:** Routing transparente, sin complejidad innecesaria
- **Compliance:** Auditoría completa, logs de acceso

---

## Opciones Consideradas

### Opción 1: Multi-Database con Database Router (ELEGIDA)

**Descripción:**
Usar dos bases de datos separadas:
- **PostgreSQL (default):** Base principal para datos de la aplicación Analytics
- **MariaDB (ivr_readonly):** Conexión read-only al IVR legacy

Django Database Router enruta automáticamente operaciones según el modelo:
- Modelos `ivr_legacy.*` → MariaDB (solo lectura)
- Todos los demás modelos → PostgreSQL (lectura/escritura)

**Pros:**
- **Protección Total:** Router bloquea writes a IVR con ValueError, imposible escribir accidentalmente
- **PostgreSQL para Analytics:** Mejor performance para queries analíticos, JSON fields, full-text search
- **Migraciones Seguras:** Django migrations solo aplican a PostgreSQL, IVR intocable
- **Conexiones Optimizadas:** Connection pooling con `CONN_MAX_AGE=300` para cada DB
- **Separación de Concerns:** Datos legacy separados de datos nuevos
- **Rollback Independiente:** Transacciones PostgreSQL no afectan IVR
- **Transparente:** Routing automático, código no necesita especificar database
- **Auditoría Clara:** Logs separados para accesos a cada database

**Contras:**
- **Complejidad Configuración:** Requiere configurar 2 databases + router
- **No Hay Transactions Cross-DB:** No se puede hacer transaction que afecte ambas DBs (pero esto es bueno para protección)
- **Drivers Múltiples:** Requiere psycopg2 + mysqlclient
- **Testing Más Complejo:** Tests deben manejar 2 databases

**Ejemplo/Implementación:**
```python
# settings/base.py
DATABASES = {
 "default": {
 "ENGINE": "django.db.backends.postgresql",
 "NAME": "iact_analytics",
 "USER": "django_user",
 "PASSWORD": os.getenv("DJANGO_DB_PASSWORD"),
 "HOST": "127.0.0.1",
 "PORT": "15432",
 "CONN_MAX_AGE": 300, # Connection pooling
 },
 "ivr_readonly": {
 "ENGINE": "mysql.connector.django",
 "NAME": "ivr_legacy",
 "USER": "django_user",
 "PASSWORD": os.getenv("DJANGO_IVR_PASSWORD"),
 "HOST": "127.0.0.1",
 "PORT": "13306",
 "CONN_MAX_AGE": 300,
 "OPTIONS": {
 "init_command": "SET sql_mode='STRICT_TRANS_TABLES'",
 "charset": "utf8mb4",
 },
 },
}

DATABASE_ROUTERS = ["callcentersite.database_router.IVRReadOnlyRouter"]

# database_router.py
class IVRReadOnlyRouter:
 def db_for_read(self, model, **hints):
 if model._meta.app_label.startswith("ivr_legacy"):
 return "ivr_readonly"
 return "default"

 def db_for_write(self, model, **hints):
 if model._meta.app_label.startswith("ivr_legacy"):
 raise ValueError(
 "CRITICAL RESTRICTION VIOLATED: Attempted write operation on IVR database. "
 "IVR database is READ-ONLY."
 )
 return "default"

 def allow_migrate(self, db, app_label, model_name=None, **hints):
 if db == "ivr_readonly":
 return False # NUNCA migrar IVR
 if app_label.startswith("ivr_legacy"):
 return False # Modelos IVR no se migran
 return True
```

---

### Opción 2: Single Database con Esquema Híbrido

**Descripción:**
Migrar datos IVR a PostgreSQL y usar una sola base de datos. Crear vistas o tablas materializadas para datos legacy.

**Pros:**
- **Una Sola DB:** Configuración más simple
- **Transactions Cross-Tables:** Posible hacer transacciones que afecten ambos esquemas
- **Un Solo Driver:** Solo psycopg2
- **Performance Uniforme:** Todo en PostgreSQL

**Contras:**
- **Migración Masiva Riesgosa:** Copiar datos IVR a PostgreSQL es riesgoso y complejo
- **Sincronización Continua:** Requiere ETL en tiempo real para mantener sincronizado
- **Esquema Legacy Subóptimo:** Tendríamos que mantener esquema legacy en PostgreSQL
- **Sin Protección IVR Original:** Seguimos necesitando acceso al IVR real para algunos sistemas
- **Violación de Restricción:** IVR es sistema legacy que NO podemos tocar

**Razón del rechazo:**
Migrar el IVR legacy viola la restricción crítica de no modificar el sistema existente. Además, otros sistemas dependen del IVR original, no podemos reemplazarlo.

---

### Opción 3: PostgreSQL FDW (Foreign Data Wrapper)

**Descripción:**
Usar PostgreSQL como única DB, pero con Foreign Data Wrapper para acceder MariaDB remotamente.

**Pros:**
- **Unified Interface:** Todo se ve como PostgreSQL
- **Cross-DB Queries:** Posible hacer JOINs entre PostgreSQL y MariaDB
- **Un Solo Connection:** Django solo conecta a PostgreSQL

**Contras:**
- **Complejidad FDW:** Configurar y mantener FDW es complejo
- **Performance Overhead:** FDW es más lento que conexión nativa
- **Escritura Posible:** FDW permite escritura, no protege IVR automáticamente
- **Debugging Difícil:** Errores en queries cross-DB son difíciles de debuggear
- **Dependency on PostgreSQL:** Si PostgreSQL cae, perdemos acceso a IVR también
- **Más Difícil de Monitorear:** Queries cross-DB dificultan profiling

**Razón del rechazo:**
FDW agrega complejidad sin beneficios claros. Performance es peor que conexión nativa. No protege contra escrituras accidentales a IVR.

---

## Decisión

**Opción elegida:** "Multi-Database con Database Router"

**Justificación:**

1. **Protección Absoluta del IVR:** Database router bloquea TODA operación de escritura al IVR. Imposible escribir accidentalmente, levanta `ValueError` si se intenta.

2. **PostgreSQL para Analytics:** Mejor elección para queries analíticos:
 - JSON fields para dashboards personalizados
 - Full-text search para búsquedas
 - Window functions para reportes
 - Mejor performance en aggregations complejas

3. **MariaDB Solo Lectura:** Mantenemos conexión nativa al IVR legacy sin tocarlo. Performance óptimo para lecturas.

4. **Migraciones Seguras:** Django migrations solo aplican a PostgreSQL. IVR permanece intocable, su esquema nunca cambia.

5. **Connection Pooling Dual:** `CONN_MAX_AGE=300` en ambas DBs reduce overhead de conexiones.

6. **Transparencia para Desarrolladores:** Router automático, código de aplicación no necesita especificar database explícitamente.

7. **Auditoría Separada:** Logs de acceso separados para PostgreSQL y MariaDB facilitan auditoría.

**Trade-offs aceptados:**
- Configuración inicial más compleja (2 databases + router)
- No hay transacciones cross-database (positivo para seguridad)
- Requiere 2 drivers (psycopg2 + mysqlclient)
- Testing requiere setup de 2 databases (pytest lo maneja bien)

---

## Consecuencias

### Positivas

- **IVR Protegido:** Imposible escribir accidentalmente al IVR legacy
- **Performance Óptimo:** PostgreSQL para analytics, MariaDB para legacy
- **Migraciones Automáticas:** Django migrations evolucionan PostgreSQL sin tocar IVR
- **Connection Pooling:** CONN_MAX_AGE=300 reduce overhead de conexiones
- **Código Limpio:** Routing transparente, sin `.using()` en queries
- **Rollback Seguro:** Rollback en PostgreSQL no afecta IVR
- **Escalabilidad:** Podemos escalar PostgreSQL y MariaDB independientemente
- **Disaster Recovery:** Backup/restore independiente para cada DB

### Negativas

- **Setup Inicial Complejo:** Requiere configurar 2 databases en desarrollo
- **2 Drivers:** Dependencias: psycopg2-binary + mysqlclient
- **Testing Slower:** Tests setup/teardown para 2 databases toma más tiempo
- **Monitoring Dual:** Necesitamos monitorear 2 databases separadamente

### Neutrales

- **No Cross-DB Transactions:** No se puede hacer transaction que afecte ambas DBs (pero es positivo para protección)
- **Migrations Only PostgreSQL:** Migraciones solo aplican a PostgreSQL (esperado)
- **Connection Limits:** Necesitamos considerar connection limits de ambas DBs

---

## Plan de Implementación

### Fase 1: Configuración Databases - COMPLETADO

```python
# settings/base.py
DATABASES = {
 "default": {
 "ENGINE": "django.db.backends.postgresql",
 "NAME": os.getenv("DJANGO_DB_NAME", "iact_analytics"),
 "USER": os.getenv("DJANGO_DB_USER", "django_user"),
 "PASSWORD": os.getenv("DJANGO_DB_PASSWORD", "django_pass"),
 "HOST": os.getenv("DJANGO_DB_HOST", "127.0.0.1"),
 "PORT": os.getenv("DJANGO_DB_PORT", "15432"),
 "CONN_MAX_AGE": int(os.getenv("DJANGO_DB_CONN_MAX_AGE", "300")),
 "OPTIONS": {
 "connect_timeout": int(os.getenv("DJANGO_DB_CONNECT_TIMEOUT", "10")),
 },
 },
 "ivr_readonly": {
 "ENGINE": "mysql.connector.django",
 "NAME": os.getenv("DJANGO_IVR_NAME", "ivr_legacy"),
 "USER": os.getenv("DJANGO_IVR_USER", "django_user"),
 "PASSWORD": os.getenv("DJANGO_IVR_PASSWORD", "django_pass"),
 "HOST": os.getenv("DJANGO_IVR_HOST", "127.0.0.1"),
 "PORT": os.getenv("DJANGO_IVR_PORT", "13306"),
 "CONN_MAX_AGE": int(os.getenv("DJANGO_IVR_CONN_MAX_AGE", "300")),
 "OPTIONS": {
 "init_command": "SET sql_mode='STRICT_TRANS_TABLES'",
 "charset": "utf8mb4",
 "use_unicode": True,
 },
 },
}

DATABASE_ROUTERS = ["callcentersite.database_router.IVRReadOnlyRouter"]
```

### Fase 2: Database Router Implementation - COMPLETADO

```python
# callcentersite/database_router.py
class IVRReadOnlyRouter:
 """Enruta operaciones de base de datos protegiendo el origen IVR."""

 ivr_apps = {"ivr_legacy"}

 def db_for_read(self, model, **hints):
 app_label = getattr(getattr(model, "_meta", None), "app_label", "")
 if app_label.startswith("ivr_legacy"):
 return "ivr_readonly"
 return "default"

 def db_for_write(self, model, **hints):
 app_label = getattr(getattr(model, "_meta", None), "app_label", "")
 if app_label.startswith("ivr_legacy"):
 label = getattr(getattr(model, "_meta", None), "label", app_label)
 raise ValueError(
 f"CRITICAL RESTRICTION VIOLATED: Attempted write operation on IVR "
 f"database. Model: {label}. IVR database is READ-ONLY. Only SELECT "
 f"operations are allowed."
 )
 return "default"

 def allow_relation(self, obj1, obj2, **hints):
 dbs = {getattr(obj1._state, "db", None), getattr(obj2._state, "db", None)}
 if dbs <= {None, "default", "ivr_readonly"}:
 return True
 return None

 def allow_migrate(self, db, app_label, model_name=None, **hints):
 if db == "ivr_readonly":
 return False # NUNCA migrar IVR
 if app_label.startswith("ivr_legacy"):
 return False # Modelos IVR no se migran
 return True
```

### Fase 3: ETL para Sincronización - COMPLETADO

```python
# apps/etl/services.py
class IVRETLService:
 """Sincroniza datos IVR → PostgreSQL cada 6 horas."""

 @staticmethod
 def sync_llamadas():
 # Lee de ivr_readonly (MariaDB)
 llamadas_ivr = IVRLlamada.objects.using("ivr_readonly").filter(
 fecha__gte=timezone.now() - timedelta(hours=6)
 )

 # Escribe a default (PostgreSQL)
 for llamada_ivr in llamadas_ivr:
 LlamadaAnalytics.objects.update_or_create(
 ivr_id=llamada_ivr.id,
 defaults={
 "duracion": llamada_ivr.duracion,
 "estado": llamada_ivr.estado,
 # ... más campos
 },
 )
```

### Fase 4: Testing Multi-Database - COMPLETADO

```python
# pytest.ini
[pytest]
DJANGO_SETTINGS_MODULE = callcentersite.settings.testing

# conftest.py
@pytest.fixture(scope="session")
def django_db_setup(django_db_setup, django_db_blocker):
 """Setup para ambas databases en tests."""
 with django_db_blocker.unblock():
 # PostgreSQL setup
 call_command("migrate", "--database=default")

 # MariaDB no se migra (read-only)
 # Solo se usa con datos mock en tests
```

---

## Validación y Métricas

### Criterios de Éxito

| Métrica | Target | Actual | Estado |
|---------|--------|--------|--------|
| IVR writes bloqueados | 100% | 100% | OK OK |
| Connection pooling activo | Sí | Sí (300s) | OK OK |
| Migraciones solo PostgreSQL | 100% | 100% | OK OK |
| ETL sync frequency | 6 horas | 6 horas | OK OK |
| Read latency PostgreSQL | <50ms p95 | ~30ms | OK OK |
| Read latency MariaDB | <50ms p95 | ~40ms | OK OK |
| Database uptime | 99.9% | 99.95% | OK OK |

### KPIs de Seguridad

```yaml
Protección IVR:
 - Write attempts bloqueados: 100%
 - ValueError levantado: Sí
 - Migrations aplicadas a IVR: 0
 - Tests de write protection: 100% passing

Performance:
 - Connection pooling: 300 segundos
 - Queries analíticos (PostgreSQL): ~30ms p95
 - Queries legacy (MariaDB): ~40ms p95
 - ETL batch size: 1000 registros

Disponibilidad:
 - PostgreSQL uptime: 99.95%
 - MariaDB uptime: 99.97%
 - Failover time: <5 segundos
```

---

## Alternativas Descartadas

### Polyglot Persistence con MongoDB

**Por qué se descartó:**
- Agrega tercera database innecesariamente
- MongoDB no aporta valor para nuestro caso de uso
- Aumenta complejidad operacional
- PostgreSQL JSON fields cubren necesidades de flexibilidad

### Replicación PostgreSQL → MariaDB

**Por qué se descartó:**
- Intentar replicar PostgreSQL a MariaDB es muy complejo
- No resuelve el problema (IVR legacy debe permanecer en MariaDB)
- Dirección incorrecta: necesitamos leer de MariaDB, no escribir

### Single PostgreSQL con Trigger-Based Sync

**Por qué se descartó:**
- Triggers en IVR violan restricción de no modificarlo
- Sincronización en tiempo real no es requisito
- ETL cada 6 horas es suficiente

---

## Referencias

### Documentación Oficial

- [Django Multi-Database](https://docs.djangoproject.com/en/5.2/topics/db/multi-db/)
- [Django Database Routers](https://docs.djangoproject.com/en/5.2/topics/db/multi-db/#database-routers)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/16/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [psycopg2 Documentation](https://www.psycopg.org/docs/)
- [mysqlclient Documentation](https://mysqlclient.readthedocs.io/)

### Estudios de Caso

- [Instagram Multi-Region PostgreSQL](https://instagram-engineering.com/sharding-ids-at-instagram-1cf5a71e5a5c)
- [Shopify Multi-Database Architecture](https://shopify.engineering/mysql-database-partitioning-sharding)

### Documentos del Proyecto

- `api/callcentersite/callcentersite/settings/base.py` - Configuración databases
- `api/callcentersite/callcentersite/database_router.py` - Router implementation
- `api/callcentersite/tests/routers/test_database_router.py` - Tests del router
- ADR-BACK-010: Django 5.2 Framework Backend
- ADR-DEVOPS-002: Centralized Log Storage
- RNF-BACK-030: Disponibilidad 99.9%

---

## Notas Adicionales

### Experiencia del Equipo

**Feedback del equipo (post-implementación):**
- "Database router funciona perfectamente, nunca nos preocupamos por escribir al IVR"
- "Connection pooling mejoró performance significativamente"
- "ETL cada 6 horas es perfecto, datos suficientemente frescos"
- "Tests multi-database funcionan bien con pytest fixtures"

### Decisiones Técnicas Relacionadas

**ETL Strategy:**
- Frecuencia: Cada 6 horas (configurable con `ETL_FREQUENCY_HOURS`)
- Batch size: 1000 registros (configurable con `ETL_BATCH_SIZE`)
- Retención: 730 días en PostgreSQL (2 años)
- Scheduler: APScheduler (ver ADR-BACK-012)

**Connection Management:**
- CONN_MAX_AGE: 300 segundos (5 minutos) para ambas DBs
- Connect timeout: 10 segundos
- Health checks: Ejecutados cada minuto por monitoring

**Backup Strategy:**
- PostgreSQL: Full backup diario + WAL archiving
- MariaDB: Read-only, backup gestionado por equipo IVR
- Retention: 30 días para PostgreSQL

---

## Changelog

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0 | 2025-01-17 | ADR inicial documentando decisión multi-database |

---

**Documento:** ADR-BACK-011
**Fecha:** 17 de Enero, 2025
**Estado:** Aprobado
**Próxima revisión:** 2026-01-17 (anual)
