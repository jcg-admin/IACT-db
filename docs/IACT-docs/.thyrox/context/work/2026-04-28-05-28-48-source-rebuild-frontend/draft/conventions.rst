.. meta::
   :artefacto: FRONTEND_CONVENTIONS
   :tipo: Convenciones del tier
   :dominio: tech
   :estado: Esqueleto
   :version: 1.0.0
   :fecha_creacion: 2026-04-28
   :autor: Equipo IACT

============================================
Frontend — Convenciones
============================================

React
=====

Naming
------

- **Componentes:** ``PascalCase`` (``UserCard.jsx``, ``ReportTable.jsx``).
- **Hooks custom:** ``camelCase`` con prefijo ``use``
  (``useReportData``, ``useAuth``).
- **Files de utilidades:** ``camelCase``.
- **Constantes globales:** ``UPPER_SNAKE_CASE``.

Estructura
----------

::

    frontend/src/
    ├── components/             # Componentes reutilizables
    ├── pages/                  # Componentes de página (route targets)
    ├── hooks/                  # Hooks custom
    ├── api/                    # Cliente HTTP + endpoints
    ├── store/                  # State management
    ├── utils/                  # Utilidades puras
    ├── styles/                 # Tema, variables, mixins
    └── App.jsx

Tipos de componentes
--------------------

- **Function components** con hooks (preferidos).
- Class components solo cuando se requiere ``componentDidCatch``
  (error boundaries).

Reglas
------

- Un componente = un archivo.
- Props con destructuring en la firma.
- ``PropTypes`` o TypeScript para validación.
- No mutar props.

Webpack
=======

- ``webpack.config.js`` como entry point de configuración.
- Code splitting por route (lazy loading).
- Source maps en dev (``eval-source-map``), no en producción.
- Loaders: ``babel-loader`` (JS/JSX), ``css-loader`` + ``style-loader``
  (CSS), ``file-loader`` (assets).
- Plugins: ``HtmlWebpackPlugin``, ``MiniCssExtractPlugin`` (prod),
  ``DefinePlugin`` para variables de entorno.

Estilos
=======

- **CSS Modules** o **CSS-in-JS** (decisión pendiente — ADR).
- Variables de tema centralizadas (no inline magic numbers).
- BEM o convención equivalente para clases CSS si se usa CSS
  estándar.

Estado
======

- State local con ``useState`` para datos de un componente.
- State compartido con la solución elegida (Redux/Context/Zustand).
- No mezclar fuentes de verdad — un dato vive en un solo lugar.

API client
==========

- Wrapper centralizado en ``src/api/`` con interceptores de auth
  y error handling.
- Endpoints como funciones tipadas (no strings dispersos).

Testing
=======

- ``jest`` + ``react-testing-library``.
- Convención: ``{Component}.test.jsx`` adyacente al componente.
- Tests de comportamiento (queries por rol/texto), no de
  implementación.

Accesibilidad
=============

- Etiquetas ARIA donde corresponde.
- Contraste mínimo WCAG AA.
- Navegación por teclado.

Commit y branching
==================

Aplican las reglas globales del repo (Tim Pope, ``feature/*``).
