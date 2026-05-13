Procedimiento: Instalación de Entorno de Desarrollo
===================================================

Propósito
---------

Guía paso a paso para la instalación inicial del entorno de desarrollo
del proyecto IACT.

Alcance
-------

Este procedimiento es para nuevos desarrolladores que se incorporan al
proyecto.

Pre-requisitos
--------------

-  Sistema operativo: Windows 10+, macOS 11+, o Linux (Ubuntu 20.04+)
-  Mínimo 8GB RAM
-  20GB espacio en disco
-  Conexión a internet
-  Acceso al repositorio GitHub

Procedimiento
-------------

1. Instalaciones Básicas
~~~~~~~~~~~~~~~~~~~~~~~~

1.1 Git
^^^^^^^

**Windows:**

.. code:: bash

   # Descargar desde
   https://git-scm.com/download/win

   # O con chocolatey
   choco install git

**macOS:**

.. code:: bash

   brew install git

**Linux:**

.. code:: bash

   sudo apt-get update
   sudo apt-get install git

1.2 Python 3.11+
^^^^^^^^^^^^^^^^

**Windows:**

.. code:: bash

   # Descargar desde
   https://www.python.org/downloads/

   # O con chocolatey
   choco install python --version=3.11

**macOS:**

.. code:: bash

   brew install python@3.11

**Linux:**

.. code:: bash

   sudo apt-get install python3.11 python3.11-venv python3-pip

1.3 Vagrant
^^^^^^^^^^^

**Windows:**

.. code:: bash

   # Descargar desde
   https://www.vagrantup.com/downloads

   # O con chocolatey
   choco install vagrant

**macOS:**

.. code:: bash

   brew install --cask vagrant

**Linux:**

.. code:: bash

   wget https://releases.hashicorp.com/vagrant/2.3.7/vagrant_2.3.7-1_amd64.deb
   sudo dpkg -i vagrant_2.3.7-1_amd64.deb

1.4 VirtualBox
^^^^^^^^^^^^^^

**Windows:**

.. code:: bash

   choco install virtualbox

**macOS:**

.. code:: bash

   brew install --cask virtualbox

**Linux:**

.. code:: bash

   sudo apt-get install virtualbox

2. Configuración de Git
~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Configurar identidad
   git config --global user.name "Tu Nombre"
   git config --global user.email "tu.email@ejemplo.com"

   # Configurar editor
   git config --global core.editor "code --wait"  # VS Code
   # o
   git config --global core.editor "vim"

   # Configurar line endings
   git config --global core.autocrlf input  # Linux/Mac
   git config --global core.autocrlf true   # Windows

   # Verificar configuración
   git config --list

3. Configuración de SSH para GitHub
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Generar clave SSH
   ssh-keygen -t ed25519 -C "tu.email@ejemplo.com"

   # Iniciar ssh-agent
   eval "$(ssh-agent -s)"

   # Agregar clave
   ssh-add ~/.ssh/id_ed25519

   # Copiar clave pública
   cat ~/.ssh/id_ed25519.pub
   # O en Windows
   type %USERPROFILE%\.ssh\id_ed25519.pub

   # Agregar en GitHub: Settings > SSH and GPG keys > New SSH key

4. Instalar gh CLI (Opcional pero Recomendado)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Windows:**

.. code:: bash

   choco install gh

**macOS:**

.. code:: bash

   brew install gh

**Linux:**

.. code:: bash

   curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
   sudo apt update
   sudo apt install gh

Autenticar:

.. code:: bash

   gh auth login

5. Clonar Repositorio
~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Usando SSH (recomendado)
   git clone git@github.com:2-Coatl/IACT---project.git
   cd IACT---project

   # O usando HTTPS
   git clone https://github.com/2-Coatl/IACT---project.git
   cd IACT---project

6. Configurar Vagrant
~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Iniciar VM (primera vez - puede tomar 10-15 minutos)
   vagrant up

   # Conectar a la VM
   vagrant ssh

   # Dentro de la VM, verificar
   python3 --version
   cd /vagrant/api
   ls -la

7. Configurar Entorno Python (Dentro de VM)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ya debería estar creado, pero si no:
   cd /vagrant/api
   python3 -m venv venv
   source venv/bin/activate

   # Instalar dependencias
   pip install --upgrade pip
   pip install -r requirements/dev.txt
   pip install -r requirements/test.txt

8. Configurar Base de Datos
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Dentro de VM, con venv activado
   cd /vagrant/api

   # Aplicar migraciones
   python manage.py migrate

   # Crear superusuario
   python manage.py createsuperuser

   # Cargar datos iniciales (opcional)
   python manage.py loaddata fixtures/initial_data.json

9. Verificar Instalación
~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Tests
   pytest

   # Iniciar servidor
   python manage.py runserver 0.0.0.0:8000

   # En tu navegador local:
   # http://localhost:8080 (port forwarding de Vagrant)

10. IDE Setup (VS Code Recomendado)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

10.1 Instalar VS Code
^^^^^^^^^^^^^^^^^^^^^

Descargar desde: https://code.visualstudio.com/

10.2 Extensiones Recomendadas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Instalar extensiones desde CLI
   code --install-extension ms-python.python
   code --install-extension ms-python.vscode-pylance
   code --install-extension ms-python.black-formatter
   code --install-extension bungcip.better-toml
   code --install-extension eamodio.gitlens
   code --install-extension GitHub.copilot  # si tienes licencia

O instalar desde UI: - Python - Pylance - Black Formatter - GitLens -
Django (batisteo.vscode-django)

10.3 Configurar Workspace
^^^^^^^^^^^^^^^^^^^^^^^^^

Abrir carpeta del proyecto en VS Code:

.. code:: bash

   code /ruta/a/IACT---project

VS Code debería detectar ``.vscode/settings.json`` automáticamente.

Troubleshooting
---------------

Vagrant up falla
~~~~~~~~~~~~~~~~

.. code:: bash

   # Verificar VirtualBox
   vboxmanage --version

   # Ver logs detallados
   vagrant up --debug

   # Destruir y recrear
   vagrant destroy -f
   vagrant up

Python no encontrado en VM
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Dentro de VM
   which python3
   sudo apt-get update
   sudo apt-get install python3.11

Migraciones fallan
~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Verificar conexión a DB
   python manage.py check --database default

   # Ver estado de migraciones
   python manage.py showmigrations

   # Fake si es necesario (cuidado)
   python manage.py migrate --fake-initial

Tests fallan
~~~~~~~~~~~~

.. code:: bash

   # Reinstalar dependencias
   pip install -r requirements/test.txt --force-reinstall

   # Limpiar cache
   pytest --cache-clear
   rm -rf .pytest_cache

Checklist de Verificación
-------------------------

-  ☐ Git instalado y configurado
-  ☐ Python 3.11+ instalado
-  ☐ Vagrant y VirtualBox instalados
-  ☐ SSH configurado para GitHub
-  ☐ Repositorio clonado
-  ☐ VM de Vagrant funcionando
-  ☐ Dependencias Python instaladas
-  ☐ Migraciones aplicadas
-  ☐ Tests pasan
-  ☐ Servidor Django arranca
-  ☐ VS Code configurado
-  ☐ Acceso a documentación

Recursos Relacionados
---------------------

-  `ADR_2025_001: Vagrant +
   mod_wsgi <../arquitectura/adr/ADR_2025_001-vagrant-mod-wsgi.md>`__
-  `Procedimiento: Desarrollo
   Local <procedimiento_desarrollo_local.md>`__
-  `DevContainers (futuro) <../devops/contenedores_devcontainer.md>`__

Tiempo Estimado
---------------

-  Instalaciones: 30-45 minutos
-  Configuración: 15-20 minutos
-  Primera VM up: 10-15 minutos
-  **Total: 1-1.5 horas**

Soporte
-------

Si encuentras problemas: 1. Revisar logs detalladamente 2. Buscar en
issues del repo 3. Preguntar en canal de desarrollo 4. Crear issue con
detalles completos

Changelog
---------

-  2025-11-04: Creación inicial del procedimiento
