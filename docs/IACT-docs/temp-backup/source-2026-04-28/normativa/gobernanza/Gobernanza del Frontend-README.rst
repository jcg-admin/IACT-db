Gobernanza del Frontend
=======================

Políticas, estándares y lineamientos que rigen el desarrollo,
mantenimiento y evolución del frontend.

⚠️ Gobernanza Multi-nivel
-------------------------

El proyecto IACT utiliza una arquitectura de gobernanza en dos niveles:

1. **Gobernanza Global** (```/docs/gobernanza/`` <../gobernanza/>`__):
   Decisiones que afectan a TODO el proyecto
2. **Gobernanza Frontend** (este directorio): Decisiones específicas del
   frontend

Enlaces Rápidos a Gobernanza Global
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**ANTES de crear un ADR aquí, consulta la gobernanza global:**

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Recurso
     - Ubicación
   * - **ADRs Globales**
     - ``../gobernanza/adr/``
   * - **Guías Compartidas**
     - ``../gobernanza/guias/``
   * - **Procedimientos**
     - ``../gobernanza/procedimientos/``
   * - **Templates**
     - ``../gobernanza/templates/``
   * - **Diseño Global**
     - ``../gobernanza/diseno/``

**Documento clave:** ``ADR-GOB-010: Gobernanza Multi-nivel``
(``../gobernanza/adr/ADR-GOB-010-gobernanza-multinivel.md``)

¿Cuándo crear ADR aquí vs. Global?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**✅ ADR de Frontend (aquí)**: Solo afecta frontend, stack-specific
(React/TypeScript), no rompe interoperabilidad

**❌ ADR Global**: Afecta múltiples dominios, define estándares del
proyecto, cross-cutting concerns

Página padre
------------

-  ```../README.md`` <../README.md>`__

Páginas hijas
-------------

-  ```adr/`` <adr/>`__ - ADRs específicos del frontend
-  ```lineamientos_gobernanza.md`` <lineamientos_gobernanza.md>`__ -
   Lineamientos específicos
-  ```registro_decisiones.md`` <registro_decisiones.md>`__ - Bitácora de
   decisiones de gobernanza

Información clave
-----------------

Estándares de código
~~~~~~~~~~~~~~~~~~~~

-  Guía de estilo (ESLint, Prettier)
-  Convenciones de naming
-  Estructura de archivos y directorios
-  Documentación de código (JSDoc, TSDoc)
-  Accesibilidad (WCAG 2.1)

Proceso de desarrollo
~~~~~~~~~~~~~~~~~~~~~

-  Workflow de Git (branching strategy)
-  Code review requirements
-  Testing requirements
-  Definition of Done
-  CI/CD pipeline

Gestión de dependencias
~~~~~~~~~~~~~~~~~~~~~~~

-  Política de actualización de dependencias
-  Evaluación de nuevas librerías
-  Gestión de security vulnerabilities
-  Documentación de dependencias críticas

Performance y optimización
~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Métricas objetivo (LCP, FID, CLS)
-  Bundle size limits
-  Code splitting strategy
-  Lazy loading guidelines
-  Caching strategy

Seguridad frontend
~~~~~~~~~~~~~~~~~~

-  Input validation
-  XSS prevention
-  CSRF protection
-  Content Security Policy
-  Secrets management

Lineamientos corporativos aplicables
------------------------------------

Se heredan los siguientes lineamientos del nivel corporativo: -
```../../gobernanza/estandares_codigo.md`` <../../gobernanza/estandares_codigo.md>`__
-------------------------------------------------------------------------------------
```../../gobernanza/lineamientos_gobernanza.md`` <../../gobernanza/lineamientos_gobernanza.md>`__

Estado de cumplimiento
----------------------

+-----------------------+-----------------------+-----------------------+
| Elemento en la base   | ¿Existe en            | Observaciones         |
| maestra               | repositorio?          |                       |
+=======================+=======================+=======================+
| Portada de Gobernanza | Sí                    | Este archivo          |
| frontend              |                       | documenta políticas y |
|                       |                       | estándares del        |
|                       |                       | frontend              |
+-----------------------+-----------------------+-----------------------+
| Lineamientos de       | Pendiente             | Crear documento con   |
| gobernanza            |                       | políticas específicas |
|                       |                       | de frontend           |
+-----------------------+-----------------------+-----------------------+
| Estándares de código  | Parcial               | Definidos en          |
|                       |                       | configuración         |
|                       |                       | ESLint/Prettier,      |
|                       |                       | falta documentación   |
+-----------------------+-----------------------+-----------------------+
| Registro de           | Pendiente             | Crear bitácora de     |
| decisiones            |                       | decisiones de         |
|                       |                       | gobernanza            |
+-----------------------+-----------------------+-----------------------+

Acciones prioritarias
---------------------

-  ☐ Documentar lineamientos de gobernanza frontend
-  ☐ Formalizar estándares de código en documento
-  ☐ Establecer métricas y objetivos de performance
-  ☐ Crear registro de decisiones de gobernanza
