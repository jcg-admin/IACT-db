Architecture Decision Records (ADR) - Backend
=============================================

Este directorio contiene los Architecture Decision Records especificos
del dominio backend del proyecto IACT.

Proposito
---------

Documentar decisiones arquitectonicas importantes del backend,
incluyendo: - Contexto de la decision - Alternativas consideradas -
Decision tomada - Consecuencias esperadas e impacto

Nomenclatura
------------

::

   ADR-BACK-###-titulo-snake-case.md

**Ejemplos:** - ``ADR-BACK-001-arquitectura-permisos-granular.md`` -
``ADR-BACK-002-estrategia-testing-backend.md`` -
``ADR-BACK-003-migracion-django-4.md``

Estructura de un ADR
--------------------

Cada ADR debe incluir metadatos YAML:

.. code:: yaml

   ---
   id: ADR-BACK-###
   tipo: adr
   estado: [propuesta|aceptada|rechazada|obsoleta|superseded]
   fecha: YYYY-MM-DD
   contexto: Breve descripcion del contexto
   decision: Decision tomada
   consecuencias: Impacto esperado
   alternativas: Alternativas consideradas
   supersedes: ADR-BACK-### (si aplica)
                                       

Plantilla
---------

Ver: ``docs/backend/plantillas/plantilla-adr-backend.md``

ADRs Existentes
---------------

(Lista se actualizara conforme se creen ADRs formales)

Por implementar:
~~~~~~~~~~~~~~~~

-  Arquitectura de permisos granular
-  Estrategia de testing (TDD)
-  Sesiones en MySQL (no Redis)
-  Base de datos dual (IVR read-only + Analytics write)

Restricciones del Proyecto
--------------------------

Los ADRs deben considerar las siguientes restricciones criticas: - NO
usar email/SMTP - NO usar Redis (sesiones en MySQL) - Base de datos
dual: IVR (read-only) + Analytics (write)

Referencias
-----------

-  `ADR GitHub
   repo <https://github.com/joelparkerhenderson/architecture-decision-record>`__
-  `Documentar decisiones arquitectonicas - Martin
   Fowler <https://martinfowler.com/articles/documenting-architecture-decisions.html>`__

--------------

**Ultima actualizacion:** 2025-11-18 **Responsable:** Equipo Backend
