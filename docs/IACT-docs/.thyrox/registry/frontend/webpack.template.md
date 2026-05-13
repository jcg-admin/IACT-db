<!-- SKILL_START -->
```yml
name: frontend-webpack
description: "Skill de tecnología para configuración de Webpack. Usar cuando se trabaje en bundling, loaders, plugins, optimización de assets o configuración del build pipeline en el proyecto {{PROJECT_NAME}}. Invocar durante Phase 1 ANALYZE para revisar la configuración de build, durante Phase 6 EXECUTE para modificar webpack.config.js, y durante Phase 7 TRACK para auditar tamaño de bundles."
layer: frontend
framework: webpack
project: {{PROJECT_NAME}}
```

# {{LAYER_TITLE}} {{FRAMEWORK_TITLE}} — SKILL

Guía fase-por-fase para trabajar con Webpack en el proyecto {{PROJECT_NAME}}.

---

## Phase 1: ANALYZE — Qué investigar en la configuración de build

Al analizar un feature que toca el build pipeline, cubrir:
- Configuración actual — `webpack.config.js`, `webpack.common.js`, scripts de npm
- Loaders activos — ¿qué tipos de archivos se procesan y cómo?
- Plugins activos — ¿HtmlWebpackPlugin, MiniCssExtractPlugin, DefinePlugin?
- Tamaño del bundle actual — ejecutar `webpack --json | webpack-bundle-analyzer`
- Dev vs Prod — ¿hay configs separadas? ¿qué difiere?

## Phase 4: STRUCTURE — Qué especificar para cambios de build

En `requirements-spec.md`, incluir:
- Entry/output paths — dónde entra el código y dónde sale el bundle
- Loaders requeridos — qué tipos de archivo necesita procesar el feature
- Variables de entorno — qué se inyecta con DefinePlugin por ambiente
- Splits de bundle requeridos — chunks por ruta, vendors separados

## Phase 6: EXECUTE — Convenciones de implementación

Ver sección INSTRUCTIONS para reglas específicas.

Orden de implementación recomendado:
1. Modificar `webpack.common.js` para cambios compartidos dev/prod
2. Modificar `webpack.dev.js` o `webpack.prod.js` para cambios específicos
3. Verificar build dev: `npx webpack --mode development`
4. Verificar build prod: `npx webpack --mode production`
5. Analizar bundle si hubo cambios de tamaño: `npx webpack-bundle-analyzer dist/`

## Phase 7: TRACK — Qué revisar al cerrar

- Bundle de producción no creció más de un 10% sin justificación
- No hay módulos duplicados (verificar con bundle-analyzer)
- Source maps configurados correctamente (hidden-source-map en prod)
- Dev server arranca sin warnings de deprecación
- Variables de entorno sensibles no están en el bundle (`DefinePlugin` solo con valores públicos)
<!-- SKILL_END -->

<!-- INSTRUCTIONS_START -->
# {{LAYER_TITLE}} {{FRAMEWORK_TITLE}} — Guidelines

Reglas siempre activas para trabajar con Webpack en {{PROJECT_NAME}}.

## Separar configs por ambiente

```javascript
// CORRECTO — webpack.common.js
const { merge } = require('webpack-merge');
const common = require('./webpack.common.js');

module.exports = merge(common, {
  mode: 'development',
  devtool: 'eval-source-map',
  devServer: { hot: true, port: 3000 },
});

// INCORRECTO — config única con condicionales
module.exports = {
  mode: process.env.NODE_ENV,
  // ... mezcla de dev y prod en un solo archivo
};
```

## Content hash en producción para cache busting

```javascript
// CORRECTO — producción
output: {
  filename: '[name].[contenthash].js',
  chunkFilename: '[name].[contenthash].chunk.js',
  clean: true,
}

// INCORRECTO — sin hash, el browser cachea el bundle viejo
output: {
  filename: 'bundle.js',
}
```

## Asset modules nativos (Webpack 5) — no usar file-loader

```javascript
// CORRECTO — Webpack 5 nativo
module: {
  rules: [
    { test: /\.(png|jpg|gif|svg)$/, type: 'asset/resource' },
    { test: /\.(woff|woff2|ttf|eot)$/, type: 'asset/resource' },
  ]
}

// INCORRECTO — file-loader es legacy en Webpack 5
{ test: /\.(png|jpg)$/, use: ['file-loader'] }
```

## MiniCssExtractPlugin en producción, style-loader en desarrollo

```javascript
// CORRECTO
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const isProd = process.env.NODE_ENV === 'production';

rules: [{
  test: /\.css$/,
  use: [
    isProd ? MiniCssExtractPlugin.loader : 'style-loader',
    'css-loader',
  ],
}]

// INCORRECTO — style-loader en producción inyecta CSS via JS (más lento)
use: ['style-loader', 'css-loader']
```

## Code splitting con dynamic import

```javascript
// CORRECTO — lazy load de ruta pesada
const HeavyPage = React.lazy(() =>
  import(/* webpackChunkName: "heavy-page" */ './pages/HeavyPage')
);

// INCORRECTO — todo en el bundle principal
import HeavyPage from './pages/HeavyPage';
```

## Alias para evitar paths relativos profundos

```javascript
// CORRECTO — webpack.common.js
resolve: {
  alias: { '@': path.resolve(__dirname, 'src/') },
  extensions: ['.ts', '.tsx', '.js', '.jsx'],
}
// Uso: import Button from '@/components/Button'

// INCORRECTO
import Button from '../../../components/Button'
```
<!-- INSTRUCTIONS_END -->
