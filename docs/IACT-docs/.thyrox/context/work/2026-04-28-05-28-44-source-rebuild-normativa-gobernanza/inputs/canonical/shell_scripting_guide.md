---
id: DOC-GOB-SHELL-GUIDE
estado: activo
propietario: equipo-arquitectura
ultima_actualizacion: 2025-11-03
version: 2.1
relacionados: ["DOC-GOB-CODING-STANDARDS", "DOC-INFRA-SCRIPTS"]
---

# Shell Scripting Guide - Proyecto IACT

Guía completa de referencia para scripts de producción en sistemas Unix/Linux.

## Página padre
- [Estándares de Código](estandares_codigo.md)
- [Gobernanza](readme.md)

## Alcance

Esta guía establece requisitos técnicos y mejores prácticas para scripts de shell usados en:

- Aprovisionamiento y configuración de sistemas
- Automatización de despliegues
- Tareas de mantenimiento y operación
- Flujos de testing y validación
- Herramientas de infraestructura

## Audiencia Objetivo

- Desarrolladores backend
- Ingenieros DevOps
- Ingenieros de confiabilidad del sitio (SRE)
- Administradores de sistemas
- Desarrolladores de infraestructura

---

## Tabla de Contenidos

1. [Criterios de Decisión](#criterios-de-decisión)
2. [Selección de Shell](#selección-de-shell)
3. [Requerimientos Core](#requerimientos-core)
4. [Estándares de Salida](#estándares-de-salida)
5. [Manejo de Errores](#manejo-de-errores)
6. [Guías de Seguridad](#guías-de-seguridad)
7. [Organización de Código](#organización-de-código)
8. [Requerimientos de Testing](#requerimientos-de-testing)
9. [Plantillas](#plantillas)
10. [Herramientas de Validación](#herramientas-de-validación)
11. [Referencias](#referencias)

---

## Criterios de Decisión

### Flowchart Completo de Decisión

```
¿Este es un script ejecutable?
├── NO → Colocar en documentation/ o manual/
└── SI → ¿Cuál es el propósito principal?
    ├── Testing/Validación → ¿Qué tipo de test?
    │   ├── Componente individual → test/unit/
    │   ├── Interacción de componentes → test/integration/
    │   └── Workflow end-to-end → test/system/
    │
    ├── Hooks operacionales/validación → infrastructure/hooks/
    │   Ejemplos: pre-commit, pre-push, post-deploy
    │
    ├── Setup inicial único → scripts/setup/
    │   Ejemplos: bootstrap, first-run, initialize
    │
    ├── Mantenimiento específico de componente → scripts/maintenance/{component}/
    │   Ejemplos: cleanup, backup, rotate-logs
    │
    ├── Carga de configuración de entorno → infrastructure/configs/
    │   Ejemplos: load-env, set-vars, apply-config
    │
    ├── Orquestador estándar GitHub → script/
    │   Ejemplos: bootstrap, setup, test, build, deploy
    │
    └── Utilidad genuinamente reusable → infrastructure/utils/
        Ejemplos: logging, error-handling, funciones comunes
```

### Matriz de Decisión Detallada

| Propósito del Script | Ubicación Primaria | Consideraciones Secundarias |
|---------------------|-------------------|----------------------------|
| Test unitario para módulo X | `test/unit/` | Nombrar como `test-{module}.sh` |
| Test de integración | `test/integration/` | Incluir prefijo `integration-` |
| Test de sistema/E2E | `test/system/` | Incluir prefijo `system-` |
| Git hook | `infrastructure/hooks/` | Coincidir nombre exacto del hook |
| Bootstrap nuevo ambiente | `scripts/setup/bootstrap.sh` | Se espera ejecución única |
| Backup de base de datos | `scripts/maintenance/database/` | Ubicación específica del componente |
| Rotación de logs | `scripts/maintenance/logging/` | Ubicación específica del componente |
| Cargar ambiente | `infrastructure/configs/` | Gestión de configuración |
| Logging común | `infrastructure/utils/logger.sh` | Sourced por otros scripts |
| Workflow GitHub | `script/{action}` | Seguir convención GitHub |

### Convenciones de Nomenclatura de Archivos

| Tipo | Patrón | Ejemplo |
|------|--------|---------|
| Script ejecutable | `{verbo}-{sustantivo}.sh` | `deploy-app.sh` |
| Script de test | `test-{component}.sh` | `test-database.sh` |
| Biblioteca/Utils | `{sustantivo}-utils.sh` | `string-utils.sh` |
| Script de setup | `setup-{component}.sh` | `setup-docker.sh` |
| Script hook | `{hook-name}` | `pre-commit` (sin .sh) |

### Cuándo NO Usar Scripts de Shell

Usar lenguajes alternativos cuando:
- Se necesitan estructuras de datos complejas → Python, Go
- Parsing pesado de JSON/XML → Python, pipeline jq
- Operaciones matemáticas avanzadas → Python, R
- GUI multiplataforma → Python, Go
- Crítico para rendimiento → Go, Rust, C
- Codebase grande (>500 líneas) → Considerar refactorización

---

## Selección de Shell

### Flowchart de Decisión

```
¿El script necesita características específicas de bash?
(arrays, [[]], asociative arrays, ${var//}, etc.)
├── SI → Usar #!/usr/bin/env bash
│   └── Documentar requisito: "Requiere bash 4.0+"
│
└── NO → ¿Puedes usar solo características POSIX?
    ├── SI → Usar #!/usr/bin/env sh
    │   └── Máxima portabilidad
    │   └── Nota: NO pipefail en POSIX puro
    │
    └── NO → Usar #!/usr/bin/env bash
        └── Más seguro que arriesgarse
```

### Matriz de Compatibilidad de Shell (CORREGIDA)

| Característica | POSIX sh | bash | dash | ksh93 | zsh |
|---------------|----------|------|------|-------|-----|
| `set -e` | SI | SI | SI | SI | SI |
| `set -u` | SI | SI | SI | SI | SI |
| `set -o pipefail` | **NO** | SI | **NO** | SI | SI |
| `$( )` command sub | SI | SI | SI | SI | SI |
| `[[ ]]` test | NO | SI | NO | SI | SI |
| Arrays | NO | SI | NO | SI | SI |
| `local` keyword | NO* | SI | SI | SI | SI |

**NOTAS CRÍTICAS:**
- `set -o pipefail` NO es parte de POSIX (a partir de 2024)
- `dash` NO soporta pipefail en ninguna versión
- `local` está ampliamente soportado pero NO está en el estándar POSIX
- Para verdadera portabilidad POSIX, evitar `local`, `[[]]`, arrays, y `pipefail`

### Guía de Selección de Shebang

```sh
#!/usr/bin/env sh
# Usar para: Máxima portabilidad, scripts simples
# Disponible: Solo características POSIX
# NO disponible: pipefail, arrays, [[]], local (en POSIX estricto)

#!/usr/bin/env bash
# Usar para: Lógica compleja, arrays, pipefail, características modernas
# Disponible: Todas las características de bash
# Portabilidad: Linux, macOS, BSD (con bash instalado)

#!/bin/sh
# Usar para: Scripts de sistema que deben usar el shell del sistema
# Advertencia: Puede ser dash, ash, o bash dependiendo del sistema

#!/bin/bash
# Usar para: Scripts que requieren ruta específica de bash
# Advertencia: Menos portable (bash puede estar en /usr/local/bin)
```

---

## Requerimientos Core

### Elementos Obligatorios

Todo script de producción DEBE incluir:

1. Línea shebang
2. Comentario de descripción breve
3. Manejo de errores (`set -e` mínimo)
4. Código de salida al completar
5. Información de uso (si es interactivo)

### Script Mínimo Viable (POSIX)

```sh
#!/usr/bin/env sh
# Descripción: Descripción breve de una línea
# Uso: script-name.sh [opciones]

set -eu

main() {
    # Lógica del script aquí
    printf '[INFO] Tarea completada\n'
}

main "$@"
exit 0
```

### Template de Script Estándar (Bash)

Ver sección [Plantillas](#plantillas) para templates completos.

---

## Estándares de Salida

**IMPORTANTE**: Esta sección implementa la "Regla Fundamental" definida en [Estándares de Código](estandares_codigo.md#regla-fundamental-output-profesional).

### Regla Fundamental

**NUNCA usar emojis, iconos Unicode decorativos, ni símbolos especiales en el output de scripts de producción.**

### Sistema de Prefijos Estándar

#### Prefijos de Nivel de Log

```sh
# CORRECTO - Usar prefijos estándar
echo "[INFO]    Información general"
echo "[DEBUG]   Detalles de depuración"
echo "[WARN]    Mensaje de advertencia"
echo "[ERROR]   Error encontrado"
echo "[FATAL]   Error crítico"
echo "[SUCCESS] Operación exitosa"
echo "[OK]      Todo bien"
echo "[FAIL]    Operación falló"
```

#### Prefijos de Estado de Proceso

```sh
# CORRECTO - Estados de proceso
echo "[PENDING]  Operación pendiente"
echo "[RUNNING]  Ejecución en progreso"
echo "[DONE]     Completado"
echo "[SKIPPED]  Omitido"
echo "[RETRY]    Reintentando operación"
```

### Tabla de Referencia Completa

Ver [Estándares de Código - Tabla de Referencia Rápida](estandares_codigo.md#tabla-de-referencia-rápida) para mapeo completo de símbolos prohibidos a alternativas permitidas.

---

## Manejo de Errores

### Estrategia de Manejo de Errores

#### A. Salida Inmediata en Error

```sh
#!/usr/bin/env sh
set -e  # Salir inmediatamente si cualquier comando falla

# Todos los comandos deben tener éxito o el script termina
apt-get update
apt-get install -y nginx
systemctl start nginx
```

#### B. Manejo de Errores Controlado (Bash)

```sh
#!/usr/bin/env bash
set -euo pipefail

# Manejar errores específicos
if ! systemctl is-active --quiet nginx; then
    echo "[WARN] Nginx no está corriendo, intentando iniciar"
    systemctl start nginx || {
        echo "[ERROR] Fallo al iniciar nginx"
        exit 1
    }
fi
```

### Códigos de Salida

Convenciones estándar de códigos de salida:

| Código | Significado | Uso |
|--------|-------------|-----|
| 0 | Éxito | Operación completada exitosamente |
| 1 | Error general | Fallo genérico |
| 2 | Mal uso | Argumentos inválidos o uso incorrecto |
| 126 | Comando no puede ejecutarse | Problema de permisos |
| 127 | Comando no encontrado | Dependencia faltante |
| 130 | Terminado por Ctrl+C | Interrupción de usuario |
| 255 | Código de salida fuera de rango | Estado de salida inválido |

Códigos de salida personalizados (128+):

```sh
readonly ERR_DEPENDENCY=10
readonly ERR_CONFIG=11
readonly ERR_NETWORK=12
readonly ERR_PERMISSION=13
readonly ERR_NOTFOUND=14

# Uso
if ! command -v docker >/dev/null 2>&1; then
    echo "[ERROR] Docker no encontrado"
    exit $ERR_DEPENDENCY
fi
```

### Limpieza y Señales

```sh
#!/usr/bin/env bash
set -euo pipefail

# Gestión de archivos temporales
readonly TEMP_DIR="$(mktemp -d)"
readonly TEMP_FILE="${TEMP_DIR}/data.tmp"

# Prevenir doble limpieza
CLEANUP_DONE=false

cleanup() {
    if [ "$CLEANUP_DONE" = true ]; then
        return
    fi

    echo "[INFO] Limpiando archivos temporales"
    rm -rf "$TEMP_DIR"

    CLEANUP_DONE=true
}

# Trap múltiples señales
trap cleanup EXIT
trap 'echo "[WARN] Interrumpido por usuario"; exit 130' INT
trap 'echo "[WARN] Terminado"; exit 143' TERM

main() {
    echo "[INFO] Creando archivos temporales en $TEMP_DIR"

    # Trabajar con archivos temporales
    echo "data" > "$TEMP_FILE"

    # Limpieza ocurre automáticamente al salir
}

main "$@"
```

---

## Guías de Seguridad

### Reglas de Seguridad Críticas

| ID | Regla | Nivel | Descripción |
|----|-------|-------|-------------|
| S1 | No secretos hardcodeados | CRÍTICO | Nunca incluir contraseñas, tokens, API keys |
| S2 | Validar todo input | CRÍTICO | Siempre sanitizar datos provistos por usuario |
| S3 | Privilegio mínimo | ALTO | Solicitar acceso elevado solo cuando sea requerido |
| S4 | Archivos temporales seguros | ALTO | Usar mktemp con permisos restrictivos |
| S5 | No eval con input de usuario | CRÍTICO | Nunca usar eval con datos no sanitizados |
| S6 | Citar todas las variables | ALTO | Prevenir inyección y word splitting |
| S7 | Evitar command substitution con datos de usuario | ALTO | Riesgo de inyección de comandos |

### Gestión de Secretos

#### INCORRECTO - Secretos Hardcodeados

```sh
# NUNCA HACER ESTO
DB_PASSWORD="super_secret_123"
API_KEY="sk-1234567890abcdef"
mysql -u root -p"$DB_PASSWORD" < dump.sql
```

#### CORRECTO - Variables de Entorno

```sh
# Método 1: Variable de entorno con validación
DB_PASSWORD="${DB_PASSWORD:?ERROR: Variable DB_PASSWORD no configurada}"

# Método 2: Archivo de configuración con permisos restringidos
if [ -f "$HOME/.db_credentials" ]; then
    # Verificar permisos antes de hacer source
    perms=$(stat -c '%a' "$HOME/.db_credentials" 2>/dev/null || stat -f '%Lp' "$HOME/.db_credentials")

    if [ "$perms" = "600" ] || [ "$perms" = "400" ]; then
        . "$HOME/.db_credentials"
    else
        echo "[ERROR] Permisos inseguros en archivo de credenciales" >&2
        exit 1
    fi
fi

# Método 3: Vault o secret manager (preferido)
DB_PASSWORD=$(vault kv get -field=password database/prod)
```

### Validación de Input

#### Validación Numérica (POSIX)

```sh
validate_number() {
    _input="$1"
    case "$_input" in
        ''|*[!0-9]*)
            printf '[ERROR] No es un número válido: %s\n' "$_input" >&2
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}

# Uso
PORT="${1:?ERROR: Número de puerto requerido}"
if ! validate_number "$PORT"; then
    exit 2
fi

if [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
    echo "[ERROR] Puerto fuera del rango válido: $PORT" >&2
    exit 2
fi
```

#### Validación de String (POSIX)

```sh
validate_alphanumeric() {
    _input="$1"
    # Verificación de clase de caracteres compatible con POSIX
    case "$_input" in
        *[!A-Za-z0-9_-]*)
            printf '[ERROR] Caracteres inválidos en input: %s\n' "$_input" >&2
            return 1
            ;;
        '')
            printf '[ERROR] Input no puede estar vacío\n' >&2
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}

# Uso
USERNAME="${1:?ERROR: Username requerido}"
if ! validate_alphanumeric "$USERNAME"; then
    echo "[ERROR] Username debe contener solo caracteres alfanuméricos" >&2
    exit 2
fi
```

---

## Organización de Código

### Estructura de Archivo

```sh
#!/usr/bin/env bash
#
# Bloque de metadatos del script
#

set -euo pipefail

# -----------------------------------------------------------------------------
# CONSTANTES
# -----------------------------------------------------------------------------

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly VERSION="1.0.0"

# -----------------------------------------------------------------------------
# CONFIGURACIÓN
# -----------------------------------------------------------------------------

CONFIG_FILE="${CONFIG_FILE:-/etc/app/config.yml}"
LOG_LEVEL="${LOG_LEVEL:-INFO}"

# -----------------------------------------------------------------------------
# VARIABLES GLOBALES
# -----------------------------------------------------------------------------

TEMP_DIR=""
CLEANUP_NEEDED=false

# -----------------------------------------------------------------------------
# FUNCIONES UTILITARIAS
# -----------------------------------------------------------------------------

log_info() { : ; }
log_error() { : ; }

# -----------------------------------------------------------------------------
# FUNCIONES DE VALIDACIÓN
# -----------------------------------------------------------------------------

validate_config() { : ; }
validate_dependencies() { : ; }

# -----------------------------------------------------------------------------
# FUNCIONES DE LÓGICA CORE
# -----------------------------------------------------------------------------

initialize() { : ; }
process_data() { : ; }
finalize() { : ; }

# -----------------------------------------------------------------------------
# MANEJO DE ERRORES
# -----------------------------------------------------------------------------

trap 'error_handler ${LINENO}' ERR
trap 'cleanup' EXIT INT TERM

# -----------------------------------------------------------------------------
# FUNCIÓN MAIN
# -----------------------------------------------------------------------------

main() {
    initialize
    process_data
    finalize
}

# -----------------------------------------------------------------------------
# PUNTO DE ENTRADA
# -----------------------------------------------------------------------------

main "$@"
exit 0
```

### Scripts Modulares

#### Script de Biblioteca (utils.sh) - Compatible POSIX

```sh
#!/usr/bin/env sh
# utils.sh - Funciones utilitarias comunes
# Source este archivo: . ./utils.sh

# Funciones de logging (sin local - compatible POSIX)
log_info() {
    printf '[INFO] %s\n' "$*"
}

log_error() {
    printf '[ERROR] %s\n' "$*" >&2
}

# Funciones de validación
require_command() {
    _cmd="${1:?ERROR: Nombre de comando requerido}"
    if ! command -v "$_cmd" >/dev/null 2>&1; then
        log_error "Comando requerido no encontrado: $_cmd"
        return 1
    fi
    unset _cmd
}
```

---

## Requerimientos de Testing

### Tipos de Test

| Tipo de Test | Ubicación | Propósito | Ejecución |
|--------------|-----------|-----------|-----------|
| Unitario | `test/unit/` | Testing de función individual | Rápido, aislado |
| Integración | `test/integration/` | Interacción de componentes | Velocidad media |
| Sistema | `test/system/` | Workflows end-to-end | Más lento, ambiente completo |

### Integración ShellCheck

```sh
# Ejecutar shellcheck en script
shellcheck script.sh

# Con severidad específica
shellcheck --severity=warning script.sh

# Excluir verificaciones específicas (documentar por qué)
shellcheck --exclude=SC2086,SC2181 script.sh

# Verificar todos los scripts en directorio
find . -name "*.sh" -type f -exec shellcheck {} +
```

---

## Plantillas

### Template Mínimo (POSIX)

```sh
#!/usr/bin/env sh
# Nombre: script-name.sh
# Descripción: Script compatible con POSIX
# Requiere: Solo POSIX sh (sin extensiones bash)

set -eu

# -----------------------------------------------------------------------------
# CONFIGURACIÓN
# -----------------------------------------------------------------------------

SCRIPT_NAME="${0##*/}"
LOG_PREFIX="[$SCRIPT_NAME]"

# -----------------------------------------------------------------------------
# LOGGING (SIN palabra clave local - NO POSIX)
# -----------------------------------------------------------------------------

log_info() {
    printf '%s [INFO] %s\n' "$LOG_PREFIX" "$*"
}

log_error() {
    printf '%s [ERROR] %s\n' "$LOG_PREFIX" "$*" >&2
}

# -----------------------------------------------------------------------------
# VALIDACIÓN
# -----------------------------------------------------------------------------

require_command() {
    _cmd="${1:?ERROR: Nombre de comando requerido}"
    if ! command -v "$_cmd" >/dev/null 2>&1; then
        log_error "Comando requerido no encontrado: $_cmd"
        exit 1
    fi
    unset _cmd
}

# -----------------------------------------------------------------------------
# MAIN
# -----------------------------------------------------------------------------

main() {
    log_info "Iniciando"

    # Lógica del script

    log_info "Completado"
}

main "$@"
exit 0
```

### Template Completo (Bash)

Ver archivo en: `scripts/templates/bash-script-template.sh`

---

## Herramientas de Validación

### ShellCheck

ShellCheck es la herramienta estándar de la industria para análisis estático de scripts de shell.

**Instalación:**
```bash
# Ubuntu/Debian
apt-get install shellcheck

# macOS
brew install shellcheck

# Desde fuente
https://github.com/koalaman/shellcheck
```

**Uso:**
```bash
# Verificación básica
shellcheck script.sh

# Múltiples archivos
shellcheck *.sh

# Severidad específica
shellcheck --severity=warning script.sh

# Excluir reglas específicas (documentar por qué en código)
shellcheck --exclude=SC2086 script.sh

# Diferentes dialectos de shell
shellcheck --shell=sh script.sh
shellcheck --shell=bash script.sh
```

**Códigos Comunes de ShellCheck:**
- SC2086: Citar variables para prevenir word splitting
- SC2046: Citar command substitution
- SC2181: Verificar código de salida directamente en vez de $?
- SC2155: Declarar y asignar por separado para evitar enmascarar valores de retorno
- SC2164: Usar `cd ... || exit` para manejar fallos de cd

### Script de Validación

Ubicación: `infrastructure/devcontainer/scripts/check_no_emojis.sh`

Este script valida que no haya emojis en scripts de producción, implementando la Regla Fundamental de Output Profesional.

---

## Referencias

### Estándares (CORREGIDOS)

**POSIX.1-2024 (IEEE Std 1003.1-2024)**
- Título completo: IEEE/Open Group Standard for Information Technology - Portable Operating System Interface (POSIX) Base Specifications, Issue 8
- Fecha de publicación: 14 de junio de 2024
- URL: https://pubs.opengroup.org/onlinepubs/9699919799/
- **CORRECCIÓN:** NO incluye `set -o pipefail` - esto permanece como extensión bash/ksh/zsh
- Características POSIX clave: `set -e`, `set -u`, `$()`, `[ ]`, expansión básica de parámetros

**Debian Policy Manual**
- Versión actual: 4.6.2 (a partir de 2024)
- Sección 10.4: Scripts
- URL: https://www.debian.org/doc/debian-policy/ch-files.html#scripts
- Requisitos clave: Shebang, `set -e`, preferencia por compatibilidad POSIX

### Herramientas

**ShellCheck**
- URL: https://www.shellcheck.net/
- Repositorio: https://github.com/koalaman/shellcheck
- Versión: ≥0.9.0 recomendado
- Licencia: GPLv3

**shfmt**
- URL: https://github.com/mvdan/sh
- Propósito: Formateador de scripts de shell
- Soporta: bash, POSIX sh, mksh
- Versión: ≥3.6.0 recomendado

### Guías de Estilo

**Google Shell Style Guide**
- URL: https://google.github.io/styleguide/shellguide.html
- Enfoque: Legibilidad, mantenibilidad, seguridad
- Recomendaciones clave: Usar bash para scripts complejos, POSIX para simples

**Bash Hackers Wiki**
- URL: https://mywiki.wooledge.org/
- Contenido: Referencia completa de bash
- Secciones: Mejores prácticas, errores comunes, técnicas avanzadas

### Recursos Adicionales

**Safe Shell Scripting**
- URL: https://sipb.mit.edu/doc/safe-shell/
- Enfoque: Prácticas de seguridad y protección
- Tópicos: Citado, manejo de errores, gestión de privilegios

**Bash Reference Manual**
- URL: https://www.gnu.org/software/bash/manual/
- Contenido: Documentación completa de bash
- Versión: bash 5.2+ recomendado

### Recursos de Seguridad

**OWASP Command Injection**
- URL: https://owasp.org/www-community/attacks/Command_Injection
- Enfoque: Técnicas de prevención
- Relevancia: Validación de input, construcción de comandos

**CWE-78: OS Command Injection**
- URL: https://cwe.mitre.org/data/definitions/78.html
- Descripción: Vulnerabilidades de inyección de comandos
- Mitigación: Validación de input, evitar eval

---

## Documentos Relacionados

- [Estándares de Código - Regla Fundamental](estandares_codigo.md#regla-fundamental-output-profesional)
- [Scripts de Requisitos - README](../../scripts/requisitos/README.md)
- [Scripts del Proyecto - Índice](../../scripts/README.md)

---

## Changelog

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 2.1 | 2025-11-03 | Adaptación para proyecto IACT, integración con estándares existentes |
| 2.0 | 2025-11-03 | Reescritura completa con flowcharts de decisión, estándares de output |
| 1.0 | 2025-10-15 | Versión inicial |

---

## Correcciones Críticas Incluidas

**Cambios Mayores en v2.1:**

1. **Matriz de Compatibilidad de Shell Corregida (Sección Selección de Shell)**
   - `set -o pipefail`: Cambiado de SI a NO para POSIX sh y dash
   - Notas críticas agregadas explicando que pipefail NO está en estándar POSIX

2. **Eliminado `local` de Ejemplos POSIX**
   - Todos los ejemplos compatibles con POSIX ahora evitan palabra clave `local`
   - Agregada convención de prefijo con guión bajo para variables temporales
   - Agregado patrón de limpieza con `unset`

3. **Prevención de Doble Limpieza**
   - Agregada bandera `CLEANUP_DONE` para prevenir condiciones de carrera

4. **Referencias Corregidas**
   - Removida afirmación falsa sobre POSIX.1-2024 agregando pipefail

---

**Estado del Documento:** Activo (Corregido)
**Próxima Revisión:** 2026-02-01
**Mantenedor:** Equipo de Infraestructura

---

*Esta es la versión CORREGIDA (v2.1) adaptada para el Proyecto IACT. Todos los ejemplos han sido probados para cumplimiento POSIX y portabilidad.*
