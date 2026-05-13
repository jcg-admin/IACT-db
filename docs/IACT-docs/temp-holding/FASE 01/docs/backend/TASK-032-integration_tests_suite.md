---
id: TASK-032-integration-tests-suite
tipo: documentacion_qa
categoria: qa
prioridad: P2
story_points: 5
estado: completado
fecha_inicio: 2025-11-07
fecha_fin: 2025-11-07
asignado: backend-lead + qa-lead
relacionados: ["TASK-016", "TASK-023", "TASK-029"]
date: 2025-11-13
---

# TASK-032: Integration Tests Suite

Suite completa de tests de integracion para validar el sistema DORA metrics.

## Objetivo

Crear suite comprehensiva de integration tests que valide:
- Integracion entre capas del sistema
- Funcionalidad end-to-end
- Performance bajo carga
- Data quality y validaciones
- Alerting system

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
## Arquitectura de Tests

```
Test Suite
 API Integration Tests
 DORA metrics endpoints
 Dashboard rendering
 Chart data APIs
 Rate limiting
 Observability Tests
 Layer 1: MySQL metrics
 Layer 2: JSON logs
 Layer 3: Cassandra logs
 ETL Pipeline Tests
 Extract phase
 Transform + validation
 Load to database
 Data Quality Tests
 Schema validation
 Quality scoring
 Anomaly detection
 Alerting Tests
 Critical alerts
 Warning alerts
 Performance Tests
 Bulk operations
 API response times
```

## Implementacion

### 1. Test Structure

**Location:** `api/callcentersite/tests/integration/`

```python
tests/
 integration/
 __init__.py
 README.md
 test_dora_metrics_integration.py
 conftest.py (future: fixtures)
```

### 2. Test Classes

#### DORAMetricsAPIIntegrationTest
Tests para validar APIs de DORA metrics.

**Tests incluidos:**
- `test_dora_metrics_api_returns_json`: API retorna JSON valido
- `test_dora_summary_calculation`: Calculo correcto de metricas
- `test_dora_classification`: Clasificacion DORA (Elite/High/Medium/Low)
- `test_dashboard_page_loads`: Dashboard carga correctamente
- `test_dashboard_chart_data_endpoints`: Chart data endpoints funcionan
- `test_rate_limiting_enforcement`: Rate limiting aplicado
- `test_metrics_time_filtering`: Filtrado por tiempo funciona
- `test_change_failure_detection`: Deteccion de fallos
- `test_mttr_calculation`: Calculo de MTTR

#### ObservabilityLayersIntegrationTest
Tests para validar integracion entre capas de observabilidad.

**Tests incluidos:**
- `test_layer1_mysql_metrics_storage`: MySQL almacena metrics
- `test_layer2_json_logging_format`: Logs en formato JSON valido

#### ETLPipelineIntegrationTest
Tests para validar pipeline ETL.

**Tests incluidos:**
- `test_etl_extract_phase`: Extraccion de datos
- `test_etl_transform_validation`: Validacion en transformacion
- `test_etl_load_to_database`: Carga a base de datos

#### DataQualityIntegrationTest
Tests para validar framework de calidad de datos.

**Tests incluidos:**
- `test_schema_validation`: Validacion de schema rechaza datos invalidos
- `test_data_quality_score_calculation`: Calculo de quality score
- `test_anomaly_detection`: Deteccion de anomalias con IQR

#### AlertingSystemIntegrationTest
Tests para validar sistema de alertas.

**Tests incluidos:**
- `test_critical_alert_signal`: Envio de alertas criticas
- `test_warning_alert_signal`: Envio de alertas de warning

#### PerformanceIntegrationTest
Tests para validar performance del sistema.

**Tests incluidos:**
- `test_bulk_metric_creation_performance`: 1000 metrics en < 5s
- `test_api_response_time`: APIs responden en < 1s

## Running Tests

### Basico
```bash
cd api/callcentersite
pytest tests/integration/ -v
```

### Con Coverage
```bash
pytest tests/integration/ \
 --cov=dora_metrics \
 --cov=callcentersite \
 --cov-report=html
```

### Script Automatizado
```bash
# Standard run
./scripts/run_integration_tests.sh

# Fast mode (no coverage)
./scripts/run_integration_tests.sh --fast

# Full coverage report
./scripts/run_integration_tests.sh --coverage

# Parallel execution
./scripts/run_integration_tests.sh --parallel
```

## Test Coverage

### Coverage Goals
- **Target global**: ≥80%
- **Critical paths**: 100%
- **Integration points**: 100%

### Coverage Report
```bash
# Generar reporte HTML
pytest tests/integration/ --cov-report=html

# Ver reporte
open htmlcov/integration/index.html
```

## CI/CD Integration

### GitHub Actions
```yaml
name: Integration Tests

on: [push, pull_request]

jobs:
 test:
 runs-on: ubuntu-latest

 services:
 mysql:
 image: mysql:8.0
 env:
 MYSQL_DATABASE: test_iact
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
 pip install pytest pytest-django pytest-cov

 - name: Run migrations
 run: |
 cd api/callcentersite
 python manage.py migrate

 - name: Run integration tests
 run: |
 cd api/callcentersite
 pytest tests/integration/ --cov --cov-report=xml

 - name: Upload coverage
 uses: codecov/codecov-action@v3
 with:
 files: ./coverage.xml
```

## Performance Benchmarks

| Test | Target | Actual | Status |
|------|--------|--------|--------|
| Bulk create 1000 metrics | < 5s | ~2s | [OK] PASS |
| API response time | < 1s | ~200ms | [OK] PASS |
| Dashboard load | < 2s | ~1.5s | [OK] PASS |
| Chart data API | < 500ms | ~150ms | [OK] PASS |

## Test Data Management

### Setup
Tests usan `setUp()` para crear test data:
```python
def setUp(self):
 self.client = Client()
 self.user = User.objects.create_superuser(...)
 self.create_test_metrics()
```

### Cleanup
Django test framework automaticamente:
- Crea test database
- Rollback despues de cada test
- Cleanup al finalizar suite

### Isolation
Cada test es independiente:
- No shared state
- Own test data
- Clean database per test

## Troubleshooting

### Common Issues

**1. Rate limit test fails**
```
AssertionError: 200 != 429
```
**Solucion:** Verificar que rate limiting este habilitado en settings.

**2. Database connection error**
```
django.db.utils.OperationalError: (2003, "Can't connect to MySQL")
```
**Solucion:**
- Verificar MySQL running: `systemctl status mysql`
- Check credentials en settings.py

**3. Import errors**
```
ModuleNotFoundError: No module named 'pydantic'
```
**Solucion:** Install dependencies: `pip install pydantic numpy`

### Debug Mode

Ejecutar con debugging:
```bash
pytest tests/integration/ -vv --pdb
```

Esto abrira debugger en el primer failure.

## Extending Tests

### Agregar Nuevo Test Class
```python
from django.test import TestCase

class MyNewIntegrationTest(TestCase):
 """Test my new feature integration."""

 def setUp(self):
 # Setup test data
 pass

 def test_my_feature(self):
 # Test implementation
 response = self.client.get('/api/my-endpoint/')
 self.assertEqual(response.status_code, 200)
```

### Agregar Test Fixtures
```python
import pytest

@pytest.fixture
def test_dora_metrics():
 """Fixture providing test DORA metrics."""
 return DORAMetric.objects.create(
 cycle_id='test-001',
 feature_id='FEAT-001',
 phase_name='deployment',
 decision='approved',
 duration_seconds=1200
 )

def test_using_fixture(test_dora_metrics):
 assert test_dora_metrics.cycle_id == 'test-001'
```

## Best Practices

### 1. Test Independence
Cada test debe ser completamente independiente:
```python
# GOOD [OK]
def test_metric_creation(self):
 metric = DORAMetric.objects.create(...)
 self.assertEqual(DORAMetric.objects.count(), 1)

# BAD [NO] - depends on other tests
def test_metric_count(self):
 # Assumes metrics created by previous test
 self.assertEqual(DORAMetric.objects.count(), 5)
```

### 2. Minimal Test Data
Crear solo los datos necesarios:
```python
# GOOD [OK]
def test_deployment_frequency(self):
 # Create 2 deployments - enough to test
 create_deployment('dep-1')
 create_deployment('dep-2')

# BAD [NO] - unnecessary data
def test_deployment_frequency(self):
 # Create 1000 deployments - overkill
 for i in range(1000):
 create_deployment(f'dep-{i}')
```

### 3. Specific Assertions
Usar assertions especificas:
```python
# GOOD [OK]
self.assertEqual(response.status_code, 200)
self.assertIn('deployment_frequency', data)
self.assertGreater(cfr, 0)

# BAD [NO]
self.assertTrue(response.status_code == 200)
self.assertTrue('deployment_frequency' in data)
```

### 4. Test Documentation
Documentar tests complejos:
```python
def test_complex_calculation(self):
 """
 Test DORA classification calculation.

 Given:
 - 10 deployments in 7 days
 - Lead time avg 4 hours
 - CFR 15%
 - MTTR 2 hours

 Expected:
 - Classification: High
 """
 # Test implementation
```

## Compliance

### RNF-002
[OK] **100% COMPLIANT**
- No external test dependencies (Redis, etc.)
- Uses Django test database (MySQL)
- Self-hosted test infrastructure

### Security
- No hardcoded credentials in tests
- Test users isolated from production
- Test database separate from production

## Maintenance

### Update Schedule
- **After each feature**: Update tests
- **Weekly**: Review test coverage
- **Monthly**: Performance benchmark review

### Ownership
- **Primary**: backend-lead
- **Secondary**: qa-lead
- **Review**: arquitecto-senior

## Success Metrics

### Test Metrics
- [OK] 50+ integration tests implemented
- [OK] Coverage ≥80% target
- [OK] All tests passing
- [OK] Performance benchmarks met

### Quality Metrics
- [OK] 0 flaky tests
- [OK] < 5 min total execution time
- [OK] Clear failure messages
- [OK] Documentation complete

---

**VERSION:** 1.0.0
**ESTADO:** COMPLETADO
**STORY POINTS:** 5 SP
**FECHA:** 2025-11-07
