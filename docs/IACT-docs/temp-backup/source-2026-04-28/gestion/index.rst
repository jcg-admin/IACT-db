.. _gestion:

=======
Gestión
=======

Propósito del Dominio
=====================

El dominio **Gestión** contiene la documentación de usuarios, la gestión del proyecto
y las evidencias de pruebas y validaciones del sistema IACT.

Este dominio responde a las preguntas: **"¿Cómo usar el sistema, cómo se gestiona el proyecto, y cuál es el flujo de trabajo de Git?"**

[CONFLICT TEST: Alternative change on feature/project-setup for conflict validation]

[CONFLICT TEST: Change made on develop branch for merge conflict validation test]

Contenido
=========

La gestión proporciona:

* **Manuales de Usuario:** Guías de operación y administración del sistema
* **Gestión de Proyecto:** Planificación, cronogramas, riesgos, seguimiento
* **Evidencia:** Pruebas, validaciones, aprobaciones, auditorías

Audiencias
==========

Este dominio sirve a múltiples audiencias:

* **Usuarios Finales:** Manuales de operación del dashboard
* **Administradores:** Guías de configuración y gestión de usuarios
* **Equipo de Proyecto:** Documentación de planificación y seguimiento
* **QA y Auditoría:** Evidencias de pruebas y validaciones

Subdominios
===========

.. toctree::
   :maxdepth: 2

   manuales_usuarios/index
   pm/index
   evidencia/index

.. note::
   Los manuales de usuario derivan de los casos de uso documentados en el dominio 
   de Requisitos, garantizando consistencia entre especificación e implementación.


.. toctree::
   :hidden:
   :maxdepth: 1

   git-workflow
   plantilla_adr
