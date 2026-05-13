.. meta::
 :artefacto: Checklists_Backend
 :tipo: Checklist
 :dominio: gestion
 :subdominio: pm
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

Checklists del backend
======================

Listas de verificación para validar entregables clave del backend dentro
del SDLC. Cada checklist debe asociarse a un espacio principal y
actualizarse conforme evolucione el proceso.

Página padre
------------

- ```../README.rst`` <../README>`__

Páginas hijas
-------------

- `:doc:`checklist_desarrollo </gestion/pm/checklists/checklist-desarrollo>` <checklist_desarrollo.rst>`__
- `:doc:`checklist_testing </gestion/pm/checklists/checklist-testing>` <checklist_testing.rst>`__
- `:doc:`checklist_trazabilidad_requisitos </gestion/pm/checklists/checklist-trazabilidad-requisitos>` <checklist_trazabilidad_requisitos.rst>`__

Información clave
-----------------

Recursos disponibles
~~~~~~~~~~~~~~~~~~~~

- :doc:`checklist_desarrollo </gestion/pm/checklists/checklist-desarrollo>`
- :doc:`checklist_testing </gestion/pm/checklists/checklist-testing>`
- :doc:`checklist_trazabilidad_requisitos </gestion/pm/checklists/checklist-trazabilidad-requisitos>`

Recomendaciones
~~~~~~~~~~~~~~~

- Mantener responsables y fechas de revisión en el front matter de cada
  checklist.
- Referenciar estos artefactos desde
  ```../gobernanza/README.rst`` <../gobernanza/README>`__ al preparar
  ceremonias del backend.
- Registrar el control documental transversal en
  ```../../infrastructure/checklists/checklist_cambios_documentales.rst`` <../../infrastructure/checklists/checklist_cambios_documentales.rst>`__.

Estado de cumplimiento
----------------------

.. list-table::
   :header-rows: 1

   * - Elemento en la base maestra
     - ¿Existe en repositorio?
     - Observaciones
   * - Portada del espacio de checklists
     - Sí
     - Este archivo mantiene la jerarquía y metadatos requeridos.
   * - Checklist de desarrollo
     - Sí
     - Disponible en ```checklist_des arrollo.rst`` <checkli st_desarrollo.rst>`__.
   * - Checklist de pruebas
     - Sí
     - Registrado en ```checkli st_testing.rst`` <chec klist_testing.rst>`__.
   * - Checklist de trazabilidad de requisitos
     - Sí
     - Disponible en ```checklist_trazabil idad_requisitos.rst`` <checklist_trazabilid ad_requisitos.rst>`__.
   * - Registro de owners y fechas de vigencia
     - No
     - Falta consolidar inventario con responsables y última revisión.

Acciones prioritarias
---------------------

- [ ] Crear inventario maestro con owners y fechas de revisión de cada
  checklist.
- [ ] Definir cadencia de auditoría para medir cumplimiento y actualizar
  métricas en QA.
- [ ] Conectar cada checklist con los rituales documentados en
  Gobernanza.
