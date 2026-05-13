```yml
name: frontend-webpack
description: "Skill de tecnología para configuración de Webpack. Usar cuando se trabaje en bundling, loaders, plugins, optimización de assets o configuración del build pipeline en el proyecto thyrox. Invocar durante Phase 3 ANALYZE para revisar la configuración de build, durante Phase 10 EXECUTE para modificar webpack.config.js, y durante Phase 11 TRACK/EVALUATE para auditar tamaño de bundles."
layer: frontend
framework: webpack
project: thyrox
```

# Frontend Webpack — SKILL

Guía fase-por-fase para trabajar con Webpack en el proyecto thyrox.

---

## Stage 3: DIAGNOSE — Qué investigar en la configuración de build

Al analizar un feature que toca el build pipeline, cubrir:
- Configuración actual — `webpack.config.js`, `webpack.common.js`, scripts de npm
- Loaders activos — ¿qué tipos de archivos se procesan y cómo?
- Plugins activos — ¿HtmlWebpackPlugin, MiniCssExtractPlugin, DefinePlugin?
- Tamaño del bundle actual — ejecutar `webpack --json | webpack-bundle-analyzer`
- Dev vs Prod — ¿hay configs separadas? ¿qué difiere?

## Phase 7: DESIGN/SPECIFY — Qué especificar para cambios de build

En `requirements-spec.md`, incluir:
- Entry/output paths — dónde entra el código y dónde sale el bundle
- Loaders requeridos — qué tipos de archivo necesita procesar el feature
- Variables de entorno — qué se inyecta con DefinePlugin por ambiente
- Splits de bundle requeridos — chunks por ruta, vendors separados

## Stage 10: IMPLEMENT — Convenciones de implementación

Ver sección INSTRUCTIONS para reglas específicas.

Orden de implementación recomendado:
1. Modificar `webpack.common.js` para cambios compartidos dev/prod
2. Modificar `webpack.dev.js` o `webpack.prod.js` para cambios específicos
3. Verificar build dev: `npx webpack --mode development`
4. Verificar build prod: `npx webpack --mode production`
5. Analizar bundle si hubo cambios de tamaño: `npx webpack-bundle-analyzer dist/`

## Phase 11: TRACK/EVALUATE — Qué revisar al cerrar

- Bundle de producción no creció más de un 10% sin justificación
- No hay módulos duplicados (verificar con bundle-analyzer)
- Source maps configurados correctamente (hidden-source-map en prod)
- Dev server arranca sin warnings de deprecación
- Variables de entorno sensibles no están en el bundle (`DefinePlugin` solo con valores públicos)
