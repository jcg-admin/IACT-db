Procedimiento: Gestión de Cambios
=================================

Propósito
---------

Definir el proceso estándar para proponer, revisar, aprobar e
implementar cambios en el proyecto IACT.

Alcance
-------

Aplica a todos los cambios de código, documentación y configuración que
afecten los repositorios del proyecto.

Tipos de Cambios
----------------

Cambios de Código
~~~~~~~~~~~~~~~~~

-  **feat**: Nueva funcionalidad
-  **fix**: Corrección de bug
-  **refactor**: Refactorización sin cambio funcional
-  **perf**: Mejoras de performance
-  **test**: Agregar o modificar tests
-  **docs**: Solo cambios en documentación

Cambios de Documentación
~~~~~~~~~~~~~~~~~~~~~~~~

-  **Menor**: Corrección de typos, formato
-  **Mayor**: Nueva sección, reestructuración
-  **Crítico**: Cambio de proceso, ADR nueva

Procedimiento
-------------

1. Planificación del Cambio
~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.1 Identificar Necesidad
^^^^^^^^^^^^^^^^^^^^^^^^^

-  ☐ Documentar el problema o requisito
-  ☐ Verificar que no exista issue duplicado
-  ☐ Determinar el tipo de cambio

1.2 Crear Issue
^^^^^^^^^^^^^^^

.. code:: bash

   # Usando gh CLI
   gh issue create \
     --title "feat: Agregar autenticación JWT" \
     --body "Descripción detallada..." \
     --label "enhancement"

O crear en GitHub: - Título descriptivo - Descripción clara del problema
- Criterios de aceptación - Prioridad y labels

2. Desarrollo del Cambio
~~~~~~~~~~~~~~~~~~~~~~~~

2.1 Crear Rama Feature
^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Desde main actualizado
   git checkout main
   git pull origin main

   # Crear feature branch
   git checkout -b feature/autenticacion-jwt-20251104

   # Convención: {tipo}/{descripcion-corta}-{fecha}

2.2 Implementar Cambio
^^^^^^^^^^^^^^^^^^^^^^

-  ☐ Seguir `Lineamientos de
   Código <../arquitectura/lineamientos_codigo.md>`__
-  ☐ Escribir tests (TDD cuando sea posible)
-  ☐ Actualizar documentación relevante
-  ☐ Seguir `Checklist de
   Desarrollo <../checklists/checklist_desarrollo.md>`__

2.3 Commits
^^^^^^^^^^^

Usar Conventional Commits:

.. code:: bash

   # Formato
   git commit -m "{tipo}: {descripción corta}

   {descripción larga opcional}

   {referencias a issues}"

   # Ejemplos
   git commit -m "feat: agregar endpoint de login JWT

   - Implementar serializer para credenciales
   - Crear vista de autenticación
   - Agregar tests unitarios

   Closes #123"

   git commit -m "fix: corregir validación de passwords

   El validador no estaba verificando longitud mínima
   correctamente cuando la contraseña tenía espacios.

   Fixes #456"

3. Pre-Pull Request
~~~~~~~~~~~~~~~~~~~

3.1 Validación Local
^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Ejecutar checklist completo
   black .
   isort .
   pylint api/**/*.py
   flake8 .

   # Tests
   pytest --cov=. --cov-report=html

   # Verificar cobertura >= 80%

3.2 Actualizar Rama
^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Asegurar que estás al día con main
   git checkout main
   git pull origin main
   git checkout feature/tu-rama
   git rebase main

   # Resolver conflictos si hay
   # Luego
   git rebase --continue

3.3 Push
^^^^^^^^

.. code:: bash

   git push -u origin feature/tu-rama

4. Crear Pull Request
~~~~~~~~~~~~~~~~~~~~~

4.1 Usando gh CLI
^^^^^^^^^^^^^^^^^

.. code:: bash

   gh pr create \
     --title "feat: Agregar autenticación JWT" \
     --body "$(cat <<EOF
   ## Summary
   - Implementa autenticación con JSON Web Tokens
   - Agrega endpoints /api/auth/login y /api/auth/refresh
   - Configura middleware de autenticación

   ## Test Plan
   - [x] Tests unitarios de serializers
   - [x] Tests de endpoints
   - [x] Tests de integración con middleware
   - [x] Validación manual en desarrollo

   ## Related Issues
   Closes #123

   ## Breaking Changes
   Ninguno

   ## Screenshots
   N/A - Backend API
   EOF
   )" \
     --assignee @me \
     --reviewer equipo-backend

4.2 Template de PR
^^^^^^^^^^^^^^^^^^

El PR debe incluir:

**Summary** (3-5 bullets de qué se cambió) - Cambio 1 - Cambio 2 -
Cambio 3

**Test Plan** (cómo se probó) - [ ] Tests unitarios
agregados/actualizados - [ ] Tests de integración - [ ] Verificación
manual

**Related Issues** (links a issues) - Closes #123 - Related to #456

**Breaking Changes** (si aplica) - Listar cambios incompatibles con
versión anterior

**Deployment Notes** (si aplica) - Pasos especiales de deployment -
Migraciones de DB - Cambios de configuración

5. Code Review
~~~~~~~~~~~~~~

5.1 Como Autor
^^^^^^^^^^^^^^

-  ☐ Responder a comentarios en < 24 horas
-  ☐ Hacer cambios solicitados
-  ☐ Pushear cambios
-  ☐ Re-solicitar review cuando esté listo

5.2 Como Reviewer
^^^^^^^^^^^^^^^^^

Verificar (ver `Checklist de
Review <../checklists/readme.md#checklist-de-code-review>`__):

**Funcionalidad:** - [ ] El código hace lo que dice - [ ] Edge cases
considerados - [ ] Manejo de errores apropiado

**Calidad:** - [ ] Código legible y mantenible - [ ] Sigue lineamientos
del proyecto - [ ] No hay código duplicado

**Tests:** - [ ] Cobertura adecuada - [ ] Tests son determinísticos - [
] Nombres descriptivos

**Seguridad:** - [ ] No hay vulnerabilidades obvias - [ ] Inputs
validados - [ ] Secrets no expuestos

**Performance:** - [ ] No hay N+1 queries - [ ] Índices apropiados - [ ]
Queries optimizadas

**Documentación:** - [ ] Docstrings completos - [ ] README actualizado
si aplica - [ ] ADR creado si es decisión arquitectónica

6. Merge
~~~~~~~~

6.1 Pre-Merge Checklist
^^^^^^^^^^^^^^^^^^^^^^^

-  ☐ Todos los reviews aprobados (mínimo 1)
-  ☐ CI pasó (cuando se implemente)
-  ☐ Conflictos resueltos
-  ☐ Rama actualizada con main

6.2 Merge Strategy
^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Squash and merge (preferido para features)
   gh pr merge --squash --delete-branch

   # Merge commit (para releases)
   gh pr merge --merge --delete-branch

   # Rebase (para cambios lineales simples)
   gh pr merge --rebase --delete-branch

6.3 Post-Merge
^^^^^^^^^^^^^^

-  ☐ Verificar que PR fue mergeado
-  ☐ Rama feature eliminada
-  ☐ Issue relacionado cerrado automáticamente
-  ☐ Actualizar proyecto/board si aplica

.. _cambios-de-documentación-1:

7. Cambios de Documentación
~~~~~~~~~~~~~~~~~~~~~~~~~~~

7.1 Flujo Simplificado
^^^^^^^^^^^^^^^^^^^^^^

Para cambios solo de documentación:

.. code:: bash

   # Rama docs
   git checkout -b docs/actualizar-readme-20251104

   # Hacer cambios
   # ...

   # Commit
   git commit -m "docs: actualizar guía de instalación"

   # PR directo sin review extenso (para cambios menores)
   gh pr create --title "docs: actualizar guía de instalación" --reviewer @me

   # Self-merge si es cambio trivial
   gh pr merge --squash --delete-branch

7.2 Cambios Mayores
^^^^^^^^^^^^^^^^^^^

Para reestructuraciones o ADRs, seguir flujo completo con review.

Ver: `Procedimiento de Revisión
Documental <procedimiento_revision_documental.md>`__

Cambios de Emergencia (Hotfix)
------------------------------

Cuando Usar
~~~~~~~~~~~

-  Bug crítico en producción
-  Vulnerabilidad de seguridad
-  Pérdida de servicio

Procedimiento Acelerado
~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Desde main
   git checkout main
   git pull origin main

   # Crear hotfix branch
   git checkout -b hotfix/corregir-login-roto-20251104

   # Implementar fix MÍNIMO
   # ...

   # Tests
   pytest tests/test_authentication.py

   # Commit y push
   git commit -m "fix: corregir validación de login

   Corrige error que permitía login con credenciales vacías.
   CRÍTICO: afecta autenticación en producción.

   Fixes #789"
   git push -u origin hotfix/corregir-login-roto-20251104

   # PR urgente
   gh pr create --title "HOTFIX: Corregir validación de login" \
     --label "hotfix,urgent" \
     --reviewer @equipo-backend

   # Una vez aprobado
   gh pr merge --squash --delete-branch

   # Tag inmediato
   git tag -a v1.2.1 -m "Hotfix: login validation"
   git push origin v1.2.1

Ver: `Procedimiento de Release <procedimiento_release.md>`__ para
deployment urgente.

Métricas
--------

Medir: - Tiempo promedio de review: < 48 horas - Tasa de aprobación en
primer intento: > 70% - PRs abiertos simultáneamente por dev: < 3 -
Tamaño promedio de PR: < 400 líneas

Herramientas
------------

-  **gh CLI**: Para automatizar workflow
-  **GitHub Actions**: CI/CD (futuro)
-  **GitLens (VS Code)**: Para ver historial
-  **GitHub Projects**: Para tracking

Recursos Relacionados
---------------------

-  `Checklist de Desarrollo <../checklists/checklist_desarrollo.md>`__
-  `Checklist de Testing <../checklists/checklist_testing.md>`__
-  `Lineamientos de Código <../arquitectura/lineamientos_codigo.md>`__
-  `Procedimiento de QA <procedimiento_qa.md>`__
-  `Procedimiento de Release <procedimiento_release.md>`__

Referencias
-----------

-  `Conventional Commits <https://www.conventionalcommits.org/>`__
-  `GitHub Flow <https://guides.github.com/introduction/flow/>`__
-  `Semantic Versioning <https://semver.org/>`__

Changelog
---------

-  2025-11-04: Creación inicial del procedimiento
