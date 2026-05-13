.. meta::
 :artefacto: ONB_SETUP-ENTORNO
 :tipo: Guia
 :dominio: onboarding
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Interno

=======================
Setup del Entorno Local
=======================

Procedimiento para configurar el entorno de desarrollo local del
proyecto IACT.

1. Prerequisitos
================

- Ubuntu 22.04 LTS o equivalente.
- Python 3.10+.
- Node.js 18+.
- MySQL 8.0+ (BD operacional).
- PostgreSQL 14+ (BD analitica).
- git.

2. Clonar repositorio
=====================

.. code-block:: bash

 git clone <repo-url>
 cd iact

3. Configurar backend
=====================

.. code-block:: bash

 python -m venv venv
 source venv/bin/activate
 pip install -r requirements.txt
 python manage.py migrate
 python manage.py createsuperuser

4. Configurar frontend
======================

.. code-block:: bash

 cd frontend
 npm install
 npm run dev

5. Configurar BDs
=================

Ver procedimientos especificos:

- :doc:`/normativa/procedimientos/proced-devops-001-deploy-staging`
- :doc:`/databases/index` (cuando este disponible)

6. Build de la documentacion
============================

.. code-block:: bash

 cd /path/to/iact-docs
 make html
 # Salida en build/html/index.html

Build limpio (0 warnings, 0 errors) es **requisito** antes de
mergear cualquier PR que toque ``source/``.
