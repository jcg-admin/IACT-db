ADR-015: Frontend como Modular Monolith (no Microfrontends)
===========================================================

VALIDAR SI EL ADR-FRONT-001

NO TIENE QUE SER LA ELECCION DE WEBPACK+

Estado
------

**Aceptado** - 2025-11-06

Contexto
--------

El frontend de IACT (IVR Analytics & Customer Tracking) necesita una
arquitectura escalable que permita:

1. Desarrollo independiente de módulos (Dashboard, Reportes, Alertas,
   Admin)
2. Build y deploy simplificado
3. Performance optimo (dashboard debe cargar en <3 segundos)
4. Mantenibilidad a largo plazo con equipo pequeño (2-3 desarrolladores)

Opciones Evaluadas
~~~~~~~~~~~~~~~~~~

Opción 1: Microfrontends (Module Federation)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Pros**: - Despliegue independiente de módulos - Tecnologías diferentes
por módulo (React, Vue, etc) - Equipos completamente autónomos -
Escalabilidad organizacional

**Contras**: - Complejidad significativa (orquestación, comunicación
inter-apps) - Overhead de performance (múltiples bundles,
inicializaciones) - Duplicación de dependencias (React cargado múltiples
veces) - Testing end-to-end complejo - Requiere shared state complejo
(eventos custom, storage) - Overhead de CI/CD (múltiples pipelines)

Opción 2: Monolito Tradicional
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Pros**: - Simplicidad máxima - Build único y rápido - Testing
integrado natural

**Contras**: - Acoplamiento alto - Escalabilidad limitada (todo en un
directorio) - Refactorings globales riesgosos

Opción 3: Modular Monolith (SELECCIONADA)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Pros**: - Balance entre autonomía y simplicidad - Build único y deploy
único (simple CI/CD) - Performance óptimo (sin overhead microfrontends)
- Code splitting por módulo (lazy loading) - State management unificado
(Redux global) - Testing integrado natural - Refactorings globales
posibles - Migración futura a microfrontends si necesario

**Contras**: - Requiere disciplina de equipo (no acoplar módulos) - Una
tecnología para todos (React) - Deploy atómico (no por módulo)

Decisión
--------

Implementar el frontend como **Modular Monolith**:

Estructura de Módulos
~~~~~~~~~~~~~~~~~~~~~

::

   src/
   ├── app/                  Aplicación raíz
   ├── components/           Componentes compartidos
   ├── hooks/                Hooks compartidos
   ├── modules/              Módulos de negocio (AUTÓNOMOS)
   │   ├── dashboard/
   │   │   ├── hooks/
   │   │   ├── state/       Redux slice local
   │   │   ├── DashboardModule.jsx
   │   │   └── index.js
   │   ├── reports/
   │   ├── alerts/
   │   └── admin/
   ├── pages/                Páginas (componen módulos)
   ├── state/                Redux store global
   └── styles/               Estilos globales

Reglas de Módulos
~~~~~~~~~~~~~~~~~

1. **Encapsulación**: Módulos exportan solo su componente principal
   (index.js)
2. **Estado local**: Cada módulo tiene su propio slice de Redux
3. **Sin dependencias entre módulos**: Módulos NO importan otros módulos
4. **Comunicación vía Redux**: Si necesitan compartir datos, usar Redux
   store
5. **Lazy loading**: Módulos grandes con React.lazy() para code
   splitting

Ejemplo: Módulo Dashboard
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: javascript

   // src/modules/dashboard/index.js
   export { default } from './DashboardModule';

   // src/modules/dashboard/DashboardModule.jsx
   import { useDashboardData } from './hooks/useDashboardData';

   function DashboardModule() {
     const { widgets } = useDashboardData();
     return <div>{/* render widgets */}</div>;
   }

   export default DashboardModule;

   // src/modules/dashboard/state/dashboardSlice.js
   import { createSlice } from '@reduxjs/toolkit';

   const dashboardSlice = createSlice({
     name: 'dashboard',
     initialState: { widgets: [] },
     reducers: { /* ... */ },
   });

   // src/pages/DashboardPage.jsx
   import DashboardModule from '@modules/dashboard';

   function DashboardPage() {
     return <DashboardModule />;
   }

Beneficios Específicos para IACT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Performance**:

   -  Bundle único optimizado con code splitting
   -  Objetivo: Dashboard <3s (fácil de medir y optimizar)
   -  No overhead de comunicación entre microfrontends

2. **Desarrollo**:

   -  Equipo pequeño (2-3 devs) puede trabajar eficientemente
   -  Refactorings globales son viables (ej: cambiar librería UI)
   -  Debugging simple (un solo contexto)

3. **Deploy**:

   -  CI/CD simple: un build, un deploy
   -  Rollback completo (no inconsistencias entre versiones de módulos)
   -  Un solo ambiente (no orquestación)

4. **Mantenimiento**:

   -  Dependencias centralizadas (un package.json)
   -  Actualizaciones globales (ej: React 18 → 19)
   -  Testing E2E natural (todo en un contexto)

Consecuencias
-------------

Positivas
~~~~~~~~~

1. Simplicidad operacional (un repo, un build, un deploy)
2. Performance óptimo para dashboard IACT (<3s objetivo alcanzable)
3. Testing integrado natural
4. Curva de aprendizaje baja para nuevos desarrolladores
5. Herramientas estándar de React (no Module Federation)

Negativas
~~~~~~~~~

1. Requiere disciplina de equipo para mantener módulos desacoplados
2. Deploy atómico (un cambio en módulo X requiere redeploy completo)
3. Una sola tecnología (React) para todo
4. Escalabilidad organizacional limitada (equipos autónomos totalmente)

Mitigaciones
~~~~~~~~~~~~

1. **Disciplina**: Code reviews estrictos, linting de imports entre
   módulos
2. **Deploy atómico**: Aceptable dado el tamaño del sistema y equipo
3. **Tecnología única**: React es suficiente para todos los módulos IACT
4. **Escalabilidad**: Si el equipo crece >10 devs, reevaluar (ADR
   futuro)

Plan de Migración (Si necesario en futuro)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Si el sistema crece significativamente, la estructura modular facilita
migración a microfrontends:

::

   Paso 1: Módulos ya están encapsulados
   Paso 2: Separar cada módulo a su propio repo
   Paso 3: Implementar Module Federation
   Paso 4: Migrar módulo por módulo (gradual)

Alternativas Rechazadas
-----------------------

Microfrontends (Module Federation)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Rechazado por: - Complejidad innecesaria para equipo pequeño - Overhead
de performance (dashboard <3s crítico) - Sistema IACT no requiere
despliegue independiente por módulo

Monolito Tradicional (sin estructura modular)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Rechazado por: - Falta de escalabilidad (todo mezclado en un directorio)
- Acoplamiento alto (difícil mantener)

CONSULTAR ESTAS ESTRATEGIAS
---------------------------

-  Largest Contentful Paint (LCP) https://web.dev/articles/lcp?hl=es-419

-  Tiempo hasta el primer byte (TTFB)
   https://web.dev/articles/ttfb?hl=es-419

-  Primer procesamiento de imagen con contenido (FCP)
   https://web.dev/articles/fcp?hl=es-419

Referencias
-----------

-  **Modular Monolith**:
   https://www.kamilgrzybek.com/blog/posts/modular-monolith-primer

https://parceljs.org/recipes/react/#code-splitting

https://react.dev/learn/build-a-react-app-from-scratch#code-splitting

-  **React Code Splitting**:
   https://reactjs.org/docs/code-splitting.html
-  **Redux Toolkit**: https://redux-toolkit.js.org/
-  **Requisito RF-012**: Dashboard con 10 widgets (carga <3s)

Decisión Relacionadas
---------------------

-  **ADR-016**: Redux Toolkit para state management
-  **ADR-018**: Webpack para bundling (code splitting)

Notas
-----

Esta decisión es reversible si: - Equipo crece >10 desarrolladores
frontend - Se requiere despliegue independiente por módulo - Performance
no se puede lograr (<3s)

Revisar esta decisión en: **Q2 2026** (6 meses después de lanzamiento
v1.0)

--------------

**Decidido por**: Tech Lead Frontend, Arquitecto de Software **Fecha**:
2025-11-06 **Estado**: Aceptado
