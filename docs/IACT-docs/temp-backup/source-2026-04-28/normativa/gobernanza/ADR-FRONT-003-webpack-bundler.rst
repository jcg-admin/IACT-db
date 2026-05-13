ADR-018: Webpack como Bundler (no Vite)
=======================================

CONSIDERAR ACTUALIZAR CON : Webpack como Bundler (Actualización de
Optimización)

Estado
------

**Aceptado** - 2025-11-06

Contexto
--------

El frontend IACT necesita un bundler para:

1. Transpilar JSX y ES6+ a JavaScript compatible
2. Bundle de múltiples módulos en archivos optimizados
3. Code splitting para lazy loading de módulos
4. Dev server con Hot Module Replacement (HMR)
5. Optimizaciones para producción (minificación, tree shaking)

Requisitos de Build
~~~~~~~~~~~~~~~~~~~

-  **Desarrollo**: HMR rápido, <2s rebuild
-  **Producción**: Bundle optimizado <500KB gzipped
-  **Path aliases**: @app, @modules, @components
-  **Code splitting**: Por módulo (lazy loading)
-  **CSS**: Style loader + CSS loader
-  **Compatibilidad**: Navegadores últimas 2 versiones

Opciones Evaluadas
~~~~~~~~~~~~~~~~~~

Opción 1: Vite
^^^^^^^^^^^^^^

**Pros**: - **Dev server ultra rápido**: ESM nativo, sin bundling en dev
- **HMR instantáneo**: <100ms rebuild - **Configuración mínima**:
Out-of-the-box funciona - **Plugins modernos**: Ecosystem creciendo
rápido - **Build rápido**: Usa esbuild (Go) para pre-bundling

**Contras**: - **Ecosystem menos maduro**: Menos plugins vs Webpack (ej:
alias complejos) - **Configuración avanzada limitada**: Para casos edge,
menos flexible - **Producción usa Rollup**: Dos bundlers diferentes
(dev: esbuild, prod: rollup) - **Compatibilidad legacy**: Requiere
plugin extra para navegadores viejos - **Menor adopción enterprise**:
Webpack más establecido en empresas

Opción 2: Parcel
^^^^^^^^^^^^^^^^

**Pros**: - Zero config - Rápido - Simple

**Contras**: - Configuración custom limitada - Menor ecosystem - Menos
adopción que Webpack/Vite

Opción 3: Webpack (SELECCIONADA)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Pros**: - **Ecosystem maduro**: Miles de loaders y plugins -
**Configuración explícita**: Control total sobre build - **Code
splitting avanzado**: SplitChunksPlugin robusto - **Compatibilidad
probada**: Años de producción en empresas - **Docs extensas**: Cualquier
problema tiene solución documentada - **Consistencia**: Mismo bundler
dev y prod - **Path aliases**: Configuración simple y predecible

**Contras**: - **Dev server más lento**: ~2-3s rebuild vs <100ms de Vite
- **Configuración verbosa**: Requiere webpack.config.cjs explícito -
**Curva de aprendizaje**: Conceptos: loaders, plugins, chunks

Decisión
--------

Usar **Webpack 5** como bundler.

Razones Principales
~~~~~~~~~~~~~~~~~~~

1. **Ecosystem maduro CRÍTICO**:

   -  Path aliases configuración simple y confiable
   -  HtmlWebpackPlugin para index.html
   -  Babel loader integración probada
   -  Style loader + CSS loader estándar

2. **Code splitting avanzado**:

   -  SplitChunksPlugin configuración granular
   -  Lazy loading por módulo con React.lazy()
   -  Vendor chunk separation (React, Redux separate)

3. **Configuración explícita**:

   -  Control total sobre optimizaciones
   -  Predecible: mismo config en todos los ambientes
   -  Fácil de debuggear configuración

4. **Compatibilidad empresarial**:

   -  Webpack más aceptado en empresas (ej: Django + Webpack común)
   -  Documentación extensa para casos edge
   -  Comunidad grande

5. **Consistencia**:

   -  Mismo bundler en desarrollo y producción
   -  Comportamiento predecible

Implementación
~~~~~~~~~~~~~~

.. code:: javascript

   // webpack.config.cjs
   const path = require('path');
   const HtmlWebpackPlugin = require('html-webpack-plugin');

   module.exports = (env) => {
     const isProduction = env.production === true;

     return {
       mode: isProduction ? 'production' : 'development',
       entry: './src/index.jsx',
       output: {
         path: path.resolve(__dirname, 'dist'),
         filename: isProduction ? '[name].[contenthash].js' : '[name].js',
         clean: true,
         publicPath: '/',
       },
       devServer: {
         port: 3000,
         hot: true,
         historyApiFallback: true,
       },
       module: {
         rules: [
           {
             test: /\.jsx?$/,
             exclude: /node_modules/,
             use: 'babel-loader',
           },
           {
             test: /\.css$/,
             use: ['style-loader', 'css-loader'],
           },
         ],
       },
       resolve: {
         extensions: ['.js', '.jsx'],
         alias: {
           '@app': path.resolve(__dirname, 'src/app'),
           '@modules': path.resolve(__dirname, 'src/modules'),
           '@components': path.resolve(__dirname, 'src/components'),
           '@hooks': path.resolve(__dirname, 'src/hooks'),
           '@styles': path.resolve(__dirname, 'src/styles'),
           '@state': path.resolve(__dirname, 'src/state'),
         },
       },
       plugins: [
         new HtmlWebpackPlugin({
           template: './public/index.html',
         }),
       ],
       devtool: isProduction ? 'source-map' : 'eval-source-map',
       optimization: {
         splitChunks: isProduction
           ? {
               chunks: 'all',
               cacheGroups: {
                 vendor: {
                   test: /[\\/]node_modules[\\/]/,
                   name: 'vendors',
                   priority: 10,
                 },
                 common: {
                   minChunks: 2,
                   priority: 5,
                   reuseExistingChunk: true,
                 },
               },
             }
           : false,
       },
     };
   };

Path Aliases
~~~~~~~~~~~~

Configurados en ``webpack.config.cjs`` > resolve.alias:

.. code:: javascript

   import App from '@app/App';                    // src/app/
   import HomeModule from '@modules/home';        // src/modules/
   import MainLayout from '@components/MainLayout'; // src/components/

Beneficios: - Imports limpios sin ``../../../../`` - Refactoring más
fácil (cambiar ubicación sin romper imports) - Autocomplete en IDEs
funciona

Code Splitting
~~~~~~~~~~~~~~

.. code:: javascript

   // Lazy loading de módulos
   const DashboardModule = React.lazy(() => import('@modules/dashboard'));
   const ReportsModule = React.lazy(() => import('@modules/reports'));

   // Resultado: dashboard.chunk.js, reports.chunk.js
   // Solo se cargan cuando usuario navega a esa sección

Optimizaciones Producción
~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Minificación**: Terser (built-in Webpack 5)
2. **Tree shaking**: Eliminar código no usado
3. **Cache busting**: [contenthash] en nombres archivos
4. **Vendor separation**: React/Redux en chunk separado (cache
   long-term)
5. **Source maps**: Para debugging en producción

Consecuencias
-------------

Positivas
~~~~~~~~~

1. **Configuración explícita**: Control total, predecible
2. **Ecosystem maduro**: Cualquier problema tiene solución
3. **Code splitting robusto**: SplitChunksPlugin avanzado
4. **Path aliases**: Imports limpios en toda la app
5. **Consistencia**: Mismo bundler dev/prod

Negativas
~~~~~~~~~

1. **Dev server más lento**: ~2-3s rebuild (vs <100ms Vite)
2. **Configuración verbosa**: webpack.config.cjs ~100 líneas
3. **Curva de aprendizaje**: Conceptos Webpack más complejos

Mitigaciones
~~~~~~~~~~~~

1. **Dev server lento**: Aceptable para equipo pequeño (2-3 devs)
2. **Configuración verbosa**: Una sola vez, luego estable
3. **Curva aprendizaje**: Documentación interna, ejemplos

Métricas
~~~~~~~~

======================= ====== ==============================
Métrica                 Target Actual (Medido en v0.1.0)
======================= ====== ==============================
Dev rebuild             <3s    ~2s (aceptable)
Bundle size (gzipped)   <500KB TBD (medir después de módulos)
Build time (producción) <60s   ~15s (sin módulos aún)
======================= ====== ==============================

Alternativas Rechazadas
-----------------------

Vite
~~~~

Rechazado por: - Ecosystem menos maduro (menos plugins) - Configuración
avanzada limitada (path aliases complejos) - Dos bundlers diferentes
(dev: esbuild, prod: rollup) - Menor adopción enterprise

**Nota**: Reevaluar Vite en Q2 2026. Si ecosystem madura, migración es
posible.

Parcel
~~~~~~

Rechazado por: - Configuración custom muy limitada - Menor ecosystem que
Webpack - Menos control sobre optimizaciones

Referencias
-----------

-  **Webpack 5**: https://webpack.js.org/
-  **HtmlWebpackPlugin**:
   https://github.com/jantimon/html-webpack-plugin
-  **Babel Loader**: https://github.com/babel/babel-loader
-  **Code Splitting**: https://webpack.js.org/guides/code-splitting/

Decisiones Relacionadas
-----------------------

-  **ADR-015**: Modular Monolith (code splitting por módulo)
-  **ADR-016**: Redux Toolkit (bundle size considerado)

Plan de Migración a Vite (Si futuro)
------------------------------------

Si Vite madura suficientemente:

1. **Paso 1**: Probar Vite en branch experimental
2. **Paso 2**: Medir performance (dev rebuild, bundle size)
3. **Paso 3**: Validar path aliases funcionan igual
4. **Paso 4**: Migrar configuración Webpack → Vite
5. **Paso 5**: Actualizar CI/CD
6. **Paso 6**: Deploy gradual (canary)

Complejidad: **Media** (configuraciones similares)

Notas
-----

-  Webpack es **overkill** para apps triviales, pero IACT necesita code
   splitting robusto
-  Dev server ~2-3s rebuild es ACEPTABLE para equipo pequeño
-  Si en futuro equipo crece y dev rebuild se vuelve bottleneck,
   reevaluar Vite
-  Revisar esta decisión en: **Q2 2026** (después de medir métricas
   reales)

--------------

**Decidido por**: Tech Lead Frontend **Fecha**: 2025-11-06 **Estado**:
Aceptado
