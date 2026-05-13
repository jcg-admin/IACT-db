---
id: REF-DJANGO-DRF-001
tipo: referencia
categoria: frameworks
version: 1.0.0
fecha_creacion: 2025-11-18
---

# Referencias Técnicas - Django & DRF

Guía de referencia rápida para Django y Django REST Framework.

---

## Django 5.x

### Models
```python
from django.db import models

class MiModelo(models.Model):
 nombre = models.CharField(max_length=200)
 fecha_creacion = models.DateTimeField(auto_now_add=True)
 activo = models.BooleanField(default=True)

 class Meta:
 db_table = 'mi_tabla'
 ordering = ['-fecha_creacion']

 def __str__(self):
 return self.nombre
```

### Managers
```python
class ActivoManager(models.Manager):
 def get_queryset(self):
 return super().get_queryset().filter(activo=True)

class MiModelo(models.Model):
 # ... campos ...
 objects = models.Manager() # Manager por defecto
 activos = ActivoManager() # Manager custom
```

### Signals
```python
from django.db.models.signals import post_save
from django.dispatch import receiver

@receiver(post_save, sender=MiModelo)
def mi_modelo_guardado(sender, instance, created, **kwargs):
 if created:
 print(f"Nuevo {instance.nombre} creado")
```

---

## Django REST Framework 3.x

### Serializers
```python
from rest_framework import serializers

class MiSerializer(serializers.ModelSerializer):
 # Campo calculado
 nombre_completo = serializers.SerializerMethodField()

 class Meta:
 model = MiModelo
 fields = ['id', 'nombre', 'nombre_completo', 'activo']
 read_only_fields = ['id']

 def get_nombre_completo(self, obj):
 return f"{obj.nombre} - {obj.id}"

 def validate_nombre(self, value):
 if len(value) < 3:
 raise serializers.ValidationError("Nombre muy corto")
 return value
```

### ViewSets
```python
from rest_framework import viewsets, filters
from rest_framework.decorators import action
from rest_framework.response import Response

class MiViewSet(viewsets.ModelViewSet):
 queryset = MiModelo.objects.all()
 serializer_class = MiSerializer
 filter_backends = [filters.SearchFilter]
 search_fields = ['nombre']

 def get_queryset(self):
 # Filtrar por usuario actual
 return MiModelo.activos.all()

 @action(detail=True, methods=['post'])
 def activar(self, request, pk=None):
 obj = self.get_object()
 obj.activo = True
 obj.save()
 return Response({'status': 'activado'})
```

### Permissions
```python
from rest_framework import permissions

class EsPropietario(permissions.BasePermission):
 def has_object_permission(self, request, view, obj):
 return obj.usuario == request.user

class MiViewSet(viewsets.ModelViewSet):
 permission_classes = [permissions.IsAuthenticated, EsPropietario]
```

---

## Testing

### Fixtures
```python
import pytest
from myapp.models import MiModelo

@pytest.fixture
def mi_modelo():
 return MiModelo.objects.create(nombre='Test')

@pytest.mark.django_db
def test_mi_modelo(mi_modelo):
 assert mi_modelo.nombre == 'Test'
```

### API Tests
```python
from rest_framework.test import APIClient

@pytest.fixture
def api_client():
 return APIClient()

@pytest.mark.django_db
def test_api_lista(api_client):
 response = api_client.get('/api/v1/mis-modelos/')
 assert response.status_code == 200
```

---

## Referencias Oficiales

- [Django Documentation](https://docs.djangoproject.com/en/5.0/)
- [DRF Documentation](https://www.django-rest-framework.org/)
- [pytest-django](https://pytest-django.readthedocs.io/)

---

**Última actualización:** 2025-11-18
