.. meta::
 :artefacto: TPL_DEPLOYMENT_GUIDE
 :tipo: Plantilla
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==================================================
TPL_DEPLOYMENT_GUIDE: Plantilla de Deployment
==================================================

.. note::

 Plantilla para guías de deployment paso a paso. Aplica skill
 ``bpa-implement``. Se usa por release y por ambiente
 (staging / producción).

1. Propósito
============

Documentar el procedimiento exacto para desplegar una versión
del producto IACT a un ambiente específico, sin ambigüedad
operativa.

2. Cuándo usar esta plantilla
=============================

- Para cada release que requiera deployment manual asistido.
- Como base de runbooks operacionales para deploy automatizado.

3. Estructura obligatoria
=========================

3.1 Resumen
-----------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Ambiente**
   - {STAGING / PRODUCCIÓN}
 * - **Versión**
   - {vX.Y.Z}
 * - **Tipo deployment**
   - rolling-update / blue-green / hot-swap
 * - **Tiempo estimado**
   - {minutos}
 * - **Owner**
   - DevOps Engineer

3.2 Precondiciones
------------------

- Build vX.Y.Z disponible y firmado.
- Acceso al servidor / cluster.
- Credenciales BD aceptando escrituras.
- Plan de release aprobado:
  :doc:`tpl-release-plan-release-management`.
- Ventana de mantenimiento confirmada (si aplica).

3.3 Pasos de deployment
-----------------------

.. list-table::
 :widths: 8 60 32
 :header-rows: 1

 * - #
   - Acción
   - Verificación
 * - {ejemplo}
   - {ejemplo}
   - {ejemplo}

Cada paso debe ser:

- **Atómico** (ejecutable sin ambigüedad).
- **Verificable** (con criterio de éxito explícito).
- **Reversible** (con su acción de rollback).

3.4 Smoke tests post-deployment
-------------------------------

Lista de tests inmediatos a ejecutar:

- Health endpoint OK.
- Login funcional con usuario de prueba.
- Tests críticos del UC del release.

3.5 Rollback
------------

.. code-block:: bash

 # Comandos exactos para revertir
 # Si la causa es la migration: cómo revertir BD también

3.6 Verificación post-deployment
--------------------------------

- Métricas verdes en dashboard.
- Error rate < 0.1%.
- Tests automáticos del UC pasan.

3.7 Sign-off
------------

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

4. Stack de despliegue (proyecto IACT)
======================================

El proyecto IACT es un **modular monolith** desplegado sobre:

- Vagrant (provisioning)
- Apache + mod_wsgi (per
  :doc:`/devops/adr-devops-001-vagrant-mod-wsgi-importante-produc`)
- systemd para gestión de daemons (etl-scheduler, export-worker)

NO se usa Kubernetes ni microservicios.

5. Ejemplo de aplicación
========================

Ver :doc:`/base-cognitiva/_ejemplos-pedagogicos/ejemplo-dark-mode/deployment-guide-staging`
como guía aplicada al deployment de Dark Mode a STAGING.

6. Convenciones de naming
=========================

- Archivo: ``deployment-guide-{ambiente}.rst`` o
  ``deployment-{version}-{ambiente}.rst``.
- Ubicación: ``source/devops/`` para guías generales,
  ``source/devops/runbooks/`` para runbooks operacionales.

7. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``bpa-implement`` (Business Process Architecture — Implement)
 * - **Templates relacionados**
   - :doc:`tpl-release-plan-release-management`, :doc:`tpl-troubleshooting-runbook`
 * - **ADRs aplicables**
   - :doc:`/devops/adr-devops-001-vagrant-mod-wsgi-importante-produc`
