---
id: RB-DEVOPS-004
estado: vigente
propietario: equipo-devops
ultima_actualizacion: 2025-02-16
relacionados: ["DOC-OPS-001", "playbooks_operativos/copilot_codespaces.md"]
---
# Runbook de verificación: GitHub Copilot y Codespaces

Este runbook confirma que el Codespace corporativo deja lista la integración con GitHub Copilot y registra las evidencias clave descritas en `playbooks_operativos/copilot_codespaces.md`.

## 1. Matriz de cumplimiento

| Requisito | Evidencia | Validación |
|-----------|-----------|------------|
| Extensiones `github.copilot` y `github.copilot-chat` preinstaladas | `.devcontainer/devcontainer.json` → `customizations.vscode.extensions` | Ambas extensiones figuran junto al stack Python/SQL y se distribuyen en cada Codespace. |
| Políticas `github.copilot.enable` aplicadas | `.devcontainer/devcontainer.json` → `customizations.vscode.settings` | El ajuste deshabilita Copilot en texto plano y entradas de commit conforme a las políticas de seguridad. |
| Scripts centralizados para aprovisionamiento | `infrastructure/devcontainer/scripts/post_create.sh` y `post-start.sh` | Los comandos de bootstrap se ejecutan desde el repositorio y persisten logs en `infrastructure/devcontainer/logs/`. |
| Validación automática de Django | `post_create.sh` ejecuta `python manage.py check` tras instalar dependencias. | El resultado queda trazado en `post_create.log`. |
| Smoke test de `pytest` no bloqueante | `post_create.sh` ejecuta `python -m pytest --maxfail=1 --disable-warnings -q` por defecto y solo registra advertencias ante fallos. | Garantiza visibilidad temprana sin frenar la creación del Codespace. |
| Banderas de aprovisionamiento controladas | `.devcontainer/devcontainer.json` → `containerEnv.DEVCONTAINER_*` | Permiten habilitar/omitir instalación de Copilot, pruebas automáticas y diagnósticos de npm según la necesidad. |
| Verificación en el arranque | `post-start.sh` relanza `python manage.py check` al iniciarse el contenedor remoto. | La salida se guarda en `post-start.log` para diagnóstico. |
| Copilot CLI preparado | `post_create.sh` valida `node >=22` y `npm >=10`, ejecuta `npm-diagnostics.sh` (log en `infrastructure/devcontainer/logs/npm-diagnostics.log`) e instala `@github/copilot`. | La instalación cumple el flujo "install once, authenticate, work" sin pasos manuales y conserva trazas para soporte. |
| Bootstrap de variables de entorno | `post_create.sh` copia `env.example` → `env` en `api/callcentersite/` si el archivo no existe. | Evita errores en `manage.py` tras el primer arranque. |

## 2. Procedimiento de auditoría rápida

1. **Reconstruir Codespace**
   ```bash
   Codespaces: Rebuild Container
   ```
   - Revisar `infrastructure/devcontainer/logs/post_create.log` y confirmar que no existan errores fatales de `pip`.
   - Verificar que el bloque `[post_create] Ejecutando pytest` aparezca incluso cuando existan fallos en las pruebas.
   - Consultar `infrastructure/devcontainer/logs/npm-diagnostics-*.log` para validar `npm ping`, registry y configuración de proxy registrada automáticamente.
2. **Verificar Copilot CLI**
   ```bash
   gh auth status
   gh copilot status
   node --version
   npm --version
   copilot
   ```
   - Confirmar que la CLI responda, que las versiones cumplan `node >=22` / `npm >=10` y que la sesión pertenezca a la cuenta corporativa.
3. **Solicitar sugerencia en VS Code**
   - Abrir un archivo Python y usar `Ctrl+Enter` para pedir una propuesta de código.
   - Comprobar la barra de estado de VS Code: debe mostrar “GitHub Copilot: conectado”.
4. **Ejecutar pruebas manuales**
   ```bash
   cd api/callcentersite
   python -m pytest --maxfail=1
   ```
   - Registrar cobertura ≥80 % y adjuntar la salida al ticket o wiki correspondiente.
5. **Actualizar documentación**
   - Registrar fecha, persona responsable y hallazgos en la wiki interna.
   - Escalar incidentes de firewall con logs adjuntos y referencias a dominios bloqueados.

## 3. Manejo de incidentes

1. **Diagnóstico inicial**
   - Ejecutar `gh auth status` y `gh copilot status` para confirmar autenticación.
   - Validar que las variables de entorno de proxy sigan presentes en el Codespace (`printenv | grep -i proxy`).
2. **Recolección de evidencias**
   - Guardar capturas de los mensajes de la extensión y de la barra de estado.
   - Documentar dominios o puertos bloqueados reportados en el firewall.
3. **Contención**
   - Indicar a la persona desarrolladora que continúe con el flujo TDD estándar mientras se gestiona la apertura de red.
   - Mantener actualizado el ticket hasta recibir confirmación de que Copilot vuelve a conectarse.

## 4. Checklist para entrega semanal

- [ ] `post_create.log` y `post-start.log` sin errores críticos.
- [ ] Copilot CLI instalado (`copilot --version`) y accesible desde la terminal.
- [ ] Extensiones de Copilot visibles en VS Code.
- [ ] `pytest` ejecutado automáticamente tras la reconstrucción del contenedor.
- [ ] Documentación interna actualizada con hallazgos y bloqueos.

## 5. Guía rápida para el equipo

1. **Instala y autentica**
   - Sigue el resumen de los apartados §6.1 y §6.2 para dejar lista la CLI y validar la sesión corporativa.
2. **Conoce el repositorio**
   - Consulta el flujo descrito en §6.3 para recopilar el layout y el estado del entorno.
3. **Encuentra trabajo relevante**
   - Prioriza issues con el procedimiento §6.4 y registra evidencias en la wiki.
4. **Implementa con control**
   - Mantén el ciclo TDD utilizando los pasos guiados de §6.5 y verifica comandos antes de ejecutarlos.
5. **Prepara la entrega**
   - Aplica las convenciones corporativas apoyándote en §6.6.
6. **Resuelve incidentes operativos**
   - Revisa §6.7 y §6.8 para liberar recursos y gestionar extensiones MCP.

> **Tip:** ante restricciones de red persistentes, coordinar con TI la creación de un túnel temporal usando la VPN corporativa oficial antes de iniciar Codespaces.

## 6. Recetario de Copilot CLI

### 6.1 Instalación automatizada

- El script `infrastructure/devcontainer/scripts/post_create.sh` valida versiones (`node --version`, `npm --version`) y exige `node >=22` y `npm >=10` antes de instalar la CLI.
- Cuando `DEVCONTAINER_INSTALL_COPILOT_CLI=1` (valor por defecto) se ejecuta `infrastructure/devcontainer/scripts/npm-diagnostics.sh` y el resultado queda en `infrastructure/devcontainer/logs/npm-diagnostics.log`; adjunta este archivo al ticket de soporte cuando existan fallos de red o permisos.
- Para omitir tanto la instalación como la recopilación de diagnósticos establece `DEVCONTAINER_INSTALL_COPILOT_CLI=0` en `devcontainer.json` o en los Secrets del Codespace y reconstruye el contenedor.
- El script de diagnósticos acepta `DEVCONTAINER_NPM_DIAGNOSTICS_DRY_RUN=1` para ejecutar `npm install -g @github/copilot --dry-run --verbose` y registrar la traza completa; deja el valor `0` (por defecto) si no requieres el volcado detallado.
- La instalación se realiza con:
  ```bash
  npm install -g @github/copilot
  copilot --help
  ```
- Si `copilot` no queda disponible, revisar `~/.npm-global/bin` y ajustar `PATH` en `.bashrc`.
- Registrar en la bitácora `post_create.log` la línea `[post_create] Copilot CLI disponible`.
- El script genera un informe adicional `npm-diagnostics-<fecha>.log` con `npm ping`, proxies configurados y contenidos de `.npmrc`; adjúntalo en cualquier ticket de red.

#### 6.1.1 Error `403 Forbidden` al instalar `@github/copilot`

En entornos corporativos con proxies estrictos puede aparecer el error:

```text
npm ERR! code E403
npm ERR! 403 403 Forbidden - GET https://registry.npmjs.org/@github%2fcopilot - request forbidden by corporate proxy
```

**Causa.** `@github/copilot` se publica en el registro público `https://registry.npmjs.org/`. El error suele ocurrir cuando el proxy o
mirror corporativo bloquea el paquete (por ejemplo, Artifactory mal configurado), fuerza autenticación con credenciales externas
o intercepta las solicitudes `@github/*`. En estos casos `npm` no debe apuntar a `npm.pkg.github.com` ni requiere tokens con
`read:packages`.

**Solución.** Restablecer la configuración de `npm` para usar el registro público oficial, validar la ruta a través del proxy y, si el bloqueo
persiste, escalar a la mesa de redes con evidencias:

```bash
npm config delete @github:registry            # elimina overrides heredados
npm config set registry https://registry.npmjs.org/
npm config delete //npm.pkg.github.com/:_authToken || true
npm cache clean --force
npm ping                                      # verifica conectividad con el registro público
npm install -g @github/copilot
```

> **Seguimiento:** si `npm ping` también devuelve `403`, abrir ticket con el equipo de redes adjuntando la hora, IP del proxy y la URL
> bloqueada. Para instalaciones críticas, solicitar whitelist temporal del dominio `registry.npmjs.org` y del scope `@github`.

> **Banderas útiles:**
> - `DEVCONTAINER_INSTALL_COPILOT_CLI=0` omite la instalación automática (útil si el equipo de redes está depurando manualmente).
> - `DEVCONTAINER_CAPTURE_NPM_DIAGNOSTICS=0` evita generar logs extra cuando no son necesarios.
> - `DEVCONTAINER_NPM_DIAGNOSTICS_DRY_RUN=1` añade un `npm install --dry-run --verbose` al reporte para reproducir el error.

#### 6.1.1 Error `403 Forbidden` al instalar `@github/copilot`

En entornos restringidos puede aparecer el error:

```text
npm ERR! code E403
npm ERR! 403 403 Forbidden - GET https://registry.npmjs.org/@github%2fcopilot - no hay permiso para acceder al registro
```

**Causa.** El paquete `@github/copilot` vive en el registro privado `https://npm.pkg.github.com` y exige autenticación con un token
personal de GitHub que tenga el scope `read:packages`. Cuando `npm` intenta descargarlo desde `registry.npmjs.org` sin esa
configuración, el proxy corporativo responde `403`.

**Solución.** Configurar `npm` para usar el registro correcto y autenticar la sesión antes de ejecutar el script automatizado:

```bash
export GITHUB_TOKEN="<token-con-read:packages>"
printf "@github:registry=https://npm.pkg.github.com\n//npm.pkg.github.com/:_authToken=%s\n" "$GITHUB_TOKEN" > "$HOME/.npmrc"
npm config set @github:registry https://npm.pkg.github.com
npm config set //npm.pkg.github.com/:_authToken "$GITHUB_TOKEN"
npm install -g @github/copilot --registry=https://npm.pkg.github.com
```

> **Nota:** guarda el token en el gestor de secretos corporativo y nunca lo incluyas en commits ni variables compartidas. Si el
entorno no permite escribir en `$HOME/.npmrc`, exporta `NPM_CONFIG_USERCONFIG` apuntando a un archivo dentro de
`infrastructure/devcontainer/logs/` con permisos adecuados y reutiliza la configuración anterior.

### 6.2 Autenticación y validaciones

1. Lanzar la CLI:
   ```bash
   copilot
   /login
   ```
2. Autenticar con una cuenta que tenga plan Copilot Pro/Pro+/Business/Enterprise.
3. Confirmar que la sesión quedó enlazada:
   ```bash
   gh auth status
   gh copilot status
   ```
4. Documentar en la wiki: fecha, responsable, tipo de red, resultado y si fue necesario ejecutar `/reset`.

### 6.3 Arranque rápido del repositorio

1. Solicitar un resumen del proyecto:
   ```text
   Explain the layout of this project.
   ```
2. Verificar dependencias y entorno:
   ```text
   Make sure my environment is ready to build this project.
   ```
3. Confirmar que Copilot enlistó comandos como `python manage.py check` y la instalación de Go cuando corresponda.
4. Registrar la respuesta en la wiki de onboarding.

### 6.4 Rastreo de issues y priorización

1. Usar el MCP de GitHub integrado:
   ```text
   Find good first issues in this repository and rank them by difficulty.
   ```
2. Validar que cada issue incluya enlace, tags y justificación de dificultad.
3. Documentar el issue seleccionado, responsable y decisión tomada en la wiki interna.

### 6.5 Flujo de implementación asistida

1. Crear un branch siguiendo la convención `feature/<ticket>`.
2. Pedir a Copilot un plan y revisión del diff:
   ```text
   Start implementing issue #1234. Show me the diff before applying.
   ```
3. Revisar el plan, ajustar el alcance y aprobar los cambios cuando respeten el ciclo TDD.
4. Ejecutar manualmente los tests relevantes (`pytest`, `python manage.py test`) antes de confirmar cambios.

### 6.6 Automatización de entrega

1. Mantener control humano sobre el empaquetado:
   ```text
   Stage changes, write a commit referencing #1234, and open a draft PR.
   ```
2. Validar que el mensaje de commit respete el formato `<type>(<scope>): <description>`.
3. Confirmar que el PR queda en modo borrador y añadir checklist de revisión.

### 6.7 Utilidades de soporte

1. Liberar puertos ocupados cuando aparezca el error "address already in use":
   ```text
   What process is using port 8080? Kill it and verify the port is free.
   ```
2. Gestionar permisos activos:
   ```text
   /session
   /reset
   /add-directory
   ```
3. Registrar incidentes de red en el tablero de plataforma y adjuntar logs generados.

### 6.8 Extensión con MCP adicionales

1. Revisar lineamientos de seguridad en `playbooks_operativos/copilot_codespaces.md` antes de agregar servidores.
2. Solicitar la instalación de nuevas herramientas:
   ```text
   /mcp add
   ```
3. Documentar nombre, tipo (Local/HTTP/SSE), comando, argumentos y variables de entorno propuestas.
4. Someter la solicitud a Seguridad TI, incluyendo evaluación de riesgos y plan de rollback.

> **Nota:** cualquier integración MCP debe contar con aprobación previa y pruebas controladas en un Codespace aislado.
