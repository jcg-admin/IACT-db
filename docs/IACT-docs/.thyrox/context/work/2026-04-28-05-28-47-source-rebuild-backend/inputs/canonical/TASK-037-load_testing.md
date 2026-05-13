---
id: TASK-037-load-testing
tipo: documentacion_qa
categoria: qa
prioridad: P3
story_points: 5
estado: completado
fecha_inicio: 2025-11-07
fecha_fin: 2025-11-07
asignado: qa-lead + devops-lead
relacionados: ["TASK-032", "TASK-035"]
date: 2025-11-13
---

# TASK-037: Load Testing

Suite de load testing para validar performance bajo carga del sistema IACT DORA metrics.

## Objetivo

Validar que el sistema mantenga performance aceptable bajo carga mediante:
- Load testing con múltiples usuarios concurrentes
- Stress testing para identificar límites
- Performance benchmarking
- Identificación de cuellos de botella

## Técnicas de Prompt Engineering para Agente

Las siguientes técnicas deben aplicarse al ejecutar esta tarea con un agente:

1. **Tool-use Prompting** (knowledge_techniques.py)
 - Ejecutar pytest con parametros especificos para tests de integracion

2. **ReAct** (knowledge_techniques.py)
 - Razonar sobre el estado actual, ejecutar tests, reflexionar sobre resultados

3. **Self-Consistency** (self_consistency.py)
 - Verificar consistencia entre multiples ejecuciones de tests

4. **Chain of Verification** (chain_of_verification.py)
 - Validar cada capa del sistema de forma secuencial

5. **Auto-CoT** (auto_cot_agent.py)
 - Generar razonamiento automatico para debugging de tests fallidos

Agente recomendado: SDLCTestingAgent o TDDAgent
## Tools Implementados

### 1. Locust Load Testing (locustfile.py)

Framework Python avanzado para load testing.

**User Classes:**

1. **DORAMetricsAPIUser** - Usuario típico
 - Wait time: 1-3s entre requests
 - Mix realista de endpoints
 - Pesos basados en uso esperado

2. **HighVolumeUser** - Usuario intensivo
 - Wait time: 0.5s (stress test)
 - Requests rápidos continuos

3. **WriteOperationUser** - Escritura
 - Wait time: 5-10s
 - POST endpoints para crear métricas

**Task Weights (DORAMetricsAPIUser):**
- `get_dora_summary`: 10 (más frecuente)
- `get_dashboard`: 5
- `get_deployment_frequency_chart`: 3
- `get_lead_time_chart`: 3
- `get_data_catalog`: 2
- `query_dora_metrics_catalog`: 2
- `get_trend_analysis`: 2
- `check_ecosystem_health`: 1
- `get_data_quality`: 1
- `get_comparative_analytics`: 1
- `get_anomaly_detection`: 1

**Usage:**

```bash
# Install Locust
pip install locust

# Run with Web UI
locust -f scripts/load_testing/locustfile.py --host=http://localhost:8000

# Access UI at http://localhost:8089

# Run headless
locust -f scripts/load_testing/locustfile.py \
 --host=http://localhost:8000 \
 --users 100 \
 --spawn-rate 10 \
 --run-time 5m \
 --headless

# Generate HTML report
locust -f scripts/load_testing/locustfile.py \
 --host=http://localhost:8000 \
 --users 100 \
 --spawn-rate 10 \
 --run-time 5m \
 --headless \
 --html load_test_report.html
```

**Locust Features:**
- Real-time statistics
- Response time percentiles (p50, p95, p99)
- Failures tracking
- Requests per second (RPS)
- Charts and graphs
- Distributed load testing support

### 2. Simple Load Test Script (simple_load_test.sh)

Bash script ligero sin dependencias externas (solo curl y GNU parallel).

**Features:**
- Concurrent requests con GNU parallel
- Response time tracking (ms)
- Success/failure counting
- Statistical analysis
- Performance assessment
- CSV results output

**Usage:**

```bash
# Basic run (defaults: 10 concurrent, 100 requests)
./scripts/load_testing/simple_load_test.sh

# Custom configuration
HOST=http://localhost:8000 \
CONCURRENT_USERS=50 \
TOTAL_REQUESTS=500 \
./scripts/load_testing/simple_load_test.sh

# Stress test (high concurrency)
CONCURRENT_USERS=100 TOTAL_REQUESTS=1000 \
./scripts/load_testing/simple_load_test.sh
```

**Output Files:**
- `results_TIMESTAMP.txt`: Raw CSV data
- `summary_TIMESTAMP.txt`: Summary report

**Statistics Calculated:**
- Total/successful/failed requests
- Success rate (%)
- Response times: avg, min, max
- Percentiles: p50, p95, p99

**Performance Targets:**
- p95 < 1000ms
- Average < 500ms
- Success rate >= 99%

## Endpoints Tested

### Core API
- `/api/dora/metrics/` - DORA summary
- `/api/dora/dashboard/` - Dashboard page
- `/api/dora/charts/deployment-frequency/` - Chart data
- `/api/dora/charts/lead-time-trends/` - Trend data

### Data Catalog (AI Capability 6)
- `/api/dora/data-catalog/` - Catalog index
- `/api/dora/data-catalog/dora-metrics/` - Query metrics

### Ecosystem Health (AI Capability 7)
- `/api/dora/ecosystem/health/` - Health status
- `/api/dora/ecosystem/quality/` - Quality assessment

### Advanced Analytics
- `/api/dora/analytics/trends/deployment-frequency/` - Trend analysis
- `/api/dora/analytics/comparative/period-over-period/` - Comparisons

## Test Scenarios

### Scenario 1: Normal Load
**Config:** 10 concurrent users, 5 min duration
**Expected:** All endpoints < 500ms average
**Purpose:** Validate normal operation

```bash
locust -f locustfile.py --host=http://localhost:8000 \
 --users 10 --spawn-rate 2 --run-time 5m --headless
```

### Scenario 2: Peak Load
**Config:** 50 concurrent users, 10 min duration
**Expected:** p95 < 1s, success rate > 99%
**Purpose:** Simulate peak traffic

```bash
locust -f locustfile.py --host=http://localhost:8000 \
 --users 50 --spawn-rate 5 --run-time 10m --headless
```

### Scenario 3: Stress Test
**Config:** 100+ concurrent users, 15 min duration
**Expected:** Identify breaking point
**Purpose:** Find system limits

```bash
locust -f locustfile.py --host=http://localhost:8000 \
 --users 100 --spawn-rate 10 --run-time 15m --headless
```

### Scenario 4: Endurance Test
**Config:** 20 concurrent users, 1 hour duration
**Expected:** Stable performance over time
**Purpose:** Detect memory leaks, degradation

```bash
locust -f locustfile.py --host=http://localhost:8000 \
 --users 20 --spawn-rate 2 --run-time 1h --headless
```

## Performance Targets

### Response Time Targets
| Metric | Target | Threshold |
|--------|--------|-----------|
| Average | < 300ms | < 500ms |
| Median (p50) | < 200ms | < 400ms |
| 95th Percentile (p95) | < 800ms | < 1000ms |
| 99th Percentile (p99) | < 1500ms | < 2000ms |
| Maximum | < 3000ms | < 5000ms |

### Throughput Targets
| Load Level | Target RPS | Min Success Rate |
|------------|------------|------------------|
| Normal (10 users) | 50+ | 99.9% |
| Peak (50 users) | 200+ | 99.5% |
| Stress (100 users) | 300+ | 99.0% |

### System Resources (During Peak)
| Resource | Target | Max |
|----------|--------|-----|
| CPU Usage | < 70% | < 85% |
| Memory Usage | < 60% | < 75% |
| DB Connections | < 50 | < 80 |

## Monitoring During Tests

### System Metrics to Track

```bash
# CPU and Memory
top -b -n 1 | head -20

# Database connections
mysql -e "SHOW STATUS LIKE 'Threads_connected';"

# Slow queries
mysql -e "SHOW PROCESSLIST;" | grep -v Sleep

# Application logs
tail -f /var/log/iact/app.json.log | grep -i error
```

### Django Monitoring

```python
# Add to settings.py for debug
LOGGING = {
 'loggers': {
 'django.db.backends': {
 'level': 'DEBUG', # Log SQL queries
 }
 }
}
```

## Results Analysis

### Locust HTML Report

Includes:
- Request statistics table
- Response time charts
- Failures table
- Download data (CSV)

### Simple Script Results

Example output:
```
========================================
Request Statistics
========================================
Total Requests: 100
Successful (200): 98
Failed: 2
Success Rate: 98.00%

========================================
Response Time Statistics (ms)
========================================
Average: 245.50
Minimum: 120
Maximum: 980
Median (p50): 210
95th Percentile (p95): 650
99th Percentile (p99): 950

========================================
Performance Assessment
========================================
[x] PASS: p95 response time under 1 second
[x] PASS: Average response time under 500ms
[ ] FAIL: Success rate < 99%
```

## Troubleshooting

### High Response Times

**Causes:**
- Database connection pool exhaustion
- Missing database indices
- N+1 query problems
- Network latency

**Solutions:**
- Increase `CONN_MAX_AGE` in settings
- Add database indices
- Use `select_related()` / `prefetch_related()`
- Optimize queries

### High Failure Rate

**Causes:**
- Rate limiting triggered
- Database connection errors
- Application errors
- Insufficient resources

**Solutions:**
- Adjust rate limits
- Increase DB max connections
- Fix application bugs
- Scale resources

### Memory Leaks

**Detection:**
- Memory usage increases over time
- Performance degrades in endurance tests

**Solutions:**
- Profile with memory_profiler
- Check for unclosed connections
- Review object lifecycle
- Restart workers periodically

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Load Testing

on:
 schedule:
 - cron: '0 2 * * 1' # Weekly, Monday 2 AM
 workflow_dispatch:

jobs:
 load-test:
 runs-on: ubuntu-latest

 services:
 mysql:
 image: mysql:8.0
 env:
 MYSQL_DATABASE: iact
 MYSQL_ROOT_PASSWORD: root
 ports:
 - 3306:3306

 steps:
 - uses: actions/checkout@v3

 - name: Set up Python
 uses: actions/setup-python@v4
 with:
 python-version: '3.11'

 - name: Install dependencies
 run: |
 pip install -r requirements.txt
 pip install locust

 - name: Run migrations
 run: |
 cd api/callcentersite
 python manage.py migrate

 - name: Start Django server
 run: |
 cd api/callcentersite
 python manage.py runserver &
 sleep 5

 - name: Run load test
 run: |
 locust -f scripts/load_testing/locustfile.py \
 --host=http://localhost:8000 \
 --users 20 \
 --spawn-rate 5 \
 --run-time 3m \
 --headless \
 --html load_test_report.html

 - name: Upload report
 uses: actions/upload-artifact@v3
 with:
 name: load-test-report
 path: load_test_report.html
```

## Best Practices

### Before Load Testing
1. **Use staging environment** - Never production
2. **Baseline metrics** - Know normal performance
3. **Monitor resources** - CPU, memory, DB
4. **Backup data** - In case of issues

### During Load Testing
1. **Gradual ramp-up** - Don't spike immediately
2. **Monitor continuously** - Watch for errors
3. **Multiple runs** - Verify consistency
4. **Document results** - Save all reports

### After Load Testing
1. **Analyze results** - Identify bottlenecks
2. **Compare baselines** - Track improvements
3. **Fix issues** - Address problems found
4. **Retest** - Verify fixes work

## Compliance

### RNF-002
[OK] **COMPLIANT** - Uses existing infrastructure

### Performance
- Target: p95 < 1s
- Success rate: >= 99%
- Scalability: 100+ concurrent users

---

**VERSION:** 1.0.0
**ESTADO:** COMPLETADO
**STORY POINTS:** 5 SP
**FECHA:** 2025-11-07
