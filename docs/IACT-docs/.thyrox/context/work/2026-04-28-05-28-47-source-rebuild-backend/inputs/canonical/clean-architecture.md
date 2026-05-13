---
id: METODOLOGIA-CLEAN-ARCH-001
tipo: metodologia
categoria: arquitectura
titulo: Clean Architecture
version: 1.0.0
fecha_creacion: 2025-11-18
---

# Clean Architecture - Backend Django

Principios de Clean Architecture aplicados a Django.

---

## Principios Fundamentales

### 1. Separation of Concerns
Separar código en capas con responsabilidades claras:

```

 Presentation Layer ← ViewSets, Serializers
 (Django REST Framework) 

 Business Logic Layer ← Services, Use Cases
 (Application Services) 

 Data Access Layer ← Repositories, ORM
 (Django Models) 

```

### 2. Dependency Rule
**Las dependencias fluyen hacia adentro:**
- Presentation → Business Logic → Data
- NUNCA al revés

### 3. Business Logic Independiente
La lógica de negocio NO debe depender de:
- Frameworks web
- Bases de datos específicas
- UI/Frontend

---

## Estructura Django con Clean Architecture

```
myapp/
 models.py # Entities (Domain Layer)
 serializers.py # Presentation Layer
 views.py # Presentation Layer
 services.py # Business Logic Layer
 repositories.py # Data Access Layer
 tests/
 test_services.py
 test_repositories.py
 test_views.py
```

---

## Ejemplo Práctico

### Domain Layer (models.py)
```python
from django.db import models

class Producto(models.Model):
 """Entity: Producto de inventario"""
 nombre = models.CharField(max_length=200)
 precio = models.DecimalField(max_digits=10, decimal_places=2)
 stock = models.IntegerField(default=0)

 class Meta:
 db_table = 'productos'
```

### Data Access Layer (repositories.py)
```python
from typing import List, Optional
from .models import Producto

class ProductoRepository:
 """Abstracción de acceso a datos de Producto"""

 def get_by_id(self, producto_id: int) -> Optional[Producto]:
 try:
 return Producto.objects.get(id=producto_id)
 except Producto.DoesNotExist:
 return None

 def get_all(self) -> List[Producto]:
 return list(Producto.objects.all())

 def get_disponibles(self) -> List[Producto]:
 return list(Producto.objects.filter(stock__gt=0))

 def save(self, producto: Producto) -> Producto:
 producto.save()
 return producto
```

### Business Logic Layer (services.py)
```python
from decimal import Decimal
from typing import Optional
from .repositories import ProductoRepository
from .models import Producto

class ProductoService:
 """Lógica de negocio de Productos"""

 def __init__(self, repository: ProductoRepository = None):
 self.repository = repository or ProductoRepository()

 def crear_producto(self, nombre: str, precio: Decimal, stock: int = 0) -> Producto:
 """Crear nuevo producto con validaciones de negocio"""
 # Validaciones de negocio
 if precio <= 0:
 raise ValueError("Precio debe ser mayor a 0")
 if stock < 0:
 raise ValueError("Stock no puede ser negativo")

 # Crear y guardar
 producto = Producto(
 nombre=nombre,
 precio=precio,
 stock=stock
 )
 return self.repository.save(producto)

 def aplicar_descuento(self, producto_id: int, porcentaje: Decimal) -> Optional[Producto]:
 """Aplicar descuento a producto"""
 producto = self.repository.get_by_id(producto_id)
 if not producto:
 return None

 if porcentaje < 0 or porcentaje > 100:
 raise ValueError("Porcentaje debe estar entre 0 y 100")

 descuento = producto.precio * (porcentaje / 100)
 producto.precio -= descuento

 return self.repository.save(producto)
```

### Presentation Layer (views.py)
```python
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from .serializers import ProductoSerializer
from .services import ProductoService

class ProductoViewSet(viewsets.ModelViewSet):
 """API ViewSet para Productos"""
 serializer_class = ProductoSerializer

 def __init__(self, **kwargs):
 super().__init__(**kwargs)
 self.service = ProductoService()

 def get_queryset(self):
 return self.service.repository.get_all()

 def create(self, request):
 """Crear producto usando servicio"""
 serializer = self.get_serializer(data=request.data)
 serializer.is_valid(raise_exception=True)

 try:
 producto = self.service.crear_producto(
 nombre=serializer.validated_data['nombre'],
 precio=serializer.validated_data['precio'],
 stock=serializer.validated_data.get('stock', 0)
 )
 return Response(
 ProductoSerializer(producto).data,
 status=status.HTTP_201_CREATED
 )
 except ValueError as e:
 return Response(
 {'error': str(e)},
 status=status.HTTP_400_BAD_REQUEST
 )

 @action(detail=True, methods=['post'])
 def aplicar_descuento(self, request, pk=None):
 """Endpoint para aplicar descuento"""
 porcentaje = request.data.get('porcentaje')

 try:
 producto = self.service.aplicar_descuento(pk, porcentaje)
 if not producto:
 return Response(
 {'error': 'Producto no encontrado'},
 status=status.HTTP_404_NOT_FOUND
 )

 return Response(ProductoSerializer(producto).data)
 except ValueError as e:
 return Response(
 {'error': str(e)},
 status=status.HTTP_400_BAD_REQUEST
 )
```

---

## Beneficios

1. **Testeable:** Business logic independiente de framework
2. **Mantenible:** Cambios localizados
3. **Escalable:** Fácil añadir features
4. **Portable:** Business logic reutilizable

---

## Referencias

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Django Best Practices](https://django-best-practices.readthedocs.io/)

---

**Última actualización:** 2025-11-18
