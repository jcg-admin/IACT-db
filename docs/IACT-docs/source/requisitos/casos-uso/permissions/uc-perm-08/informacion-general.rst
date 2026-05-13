.. _uc-perm-08-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - UC_PERM_08
 * - **Nombre**
   - Generar Menu Dinamico
 * - **Categoria**
   - UX support / personalization
 * - **Modulo**
   - MOD_Permissions
 * - **BReq**
   - BReq-001, BReq-007
 * - **Funcion RBAC**
   - Implícita ``view_own_navigation``
 * - **Criticidad**
   - Importante (UX) — NO crítica
     (seguridad esta en UC_PERM_07)

1.2 Proposito
=============

Dar al frontend una estructura jerárquica
del menu para el User autenticado, basada
en el ``effective_set`` del User. Garantiza:

- El User no ve opciones para las que no
  tiene permiso (UX).
- Frontend agrupa coherentemente por
  dominio (Vistas, Administracion,
  Reportes, etc.).
- Carga inicial < 50 ms.

1.3 NO es seguridad
===================

Si un User construye una URL directa para
una funcion que no aparece en su menu, el
endpoint debe devolver 403 igual (UC_PERM_07
con decorator). El menu **oculta**, NO
**bloquea**.

1.4 Esquema del menu
====================

Estructura de salida (formato conceptual):

::

   {
     "domains": [
       {
         "code": "vistas",
         "label": "Vistas",
         "sections": [
           {
             "code": "dashboards",
             "label": "Dashboards",
             "actions": [
               { code: "view", label: "Ver" },
               { code: "edit", label: "Editar" }
             ]
           }
         ]
       },
       ...
     ],
     "user_id": int,
     "generated_at": timestamp,
     "cache": bool
   }

1.5 Convencion de codes RBAC
============================

Las funciones siguen patron:

::

   <action>_<scope>_<entity>

Ej: ``view_kpi_dashboard``,
``edit_user_profile``,
``export_quality_report``.

Para el menu, se mapea a estructura
jerarquica via **registry de funciones**
(catalogo Function tiene metadata):

- ``domain``: vistas / administracion /
  reportes / calidad / ...
- ``section``: dashboards / users / ...
- ``label_es``, ``label_en``
- ``icon``, ``order``

Esta metadata vive con la Function en
catalogo, no se infiere del code.

1.6 Restricciones aplicables
============================

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - CNST
   - Aplicacion
 * - **CNST-008**
   - segmento del User filtra
     funciones de visibilidad
 * - **CNST-009**
   - JWT requerido
 * - **CNST-013**
   - Excepciones estandar

1.7 Out of scope
================

- Personalizacion estetica del menu (icons,
  colors) — es del frontend.
- Generar menu de OTRO User (admin) —
  separado: UC_PERM_08b (NUEVO si se
  necesita; ver Parte 4).
- Audit del menu — se audita el USO de las
  funciones, no la generacion del menu
  (P-51).
