---
id: DOC-ARQ-LINEAMIENTOS
estado: activo
propietario: equipo-arquitectura
ultima_actualizacion: 2025-11-02
relacionados: ["DOC-ARQ-INDEX", "DOC-GOB-INDEX"]
date: 2025-11-13
---
# Lineamientos de Código - Proyecto IACT

Este documento establece los estándares de código, convenciones de nombrado, y mejores prácticas que deben seguirse en el desarrollo del proyecto IACT.

## Página padre
- [Arquitectura](README.md)

## Python / Django

### Convenciones de Nombrado

```python
# Clases: PascalCase
class CallCenterMetrics:
 pass

# Funciones y métodos: snake_case
def calculate_average_handling_time(calls):
 pass

# Constantes: UPPER_SNAKE_CASE
MAX_RETRY_ATTEMPTS = 3
DATABASE_TIMEOUT = 30

# Variables privadas: _prefijo
class Service:
 def __init__(self):
 self._internal_state = {}

# Variables protegidas: __prefijo (name mangling)
class BaseModel:
 def __init__(self):
 self.__private_data = None
```

### Estructura de Módulos

```
proyecto/
 models/ # Modelos de Django
 __init__.py
 call.py
 agent.py
 services/ # Lógica de negocio
 __init__.py
 metrics_service.py
 etl_service.py
 repositories/ # Acceso a datos
 __init__.py
 call_repository.py
 serializers/ # Django REST serializers
 views/ # Vistas/ViewSets
 tests/ # Tests unitarios e integración
 utils/ # Utilidades compartidas
```

### Docstrings

Usar **Google Style** para docstrings:

```python
def process_call_data(call_id: int, include_metadata: bool = False) -> dict:
 """Procesa los datos de una llamada específica.

 Extrae la información de la llamada desde la base de datos IVR,
 aplica transformaciones necesarias y retorna un diccionario con
 los datos procesados.

 Args:
 call_id: ID único de la llamada a procesar
 include_metadata: Si True, incluye metadatos adicionales

 Returns:
 Diccionario con los datos procesados de la llamada:
 {
 'duration': int,
 'agent_id': int,
 'queue_time': int,
 'metadata': dict (opcional)
 }

 Raises:
 CallNotFoundError: Si la llamada no existe
 DatabaseConnectionError: Si falla la conexión a DB

 Examples:
 >>> process_call_data(12345)
 {'duration': 120, 'agent_id': 42, 'queue_time': 30}
 """
 pass
```

### Type Hints

**Obligatorio** usar type hints en todas las funciones públicas:

```python
from typing import List, Dict, Optional, Union
from datetime import datetime

def get_calls_by_date(
 start_date: datetime,
 end_date: datetime,
 agent_ids: Optional[List[int]] = None
) -> List[Dict[str, Union[int, str, float]]]:
 """Retorna llamadas en rango de fechas."""
 pass
```

### Imports

Orden de imports según PEP 8:

```python
# 1. Standard library
import os
import sys
from datetime import datetime
from typing import List, Dict

# 2. Third-party packages
import django
from django.db import models
from rest_framework import serializers

# 3. Local application imports
from .models import Call
from .services import MetricsService
from ..utils import format_duration
```

### Gestión de Errores

```python
# Usar excepciones específicas
class CallCenterException(Exception):
 """Excepción base del dominio."""
 pass

class CallNotFoundError(CallCenterException):
 """Llamada no encontrada."""
 pass

# Manejo apropiado
def get_call(call_id: int) -> Call:
 try:
 return Call.objects.get(id=call_id)
 except Call.DoesNotExist:
 raise CallNotFoundError(f"Call {call_id} not found")
 except DatabaseError as e:
 logger.error(f"Database error fetching call {call_id}: {e}")
 raise
```

## Testing

### Estructura de Tests

```python
# tests/test_metrics_service.py
import pytest
from django.test import TestCase
from ..services import MetricsService

class TestMetricsService(TestCase):
 """Tests for MetricsService."""

 def setUp(self):
 """Preparación antes de cada test."""
 self.service = MetricsService()
 self.test_data = create_test_calls()

 def test_calculate_aht_with_valid_data(self):
 """Should calculate correct AHT with valid call data."""
 # Arrange
 calls = [
 {'duration': 100},
 {'duration': 200},
 {'duration': 300},
 ]

 # Act
 result = self.service.calculate_aht(calls)

 # Assert
 self.assertEqual(result, 200)

 def test_calculate_aht_with_empty_data(self):
 """Should raise ValueError when call list is empty."""
 # Arrange
 calls = []

 # Act & Assert
 with self.assertRaises(ValueError):
 self.service.calculate_aht(calls)
```

### Cobertura Mínima

- **80%** de cobertura obligatoria
- **100%** en servicios críticos (ETL, cálculo de métricas)
- Ejecutar con: `pytest --cov=. --cov-report=html`

### Nomenclatura de Tests

```python
# Patrón: test_<función>_<escenario>_<resultado_esperado>

def test_process_call_with_valid_id_returns_processed_data():
 pass

def test_process_call_with_invalid_id_raises_not_found():
 pass

def test_calculate_metrics_with_empty_dataset_returns_zero():
 pass
```

## Django Específico

### Modelos

```python
from django.db import models
from django.core.validators import MinValueValidator

class Call(models.Model):
 """Representa una llamada en el sistema."""

 # Fields
 call_id = models.CharField(
 max_length=50,
 unique=True,
 help_text="Identificador único de la llamada"
 )
 duration = models.IntegerField(
 validators=[MinValueValidator(0)],
 help_text="Duración en segundos"
 )
 created_at = models.DateTimeField(auto_now_add=True)
 updated_at = models.DateTimeField(auto_now=True)

 class Meta:
 db_table = 'calls'
 ordering = ['-created_at']
 indexes = [
 models.Index(fields=['call_id']),
 models.Index(fields=['created_at']),
 ]

 def __str__(self) -> str:
 return f"Call {self.call_id}"

 def get_formatted_duration(self) -> str:
 """Retorna duración formateada como MM:SS."""
 minutes = self.duration // 60
 seconds = self.duration % 60
 return f"{minutes:02d}:{seconds:02d}"
```

### Consultas Eficientes

```python
# OK BIEN: Usar select_related para FK
calls = Call.objects.select_related('agent', 'queue').all()

# OK BIEN: Usar prefetch_related para M2M
agents = Agent.objects.prefetch_related('skills').all()

# OK BIEN: Filtrar en DB, no en Python
expensive_calls = Call.objects.filter(duration__gte=300)

# NO MAL: N+1 queries
for call in Call.objects.all():
 print(call.agent.name) # Query por cada iteración
```

## Estándares de Código

### Formateo

- **Formatter**: Black (línea 88 caracteres)
- **Linter**: Pylint + Flake8
- **Import sorting**: isort

```bash
# Aplicar formateo automático
black .
isort .

# Verificar calidad
pylint **/*.py
flake8 .
```

### Pre-commit Hooks

Configurar pre-commit hooks para validar antes de commit:

```yaml
# .pre_commit_config.yaml
repos:
 - repo: https://github.com/psf/black
 rev: 23.0.0
 hooks:
 - id: black

 - repo: https://github.com/pycqa/isort
 rev: 5.12.0
 hooks:
 - id: isort

 - repo: https://github.com/pycqa/flake8
 rev: 6.0.0
 hooks:
 - id: flake8
```

## Seguridad

### Variables de Entorno

```python
# OK BIEN: Usar python-decouple o django-environ
from decouple import config

DATABASE_PASSWORD = config('DB_PASSWORD')
SECRET_KEY = config('SECRET_KEY')

# NO MAL: Hardcodear secrets
DATABASE_PASSWORD = 'my_password_123'
```

### Validación de Inputs

```python
from django.core.validators import validate_email
from django.core.exceptions import ValidationError

def process_user_input(email: str, age: int) -> None:
 """Procesa input del usuario con validación."""
 # Validar email
 try:
 validate_email(email)
 except ValidationError:
 raise ValueError("Invalid email format")

 # Validar rango
 if not (0 <= age <= 150):
 raise ValueError("Age must be between 0 and 150")
```

## Logging

```python
import logging

logger = logging.getLogger(__name__)

def process_important_data(data: dict) -> None:
 """Procesa datos importantes con logging apropiado."""
 logger.info(f"Starting processing for {len(data)} records")

 try:
 result = complex_operation(data)
 logger.info(f"Processing completed: {result}")
 except Exception as e:
 logger.error(f"Processing failed: {e}", exc_info=True)
 raise
```

### Niveles de Log

- `DEBUG`: Información detallada para debugging
- `INFO`: Eventos normales del sistema
- `WARNING`: Situaciones inesperadas pero manejables
- `ERROR`: Errores que impiden completar operación
- `CRITICAL`: Errores que pueden causar falla del sistema

## Performance

### Database Query Optimization

```python
# OK BIEN: Usar only() para limitar campos
calls = Call.objects.only('id', 'duration', 'created_at')

# OK BIEN: Usar valores agregados en DB
from django.db.models import Avg, Count
stats = Call.objects.aggregate(
 avg_duration=Avg('duration'),
 total_calls=Count('id')
)

# OK BIEN: Bulk operations
Call.objects.bulk_create([
 Call(call_id='1', duration=100),
 Call(call_id='2', duration=200),
])
```

### Caching (Futuro)

```python
from django.core.cache import cache

def get_daily_metrics(date: str) -> dict:
 """Retorna métricas del día con cache."""
 cache_key = f'metrics_{date}'

 # Intentar obtener de cache
 cached = cache.get(cache_key)
 if cached:
 return cached

 # Calcular si no existe en cache
 metrics = calculate_metrics(date)
 cache.set(cache_key, metrics, timeout=3600) # 1 hora

 return metrics
```

## Recursos Relacionados

- [PEP 8 - Style Guide for Python Code](https://peps.python.org/pep-0008/)
- [Django Coding Style](https://docs.djangoproject.com/en/dev/internals/contributing/writing-code/coding-style/)
- [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
- [Gobernanza del Proyecto](../gobernanza/README.md)

## Cumplimiento

| Elemento | Estado | Herramienta |
|----------|--------|-------------|
| Formateo automático | WARNING Pendiente | Black |
| Linting configurado | WARNING Pendiente | Pylint + Flake8 |
| Type checking | WARNING Pendiente | mypy |
| Pre-commit hooks | WARNING Pendiente | pre-commit |
| Import sorting | WARNING Pendiente | isort |

## Acciones Prioritarias

- [ ] Configurar Black, isort, Pylint, Flake8 en el proyecto
- [ ] Implementar pre-commit hooks
- [ ] Establecer pipeline CI para validar estándares
- [ ] Crear guía de revisión de código basada en estos lineamientos
- [ ] Agregar mypy para type checking estático
