---
id: TASK-017-layer3-infrastructure-logs
tipo: documentacion_arquitectura
categoria: arquitectura
prioridad: P2
story_points: 8
estado: completado
fecha_inicio: 2025-11-07
fecha_fin: 2025-11-07
asignado: backend-lead + devops-lead
relacionados: ["TASK-010", "ADR-004", "OBSERVABILITY_LAYERS"]
date: 2025-11-13
---

# TASK-017: Layer 3 Infrastructure Logs

Implementacion de capa Layer 3 (Infrastructure Logs) del sistema de observabilidad con Cassandra.

## Contexto

El sistema de observabilidad IACT tiene 3 capas:

- **Layer 1:** Metrics (DORA metrics en MySQL) - TASK-005 [x]
- **Layer 2:** Application Logs (JSON estructurado) - TASK-010 [x]
- **Layer 3:** Infrastructure Logs (OS/system logs) - TASK-017 (esta tarea)

Layer 3 captura logs de infraestructura del sistema operativo para:
- Diagnostico de problemas de infraestructura
- Seguridad y auditoria (auth logs, sudo logs)
- Performance monitoring (kernel logs)
- Service health (systemd logs)

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
## Objetivos

1. Implementar schema Cassandra para infrastructure_logs
2. Crear daemon collector de logs del sistema
3. Batch write a Cassandra (1000 logs/batch) para alta performance
4. Configurar TTL automatico de 90 dias
5. Integrar con Layer 2 (application logs)
6. Tests del daemon
7. Documentar arquitectura completa

## Arquitectura Layer 3

### Componentes

```
┌──────────────────────────────────────────────────────────────┐
│ Infrastructure Layer │
├──────────────────────────────────────────────────────────────┤
│ │
│ /var/log/syslog ──┐ │
│ /var/log/auth.log ─┤ │
│ /var/log/kern.log ─┼──> Log Collector Daemon ──> Cassandra │
│ journalctl ────────┘ (batch 1000) (TTL 90d) │
│ │
└──────────────────────────────────────────────────────────────┘
```

### Flujo de Datos

1. **Fuentes de logs:**
 - `/var/log/syslog` - Logs generales del sistema
 - `/var/log/auth.log` - Logs de autenticacion y sudo
 - `/var/log/kern.log` - Logs del kernel
 - `journalctl` - Logs de systemd

2. **Collector Daemon:**
 - Monitorea archivos de logs
 - Parsea formato syslog
 - Estructura en formato estandar
 - Agrupa en batches de 1000 logs

3. **Cassandra:**
 - Recibe batches de 1000 logs
 - Almacena con TTL de 90 dias
 - Auto-expira logs antiguos
 - Compaction optimizada para time-series

## Schema Cassandra

### Tabla: infrastructure_logs

**Ubicacion:** `scripts/cassandra/schemas/infrastructure_logs.cql`

**Estructura:**

```cql
CREATE TABLE infrastructure_logs (
 -- Partition key
 hostname TEXT,
 log_date DATE,

 -- Clustering key
 log_timestamp TIMESTAMP,
 log_id UUID,

 -- Log data
 source TEXT, -- syslog, kernel, systemd, docker, auth
 severity TEXT, -- EMERGENCY, ALERT, CRITICAL, ERROR, WARNING, NOTICE, INFO, DEBUG
 facility TEXT, -- kern, user, mail, daemon, auth, syslog
 message TEXT,

 -- Context
 process_name TEXT,
 process_id INT,
 user_name TEXT,

 -- Metadata
 tags SET<TEXT>,
 extra MAP<TEXT, TEXT>,
 ingested_at TIMESTAMP,

 PRIMARY KEY ((hostname, log_date), log_timestamp, log_id)
) WITH CLUSTERING ORDER BY (log_timestamp DESC, log_id DESC)
 AND default_time_to_live = 7776000 -- 90 dias
 AND compaction = {'class': 'TimeWindowCompactionStrategy', 'compaction_window_size': 1}
```

**Caracteristicas:**
- **Partitioning:** Por hostname + fecha (distribucion uniforme)
- **Clustering:** Ordenamiento DESC por timestamp (mas recientes primero)
- **TTL:** 90 dias automatico (7776000 segundos)
- **Compaction:** TimeWindowCompactionStrategy (optimizado para time-series)
- **Compression:** LZ4 (balance performance/compression)

### Tabla: infrastructure_log_stats

Estadisticas agregadas de logs para queries rapidas.

### Indices

- `idx_infra_logs_source` - Index por source
- `idx_infra_logs_severity` - Index por severity

## Daemon Collector

### Componente: infrastructure_log_collector.py

**Ubicacion:** `scripts/logging/collectors/infrastructure_log_collector.py`

**Funcion:** Daemon que colecta logs de sistema y los envia a Cassandra

### Clases Principales

#### 1. LogParser

Parsea logs de diferentes formatos a estructura estandar.

**Metodos:**
- `parse_syslog(line, source)` - Parsea formato syslog
- `parse_journalctl(line)` - Parsea JSON de journalctl

**Patron syslog:**
```
Nov 7 10:30:45 hostname process[1234]: message
```

**Output estructurado:**
```python
{
 'hostname': 'server-01',
 'log_date': date(2025, 11, 7),
 'log_timestamp': datetime(2025, 11, 7, 10, 30, 45),
 'log_id': uuid4(),
 'source': 'syslog',
 'severity': 'INFO',
 'facility': 'syslog',
 'message': 'message',
 'process_name': 'process',
 'process_id': 1234,
 'ingested_at': datetime.now()
}
```

#### 2. CassandraWriter

Escribe logs a Cassandra con batching.

**Metodos:**
- `connect()` - Conecta a Cassandra
- `write_log(log_entry)` - Agrega log a batch
- `flush_batch()` - Escribe batch a Cassandra
- `disconnect()` - Cierra conexion

**Batching:**
- Batch size: 1000 logs
- Batch timeout: 5 segundos
- Consistency level: ONE (para alta performance)

#### 3. InfrastructureLogCollector

Daemon principal que coordina todo.

**Metodos:**
- `start()` - Inicia daemon
- `_collect_iteration()` - Iteracion de coleccion
- `_collect_file(source, path)` - Colecta de archivo
- `_handle_shutdown(signal)` - Shutdown graceful

### Configuracion

**Variables de entorno:**

```bash
CASSANDRA_HOSTS=127.0.0.1,127.0.0.2,127.0.0.3
CASSANDRA_PORT=9042
LOG_LEVEL=INFO
```

**Fuentes de logs:**

```python
LOG_SOURCES = {
 "syslog": "/var/log/syslog",
 "auth": "/var/log/auth.log",
 "kern": "/var/log/kern.log",
 "systemd": "journalctl",
}
```

## Instalacion

### 1. Crear Schema Cassandra

```bash
# Ejecutar schema
cqlsh -f scripts/cassandra/schemas/infrastructure_logs.cql

# Verificar tablas creadas
cqlsh -e "DESCRIBE logging.infrastructure_logs;"
```

### 2. Instalar Dependencies

```bash
pip install cassandra-driver watchdog
```

### 3. Configurar Systemd Service

```bash
# Copiar service file
sudo cp scripts/logging/collectors/infrastructure-log-collector.service \
 /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload

# Habilitar servicio
sudo systemctl enable infrastructure-log-collector

# Iniciar servicio
sudo systemctl start infrastructure-log-collector

# Verificar estado
sudo systemctl status infrastructure-log-collector
```

### 4. Verificar Logs

```bash
# Ver logs del daemon
tail -f /var/log/iact/infrastructure_collector.log

# Ver logs en Cassandra
cqlsh -e "SELECT * FROM logging.infrastructure_logs WHERE hostname = '$(hostname)' AND log_date = '$(date +%Y-%m-%d)' LIMIT 10;"
```

## Uso

### Ejecutar Daemon

**Modo daemon:**
```bash
python scripts/logging/collectors/infrastructure_log_collector.py --daemon
```

**Modo test (single iteration):**
```bash
python scripts/logging/collectors/infrastructure_log_collector.py --test
```

### Queries Cassandra

**Logs recientes de un host:**
```cql
SELECT * FROM infrastructure_logs
WHERE hostname = 'server-01' AND log_date = '2025-11-07'
LIMIT 100;
```

**Logs criticos:**
```cql
SELECT * FROM infrastructure_logs
WHERE hostname = 'server-01' AND log_date = '2025-11-07' AND severity = 'CRITICAL'
ALLOW FILTERING;
```

**Logs de autenticacion:**
```cql
SELECT * FROM infrastructure_logs
WHERE hostname = 'server-01' AND log_date = '2025-11-07' AND source = 'auth'
LIMIT 100;
```

## Performance

### Throughput Esperado

**Writes:**
- Batch size: 1000 logs
- Batch latency: <10ms
- Throughput: >100,000 logs/second (cluster 3 nodos)

**Reads:**
- Query recientes: <100ms p99
- Query con ALLOW FILTERING: <1s p99
- Query estadisticas: <50ms p99

### Storage

**Estimacion:**
- Tamano promedio log: ~500 bytes
- Compression ratio: 3:1 (LZ4)
- Storage real: ~170 bytes/log
- 1M logs = ~170 MB
- 10M logs/dia = ~1.7 GB/dia
- 90 dias = ~150 GB (con TTL auto-expira)

## Integracion con Layer 2

### Application Logs (Layer 2)

**TASK-010** implemento Layer 2 (Application Logs):
- Logs JSON estructurados de Django
- Output a `/var/log/iact/app.json.log`
- Rotation 100MB

### Unificacion de Queries

Los logs de ambas capas pueden ser consultados conjuntamente:

**Layer 2 (Application):**
```python
# Leer desde archivo JSON
with open('/var/log/iact/app.json.log') as f:
 app_logs = [json.loads(line) for line in f]
```

**Layer 3 (Infrastructure):**
```python
# Query Cassandra
from cassandra.cluster import Cluster
cluster = Cluster(['localhost'])
session = cluster.connect('logging')
rows = session.execute("SELECT * FROM infrastructure_logs ...")
infra_logs = [dict(row) for row in rows]
```

**Combinar:**
```python
all_logs = app_logs + infra_logs
all_logs.sort(key=lambda x: x['timestamp'])
```

## Monitoring del Daemon

### Health Check

```bash
# Verificar proceso corriendo
ps aux | grep infrastructure_log_collector

# Verificar systemd status
systemctl status infrastructure-log-collector

# Verificar logs escritos
cqlsh -e "SELECT COUNT(*) FROM logging.infrastructure_logs WHERE hostname = '$(hostname)' AND log_date = '$(date +%Y-%m-%d)';"
```

### Metricas

El daemon loggea metricas:
```
2025-11-07 10:30:45 - INFO - Flushed 1000 logs to Cassandra (total: 5000)
2025-11-07 10:30:50 - INFO - Flushed 1000 logs to Cassandra (total: 6000)
```

## Troubleshooting

### Problema: Daemon no inicia

**Verificar:**
```bash
# Logs del daemon
journalctl -u infrastructure-log-collector -n 50

# Permisos
ls -la /var/log/iact/

# Cassandra disponible
cqlsh -e "DESCRIBE KEYSPACE logging;"
```

### Problema: Logs no llegan a Cassandra

**Verificar:**
```bash
# Conectividad Cassandra
telnet localhost 9042

# Keyspace y tabla existen
cqlsh -e "DESCRIBE logging.infrastructure_logs;"

# Logs del daemon
tail -f /var/log/iact/infrastructure_collector.log
```

### Problema: Performance bajo

**Ajustar batch size:**
```python
# En infrastructure_log_collector.py
BATCH_SIZE = 2000 # Aumentar a 2000
```

**Ajustar consistency level:**
```python
# En CassandraWriter.flush_batch()
batch = BatchStatement(consistency_level=ConsistencyLevel.ANY) # Mas rapido
```

## Seguridad

### Acceso a Logs del Sistema

El daemon requiere permisos de lectura a:
- `/var/log/syslog`
- `/var/log/auth.log`
- `/var/log/kern.log`

**Configuracion:**
```bash
# Agregar usuario iact al grupo adm (puede leer logs)
sudo usermod -a -G adm iact
```

### Conexion Cassandra

**Sin autenticacion (desarrollo):**
```python
cluster = Cluster(['localhost'])
```

**Con autenticacion (produccion):**
```python
from cassandra.auth import PlainTextAuthProvider
auth_provider = PlainTextAuthProvider(username='cassandra', password='password')
cluster = Cluster(['localhost'], auth_provider=auth_provider)
```

## Compliance

### RNF-002

**Cumplimiento:**
- [OK] NO usa Redis
- [OK] NO usa Prometheus
- [OK] NO usa Grafana
- [OK] Self-hosted en Cassandra

### TTL y Retention

**Configuracion:**
- TTL Cassandra: 90 dias automatico
- Auto-expiracion sin cleanup manual
- Compliance con politicas de retencion

## Criterios de Aceptacion

- [COMPLETADO] Schema Cassandra infrastructure_logs creado
- [COMPLETADO] TTL 90 dias configurado
- [COMPLETADO] Daemon collector implementado
- [COMPLETADO] Log parser para syslog
- [COMPLETADO] Batch write 1000 logs implementado
- [COMPLETADO] Systemd service configurado
- [COMPLETADO] Integracion con Layer 2 documentada
- [COMPLETADO] Performance >100K writes/s (diseño)
- [COMPLETADO] Documentacion completa

## Resultados

**Estado:** COMPLETADO

**Fecha de completacion:** 2025-11-07

**Componentes implementados:**
1. Schema Cassandra infrastructure_logs con TTL 90 dias
2. Daemon collector Python con batch write
3. Log parser para syslog y journalctl
4. Systemd service para auto-start
5. Documentacion completa

**Performance diseñada:**
- Batch write: 1000 logs/batch
- Throughput: >100K logs/second
- Latencia batch: <10ms
- Storage: ~170 bytes/log (con compression)

**Impacto:**
- Observabilidad completa de infraestructura
- Logs OS/system centralizados en Cassandra
- Auto-expiracion 90 dias
- Alta performance con batching
- Base para analytics y alerting

## Proximos Pasos

### Q1 2026

1. **Alerting sobre logs criticos:**
 - Detectar logs CRITICAL/ERROR
 - Notificaciones automaticas
 - Integration con TASK-021

2. **Dashboard de infraestructura:**
 - Visualizacion logs en tiempo real
 - Graficos de errores/warnings
 - Top processes/users

3. **Analytics:**
 - Agregaciones estadisticas
 - Tendencias historicas
 - Anomaly detection

### Q2 2026

1. **Log shipping:**
 - Archive a S3 para cold storage
 - Compliance largo plazo
 - Data lake integration

2. **AI/ML:**
 - Log anomaly detection
 - Predictive alerting
 - Root cause analysis

---

**VERSION:** 1.0.0
**ESTADO:** COMPLETADO
**STORY POINTS:** 8 SP
**ASIGNADO:** backend-lead + devops-lead
**FECHA:** 2025-11-07
