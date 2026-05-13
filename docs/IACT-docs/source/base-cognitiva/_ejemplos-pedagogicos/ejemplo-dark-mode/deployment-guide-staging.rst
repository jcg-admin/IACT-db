.. meta::
 :artefacto: DEPLOYMENT-GUIDE-staging
 :tipo: Guía de Deployment
 :dominio: base-cognitiva
 :subdominio: ejemplos-pedagogicos
 :saga: dark-mode
 :fase_sdlc: deployment
 :skill_aplicada: bpa-implement
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==============================
Guía de Deployment: Staging
==============================

.. note::

 **Ejemplo pedagógico (saga dark-mode).** Aplica el skill
 ``bpa-implement`` (BPA — Implementation phase) para deployment
 a staging del release v1.5.0 que incluye Dark Mode.

1. Resumen
==========

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Ambiente**
   - Staging
 * - **Versión**
   - v1.5.0 (saga dark-mode)
 * - **Tipo de deployment**
   - Rolling update (sin downtime)
 * - **Estimated time**
   - 15 min
 * - **Owner**
   - DevOps Engineer

2. Precondiciones
=================

- Build v1.5.0 publicado en registry interno.
- Staging DB accesible.
- Accesos administrativos al cluster.
- Plan de release aprobado: :doc:`release-plan-v1-5-0`.

3. Pasos de deployment
======================

.. list-table::
 :widths: 8 60 32
 :header-rows: 1

 * - #
   - Acción
   - Verificación
 * - 1
   - Aplicar migration ``20260501-add-user-preferences.sql``
   - Tabla creada; indices ok
 * - 2
   - Pull image ``iact:v1.5.0`` en cluster staging
   - Image disponible
 * - 3
   - Update deployment ``iact-backend`` a image v1.5.0
   - Pods rolling-update sin errores
 * - 4
   - Update deployment ``iact-frontend`` a image v1.5.0
   - Pods rolling-update sin errores
 * - 5
   - Smoke test: GET /api/preferences/theme
   - Status 200 o 401 si no hay sesión
 * - 6
   - Smoke test: login + toggle theme
   - Cambio aplicado, persiste
 * - 7
   - Verificar logs por errors
   - 0 errors críticos en 5 min

4. Rollback (si falla)
======================

.. code-block:: bash

 # Revertir deployment
 kubectl rollout undo deployment/iact-backend
 kubectl rollout undo deployment/iact-frontend

 # Si la migration causó el problema:
 psql -h staging-db -U iact -c "DROP TABLE user_preferences;"

5. Post-deployment checks
=========================

- Smoke tests automatizados pasan.
- Métricas dashboard en verde (error rate < 0.1%).
- TC-001 ejecutado en staging y PASS.

6. Sign-off
===========

.. list-table::
 :widths: 25 25 25 25
 :header-rows: 1

 * - Rol
   - Nombre
   - Firma
   - Fecha
 * - DevOps
   - {nombre}
   - {firma}
   - {YYYY-MM-DD}
 * - QA
   - {nombre}
   - {firma}
   - {YYYY-MM-DD}
 * - Tech Lead
   - {nombre}
   - {firma}
   - {YYYY-MM-DD}

7. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Saga**
   - dark-mode (:doc:`index`)
 * - **Skill aplicada**
   - ``bpa-implement``
 * - **Fase SDLC**
   - Deployment
 * - **Release plan backing**
   - :doc:`release-plan-v1-5-0`
 * - **Final de la saga**
   - End-to-end completo. Volver al :doc:`index` para resumen.
