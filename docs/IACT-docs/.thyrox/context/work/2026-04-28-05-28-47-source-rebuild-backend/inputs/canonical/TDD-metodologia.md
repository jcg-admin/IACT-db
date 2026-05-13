---
id: METODOLOGIA-TDD-001
tipo: metodologia
categoria: testing
titulo: Test-Driven Development (TDD)
version: 1.0.0
fecha_creacion: 2025-11-18
---

# Test-Driven Development (TDD) - Backend

Guía de TDD para desarrollo backend con Django y pytest.

---

## ¿Qué es TDD?

Test-Driven Development es una práctica de desarrollo donde **escribes tests ANTES del código**. El ciclo es:

1. **RED:** Escribir test que falla
2. **GREEN:** Escribir código mínimo que pasa el test
3. **REFACTOR:** Mejorar el código manteniendo tests pasando

---

## Ciclo TDD

### Paso 1: RED - Escribir Test que Falla

```python
# tests/test_services.py
import pytest
from myapp.services import CalculatorService

def test_calculator_suma_dos_numeros():
 """Test que suma dos números correctamente"""
 calculator = CalculatorService()
 result = calculator.sumar(2, 3)
 assert result == 5
```

**Resultado esperado:** Test falla porque `CalculatorService` no existe

### Paso 2: GREEN - Código Mínimo

```python
# myapp/services.py
class CalculatorService:
 def sumar(self, a, b):
 return a + b
```

**Resultado:** Test pasa OK

### Paso 3: REFACTOR - Mejorar

```python
# myapp/services.py
class CalculatorService:
 """Servicio para operaciones matemáticas"""

 def sumar(self, a: int, b: int) -> int:
 """Suma dos números enteros"""
 return a + b
```

**Resultado:** Tests siguen pasando, código mejorado OK

---

## TDD con Django

### Ejemplo: ViewSet con TDD

#### 1. Test First
```python
# tests/test_api.py
import pytest
from rest_framework.test import APIClient
from django.contrib.auth import get_user_model

User = get_user_model()

@pytest.fixture
def api_client():
 return APIClient()

@pytest.fixture
def user():
 return User.objects.create_user(
 username='testuser',
 password='testpass123'
 )

def test_obtener_lista_de_productos(api_client, user):
 """Test que obtiene lista de productos"""
 api_client.force_authenticate(user=user)
 response = api_client.get('/api/v1/productos/')

 assert response.status_code == 200
 assert isinstance(response.data, list)
```

#### 2. Implementación Mínima
```python
# views.py
from rest_framework import viewsets
from .models import Producto
from .serializers import ProductoSerializer

class ProductoViewSet(viewsets.ModelViewSet):
 queryset = Producto.objects.all()
 serializer_class = ProductoSerializer
```

#### 3. Refactor
Añadir permisos, filtros, optimizaciones...

---

## Mejores Prácticas TDD

### 1. Tests Pequeños y Específicos
```python
# OK BUENO
def test_suma_numeros_positivos():
 assert sumar(2, 3) == 5

def test_suma_numeros_negativos():
 assert sumar(-2, -3) == -5

# MALO
def test_todas_las_operaciones():
 assert sumar(2, 3) == 5
 assert restar(5, 3) == 2
 assert multiplicar(2, 3) == 6
 # ... demasiado en un test
```

### 2. Arrange-Act-Assert (AAA)
```python
def test_crear_usuario():
 # Arrange (preparar datos)
 username = 'testuser'
 password = 'testpass123'

 # Act (ejecutar acción)
 user = User.objects.create_user(username=username, password=password)

 # Assert (verificar resultado)
 assert user.username == username
 assert user.check_password(password)
```

### 3. Fixtures para Reusabilidad
```python
@pytest.fixture
def producto():
 return Producto.objects.create(
 nombre='Test Product',
 precio=100.00
 )

def test_producto_tiene_nombre(producto):
 assert producto.nombre == 'Test Product'

def test_producto_tiene_precio(producto):
 assert producto.precio == 100.00
```

---

## TDD con Django Models

```python
# 1. Test
def test_modelo_producto_requiere_nombre():
 with pytest.raises(ValidationError):
 producto = Producto(precio=100)
 producto.full_clean()

# 2. Implementación
from django.db import models
from django.core.exceptions import ValidationError

class Producto(models.Model):
 nombre = models.CharField(max_length=200) # required por defecto
 precio = models.DecimalField(max_digits=10, decimal_places=2)
```

---

## Referencias

- [pytest Documentation](https://docs.pytest.org/)
- [pytest-django](https://pytest-django.readthedocs.io/)
- [DRF Testing](https://www.django-rest-framework.org/api-guide/testing/)

---

**Última actualización:** 2025-11-18
