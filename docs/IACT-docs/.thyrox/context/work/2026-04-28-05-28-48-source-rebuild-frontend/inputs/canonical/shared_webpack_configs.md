---
id: DOC-FRONTEND-WEBPACK-CONFIGS
tipo: guia
estado: borrador
propietario: equipo-frontend
ultima_actualizacion: 2025-11-10
relacionados: ["DOC-ARQ-FRONTEND"]
date: 2025-11-13
---

# Shared Webpack configs para microfrontends single-spa

## Resumen

Los microfrontends basados en single-spa comparten una serie de configuraciones
de Webpack mantenidas en el repositorio `create-single-spa`. Estas plantillas
permiten alinear la salida del bundle (ES modules, SystemJS) y estandarizar el
consumo de dependencias compartidas mientras cada microfrontend mantiene su
ciclo de build independiente.

## Paquetes disponibles

### `webpack-config-single-spa`

* **Instalación**

  ```bash
  npm install --save-dev webpack-config-single-spa webpack-merge
  # o
  yarn add --dev webpack-config-single-spa webpack-merge
  ```

* **Uso base**

  ```javascript
  const singleSpaDefaults = require("webpack-config-single-spa");
  const { merge } = require("webpack-merge");

  module.exports = (webpackConfigEnv, argv) => {
    const defaultConfig = singleSpaDefaults({
      orgName: "name-of-company",
      projectName: "name-of-project",
      webpackConfigEnv,
      argv,
      orgPackagesAsExternal: true,
      outputSystemJS: false,
      importMapUrl: "https://react.microfrontends.app/importmap.json",
      rootDirectoryLevel: 1,
      disableHtmlGeneration: false,
    });

    return merge(defaultConfig, {
      // Modificaciones específicas del microfrontend
    });
  };
  ```

* **Cuándo usarlo**: Microfrontends genéricos (sin React/TypeScript) que
  requieren salida en formato ES modules y control detallado sobre externals.

### `webpack-config-single-spa-react`

* **Instalación**

  ```bash
  npm install --save-dev webpack-config-single-spa-react webpack-merge
  # o
  yarn add --dev webpack-config-single-spa-react webpack-merge
  ```

* **Uso base**

  ```javascript
  const singleSpaDefaults = require("webpack-config-single-spa-react");
  const { merge } = require("webpack-merge");

  module.exports = (webpackConfigEnv, argv) => {
    const defaultConfig = singleSpaDefaults({
      orgName: "name-of-company",
      projectName: "name-of-project",
      webpackConfigEnv,
      argv,
      orgPackagesAsExternal: true,
      rootDirectoryLevel: 1,
      standaloneOptions: {},
    });

    return merge(defaultConfig, {
      // Customizaciones React (aliases, plugins, loaders)
    });
  };
  ```

* **Cuándo usarlo**: Microfrontends React que heredan presets JSX, Fast Refresh
  y configuración de `standalone-single-spa-webpack-plugin`.

### `webpack-config-single-spa-ts`

* **Instalación**

  ```bash
  npm install --save-dev webpack-config-single-spa-ts webpack-merge
  # o
  yarn add --dev webpack-config-single-spa-ts webpack-merge
  ```

* **Uso base**

  ```javascript
  const singleSpaDefaults = require("webpack-config-single-spa-ts");
  const { smart: merge } = require("webpack-merge");

  module.exports = (webpackConfigEnv, argv) => {
    const defaultConfig = singleSpaDefaults({
      orgName: "name-of-company",
      projectName: "name-of-project",
      webpackConfigEnv,
      argv,
    });

    return merge(defaultConfig, {
      // Ajustes específicos de TypeScript
    });
  };
  ```

* **Cuándo usarlo**: Microfrontends escritos en TypeScript que necesitan loader
  y resolución TS listos para usar.

### `webpack-config-single-spa-react-ts`

* **Instalación**

  ```bash
  npm install --save-dev webpack-config-single-spa-react-ts webpack-merge
  # o
  yarn add --dev webpack-config-single-spa-react-ts webpack-merge
  ```

* **Uso base**

  ```javascript
  const singleSpaDefaults = require("webpack-config-single-spa-react-ts");
  const { smart: merge } = require("webpack-merge");

  module.exports = (webpackConfigEnv, argv) => {
    const defaultConfig = singleSpaDefaults({
      orgName: "name-of-company",
      projectName: "name-of-project",
      orgPackagesAsExternal: true,
      webpackConfigEnv,
      argv,
      rootDirectoryLevel: 1,
      disableHtmlGeneration: false,
    });

    return merge(defaultConfig, {
      // Ajustes combinados React + TypeScript
    });
  };
  ```

* **Cuándo usarlo**: Microfrontends React con TypeScript que buscan minimizar
  configuración manual.

## Extender las configuraciones compartidas

1. **Reutilizar loaders con `require.resolve`** para apuntar a dependencias
   provistas por los paquetes `webpack-config-single-spa-*` sin duplicar
   instalaciones.
2. **Unificar reglas con `mergeWithRules`** cuando se necesite extender loaders
   existentes (por ejemplo, cargar SVG como componentes con `@svgr/webpack`).
3. **Reemplazar plugins con `mergeWithCustomize`** para evitar instancias
   duplicadas (p.ej. `HtmlWebpackPlugin`).
4. **Modificar configuraciones existentes** usando `singleSpaDefaults.modifyConfig`
   cuando se parte de un objeto Webpack ya creado.

## Buenas prácticas

- Mantener un repositorio compartido del equipo con cualquier override común y
  consumirlo desde cada microfrontend.
- Documentar el uso de `importMapUrl` y las dependencias que se marcan como
  externals para evitar duplicidad de librerías en runtime.
- Revisar el output final con `console.dir(config, null, 2)` al depurar merges
  complejos.
- Actualizar los paquetes compartidos de forma coordinada para prevenir
  incompatibilidades en builds independientes.
