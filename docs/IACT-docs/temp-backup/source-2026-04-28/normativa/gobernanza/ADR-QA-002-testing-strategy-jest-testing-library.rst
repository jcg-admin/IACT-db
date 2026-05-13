ADR-019: Jest + Testing Library para Testing Frontend
=====================================================

COMO VALIDAR QUE SE SE ESTE IMPLEMENTANDO Jest Y QUE SEA TDD

Estado
------

**Aceptado** - 2025-11-06

Contexto
--------

El frontend IACT requiere una estrategia de testing completa que cubra:

1. **Unit tests**: Redux slices, funciones puras
2. **Component tests**: React components
3. **Integration tests**: Flujos user completos
4. **Coverage**: Mínimo 80% (objetivo proyecto)

Requisitos de Testing
~~~~~~~~~~~~~~~~~~~~~

-  **Rapidez**: Test suite <30s para CI/CD rápido
-  **Confiabilidad**: Tests no flaky (falsos positivos/negativos)
-  **Simplicidad**: Fácil escribir tests para equipo
-  **Coverage**: Medir cobertura automáticamente
-  **CI/CD integration**: Falla build si tests fallan

Opciones Evaluadas
~~~~~~~~~~~~~~~~~~

Opción 1: Vitest
^^^^^^^^^^^^^^^^

**Pros**: - Ultra rápido (ESM nativo, multithreading) - API compatible
con Jest - Integración nativa con Vite - UI moderna para ver resultados

**Contras**: - Ecosystem menor (menos plugins) - Requiere Vite (nosotros
usamos Webpack - ADR-018) - Documentación menor - Menos adopción
enterprise

Opción 2: Mocha + Chai + Enzyme
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Pros**: - Flexible - Maduro - Enzyme para React

**Contras**: - **Enzyme desactualizado**: No soporta React 18 bien -
Configuración compleja (múltiples librerías) - Assertions verbosas
(Chai) - Ecosystem fragmentado

Opción 3: Jest + React Testing Library (SELECCIONADA)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Pros**: - **Ecosystem maduro**: Jest estándar de industria - **Testing
Library filosofía**: “Test como usuario” (no implementación) - **Zero
config**: Con Babel funciona out-of-the-box - **Mocking robusto**:
Jest.mock() simple y potente - **Coverage built-in**: –coverage sin
configuración extra - **Snapshots**: Para componentes UI complejos -
**Comunidad grande**: Cualquier problema tiene solución - **CI/CD
standard**: GitHub Actions, GitLab CI, etc. tienen ejemplos

**Contras**: - Más lento que Vitest (~10-20% más) - jsdom no es browser
real (faltan algunas APIs)

Decisión
--------

Usar **Jest + React Testing Library** como estrategia de testing.

Componentes
~~~~~~~~~~~

1. **Jest**: Test runner y framework
2. **React Testing Library**: Utilities para testear React
3. **jest-dom**: Matchers custom para DOM
4. **jsdom**: Environment simulado de browser

Razones Principales
~~~~~~~~~~~~~~~~~~~

1. **Testing Library filosofía CRÍTICA**:

   -  “Test como usuario interactuaría” (no detalles implementación)
   -  Tests resilientes a refactorings
   -  Fuerza a escribir componentes accesibles

2. **Jest ecosystem maduro**:

   -  Mocking robusto (APIs, módulos, timers)
   -  Coverage automático
   -  Snapshots para UI
   -  Watch mode interactivo

3. **Simplicidad**:

   -  Un comando: ``npm test``
   -  Configuración mínima (en package.json)
   -  Tests intuitivos de leer

4. **CI/CD integración**:

   -  GitHub Actions tiene ejemplos oficiales
   -  Jest JUnit reporter para CI

Implementación
~~~~~~~~~~~~~~

Configuración Jest
^^^^^^^^^^^^^^^^^^

.. code:: json

   // package.json
   {
     "jest": {
       "testEnvironment": "jsdom",
       "setupFilesAfterEnv": ["<rootDir>/jest.setup.js"],
       "moduleNameMapper": {
         "^@app/(.*)$": "<rootDir>/src/app/$1",
         "^@modules/(.*)$": "<rootDir>/src/modules/$1",
         "^@components/(.*)$": "<rootDir>/src/components/$1",
         "^@hooks/(.*)$": "<rootDir>/src/hooks/$1",
         "^@styles/(.*)$": "<rootDir>/src/styles/$1",
         "^@state/(.*)$": "<rootDir>/src/state/$1",
         "\\.(css)$": "identity-obj-proxy"
       },
       "transform": {
         "^.+\\.[tj]sx?$": "babel-jest"
       }
     }
   }

Setup Global
^^^^^^^^^^^^

.. code:: javascript

   // jest.setup.js
   import '@testing-library/jest-dom';

   // Mock window.matchMedia
   Object.defineProperty(window, 'matchMedia', {
     writable: true,
     value: jest.fn().mockImplementation((query) => ({
       matches: false,
       media: query,
       addEventListener: jest.fn(),
       removeEventListener: jest.fn(),
     })),
   });

Estrategia de Testing por Capa
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Redux Slices (Unit Tests)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: javascript

   // src/modules/home/state/homeSlice.test.js
   import homeReducer, { setAnnouncement } from './homeSlice';

   describe('homeSlice', () => {
     const initialState = { announcement: null };

     it('should handle setAnnouncement', () => {
       const actual = homeReducer(initialState, setAnnouncement('Test'));
       expect(actual.announcement).toEqual('Test');
     });
   });

**Coverage target**: 100% (funciones puras, fácil testear)

2. React Components (Component Tests)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: javascript

   // src/app/App.test.jsx
   import { render, screen } from '@testing-library/react';
   import { Provider } from 'react-redux';
   import { configureStore } from '@reduxjs/toolkit';
   import App from './App';

   describe('App Component', () => {
     it('renders without crashing', () => {
       const store = configureStore({ /* ... */ });
       render(
         <Provider store={store}>
           <App />
         </Provider>
       );
       expect(screen.getByText(/IACT Dashboard/i)).toBeInTheDocument();
     });
   });

**Coverage target**: 80% (focus en flujos críticos)

3. Hooks (Unit Tests)
^^^^^^^^^^^^^^^^^^^^^

.. code:: javascript

   // src/hooks/useAppConfig.test.js
   import { renderHook } from '@testing-library/react';
   import { Provider } from 'react-redux';
   import { useAppConfig } from './useAppConfig';

   describe('useAppConfig', () => {
     it('returns config', () => {
       const wrapper = ({ children }) => (
         <Provider store={store}>{children}</Provider>
       );

       const { result } = renderHook(() => useAppConfig(), { wrapper });
       expect(result.current.config).toBeDefined();
     });
   });

**Coverage target**: 90%

4. Integration Tests (Futuro con Playwright)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: javascript

   // tests/e2e/dashboard.spec.js
   test('dashboard loads and displays widgets', async ({ page }) => {
     await page.goto('http://localhost:3000');
     await expect(page.locator('text=IACT Dashboard')).toBeVisible();
     await expect(page.locator('.widget')).toHaveCount(10);
   });

**Coverage target**: Flujos críticos (login, dashboard, reportes)

Convenciones
~~~~~~~~~~~~

1. **Nombres de archivos**:

   -  ``ComponentName.test.jsx`` para componentes
   -  ``hookName.test.js`` para hooks
   -  ``sliceName.test.js`` para Redux slices

2. **Estructura de tests**:

.. code:: javascript

   describe('ComponentName', () => {
     // Setup común
     beforeEach(() => { /* ... */ });

     it('does something specific', () => {
       // Arrange
       const props = { /* ... */ };

       // Act
       render(<Component {...props} />);

       // Assert
       expect(screen.getByText('...')).toBeInTheDocument();
     });
   });

3. **Queries prioritarias** (Testing Library):

   -  ``getByRole`` (MEJOR - accesibilidad)
   -  ``getByLabelText`` (formularios)
   -  ``getByText`` (contenido visible)
   -  ``getByTestId`` (ÚLTIMO RECURSO)

4. **Mocking APIs**:

.. code:: javascript

   // Mock fetch global
   global.fetch = jest.fn(() =>
     Promise.resolve({
       json: () => Promise.resolve({ data: 'test' }),
     })
   );

Comandos
~~~~~~~~

.. code:: bash

   # Run all tests
   npm test

   # Watch mode (re-run on change)
   npm run test:watch

   # Coverage report
   npm run test:coverage

   # Run tests in CI (no watch, verbose)
   npm test -- --ci --verbose

Coverage Report
~~~~~~~~~~~~~~~

.. code:: bash

   # Genera reporte en console + HTML
   npm run test:coverage

   # Ver reporte HTML
   open coverage/lcov-report/index.html

**Targets de coverage**: - **Statements**: 80% - **Branches**: 75% -
**Functions**: 80% - **Lines**: 80%

Consecuencias
-------------

Positivas
~~~~~~~~~

1. **Confianza alta**: Tests resilientes a refactorings
2. **CI/CD simple**: Jest standard, fácil integrar
3. **Coverage automático**: Medir progreso fácilmente
4. **Debugging**: Watch mode interactivo
5. **Comunidad**: Cualquier problema tiene solución

Negativas
~~~~~~~~~

1. **Performance**: ~10-20% más lento que Vitest
2. **jsdom limitado**: No todas las APIs browser (ej:
   IntersectionObserver)
3. **Snapshots**: Pueden ser ruidosos si UI cambia mucho

Mitigaciones
~~~~~~~~~~~~

1. **Performance**: Test suite <30s es aceptable (medido)
2. **jsdom limitado**: Mock APIs faltantes en jest.setup.js
3. **Snapshots**: Usar con moderación (solo para componentes estables)

Métricas
~~~~~~~~

=================== ====== ===========================
Métrica             Target Actual (v0.1.0)
=================== ====== ===========================
Test suite duration <30s   ~5s (sin tests aún)
Coverage statements 80%    TBD (después de más código)
Tests flaky         0%     0%
CI/CD integration   Sí     Pendiente configurar
=================== ====== ===========================

Alternativas Rechazadas
-----------------------

Vitest
~~~~~~

Rechazado por: - Requiere Vite (usamos Webpack - ADR-018) - Ecosystem
menor - Menos adopción enterprise

**Nota**: Si migramos a Vite (futuro), reevaluar Vitest.

Mocha + Chai + Enzyme
~~~~~~~~~~~~~~~~~~~~~

Rechazado por: - Enzyme no soporta React 18 bien - Configuración
compleja (múltiples librerías) - Ecosystem fragmentado

Cypress (Component Testing)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Rechazado por: - Más lento (browser real) - Mejor para E2E que component
tests - Playwright es mejor alternativa para E2E

Referencias
-----------

-  **Jest**: https://jestjs.io/
-  **React Testing Library**: https://testing-library.com/react
-  **jest-dom**: https://github.com/testing-library/jest-dom
-  **Testing Library Philosophy**:
   https://testing-library.com/docs/guiding-principles/
-  **Coverage**:
   https://jestjs.io/docs/configuration#collectcoverage-boolean

Decisiones Relacionadas
-----------------------

-  **ADR-016**: Redux Toolkit (slices fáciles de testear)
-  **ADR-018**: Webpack (Babel transform para tests)

Roadmap Testing
---------------

v0.1.0 (Actual)
~~~~~~~~~~~~~~~

-  Jest + Testing Library configurado
-  Tests básicos (App.test.jsx, homeSlice.test.js)
-  Coverage CI/CD pendiente

v0.2.0 (Q1 2026)
~~~~~~~~~~~~~~~~

-  Tests para todos los módulos (dashboard, reports)
-  Coverage >80%
-  CI/CD bloquea merge si coverage baja

v0.3.0 (Q2 2026)
~~~~~~~~~~~~~~~~

-  E2E tests con Playwright
-  Visual regression tests (opcional)
-  Performance tests (Lighthouse CI)

Plan de Capacitación
--------------------

1. **Sesión 1 (2 horas)**: Fundamentos Jest
2. **Sesión 2 (2 horas)**: Testing Library philosophy
3. **Sesión 3 (2 horas)**: Mocking strategies
4. **Hands-on**: Escribir tests para componente nuevo
5. **Documentación**: README interno con ejemplos IACT

Notas
-----

-  Testing Library philosophy (“test como usuario”) es CRÍTICA
-  Tests NO deben depender de detalles de implementación
-  Coverage 80% es MÍNIMO, no máximo (más es mejor)
-  Revisar esta decisión en: **Q2 2026** (después de más experiencia)

--------------

**Decidido por**: Tech Lead Frontend, QA Lead **Fecha**: 2025-11-06
**Estado**: Aceptado
