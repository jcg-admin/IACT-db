PROCED-DEV-003: Resolver Conflictos de Merge
============================================

Objetivo
--------

Proporcionar guía paso a paso para resolver conflictos de merge de forma
segura y efectiva, manteniendo la integridad del código.

Alcance
-------

Este procedimiento cubre: - Identificación de conflictos - Estrategias
de resolución - Verificación post-resolución - Prevención de conflictos
futuros

NO cubre: - Merge de branches sin conflictos (automático) - Resolución
de conflictos en repositorio remoto - Rebase interactivo avanzado

Pre-requisitos
--------------

-  Git instalado y configurado
-  Editor de código configurado como merge tool
-  Conocimiento de la funcionalidad afectada
-  Tests disponibles para validar resolución

Roles y Responsabilidades
-------------------------

-  **Developer**: Resuelve conflictos en su branch
-  **Code Owner**: Consulta en caso de duda sobre código crítico
-  **Tech Lead**: Revisa resoluciones complejas

Procedimiento Detallado
-----------------------

PASO 1: Identificar Conflictos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.1 Escenario: Actualizar feature branch con main
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Asegurar estar en tu feature branch
   git checkout feature/user-authentication

   # Fetch latest changes from remote
   git fetch origin

   # Intentar merge de main
   git merge origin/main

**Escenario A: Sin conflictos** ✅

::

   Auto-merging src/auth/service.py
   Merge made by the 'recursive' strategy.
    3 files changed, 42 insertions(+), 12 deletions(-)

**Acción**: Continuar con desarrollo. No requiere este procedimiento.

--------------

**Escenario B: Con conflictos** ⚠️

::

   Auto-merging src/auth/service.py
   CONFLICT (content): Merge conflict in src/auth/service.py
   Auto-merging src/permissions/models.py
   CONFLICT (content): Merge conflict in src/permissions/models.py
   Automatic merge failed; fix conflicts and then commit the result.

**Acción**: Proceder con PASO 2.

--------------

1.2 Listar archivos en conflicto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Ver archivos en conflicto
   git status

   # Output:
   # On branch feature/user-authentication
   # You have unmerged paths.
   #   (fix conflicts and run "git commit")
                                           
   # Unmerged paths:
   #   (use "git add <file>..." to mark resolution)
   #        both modified:   src/auth/service.py
   #        both modified:   src/permissions/models.py

--------------

PASO 2: Entender el Conflicto
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

2.1 Examinar archivo con conflicto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Abrir archivo en editor
   code src/auth/service.py

**Marcadores de conflicto**:

.. code:: python

   def authenticate(username, password):
   <<<<<<< HEAD
       # Tu versión (feature branch)
       user = User.objects.get(username=username)
       if user.check_password_jwt(password):
           return generate_jwt_token(user)
       return None
                  
       # Versión de main
       user = User.objects.get(username=username)
       if user.check_password(password):
           return user
       return None
   >>>>>>> origin/main

**Componentes**: - ``<<<<<<< HEAD``: Inicio de tu versión - ``=======``:
Separador - ``>>>>>>> origin/main``: Fin de versión de main

--------------

2.2 Investigar contexto
^^^^^^^^^^^^^^^^^^^^^^^

**Revisar commits que causaron el conflicto**:

.. code:: bash

   # Ver qué cambió en tu branch
   git log HEAD..origin/main --oneline -- src/auth/service.py

   # Ver el diff específico
   git diff HEAD...origin/main -- src/auth/service.py

**Preguntas clave**: 1. ¿Qué intentaba hacer tu cambio? 2. ¿Qué
intentaba hacer el cambio en main? 3. ¿Son compatibles ambos cambios? 4.
¿Cuál es el comportamiento correcto esperado?

--------------

PASO 3: Estrategias de Resolución
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Estrategia 1: Aceptar tu versión
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Cuándo usar**: - Tu cambio es más reciente/correcto - Cambio en main
está obsoleto - Ya acordado con equipo

**Cómo**:

.. code:: bash

   # Usar tu versión completa
   git checkout --ours src/auth/service.py

   # Marcar como resuelto
   git add src/auth/service.py

--------------

Estrategia 2: Aceptar versión de main
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Cuándo usar**: - Cambio en main es fix crítico - Tu cambio será
refactorizado - Ya no necesitas tu cambio

**Cómo**:

.. code:: bash

   # Usar versión de main completa
   git checkout --theirs src/auth/service.py

   # Marcar como resuelto
   git add src/auth/service.py

--------------

Estrategia 3: Merge manual (RECOMENDADO)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Cuándo usar**: - Ambos cambios son necesarios - Necesitas combinar
lógica de ambos - Es el caso más común

**Cómo**:

1. **Abrir archivo en editor**

2. **Analizar ambas versiones**

.. code:: python

   <<<<<<< HEAD
   # TU versión: JWT authentication
   user = User.objects.get(username=username)
   if user.check_password_jwt(password):
       return generate_jwt_token(user)
   return None
              
   # Versión MAIN: Simple authentication
   user = User.objects.get(username=username)
   if user.check_password(password):
       return user
   return None
   >>>>>>> origin/main

3. **Decidir resolución correcta**

En este caso, TU cambio (JWT) es evolución del cambio en main. La
resolución correcta es mantener TU versión.

4. **Editar manualmente**

Eliminar marcadores de conflicto y dejar versión correcta:

.. code:: python

   def authenticate(username, password):
       user = User.objects.get(username=username)
       if user.check_password_jwt(password):
           return generate_jwt_token(user)
       return None

5. **Marcar como resuelto**

.. code:: bash

   git add src/auth/service.py

--------------

Estrategia 4: Merge híbrido (combinar ambos)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Ejemplo de conflicto**:

.. code:: python

   <<<<<<< HEAD
   # Tu versión: Agregar logging
   def authenticate(username, password):
       logger.info(f"Authentication attempt for user: {username}")
       user = User.objects.get(username=username)
       if user.check_password(password):
           return user
       return None
                  
   # Versión main: Agregar try/catch
   def authenticate(username, password):
       try:
           user = User.objects.get(username=username)
           if user.check_password(password):
               return user
           return None
       except User.DoesNotExist:
           return None
   >>>>>>> origin/main

**Resolución: Combinar AMBOS**:

.. code:: python

   def authenticate(username, password):
       logger.info(f"Authentication attempt for user: {username}")
       try:
           user = User.objects.get(username=username)
           if user.check_password(password):
               logger.info(f"Authentication successful for user: {username}")
               return user
           logger.warning(f"Authentication failed for user: {username}")
           return None
       except User.DoesNotExist:
           logger.error(f"User not found: {username}")
           return None

.. code:: bash

   git add src/auth/service.py

--------------

PASO 4: Usar Merge Tools
~~~~~~~~~~~~~~~~~~~~~~~~

4.1 Configurar merge tool
^^^^^^^^^^^^^^^^^^^^^^^^^

**VS Code**:

.. code:: bash

   git config --global merge.tool vscode
   git config --global mergetool.vscode.cmd 'code --wait $MERGED'

**Meld**:

.. code:: bash

   git config --global merge.tool meld

**P4Merge**:

.. code:: bash

   git config --global merge.tool p4merge

--------------

4.2 Ejecutar merge tool
^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   git mergetool src/auth/service.py

**Interface típica de merge tool**:

::

   ┌────────────────┬────────────────┬────────────────┐
   │  LOCAL         │  BASE          │  REMOTE        │
   │  (Tu versión)  │  (Ancestro)    │  (Main)        │
   ├────────────────┴────────────────┴────────────────┤
   │           MERGED (Resultado final)                │
   └───────────────────────────────────────────────────┘

-  **LOCAL**: Tu versión (HEAD)
-  **BASE**: Ancestro común (antes de cambios)
-  **REMOTE**: Versión de main
-  **MERGED**: Donde editas la resolución final

--------------

PASO 5: Verificar Resolución
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

5.1 Verificar que no quedan marcadores
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Buscar marcadores de conflicto restantes
   grep -r "<<<<<<< HEAD" src/
   grep -r "=======" src/
   grep -r ">>>>>>>" src/

   # Esperado: Sin resultados

--------------

5.2 Compilar/lint el código
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Python
   python -m py_compile src/auth/service.py
   flake8 src/auth/service.py

   # JavaScript
   npm run lint

   # TypeScript
   tsc --noEmit

**Criterio**: Sin errores de compilación/lint

--------------

5.3 Ejecutar tests
^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Tests del archivo modificado
   pytest tests/test_auth.py -v

   # O tests completos
   pytest

**Criterio**: Todos los tests pasan ✅

--------------

5.4 Review manual del diff
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Ver todos los cambios del merge
   git diff --cached

   # Revisar lógica línea por línea

**Checklist**: - [ ] Lógica tiene sentido - [ ] No se perdió
funcionalidad de ninguna versión - [ ] Estilo de código consistente - [
] No hay código duplicado - [ ] Imports necesarios incluidos

--------------

PASO 6: Completar el Merge
~~~~~~~~~~~~~~~~~~~~~~~~~~

6.1 Commit de resolución
^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Ver estado
   git status

   # Si todo está staged y resuelto
   git commit

   # Git abrirá editor con mensaje por defecto:
   # "Merge branch 'main' into feature/user-authentication"

**Mejorar mensaje de commit**:

::

   Merge branch 'main' into feature/user-authentication

   Conflictos resueltos en:
   - src/auth/service.py: Combinado JWT auth con error handling
   - src/permissions/models.py: Mantenido cambios de ambas versiones

   Tests verificados: ✅ All passing

--------------

6.2 Push del merge
^^^^^^^^^^^^^^^^^^

.. code:: bash

   git push origin feature/user-authentication

--------------

6.3 Notificar si es necesario
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si el conflicto fue complejo:

::

   🔄 Resolved merge conflicts in feature/user-authentication

   Files affected:
   - src/auth/service.py
   - src/permissions/models.py

   Resolution: Combined JWT authentication with error handling from main

   All tests passing ✅

--------------

PASO 7: Abortar Merge (Si es Necesario)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Si en cualquier momento necesitas cancelar:

.. code:: bash

   # Abortar merge y volver al estado anterior
   git merge --abort

   # Verificar que volviste al estado limpio
   git status

**Cuándo abortar**: - Conflictos demasiado complejos - Necesitas
consultar con equipo primero - Descubres que necesitas más cambios antes
de merge

--------------

Problemas Comunes y Soluciones
------------------------------

Problema 1: “Cannot merge binary files”
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Error**: Conflicto en archivo binario (imagen, PDF, etc.)

**Solución**:

.. code:: bash

   # Elegir una versión completa
   git checkout --ours path/to/binary/file  # Tu versión
   # O
   git checkout --theirs path/to/binary/file  # Versión de main

   git add path/to/binary/file

**Mejor práctica**: Evitar archivos binarios en git, usar Git LFS.

--------------

Problema 2: Conflictos en archivos generados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivos como**: - ``package-lock.json`` - ``poetry.lock`` - Build
artifacts

**Solución**:

.. code:: bash

   # Re-generar en lugar de resolver manualmente
   git checkout --theirs package-lock.json
   npm install  # Re-genera lock file
   git add package-lock.json

--------------

Problema 3: Muchos conflictos (>10 archivos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Solución**:

1. **Considerar rebase en lugar de merge**:

.. code:: bash

   git merge --abort
   git rebase origin/main
   # Resuelve conflictos commit por commit

2. **O dividir el trabajo**:

   -  Resolver archivos críticos primero
   -  Commit resolución parcial
   -  Continuar con resto

--------------

Problema 4: Perdí cambios al resolver
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Solución**:

.. code:: bash

   # Ver reflog para encontrar estado anterior
   git reflog

   # Volver a estado antes del merge
   git reset --hard HEAD@{1}

   # Re-intentar merge

--------------

Prevención de Conflictos
------------------------

Mejores Prácticas
~~~~~~~~~~~~~~~~~

1. **Sync frecuentemente**:

.. code:: bash

   # Al menos una vez al día
   git fetch origin
   git merge origin/main

2. **Feature branches pequeños**:

   -  Trabajar en PRs de < 500 líneas
   -  Merge rápido (< 3 días)

3. **Comunicación**:

   -  Avisar en equipo si vas a modificar archivos centrales
   -  Coordinar con otros developers en mismos archivos

4. **Atomic commits**:

   -  Un cambio lógico por commit
   -  Facilita resolución commit por commit con rebase

--------------

Herramientas Útiles
-------------------

Git Aliases
~~~~~~~~~~~

.. code:: bash

   # Agregar a ~/.gitconfig

   [alias]
       conflicts = diff --name-only --diff-filter=U
       resolve-ours = "!f() { git checkout --ours $1 && git add $1; }; f"
       resolve-theirs = "!f() { git checkout --theirs $1 && git add $1; }; f"

**Uso**:

.. code:: bash

   git conflicts  # Lista archivos en conflicto
   git resolve-ours src/auth/service.py  # Resolver con tu versión

--------------

Checklist de Resolución
-----------------------

.. code:: markdown

   Pre-Resolución:
   - [ ] Entiendo QUÉ causó el conflicto
   - [ ] Entiendo QUÉ hace cada versión
   - [ ] Sé cuál es el comportamiento correcto esperado

   Durante Resolución:
   - [ ] Todos los marcadores de conflicto eliminados
   - [ ] Código compila sin errores
   - [ ] Linters pasan
   - [ ] Lógica revisada manualmente

   Post-Resolución:
   - [ ] Tests ejecutados y pasando
   - [ ] Diff revisado
   - [ ] Commit message descriptivo
   - [ ] Push exitoso
   - [ ] Equipo notificado (si es complejo)

--------------

Referencias
-----------

-  `Git Documentation - Basic Merge
   Conflicts <https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging>`__
-  `PROC-DEV-001: Pipeline de Trabajo
   IACT <../procesos/PROC-DEV-001-pipeline_trabajo_iact.md>`__
-  `PROCED-DEV-001: Crear Pull
   Request <PROCED-DEV-001-crear_pull_request.md>`__

Historial de Cambios
--------------------

======= ========== =========== ===============
Versión Fecha      Autor       Cambios
======= ========== =========== ===============
1.0.0   2025-11-17 Claude Code Versión inicial
======= ========== =========== ===============

Aprobación
----------

-  **Autor**: Claude Code (Sonnet 4.5)
-  **Revisado por**: Pendiente
-  **Aprobado por**: Pendiente
-  **Fecha de próxima revisión**: 2026-02-17
