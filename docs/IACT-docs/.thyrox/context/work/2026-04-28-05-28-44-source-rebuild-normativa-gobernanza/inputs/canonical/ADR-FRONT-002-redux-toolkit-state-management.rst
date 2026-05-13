ADR-016: Redux Toolkit para State Management (no Context API)
=============================================================

ESTO, VA LA MANO CON LA DECISION SOBRE

CONSULTAR ESTAS ESTRATEGIAS
---------------------------

-  Largest Contentful Paint (LCP) https://web.dev/articles/lcp?hl=es-419

-  Tiempo hasta el primer byte (TTFB)
   https://web.dev/articles/ttfb?hl=es-419

-  Primer procesamiento de imagen con contenido (FCP)
   https://web.dev/articles/fcp?hl=es-419

Estado
------

**Aceptado** - 2025-11-06

Contexto
--------

El frontend de IACT necesita gestionar estado complejo:

1. **Dashboard**: 10 widgets con datos independientes
2. **Reportes**: Filtros, datos tabulares, paginación
3. **Alertas**: Lista de alertas activas, historial
4. **Autenticación**: Usuario, tokens JWT, permisos
5. **Configuración global**: Tema, idioma, preferences

Requisitos de Estado
~~~~~~~~~~~~~~~~~~~~

-  **Performance crítico**: Dashboard <3s carga (RF-012)
-  **Estado compartido**: Datos de usuario usados en múltiples módulos
-  **Debugging**: Equipo necesita herramientas para debugging
-  **Testing**: Estado debe ser testeable aisladamente
-  **Persistencia**: Algunos datos deben persistir (JWT tokens)

Opciones Evaluadas
~~~~~~~~~~~~~~~~~~

Opción 1: Context API (React built-in)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Pros**: - Sin dependencias externas - Simple para casos básicos -
Integrado en React - Curva de aprendizaje baja

**Contras**: - **Performance**: Re-renders innecesarios con Context
grande - **No dev tools**: Sin Redux DevTools (crítico para debugging) -
**No middleware**: Sin side effects management (thunks, sagas) -
**Boilerplate custom**: Necesita abstracciones custom para
actions/reducers - **Testing complejo**: Requiere mocks de Context
providers

**Ejemplo problema performance**:

.. code:: javascript

   // Con Context API: TODOS los consumidores re-renderizan
   const AppContext = createContext({ user, widgets, alerts, ... });

   // Widget1 solo necesita 'widgets', pero re-renderiza si 'alerts' cambia

Opción 2: Zustand (State management ligero)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Pros**: - Muy ligero (1KB) - API simple similar a hooks - Performance
bueno - Dev tools disponible

**Contras**: - Ecosistema menor vs Redux - Middleware limitado - Menos
tooling (persist, dev tools menos maduro) - Equipo menos familiarizado

Opción 3: Redux Toolkit (SELECCIONADA)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Pros**: - **Redux DevTools**: Time-travel debugging, inspección de
estado - **Performance óptimo**: Selector memoization, re-renders
precisos - **Middleware robusto**: RTK Query para caching, thunks para
async - **Testing simple**: Reducers son funciones puras -
**Persistencia**: Redux-persist maduro y confiable - **Boilerplate
mínimo**: RTK elimina boilerplate de Redux clásico - **Ecosistema
maduro**: Amplia documentación, librerías, comunidad

**Contras**: - Dependencia externa (62KB gzipped) - Curva de aprendizaje
(conceptos: actions, reducers, selectors) - Overhead para casos simples
(overkill para app trivial)

Decisión
--------

Usar **Redux Toolkit** (RTK) como solución de state management.

Razones Principales
~~~~~~~~~~~~~~~~~~~

1. **Performance CRÍTICO**: Dashboard IACT <3s

   -  Redux con memoized selectors evita re-renders innecesarios
   -  Context API tendría problemas con 10 widgets compartiendo contexto

2. **Redux DevTools CRÍTICO**: Debugging esencial

   -  Time-travel debugging
   -  Inspección de acciones y estado
   -  Diff de cambios
   -  Export/import de estado para reproducir bugs

3. **Testing SIMPLE**: Reducers funciones puras

   .. code:: javascript

      // Test simple y predecible
      expect(dashboardReducer(state, setWidgets(newWidgets))).toEqual(expectedState);

4. **Middleware NECESARIO**: RTK Query para futuro

   -  Caching automático de API calls
   -  Invalidación de caché
   -  Optimistic updates

5. **Estructura CLARA**: Slices por módulo

   .. code:: javascript

      store = {
        appConfig: { ... },      // Global
        dashboard: { widgets },  // Módulo dashboard
        reports: { filters },    // Módulo reports
        alerts: { list },        // Módulo alerts
      }

Implementación
~~~~~~~~~~~~~~

Store Global
^^^^^^^^^^^^

.. code:: javascript

   // src/state/store.js
   import { configureStore } from '@reduxjs/toolkit';
   import appConfigReducer from './slices/appConfigSlice';
   import dashboardReducer from '@modules/dashboard/state/dashboardSlice';

   export const store = configureStore({
     reducer: {
       appConfig: appConfigReducer,
       dashboard: dashboardReducer,
       // Cada módulo agrega su slice
     },
     middleware: (getDefaultMiddleware) =>
       getDefaultMiddleware({
         serializableCheck: { /* ... */ },
       }),
     devTools: process.env.NODE_ENV !== 'production',
   });

Slice por Módulo
^^^^^^^^^^^^^^^^

.. code:: javascript

   // src/modules/dashboard/state/dashboardSlice.js
   import { createSlice } from '@reduxjs/toolkit';

   const dashboardSlice = createSlice({
     name: 'dashboard',
     initialState: {
       widgets: [],
       isLoading: false,
       lastUpdate: null,
     },
     reducers: {
       setWidgets: (state, action) => {
         state.widgets = action.payload;
         state.lastUpdate = new Date().toISOString();
       },
       setLoading: (state, action) => {
         state.isLoading = action.payload;
       },
     },
   });

   export const { setWidgets, setLoading } = dashboardSlice.actions;
   export default dashboardSlice.reducer;

Hook Personalizado
^^^^^^^^^^^^^^^^^^

.. code:: javascript

   // src/modules/dashboard/hooks/useDashboardData.js
   import { useSelector, useDispatch } from 'react-redux';
   import { setWidgets, setLoading } from '../state/dashboardSlice';

   export function useDashboardData() {
     const dispatch = useDispatch();
     const { widgets, isLoading, lastUpdate } = useSelector(
       (state) => state.dashboard
     );

     const loadWidgets = async () => {
       dispatch(setLoading(true));
       try {
         const response = await fetch('/api/dashboard/widgets');
         const data = await response.json();
         dispatch(setWidgets(data));
       } finally {
         dispatch(setLoading(false));
       }
     };

     return { widgets, isLoading, lastUpdate, loadWidgets };
   }

Convenciones Redux
~~~~~~~~~~~~~~~~~~

1. **Un slice por módulo**:
   ``modules/dashboard/state/dashboardSlice.js``
2. **Nombres de acciones**: camelCase (setWidgets, setLoading)
3. **Estado inmutable**: RTK usa Immer internamente (mutaciones
   “seguras”)
4. **Selectors memoizados**: Usar ``createSelector`` de reselect para
   computaciones costosas
5. **Async con thunks**: Para lógica asíncrona compleja

Consecuencias
-------------

Positivas
~~~~~~~~~

1. **Redux DevTools**: Debugging potente (time-travel, inspección)
2. **Performance óptimo**: Selector memoization, re-renders precisos
3. **Testing simple**: Reducers puros, fácil de testear
4. **Escalabilidad**: Añadir nuevos módulos es trivial (nuevo slice)
5. **Persistencia**: Redux-persist para JWT tokens
6. **Middleware**: RTK Query para caching API (futuro)

Negativas
~~~~~~~~~

1. **Dependencia externa**: 62KB gzipped (aceptable para dashboard
   complejo)
2. **Curva de aprendizaje**: Equipo debe aprender Redux (2-3 días)
3. **Boilerplate**: Más código vs Context API simple

Mitigaciones
~~~~~~~~~~~~

1. **Tamaño bundle**: Code splitting por módulo (lazy loading)
2. **Curva aprendizaje**: Training sesión de 4 horas, documentación
   interna
3. **Boilerplate**: RTK ya minimiza boilerplate (vs Redux clásico)

Métricas de Éxito
~~~~~~~~~~~~~~~~~

======================= ====================== ======================
Métrica                 Baseline (Context API) Target (Redux)
======================= ====================== ======================
Dashboard carga         ~5s (estimado)         <3s (RF-012)
Re-renders innecesarios Alto (Context)         Bajo (Selectors)
Time to debug bug       2-4 horas              30-60 min (DevTools)
Test coverage reducers  N/A                    >90% (funciones puras)
======================= ====================== ======================

Alternativas Rechazadas
-----------------------

Context API
~~~~~~~~~~~

Rechazado por: - Performance insuficiente para 10 widgets compartiendo
contexto - Sin Redux DevTools (crítico para debugging) - Re-renders
innecesarios - Testing más complejo

Zustand
~~~~~~~

Rechazado por: - Ecosistema menor vs Redux - Middleware menos maduro -
Equipo familiarizado con Redux (experiencia previa)

MobX
~~~~

Rechazado por: - Paradigma observable más complejo - Menor adopción en
comunidad React - Debugging menos transparente

Referencias
-----------

-  **Redux Toolkit**: https://redux-toolkit.js.org/
-  **Redux DevTools**: https://github.com/reduxjs/redux-devtools
-  **Reselect (Memoized Selectors)**:
   https://github.com/reduxjs/reselect
-  **RTK Query**: https://redux-toolkit.js.org/rtk-query/overview
-  **Requisito RF-012**: Dashboard 10 widgets <3s

Decisiones Relacionadas
-----------------------

-  **ADR-015**: Modular Monolith (estructura permite slices por módulo)
-  **ADR-018**: Webpack (code splitting para reducir bundle size)

Plan de Capacitación
--------------------

1. **Sesión 1 (2 horas)**: Fundamentos Redux (actions, reducers, store)
2. **Sesión 2 (2 horas)**: Redux Toolkit (slices, createAsyncThunk)
3. **Hands-on**: Crear slice nuevo para módulo de prueba
4. **Documentación**: README.md interno con ejemplos IACT

Notas
-----

-  Redux es OVERKILL para apps triviales, pero IACT es complejo (10
   widgets)
-  Si en futuro se simplifica (ej: solo 2-3 pantallas), reevaluar
   Context API
-  Revisar esta decisión en: **Q2 2026** (después de v1.0 en producción)

--------------

**Decidido por**: Tech Lead Frontend, Arquitecto de Software **Fecha**:
2025-11-06 **Estado**: Aceptado
