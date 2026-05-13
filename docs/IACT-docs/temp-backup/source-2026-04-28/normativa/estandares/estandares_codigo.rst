Estándares de Código - Proyecto IACT
====================================

Este documento define los estándares de código que DEBEN seguirse en
todo el proyecto IACT para garantizar calidad, mantenibilidad y
profesionalismo.

Página padre
------------

-  `Gobernanza <readme.md>`__

Alcance
-------

Estos estándares aplican a: - Scripts de infraestructura (Bash,
PowerShell) - Código de aplicación (Python, JavaScript/TypeScript) -
Scripts de automatización y DevOps - Configuraciones de CI/CD -
Documentación técnica (cuando incluya código)

Documentación Relacionada
-------------------------

**Para scripts de shell**, consultar también: - `Shell Scripting Guide
Completa <shell_scripting_guide.md>`__ - Guía exhaustiva de shell
scripting - `Plantillas de
Scripts <../../scripts/templates/README.md>`__ - Templates
estandarizados

Tabla de Contenidos
-------------------

1. `Regla Fundamental: Output
   Profesional <#regla-fundamental-output-profesional>`__
2. `Estándares de Python <#estándares-de-python>`__
3. `Estándares de Scripts de Shell <#estándares-de-scripts-de-shell>`__
4. `Estándares de PowerShell <#estándares-de-powershell>`__
5. `Validación y Control de
   Calidad <#validación-y-control-de-calidad>`__

--------------

Regla Fundamental: Output Profesional
-------------------------------------

Principio Fundamental
~~~~~~~~~~~~~~~~~~~~~

**NUNCA usar emojis, iconos Unicode decorativos, ni símbolos especiales
en el output de scripts de producción.**

Justificación
~~~~~~~~~~~~~

1. **Compatibilidad**: Emojis y caracteres especiales pueden no
   renderizarse correctamente en:

   -  Terminales legacy
   -  Sistemas Windows con codificación antigua
   -  Logs de CI/CD
   -  Archivos de log
   -  Monitores de sistema

2. **Profesionalismo**: Los scripts de producción deben ser
   profesionales y corporativos

3. **Parsing**: Logs con emojis son difíciles de parsear con
   herramientas estándar (grep, awk, sed)

4. **Accesibilidad**: Screen readers tienen problemas con emojis

5. **Codificación**: Problemas con UTF-8/ASCII en diferentes sistemas

NO PROHIBIDO
~~~~~~~~~~~~

Emojis
^^^^^^

.. code:: bash

   # NO NO HACER ESTO
   echo "OK Completado"
   echo "NO Error"
   echo "WARNING Advertencia"
   echo "START Iniciando"
   echo "FILE Procesando archivos"
   echo "SAVE Guardando datos"
   echo "BUSCAR Buscando"
   echo "ESPERANDO Esperando"
   echo "NUEVO Nuevo"
   echo "EXITO Éxito"

.. code:: python

   # NO NO HACER ESTO
   print("OK Test passed")
   print("NO Test failed")
   logger.info("BUSCAR Searching for files")

.. code:: powershell

   # NO NO HACER ESTO
   Write-Host "OK Completado"
   Write-Host "NO Error"
   Write-Host "WARNING Advertencia"

Iconos Unicode
^^^^^^^^^^^^^^

.. code:: bash

   # NO NO HACER ESTO
   echo "> Ejecutando"
   echo "- Item"
   echo "-> Siguiente paso"
   echo "* Importante"
   echo "♦ Nota"
   echo "■ Opción"
   echo "> Paso"
   echo "» Info"

Box Drawing Characters
^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # NO NO HACER ESTO
   echo "╔════════════╗"
   echo "║   Título   ║"
   echo "╚════════════╝"
   echo "┌──────────┐"
   echo "│  Caja    │"
   echo "└──────────┘"

OK USAR EN SU LUGAR
~~~~~~~~~~~~~~~~~~~

Sistema de Prefijos Estándar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # OK HACER ESTO
   echo "[INFO]    Información general"
   echo "[DEBUG]   Detalles de depuración"
   echo "[WARN]    Advertencia"
   echo "[ERROR]   Error encontrado"
   echo "[FATAL]   Error crítico"
   echo "[SUCCESS] Operación exitosa"
   echo "[OK]      Todo bien"
   echo "[FAIL]    Operación falló"

.. code:: python

   # OK HACER ESTO
   logger.info("[INFO] Processing started")
   logger.warning("[WARN] Configuration file not found")
   logger.error("[ERROR] Database connection failed")
   print("[SUCCESS] Migration completed")

.. code:: powershell

   # OK HACER ESTO
   Write-Host "[INFO]    Información general"
   Write-Host "[DEBUG]   Detalles de depuración"
   Write-Host "[WARN]    Advertencia"
   Write-Host "[ERROR]   Error encontrado"
   Write-Host "[SUCCESS] Operación exitosa"

Estados de Proceso
^^^^^^^^^^^^^^^^^^

.. code:: bash

   # OK HACER ESTO
   echo "[PENDING]  Operación pendiente"
   echo "[RUNNING]  En ejecución"
   echo "[DONE]     Completado"
   echo "[SKIPPED]  Omitido"
   echo "[RETRY]    Reintentando"
   echo "[TIMEOUT]  Tiempo de espera agotado"

Viñetas y Listas
^^^^^^^^^^^^^^^^

.. code:: bash

   # OK HACER ESTO - Viñetas
   echo "Options:"
   echo "  - Option 1"
   echo "  - Option 2"
   echo "  * Alternative A"
   echo "  * Alternative B"

   # OK HACER ESTO - Numeradas
   echo "Steps:"
   echo "  1. First step"
   echo "  2. Second step"
   echo "  3. Third step"

Separadores
^^^^^^^^^^^

.. code:: bash

   # OK HACER ESTO
   echo ""
   echo "------------------------------------------------------------"
   echo "============================================================"
   echo "____________________________________________________________"
   echo ""

   # O con código
   separator_line=$(printf '=%.0s' {1..60})
   echo "$separator_line"

Tabla de Referencia Rápida
~~~~~~~~~~~~~~~~~~~~~~~~~~

=============== =============== =======================
Concepto        NO No Usar      OK Usar
=============== =============== =======================
**Completado**  OK [OK] ☑       [OK] [SUCCESS] [DONE]
**Error**       NO [FAIL] ☒     [ERROR] [FAIL] [FAILED]
**Advertencia** WARNING FAST ⛔ [WARN] [WARNING]
**Información** INFO 📢         [INFO] [NOTE]
**Depuración**  [BUG] BUSCAR    [DEBUG]
**En proceso**  ESPERANDO 🔄 ⌛ [RUNNING] [PROCESSING]
**Esperando**   ⏰ ⏱️           [PENDING] [WAITING]
**Inicio**      START >️         [START] Starting…
**Fin**         🏁 ⏹️           [STOP] [END] Finished
**Archivo**     FILE FILE SAVE  FILE: file.txt
**Carpeta**     📂 🗂️           DIRECTORY: /path/
**Red**         🌐 📡           [NETWORK]
**Usuario**     👤 👥           USER: username
**Tiempo**      ⏰ 🕐           TIME: 10:30
**Fecha**       📅 PLAN         DATE: 2025-10-21
**Viñetas**     > - \* ♦        - \* 1. 2.
**Flechas**     -> ⇒ ➜ ➔        -> =>
**Check**       ☑ [OK] ✔        [OK] PASS
**Cross**       ☒ [FAIL] ✘      [FAIL] ERROR
=============== =============== =======================

Excepciones
~~~~~~~~~~~

La única excepción a esta regla es:

-  **Documentación de usuario final** (README.md, guías de usuario)
-  **Comentarios de código** (pueden usar emojis para claridad durante
   desarrollo)
-  **Commits de git** (permitido pero no recomendado)

**NUNCA en:** - Scripts de producción - Logs de aplicación - Output de
CI/CD - Scripts de automatización - Mensajes de error de sistema

--------------

Estándares de Python
--------------------

Estilo General
~~~~~~~~~~~~~~

-  **PEP 8**: Seguir PEP 8 estrictamente
-  **Formateador**: Black (line length: 88)
-  **Linter**: Flake8 + Pylint
-  **Type hints**: Obligatorios para funciones públicas
-  **Docstrings**: Formato Google o NumPy, en español

Ejemplo
~~~~~~~

.. code:: python

   from typing import List, Optional


   def calcular_aht(llamadas: List[dict]) -> float:
                                                   
       Calcula el Average Handling Time de una lista de llamadas.

       Args:
           llamadas: Lista de diccionarios con información de llamadas.
                     Cada llamada debe tener la clave 'duration'.

       Returns:
           Promedio de duración de las llamadas en segundos.
           Retorna 0.0 si la lista está vacía.

       Raises:
           KeyError: Si alguna llamada no tiene la clave 'duration'.
           TypeError: Si la duración no es numérica.

       Example:
           >>> calls = [{'duration': 100}, {'duration': 200}]
           >>> calcular_aht(calls)
           150.0
                
       if not llamadas:
           return 0.0

       total_duration = sum(call["duration"] for call in llamadas)
       return total_duration / len(llamadas)

Logging en Python
~~~~~~~~~~~~~~~~~

.. code:: python

   import logging

   # OK HACER ESTO
   logger = logging.getLogger(__name__)

   logger.info("[INFO] Processing started")
   logger.debug("[DEBUG] Variable value: %s", value)
   logger.warning("[WARN] Deprecated function called")
   logger.error("[ERROR] Database connection failed: %s", error)
   logger.critical("[FATAL] System shutdown initiated")

   # NO NO HACER ESTO
   logger.info("START Processing started")
   logger.error("NO Database connection failed")

--------------

Estándares de Scripts de Shell
------------------------------

**IMPORTANTE**: Para desarrollo avanzado de shell scripts, consultar la
`Shell Scripting Guide Completa <shell_scripting_guide.md>`__ que
incluye: - Criterios de decisión para ubicación de scripts - Selección
de shell (POSIX vs bash) - Manejo avanzado de errores y seguridad -
Organización de código modular - Requerimientos de testing - Plantillas
completas

Plantillas Disponibles
~~~~~~~~~~~~~~~~~~~~~~

El proyecto proporciona plantillas estandarizadas en
``scripts/templates/``: - ``bash-script-template.sh`` - Para scripts
complejos con características bash - ``posix-script-template.sh`` - Para
máxima portabilidad - ``library-template.sh`` - Para bibliotecas de
funciones reutilizables

Ver: `Scripts Templates README <../../scripts/templates/README.md>`__

Ejemplo Mínimo (Bash)
~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   #!/usr/bin/env bash
                                       
   # script_name.sh - Descripción breve
                                                   
   # Descripción detallada de lo que hace el script
                                                   
   # Usage:
   #   ./script_name.sh [options]
                                 
   # Options:
   #   -h, --help     Show this help message
   #   -v, --verbose  Enable verbose output
                                           

   set -euo pipefail

   # Constantes en mayúsculas
   readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   readonly LOG_FILE="/var/log/script.log"

   # Funciones con nombres descriptivos
   log_info() {
       echo "[INFO] $*" | tee -a "$LOG_FILE"
   }

   log_error() {
       echo "[ERROR] $*" >&2 | tee -a "$LOG_FILE"
   }

   main() {
       log_info "Script started"

       # Lógica principal aquí

       log_info "[SUCCESS] Script completed"
   }

   # Ejecutar main
   main "$@"

**Nota**: Este es un ejemplo mínimo. Para scripts de producción, usar
las plantillas completas en ``scripts/templates/``.

--------------

Estándares de PowerShell
------------------------

PowerShell Scripts
~~~~~~~~~~~~~~~~~~

.. code:: powershell

   <#
   .SYNOPSIS
       Descripción breve del script

   .DESCRIPTION
       Descripción detallada de lo que hace el script

   .PARAMETER Name
       Descripción del parámetro

   .EXAMPLE
       .\script.ps1 -Name "value"

   .NOTES
       Author: Team Name
       Date: 2025-11-02
   #>

   [CmdletBinding()]
   param(
       [Parameter(Mandatory=$true)]
       [string]$Name
   )

   # Strict mode
   Set-StrictMode -Version Latest
   $ErrorActionPreference = "Stop"

   function Write-InfoLog {
       param([string]$Message)
       Write-Host "[INFO] $Message" -ForegroundColor White
   }

   function Write-ErrorLog {
       param([string]$Message)
       Write-Host "[ERROR] $Message" -ForegroundColor Red
   }

   function Write-SuccessLog {
       param([string]$Message)
       Write-Host "[SUCCESS] $Message" -ForegroundColor Green
   }

   # Main logic
   try {
       Write-InfoLog "Script started"

       # Tu código aquí

       Write-SuccessLog "Script completed"
   }
   catch {
       Write-ErrorLog "Script failed: $_"
       exit 1
   }

--------------

Validación y Control de Calidad
-------------------------------

Pre-commit Hooks
~~~~~~~~~~~~~~~~

Configurar pre-commit hooks para validar automáticamente:

.. code:: yaml

   # .pre-commit-config.yaml
   repos:
     - repo: https://github.com/psf/black
       rev: 23.3.0
       hooks:
         - id: black
           language_version: python3.11

     - repo: https://github.com/PyCQA/flake8
       rev: 6.0.0
       hooks:
         - id: flake8
           args: [--max-line-length=88]

     - repo: local
       hooks:
         - id: no-emojis-in-scripts
           name: No emojis in production scripts
           entry: scripts/check_no_emojis.sh
           language: script
           files: \.(py|sh|ps1)$

Script de Validación
~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   #!/usr/bin/env bash
   # scripts/check_no_emojis.sh
   # Verifica que no haya emojis en scripts de producción

   files="$@"
   found_emojis=0

   # Lista de emojis comunes a detectar
   emoji_pattern='[OKNOWARNINGSTARTFILESAVEBUSCARESPERANDONUEVOEXITO>-->*♦■>»╔═╗║╚╝┌─┐│└┘]'

   for file in $files; do
       # Saltar archivos de documentación
       if [[ "$file" == *README.md ]] || [[ "$file" == docs/* ]]; then
           continue
       fi

       if grep -Pq "$emoji_pattern" "$file"; then
           echo "[ERROR] Emojis found in: $file"
           grep -Pn "$emoji_pattern" "$file"
           found_emojis=1
       fi
   done

   if [ $found_emojis -eq 1 ]; then
       echo ""
       echo "[FAIL] Emoji validation failed"
       echo "Remove emojis from production scripts"
       echo "See: docs/gobernanza/estandares_codigo.md"
       exit 1
   fi

   echo "[OK] No emojis found in scripts"
   exit 0

Checklist de Code Review
~~~~~~~~~~~~~~~~~~~~~~~~

Al revisar código, verificar:

-  ☐ No hay emojis en output de scripts
-  ☐ Se usan prefijos estándar ([INFO], [ERROR], etc.)
-  ☐ Logs son parseables con herramientas estándar
-  ☐ Separadores usan caracteres ASCII estándar
-  ☐ Type hints en funciones públicas (Python)
-  ☐ Docstrings presentes y en español
-  ☐ Tests tienen cobertura mínima 80%
-  ☐ Linters pasan sin errores

--------------

Enforcement
-----------

Automatización
~~~~~~~~~~~~~~

1. **Pre-commit hooks**: Bloquean commits con emojis
2. **CI/CD checks**: Fallan el build si detectan emojis
3. **Code review**: Revisores deben validar cumplimiento

Responsabilidades
~~~~~~~~~~~~~~~~~

-  **Desarrolladores**: Seguir estándares en todo momento
-  **Tech Leads**: Revisar y aprobar PRs verificando cumplimiento
-  **DevOps**: Mantener herramientas de validación actualizadas

.. _excepciones-1:

Excepciones
~~~~~~~~~~~

Cualquier excepción a estos estándares debe: 1. Ser documentada en el
código con comentario ``# EXCEPTION:`` 2. Tener justificación técnica
válida 3. Ser aprobada por Tech Lead 4. Ser temporal con fecha de
resolución

--------------

Referencias
-----------

-  `PEP 8 - Style Guide for Python
   Code <https://peps.python.org/pep-0008/>`__
-  `Black Code Formatter <https://black.readthedocs.io/>`__
-  `Google Shell Style
   Guide <https://google.github.io/styleguide/shellguide.html>`__
-  `PowerShell Best
   Practices <https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/strongly-encouraged-development-guidelines>`__

--------------

Changelog
---------

-  **2025-11-02**: Creación inicial

   -  Agregar regla fundamental sobre emojis
   -  Definir estándares de Python, Bash, PowerShell
   -  Incluir script de validación y pre-commit hooks
