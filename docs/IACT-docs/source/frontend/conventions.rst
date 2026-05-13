.. meta::
 :artefacto: FRONT_CONVENTIONS
 :tipo: Convenciones
 :dominio: frontend
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Interno

============
Convenciones
============

Convenciones de naming, estructura y estilo para el frontend
IACT. Aplica a React y Webpack.

Naming
======

React
-----

- **Componentes:** PascalCase (``UserProfile.jsx``,
  ``DashboardCard.jsx``).
- **Hooks:** camelCase con prefijo ``use``
  (``useAuth``, ``useFetchData``).
- **Utilidades / helpers:** camelCase (``formatDate``,
  ``parseQuery``).
- **Constantes globales:** UPPER_SNAKE_CASE
  (``DEFAULT_TIMEOUT``).

Webpack
-------

- **Archivos de configuracion:** ``webpack.config.js``,
  ``webpack.<env>.config.js`` (ej: ``webpack.dev.config.js``).
- **Variables de entorno:** UPPER_SNAKE_CASE.

Archivos
--------

- Aplica :doc:`/normativa/estandares/std-007-convencion-naming`:
  kebab-case, sin espacios, sin tildes ni enies.

Estructura de carpetas
======================

Por feature, no por tipo:

.. code-block:: text

 src/
   features/
     auth/
       components/
       hooks/
       services/
       index.js
     dashboard/
       components/
       hooks/
       services/
       index.js
   shared/
     components/
     hooks/
     utils/

Estilo
======

- **Linter:** ESLint con configuracion compartida.
- **Formatter:** Prettier (las reglas de estilo se delegan
  al tooling — no se documentan aqui).
- **Imports:** orden estable (libs externas → internos por
  alias → relativos).

Trazabilidad
============

- Convenciones generales: :doc:`/normativa/estandares/index`.
- Decisiones arquitectonicas frontend: registrar como ADR
  en :doc:`/normativa/gobernanza/index` con prefijo
  ``ADR-FRONT-``.
