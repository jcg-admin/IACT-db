Procedimiento: Release y Deployment
===================================

Propósito
---------

Definir el proceso para crear releases y hacer deployment del proyecto
IACT.

Alcance
-------

Aplica a releases de versiones oficiales y deployments a entornos
(staging, producción).

Tipos de Release
----------------

Seguimos `Semantic Versioning <https://semver.org/>`__:
``MAJOR.MINOR.PATCH``

-  **MAJOR** (1.0.0): Cambios incompatibles de API
-  **MINOR** (0.1.0): Nueva funcionalidad compatible
-  **PATCH** (0.0.1): Bug fixes compatibles

Procedimiento de Release
------------------------

1. Pre-Release
~~~~~~~~~~~~~~

1.1 Verificación
^^^^^^^^^^^^^^^^

-  ☐ Todos los PRs target mergeados a main
-  ☐ Todos los tests pasando
-  ☐ Cobertura >= 80%
-  ☐ No hay issues críticos abiertos
-  ☐ Documentación actualizada
-  ☐ CHANGELOG.md preparado

1.2 Crear Release Branch
^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Desde main actualizado
   git checkout main
   git pull origin main

   # Crear release branch
   git checkout -b release/v1.2.0

1.3 Preparar Release
^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Actualizar versión en archivos relevantes
   # __version__ en __init__.py
   # pyproject.toml
   # package.json (si hay frontend)

   # Actualizar CHANGELOG.md
   cat >> CHANGELOG.md << 'EOF'
   ## [1.2.0] - 2025-11-04

   ### Added
   - Nueva funcionalidad X
   - Nueva funcionalidad Y

   ### Changed
   - Mejora en Z

   ### Fixed
   - Bug #123
   - Bug #456

   ### Deprecated
   - API endpoint antiguo

   ### Security
   - Parche de seguridad para CVE-XXXX
   EOF

   # Commit de versión
   git add .
   git commit -m "chore: prepare release v1.2.0"
   git push -u origin release/v1.2.0

2. Release PR
~~~~~~~~~~~~~

.. code:: bash

   # Crear PR de release
   gh pr create \
     --title "Release v1.2.0" \
     --body "$(cat <<EOF
   ## Release v1.2.0

   ### Summary
   Release con nuevas funcionalidades de autenticación y mejoras de performance.

   ### Changes Included
   - PRs #234, #235, #236, #238
   - Total: 15 PRs mergeados

   ### Testing
   - [x] Tests unitarios: PASS
   - [x] Tests integración: PASS
   - [x] Tests E2E: PASS
   - [x] Smoke tests en staging: PASS

   ### Migration Notes
   - Se requiere ejecutar: python manage.py migrate
   - Nueva variable de entorno: JWT_SECRET_KEY

   ### Rollback Plan
   - Revertir a tag v1.1.5
   - Rollback de migraciones con migration 0042

   ### Changelog
   Ver CHANGELOG.md para detalles completos.
   EOF
   )" \
     --base main \
     --head release/v1.2.0 \
     --label "release"

3. Deployment a Staging
~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Una vez PR aprobado
   gh pr merge --merge release/v1.2.0

   # Tag de release
   git checkout main
   git pull origin main
   git tag -a v1.2.0 -m "Release version 1.2.0"
   git push origin v1.2.0

   # Deploy a staging (adaptarlo al proyecto)
   # Ejemplo placeholder:
   vagrant ssh -- "cd /vagrant && git pull && sudo systemctl restart iact-django"

4. Smoke Tests en Staging
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Tests manuales críticos
   curl -X POST https://staging.iact.com/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"username":"test","password":"test123"}'

   # Health check
   curl https://staging.iact.com/api/health

   # Tests automatizados
   pytest tests/smoke/

5. Deployment a Producción
~~~~~~~~~~~~~~~~~~~~~~~~~~

WARNING **IMPORTANTE**: Solo después de validación en staging

5.1 Preparación
^^^^^^^^^^^^^^^

-  ☐ Backup de base de datos

   .. code:: bash

      pg_dump -h prod-db -U iact -d iact_db > backup_pre_v1.2.0.sql

-  ☐ Notificar a stakeholders (ventana de mantenimiento)

-  ☐ Rollback plan documentado

5.2 Deployment
^^^^^^^^^^^^^^

.. code:: bash

   # Activar modo mantenimiento
   # (implementación depende del proyecto)

   # Deploy (ejemplo - adaptar al proyecto)
   ssh prod-server
   cd /var/www/iact
   git fetch --tags
   git checkout v1.2.0

   # Aplicar migraciones
   source venv/bin/activate
   python manage.py migrate

   # Recolectar archivos estáticos
   python manage.py collectstatic --noinput

   # Reiniciar servicios
   sudo systemctl restart iact-django
   sudo systemctl restart apache2

   # Desactivar modo mantenimiento

5.3 Verificación Post-Deploy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  ☐ Health checks pasan
-  ☐ Smoke tests pasan
-  ☐ Logs sin errores críticos
-  ☐ Métricas normales (response time, error rate)
-  ☐ Funcionalidad crítica verificada manualmente

6. Comunicación
~~~~~~~~~~~~~~~

.. code:: markdown

   # Template de anuncio

   **Release v1.2.0 Deployed to Production**

   OK Deployment completado exitosamente

   **Nuevas Funcionalidades:**
   - Autenticación JWT
   - Dashboard mejorado
   - Export de reportes en Excel

   **Bug Fixes:**
   - Corrección de login en IE11
   - Fix de timezone en reportes

   **Notas:**
   - No requiere acción de usuarios
   - Todos los datos migrados correctamente

   **Rollback:** Disponible si se detectan problemas

   **Equipo DevOps**

Hotfix Release
--------------

Para bugs críticos en producción:

.. code:: bash

   # Desde tag actual de producción
   git checkout v1.2.0
   git checkout -b hotfix/v1.2.1

   # Implementar fix mínimo
   # ...

   # Commit
   git commit -m "fix: corregir autenticación rota"

   # Tag
   git tag -a v1.2.1 -m "Hotfix: authentication"
   git push origin v1.2.1

   # Deploy inmediato a producción
   # Seguir proceso acelerado de deployment

Rollback
--------

Si hay problemas críticos:

.. code:: bash

   # En servidor de producción
   cd /var/www/iact
   git checkout v1.1.5  # versión anterior estable

   # Revertir migraciones si es necesario
   python manage.py migrate app_name 0041  # número de migración anterior

   # Reiniciar servicios
   sudo systemctl restart iact-django
   sudo systemctl restart apache2

Checklist de Release
--------------------

-  ☐ Código mergeado a main
-  ☐ Tests pasan
-  ☐ CHANGELOG.md actualizado
-  ☐ Versión bumpeada
-  ☐ Tag creado
-  ☐ Deploy a staging exitoso
-  ☐ Smoke tests en staging pasan
-  ☐ Backup de producción realizado
-  ☐ Ventana de mantenimiento comunicada
-  ☐ Deploy a producción exitoso
-  ☐ Verificación post-deploy completa
-  ☐ Monitoreo activo (primeras 2 horas)
-  ☐ Release comunicado

Monitoreo Post-Release
----------------------

Vigilar por 24-48 horas: - Error rates - Response times - CPU/Memory
usage - Database performance - Logs de errores

Recursos Relacionados
---------------------

-  `Procedimiento: QA <procedimiento_qa.md>`__
-  `Procedimiento: Gestión de
   Cambios <procedimiento_gestion_cambios.md>`__
-  `Runbooks DevOps <../devops/runbooks/>`__

Changelog
---------

-  2025-11-04: Creación inicial del procedimiento
