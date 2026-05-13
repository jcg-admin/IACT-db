# Frontend Webpack — Guidelines

Reglas siempre activas para trabajar con Webpack en thyrox.

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
