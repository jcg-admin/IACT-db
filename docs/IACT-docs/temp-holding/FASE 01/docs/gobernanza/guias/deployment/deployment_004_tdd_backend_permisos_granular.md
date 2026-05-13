---
id: GUIA-DEPLOYMENT-004
tipo: guia_operativa
categoria: deployment
audiencia: desarrolladores-backend
prioridad: P1
tiempo_lectura: 30 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: ["deployment_003_implementacion_permisos_granular", "INDICE_MAESTRO_PERMISOS_GRANULAR", "prioridad_01_estructura_base_datos"]
---

# Implementacion TDD Backend - Sistema de Permisos Granular

## Proposito

Esta guia explica como implementar el sistema de permisos granular usando Test-Driven Development (TDD), cubriendo tests unitarios, de integracion y end-to-end para las 13 funciones del sistema.

## Audiencia

Esta guia esta dirigida a: **Desarrolladores backend** que implementaran el sistema de permisos granular usando TDD.

## Pre-requisitos

- [ ] Haber leido GUIA-DEPLOYMENT-003 (Implementacion Permisos Granular)
- [ ] Entorno de desarrollo configurado (Python 3.11+, PostgreSQL, Django)
- [ ] Conocimiento de pytest y fixtures
- [ ] Conocimiento de Django ORM y migrations
- [ ] Conocimiento de TDD (Red-Green-Refactor)

## Tiempo estimado

Tiempo de lectura: 30 minutos
Tiempo de implementacion completa: 30-40 horas distribuidas en 4-5 semanas

## Contexto: Filosofia TDD para Permisos Granular

**Ciclo TDD (Red-Green-Refactor):**
1. RED: Escribir test que falle (requisito no implementado)
2. GREEN: Escribir codigo minimo para que pase
3. REFACTOR: Mejorar el codigo manteniendo tests pasando

**Estructura de tests:**
- Tests unitarios: Modelos, servicios, utilidades (markers: unit)
- Tests de integracion: Servicios + base de datos (markers: integration, django_db)
- Tests de API: Endpoints REST completos (markers: integration, django_db)

**Cobertura esperada:**
- Cobertura de lineas: 90%+
- Cobertura de ramas: 85%+
- Tests totales: ~250-300 tests
- Tiempo de ejecucion: <2 minutos

## Pasos

### Fase 1: Setup de Testing Environment (Semana 1)

#### 1.1 Verificar Configuracion Pytest

**Ubicacion**: `api/callcentersite/pytest.ini`

Verificar que contiene:

```ini
[pytest]
DJANGO_SETTINGS_MODULE = callcentersite.settings.testing
python_files = tests.py test_*.py *_tests.py
python_classes = Test*
python_functions = test_*
addopts =
    -v
    --strict-markers
    --tb=short
    --cov=.
    --cov-report=term-missing
    --cov-report=html
    --cov-branch
    --nomigrations
    -p no:warnings
testpaths = .
markers =
    unit: Unit tests
    integration: Integration tests
    slow: Slow running tests
    django_db: Tests that require database access
    permissions: Tests del sistema de permisos granular
filterwarnings =
    ignore::DeprecationWarning
    ignore::PendingDeprecationWarning
```

**Agregar nuevo marker:**

```diff
markers =
    unit: Unit tests
    integration: Integration tests
    slow: Slow running tests
    django_db: Tests that require database access
+   permissions: Tests del sistema de permisos granular
```

#### 1.2 Crear Estructura de Directorios de Tests

```bash
mkdir -p api/callcentersite/tests/permissions
touch api/callcentersite/tests/permissions/__init__.py
touch api/callcentersite/tests/permissions/conftest.py
```

**Estructura esperada:**

```
api/callcentersite/tests/
├── permissions/
│   ├── __init__.py
│   ├── conftest.py                        # Fixtures especificas de permisos
│   ├── test_models_funciones.py           # Tests de modelo Funcion
│   ├── test_models_capacidades.py         # Tests de modelo Capacidad
│   ├── test_models_grupos_permisos.py     # Tests de modelo GrupoPermiso
│   ├── test_models_usuarios_grupos.py     # Tests de relacion Usuario-Grupo
│   ├── test_models_permisos_excepcionales.py  # Tests permisos excepcionales
│   ├── test_models_auditoria.py           # Tests auditoria
│   ├── test_services_user_management.py   # Tests de UserManagementService
│   ├── test_services_permission_check.py  # Tests de verificacion de permisos
│   ├── test_views_funciones.py            # Tests de endpoints de funciones
│   ├── test_views_grupos.py               # Tests de endpoints de grupos
│   ├── test_views_usuarios.py             # Tests de endpoints de usuarios
│   └── test_integration_complete_flow.py  # Tests end-to-end
```

#### 1.3 Crear Fixtures Base

**Archivo**: `api/callcentersite/tests/permissions/conftest.py`

```python
"""Fixtures para tests del sistema de permisos granular."""

import pytest
from django.contrib.auth import get_user_model

User = get_user_model()


@pytest.fixture
def admin_user(db):
    """Usuario administrador para tests."""
    return User.objects.create_user(
        username="admin",
        email="admin@example.com",
        password="admin123",
        is_staff=True,
        is_superuser=True,
    )


@pytest.fixture
def regular_user(db):
    """Usuario regular sin permisos especiales."""
    return User.objects.create_user(
        username="user",
        email="user@example.com",
        password="user123",
    )


@pytest.fixture
def funcion_usuarios(db):
    """Funcion 'sistema.administracion.usuarios'."""
    from callcentersite.apps.users.models import Funcion

    return Funcion.objects.create(
        nombre="usuarios",
        nombre_completo="sistema.administracion.usuarios",
        dominio="sistema.administracion",
        categoria="administracion",
        descripcion="Gestion de cuentas de usuario",
        icono="users",
        orden_menu=10,
        activa=True,
    )


@pytest.fixture
def capacidad_crear_usuario(db, funcion_usuarios):
    """Capacidad 'sistema.administracion.usuarios.crear'."""
    from callcentersite.apps.users.models import Capacidad, FuncionCapacidad

    capacidad = Capacidad.objects.create(
        codigo="sistema.administracion.usuarios.crear",
        nombre="Crear Usuario",
        descripcion="Permite crear nuevos usuarios",
        requiere_aprobacion=False,
        nivel_riesgo="medio",
        activa=True,
    )

    FuncionCapacidad.objects.create(
        funcion=funcion_usuarios,
        capacidad=capacidad,
        es_requerida=True,
    )

    return capacidad


@pytest.fixture
def grupo_administracion_usuarios(db):
    """Grupo funcional 'administracion_usuarios'."""
    from callcentersite.apps.users.models import GrupoPermiso

    return GrupoPermiso.objects.create(
        codigo="administracion_usuarios",
        nombre="Administracion de Usuarios",
        descripcion="Gestion completa de cuentas de usuario",
        categoria="administracion",
        requiere_aprobacion=False,
        nivel_riesgo="alto",
        activo=True,
    )


@pytest.fixture
def grupo_con_capacidades(db, grupo_administracion_usuarios, capacidad_crear_usuario):
    """Grupo con capacidades asignadas."""
    from callcentersite.apps.users.models import GrupoCapacidad

    GrupoCapacidad.objects.create(
        grupo=grupo_administracion_usuarios,
        capacidad=capacidad_crear_usuario,
    )

    return grupo_administracion_usuarios
```

### Fase 2: Tests de Modelos (Semana 1-2)

#### 2.1 Tests para Modelo Funcion

**Archivo**: `api/callcentersite/tests/permissions/test_models_funciones.py`

```python
"""Tests TDD para modelo Funcion.

Requisitos cubiertos:
- prioridad_01_estructura_base_datos.md: Tabla funciones
"""

import pytest
from django.db import IntegrityError

from callcentersite.apps.users.models import Funcion


@pytest.mark.django_db
@pytest.mark.unit
@pytest.mark.permissions
class TestFuncionModel:
    """Tests unitarios para modelo Funcion."""

    def test_crear_funcion_valida(self):
        """
        Given datos validos de una funcion
        When se crea una instancia de Funcion
        Then se guarda correctamente en base de datos
        """
        funcion = Funcion.objects.create(
            nombre="usuarios",
            nombre_completo="sistema.administracion.usuarios",
            dominio="sistema.administracion",
            categoria="administracion",
            descripcion="Gestion de usuarios",
            icono="users",
            orden_menu=10,
            activa=True,
        )

        assert funcion.id is not None
        assert funcion.nombre == "usuarios"
        assert funcion.nombre_completo == "sistema.administracion.usuarios"
        assert funcion.activa is True

    def test_nombre_completo_debe_ser_unico(self):
        """
        Given una funcion existente con nombre_completo
        When se intenta crear otra con el mismo nombre_completo
        Then lanza IntegrityError
        """
        Funcion.objects.create(
            nombre="usuarios",
            nombre_completo="sistema.administracion.usuarios",
            dominio="sistema.administracion",
            categoria="administracion",
            descripcion="Gestion de usuarios",
        )

        with pytest.raises(IntegrityError):
            Funcion.objects.create(
                nombre="usuarios_duplicado",
                nombre_completo="sistema.administracion.usuarios",  # DUPLICADO
                dominio="sistema.administracion",
                categoria="administracion",
                descripcion="Otra descripcion",
            )

    def test_funcion_str_retorna_nombre_completo(self):
        """
        Given una funcion
        When se llama str(funcion)
        Then retorna el nombre_completo
        """
        funcion = Funcion.objects.create(
            nombre="dashboards",
            nombre_completo="sistema.vistas.dashboards",
            dominio="sistema.vistas",
            categoria="vistas",
            descripcion="Visualizacion de dashboards",
        )

        assert str(funcion) == "sistema.vistas.dashboards"

    def test_funcion_activa_por_defecto(self):
        """
        Given creacion de funcion sin especificar 'activa'
        When se crea la funcion
        Then activa=True por defecto
        """
        funcion = Funcion.objects.create(
            nombre="test",
            nombre_completo="sistema.test",
            dominio="sistema",
            categoria="test",
        )

        assert funcion.activa is True

    def test_orden_menu_por_defecto(self):
        """
        Given creacion de funcion sin especificar orden_menu
        When se crea la funcion
        Then orden_menu=999 por defecto
        """
        funcion = Funcion.objects.create(
            nombre="test",
            nombre_completo="sistema.test",
            dominio="sistema",
            categoria="test",
        )

        assert funcion.orden_menu == 999

    def test_timestamps_se_crean_automaticamente(self):
        """
        Given creacion de nueva funcion
        When se guarda en base de datos
        Then created_at y updated_at se generan automaticamente
        """
        funcion = Funcion.objects.create(
            nombre="test",
            nombre_completo="sistema.test",
            dominio="sistema",
            categoria="test",
        )

        assert funcion.created_at is not None
        assert funcion.updated_at is not None
        assert funcion.created_at <= funcion.updated_at
```

#### 2.2 Tests para Modelo Capacidad

**Archivo**: `api/callcentersite/tests/permissions/test_models_capacidades.py`

```python
"""Tests TDD para modelo Capacidad.

Requisitos cubiertos:
- prioridad_01_estructura_base_datos.md: Tabla capacidades
"""

import pytest
from django.db import IntegrityError

from callcentersite.apps.users.models import Capacidad


@pytest.mark.django_db
@pytest.mark.unit
@pytest.mark.permissions
class TestCapacidadModel:
    """Tests unitarios para modelo Capacidad."""

    def test_crear_capacidad_valida(self):
        """
        Given datos validos de una capacidad
        When se crea una instancia de Capacidad
        Then se guarda correctamente
        """
        capacidad = Capacidad.objects.create(
            codigo="sistema.administracion.usuarios.crear",
            nombre="Crear Usuario",
            descripcion="Permite crear nuevos usuarios",
            requiere_aprobacion=False,
            nivel_riesgo="medio",
            activa=True,
        )

        assert capacidad.id is not None
        assert capacidad.codigo == "sistema.administracion.usuarios.crear"
        assert capacidad.requiere_aprobacion is False

    def test_codigo_debe_ser_unico(self):
        """
        Given una capacidad existente
        When se intenta crear otra con el mismo codigo
        Then lanza IntegrityError
        """
        Capacidad.objects.create(
            codigo="sistema.test.capacidad",
            nombre="Test",
        )

        with pytest.raises(IntegrityError):
            Capacidad.objects.create(
                codigo="sistema.test.capacidad",  # DUPLICADO
                nombre="Otro nombre",
            )

    def test_nivel_riesgo_valores_permitidos(self):
        """
        Given niveles de riesgo: bajo, medio, alto, critico
        When se crea capacidad con cada nivel
        Then se acepta correctamente
        """
        for nivel in ["bajo", "medio", "alto", "critico"]:
            capacidad = Capacidad.objects.create(
                codigo=f"sistema.test.{nivel}",
                nombre=f"Test {nivel}",
                nivel_riesgo=nivel,
            )
            assert capacidad.nivel_riesgo == nivel

    def test_capacidad_activa_por_defecto(self):
        """
        Given creacion de capacidad sin especificar 'activa'
        When se crea
        Then activa=True por defecto
        """
        capacidad = Capacidad.objects.create(
            codigo="sistema.test",
            nombre="Test",
        )

        assert capacidad.activa is True

    def test_requiere_aprobacion_por_defecto(self):
        """
        Given creacion de capacidad sin especificar requiere_aprobacion
        When se crea
        Then requiere_aprobacion=False por defecto
        """
        capacidad = Capacidad.objects.create(
            codigo="sistema.test",
            nombre="Test",
        )

        assert capacidad.requiere_aprobacion is False
```

### Fase 3: Tests de Servicios (Semana 2-3)

#### 3.1 Tests para UserManagementService

**Archivo**: `api/callcentersite/tests/permissions/test_services_user_management.py`

```python
"""Tests TDD para UserManagementService.

Requisitos cubiertos:
- CASOS_DE_USO_SISTEMA_PERMISOS.md: UC-001 a UC-005
- prioridad_02_funciones_core.md: Funciones core
"""

import pytest
from django.contrib.auth import get_user_model

from callcentersite.apps.users.models import (
    Capacidad,
    GrupoPermiso,
    UsuarioGrupo,
)
from callcentersite.apps.users.services import UserManagementService

User = get_user_model()


@pytest.mark.django_db
@pytest.mark.integration
@pytest.mark.permissions
class TestUserManagementService:
    """Tests de integracion para UserManagementService."""

    def test_asignar_grupo_a_usuario(
        self,
        regular_user,
        grupo_administracion_usuarios,
    ):
        """
        Given un usuario regular sin grupos
        When se asigna grupo 'administracion_usuarios'
        Then usuario queda asignado al grupo
        """
        result = UserManagementService.asignar_grupo_a_usuario(
            usuario_id=regular_user.id,
            grupo_codigo="administracion_usuarios",
            asignado_por_id=regular_user.id,
        )

        assert result is True
        assert UsuarioGrupo.objects.filter(
            usuario=regular_user,
            grupo=grupo_administracion_usuarios,
        ).exists()

    def test_obtener_capacidades_de_usuario(
        self,
        regular_user,
        grupo_con_capacidades,
    ):
        """
        Given usuario con grupo que tiene capacidades
        When se obtienen capacidades del usuario
        Then retorna todas las capacidades de sus grupos
        """
        UserManagementService.asignar_grupo_a_usuario(
            usuario_id=regular_user.id,
            grupo_codigo=grupo_con_capacidades.codigo,
            asignado_por_id=regular_user.id,
        )

        capacidades = UserManagementService.obtener_capacidades_de_usuario(
            usuario_id=regular_user.id
        )

        assert len(capacidades) == 1
        assert capacidades[0].codigo == "sistema.administracion.usuarios.crear"

    def test_usuario_tiene_permiso_via_grupo(
        self,
        regular_user,
        grupo_con_capacidades,
    ):
        """
        Given usuario con grupo que tiene capacidad especifica
        When se verifica si usuario tiene esa capacidad
        Then retorna True
        """
        UserManagementService.asignar_grupo_a_usuario(
            usuario_id=regular_user.id,
            grupo_codigo=grupo_con_capacidades.codigo,
            asignado_por_id=regular_user.id,
        )

        result = UserManagementService.usuario_tiene_permiso(
            usuario_id=regular_user.id,
            capacidad_codigo="sistema.administracion.usuarios.crear",
        )

        assert result is True

    def test_usuario_sin_permiso_retorna_false(self, regular_user):
        """
        Given usuario sin grupos ni permisos
        When se verifica capacidad inexistente
        Then retorna False
        """
        result = UserManagementService.usuario_tiene_permiso(
            usuario_id=regular_user.id,
            capacidad_codigo="sistema.capacidad.inexistente",
        )

        assert result is False
```

### Fase 4: Tests de API (Semana 3-4)

#### 4.1 Tests para Endpoints de Funciones

**Archivo**: `api/callcentersite/tests/permissions/test_views_funciones.py`

```python
"""Tests TDD para endpoints de Funciones.

Requisitos cubiertos:
- MAPEO_FUNCIONES_MODULOS_DJANGO.md: Endpoints REST
"""

import pytest
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient


@pytest.mark.django_db
@pytest.mark.integration
@pytest.mark.permissions
class TestFuncionViewSet:
    """Tests de endpoints REST para Funciones."""

    def test_listar_funciones_autenticado(self, admin_user, funcion_usuarios):
        """
        Given usuario autenticado
        When hace GET a /api/v1/funciones/
        Then retorna 200 con lista de funciones
        """
        client = APIClient()
        client.force_authenticate(user=admin_user)

        url = reverse("funcion-list")
        response = client.get(url)

        assert response.status_code == status.HTTP_200_OK
        assert len(response.data) >= 1

    def test_crear_funcion_requiere_autenticacion(self):
        """
        Given usuario NO autenticado
        When hace POST a /api/v1/funciones/
        Then retorna 401 Unauthorized
        """
        client = APIClient()

        url = reverse("funcion-list")
        data = {
            "nombre": "test",
            "nombre_completo": "sistema.test",
            "dominio": "sistema",
            "categoria": "test",
        }
        response = client.post(url, data)

        assert response.status_code == status.HTTP_401_UNAUTHORIZED

    def test_crear_funcion_con_permisos(self, admin_user):
        """
        Given usuario administrador
        When hace POST a /api/v1/funciones/ con datos validos
        Then retorna 201 Created
        """
        client = APIClient()
        client.force_authenticate(user=admin_user)

        url = reverse("funcion-list")
        data = {
            "nombre": "nueva_funcion",
            "nombre_completo": "sistema.nueva_funcion",
            "dominio": "sistema",
            "categoria": "test",
            "descripcion": "Funcion de prueba",
        }
        response = client.post(url, data)

        assert response.status_code == status.HTTP_201_CREATED
        assert response.data["nombre"] == "nueva_funcion"
```

### Fase 5: Tests End-to-End (Semana 4)

#### 5.1 Tests de Flujo Completo

**Archivo**: `api/callcentersite/tests/permissions/test_integration_complete_flow.py`

```python
"""Tests end-to-end del sistema de permisos granular.

Requisitos cubiertos:
- CASOS_DE_USO_SISTEMA_PERMISOS.md: UC-001 (Ana Lopez - Agente)
"""

import pytest
from django.contrib.auth import get_user_model
from rest_framework.test import APIClient

from callcentersite.apps.users.models import (
    Capacidad,
    Funcion,
    FuncionCapacidad,
    GrupoCapacidad,
    GrupoPermiso,
)
from callcentersite.apps.users.services import UserManagementService

User = get_user_model()


@pytest.mark.django_db
@pytest.mark.integration
@pytest.mark.permissions
@pytest.mark.slow
class TestUC001AnaLopezAgente:
    """
    Test end-to-end del caso de uso UC-001: Ana Lopez - Agente.

    Simula el flujo completo:
    1. Crear agente Ana Lopez
    2. Asignar grupos: atencion_cliente, visualizacion_basica
    3. Verificar que tiene 11 capacidades
    4. Verificar que puede realizar llamadas
    5. Verificar que NO puede cerrar tickets
    """

    def test_flujo_completo_agente_ana_lopez(self, admin_user):
        """
        Given sistema con funciones y grupos configurados
        When se crea agente Ana Lopez y se asignan grupos
        Then tiene exactamente 11 capacidades y permisos correctos
        """
        # SETUP: Crear funciones y capacidades

        # Funcion: sistema.operaciones.llamadas
        funcion_llamadas = Funcion.objects.create(
            nombre="llamadas",
            nombre_completo="sistema.operaciones.llamadas",
            dominio="sistema.operaciones",
            categoria="operaciones",
            descripcion="Gestion de llamadas",
        )

        capacidad_realizar_llamada = Capacidad.objects.create(
            codigo="sistema.operaciones.llamadas.realizar",
            nombre="Realizar Llamada",
        )

        FuncionCapacidad.objects.create(
            funcion=funcion_llamadas,
            capacidad=capacidad_realizar_llamada,
        )

        # Funcion: sistema.operaciones.tickets
        funcion_tickets = Funcion.objects.create(
            nombre="tickets",
            nombre_completo="sistema.operaciones.tickets",
            dominio="sistema.operaciones",
            categoria="operaciones",
            descripcion="Gestion de tickets",
        )

        capacidad_crear_ticket = Capacidad.objects.create(
            codigo="sistema.operaciones.tickets.crear",
            nombre="Crear Ticket",
        )

        capacidad_cerrar_ticket = Capacidad.objects.create(
            codigo="sistema.operaciones.tickets.cerrar",
            nombre="Cerrar Ticket",
        )

        FuncionCapacidad.objects.create(
            funcion=funcion_tickets,
            capacidad=capacidad_crear_ticket,
        )

        FuncionCapacidad.objects.create(
            funcion=funcion_tickets,
            capacidad=capacidad_cerrar_ticket,
        )

        # Grupo: atencion_cliente (incluye realizar_llamada, crear_ticket)
        grupo_atencion = GrupoPermiso.objects.create(
            codigo="atencion_cliente",
            nombre="Atencion al Cliente",
        )

        GrupoCapacidad.objects.create(
            grupo=grupo_atencion,
            capacidad=capacidad_realizar_llamada,
        )

        GrupoCapacidad.objects.create(
            grupo=grupo_atencion,
            capacidad=capacidad_crear_ticket,
        )

        # ACCION: Crear Ana Lopez y asignar grupo

        ana = User.objects.create_user(
            username="ana.lopez",
            email="ana.lopez@empresa.com",
            password="segura123",
        )

        UserManagementService.asignar_grupo_a_usuario(
            usuario_id=ana.id,
            grupo_codigo="atencion_cliente",
            asignado_por_id=admin_user.id,
        )

        # VERIFICACION: Ana puede realizar llamadas

        puede_realizar_llamada = UserManagementService.usuario_tiene_permiso(
            usuario_id=ana.id,
            capacidad_codigo="sistema.operaciones.llamadas.realizar",
        )

        assert puede_realizar_llamada is True

        # VERIFICACION: Ana puede crear tickets

        puede_crear_ticket = UserManagementService.usuario_tiene_permiso(
            usuario_id=ana.id,
            capacidad_codigo="sistema.operaciones.tickets.crear",
        )

        assert puede_crear_ticket is True

        # VERIFICACION: Ana NO puede cerrar tickets (solo coordinadores)

        puede_cerrar_ticket = UserManagementService.usuario_tiene_permiso(
            usuario_id=ana.id,
            capacidad_codigo="sistema.operaciones.tickets.cerrar",
        )

        assert puede_cerrar_ticket is False

        # VERIFICACION: Capacidades totales

        capacidades = UserManagementService.obtener_capacidades_de_usuario(
            usuario_id=ana.id
        )

        # Debe tener 2 capacidades de atencion_cliente
        assert len(capacidades) == 2
```

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] pytest.ini actualizado con marker 'permissions'
- [ ] Estructura de directorios tests/permissions/ creada
- [ ] Fixtures base en conftest.py creadas
- [ ] Tests de modelos escritos y pasando
- [ ] Tests de servicios escritos y pasando
- [ ] Tests de API escritos y pasando
- [ ] Tests end-to-end escritos y pasando
- [ ] Cobertura de codigo >= 90%

## Como interpretar resultados

**Exito**:
- Todos los tests pasan (GREEN)
- Cobertura de lineas >= 90%
- Cobertura de ramas >= 85%
- Tiempo de ejecucion < 2 minutos
- 0 warnings de deprecation

**Ejecutar tests**:

```bash
cd api/callcentersite

# Todos los tests de permisos
pytest -m permissions

# Solo tests unitarios
pytest -m "permissions and unit"

# Solo tests de integracion
pytest -m "permissions and integration"

# Con cobertura
pytest -m permissions --cov=callcentersite.apps.users --cov-report=html

# Ver reporte de cobertura
open htmlcov/index.html
```

## Troubleshooting

### Error 1: IntegrityError en tests

**Sintomas**:
```
IntegrityError: duplicate key value violates unique constraint
```

**Causa**: Fixtures no se limpian entre tests

**Solucion**:
```python
# Usar fixture autouse en conftest.py
@pytest.fixture(autouse=True)
def reset_database(db):
    """Limpia base de datos entre tests."""
    yield
    # Django trunca automaticamente con django_db
```

### Error 2: Tests lentos (>5 minutos)

**Sintomas**:
```
pytest tardando demasiado
```

**Causa**: Muchos tests con marker django_db

**Solucion**:
```bash
# Usar --reuse-db para reutilizar base de datos entre runs
pytest --reuse-db -m permissions

# Paralelizar tests
pip install pytest-xdist
pytest -n auto -m permissions
```

### Error 3: Coverage bajo (<70%)

**Sintomas**:
```
TOTAL coverage: 68%
```

**Causa**: Falta tests de casos edge

**Solucion**:
```bash
# Identificar lineas sin cobertura
pytest --cov --cov-report=term-missing

# Agregar tests para:
# - Casos de error (validaciones)
# - Condiciones especiales (None, empty)
# - Excepciones
```

## Buenas Practicas

### 1. Patron Given-When-Then

Siempre estructura tests con:

```python
def test_ejemplo(self):
    """
    Given [estado inicial]
    When [accion ejecutada]
    Then [resultado esperado]
    """
    # GIVEN: Setup
    usuario = User.objects.create_user(...)

    # WHEN: Accion
    result = UserManagementService.asignar_grupo(...)

    # THEN: Verificacion
    assert result is True
```

### 2. Nombres Descriptivos

```python
# INCORRECTO
def test_1(self):
    pass

# CORRECTO
def test_usuario_puede_crear_ticket_cuando_tiene_grupo_atencion_cliente(self):
    pass
```

### 3. Un Assert Principal por Test

```python
# INCORRECTO
def test_multiples_cosas(self):
    assert x == 1
    assert y == 2
    assert z == 3

# CORRECTO - dividir en 3 tests
def test_x_equals_1(self):
    assert x == 1

def test_y_equals_2(self):
    assert y == 2

def test_z_equals_3(self):
    assert z == 3
```

### 4. Fixtures Reutilizables

```python
# En conftest.py
@pytest.fixture
def usuario_con_todos_los_permisos(db, admin_user):
    """Fixture que crea usuario con todos los grupos."""
    usuario = User.objects.create_user(...)
    # Asignar todos los grupos
    return usuario

# En test
def test_algo(usuario_con_todos_los_permisos):
    assert usuario_con_todos_los_permisos.grupos.count() == 10
```

## Metricas de Exito

```
Tests totales: 250-300
Tests unitarios: 150-180 (60%)
Tests integracion: 70-100 (30%)
Tests e2e: 20-30 (10%)

Cobertura lineas: >= 90%
Cobertura ramas: >= 85%
Tiempo ejecucion: < 2 minutos
Warnings: 0

Tests por modulo:
- test_models_*.py: 60-80 tests
- test_services_*.py: 80-100 tests
- test_views_*.py: 60-80 tests
- test_integration_*.py: 20-30 tests
```

## Proximos pasos

Despues de completar la implementacion TDD backend:

1. **GUIA-DEPLOYMENT-005**: Implementacion TDD Frontend (React + Jest)
2. **GUIA-DEPLOYMENT-006**: Migraciones de Base de Datos
3. **GUIA-DEPLOYMENT-007**: Deploy a Staging con Tests Automatizados
4. **scripts/test_pyramid_check.sh**: Validar test pyramid

## Referencias

- Documentacion tecnica: `docs/backend/requisitos/INDICE_MAESTRO_PERMISOS_GRANULAR.md`
- Estructura de base de datos: `docs/backend/requisitos/prioridad_01_estructura_base_datos.md`
- Casos de uso: `docs/backend/requisitos/CASOS_DE_USO_SISTEMA_PERMISOS.md`
- pytest documentation: https://docs.pytest.org/
- Django testing: https://docs.djangoproject.com/en/stable/topics/testing/
- TDD best practices: https://testdriven.io/

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: equipo-backend

---

**Mantenedores**: equipo-backend, equipo-qa
**Ultima actualizacion**: 2025-11-07
