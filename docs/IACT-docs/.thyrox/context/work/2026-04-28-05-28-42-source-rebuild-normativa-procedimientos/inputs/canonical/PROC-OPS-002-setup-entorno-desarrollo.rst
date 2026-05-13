.. _proc-ops-002:

PROC-OPS-002: Setup del Entorno de Desarrollo
=============================================

:ID: PROC-OPS-002
:Versión: 1.0.0
:Fecha: 2026-04-28
:Estado: VIGENTE
:Clasificación: OPERATIVO
:Origen: WP source-references-audit
:Audiencia: Cualquier desarrollador o autor de docs que clona el repo

----

Propósito
---------

Documentar el procedimiento de instalación del entorno local para
construir la documentación IACT en cualquier sistema operativo
(Linux, macOS, Windows). El objetivo es que un autor nuevo pueda
clonar el repo y tener un build funcional en menos de 5 minutos.

----

Prerrequisitos por SO
---------------------

Linux (Ubuntu/Debian)
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Python 3.11+
   sudo apt-get install python3.11 python3-pip

   # uv (gestor de paquetes Python)
   pip install --user uv
   # o
   curl -LsSf https://astral.sh/uv/install.sh | sh

   # Java JRE (requerido por plantuml)
   sudo apt-get install default-jre-headless

   # libenchant (opcional — solo si se usa sphinx-spelling)
   sudo apt-get install libenchant-2-2

macOS
~~~~~

.. code-block:: bash

   # Homebrew
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

   # Python + uv
   brew install python@3.11
   brew install uv

   # Java
   brew install --cask temurin

   # Enchant
   brew install enchant

Windows
~~~~~~~

**Opción recomendada: PowerShell + winget.**

.. code-block:: powershell

   # PowerShell como Administrator (o usar winget directamente)

   # Git for Windows (incluye Git Bash)
   winget install --id Git.Git -e

   # Python 3.11
   winget install --id Python.Python.3.11 -e

   # uv (gestor Python)
   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

   # Java JRE (Eclipse Temurin)
   winget install --id EclipseAdoptium.Temurin.21.JRE -e

   # GNU make (opcional — si se quiere usar Makefile)
   winget install --id GnuWin32.Make -e

.. note::
   En Windows, ``libenchant`` no se instala fácilmente. Se puede
   omitir; ``sphinx-spelling`` no se ejecuta en el CI ni es requisito
   para construir la documentación.

----

Procedimiento de Setup
----------------------

Linux y macOS (script automático)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El script ``scripts/setup.sh`` es **idempotente**: ejecutarlo N veces
produce el mismo estado final.

.. code-block:: bash

   git clone https://github.com/jcg-admin/IACT-docs.git
   cd IACT-docs
   bash scripts/setup.sh

Pasos que realiza:

1. Verifica que ``uv`` está instalado.
2. Detecta libsystem ``enchant``; instala con apt/brew si falta (con
   sudo si es necesario).
3. Verifica Java (``java -version``); instala JRE portable Adoptium
   si falta y no hay package manager.
4. Descarga ``tools/plantuml.jar`` (~22 MB) si no existe o si el
   archivo previo está corrupto.
5. Ejecuta ``uv sync`` para instalar dependencias Python en
   ``.venv/``.
6. Activa los git hooks de ``.githooks/`` con
   ``git config core.hooksPath``.

Salida esperada:

.. code-block:: text

   ==> 1/6 Verificando uv (gestor Python)
       [OK] uv 0.8.17
   ==> 2/6 Verificando libsystem enchant
       [OK] enchant ya disponible
   ==> 3/6 Verificando Java JRE
       [OK] java en PATH
   ==> 4/6 Verificando plantuml.jar bundled
       [OK] plantuml.jar ya presente (22M)
   ==> 5/6 Sincronizando dependencias Python (uv sync)
       [OK] .venv/ sincronizado
   ==> 6/6 Activando git hooks
   OK: core.hooksPath = .githooks

Windows con Git Bash (script bash funciona)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Si tenés Git for Windows instalado, abrí Git Bash (no PowerShell) y
ejecutá:

.. code-block:: bash

   bash scripts/setup.sh

Comportamiento esperado:

- ``uv``, Java, ``plantuml.jar``, ``uv sync`` y hooks: ✓ funcionan
  igual que en Linux.
- ``enchant``: el script intenta detectar con ``ldconfig`` (que no
  existe en Windows) y registra WARN. **No bloquea** el setup —
  ``sphinx-spelling`` simplemente no estará disponible.

Windows con PowerShell (script .ps1 nativo)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Para ejecución 100% PowerShell sin dependencia de Git Bash:

.. code-block:: powershell

   # Permitir ejecución de scripts firmados (UNA vez, opcional)
   Set-ExecutionPolicy -Scope CurrentUser RemoteSigned

   # Ejecutar setup
   .\scripts\setup.ps1

El script ``setup.ps1`` es funcionalmente equivalente a ``setup.sh``
y también idempotente.

----

Construir la Documentación
--------------------------

Linux y macOS
~~~~~~~~~~~~~

.. code-block:: bash

   source .venv/bin/activate
   make html

   # O sin make:
   sphinx-build -b html source build/html

   # Build estricto (warnings = errores):
   sphinx-build -W -b html source build/html

Windows con Git Bash
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   source .venv/Scripts/activate    # OJO: Scripts (no bin)
   make html

Windows con PowerShell
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: powershell

   .\.venv\Scripts\Activate.ps1
   make html

   # Si no tenés make instalado:
   sphinx-build -b html source build\html

Verificar Output
~~~~~~~~~~~~~~~~

Después del build, abrir en el navegador:

- Linux/macOS: ``open build/html/index.html`` (macOS) o
  ``xdg-open build/html/index.html`` (Linux).
- Windows: ``start build\html\index.html`` (PowerShell o cmd).

----

Verificación de Idempotencia
----------------------------

Ejecutar ``setup.sh`` (o ``setup.ps1``) por segunda vez consecutiva
debe completarse en menos de **5 segundos**, sin descargar nada nuevo,
y reportar todos los pasos como ya satisfechos:

.. code-block:: text

   ==> 1/6 Verificando uv
       [OK] uv 0.8.17
   ==> 2/6 Verificando libsystem enchant
       [OK] enchant ya disponible
   ==> 3/6 Verificando Java JRE
       [OK] java en PATH
   ==> 4/6 Verificando plantuml.jar bundled
       [OK] plantuml.jar ya presente
   ==> 5/6 Sincronizando dependencias Python (uv sync)
       Audited 86 packages
       [OK] .venv/ sincronizado
   ==> 6/6 Activando git hooks
   OK: core.hooksPath = .githooks (sin cambios)

Si la segunda corrida tarda más de 5 segundos o vuelve a descargar
el ``plantuml.jar``, reportar como bug.

----

Resolución de Problemas Comunes
-------------------------------

"uv: command not found"
~~~~~~~~~~~~~~~~~~~~~~~

Reinstalar uv:

- Linux/macOS: ``curl -LsSf https://astral.sh/uv/install.sh | sh``
- Windows: ``powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"``

"java: command not found"
~~~~~~~~~~~~~~~~~~~~~~~~~

Instalar JRE 11+:

- Ubuntu/Debian: ``sudo apt-get install default-jre-headless``
- macOS: ``brew install --cask temurin``
- Windows: ``winget install --id EclipseAdoptium.Temurin.21.JRE -e``

Verificar con ``java -version``.

"sphinx-build: command not found"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Significa que el venv no está activado. Ejecutar:

- Linux/macOS: ``source .venv/bin/activate``
- Windows Git Bash: ``source .venv/Scripts/activate``
- Windows PowerShell: ``.\.venv\Scripts\Activate.ps1``

Verificar con ``which sphinx-build`` (Linux/macOS) o
``Get-Command sphinx-build`` (PowerShell).

"plantuml command failed"
~~~~~~~~~~~~~~~~~~~~~~~~~

Verificar que ``tools/plantuml.jar`` existe y tiene tamaño ~22 MB.
Si está corrupto o falta, ``setup.sh`` lo re-descarga automáticamente.

Para forzar re-descarga manual:

.. code-block:: bash

   rm tools/plantuml.jar
   bash scripts/setup.sh

"Encoding errors" (Windows con tildes/ñ en nombres)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sphinx puede fallar leyendo archivos cuyo path contiene caracteres
no-ASCII en Windows. Esto se debe al directorio ``diseño_detallado/``
(con ñ). El plan de cleanup contempla renombrar ese directorio.

Hasta entonces, configurar terminal a UTF-8:

.. code-block:: powershell

   chcp 65001
   $env:PYTHONIOENCODING = "utf-8"

----

Estructura del Proyecto Post-Setup
----------------------------------

Después de un setup exitoso, el repo debe verse así:

.. code-block:: text

   IACT-docs/
   ├── source/                ← documentación fuente .rst
   ├── build/html/            ← (generado por make html)
   ├── .venv/                 ← (creado por uv sync) — NO commitear
   ├── tools/
   │   ├── bin/plantuml       ← wrapper shell (committeado)
   │   └── plantuml.jar       ← descargado por setup — NO commitear
   ├── scripts/
   │   ├── setup.sh           ← bootstrap Linux/macOS/Git Bash
   │   ├── setup.ps1          ← bootstrap Windows PowerShell nativo
   │   ├── install-hooks.sh   ← sub-step (idempotente)
   │   └── validate-plantuml.sh
   ├── pyproject.toml         ← deps Python
   ├── uv.lock                ← lock file (committeado)
   ├── Makefile               ← targets de Sphinx
   └── readme.rst

Los siguientes ya están en ``.gitignore``:

- ``.venv/``
- ``build/``
- ``tools/plantuml.jar``
- ``tools/jre/``

----

Referencias
-----------

- :ref:`proc-ops-001` — Despliegue de Documentación a Producción
  (siguiente paso: cómo descargar el release y subirlo al servidor).
- :ref:`std-007` — Convención de Naming de Archivos y Carpetas
  (para autores que crean nuevos ``.rst``).
- :ref:`std-006` — Versionado Semántico (cómo versionar los archivos
  que se editan).

----

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 12 12 76

   * - Versión
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-04-28
     - Versión inicial. Cubre setup en Linux, macOS y Windows
       (Git Bash y PowerShell nativo). Incluye prerrequisitos,
       procedimiento idempotente, troubleshooting de problemas
       comunes y verificación post-setup.
