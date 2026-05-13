# Pipeline CPython Precompilado y uso en DevContainer

## Resumen ejecutivo
Este documento sintetiza cómo se genera, publica y consume el artefacto de CPython precompilado y qué ajustes son necesarios en el DevContainer del monolito. Responde a las preguntas frecuentes del equipo sobre "¿cuál es el pipeline?" y "¿cómo se usa en `.devcontainer/`?".

- **Tecnología base**: todo el flujo se ejecuta con scripts shell y objetivos de `Makefile`. No se añadió código Python nuevo; el binario proviene del proceso de compilación descrito en la Fase 3.
- **Resultado esperado**: un tarball `cpython-<versión>-<os>-build<id>.tgz` con los binarios y librerías ya compilados que puede instalarse en cualquier DevContainer compatible.

---

## 1. Pipeline end-to-end
El flujo completo se divide en tres etapas secuenciales. Cada una depende de scripts shell y objetivos de `Makefile` ya documentados en la fase 3 del procedimiento oficial.

### 1.1 Construcción del artefacto
1. Validar dependencias del host (Vagrant, VirtualBox, espacio en disco) con los scripts provistos.
2. Levantar la VM de compilación (`make vagrant-cpython-up` o `vagrant up`).
3. Ejecutar la compilación (`make build_cpython VERSION=3.12.6 BUILD=1`). Este objetivo invoca `scripts/build_cpython.sh`, que compila CPython en la VM.
4. Ejecutar la validación del paquete (`make validate-cpython ARTIFACT=cpython-3.12.6-ubuntu20.04-build1.tgz`). Este paso corre `scripts/validate_artifact.sh` para revisar hash y módulos críticos.
5. Resultado: `infrastructure/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz` más su `*.sha256`. Con ambos archivos se garantiza que el binario está listo para distribución.

> Fuente: Procedimiento fase 3, secciones 1.1 a 1.4.【F:docs/infrastructure/cpython_precompilado/FASE-3-PROCEDIMIENTO.md†L17-L107】

### 1.2 Publicación en GitHub Releases
1. Crear y pushear el tag `cpython-3.12.6-build1`.
2. Crear la release usando el template provisto (título, changelog, tabla de artefactos).
3. Adjuntar el tarball y el checksum y marcar como pre-release en la primera publicación.

> Fuente: Procedimiento fase 3, sección 2.【F:docs/infrastructure/cpython_precompilado/FASE-3-PROCEDIMIENTO.md†L109-L188】

### 1.3 Consumo en proyectos
1. Añadir la Feature personalizada en `.devcontainer/devcontainer.json`.
2. Elegir si se usa `artifactUrl` local (desarrollo) o desde la release pública (producción).
3. Reconstruir el contenedor y validar `python3 --version` y módulos nativos. No se requiere ejecutar scripts Python; el instalador descomprime el tarball y expone `/opt/python-<versión>` automáticamente.

> Fuente: Guía de usuario CPython precompilado, secciones "Inicio Rápido" y "Configuración avanzada".【F:docs/infrastructure/cpython_precompilado/README.md†L33-L130】

---

## 2. Uso dentro de `.devcontainer/`
El DevContainer del monolito ya referencia el instalador personalizado. Estos son los puntos clave que debe conocer cualquier integrante del equipo:

### 2.1 Feature instalada
```jsonc
"features": {
  "./infrastructure/cpython/installer": {
    "version": "3.12.6",
    "artifactUrl": "/workspaces/${localWorkspaceFolderBasename}/infrastructure/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz",
    "checksumUrl": "/workspaces/${localWorkspaceFolderBasename}/infrastructure/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz.sha256",
    "installPrefix": "/opt/python",
    "skipValidation": false
  },
  "ghcr.io/devcontainers/features/git:1": { "version": "latest" },
  "ghcr.io/devcontainers/features/common-utils:2": { "installZsh": true, "installOhMyZsh": true, "upgradePackages": true, "username": "vscode", "userUid": "1000", "userGid": "1000" }
}
```
- **Local vs Release**: Para modo offline se usa la ruta montada del workspace; para producción se descomenta la URL de GitHub Release.
- **Validaciones automáticas**: `skipValidation` permanece en `false`, por lo que el instalador ejecuta `sha256sum`, extracción y chequeos básicos al iniciar el contenedor.

> Fuente: `.devcontainer/devcontainer.json`, bloque `features` con comentarios oficiales.【F:.devcontainer/devcontainer.json†L27-L70】

### 2.2 Hooks de ciclo de vida
El archivo define comandos shell que orquestan el setup:
- `initializeCommand`: corre en el host y valida requisitos antes de construir el contenedor.
- `onCreateCommand`: prepara Python, Git y directorios iniciales.
- `updateContentCommand`: instala dependencias Python del proyecto (vía `pip` dentro del contenedor, usando el CPython precompilado).
- `postCreateCommand`: prepara las bases de datos y aplica migraciones.
- `postStartCommand`: ejecuta verificaciones rápidas en cada arranque.

> Fuente: Sección de hooks documentada en `.devcontainer/devcontainer.json` y scripts bajo `infrastructure/devcontainer/scripts/`.
> 【F:.devcontainer/devcontainer.json†L10-L44】【F:api/callcentersite/tests/devcontainer/test_init_host_script.py†L10-L53】

### 2.3 Rebuild y verificación
Para reconstruir y comprobar que el DevContainer usa el binario precompilado:
```bash
# Dentro de VS Code
Cmd/Ctrl + Shift + P
→ "Dev Containers: Rebuild Container"

# Una vez abierto el contenedor
python3 --version
python3 -c "import ssl, sqlite3, uuid, lzma, bz2; print('Módulos nativos OK')"
```
Si se usa la versión publicada, reemplazar el `artifactUrl` por la URL del release correspondiente antes del rebuild.

> Fuente: Guía de usuario CPython precompilado, validación post-rebuild.【F:docs/infrastructure/cpython_precompilado/README.md†L72-L123】

---

## 3. Checklist operativo rápido
| Etapa | Responsable | Script/Comando | Evidencia |
|-------|-------------|----------------|-----------|
| Build | Infraestructura | `make build_cpython VERSION=3.12.6 BUILD=1` | Tarball + checksum en `infrastructure/cpython/artifacts/` |
| QA artefacto | Infraestructura | `make validate-cpython ARTIFACT=...` | Log con `[SUCCESS]` |
| Publicación | Infraestructura | Git tag + Release template | Release en GitHub | 
| Consumo DevContainer | Desarrollo | `Dev Containers: Rebuild Container` | `python3 --version` = 3.12.6 |

Usar esta tabla como recordatorio antes de cada liberación del binario.

---

## 4. Referencias
- Procedimiento completo Fase 3 (`FASE-3-PROCEDIMIENTO.md`).
- Guía de usuario (`README.md`).
- Scripts de DevContainer (`infrastructure/devcontainer/scripts/*.sh`).

Este documento no reemplaza a los manuales oficiales; sirve como vista rápida para quienes solo necesitan comprender el pipeline y el uso en DevContainers.
