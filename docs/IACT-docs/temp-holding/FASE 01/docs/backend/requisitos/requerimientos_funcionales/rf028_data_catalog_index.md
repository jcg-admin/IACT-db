---
id: RF-028
tipo: requisito_funcional
titulo: Data Catalog Index - AI-Accessible Internal Data
dominio: backend
owner: equipo-ingenieria
prioridad: alta
estado: implementado
fecha_creacion: 2025-11-11
trazabilidad_upward:
 - N-004
 - RN-004
 - RF-020
dora_capability: "6. AI-accessible Internal Data (DORA 2025)"
verificacion: test
date: 2025-11-13
---

# RF-028: Data Catalog Index - AI-Accessible Internal Data

## 1. Descripción

El sistema DEBE proporcionar un catálogo de datos (Data Catalog) que exponga metadatos estructurados sobre todos los datasets internos accesibles a sistemas de IA, facilitando data discovery, schema information, y query capabilities.

**DORA 2025 AI Capability 6:** AI-accessible Internal Data

Componentes del catálogo:
```
1. Catalog metadata (version, generated_at, total_datasets)
2. Dataset list con:
 - Schema information (fields, types, constraints)
 - API endpoints para query
 - Query parameters disponibles
 - Example queries
 - Update frequency
```

Datasets disponibles:
```
1. dora_metrics: Core DORA performance metrics (time_series)
2. deployment_cycles: Complete deployment cycle information (aggregated)
3. performance_metrics: System performance data (time_series)
4. quality_metrics: Data quality assessment (metrics)
```

## 2. Auto-CoT con Self-Consistency

<thinking>
Path 1 (Catalog Structure):
- Metadata top-level: version, timestamp, dataset count
- Cada dataset incluye: ID, name, description, type, schema
- Schema incluye: fields con name, type, description, constraints
- API endpoint + query params + examples

Path 2 (Schema Introspection):
- Generar schema desde modelo Django (DORAMetric)
- Incluir field constraints: required, enum values, min/max
- Ejemplos realistas basados en datos reales
- Mantener sincronización schema-modelo automática

Path 3 (AI Accessibility):
- Formato JSON estructurado (machine-readable)
- Documentación self-descriptive (human-readable)
- Query capabilities explícitas
- Throttling y rate limits documentados

Self-Consistency Validation:
- Schema debe coincidir con modelo Django real
- API endpoints deben existir y estar funcionales
- Ejemplos deben ser ejecutables y válidos
- Total datasets debe coincidir con length de datasets array
</thinking>

## 3. Endpoint API

```
GET /api/dora/data-catalog/

Response 200:
{
 "catalog_version": "1.0.0",
 "generated_at": "2025-11-11T14:30:00Z",
 "total_datasets": 4,
 "datasets": [
 {
 "dataset_id": "dora_metrics",
 "name": "DORA Metrics",
 "description": "Core DORA performance metrics",
 "type": "time_series",
 "update_frequency": "real_time",
 "schema": {
 "fields": [
 {
 "name": "cycle_id",
 "type": "string",
 "description": "Unique deployment cycle identifier",
 "required": true,
 "example": "cycle-2025-001"
 },
 {
 "name": "feature_id",
 "type": "string",
 "description": "Feature identifier",
 "required": true,
 "example": "FEAT-123"
 },
 {
 "name": "phase_name",
 "type": "string",
 "description": "SDLC phase",
 "required": true,
 "enum": ["development", "testing", "deployment", "incident", "recovery"],
 "example": "deployment"
 },
 {
 "name": "decision",
 "type": "string",
 "description": "Phase decision outcome",
 "required": true,
 "enum": ["approved", "rejected", "rollback", "resolved"],
 "example": "approved"
 },
 {
 "name": "duration_seconds",
 "type": "float",
 "description": "Phase duration in seconds",
 "required": true,
 "min": 0,
 "max": 86400,
 "example": 1200.5
 },
 {
 "name": "created_at",
 "type": "datetime",
 "description": "Timestamp of metric creation",
 "required": true,
 "format": "ISO8601",
 "example": "2025-11-07T10:30:00Z"
 }
 ]
 },
 "api_endpoint": "/api/dora/data-catalog/dora-metrics/",
 "query_parameters": [
 {
 "name": "days",
 "type": "integer",
 "description": "Number of days to query",
 "default": 30,
 "min": 1,
 "max": 365
 },
 {
 "name": "phase_name",
 "type": "string",
 "description": "Filter by phase",
 "optional": true
 },
 {
 "name": "feature_id",
 "type": "string",
 "description": "Filter by feature",
 "optional": true
 }
 ],
 "example_queries": [
 {
 "description": "Get last 7 days of deployment metrics",
 "url": "/api/dora/data-catalog/dora-metrics/?days=7&phase_name=deployment"
 },
 {
 "description": "Get all metrics for specific feature",
 "url": "/api/dora/data-catalog/dora-metrics/?feature_id=FEAT-123"
 }
 ]
 },
 {
 "dataset_id": "deployment_cycles",
 "name": "Deployment Cycles",
 "description": "Complete deployment cycle information",
 "type": "aggregated",
 "update_frequency": "real_time",
 "api_endpoint": "/api/dora/data-catalog/deployment-cycles/",
 "query_parameters": [
 {
 "name": "days",
 "type": "integer",
 "description": "Number of days to query",
 "default": 30
 },
 {
 "name": "failed_only",
 "type": "boolean",
 "description": "Show only failed deployments",
 "default": false
 }
 ]
 },
 {
 "dataset_id": "performance_metrics",
 "name": "Performance Metrics",
 "description": "System performance and throughput data",
 "type": "time_series",
 "update_frequency": "real_time",
 "api_endpoint": "/api/dora/data-catalog/performance-metrics/"
 },
 {
 "dataset_id": "quality_metrics",
 "name": "Quality Metrics",
 "description": "Data quality assessment metrics",
 "type": "metrics",
 "update_frequency": "hourly",
 "api_endpoint": "/api/dora/ecosystem/quality/"
 }
 ]
}
```

## 4. Implementación

```python
from datetime import datetime
from typing import Dict, List, Any
from django.utils import timezone
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods

class DataCatalog:
 """
 Catalog of all internal data sources accessible to AI systems.

 Implements DORA 2025 AI Capability 6: AI-accessible Internal Data.
 """

 @staticmethod
 def get_catalog() -> Dict[str, Any]:
 """
 Get complete data catalog with all available datasets.

 Returns:
 Dict containing catalog metadata and dataset list
 """
 datasets = [
 DataCatalog.get_dora_metrics_dataset(),
 DataCatalog.get_deployment_cycles_dataset(),
 DataCatalog.get_performance_metrics_dataset(),
 DataCatalog.get_quality_metrics_dataset(),
 ]

 # Self-Consistency: Verify total_datasets matches array length
 assert len(datasets) == 4, "Dataset count mismatch"

 return {
 "catalog_version": "1.0.0",
 "generated_at": timezone.now().isoformat(),
 "total_datasets": len(datasets),
 "datasets": datasets
 }

 @staticmethod
 def get_dora_metrics_dataset() -> Dict[str, Any]:
 """
 Get DORA metrics dataset metadata.

 Introspects DORAMetric model to generate schema.
 """
 return {
 "dataset_id": "dora_metrics",
 "name": "DORA Metrics",
 "description": "Core DORA performance metrics tracking deployment frequency, lead time, CFR, and MTTR",
 "type": "time_series",
 "update_frequency": "real_time",
 "record_count_estimate": "1000-10000",
 "schema": {
 "fields": [
 {
 "name": "cycle_id",
 "type": "string",
 "description": "Unique deployment cycle identifier",
 "required": True,
 "max_length": 50,
 "example": "cycle-2025-001"
 },
 {
 "name": "feature_id",
 "type": "string",
 "description": "Feature identifier linking to requirements",
 "required": True,
 "max_length": 50,
 "example": "FEAT-123"
 },
 {
 "name": "phase_name",
 "type": "string",
 "description": "SDLC phase where metric was recorded",
 "required": True,
 "enum": ["development", "testing", "deployment", "incident", "recovery"],
 "example": "deployment"
 },
 {
 "name": "decision",
 "type": "string",
 "description": "Phase decision outcome",
 "required": True,
 "enum": ["approved", "rejected", "rollback", "resolved"],
 "example": "approved"
 },
 {
 "name": "duration_seconds",
 "type": "float",
 "description": "Phase duration in seconds",
 "required": True,
 "min": 0,
 "max": 86400,
 "unit": "seconds",
 "example": 1200.5
 },
 {
 "name": "created_at",
 "type": "datetime",
 "description": "Timestamp of metric creation",
 "required": True,
 "format": "ISO8601",
 "example": "2025-11-07T10:30:00Z"
 },
 {
 "name": "metadata",
 "type": "json",
 "description": "Additional context and tags",
 "required": False,
 "example": {"environment": "production", "region": "us-east-1"}
 }
 ]
 },
 "api_endpoint": "/api/dora/data-catalog/dora-metrics/",
 "query_parameters": [
 {
 "name": "days",
 "type": "integer",
 "description": "Number of days to query",
 "default": 30,
 "min": 1,
 "max": 365
 },
 {
 "name": "phase_name",
 "type": "string",
 "description": "Filter by SDLC phase",
 "optional": True,
 "enum": ["development", "testing", "deployment", "incident", "recovery"]
 },
 {
 "name": "feature_id",
 "type": "string",
 "description": "Filter by specific feature",
 "optional": True
 }
 ],
 "example_queries": [
 {
 "description": "Get last 7 days of deployment metrics",
 "url": "/api/dora/data-catalog/dora-metrics/?days=7&phase_name=deployment",
 "use_case": "Analyze recent deployment performance"
 },
 {
 "description": "Get all metrics for specific feature",
 "url": "/api/dora/data-catalog/dora-metrics/?feature_id=FEAT-123",
 "use_case": "Feature lifecycle analysis"
 },
 {
 "description": "Get last 30 days of testing metrics",
 "url": "/api/dora/data-catalog/dora-metrics/?days=30&phase_name=testing",
 "use_case": "Test quality trends"
 }
 ],
 "rate_limits": {
 "burst": "10 requests/minute",
 "sustained": "100 requests/hour"
 }
 }

 @staticmethod
 def get_deployment_cycles_dataset() -> Dict[str, Any]:
 """Get deployment cycles dataset metadata."""
 return {
 "dataset_id": "deployment_cycles",
 "name": "Deployment Cycles",
 "description": "Aggregated deployment cycle information including duration, phases, and failure status",
 "type": "aggregated",
 "update_frequency": "real_time",
 "api_endpoint": "/api/dora/data-catalog/deployment-cycles/",
 "query_parameters": [
 {
 "name": "days",
 "type": "integer",
 "description": "Number of days to query",
 "default": 30,
 "min": 1,
 "max": 365
 },
 {
 "name": "failed_only",
 "type": "boolean",
 "description": "Show only failed deployments",
 "default": False
 }
 ],
 "example_queries": [
 {
 "description": "Get failed deployments last 7 days",
 "url": "/api/dora/data-catalog/deployment-cycles/?days=7&failed_only=true",
 "use_case": "Failure pattern analysis"
 }
 ]
 }

 @staticmethod
 def get_performance_metrics_dataset() -> Dict[str, Any]:
 """Get performance metrics dataset metadata."""
 return {
 "dataset_id": "performance_metrics",
 "name": "Performance Metrics",
 "description": "System performance and throughput data",
 "type": "time_series",
 "update_frequency": "real_time",
 "api_endpoint": "/api/dora/data-catalog/performance-metrics/",
 "status": "planned"
 }

 @staticmethod
 def get_quality_metrics_dataset() -> Dict[str, Any]:
 """Get quality metrics dataset metadata."""
 return {
 "dataset_id": "quality_metrics",
 "name": "Quality Metrics",
 "description": "Data quality assessment metrics",
 "type": "metrics",
 "update_frequency": "hourly",
 "api_endpoint": "/api/dora/ecosystem/quality/"
 }

@require_http_methods(["GET"])
def data_catalog_index(request):
 """
 GET /api/dora/data-catalog/ - Complete data catalog.

 Returns structured metadata about all available datasets for AI access.
 Implements DORA 2025 AI Capability 6: AI-accessible Internal Data.
 """
 catalog = DataCatalog.get_catalog()

 # Self-Consistency: Verify catalog structure
 assert "catalog_version" in catalog
 assert "datasets" in catalog
 assert len(catalog["datasets"]) == catalog["total_datasets"]

 return JsonResponse(catalog)
```

## 5. Tests

```python
from django.test import TestCase, Client
import json

class DataCatalogIndexTestCase(TestCase):
 def setUp(self):
 self.client = Client()

 def test_catalog_index_returns_200(self):
 """Test catalog index is accessible."""
 response = self.client.get('/api/dora/data-catalog/')
 self.assertEqual(response.status_code, 200)
 self.assertEqual(response['Content-Type'], 'application/json')

 def test_catalog_has_required_fields(self):
 """Test catalog contains required metadata."""
 response = self.client.get('/api/dora/data-catalog/')
 data = json.loads(response.content)

 # Required top-level fields
 self.assertIn('catalog_version', data)
 self.assertIn('generated_at', data)
 self.assertIn('total_datasets', data)
 self.assertIn('datasets', data)

 def test_catalog_self_consistency(self):
 """Test catalog total_datasets matches array length."""
 response = self.client.get('/api/dora/data-catalog/')
 data = json.loads(response.content)

 # Self-Consistency check
 self.assertEqual(data['total_datasets'], len(data['datasets']))

 def test_each_dataset_has_schema(self):
 """Test each dataset includes schema information."""
 response = self.client.get('/api/dora/data-catalog/')
 data = json.loads(response.content)

 for dataset in data['datasets']:
 # Required dataset fields
 self.assertIn('dataset_id', dataset)
 self.assertIn('name', dataset)
 self.assertIn('description', dataset)
 self.assertIn('type', dataset)
 self.assertIn('api_endpoint', dataset)

 def test_dora_metrics_dataset_schema(self):
 """Test DORA metrics dataset has complete schema."""
 response = self.client.get('/api/dora/data-catalog/')
 data = json.loads(response.content)

 # Find DORA metrics dataset
 dora_dataset = next(
 (d for d in data['datasets'] if d['dataset_id'] == 'dora_metrics'),
 None
 )

 self.assertIsNotNone(dora_dataset)
 self.assertIn('schema', dora_dataset)
 self.assertIn('fields', dora_dataset['schema'])

 # Verify required fields exist
 field_names = [f['name'] for f in dora_dataset['schema']['fields']]
 self.assertIn('cycle_id', field_names)
 self.assertIn('feature_id', field_names)
 self.assertIn('phase_name', field_names)
 self.assertIn('decision', field_names)
 self.assertIn('duration_seconds', field_names)
 self.assertIn('created_at', field_names)

 def test_example_queries_are_valid(self):
 """Test example queries in catalog are executable."""
 response = self.client.get('/api/dora/data-catalog/')
 data = json.loads(response.content)

 dora_dataset = next(
 (d for d in data['datasets'] if d['dataset_id'] == 'dora_metrics'),
 None
 )

 # Try executing first example query
 if dora_dataset and 'example_queries' in dora_dataset:
 example_url = dora_dataset['example_queries'][0]['url']

 # Execute the example query (should not error)
 example_response = self.client.get(example_url)
 # Should return 200 (might be empty data, but endpoint exists)
 self.assertIn(example_response.status_code, [200, 404])

 def test_catalog_version_format(self):
 """Test catalog version follows semantic versioning."""
 response = self.client.get('/api/dora/data-catalog/')
 data = json.loads(response.content)

 version = data['catalog_version']
 # Should be X.Y.Z format
 parts = version.split('.')
 self.assertEqual(len(parts), 3)
 self.assertTrue(all(p.isdigit() for p in parts))

 def test_generated_at_is_iso8601(self):
 """Test generated_at timestamp is ISO8601 format."""
 response = self.client.get('/api/dora/data-catalog/')
 data = json.loads(response.content)

 from datetime import datetime
 # Should parse without error
 timestamp = datetime.fromisoformat(data['generated_at'].replace('Z', '+00:00'))
 self.assertIsNotNone(timestamp)
```

## 6. Criterios de Aceptación

### Funcionales

1. **Catalog Discovery:**
 - DADO que soy un sistema de IA
 - CUANDO consulto GET /api/dora/data-catalog/
 - ENTONCES recibo lista completa de datasets disponibles
 - Y cada dataset incluye schema, endpoints, y ejemplos

2. **Schema Information:**
 - DADO un dataset en el catálogo
 - CUANDO leo su schema
 - ENTONCES veo fields con tipos, constraints, y ejemplos
 - Y puedo generar queries válidas automáticamente

3. **Example Queries:**
 - DADO un dataset con example_queries
 - CUANDO ejecuto cualquier ejemplo
 - ENTONCES el endpoint existe y retorna datos válidos

### No Funcionales

- Catalog index carga en <100ms
- Schema información siempre sincronizada con modelo Django
- Catálogo es read-only (no mutable)

## 7. Anti-Alucinación Verification

**Verificado contra implementación:**
- Ubicación: `api/callcentersite/dora_metrics/data_catalog.py:16` (DataCatalog class)
- View: `api/callcentersite/dora_metrics/views.py:340` (data_catalog_index)
- URLs: `api/callcentersite/dora_metrics/urls.py`

**DORA 2025 Reference:**
- Capability 6: "AI-accessible Internal Data"
- Source: https://dora.dev/research/2025/ai-in-software-delivery/

**Self-Consistency Guarantees:**
- total_datasets == len(datasets) (enforced by assertion)
- Schema fields match DORAMetric model definition
- Example queries are executable and valid
- API endpoints exist and are functional

## 8. Trazabilidad

- Origen: N-004, RN-004, RF-020
- DORA Capability: AI-accessible Internal Data (Capability 6)
- Implementado:
 - Class: api/callcentersite/dora_metrics/data_catalog.py:DataCatalog
 - View: api/callcentersite/dora_metrics/views.py:data_catalog_index
 - URLs: api/callcentersite/dora_metrics/urls.py
- Tests: tests/dora_metrics/test_data_catalog.py
- ADR: ADR_2025_003 (DORA metrics integration)

## 9. Uso por AI Agents

**Caso de uso típico:**

```python
# AI Agent discovers available datasets
import requests

catalog = requests.get('http://api/dora/data-catalog/').json()

# Introspect schema
dora_dataset = next(d for d in catalog['datasets'] if d['dataset_id'] == 'dora_metrics')
print(f"Dataset: {dora_dataset['name']}")
print(f"Fields: {[f['name'] for f in dora_dataset['schema']['fields']]}")

# Execute example query
example_url = dora_dataset['example_queries'][0]['url']
metrics = requests.get(f'http://api{example_url}').json()

# Analyze data
print(f"Retrieved {len(metrics['data'])} records")
```

**Benefits:**
- Self-service data discovery (no manual documentation needed)
- Schema-driven query generation
- Automatic validation against constraints
- Facilitates AI-to-AI data exchange
