PROCED-DEV-001: Crear Pull Request
==================================

Objetivo
--------

Proporcionar pasos específicos para crear un Pull Request (PR)
correctamente siguiendo los estándares del proyecto IACT.

Alcance
-------

Este procedimiento cubre: - Preparación de cambios locales - Creación de
branch - Commits con mensajes estándar - Push a remoto - Creación de PR
con template

NO cubre: - Code review (ver PROCED-DEV-002) - Resolución de conflictos
complejos - Estrategias de merge

Pre-requisitos
--------------

-  Git instalado y configurado
-  Repositorio clonado localmente
-  Permisos de escritura en el repositorio
-  Branch principal actualizado

Roles y Responsabilidades
-------------------------

-  **Developer**: Ejecuta todos los pasos
-  **Tech Lead**: Revisa conformidad con estándares

Procedimiento Detallado
-----------------------

PASO 1: Actualizar Branch Principal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Cambiar a branch principal
   git checkout main  # o master según configuración

   # Obtener últimos cambios
   git pull origin main

**Criterio de éxito**: ``Already up to date`` o cambios descargados sin
conflictos

--------------

PASO 2: Crear Feature Branch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Patrón de nomenclatura**: ``tipo/descripcion-corta-kebab-case``

**Tipos válidos**: - ``feature/`` - Nueva funcionalidad - ``fix/`` -
Corrección de bug - ``refactor/`` - Refactorización sin cambio funcional
- ``docs/`` - Solo cambios en documentación - ``test/`` - Agregar o
mejorar tests - ``chore/`` - Tareas de mantenimiento

.. code:: bash

   # Ejemplo: Nueva funcionalidad de autenticación
   git checkout -b feature/user-authentication

   # Ejemplo: Corrección de bug en permisos
   git checkout -b fix/permission-validation

**Criterio de éxito**: Mensaje
``Switched to a new branch 'feature/...'``

--------------

PASO 3: Realizar Cambios y Commits
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

3.1 Hacer cambios en el código
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Trabajar normalmente en los archivos necesarios.

3.2 Verificar estado
^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   git status

3.3 Agregar archivos al staging
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Agregar archivos específicos
   git add ruta/al/archivo.py

   # O agregar todos los cambios (con precaución)
   git add .

3.4 Crear commit con mensaje estándar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Patrón de mensaje**: ``tipo(alcance): descripción``

.. code:: bash

   git commit -m "$(cat <<'EOF'
   feat(auth): implementar autenticación JWT

   - Agregar endpoint /api/auth/login
   - Crear middleware de validación de token
   - Implementar refresh token mechanism
   - Agregar tests unitarios para auth service

   Relacionado: TASK-042, ADR-BACK-006
   EOF
   )"

**Tipos de commit válidos**: - ``feat``: Nueva funcionalidad - ``fix``:
Corrección de bug - ``refactor``: Refactorización - ``docs``:
Documentación - ``test``: Tests - ``chore``: Mantenimiento - ``style``:
Formateo (no cambia lógica) - ``perf``: Mejoras de performance

**Criterio de éxito**: Commit creado con hash SHA

--------------

PASO 4: Push a Remoto
~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Primera vez (crear branch remoto)
   git push -u origin feature/user-authentication

   # Pushes subsecuentes
   git push

**Criterio de éxito**: Mensaje
``Branch 'feature/...' set up to track remote branch``

--------------

PASO 5: Crear Pull Request en GitHub
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

5.1 Abrir navegador
^^^^^^^^^^^^^^^^^^^

Ir a la URL del repositorio en GitHub.

5.2 Click en “Compare & pull request”
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

GitHub automáticamente detecta el nuevo branch y muestra banner
amarillo.

5.3 Completar formulario de PR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Título**: Usar mismo formato que commit principal

::

   feat(auth): implementar autenticación JWT

**Descripción**: Usar template del proyecto

.. code:: markdown

   ## Resumen

   Implementación de sistema de autenticación basado en JWT para endpoints de API.

   ## Cambios Principales

   - Endpoint `/api/auth/login` para autenticación
   - Middleware `AuthenticationMiddleware` para validar tokens
   - Sistema de refresh tokens con expiración de 7 días
   - Tests de integración para flujo completo de auth

   ## Tipo de Cambio

   - [x] Nueva funcionalidad (feature)
   - [ ] Corrección de bug (fix)
   - [ ] Cambio que rompe compatibilidad (breaking change)
   - [ ] Documentación

   ## Test Plan

   1. Ejecutar `pytest tests/auth/`
   2. Verificar login exitoso con credenciales válidas
   3. Verificar rechazo con credenciales inválidas
   4. Verificar refresh token mechanism
   5. Verificar middleware protege endpoints

   ## Checklist

   - [x] Mi código sigue el estilo del proyecto
   - [x] He realizado self-review
   - [x] He comentado código complejo
   - [x] He actualizado documentación
   - [x] Mis cambios no generan warnings
   - [x] He agregado tests que prueban mi fix/feature
   - [x] Tests nuevos y existentes pasan localmente
   - [x] Coverage de tests >= 80%

   ## Relacionado

   - Relacionado: TASK-042-jwt-authentication
   - Implementa: ADR-BACK-006-jwt-auth-strategy
   - Documenta: GUIA-BACK-003-authentication-guide

   ## Screenshots/Evidencia

   (Incluir si aplica)

5.4 Asignar reviewers
^^^^^^^^^^^^^^^^^^^^^

**Mínimo**: 2 reviewers - 1 del mismo equipo/dominio - 1 de diferente
perspectiva (opcional pero recomendado)

5.5 Agregar labels
^^^^^^^^^^^^^^^^^^

Ejemplos: - ``feature``, ``bug``, ``documentation`` - ``backend``,
``frontend``, ``devops`` - ``high-priority``, ``low-priority``

5.6 Vincular issues
^^^^^^^^^^^^^^^^^^^

Si existe issue relacionado: “Closes #123” en la descripción

--------------

PASO 6: Verificaciones Post-Creación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

6.1 Verificar CI/CD
^^^^^^^^^^^^^^^^^^^

Esperar que checks pasen: - ✅ Tests unitarios - ✅ Linters - ✅
Coverage - ✅ Build exitoso

6.2 Revisar diff
^^^^^^^^^^^^^^^^

Verificar que SOLO están los cambios intencionales.

6.3 Notificar reviewers
^^^^^^^^^^^^^^^^^^^^^^^

Opcional: Enviar mensaje en Slack/Teams notificando el PR.

--------------

Criterios de Éxito Global
-------------------------

-  ✅ PR creado y visible en GitHub
-  ✅ Todos los checks de CI/CD en verde
-  ✅ Reviewers asignados
-  ✅ Descripción completa con test plan
-  ✅ No hay merge conflicts
-  ✅ Diff contiene solo cambios intencionales

Problemas Comunes y Soluciones
------------------------------

Problema 1: Push rechazado
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Error**: ``! [rejected] feature/... -> feature/... (fetch first)``

**Solución**:

.. code:: bash

   git pull origin feature/user-authentication --rebase
   git push

--------------

Problema 2: CI/CD failing
~~~~~~~~~~~~~~~~~~~~~~~~~

**Error**: Tests o linters fallan

**Solución**: 1. Revisar logs de CI/CD 2. Ejecutar localmente:
``pytest`` o ``npm test`` 3. Corregir errores 4. Commit y push fix

--------------

Problema 3: Merge conflicts
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Error**: GitHub indica conflictos con main

**Solución**:

.. code:: bash

   git checkout main
   git pull origin main
   git checkout feature/user-authentication
   git merge main
   # Resolver conflictos manualmente
   git add .
   git commit -m "merge: resolver conflictos con main"
   git push

--------------

Referencias
-----------

-  `PROC-DEV-001: Pipeline de Trabajo
   IACT <../procesos/PROC-DEV-001-pipeline_trabajo_iact.md>`__
-  `GUIA-GOB-002: Convenciones de
   Nomenclatura <../guias/GUIA-GOB-002-convenciones_nomenclatura.md>`__
-  `Git Workflow
   Documentation <https://docs.github.com/en/pull-requests>`__

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
