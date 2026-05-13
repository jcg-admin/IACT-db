# Instalar y validar GitHub Copilot CLI

## Contexto
Procedimiento para instalar [GitHub Copilot CLI](https://githubnext.com/projects/copilot-cli/) en servidores de soporte y validar que el comando `copilot` queda disponible en el entorno shell.

## Requisitos previos
- Node.js 18+ y npm disponibles en el sistema (se recomienda Node 22+ y npm 10+ para alinear con los scripts del repositorio).
- Acceso con privilegios para instalar paquetes globales (`npm install -g`).
- Conexión a Internet hacia los repositorios de npm (o acceso al proxy corporativo autorizado).

## Pasos
1. Actualizar la caché de npm (opcional pero recomendado en entornos compartidos):
   ```bash
   npm cache verify
   ```
2. Verificar la conectividad de npm a `https://registry.npmjs.org` (útil cuando existe un proxy corporativo):
   ```bash
   npm ping --registry https://registry.npmjs.org
   ```
   - Si el comando responde con `ping ok`, se puede continuar.
   - En caso de error `403 Forbidden` revisar la sección de *Solución de problemas*.
3. Instalar la CLI de GitHub Copilot de forma global. El paquete oficial publicado por GitHub es `@github/copilot`:
   ```bash
   npm install -g @github/copilot
   ```
4. Confirmar que el ejecutable `copilot` quedó en el `PATH`:
   ```bash
   which copilot
   ```
5. Ejecutar un comando de ayuda para validar que responde correctamente:
   ```bash
   copilot --help
   ```
6. Registrar la versión instalada:
   ```bash
   copilot --version
   ```

## Solución de problemas
- **403 Forbidden a través del proxy corporativo**
  - Revisar las variables de entorno `HTTP_PROXY`, `HTTPS_PROXY`, `NO_PROXY`, `npm_config_*`. Asegurarse de que apuntan a un proxy válido y con credenciales vigentes.
  - Si el proxy no admite túneles `CONNECT` hacia npmjs.org, solicitar la liberación del dominio o realizar la instalación desde una red con acceso directo.
  - Como verificación rápida se puede deshabilitar temporalmente las variables de proxy en la misma sesión:
    ```bash
    env -u http_proxy -u https_proxy -u HTTP_PROXY -u HTTPS_PROXY \
      -u npm_config_http_proxy -u npm_config_https_proxy \
      npm ping --registry https://registry.npmjs.org
    ```
    Si el comando deja de fallar por `403` pero pasa a `ENOTFOUND`/`ECONNREFUSED`, es indicativo de que la salida directa a Internet está bloqueada y se requiere el proxy corporativo.
- **`copilot` no aparece en el PATH**
  - Ejecutar `npm config get prefix` para ubicar la ruta global.
  - Añadir `<prefix>/bin` al `PATH` del usuario (por ejemplo, exportándolo en `~/.bashrc`).
- **Versiones antiguas de Node/npm**
  - Actualizar Node.js mediante NVM o el gestor corporativo para alcanzar `node >= 22` y `npm >= 10`, tal como valida `infrastructure/devcontainer/scripts/post-create.sh`.

## Validaciones
- `npm ping` responde sin errores y confirma conectividad.
- `which copilot` devuelve una ruta válida dentro de `node_modules` globales.
- `copilot --help` y `copilot --version` muestran la ayuda y la versión de la CLI respectivamente.

## Evidencias sugeridas
- Captura o log del comando `copilot --version`.
- Bitácora de la instalación (`npm install -g @github/copilot`).
- Evidencia de conectividad (`npm ping`) en entornos con proxy.
