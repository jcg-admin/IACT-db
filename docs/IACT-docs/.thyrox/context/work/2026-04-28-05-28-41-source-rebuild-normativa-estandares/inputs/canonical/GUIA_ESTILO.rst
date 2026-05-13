Guía de Estilo - Proyecto IACT
==============================

Propósito
---------

Definir las convenciones de estilo para todo el contenido del proyecto
IACT, incluyendo código, documentación, commits, y comunicación.

Alcance
-------

Esta guía aplica a: - Documentación (archivos .md) - Código fuente
(Python, JavaScript, etc.) - Mensajes de commit - Pull Requests - Issues
- Comentarios en código

--------------

1. Uso de Emojis
----------------

Regla Principal
~~~~~~~~~~~~~~~

**PROHIBIDO**: No usar emojis en ningún documento, código, o
comunicación del proyecto.

Justificación
~~~~~~~~~~~~~

-  Mantener profesionalismo y claridad
-  Evitar problemas de codificación y compatibilidad
-  Garantizar legibilidad en todos los entornos
-  Facilitar búsqueda y procesamiento de texto

Ejemplos
~~~~~~~~

**Incorrecto:**

.. code:: markdown

   ## Paso 1: Setup inicial 

   - [x] Python instalado
   - [ ] Node.js no instalado
   -  Configurar entorno

**Correcto:**

.. code:: markdown

   ## Paso 1: Setup inicial

   - [x] Python instalado
   - [ ] Node.js no instalado
   - Configurar entorno

**Incorrecto (commits):**

.. code:: bash

   git commit -m "feat: agregar autenticación JWT "
   git commit -m "fix: corregir bug crítico "

**Correcto (commits):**

.. code:: bash

   git commit -m "feat: agregar autenticación JWT"
   git commit -m "fix: corregir bug crítico en validación"

Excepciones
~~~~~~~~~~~

**ÚNICA EXCEPCIÓN**: Si el usuario solicita explícitamente emojis en un
contexto específico.

Ejemplo válido:

::

   Usuario: "Crea un README para usuarios finales con emojis para hacerlo más amigable"
   Asistente: [Puede usar emojis en este caso específico]

Alternativas Recomendadas
~~~~~~~~~~~~~~~~~~~~~~~~~

En lugar de emojis, usar:

========= ====================================
Emoji     Alternativa
========= ====================================
[x]       ``[x]`` o “Completado” o “Correcto”
[ ]       ``[ ]`` o “Pendiente” o “Incorrecto”
\         “Lanzamiento” o simplemente omitir
\         “Configurar” o “Herramientas”
\         “Documentación” o simplemente omitir
[WARNING] “ADVERTENCIA:” o “Nota:”
\         “CRÍTICO:” o “URGENTE:”
\         “Sugerencia:” o “Nota:”
\         “Seguridad” o simplemente omitir
========= ====================================

--------------

2. Formato de Documentación Markdown
------------------------------------

Encabezados
~~~~~~~~~~~

.. code:: markdown

   # Título Principal (H1) - Solo uno por documento

   ## Sección Principal (H2)

   ### Subsección (H3)

   #### Subsección menor (H4)

**Reglas:** - Solo un H1 por documento - No saltar niveles (H1 -> H3) -
Usar espacios antes y después de encabezados

Listas
~~~~~~

**Listas sin ordenar:**

.. code:: markdown

   - Elemento 1
   - Elemento 2
     - Sub-elemento 2.1
     - Sub-elemento 2.2
   - Elemento 3

**Listas ordenadas:**

.. code:: markdown

   1. Primer paso
   2. Segundo paso
   3. Tercer paso

**Listas de tareas:**

.. code:: markdown

   - [ ] Tarea pendiente
   - [x] Tarea completada
   - [ ] Otra tarea pendiente

Bloques de Código
~~~~~~~~~~~~~~~~~

**Código inline:**

.. code:: markdown

   Usar el comando `git status` para ver cambios.

**Bloques de código:**

.. code:: markdown

   ```bash
   git add .
   git commit -m "feat: nueva funcionalidad"
   git push
           

**Reglas:** - Siempre especificar el lenguaje después de las comillas -
Usar sangría consistente dentro del bloque - No mezclar tabs y espacios

Enlaces
~~~~~~~

**Enlaces inline:**

.. code:: markdown

   Ver [documentación oficial](https://example.com)

**Enlaces con referencia:**

.. code:: markdown

   Ver [documentación][1]

   [1]: https://example.com

Énfasis
~~~~~~~

.. code:: markdown

   **Negrita** para énfasis fuerte
   *Cursiva* para énfasis leve
   `Código inline` para comandos o código

--------------

3. Estilo de Código Python
--------------------------

Formateo
~~~~~~~~

**Herramienta obligatoria:** Black

.. code:: bash

   black .

**Configuración:** - Longitud de línea: 88 caracteres (default de Black)
- Comillas: dobles por defecto - Sangría: 4 espacios (nunca tabs)

Imports
~~~~~~~

**Orden (isort):**

.. code:: python

   # 1. Imports estándar
   import os
   import sys
   from datetime import datetime

   # 2. Imports third-party
   import django
   from rest_framework import serializers

   # 3. Imports locales
   from .models import User
   from .utils import generate_token

Nombrado
~~~~~~~~

.. code:: python

   # Clases: PascalCase
   class UserAuthentication:
       pass

   # Funciones y métodos: snake_case
   def generate_access_token():
       pass

   # Constantes: UPPER_SNAKE_CASE
   MAX_TOKEN_LIFETIME = 3600

   # Variables: snake_case
   user_count = 10
   is_active = True

Docstrings
~~~~~~~~~~

**Formato Google Style:**

.. code:: python

   def generate_token(user_id: int, expiration: int = 3600) -> str:
                                                                   
       Generar token JWT para usuario.

       Args:
           user_id: ID del usuario en la base de datos.
           expiration: Tiempo de expiración en segundos. Default: 3600.

       Returns:
           Token JWT como string.

       Raises:
           ValueError: Si user_id es inválido.
           TokenGenerationError: Si falla la generación del token.

       Example:
           >>> token = generate_token(123, expiration=7200)
           >>> print(token)
           'eyJ0eXAiOiJKV1QiLCJhbGc...'
                                       
       pass

Type Hints
~~~~~~~~~~

**Obligatorio** para todas las funciones públicas:

.. code:: python

   from typing import Dict, List, Optional

   def get_user_data(user_id: int) -> Dict[str, any]:
       """Obtener datos del usuario."""
       pass

   def find_users(active: bool = True) -> List[User]:
       """Buscar usuarios activos."""
       pass

   def get_token(refresh_token: Optional[str] = None) -> Optional[str]:
       """Generar o renovar token."""
       pass

--------------

4. Mensajes de Commit
---------------------

Formato Conventional Commits
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Estructura obligatoria:**

::

   <tipo>: <descripción corta>

   <descripción larga opcional>

   <referencias a issues>

Tipos Válidos
~~~~~~~~~~~~~

.. code:: bash

   feat:     # Nueva funcionalidad
   fix:      # Corrección de bug
   refactor: # Refactorización sin cambio funcional
   perf:     # Mejora de performance
   test:     # Agregar o modificar tests
   docs:     # Solo cambios en documentación
   chore:    # Cambios de build, deps, configuración
   style:    # Formateo de código (sin cambio funcional)
   ci:       # Cambios en CI/CD

Reglas
~~~~~~

1. **Descripción corta:**

   -  Máximo 72 caracteres
   -  Minúsculas
   -  Sin punto final
   -  Verbo en infinitivo

2. **Descripción larga:**

   -  Opcional pero recomendada
   -  Explicar QUÉ y POR QUÉ (no CÓMO)
   -  Máximo 80 caracteres por línea

3. **Referencias:**

   -  ``Closes #123`` - Cierra issue automáticamente
   -  ``Fixes #456`` - Corrige bug
   -  ``Related to #789`` - Relacionado sin cerrar

Ejemplos Correctos
~~~~~~~~~~~~~~~~~~

.. code:: bash

   feat: agregar autenticación JWT

   - Implementar serializers para login y refresh token
   - Crear vistas para endpoints de autenticación
   - Agregar validación de credenciales
   - Generar JWT tokens con PyJWT

   Los tokens incluyen user_id, username, y tipo de token.
   Access token expira en 24h, refresh token en 7 días.

   Closes #123

.. code:: bash

   fix: corregir validación de login con credenciales vacías

   El bug permitía bypass de autenticación si se enviaba request
   con username vacío. Vulnerabilidad de seguridad crítica.

   Fix:
   - Agregar validación explícita de campos no vacíos
   - Agregar test para prevenir regresión

   Fixes #789

Ejemplos Incorrectos
~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # MAL: Mayúscula inicial
   Feat: agregar autenticación

   # MAL: Punto final
   feat: agregar autenticación.

   # MAL: Demasiado largo (>72 chars)
   feat: agregar autenticación JWT con tokens de acceso y refresh para la API completa

   # MAL: Sin tipo
   agregar autenticación JWT

   # MAL: Descripción vaga
   fix: corregir bug

   # MAL: Emojis
   feat: agregar autenticación JWT 

--------------

5. Pull Requests
----------------

Título
~~~~~~

**Formato:** Igual que commits (Conventional Commits)

::

   feat: Agregar autenticación JWT
   fix: Corregir validación de login
   docs: Actualizar guía de desarrollo

Descripción
~~~~~~~~~~~

**Template obligatorio:**

.. code:: markdown

   ## Summary
   - Cambio principal 1
   - Cambio principal 2
   - Cambio principal 3

   ## Technical Details
   [Descripción técnica detallada si es necesario]

   ## Test Plan
   - [ ] Tests unitarios agregados/actualizados
   - [ ] Tests de integración
   - [ ] Cobertura >= 80%
   - [ ] Verificación manual

   ## Related Issues
   Closes #123
   Related to #456

   ## Breaking Changes
   [Listar si hay cambios incompatibles]

   ## Deployment Notes
   [Pasos especiales si aplica]

   ## Checklist
   - [ ] Código sigue lineamientos del proyecto
   - [ ] Tests agregados con cobertura >= 80%
   - [ ] Documentación actualizada
   - [ ] Sin secretos en código
   - [ ] Security scan pasó
   - [ ] Pre-commit hooks pasaron
   - [ ] Branch actualizado con main

.. _reglas-1:

Reglas
~~~~~~

1. **Tamaño:** Máximo 400 líneas de código
2. **Alcance:** Un solo cambio lógico por PR
3. **Reviews:** Mínimo 1 aprobación requerida
4. **CI/CD:** Todos los checks deben pasar
5. **Conflictos:** Resolver antes de merge

--------------

6. Nombres de Archivos
----------------------

Convenciones
~~~~~~~~~~~~

.. code:: bash

   # Python: snake_case
   user_authentication.py
   generate_token.py
   test_user_auth.py

   # Documentación: snake_case o kebab-case
   guia_desarrollo.md
   procedimiento-qa.md
   README.md

   # Configuración: lowercase con guiones
   .pre-commit-config.yaml
   docker-compose.yml

Evitar
~~~~~~

.. code:: bash

   # MAL: PascalCase para archivos
   UserAuthentication.py

   # MAL: camelCase para archivos
   userAuthentication.py

   # MAL: Espacios en nombres
   user authentication.py

   # MAL: Caracteres especiales
   user@authentication.py

--------------

7. Comentarios en Código
------------------------

Cuándo Comentar
~~~~~~~~~~~~~~~

**SÍ comentar:** - Lógica compleja o no obvia - Razones de decisiones
arquitectónicas - Workarounds temporales (con TODO) - Algoritmos
complejos - Requisitos de negocio específicos

**NO comentar:** - Código auto-explicativo - Redundancia con docstrings
- Código comentado (eliminarlo)

Formato
~~~~~~~

.. code:: python

   # Correcto: Comentario conciso explicando POR QUÉ
   # Usamos algoritmo de dos punteros por performance O(n) vs O(n²)
   def find_duplicates(arr):
       pass

   # Incorrecto: Comentario redundante
   # Esta función suma dos números
   def add(a, b):
       return a + b

TODOs
~~~~~

.. code:: python

   # TODO(usuario): Descripción de tarea pendiente
   # TODO(juan): Refactorizar para usar cache Redis

   # FIXME: Descripción de problema conocido
   # FIXME: Este workaround temporal debe removerse en v2.0

   # HACK: Descripción de solución temporal
   # HACK: Parche rápido hasta que se implemente solución correcta

--------------

8. Estructura de Directorios
----------------------------

Nomenclatura
~~~~~~~~~~~~

::

   proyecto/
   ├── api/                    # Código backend
   │   ├── apps/              # Django apps (snake_case)
   │   ├── tests/             # Tests organizados por app
   │   └── requirements/      # Dependencias
   ├── docs/                   # Documentación
   │   ├── arquitectura/      # ADRs y diseño
   │   ├── gobernanza/        # Procesos y procedimientos
   │   └── implementacion/    # Docs técnica
   ├── scripts/               # Scripts de automatización
   │   ├── ai/               # Agentes AI
   │   └── requisitos/       # Scripts de gestión
   └── infrastructure/        # Infraestructura como código

--------------

9. Testing
----------

Nombres de Tests
~~~~~~~~~~~~~~~~

.. code:: python

   # Formato: test_<acción>_<condición>_<resultado_esperado>

   def test_login_success_returns_tokens():
       """Test que login exitoso retorna access y refresh token."""
       pass

   def test_login_invalid_credentials_returns_401():
       """Test que credenciales inválidas retornan 401."""
       pass

   def test_refresh_token_expired_returns_401():
       """Test que token expirado retorna 401."""
       pass

Estructura (AAA Pattern)
~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: python

   def test_example():
       """Descripción del test."""
       # Arrange - Configurar
       user = User.objects.create_user(username='test')
       client = APIClient()

       # Act - Ejecutar
       response = client.post('/api/login', {...})

       # Assert - Verificar
       assert response.status_code == 200
       assert 'access_token' in response.data

--------------

10. Documentación de APIs
-------------------------

Formato OpenAPI/Swagger
~~~~~~~~~~~~~~~~~~~~~~~

.. code:: python

   class LoginView(APIView):
                            
       Vista para autenticación de usuarios.

       Endpoints:
           POST /api/auth/login - Login con username/password

       Request Body:
           {
               "username": "string",
               "password": "string"
           }

       Response 200:
           {
               "access_token": "string",
               "refresh_token": "string"
           }

       Response 401:
           {
               "error": "Credenciales inválidas"
           }
            
       pass

--------------

11. Versionado Semántico
------------------------

.. _guia-estilo-formato-1:

Formato
~~~~~~~

::

   v<MAJOR>.<MINOR>.<PATCH>

   Ejemplo: v1.2.3

.. _reglas-2:

Reglas
~~~~~~

-  **MAJOR**: Cambios incompatibles (breaking changes)
-  **MINOR**: Nueva funcionalidad compatible
-  **PATCH**: Correcciones de bugs compatibles

.. _guia-estilo-ejemplos-1:

Ejemplos
~~~~~~~~

.. code:: bash

   v1.0.0 -> v1.0.1  # Bug fix
   v1.0.1 -> v1.1.0  # Nueva feature
   v1.1.0 -> v2.0.0  # Breaking change

--------------

12. Validación Automática
-------------------------

Pre-commit Hooks
~~~~~~~~~~~~~~~~

El proyecto usa pre-commit hooks para validar:

-  Formato de código (Black, isort)
-  Linting (Ruff)
-  Type checking (MyPy)
-  Security scan (Bandit)
-  Secret detection (detect-secrets)
-  **Detección de emojis** (custom hook)

Ejecutar Manualmente
~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ejecutar todos los hooks
   pre-commit run --all-files

   # Ejecutar hook específico
   pre-commit run black --all-files
   pre-commit run no-emojis --all-files

--------------

13. Métricas de Calidad
-----------------------

Objetivos
~~~~~~~~~

======================= =============
Métrica                 Target
======================= =============
Cobertura de código     >= 80%
Complejidad ciclomática <= 10
Longitud de funciones   <= 50 líneas
Longitud de archivos    <= 500 líneas
Tamaño de PR            <= 400 líneas
======================= =============

Herramientas
~~~~~~~~~~~~

.. code:: bash

   # Cobertura
   pytest --cov=. --cov-report=html

   # Complejidad
   radon cc api/ -a -nb

   # Linting
   ruff check .

   # Type coverage
   mypy --strict api/

--------------

14. Excepciones a la Guía
-------------------------

Proceso de Excepción
~~~~~~~~~~~~~~~~~~~~

Si necesitas una excepción a esta guía:

1. **Crear issue** describiendo:

   -  Regla a exceptuar
   -  Razón justificada
   -  Alcance de la excepción
   -  Duración (temporal/permanente)

2. **Aprobación requerida:**

   -  Tech Lead (decisiones técnicas)
   -  BA Lead (requisitos y docs)
   -  Security Lead (seguridad)

3. **Documentar** en ADR si es decisión arquitectónica

Ejemplo
~~~~~~~

.. code:: markdown

   ## Excepción: Uso de emojis en UI de usuario final

   **Razón:** Marketing solicita emojis para UI más amigable
   **Alcance:** Solo archivos en /frontend/public/
   **Duración:** Permanente
   **Aprobado por:** Product Owner, Tech Lead
   **ADR:** ADR_2025_007

--------------

15. Recursos Adicionales
------------------------

Referencias
~~~~~~~~~~~

-  `Conventional Commits <https://www.conventionalcommits.org/>`__
-  `Google Python Style
   Guide <https://google.github.io/styleguide/pyguide.html>`__
-  `PEP 8 <https://pep8.org/>`__
-  `PEP 257 - Docstring
   Conventions <https://www.python.org/dev/peps/pep-0257/>`__
-  `Semantic Versioning <https://semver.org/>`__
-  `Keep a Changelog <https://keepachangelog.com/>`__

.. _guia-estilo-herramientas-1:

Herramientas
~~~~~~~~~~~~

-  **Black**: Formateo automático Python
-  **isort**: Ordenar imports
-  **Ruff**: Linting ultra-rápido
-  **MyPy**: Type checking
-  **Bandit**: Security linting
-  **pre-commit**: Git hooks framework

--------------

Changelog
---------

+-------------------+--------------+-------------------+--------------+
| Versión           | Fecha        | Cambios           | Autor        |
+===================+==============+===================+==============+
| 1.0.0             | 2025-11-06   | Creación inicial  | Equipo       |
|                   |              | de guía de estilo | Gobernanza   |
|                   |              | completa          |              |
+-------------------+--------------+-------------------+--------------+

--------------

Contacto
--------

Para preguntas sobre esta guía: - **Guía General**: Equipo Gobernanza -
**Código Python**: Tech Lead - **Documentación**: BA Lead -
**Seguridad**: Security Lead

--------------

**Esta guía es obligatoria para todos los contribuidores del proyecto
IACT.**
