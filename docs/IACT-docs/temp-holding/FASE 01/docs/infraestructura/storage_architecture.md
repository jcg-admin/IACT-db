---
id: DOC-ARQUITECTURA-STORAGE
tipo: arquitectura
categoria: infraestructura
version: 1.0.0
fecha_creacion: 2025-11-07
propietario: arquitecto-senior
relacionados: ["ADR_2025_004", "OBSERVABILITY_LAYERS.md", "DORA_CASSANDRA_INTEGRATION.md", "ADR_2025_003"]
date: 2025-11-13
---

# Arquitectura de Storage - Separacion de Concerns

Documento tecnico que explica la estrategia de persistencia multi-base de datos del proyecto IACT, justificando el uso de MySQL para DORA metrics y Cassandra para logs de aplicacion e infraestructura.

**Version:** 1.0.0
**Fecha:** 2025-11-07

---

## Vision General

El proyecto IACT utiliza **2 bases de datos diferentes** para propositos especificos:

1. **MySQL** - Para metricas DORA (Capa 1: Proceso de Desarrollo)
2. **Apache Cassandra** - Para logs de aplicacion e infraestructura (Capas 2 y 3)

**Principio arquitectonico:** Separation of Concerns (SoC) - cada base de datos optimizada para su workload especifico.

---

## Arquitectura de 3 Capas

```
CAPA 1: DORA Metrics (Proceso)        CAPA 2: Application Logs (Runtime)      CAPA 3: Infrastructure Logs (Sistema)
     |                                      |                                         |
     v                                      v                                         v
MySQL: dora_metrics                    Cassandra: application_logs             Cassandra: infrastructure_logs
     |                                      |                                         |
     v                                      v                                         v
Queries complejas                      Queries simples                         Queries simples
Miles registros                        Millones registros                      Millones registros
Permanente                             90 dias TTL                             90 dias TTL
```

---

## Por Que NO Usar Una Sola Base de Datos

### Problema: Requisitos Contradictorios

| Aspecto | DORA Metrics | Application/Infrastructure Logs |
|---------|--------------|----------------------------------|
| Volumen de datos | Bajo (miles/mes) | Alto (millones/dia) |
| Tipo de queries | Complejas (JOINs, GROUP BY, agregaciones) | Simples (filtros por fecha/level) |
| Write throughput | Bajo (~10 writes/min) | Alto (1M writes/s) |
| Updates | Frecuentes (PDCA updates ciclos) | Nunca (immutable, append-only) |
| Retencion | Permanente (historia del equipo) | 90 dias (TTL automatico) |
| ACID transactions | Requerido (integridad PDCA) | No necesario (eventual consistency OK) |

**Conclusion:** Imposible optimizar 1 BD para ambos workloads.

---

## CAPA 1: DORA Metrics - MySQL

### Justificacion Tecnica

**Tipo de datos:**
```json
{
  "cycle_id": "cycle-20251107-153000",
  "feature_id": "FEAT-123",
  "phases": [
    {"phase": "planning", "duration": 900, "decision": "go"},
    {"phase": "testing", "duration": 7200, "decision": "go"},
    {"phase": "deployment", "duration": 1800, "decision": "go"}
  ],
  "metrics": {
    "lead_time": 1.25,
    "deployment_frequency": 1,
    "change_failure_rate": 5.0
  }
}
```

**Volumen esperado:**
- 1 ciclo por feature
- Aproximadamente 50 features/mes
- Aproximadamente 600 ciclos/ano
- Total: Miles de registros (NO millones)

**Queries tipicas:**
```sql
-- Calcular Lead Time promedio ultimos 30 dias
SELECT AVG(duration_seconds)
FROM dora_metrics
WHERE phase_name = 'deployment'
  AND created_at >= NOW() - INTERVAL 30 DAY;

-- Comparar performance por team
SELECT team, AVG(lead_time)
FROM dora_metrics
GROUP BY team;

-- Correlacionar story points con duracion
SELECT story_points, AVG(duration_seconds)
FROM dora_metrics
WHERE phase_name = 'testing'
GROUP BY story_points;
```

### Por Que MySQL

**Ventajas para DORA:**
- [OK] Queries complejas nativas (JOINs, GROUP BY, window functions)
- [OK] ACID transactions (integridad de datos PDCA)
- [OK] Django ORM nativo (desarrollo rapido)
- [OK] Retencion permanente (sin TTL, historia del equipo)
- [OK] Volumen bajo (miles registros manejables)
- [OK] Django Admin dashboards nativos
- [OK] Updates frecuentes (ciclos PDCA modifican registros)

**Por que NO Cassandra para DORA:**
- [PROBLEMA] Cassandra optimizado para append-only (DORA necesita updates)
- [PROBLEMA] JOINs complejos dificiles en CQL
- [PROBLEMA] GROUP BY limitado en Cassandra
- [PROBLEMA] Volumen bajo no justifica complejidad cluster
- [PROBLEMA] Eventual consistency inadecuada para PDCA

### Schema MySQL

```sql
CREATE TABLE dora_metrics (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    cycle_id VARCHAR(50) UNIQUE NOT NULL,
    feature_id VARCHAR(50) NOT NULL,
    phase_name VARCHAR(50) NOT NULL,  -- 'planning', 'testing', 'deployment', 'maintenance'
    decision VARCHAR(20),              -- 'go', 'no-go', 'review', 'blocked'
    duration_seconds DECIMAL(10,2),
    metadata JSON,                     -- Flexible metadata (story_points, tests_passed, etc)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_phase (phase_name),
    INDEX idx_feature (feature_id),
    INDEX idx_created (created_at)
) ENGINE=InnoDB;
```

### Storage Actual vs Futuro

**Actual (v1):**
```
.dora_sdlc_metrics.json (raiz del proyecto)
```

**Futuro (P0 - 8 SP):**
```
MySQL: dora_metrics table
Django Admin: /admin/dora/metrics/
```

---

## CAPAS 2 y 3: Application + Infrastructure Logs - Cassandra

### Justificacion Tecnica

**Tipo de datos:**
```python
# Application log (Capa 2)
logger.error(
    "Payment failed",
    extra={
        'request_id': 'a1b2c3d4',
        'user_id': 12345,
        'amount': 99.99,
        'error_code': 'CARD_DECLINED'
    }
)

# Infrastructure log (Capa 3)
# nginx access.log
127.0.0.1 - user [07/Nov/2025:15:30:45 +0000] "GET /api/users HTTP/1.1" 200 1234
```

**Volumen esperado:**
- 1,000 requests/min = 1.4M requests/dia
- 3 logs promedio por request
- Total: 4.2M logs/dia = 126M logs/mes

**Queries tipicas:**
```cql
-- Buscar errores hoy
SELECT * FROM application_logs
WHERE log_date = '2025-11-07'
  AND level = 'ERROR'
LIMIT 100;

-- Logs de un request especifico (tracing)
SELECT * FROM application_logs
WHERE log_date = '2025-11-07'
  AND request_id = 'a1b2c3d4';

-- Count errores ultima hora
SELECT COUNT(*) FROM application_logs
WHERE log_date = '2025-11-07'
  AND timestamp >= NOW() - 1 HOUR
  AND level = 'ERROR';
```

### Por Que Cassandra

**Ventajas para logs:**
- [OK] Write throughput mayor a 1M logs/segundo (vs MySQL aproximadamente 10K/s)
- [OK] Append-only optimizado (logs nunca se actualizan)
- [OK] TTL nativo (retention automatico 90 dias sin scripts)
- [OK] Particionado por fecha (queries rapidas por dia)
- [OK] Linear scaling (agregar nodos = mas throughput)
- [OK] No single point of failure (peer-to-peer vs MySQL master)
- [OK] Sequential writes optimizados (Commit Log)

**Por que NO MySQL para logs:**
- [PROBLEMA] MySQL aproximadamente 10K writes/s (insuficiente para 4M logs/dia)
- [PROBLEMA] Locks en tabla con millones de filas
- [PROBLEMA] Partitioning manual complejo
- [PROBLEMA] Single point of failure (master)
- [PROBLEMA] No escala horizontalmente

### Schemas Cassandra

**Capa 2: Application Logs**
```cql
CREATE TABLE logging.application_logs (
    log_date DATE,              -- Partition key (dia)
    timestamp TIMESTAMP,        -- Clustering key (orden cronologico)
    level TEXT,                 -- INFO, ERROR, CRITICAL
    logger TEXT,                -- 'analytics', 'etl', 'reports'
    message TEXT,
    request_id TEXT,            -- UUID para tracing
    user_id INT,
    session_id TEXT,
    metadata MAP<TEXT, TEXT>,
    traceback TEXT,
    duration_ms DECIMAL,

    PRIMARY KEY ((log_date), timestamp)
) WITH CLUSTERING ORDER BY (timestamp DESC)
  AND compaction = {
      'class': 'TimeWindowCompactionStrategy',
      'compaction_window_size': 1,
      'compaction_window_unit': 'DAYS'
  }
  AND default_time_to_live = 7776000;  -- 90 dias
```

**Capa 3: Infrastructure Logs**
```cql
CREATE TABLE logging.infrastructure_logs (
    log_date DATE,              -- Partition key (dia)
    timestamp TIMESTAMP,        -- Clustering key (orden cronologico)
    source TEXT,                -- 'nginx/access', 'postgresql', 'syslog'
    level TEXT,                 -- ERROR, WARNING, INFO
    message TEXT,
    metadata MAP<TEXT, TEXT>,

    PRIMARY KEY ((log_date), timestamp)
) WITH CLUSTERING ORDER BY (timestamp DESC)
  AND compaction = {
      'class': 'TimeWindowCompactionStrategy'
  }
  AND default_time_to_live = 7776000;  -- 90 dias
```

---

## Comparacion Tecnica Detallada

### Performance Benchmark

**Scenario:** Deploy con 1000 requests/min spike

**MySQL:**
```
- 1000 logs/min × 1ms write = 1000ms overhead total
- Master bottleneck (todos los writes a 1 nodo)
- Lock contention en tabla con millones de filas
- Write throughput: aproximadamente 10,000 writes/s MAX
- Resultado: Degradacion de performance bajo carga
```

**Cassandra:**
```
- 1000 logs/min × 0.1ms write = 100ms overhead total
- Distributed writes (sin bottleneck)
- No locks (append-only)
- Write throughput: mayor a 1,000,000 writes/s
- Resultado: Performance estable bajo carga
```

**Ventaja:** Cassandra 100x mejor throughput

### Storage y Retention

**MySQL:**
```
Volumen: 1M logs × 1KB = 1GB
Retention: Manual partitioning
  CREATE TABLE logs_2025_11 ...
  CREATE TABLE logs_2025_12 ...
  DROP TABLE logs_2025_08;  -- Manual cleanup

Complejidad: Alta (requires cron scripts)
```

**Cassandra:**
```
Volumen: 1M logs × 1KB × 0.2 (compressed) = 200MB
Retention: TTL automatico
  default_time_to_live = 7776000  -- 90 dias
  Compaction automatica limpia logs expirados

Complejidad: Baja (zero maintenance)
```

### Escalabilidad

**MySQL:**
```
Vertical scaling: Upgrade server hardware
Horizontal scaling: Master-slave replication (read replicas)
  - Writes siempre a master (bottleneck)
  - Complejidad failover

Limite: Single master bottleneck
```

**Cassandra:**
```
Horizontal scaling: Agregar nodos al cluster
  - Writes distribuidos automaticamente
  - Linear scaling (2x nodos = 2x throughput)
  - Automatic rebalancing

Limite: Practicamente ilimitado
```

---

## Anti-Pattern: Duplicacion de Logs

### NO Hacer Esto

```python
# ANTI-PATTERN - Duplicacion innecesaria
LOGGING = {
    'handlers': {
        'cassandra': {
            'class': 'CassandraLogHandler',
        },
        'mysql': {
            'class': 'MySQLLogHandler',  # Duplicacion
        },
    },
    'loggers': {
        'analytics': {
            'handlers': ['cassandra', 'mysql'],  # Doble escritura
        },
    },
}
```

### Problemas

- [PROBLEMA] Doble overhead de escritura (1ms + 0.1ms = 1.1ms por log)
- [PROBLEMA] Duplicacion de storage (2x costo)
- [PROBLEMA] Sincronizacion compleja (que pasa si uno falla y otro no)
- [PROBLEMA] Mantenimiento de 2 sistemas
- [PROBLEMA] Queries distribuidas entre 2 BDs (complejidad)
- [PROBLEMA] No hay beneficio real

### Arquitectura Correcta

```python
# CORRECTO - Single source of truth
LOGGING = {
    'handlers': {
        'cassandra': {
            'class': 'CassandraLogHandler',  # Solo Cassandra
        },
    },
    'loggers': {
        'analytics': {'handlers': ['cassandra']},
        'etl': {'handlers': ['cassandra']},
        'reports': {'handlers': ['cassandra']},
    },
}
```

**Beneficios:**
- [OK] Single source of truth (Cassandra)
- [OK] Performance optimo (mayor a 1M writes/s)
- [OK] TTL automatico (90 dias)
- [OK] Escalamiento horizontal
- [OK] No duplicacion de datos

---

## Mecanismo de Escritura

### Capa 2: Application Logs (Django)

**Handler asincrono:**
```python
class CassandraLogHandler(logging.Handler):
    def emit(self, record):
        """Non-blocking: menor a 0.1ms"""
        self.queue.put_nowait(record)  # Agregar a queue

    def _process_queue(self):
        """Worker thread: batch inserts"""
        batch = []
        while True:
            record = self.queue.get(timeout=1.0)
            batch.append(record)

            if len(batch) >= 100:  # Batch completo
                self._flush_batch(batch)  # 1 write a Cassandra
                batch = []

    def _flush_batch(self, batch):
        """100 logs = 1 batch write menor a 10ms"""
        batch_stmt = BatchStatement()
        for record in batch:
            batch_stmt.add(self.insert_stmt, (...))

        self.session.execute(batch_stmt)
```

**Caracteristicas:**
- Overhead menor a 0.1ms por log (non-blocking)
- Batch writes (100 logs por batch)
- Worker thread dedicado
- Auto-recovery en caso de falla

### Capa 3: Infrastructure Logs (Daemon)

**Daemon Python:**
```python
class InfrastructureLogsDaemon:
    def tail_logs(self):
        """Tail /var/log/nginx/access.log"""
        for line in tail_output:
            log_entry = LogParser.parse_nginx_access(line)
            self.batch.append(log_entry)

            if len(self.batch) >= 1000:  # Batch completo
                self._flush_batch()  # 1 write a Cassandra

    def _flush_batch(self):
        """1000 logs = 1 batch write menor a 10ms"""
        batch_stmt = BatchStatement()
        for entry in self.batch:
            batch_stmt.add(self.insert_stmt, (...))

        self.session.execute(batch_stmt)
```

**Caracteristicas:**
- Tail -F con inotify (log rotation handling)
- Multi-format parser (nginx, syslog, postgresql)
- Batch writes (1000 logs por batch)
- Systemd service (auto-restart)

**Mecanismo IDENTICO para Capas 2 y 3:**
- Queue/Buffer
- Worker thread
- Batch inserts
- 1 write a Cassandra por batch

---

## Migracion y Roadmap

### Estado Actual (v1.8.0)

**Cassandra (Capas 2 y 3):**
- [OK] Cluster 3 nodos instalado
- [OK] Schema application_logs creado
- [OK] Schema infrastructure_logs creado
- [OK] CassandraLogHandler implementado
- [OK] infrastructure_logs_daemon.py implementado
- [OK] Scripts instalacion (install-cassandra.sh, configure-django.sh)

**MySQL (Capa 1):**
- [PENDIENTE] Tabla dora_metrics (P0 - 8 SP)
- [OK] .dora_sdlc_metrics.json (temporal)
- [OK] DORAMetrics class (dora_sdlc_integration.py)

### Roadmap Futuro

**Q4 2025:**
1. Implementar MySQL dora_metrics table (P0 - 8 SP)
2. Migrar .dora_sdlc_metrics.json a MySQL
3. Django Admin dashboards DORA (P2 - 5 SP)

**Q1 2026:**
1. Custom dashboards Django Admin para logs Cassandra (P2 - 5 SP)
2. DORA metrics baseline establecida (P0 - 2 SP)
3. AI-enabled telemetry pipeline

**Q2 2026:**
1. Predictive analytics dashboard
2. Formalizar Data Engineer role
3. Establecer ROI metrics

---

## Instalacion y Configuracion

### Cassandra (Capas 2 y 3)

**Quick start:**
```bash
# Instalar cluster Docker (3 nodos)
./scripts/cassandra/install-cassandra.sh docker

# Configurar Django settings.py
./scripts/cassandra/configure-django.sh

# Setup cron jobs (maintenance + alerting)
./scripts/cassandra/setup-cron-jobs.sh

# Test logging
python manage.py shell -c "
import logging
logger = logging.getLogger('analytics')
logger.info('Test log', extra={'request_id': 'test-123'})
"

# Verificar Cassandra
docker exec cassandra-1 cqlsh -e "
SELECT * FROM logging.application_logs
WHERE log_date = '2025-11-07'
LIMIT 10;
"
```

### MySQL (Capa 1)

**Pendiente implementacion (P0 - 8 SP):**
```sql
-- Crear tabla
CREATE TABLE dora_metrics (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    cycle_id VARCHAR(50) UNIQUE NOT NULL,
    feature_id VARCHAR(50) NOT NULL,
    phase_name VARCHAR(50) NOT NULL,
    decision VARCHAR(20),
    duration_seconds DECIMAL(10,2),
    metadata JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_phase (phase_name),
    INDEX idx_feature (feature_id),
    INDEX idx_created (created_at)
) ENGINE=InnoDB;
```

---

## Queries de Ejemplo

### DORA Metrics (MySQL)

```sql
-- Lead Time promedio ultimos 30 dias
SELECT AVG(duration_seconds) / 3600 as avg_lead_time_hours
FROM dora_metrics
WHERE phase_name = 'deployment'
  AND created_at >= NOW() - INTERVAL 30 DAY;

-- Deployment Frequency por team
SELECT team, COUNT(*) as deploys
FROM dora_metrics
WHERE phase_name = 'deployment'
  AND created_at >= NOW() - INTERVAL 7 DAY
GROUP BY team;

-- Change Failure Rate
SELECT
    SUM(CASE WHEN decision = 'no-go' THEN 1 ELSE 0 END) / COUNT(*) * 100 as cfr
FROM dora_metrics
WHERE phase_name = 'testing'
  AND created_at >= NOW() - INTERVAL 30 DAY;
```

### Application Logs (Cassandra)

```cql
-- Errores hoy
SELECT timestamp, logger, message, traceback
FROM logging.application_logs
WHERE log_date = '2025-11-07'
  AND level = 'ERROR'
ORDER BY timestamp DESC
LIMIT 100;

-- Tracing por request_id
SELECT timestamp, level, logger, message
FROM logging.application_logs
WHERE log_date = '2025-11-07'
  AND request_id = 'a1b2c3d4-...'
ALLOW FILTERING;

-- Slow queries (mayor a 1s)
SELECT timestamp, logger, message, duration_ms
FROM logging.application_logs
WHERE log_date = '2025-11-07'
  AND duration_ms > 1000
ALLOW FILTERING;
```

### Infrastructure Logs (Cassandra)

```cql
-- Errores nginx ultimas 24h
SELECT timestamp, source, message
FROM logging.infrastructure_logs
WHERE log_date = '2025-11-07'
  AND source = 'nginx/error'
ORDER BY timestamp DESC
LIMIT 100;

-- PostgreSQL crashes
SELECT timestamp, message
FROM logging.infrastructure_logs
WHERE log_date = '2025-11-07'
  AND source = 'postgresql'
  AND level = 'CRITICAL';

-- Count errores por source
SELECT source, COUNT(*) as errors
FROM logging.infrastructure_logs
WHERE log_date = '2025-11-07'
  AND level = 'ERROR'
GROUP BY source;
```

---

## Monitoreo y Mantenimiento

### Cassandra

**Health checks:**
```bash
# Cluster status
docker exec cassandra-1 nodetool status

# Compaction stats
docker exec cassandra-1 nodetool compactionstats

# Table stats
docker exec cassandra-1 nodetool tablestats logging.application_logs
```

**Cron jobs automaticos (setup-cron-jobs.sh):**
```bash
# Error alerting (every 5 minutes)
*/5 * * * * python /app/scripts/logging/alert_on_errors.py

# Compaction stats (daily 2 AM)
0 2 * * * nodetool compactionstats >> /var/log/iact/compaction.log

# Repair (weekly Sunday 3 AM)
0 3 * * 0 nodetool repair -pr logging >> /var/log/iact/repair.log

# Cleanup (monthly 1st 4 AM)
0 4 1 * * nodetool clearsnapshot logging >> /var/log/iact/cleanup.log
```

### MySQL

**Health checks (futuro):**
```bash
# Database size
SELECT
    table_schema,
    SUM(data_length + index_length) / 1024 / 1024 as size_mb
FROM information_schema.tables
WHERE table_schema = 'iact'
GROUP BY table_schema;

# Row counts
SELECT COUNT(*) FROM dora_metrics;

# Index usage
SHOW INDEX FROM dora_metrics;
```

---

## Metricas de Exito

### Cassandra (Capas 2 y 3)

**Performance:**
- Write latency menor a 0.5ms p95
- Query latency menor a 1s p95
- Cluster health 3/3 nodes UP Normal

**Storage:**
- Disk usage menor a 80 por ciento per node
- TTL funcionando (0 logs mayor a 90 dias)
- Compression ratio mayor o igual a 80 por ciento

**Reliability:**
- Uptime mayor a 99.5 por ciento
- 0 data loss
- Automatic recovery de node failures

### MySQL (Capa 1)

**Performance (futuro):**
- Query latency menor a 100ms p95
- Insert latency menor a 10ms p95
- Index utilization mayor a 90 por ciento

**Storage:**
- Database size menor a 1GB (primeros 12 meses)
- Growth rate menor a 100MB/mes

**Data Integrity:**
- 0 orphaned records
- 100 por ciento PDCA cycle consistency

---

## Referencias

- ADR_2025_004: Centralized Log Storage en Cassandra
- ADR_2025_003: DORA SDLC Agents Integration
- OBSERVABILITY_LAYERS.md: 3 capas de observabilidad
- DORA_CASSANDRA_INTEGRATION.md: Integracion DORA + Cassandra

**Documentos tecnicos:**
- scripts/cassandra/README.md: Guia instalacion Cassandra
- scripts/logging/README.md: Logging handlers documentation
- docs/implementacion/OBSERVABILITY_LAYERS.md: Arquitectura 3 capas

---

## Preguntas Frecuentes

**P: Por que no usar una sola base de datos?**
R: Requisitos contradictorios. DORA necesita queries complejas (MySQL), logs necesitan alto throughput (Cassandra).

**P: Se pueden guardar logs en MySQL tambien?**
R: Tecnicamente si, pero es anti-pattern. Cassandra 100x mejor throughput, TTL automatico, escalamiento horizontal.

**P: Los logs de Capa 2 y 3 se guardan igual?**
R: Si, ambos en Cassandra con mecanismo identico (batch writes, TTL 90 dias). Solo difieren en tabla y fuente de datos.

**P: Como se relacionan MySQL y Cassandra?**
R: No se relacionan. Son sistemas independientes para capas diferentes. MySQL para DORA metrics, Cassandra para logs.

**P: Cuando se implementara MySQL para DORA?**
R: P0 - 8 SP (aproximadamente 2 dias). Actualmente usando .dora_sdlc_metrics.json temporal.

---

**VERSION:** 1.0.0
**ESTADO:** Documentado
**PROXIMA REVISION:** 2025-12-07 (1 mes)
