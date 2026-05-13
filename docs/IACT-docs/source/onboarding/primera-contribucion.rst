.. meta::
 :artefacto: ONB_PRIMERA-CONTRIBUCION
 :tipo: Guia
 :dominio: onboarding
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Interno

====================
Primera Contribucion
====================

Guia paso a paso para tu primera contribucion al proyecto IACT.

1. Workflow git
===============

Ver :doc:`/normativa/procedimientos/proced-dev-001-crear-pull-request`.

Resumen:

.. code-block:: bash

 git checkout -b feature/<descripcion-corta>
 # ... hacer cambios ...
 git add <archivos>
 git commit -m "Subject corto en imperativo (≤50 ch)" # Tim Pope style
 git push -u origin feature/<rama>
 # Crear PR en plataforma

2. Convenciones obligatorias
============================

- :doc:`/normativa/estandares/std-007-convencion-naming` — naming de
  archivos.
- :doc:`/normativa/estandares/std-006-versionado-semantico` —
  versionado.
- STD_007 § 7 "Convencion de Idioma" — codigo en ingles, docs y
  comentarios en espanol.

3. CNSTs criticos a respetar
============================

Antes de codificar, revisa:

- :doc:`/normativa/restricciones/cnst-001-prohibicion-de-email-y-smtp`
- :doc:`/normativa/restricciones/cnst-009-autenticacion-drf-obligatoria`
- :doc:`/normativa/restricciones/cnst-029-rbac-modelo-plano`
- :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`

4. Code review
==============

Tu PR sera revisado por:

- Tech Lead (al menos 1 aprobacion).
- Tests CI deben pasar (lint + tests + sphinx-build).
- Referencias a CNSTs aplicables en el commit body.
