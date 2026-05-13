.. _prereqs:

************************************
Requisitos Previos y Configuración del Entorno
************************************

Este documento describe los requisitos técnicos, herramientas y configuraciones
necesarias para ejecutar y desarrollar el Sistema IACT.


Requisitos de Software
======================

Componentes Esenciales
----------------------

**Python**

* Versión: 3.11 o superior
* Requerido para: Backend Django/DRF
* Verificar instalación: ``python --version``

**Base de Datos MySQL**

* Versión: 8.0 o superior
* Requerido para: Base de datos Analytics y sesiones
* Alternativa: PostgreSQL 13+

**Git**

* Versión: 2.30 o superior
* Requerido para: Control de versiones
* Verificar instalación: ``git --version``

**Docker y Docker Compose** (Opcional pero recomendado)

* Docker: 20.10 o superior
* Docker Compose: 2.0 o superior
* Requerido para: Contenedorización y desarrollo local
* Verificar instalación: ``docker --version`` y ``docker-compose --version``

Herramientas de Desarrollo
---------------------------

**Editor de Código / IDE**

Opciones recomendadas:

* PyCharm Professional (recomendado para Django)
* Visual Studio Code con extensiones Python
* Sublime Text con plugins Python

**Cliente de Base de Datos**

Opciones recomendadas:

* MySQL Workbench (para MySQL)
* DBeaver (multiplataforma, soporta MySQL y PostgreSQL)
* pgAdmin (para PostgreSQL)
* DataGrip (JetBrains)

**Herramientas de Prueba de API**

* Postman
* Insomnia
* curl (línea de comandos)
* Thunder Client (extensión VS Code)

**Navegador Web Moderno**

* Google Chrome (recomendado para desarrollo)
* Mozilla Firefox
* Microsoft Edge

Con extensiones útiles:

* JSON Formatter
* Redux DevTools (si aplica)
* React Developer Tools (si aplica)


Dependencias del Sistema
=========================

Sistema Operativo
-----------------

**Linux (Recomendado para Producción)**

* Ubuntu 22.04 LTS o superior
* CentOS 8 / Rocky Linux 8
* Debian 11 o superior

**Windows (Desarrollo)**

* Windows 10/11 con WSL2 (Windows Subsystem for Linux)
* Git Bash instalado
* PowerShell 7+ (opcional)

**macOS (Desarrollo)**

* macOS 12 (Monterey) o superior
* Xcode Command Line Tools instalados

Bibliotecas del Sistema
------------------------

**Para Ubuntu/Debian:**

.. code-block:: bash

    sudo apt-get update
    sudo apt-get install -y \
        python3.11 \
        python3.11-venv \
        python3.11-dev \
        build-essential \
        libmysqlclient-dev \
        pkg-config \
        git \
        curl \
        wget

**Para CentOS/Rocky Linux:**

.. code-block:: bash

    sudo dnf install -y \
        python311 \
        python311-devel \
        gcc \
        mysql-devel \
        git \
        curl \
        wget

**Para macOS (con Homebrew):**

.. code-block:: bash

    brew install python@3.11 mysql git


Configuración del Entorno de Desarrollo
========================================

Paso 1: Clonar el Repositorio
------------------------------

.. code-block:: bash

    git clone [URL-DEL-REPOSITORIO-INTERNO]
    cd iact-system

Paso 2: Crear Entorno Virtual
------------------------------

**Linux/macOS:**

.. code-block:: bash

    python3.11 -m venv .venv
    source .venv/bin/activate

**Windows (Git Bash):**

.. code-block:: bash

    python -m venv .venv
    source .venv/Scripts/activate

**Windows (PowerShell):**

.. code-block:: powershell

    python -m venv .venv
    .venv\Scripts\Activate.ps1

Paso 3: Instalar Dependencias de Python
----------------------------------------

.. code-block:: bash

    pip install --upgrade pip
    pip install -r requirements.txt

Para entorno de desarrollo (incluye herramientas de testing):

.. code-block:: bash

    pip install -r requirements-dev.txt

Paso 4: Configurar Variables de Entorno
----------------------------------------

Crear archivo ``.env`` en la raíz del proyecto:

.. code-block:: bash

    cp .env.example .env

Editar ``.env`` con las configuraciones necesarias:

.. code-block:: bash

    # Django
    DEBUG=True
    SECRET_KEY=your-secret-key-here
    ALLOWED_HOSTS=localhost,127.0.0.1

    # Base de Datos Analytics (lectura/escritura)
    DB_DEFAULT_ENGINE=django.db.backends.mysql
    DB_DEFAULT_NAME=iact_analytics
    DB_DEFAULT_USER=iact_user
    DB_DEFAULT_PASSWORD=your-password
    DB_DEFAULT_HOST=localhost
    DB_DEFAULT_PORT=3306

    # Base de Datos IVR (solo lectura)
    DB_IVR_ENGINE=django.db.backends.mysql
    DB_IVR_NAME=ivr_production
    DB_IVR_USER=ivr_readonly
    DB_IVR_PASSWORD=readonly-password
    DB_IVR_HOST=ivr-server.internal
    DB_IVR_PORT=3306

    # JWT
    JWT_ACCESS_TOKEN_LIFETIME=15
    JWT_REFRESH_TOKEN_LIFETIME=10080

    # ETL Schedule
    ETL_INTERVAL_HOURS=12

    # CORS (si aplica)
    CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080

Paso 5: Configurar Bases de Datos
----------------------------------

**Crear Base de Datos Analytics:**

.. code-block:: sql

    CREATE DATABASE iact_analytics CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER 'iact_user'@'localhost' IDENTIFIED BY 'your-password';
    GRANT ALL PRIVILEGES ON iact_analytics.* TO 'iact_user'@'localhost';
    FLUSH PRIVILEGES;

**Verificar acceso a Base de Datos IVR (solo lectura):**

.. code-block:: sql

    -- Verificar que el usuario ivr_readonly solo tenga permisos SELECT
    SHOW GRANTS FOR 'ivr_readonly'@'%';

Paso 6: Ejecutar Migraciones
-----------------------------

.. code-block:: bash

    python manage.py migrate --database=default

Paso 7: Crear Superusuario
---------------------------

.. code-block:: bash

    python manage.py createsuperuser

Paso 8: Cargar Datos Iniciales (Fixtures)
------------------------------------------

.. code-block:: bash

    # Cargar catálogos
    python manage.py loaddata fixtures/catalogos.json

    # Cargar funciones RBAC
    python manage.py loaddata fixtures/rbac_funciones.json

    # Cargar restricciones SoD
    python manage.py loaddata fixtures/rbac_sod.json

Paso 9: Verificar Instalación
------------------------------

.. code-block:: bash

    # Verificar configuración Django
    python manage.py check --deploy

    # Ejecutar tests
    pytest

    # Iniciar servidor de desarrollo
    python manage.py runserver

Acceder a: http://localhost:8000


Accesos y Permisos Requeridos
==============================

Repositorio de Código
----------------------

* **Acceso:** Requiere cuenta en el sistema de control de versiones interno
* **Permisos:** Lectura para todos los desarrolladores, escritura para el equipo core
* **Contacto:** [git-admin@empresa.com]

Base de Datos IVR (Solo Lectura)
---------------------------------

* **Acceso:** Usuario ``ivr_readonly`` con permisos SELECT únicamente
* **Host:** ivr-server.internal
* **Puerto:** 3306
* **Solicitar acceso a:** [dba@empresa.com]
* **Importante:** Nunca solicitar permisos de escritura en esta base de datos

Base de Datos Analytics
------------------------

* **Acceso:** Usuario con permisos completos
* **Host:** analytics-db.internal
* **Puerto:** 3306
* **Solicitar acceso a:** [dba@empresa.com]

VPN Corporativa
---------------

* **Requerido para:** Acceso a bases de datos internas desde fuera de la red corporativa
* **Software:** [Especificar cliente VPN utilizado]
* **Solicitar acceso a:** [it-support@empresa.com]

Sistemas Integrados
-------------------

* **Sistema PBX/IVR:** Acceso de solo lectura
* **CRM Externo:** API key proporcionada por el equipo de integración
* **Sistema de Envíos:** Endpoint y credenciales API


Configuración de Herramientas de Desarrollo
============================================

PyCharm / IDE
-------------

**Configurar intérprete de Python:**

1. File > Settings > Project > Python Interpreter
2. Seleccionar el intérprete del entorno virtual (``.venv/bin/python``)
3. Verificar que se carguen todas las dependencias

**Configurar Django:**

1. Languages & Frameworks > Django
2. Enable Django Support
3. Django project root: raíz del proyecto
4. Settings: ``config/settings.py`` (ajustar según estructura)
5. Manage script: ``manage.py``

**Configurar base de datos:**

1. Database tool window
2. Agregar conexiones MySQL/PostgreSQL
3. Probar conexión

VS Code
-------

**Extensiones recomendadas:**

* Python (Microsoft)
* Pylance
* Django (Baptiste Darthenay)
* GitLens
* Thunder Client (para pruebas de API)
* Better Comments
* Docker (si se usa)

**Configurar settings.json:**

.. code-block:: json

    {
        "python.defaultInterpreterPath": ".venv/bin/python",
        "python.linting.enabled": true,
        "python.linting.flake8Enabled": true,
        "python.formatting.provider": "black",
        "python.testing.pytestEnabled": true,
        "editor.formatOnSave": true
    }


Configuración de Docker (Opcional)
===================================

Si se utiliza Docker para desarrollo:

**Construir imágenes:**

.. code-block:: bash

    docker-compose build

**Iniciar servicios:**

.. code-block:: bash

    docker-compose up -d

**Ver logs:**

.. code-block:: bash

    docker-compose logs -f

**Ejecutar migraciones en contenedor:**

.. code-block:: bash

    docker-compose exec web python manage.py migrate

**Acceder al shell del contenedor:**

.. code-block:: bash

    docker-compose exec web bash


Verificación de la Instalación
===============================

Checklist de Verificación
--------------------------

Ejecutar los siguientes comandos para verificar que todo esté correctamente instalado:

.. code-block:: bash

    # 1. Verificar versión de Python
    python --version
    # Debe mostrar: Python 3.11.x

    # 2. Verificar entorno virtual activo
    which python
    # Debe apuntar a: .venv/bin/python

    # 3. Verificar instalación de Django
    python -m django --version
    # Debe mostrar: 4.x.x

    # 4. Verificar configuración Django
    python manage.py check
    # Debe mostrar: System check identified no issues

    # 5. Verificar conexión a base de datos
    python manage.py dbshell
    # Debe conectar a MySQL sin errores

    # 6. Ejecutar tests
    pytest
    # Todos los tests deben pasar

    # 7. Verificar servidor de desarrollo
    python manage.py runserver
    # Debe iniciar en http://127.0.0.1:8000/

Tests de Funcionalidad Básica
------------------------------

1. **Admin de Django:**
   - Acceder a: http://localhost:8000/admin
   - Login con superusuario creado
   - Verificar que cargue correctamente

2. **API REST:**
   - Acceder a: http://localhost:8000/api/
   - Verificar que muestre la documentación de la API

3. **Health Check:**
   - Acceder a: http://localhost:8000/health/
   - Debe retornar: ``{"status": "ok"}``


Solución de Problemas Comunes
==============================

Error: ModuleNotFoundError
---------------------------

**Problema:** No se encuentran módulos Python instalados

**Solución:**

.. code-block:: bash

    # Verificar que el entorno virtual esté activado
    which python

    # Reinstalar dependencias
    pip install -r requirements.txt

Error: MySQL Connection Refused
--------------------------------

**Problema:** No se puede conectar a MySQL

**Solución:**

1. Verificar que MySQL esté corriendo: ``sudo systemctl status mysql``
2. Verificar credenciales en ``.env``
3. Verificar que la base de datos exista
4. Probar conexión manual: ``mysql -u iact_user -p``

Error: Permission Denied (Base de Datos IVR)
---------------------------------------------

**Problema:** Acceso denegado a la base de datos IVR

**Solución:**

1. Verificar que se esté usando el usuario ``ivr_readonly``
2. Confirmar que solo se ejecutan operaciones SELECT
3. Contactar al DBA para verificar permisos

Error: Port Already in Use
---------------------------

**Problema:** El puerto 8000 ya está en uso

**Solución:**

.. code-block:: bash

    # Encontrar el proceso usando el puerto
    lsof -i :8000

    # Matar el proceso
    kill -9 [PID]

    # O usar otro puerto
    python manage.py runserver 8001

Error: SECRET_KEY not found
----------------------------

**Problema:** Variable SECRET_KEY no configurada

**Solución:**

1. Verificar que el archivo ``.env`` exista
2. Verificar que contenga ``SECRET_KEY=...``
3. Reiniciar el servidor después de modificar ``.env``


Configuración de Documentación
===============================

La documentación del proyecto usa Sphinx. Para trabajar con ella:

**Instalar dependencias de documentación:**

.. code-block:: bash

    cd docs/
    pip install -r requirements.txt

**Construir documentación HTML:**

.. code-block:: bash

    make html

**Ver documentación con live reload:**

.. code-block:: bash

    make livehtml

**Verificar enlaces:**

.. code-block:: bash

    make linkcheck


Recursos Adicionales
====================

Documentación Oficial
---------------------

* Django: https://docs.djangoproject.com/
* Django REST Framework: https://www.django-rest-framework.org/
* MySQL: https://dev.mysql.com/doc/
* Docker: https://docs.docker.com/

Recursos Internos
-----------------

* Wiki del proyecto: [URL de la wiki interna]
* Base de conocimiento: [URL de la KB]
* Sistema de tickets: [URL del sistema de tickets]
* Chat del equipo: [Canal de Slack/Teams]

Contacto
--------

Para soporte con la configuración del entorno:

* Equipo de desarrollo: [dev-iact@empresa.com]
* Soporte de infraestructura: [infra@empresa.com]
* Administración de bases de datos: [dba@empresa.com]
