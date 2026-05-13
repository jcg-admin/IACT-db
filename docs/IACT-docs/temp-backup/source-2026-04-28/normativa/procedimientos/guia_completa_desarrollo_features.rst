Guía Completa: Desarrollo de Features en IACT
=============================================

Propósito
---------

Guía práctica paso a paso para crear nuevas funcionalidades en el
proyecto IACT, desde la planificación hasta el merge, incluyendo
ejemplos concretos y mejores prácticas.

Alcance
-------

Esta guía aplica a todos los desarrolladores que necesiten implementar
nuevas features, refactorizar código existente, o realizar cambios
significativos en el proyecto.

Vista Rápida del Flujo
----------------------

::

   1. Setup Entorno     → Clonar + Vagrant + venv
   2. Planificación     → Spec + Plan + Issue en GitHub
   3. Feature Branch    → git checkout -b feature/nombre-fecha
   4. Desarrollo TDD    → Tests → Código → Validación
   5. Commits           → Conventional Commits + pre-commit hooks
   6. Pre-PR Checks     → Formateo + Linting + Coverage ≥80%
   7. Pull Request      → Template completo + CI/CD automático
   8. Code Review       → Mínimo 1 aprobación + CI pasa
   9. Merge             → Squash and merge + delete branch
   10. Post-Merge       → Issue cierra + docs regeneran

**Nota**: Para features complejas, el paso 2 incluye crear
especificación formal (spec) usando
``docs/plantillas/desarrollo/plantilla_spec.md`` y plan de
implementación usando ``docs/plantillas/desarrollo/plantilla_plan.md``.

--------------

Paso 0: Pre-requisitos
----------------------

Software Requerido
~~~~~~~~~~~~~~~~~~

-  ☐ Python 3.11+
-  ☐ Vagrant + VirtualBox 7+
-  ☐ Git configurado
-  ☐ gh CLI (GitHub CLI) - opcional pero recomendado
-  ☐ VS Code o IDE similar
-  ☐ Acceso al repositorio GitHub

Verificar Instalación
~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Verificar versiones
   python --version      # >= 3.11
   vagrant --version     # >= 2.x
   git --version         # >= 2.x
   gh --version          # >= 2.x (opcional)

   # Verificar acceso al repo
   gh repo view 2-Coatl/IACT---project

--------------

Paso 1: Setup Inicial del Entorno
---------------------------------

1.1 Clonar Repositorio (Primera Vez)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Clonar el repositorio
   git clone https://github.com/2-Coatl/IACT---project.git
   cd IACT---project

   # Verificar estructura
   ls -la

1.2 Levantar Infraestructura de Bases de Datos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Opción A: Usando Makefile (recomendado)
   make vagrant-up

   # Opción B: Directamente con Vagrant
   vagrant up

   # Esperar a que termine el provisioning (3-5 minutos)
   # El Vagrantfile provisiona:
   # - PostgreSQL 16 en puerto 127.0.0.1:15432
   # - MariaDB en puerto 127.0.0.1:13306
   # - Usuario: django_user
   # - Password: django_pass

1.3 Verificar Servicios
~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Verificar que las BD estén corriendo
   make check-services

   # O manualmente
   ./scripts/verificar_servicios.sh

   # Output esperado:
   # PostgreSQL: Conectado correctamente
   # MariaDB: Conectado correctamente

1.4 Configurar Entorno Virtual Python
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Crear entorno virtual
   python3 -m venv .venv

   # Activar entorno virtual
   source .venv/bin/activate  # Linux/Mac
   # o
   .venv\Scripts\activate     # Windows

   # Actualizar pip
   pip install --upgrade pip

   # Instalar dependencias de desarrollo
   cd api
   pip install -r requirements/base.txt
   pip install -r requirements/dev.txt
   pip install -r requirements/test.txt

   # Volver a raíz
   cd ..

1.5 Configurar Variables de Entorno
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Crear archivo .env en la raíz del proyecto
   cat > .env << 'EOF'
   # Django
   SECRET_KEY=tu-secret-key-desarrollo
   DEBUG=True
   ALLOWED_HOSTS=localhost,127.0.0.1

   # PostgreSQL (Analítica)
   DB_HOST=127.0.0.1
   DB_PORT=15432
   DB_NAME=iact_analytics
   DB_USER=django_user
   DB_PASSWORD=django_pass

   # MariaDB (IVR Legacy)
   IVR_DB_HOST=127.0.0.1
   IVR_DB_PORT=13306
   IVR_DB_NAME=ivr_legacy
   IVR_DB_USER=django_user
   IVR_DB_PASSWORD=django_pass
   EOF

1.6 Aplicar Migraciones
~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   cd api/callcentersite

   # Ejecutar migraciones
   python manage.py migrate

   # Opcional: Cargar datos de prueba
   python manage.py loaddata fixtures/initial_data.json

   # Opcional: Crear superusuario
   python manage.py createsuperuser

.. _verificar-instalación-1:

1.7 Verificar Instalación
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ejecutar servidor de desarrollo
   python manage.py runserver

   # Abrir en navegador: http://localhost:8000
   # Deberías ver la página de bienvenida

   # Ctrl+C para detener

--------------

Paso 2: Planificación de la Feature
-----------------------------------

2.1 Identificar Necesidad
~~~~~~~~~~~~~~~~~~~~~~~~~

Antes de crear una feature, define claramente:

-  ☐ ¿Qué problema resuelve?
-  ☐ ¿Cuáles son los criterios de aceptación?
-  ☐ ¿Requiere cambios en BD, API, o ambos?
-  ☐ ¿Hay dependencias con otros issues?
-  ☐ ¿Es una feature completa o un spike de investigación?

2.1.1 Crear Especificación de Feature (Spec)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Para features complejas o significativas, crear una especificación
formal usando la plantilla:

**Plantilla**: ``docs/plantillas/desarrollo/plantilla_spec.md``

**Cuándo crear una spec**: - Features que afectan múltiples componentes
- Cambios en modelos de datos o arquitectura - Features con requisitos
de negocio complejos - Cuando se necesite aprobación de stakeholders
antes de implementar

**Pasos**:

.. code:: bash

   # 1. Copiar plantilla
   cp docs/plantillas/desarrollo/plantilla_spec.md \
      docs/specs/nombre-feature.md

   # 2. Completar todas las secciones requeridas
   # Editar docs/specs/nombre-feature.md con tu editor

   # 3. Commit de spec
   git add docs/specs/nombre-feature.md
   git commit -m "docs: agregar especificación de nombre-feature"

**Secciones clave a completar**: - Metadata y trazabilidad (requisitos,
issues, ADRs) - Requisitos funcionales y criterios de aceptación -
Requisitos no funcionales (performance, seguridad) - Diseño de solución
(arquitectura, modelos, APIs) - Plan de testing y despliegue - Riesgos e
impacto

**Referencia**: Ver ``docs/plantillas/desarrollo/plantilla_spec.md``
para estructura completa.

2.1.2 Crear Plan de Implementación (Plan)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Una vez aprobada la spec, crear un plan detallado de implementación:

**Plantilla**: ``docs/plantillas/desarrollo/plantilla_plan.md``

**Cuándo crear un plan**: - Siempre que exista una spec - Features que
tomen más de 2 días de desarrollo - Cuando múltiples desarrolladores
trabajen en paralelo - Features que requieran coordinación con otros
equipos

**Pasos**:

.. code:: bash

   # 1. Copiar plantilla
   cp docs/plantillas/desarrollo/plantilla_plan.md \
      docs/plans/nombre-feature.md

   # 2. Completar plan de tareas
   # Editar docs/plans/nombre-feature.md con tu editor

   # 3. Commit de plan
   git add docs/plans/nombre-feature.md
   git commit -m "docs: agregar plan de implementación de nombre-feature"

**Secciones clave a completar**: - Pre-requisitos (conocimientos, setup,
documentación) - Arquitectura de la solución - Plan de tareas detallado
por fases - Estimaciones de tiempo por tarea - Plan de testing y deploy
- Riesgos y mitigaciones - Checklist final de completitud

**Referencia**: Ver ``docs/plantillas/desarrollo/plantilla_plan.md``
para estructura completa.

**Nota**: El plan es un documento vivo. Actualízalo a medida que avanzas
en la implementación, documentando cambios y lecciones aprendidas.

2.2 Crear Issue en GitHub
~~~~~~~~~~~~~~~~~~~~~~~~~

Opción A: Usando gh CLI (Recomendado)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   gh issue create \
     --title "feat: Agregar autenticación JWT" \
     --body "## Descripción
   Implementar autenticación con JSON Web Tokens para asegurar los endpoints de la API.

   ## Motivación
   Actualmente la API no tiene autenticación, lo cual es un riesgo de seguridad.

   ## Criterios de Aceptación
   - [ ] Endpoint POST /api/auth/login que retorna access_token y refresh_token
   - [ ] Endpoint POST /api/auth/refresh para renovar tokens
   - [ ] Middleware de autenticación que valida JWT en requests
   - [ ] Tests unitarios para serializers y views
   - [ ] Tests de integración end-to-end
   - [ ] Documentación de uso en README
   - [ ] Manejo de errores (401, 403, etc.)

   ## Requisitos Técnicos
   - Usar PyJWT library
   - Tokens expiran en 24 horas (configurable)
   - Refresh tokens expiran en 7 días
   - Incluir user_id y permissions en payload

   ## Tareas
   - [ ] Implementar serializer de credenciales
   - [ ] Crear vista de login
   - [ ] Crear vista de refresh
   - [ ] Agregar middleware JWT
   - [ ] Escribir tests unitarios
   - [ ] Escribir tests de integración
   - [ ] Actualizar documentación

   ## Prioridad
   Alta - Bloqueante para MVP

   ## Estimación
   3-5 días

   ## Referencias
   - Django REST Framework JWT docs
   - RFC 7519 (JWT)" \
     --label "enhancement,backend,priority-high" \
     --assignee @me

Opción B: Crear en GitHub UI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Ir a: https://github.com/2-Coatl/IACT—project/issues/new
2. Completar:

   -  **Título**: ``feat: Agregar autenticación JWT``
   -  **Descripción**: Usar template anterior
   -  **Labels**: ``enhancement``, ``backend``, ``priority-high``
   -  **Assignees**: Tu usuario
   -  **Projects**: Agregar al proyecto actual si existe

2.3 Verificar No Hay Duplicados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Buscar issues similares
   gh issue list --search "autenticación OR JWT OR auth"

   # Revisar issues abiertos
   gh issue list --state open --label backend

--------------

Paso 3: Crear Feature Branch
----------------------------

3.1 Actualizar Main
~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Cambiar a main
   git checkout main

   # Traer últimos cambios
   git pull origin main

   # Verificar que estás actualizado
   git log --oneline -5

3.2 Crear Branch con Nomenclatura Estándar
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Formato**: ``{tipo}/{descripcion-corta}-{fecha}``

.. code:: bash

   # Para nueva funcionalidad
   git checkout -b feature/autenticacion-jwt-20251106

   # Para corrección de bug
   git checkout -b fix/validacion-login-20251106

   # Para refactorización
   git checkout -b refactor/simplificar-auth-20251106

   # Para documentación
   git checkout -b docs/actualizar-readme-auth-20251106

   # Para hotfix crítico
   git checkout -b hotfix/corregir-login-roto-20251106

3.3 Nomenclatura para Branches de Agentes AI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Si estás trabajando con agentes AI de Claude Code, usa prefijo
``claude/``:

.. code:: bash

   # Ejemplo con session ID
   git checkout -b claude/implement-jwt-auth-011CUr35zai2SsJs6DyPKRR8

   # IMPORTANTE: Branches claude/* deben terminar con session ID para push

3.4 Verificar Branch Actual
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ver branch actual
   git branch

   # Ver todas las branches (local y remote)
   git branch -a

   # Ver último commit
   git log --oneline -1

--------------

Paso 4: Desarrollo de la Feature (TDD)
--------------------------------------

4.1 Filosofía: Test-Driven Development
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Ciclo TDD:** 1. **Red**: Escribir test que falla 2. **Green**:
Escribir código mínimo para que pase 3. **Refactor**: Mejorar código
manteniendo tests verdes

4.2 Crear Archivo de Tests Primero
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   cd api/callcentersite
   mkdir -p tests/authentication
   touch tests/authentication/test_jwt_authentication.py

.. code:: python

   # tests/authentication/test_jwt_authentication.py
                                                    
   Tests para autenticación JWT.

   RF-AUTH-001: El sistema debe permitir login con username/password
   RF-AUTH-002: El sistema debe retornar access_token y refresh_token
   RF-AUTH-003: El sistema debe validar tokens en requests protegidos
                                                                     

   import pytest
   from django.contrib.auth.models import User
   from rest_framework.test import APIClient
   from rest_framework import status


   @pytest.mark.django_db
   class TestJWTLogin:
       """Tests para endpoint de login."""

       def setup_method(self):
           """Setup ejecutado antes de cada test."""
           self.client = APIClient()
           self.login_url = '/api/auth/login'
           self.user = User.objects.create_user(
               username='testuser',
               email='test@example.com',
               password='testpass123'
           )

       def test_login_success_returns_tokens(self):
                                                   
           Test que login exitoso retorna access_token y refresh_token.

           Given: Usuario válido en BD
           When: POST a /api/auth/login con credenciales correctas
           Then: Retorna 200 con access_token y refresh_token
                                                             
           response = self.client.post(self.login_url, {
               'username': 'testuser',
               'password': 'testpass123'
           })

           assert response.status_code == status.HTTP_200_OK
           assert 'access_token' in response.data
           assert 'refresh_token' in response.data
           assert len(response.data['access_token']) > 0
           assert len(response.data['refresh_token']) > 0

       def test_login_invalid_credentials_returns_401(self):
                                                            
           Test que login con credenciales inválidas retorna 401.

           Given: Usuario con password incorrecta
           When: POST a /api/auth/login con credenciales incorrectas
           Then: Retorna 401 Unauthorized
                                         
           response = self.client.post(self.login_url, {
               'username': 'testuser',
               'password': 'wrongpassword'
           })

           assert response.status_code == status.HTTP_401_UNAUTHORIZED
           assert 'access_token' not in response.data

       def test_login_missing_fields_returns_400(self):
                                                       
           Test que login sin campos requeridos retorna 400.

           Given: Request sin username o password
           When: POST a /api/auth/login sin campos requeridos
           Then: Retorna 400 Bad Request
                                        
           response = self.client.post(self.login_url, {
               'username': 'testuser'
               # password falta
           })

           assert response.status_code == status.HTTP_400_BAD_REQUEST

       def test_login_inactive_user_returns_401(self):
                                                      
           Test que usuario inactivo no puede hacer login.

           Given: Usuario marcado como inactivo
           When: POST a /api/auth/login con credenciales correctas
           Then: Retorna 401 Unauthorized
                                         
           self.user.is_active = False
           self.user.save()

           response = self.client.post(self.login_url, {
               'username': 'testuser',
               'password': 'testpass123'
           })

           assert response.status_code == status.HTTP_401_UNAUTHORIZED


   @pytest.mark.django_db
   class TestJWTRefresh:
       """Tests para endpoint de refresh token."""

       def setup_method(self):
           """Setup ejecutado antes de cada test."""
           self.client = APIClient()
           self.refresh_url = '/api/auth/refresh'
           self.login_url = '/api/auth/login'
           self.user = User.objects.create_user(
               username='testuser',
               password='testpass123'
           )

       def test_refresh_token_success(self):
                                            
           Test que refresh token válido retorna nuevo access_token.

           Given: Refresh token válido obtenido de login
           When: POST a /api/auth/refresh con refresh_token
           Then: Retorna 200 con nuevo access_token
                                                   
           # Primero hacer login para obtener tokens
           login_response = self.client.post(self.login_url, {
               'username': 'testuser',
               'password': 'testpass123'
           })
           refresh_token = login_response.data['refresh_token']

           # Intentar refresh
           response = self.client.post(self.refresh_url, {
               'refresh_token': refresh_token
           })

           assert response.status_code == status.HTTP_200_OK
           assert 'access_token' in response.data

       def test_refresh_invalid_token_returns_401(self):
                                                        
           Test que refresh token inválido retorna 401.

           Given: Token inválido o malformado
           When: POST a /api/auth/refresh con token inválido
           Then: Retorna 401 Unauthorized
                                         
           response = self.client.post(self.refresh_url, {
               'refresh_token': 'invalid-token-123'
           })

           assert response.status_code == status.HTTP_401_UNAUTHORIZED


   @pytest.mark.django_db
   class TestJWTMiddleware:
       """Tests para middleware de autenticación JWT."""

       def setup_method(self):
           """Setup ejecutado antes de cada test."""
           self.client = APIClient()
           self.protected_url = '/api/protected-endpoint'
           self.login_url = '/api/auth/login'
           self.user = User.objects.create_user(
               username='testuser',
               password='testpass123'
           )

       def test_protected_endpoint_without_token_returns_401(self):
                                                                   
           Test que endpoint protegido sin token retorna 401.

           Given: Request sin header Authorization
           When: GET a endpoint protegido
           Then: Retorna 401 Unauthorized
                                         
           response = self.client.get(self.protected_url)

           assert response.status_code == status.HTTP_401_UNAUTHORIZED

       def test_protected_endpoint_with_valid_token_returns_200(self):
                                                                      
           Test que endpoint protegido con token válido permite acceso.

           Given: Request con access_token válido en header
           When: GET a endpoint protegido
           Then: Retorna 200 OK
                               
           # Login para obtener token
           login_response = self.client.post(self.login_url, {
               'username': 'testuser',
               'password': 'testpass123'
           })
           access_token = login_response.data['access_token']

           # Request con token
           self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {access_token}')
           response = self.client.get(self.protected_url)

           assert response.status_code == status.HTTP_200_OK

       def test_protected_endpoint_with_expired_token_returns_401(self):
                                                                        
           Test que endpoint protegido con token expirado retorna 401.

           Given: Token JWT expirado
           When: GET a endpoint protegido con token expirado
           Then: Retorna 401 Unauthorized con mensaje de expiración
                                                                   
           # Este test requiere crear un token expirado manualmente
           # o mockear la fecha actual
           pass  # Implementar según necesidad

4.3 Ejecutar Tests (Deberían Fallar - RED)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ejecutar tests del archivo
   pytest tests/authentication/test_jwt_authentication.py -v

   # Output esperado: FAILED (no existe implementación aún)

4.4 Implementar Código Mínimo (GREEN)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

4.4.1 Crear Serializers
^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Crear app de autenticación si no existe
   cd api/callcentersite
   python manage.py startapp authentication

.. code:: python

   # authentication/serializers.py
                                  
   Serializers para autenticación JWT.

   RF-AUTH-001: Validación de credenciales
   RF-AUTH-002: Generación de tokens
                                    

   from rest_framework import serializers
   from django.contrib.auth import authenticate
   from django.contrib.auth.models import User
   import jwt
   from datetime import datetime, timedelta
   from django.conf import settings


   class LoginSerializer(serializers.Serializer):
       """Serializer para login con username/password."""

       username = serializers.CharField(required=True)
       password = serializers.CharField(required=True, write_only=True)

       def validate(self, attrs):
           """Validar credenciales y retornar usuario."""
           username = attrs.get('username')
           password = attrs.get('password')

           if not username or not password:
               raise serializers.ValidationError(
                   'Debe proporcionar username y password'
               )

           user = authenticate(username=username, password=password)

           if not user:
               raise serializers.ValidationError(
                   'Credenciales inválidas'
               )

           if not user.is_active:
               raise serializers.ValidationError(
                   'Usuario inactivo'
               )

           attrs['user'] = user
           return attrs


   class TokenSerializer(serializers.Serializer):
       """Serializer para generar tokens JWT."""

       @staticmethod
       def generate_tokens(user):
                                 
           Generar access_token y refresh_token para usuario.

           Args:
               user: Usuario Django

           Returns:
               dict: {'access_token': str, 'refresh_token': str}
                                                                
           access_payload = {
               'user_id': user.id,
               'username': user.username,
               'exp': datetime.utcnow() + timedelta(hours=24),
               'iat': datetime.utcnow(),
               'type': 'access'
           }

           refresh_payload = {
               'user_id': user.id,
               'exp': datetime.utcnow() + timedelta(days=7),
               'iat': datetime.utcnow(),
               'type': 'refresh'
           }

           access_token = jwt.encode(
               access_payload,
               settings.SECRET_KEY,
               algorithm='HS256'
           )

           refresh_token = jwt.encode(
               refresh_payload,
               settings.SECRET_KEY,
               algorithm='HS256'
           )

           return {
               'access_token': access_token,
               'refresh_token': refresh_token
           }


   class RefreshTokenSerializer(serializers.Serializer):
       """Serializer para refresh token."""

       refresh_token = serializers.CharField(required=True)

       def validate_refresh_token(self, value):
           """Validar que refresh token sea válido."""
           try:
               payload = jwt.decode(
                   value,
                   settings.SECRET_KEY,
                   algorithms=['HS256']
               )

               if payload.get('type') != 'refresh':
                   raise serializers.ValidationError('Token inválido')

               return value

           except jwt.ExpiredSignatureError:
               raise serializers.ValidationError('Token expirado')
           except jwt.InvalidTokenError:
               raise serializers.ValidationError('Token inválido')

4.4.2 Crear Views
^^^^^^^^^^^^^^^^^

.. code:: python

   # authentication/views.py
                            
   Views para autenticación JWT.

   RF-AUTH-001: Endpoint de login
   RF-AUTH-002: Endpoint de refresh
                                   

   from rest_framework.views import APIView
   from rest_framework.response import Response
   from rest_framework import status
   from .serializers import (
       LoginSerializer,
       TokenSerializer,
       RefreshTokenSerializer
   )
   import jwt
   from django.conf import settings
   from django.contrib.auth.models import User


   class LoginView(APIView):
                            
       Vista para login con username/password.

       POST /api/auth/login
       Body: {"username": "user", "password": "pass"}
       Returns: {"access_token": "...", "refresh_token": "..."}
                                                               

       def post(self, request):
           """Procesar login y retornar tokens."""
           serializer = LoginSerializer(data=request.data)

           if not serializer.is_valid():
               return Response(
                   serializer.errors,
                   status=status.HTTP_400_BAD_REQUEST
               )

           user = serializer.validated_data['user']
           tokens = TokenSerializer.generate_tokens(user)

           return Response(tokens, status=status.HTTP_200_OK)


   class RefreshTokenView(APIView):
                                   
       Vista para renovar access token usando refresh token.

       POST /api/auth/refresh
       Body: {"refresh_token": "..."}
       Returns: {"access_token": "..."}
                                       

       def post(self, request):
           """Procesar refresh token y retornar nuevo access token."""
           serializer = RefreshTokenSerializer(data=request.data)

           if not serializer.is_valid():
               return Response(
                   serializer.errors,
                   status=status.HTTP_400_BAD_REQUEST
               )

           refresh_token = serializer.validated_data['refresh_token']

           try:
               payload = jwt.decode(
                   refresh_token,
                   settings.SECRET_KEY,
                   algorithms=['HS256']
               )

               user = User.objects.get(id=payload['user_id'])

               # Generar solo nuevo access token
               access_payload = {
                   'user_id': user.id,
                   'username': user.username,
                   'exp': datetime.utcnow() + timedelta(hours=24),
                   'iat': datetime.utcnow(),
                   'type': 'access'
               }

               access_token = jwt.encode(
                   access_payload,
                   settings.SECRET_KEY,
                   algorithm='HS256'
               )

               return Response(
                   {'access_token': access_token},
                   status=status.HTTP_200_OK
               )

           except User.DoesNotExist:
               return Response(
                   {'error': 'Usuario no encontrado'},
                   status=status.HTTP_401_UNAUTHORIZED
               )
           except Exception as e:
               return Response(
                   {'error': str(e)},
                   status=status.HTTP_401_UNAUTHORIZED
               )

4.4.3 Configurar URLs
^^^^^^^^^^^^^^^^^^^^^

.. code:: python

   # authentication/urls.py
   """URLs para autenticación JWT."""

   from django.urls import path
   from .views import LoginView, RefreshTokenView

   app_name = 'authentication'

   urlpatterns = [
       path('login', LoginView.as_view(), name='login'),
       path('refresh', RefreshTokenView.as_view(), name='refresh'),
   ]

.. code:: python

   # callcentersite/urls.py (agregar al principal)
   from django.urls import path, include

   urlpatterns = [
       # ... otras URLs
       path('api/auth/', include('authentication.urls')),
   ]

4.5 Ejecutar Tests Nuevamente (Deberían Pasar - GREEN)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ejecutar tests con cobertura
   pytest tests/authentication/test_jwt_authentication.py -v --cov=authentication

   # Output esperado: PASSED

4.6 Refactorizar (REFACTOR)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Revisar el código para: - [ ] Eliminar código duplicado - [ ] Mejorar
nombres de variables/funciones - [ ] Agregar docstrings completos - [ ]
Simplificar lógica compleja - [ ] Extraer constantes mágicas a settings

.. code:: python

   # authentication/settings.py (nueva configuración)
   """Configuración para módulo de autenticación."""

   from django.conf import settings

   # JWT Settings
   JWT_ACCESS_TOKEN_LIFETIME = getattr(
       settings,
       'JWT_ACCESS_TOKEN_LIFETIME',
       24  # horas
   )

   JWT_REFRESH_TOKEN_LIFETIME = getattr(
       settings,
       'JWT_REFRESH_TOKEN_LIFETIME',
       7  # días
   )

   JWT_ALGORITHM = 'HS256'

4.7 Ejecutar Suite Completa de Tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ejecutar TODOS los tests del proyecto
   pytest

   # Ejecutar con cobertura
   pytest --cov=. --cov-report=html

   # Verificar que cobertura sea >= 80%
   open htmlcov/index.html

--------------

Paso 5: Validaciones Locales (Pre-Commit)
-----------------------------------------

5.1 Formateo de Código
~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Formatear con Black
   black .

   # Organizar imports con isort
   isort .

   # Verificar que no haya cambios adicionales
   git status

5.2 Linting
~~~~~~~~~~~

.. code:: bash

   # Linting con Ruff
   ruff check .

   # Auto-fix issues que se puedan arreglar
   ruff check --fix .

   # Verificar que no queden issues
   ruff check .

5.3 Type Checking
~~~~~~~~~~~~~~~~~

.. code:: bash

   # Type checking con MyPy
   mypy api/

   # Si hay errores, agregar type hints
   # Ejemplo:
   # def login(username: str, password: str) -> Dict[str, str]:
   #     ...

5.4 Security Scan
~~~~~~~~~~~~~~~~~

.. code:: bash

   # Escaneo de seguridad con Bandit
   bandit -r api/ -f json -o bandit-report.json

   # Revisar reporte
   cat bandit-report.json | jq

   # Si hay issues de severidad HIGH o CRITICAL, corregir antes de continuar

5.5 Secret Detection
~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Detectar secretos
   detect-secrets scan

   # Si detecta falsos positivos, agregar a baseline
   detect-secrets scan --baseline .secrets.baseline

   # Verificar que no haya secretos reales

5.6 Ejecutar Tests con Coverage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Tests completos con cobertura
   pytest --cov=. --cov-report=html --cov-report=term

   # Verificar métricas:
   # - Cobertura total >= 80%
   # - Todos los tests pasan
   # - Sin warnings críticos

   # Ver reporte HTML detallado
   open htmlcov/index.html

--------------

Paso 6: Commits
---------------

6.1 Conventional Commits
~~~~~~~~~~~~~~~~~~~~~~~~

**Formato:**

::

   <tipo>: <descripción corta>

   <descripción larga opcional>

   <referencias a issues>

**Tipos válidos:** - ``feat``: Nueva funcionalidad - ``fix``: Corrección
de bug - ``refactor``: Refactorización sin cambio funcional - ``perf``:
Mejora de performance - ``test``: Agregar o modificar tests - ``docs``:
Solo cambios en documentación - ``chore``: Cambios de build, deps,
configuración

6.2 Crear Commits Atómicos
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ver cambios
   git status
   git diff

   # Agregar archivos relacionados (commit atómico)
   git add authentication/

   # Commit con mensaje descriptivo
   git commit -m "feat: implementar autenticación JWT

   - Crear serializers para login y refresh token
   - Implementar views para endpoints de autenticación
   - Agregar validación de credenciales
   - Generar JWT tokens con PyJWT
   - Configurar URLs /api/auth/login y /api/auth/refresh

   Los tokens incluyen:
   - access_token: expira en 24 horas
   - refresh_token: expira en 7 días

   Payload contiene user_id, username, y tipo de token.

   Relacionado con #123"

6.3 Pre-commit Hooks Automáticos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Al hacer commit, se ejecutan automáticamente:

.. code:: bash

   # Pre-commit hooks configurados:
   - Ruff (linting)
   - MyPy (type checking)
   - Bandit (security)
   - detect-secrets (secrets)
   - trailing-whitespace
   - end-of-file-fixer
   - check-yaml
   - check-json

   # Si algún hook falla:
   # 1. Revisar el error
   # 2. Corregir el problema
   # 3. git add los cambios
   # 4. git commit nuevamente

6.4 Commits de Tests
~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Commit separado para tests
   git add tests/authentication/
   git commit -m "test: agregar tests para autenticación JWT

   - Tests unitarios para LoginSerializer
   - Tests unitarios para TokenSerializer
   - Tests de integración para LoginView
   - Tests de integración para RefreshTokenView
   - Tests de middleware JWT

   Cobertura: 95% del módulo authentication

   Relacionado con #123"

6.5 Commits de Documentación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Commit para documentación
   git add docs/implementacion/backend/
   git commit -m "docs: documentar implementación de autenticación JWT

   - Agregar guía de uso de endpoints auth
   - Documentar estructura de tokens
   - Incluir ejemplos de requests/responses
   - Actualizar README con instrucciones de configuración

   Relacionado con #123"

--------------

Paso 7: Pre-Pull Request
------------------------

7.1 Actualizar con Main
~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Traer últimos cambios de main
   git checkout main
   git pull origin main

   # Volver a tu branch
   git checkout feature/autenticacion-jwt-20251106

   # Rebase con main
   git rebase main

   # Si hay conflictos:
   # 1. Resolver conflictos manualmente
   # 2. git add archivos-resueltos
   # 3. git rebase --continue

   # Ejecutar tests nuevamente después de rebase
   pytest --cov=. --cov-report=html

7.2 Squash Commits (Opcional)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Si tienes muchos commits pequeños, considera hacer squash:

.. code:: bash

   # Ver historial de commits
   git log --oneline

   # Squash últimos N commits
   git rebase -i HEAD~5

   # En el editor, cambiar 'pick' a 'squash' para commits a combinar
   # Guardar y cerrar editor

   # Editar mensaje de commit consolidado
   # Guardar y cerrar editor

7.3 Push a Remote
~~~~~~~~~~~~~~~~~

.. code:: bash

   # Push con tracking
   git push -u origin feature/autenticacion-jwt-20251106

   # Si hiciste rebase o squash (forzar push)
   git push -u origin feature/autenticacion-jwt-20251106 --force-with-lease

   # Para branches claude/* (con session ID)
   git push -u origin claude/implement-jwt-auth-011CUr35zai2SsJs6DyPKRR8

--------------

Paso 8: Crear Pull Request
--------------------------

8.1 Usando gh CLI (Recomendado)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   gh pr create \
     --title "feat: Agregar autenticación JWT" \
     --body "$(cat <<'EOF'
   ## Summary
   - Implementa autenticación con JSON Web Tokens (JWT)
   - Agrega endpoints POST /api/auth/login y POST /api/auth/refresh
   - Configura validación de credenciales con Django authenticate
   - Genera tokens con expiración configurable (24h access, 7d refresh)
   - Cobertura de tests: 95% del módulo authentication

   ## Technical Details
   **Endpoints implementados:**
   - `POST /api/auth/login`: Recibe username/password, retorna tokens
   - `POST /api/auth/refresh`: Recibe refresh_token, retorna nuevo access_token

   **Estructura de tokens:**
   ```json
   {
     "user_id": 123,
     "username": "john_doe",
     "exp": 1699123456,
     "iat": 1699037056,
     "type": "access"
   }

**Dependencias agregadas:** - PyJWT==2.8.0

Test Plan
---------

-  ☒ Tests unitarios de LoginSerializer (4 casos)
-  ☒ Tests unitarios de TokenSerializer (generación tokens)
-  ☒ Tests unitarios de RefreshTokenSerializer (validación)
-  ☒ Tests de integración LoginView (success, invalid creds, missing
   fields, inactive user)
-  ☒ Tests de integración RefreshTokenView (success, invalid token)
-  ☒ Tests de middleware JWT (sin token, token válido, token expirado)
-  ☒ Cobertura total: 95%
-  ☒ Security scan con Bandit: 0 issues
-  ☒ Secret detection: 0 secrets detectados
-  ☒ Validación manual en desarrollo

Related Issues
--------------

Closes #123

Breaking Changes
----------------

Ninguno - Esta es una nueva feature que no afecta funcionalidad
existente.

Deployment Notes
----------------

**Variables de entorno requeridas:**

.. code:: bash

   # Opcional: JWT_ACCESS_TOKEN_LIFETIME (default: 24 horas)
   JWT_ACCESS_TOKEN_LIFETIME=24

   # Opcional: JWT_REFRESH_TOKEN_LIFETIME (default: 7 días)
   JWT_REFRESH_TOKEN_LIFETIME=7

**Migraciones:** No requiere migraciones de BD.

**Instalación de dependencias:**

.. code:: bash

   pip install -r requirements/base.txt

Screenshots
-----------

N/A - Backend API

Checklist
---------

-  ☒ Código sigue lineamientos del proyecto
-  ☒ Tests agregados con cobertura >= 80%
-  ☒ Documentación actualizada
-  ☒ Sin secretos en código
-  ☒ Security scan pasó
-  ☒ Pre-commit hooks pasaron
-  ☒ Branch actualizado con main EOF )”
   –assignee @me
   –reviewer @equipo-backend
   –label “enhancement,backend”

::


   ### 8.2 Usando GitHub UI

   1. Ir a: https://github.com/2-Coatl/IACT---project/pulls
   2. Click "New pull request"
   3. Seleccionar:
      - Base: `main`
      - Compare: `feature/autenticacion-jwt-20251106`
   4. Click "Create pull request"
   5. Completar template que se carga automáticamente

   ### 8.3 Verificar PR Creado

   ```bash
   # Ver PR creado
   gh pr view

   # Ver status de checks
   gh pr checks

   # Ver conversación
   gh pr view --web

--------------

Paso 9: Code Review
-------------------

9.1 CI/CD Automático
~~~~~~~~~~~~~~~~~~~~

Al crear el PR, se ejecutan automáticamente:

**Workflow: python-ci.yml**

.. code:: yaml

   - Ruff linting
   - Ruff formatting check
   - MyPy type checking
   - Bandit security scan
   - pytest (todos los tests)
   - Coverage report
   - Upload artifacts

**Workflow: lint.yml**

.. code:: yaml

   - Markdown linting
   - YAML linting
   - Pre-commit hooks

9.2 Requisitos para Aprobar
~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  ☐ Mínimo 1 review aprobado
-  ☐ Todos los CI checks pasan (verde)
-  ☐ Sin conflictos con main
-  ☐ Cobertura >= 80%
-  ☐ Sin secretos detectados
-  ☐ Bandit security scan sin issues HIGH/CRITICAL

9.3 Como Autor del PR
~~~~~~~~~~~~~~~~~~~~~

Responder a Comentarios
^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Ver comentarios del PR
   gh pr view

   # Hacer cambios solicitados
   # ... editar archivos ...

   # Commit cambios
   git add .
   git commit -m "fix: aplicar feedback de code review

   - Renombrar variable confusa 'x' a 'user_id'
   - Agregar docstring faltante en generate_tokens
   - Mejorar manejo de excepciones en RefreshTokenView"

   # Push
   git push

   # El PR se actualiza automáticamente

Re-solicitar Review
^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Después de hacer cambios, re-solicitar review
   gh pr review --request @reviewer-username

   # O comentar en el PR
   gh pr comment --body "Cambios aplicados. Listo para re-review."

9.4 Como Reviewer
~~~~~~~~~~~~~~~~~

Ver Diff del PR
^^^^^^^^^^^^^^^

.. code:: bash

   # Ver diff en terminal
   gh pr diff <PR_NUMBER>

   # Ver PR en browser
   gh pr view <PR_NUMBER> --web

   # Checkout del PR localmente para probar
   gh pr checkout <PR_NUMBER>

Checklist de Review
^^^^^^^^^^^^^^^^^^^

**Funcionalidad:** - [ ] El código hace lo que dice - [ ] Edge cases
considerados - [ ] Manejo de errores apropiado - [ ] Validación de
inputs

**Calidad:** - [ ] Código legible y mantenible - [ ] Sigue lineamientos
del proyecto - [ ] No hay código duplicado - [ ] Nombres descriptivos de
variables/funciones - [ ] Funciones pequeñas y enfocadas

**Tests:** - [ ] Cobertura adecuada (>= 80%) - [ ] Tests son
determinísticos (no flaky) - [ ] Nombres descriptivos de tests - [ ]
Tests cubren edge cases - [ ] Arrange-Act-Assert pattern

**Seguridad:** - [ ] No hay vulnerabilidades obvias - [ ] Inputs
validados - [ ] Secrets no expuestos - [ ] SQL injection prevención - [
] XSS prevención

**Performance:** - [ ] No hay N+1 queries - [ ] Índices apropiados en DB
- [ ] Queries optimizadas - [ ] No hay operaciones bloqueantes
innecesarias

**Documentación:** - [ ] Docstrings completos - [ ] README actualizado
si aplica - [ ] Comentarios en código complejo - [ ] ADR creado si es
decisión arquitectónica

Aprobar PR
^^^^^^^^^^

.. code:: bash

   # Aprobar
   gh pr review <PR_NUMBER> --approve --body "LGTM!

   - Código limpio y bien estructurado
   - Tests completos con 95% coverage
   - Security scan pasó
   - Documentación actualizada

   Excelente trabajo!"

   # Solicitar cambios
   gh pr review <PR_NUMBER> --request-changes --body "Cambios solicitados:

   1. Agregar docstring a la función generate_tokens()
   2. Renombrar variable 'x' a 'user_id' para claridad
   3. Manejar excepción jwt.DecodeError específicamente

   Por favor hacer estos cambios y re-solicitar review."

   # Comentar sin aprobar/rechazar
   gh pr review <PR_NUMBER> --comment --body "Pregunta: ¿Por qué elegiste 24h para expiración de access token? ¿No es muy largo?"

--------------

Paso 10: Merge
--------------

10.1 Pre-Merge Checklist
~~~~~~~~~~~~~~~~~~~~~~~~

Verificar: - [x] Todos los reviews aprobados (mínimo 1) - [x] Todos los
CI checks pasan - [x] Sin conflictos con main - [x] Branch actualizado
con main - [x] Conversación de review resuelta

10.2 Merge con gh CLI
~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Opción A: Squash and Merge (PREFERIDO para features)
   gh pr merge <PR_NUMBER> --squash --delete-branch --body "Merging feature: Autenticación JWT

   Implementación completa de autenticación con JWT para API.

   Closes #123"

   # Opción B: Merge Commit (para releases)
   gh pr merge <PR_NUMBER> --merge --delete-branch

   # Opción C: Rebase (para cambios lineales simples)
   gh pr merge <PR_NUMBER> --rebase --delete-branch

10.3 Merge desde GitHub UI
~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Ir al PR en GitHub
2. Click “Merge pull request”
3. Seleccionar “Squash and merge”
4. Editar mensaje de commit si es necesario
5. Click “Confirm squash and merge”
6. Click “Delete branch”

10.4 Post-Merge Automático
~~~~~~~~~~~~~~~~~~~~~~~~~~

Después del merge, automáticamente:

-  **Issue cierra** (si usaste ``Closes #123``)
-  **Branch se elimina** (si seleccionaste delete branch)
-  **Docs se regeneran** (workflow ``docs.yml`` se ejecuta)
-  **Índices ISO 29148 se actualizan** (workflow
   ``requirements-index.yml``)
-  **Main se actualiza** con tu código

--------------

Paso 11: Post-Merge
-------------------

11.1 Verificar Merge Exitoso
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Actualizar tu main local
   git checkout main
   git pull origin main

   # Verificar que tu commit está en main
   git log --oneline -10

   # Ver tu feature en el historial
   git log --oneline --graph --all

   # Tu feature branch ya no existe
   git branch -a | grep "feature/autenticacion-jwt"

11.2 Verificar Issue Cerrado
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ver issue cerrado
   gh issue view 123

   # Estado esperado: "State: CLOSED"

11.3 Verificar Documentación Actualizada
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ver docs actualizadas
   # https://2-coatl.github.io/IACT---project/

   # O localmente
   make docs-serve
   # Abrir http://127.0.0.1:8000

11.4 Limpiar Branches Locales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Eliminar branch local (ya mergeado)
   git branch -d feature/autenticacion-jwt-20251106

   # Limpiar branches remotos eliminados
   git fetch --prune

   # Ver branches que puedes limpiar
   git branch --merged main

   # Eliminar todas las branches mergeadas
   git branch --merged main | grep -v "main" | xargs git branch -d

--------------

Caso Especial: Hotfix (Bug Crítico)
-----------------------------------

Cuándo Usar Hotfix
~~~~~~~~~~~~~~~~~~

-  Bug crítico en producción
-  Vulnerabilidad de seguridad
-  Pérdida de servicio o funcionalidad crítica
-  Datos corruptos o pérdida de datos

Procedimiento Acelerado
~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # 1. Desde main actualizado
   git checkout main
   git pull origin main

   # 2. Crear hotfix branch
   git checkout -b hotfix/corregir-login-roto-20251106

   # 3. Implementar FIX MÍNIMO (NO agregar features)
   # ... editar solo lo necesario ...

   # 4. Tests específicos del fix
   pytest tests/authentication/test_login.py -v

   # 5. Commit urgente
   git add .
   git commit -m "fix: corregir validación de login

   CRÍTICO: Corrige error que permitía login con credenciales vacías.

   El bug permitía bypass de autenticación si se enviaba request
   con username vacío. Esto es una vulnerabilidad de seguridad crítica.

   Fix:
   - Agregar validación explícita de campos no vacíos
   - Agregar test para prevenir regresión

   Impacto: Seguridad - ALTO
   Severidad: CRÍTICA

   Fixes #789"

   # 6. Push hotfix
   git push -u origin hotfix/corregir-login-roto-20251106

   # 7. PR urgente con labels críticos
   gh pr create \
     --title "HOTFIX: Corregir validación de login" \
     --label "hotfix,urgent,priority-critical,security" \
     --reviewer @equipo-backend @tech-lead \
     --body "## HOTFIX CRÍTICO

   **Vulnerabilidad**: Login permite credenciales vacías

   **Severidad**: CRÍTICA
   **Impacto**: Seguridad - Bypass de autenticación

   ## Fix Implementado
   - Validación explícita de username/password no vacíos
   - Test de regresión agregado

   ## Test Plan
   - [x] Test específico para credenciales vacías
   - [x] Tests existentes siguen pasando
   - [x] Verificación manual

   ## Deployment
   REQUIERE DEPLOY INMEDIATO A PRODUCCIÓN

   Closes #789"

   # 8. Una vez aprobado (FAST-TRACK)
   gh pr merge --squash --delete-branch

   # 9. Tag de versión hotfix INMEDIATO
   git checkout main
   git pull origin main
   git tag -a v1.2.1 -m "Hotfix: Critical login validation fix"
   git push origin v1.2.1

   # 10. Notificar a stakeholders
   echo "HOTFIX v1.2.1 deployed - Critical security fix" | \
     gh issue comment 789 --body-file -

--------------

Métricas de Calidad
-------------------

Métricas del Proyecto
~~~~~~~~~~~~~~~~~~~~~

=============================== ============ ===========================
Métrica                         Target       Cómo Medir
=============================== ============ ===========================
**Cobertura de código**         ≥ 80%        ``pytest --cov``
**Tamaño de PR**                < 400 líneas ``gh pr diff \| wc -l``
**Tiempo de review**            < 48 horas   GitHub PR metrics
**Tasa aprobación 1er intento** > 70%        Manual
**PRs simultáneos por dev**     < 3          ``gh pr list --author @me``
**Tests pasan**                 100%         CI status
**Security issues**             0            Bandit report
**Secrets detectados**          0            detect-secrets
=============================== ============ ===========================

Verificar Métricas
~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Cobertura
   pytest --cov=. --cov-report=term | grep TOTAL

   # Tamaño de tu PR
   gh pr diff | wc -l

   # Tus PRs abiertos
   gh pr list --author @me

   # Security scan
   bandit -r api/ -f screen

   # Secrets
   detect-secrets scan

--------------

Herramientas y Comandos Útiles
------------------------------

Makefile Commands
~~~~~~~~~~~~~~~~~

.. code:: bash

   make help              # Ver todos los comandos
   make setup            # Setup completo del entorno
   make vagrant-up       # Levantar bases de datos
   make vagrant-down     # Apagar VM
   make docs-serve       # Servir docs localmente
   make docs-deploy      # Deploy docs a GitHub Pages
   make check-services   # Verificar conexión BD
   make clean            # Limpiar archivos generados

Git Aliases Útiles
~~~~~~~~~~~~~~~~~~

Agregar a ``~/.gitconfig``:

.. code:: ini

   [alias]
       st = status
       co = checkout
       br = branch
       ci = commit
       lg = log --oneline --graph --all --decorate
       last = log -1 HEAD
       unstage = reset HEAD --
       amend = commit --amend --no-edit

GitHub CLI Aliases
~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Agregar a ~/.config/gh/config.yml
   alias:
     prs: pr list --author @me
     issues: issue list --assignee @me
     co: pr checkout
     mywork: |
       !gh pr list --author @me && gh issue list --assignee @me

--------------

Troubleshooting
---------------

Problema: Tests Fallan Localmente
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Limpiar cache de pytest
   pytest --cache-clear

   # Recrear base de datos de test
   python manage.py test --keepdb=false

   # Instalar dependencias faltantes
   pip install -r requirements/test.txt

   # Verificar variables de entorno
   cat .env

Problema: Pre-commit Hooks Fallan
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ver qué hook falló
   pre-commit run --all-files --verbose

   # Ejecutar hook específico
   pre-commit run ruff --all-files

   # Auto-fix issues
   ruff check --fix .
   black .
   isort .

   # Re-intentar commit
   git commit --no-verify  # SOLO si estás seguro

Problema: Conflictos en Rebase
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ver archivos con conflictos
   git status

   # Abrir archivos y resolver conflictos manualmente
   # Buscar marcadores: <<<<<<<, =======, >>>>>>>

   # Después de resolver
   git add archivos-resueltos
   git rebase --continue

   # Si quieres abortar el rebase
   git rebase --abort

Problema: Push Rechazado
~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Error: Updates were rejected
   # Razón: Main avanzó después de tu último pull

   # Solución:
   git pull --rebase origin main
   git push

   # O si hiciste squash local:
   git push --force-with-lease

Problema: CI Falla pero Local Pasa
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Verificar versiones de dependencias
   pip freeze > requirements-actual.txt
   diff requirements/base.txt requirements-actual.txt

   # Ejecutar en entorno limpio
   deactivate
   rm -rf .venv
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements/dev.txt
   pytest

   # Verificar workflow de CI localmente con act
   act pull_request

--------------

Recursos Relacionados
---------------------

Documentación Interna
~~~~~~~~~~~~~~~~~~~~~

-  `Procedimiento de Gestión de
   Cambios <procedimiento_gestion_cambios.md>`__ - Proceso formal
-  `Procedimiento de Desarrollo
   Local <procedimiento_desarrollo_local.md>`__ - Setup entorno
-  `Procedimiento de QA <procedimiento_qa.md>`__ - Testing y calidad
-  `Procedimiento de Release <procedimiento_release.md>`__ - Releases y
   deployment
-  `Lineamientos de Código <../arquitectura/lineamientos_codigo.md>`__ -
   Estándares de código
-  `Checklist de Desarrollo <../checklists/checklist_desarrollo.md>`__ -
   Checklist completo

Referencias Externas
~~~~~~~~~~~~~~~~~~~~

-  `Conventional Commits <https://www.conventionalcommits.org/>`__ -
   Formato de commits
-  `GitHub Flow <https://guides.github.com/introduction/flow/>`__ -
   Workflow Git
-  `Semantic Versioning <https://semver.org/>`__ - Versionado semántico
-  `Test-Driven
   Development <https://testdriven.io/test-driven-development/>`__ - TDD
   best practices
-  `Django Best
   Practices <https://django-best-practices.readthedocs.io/>`__ - Django
   patterns

Herramientas
~~~~~~~~~~~~

-  `GitHub CLI <https://cli.github.com/>`__ - ``gh`` command line tool
-  `Pre-commit <https://pre-commit.com/>`__ - Git hooks framework
-  `Ruff <https://github.com/astral-sh/ruff>`__ - Python linter
-  `Black <https://github.com/psf/black>`__ - Code formatter
-  `pytest <https://docs.pytest.org/>`__ - Testing framework
-  `Bandit <https://github.com/PyCQA/bandit>`__ - Security linter

--------------

Changelog
---------

-  **2025-11-06**: Creación inicial de la guía completa

   -  Flujo completo paso a paso con ejemplos
   -  Sección de TDD con código de ejemplo
   -  Troubleshooting común
   -  Caso especial de hotfix
   -  Métricas de calidad

--------------

Notas Finales
-------------

Principios Clave
~~~~~~~~~~~~~~~~

1. **TDD Siempre**: Tests primero, código después
2. **Commits Atómicos**: Un cambio lógico por commit
3. **PRs Pequeños**: < 400 líneas idealmente
4. **Review Rápido**: < 48 horas objetivo
5. **Documentar Todo**: Código, decisiones, procesos
6. **Calidad > Velocidad**: Mejor código limpio que rápido
7. **Preguntar Temprano**: Si tienes dudas, pregunta

Cuando Pedir Ayuda
~~~~~~~~~~~~~~~~~~

Pide ayuda si: - No entiendes un requisito - El fix parece muy complejo
- Tests fallan sin razón aparente - Conflictos de merge muy grandes -
Decisión arquitectónica significativa - Bloqueado por > 2 horas

Canales de Comunicación
~~~~~~~~~~~~~~~~~~~~~~~

-  **Slack #desarrollo**: Preguntas generales
-  **Slack #backend**: Preguntas técnicas backend
-  **GitHub Issues**: Bugs y features
-  **GitHub Discussions**: Propuestas y discusiones
-  **Pull Requests**: Code review y feedback

--------------

**Bienvenido al equipo de desarrollo IACT**
