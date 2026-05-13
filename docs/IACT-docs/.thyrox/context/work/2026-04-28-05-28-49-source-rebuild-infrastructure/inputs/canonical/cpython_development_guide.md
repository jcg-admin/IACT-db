---
id: DOC-INFRA-CPYTHON-DEV-GUIDE
tipo: documentacion-tecnica
categoria: infraestructura
version: 1.0.0
fecha_creacion: 2025-11-07
propietario: devops-lead
relacionados: ["DOC-INFRA-CPYTHON-BUILDER", "SPEC_INFRA_001"]
---

# CPython Builder - Guia de Desarrollo

## Tabla de Contenidos

1. [Introduccion](#introduccion)
2. [Arquitectura y Principios](#arquitectura-y-principios)
3. [Agregar Funciones a Utilidades](#agregar-funciones-a-utilidades)
4. [Crear Nuevas Validaciones](#crear-nuevas-validaciones)
5. [Modificar Scripts Existentes](#modificar-scripts-existentes)
6. [Extender el Sistema](#extender-el-sistema)
7. [Testing y Validacion](#testing-y-validacion)
8. [Mejores Practicas](#mejores-practicas)
9. [Patrones de Codigo](#patrones-de-codigo)
10. [Troubleshooting de Desarrollo](#troubleshooting-de-desarrollo)

## Introduccion

Esta guia proporciona instrucciones para desarrolladores que necesiten modificar, extender o mantener el sistema CPython Builder.

### Audiencia

- Ingenieros DevOps
- Desarrolladores de Infrastructure
- Mantenedores del sistema
- Contribuidores externos

### Prerequisitos

- Conocimiento de Bash scripting
- Familiaridad con Vagrant y VirtualBox
- Experiencia con compilacion de software C
- Entendimiento de Git y workflows de desarrollo

## Arquitectura y Principios

### Principios de Diseno

1. **DRY (Don't Repeat Yourself)**: Codigo duplicado debe extraerse a utilidades compartidas
2. **Separation of Concerns**: Cada componente tiene una responsabilidad clara
3. **Fail Fast**: Validaciones tempranas con errores claros
4. **Reproducibilidad**: Mismos inputs generan mismos outputs
5. **Observabilidad**: Logging detallado de todas las operaciones
6. **Modularidad**: Componentes independientes y reutilizables

### Estructura de Capas

```
┌──────────────────────────────────────┐
│        Scripts de Usuario            │  <- build_cpython.sh, validate_build.sh
│  (Logica de negocio especifica)     │
└──────────────────────────────────────┘
              │
              ▼
┌──────────────────────────────────────┐
│     Utilidades Compartidas           │  <- logging.sh, validation.sh, common.sh
│  (Funciones reutilizables)           │
└──────────────────────────────────────┘
              │
              ▼
┌──────────────────────────────────────┐
│      Configuracion Central           │  <- versions.conf
│  (Parametros y constantes)           │
└──────────────────────────────────────┘
```

### Convencion de Nombres

**Archivos**:
- Scripts: `nombre_accion.sh` (snake_case)
- Utilidades: `categoria.sh` (singular)
- Configuracion: `nombre.conf`

**Funciones**:
- Publicas: `verbo_sustantivo` (ejemplo: `validate_python_version`)
- Privadas: `_verbo_sustantivo` (prefijo underscore)

**Variables**:
- Constantes: `UPPER_CASE` (ejemplo: `DEFAULT_PYTHON_VERSION`)
- Variables: `lower_case` (ejemplo: `artifact_name`)
- Exportadas: `EXPORT_NAME` (ejemplo: `PROJECT_ROOT`)

## Agregar Funciones a Utilidades

### Determinar Categoria

Antes de agregar una funcion, determina a que categoria pertenece:

| Categoria | Archivo | Proposito |
|-----------|---------|-----------|
| Logging | `utils/logging.sh` | Funciones de output y mensajes |
| Validacion | `utils/validation.sh` | Funciones de verificacion y validacion |
| Utilidades | `utils/common.sh` | Funciones auxiliares generales |

### Template de Funcion

```bash
# Descripcion breve de la funcion (1 linea)
#
# Uso:
#   nombre_funcion "arg1" "arg2"
#
# Argumentos:
#   $1 - Descripcion del argumento 1
#   $2 - Descripcion del argumento 2 (opcional)
#
# Return:
#   0 - Exito
#   1 - Fallo
#
# Ejemplo:
#   if nombre_funcion "valor1" "valor2"; then
#       echo "Exito"
#   fi
#
nombre_funcion() {
    local arg1="$1"
    local arg2="${2:-default}"

    # Validar argumentos
    if [ -z "$arg1" ]; then
        log_error "Argumento 1 es requerido"
        return 1
    fi

    # Logica de la funcion
    log_info "Procesando $arg1..."

    # Operaciones
    if [ condition ]; then
        log_success "Operacion exitosa"
        return 0
    else
        log_error "Operacion fallida"
        return 1
    fi
}
```

### Ejemplo: Agregar Funcion de Logging

**Requisito**: Necesitamos una funcion para mostrar progreso de operaciones largas.

**Paso 1**: Editar `utils/logging.sh`

```bash
# Mostrar progreso de operacion
#
# Uso:
#   log_progress "operacion" "paso_actual" "total_pasos"
#
# Argumentos:
#   $1 - Nombre de la operacion
#   $2 - Paso actual (numero)
#   $3 - Total de pasos
#
# Ejemplo:
#   log_progress "Compilacion" 5 10
#   # Output: [INFO] [50%] Compilacion (5/10)
#
log_progress() {
    local operation="$1"
    local current="$2"
    local total="$3"

    local percentage=$((current * 100 / total))
    echo -e "${BLUE}[INFO]${NC} [${percentage}%] ${operation} (${current}/${total})"
}
```

**Paso 2**: Documentar en cabecera de archivo

```bash
#!/bin/bash
# =============================================================================
# Utilidades de Logging para CPython Builder
# =============================================================================
# Referencia: SPEC_INFRA_001
# Proposito: Funciones de logging reutilizables para todos los scripts
#
# Funciones disponibles:
#   - log_info()       : Mensaje informativo
#   - log_success()    : Mensaje de exito
#   - log_warn()       : Advertencia
#   - log_error()      : Error
#   - log_step()       : Paso de proceso
#   - log_header()     : Encabezado
#   - log_separator()  : Linea separadora
#   - log_progress()   : Progreso de operacion (NUEVA)
# =============================================================================
```

**Paso 3**: Actualizar documentacion

Agregar entrada en `/home/user/IACT---project/docs/infrastructure/cpython-builder.md` seccion "Utilidades Compartidas".

### Ejemplo: Agregar Funcion de Validacion

**Requisito**: Validar que una URL es accesible.

**Paso 1**: Editar `utils/validation.sh`

```bash
# Validar que una URL es accesible
#
# Uso:
#   validate_url_accessible "url" ["error_msg"]
#
# Argumentos:
#   $1 - URL a validar
#   $2 - Mensaje de error personalizado (opcional)
#
# Return:
#   0 - URL accesible
#   1 - URL no accesible
#
# Ejemplo:
#   if validate_url_accessible "https://www.python.org"; then
#       log_success "URL accesible"
#   fi
#
validate_url_accessible() {
    local url="$1"
    local error_msg="${2:-URL not accessible: $url}"

    # Cargar logging si no esta cargado
    if [ -z "$LOGGING_LOADED" ]; then
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        source "$SCRIPT_DIR/logging.sh"
        LOGGING_LOADED=1
    fi

    # Verificar con curl (HEAD request)
    if command -v curl >/dev/null 2>&1; then
        if curl --output /dev/null --silent --head --fail "$url"; then
            return 0
        fi
    # Verificar con wget
    elif command -v wget >/dev/null 2>&1; then
        if wget --spider -q "$url" 2>/dev/null; then
            return 0
        fi
    else
        log_error "curl ni wget disponibles para validacion de URL"
        return 1
    fi

    log_error "$error_msg"
    return 1
}
```

**Paso 2**: Agregar test

```bash
# Test en scripts/test_utils.sh (crear si no existe)
test_validate_url_accessible() {
    source "../utils/validation.sh"

    # Test URL valida
    if validate_url_accessible "https://www.python.org"; then
        echo "PASS: URL valida accesible"
    else
        echo "FAIL: URL valida no accesible"
    fi

    # Test URL invalida
    if ! validate_url_accessible "https://invalid-url-12345.com"; then
        echo "PASS: URL invalida correctamente rechazada"
    else
        echo "FAIL: URL invalida incorrectamente aceptada"
    fi
}
```

### Ejemplo: Agregar Funcion de Utilidad

**Requisito**: Calcular tiempo transcurrido entre dos timestamps.

**Paso 1**: Editar `utils/common.sh`

```bash
# Calcular tiempo transcurrido entre dos timestamps
#
# Uso:
#   elapsed=$(calculate_elapsed_time "start" "end")
#
# Argumentos:
#   $1 - Timestamp de inicio (seconds since epoch)
#   $2 - Timestamp de fin (seconds since epoch)
#
# Return:
#   String formateado: "Xh Ym Zs"
#
# Ejemplo:
#   start=$(date +%s)
#   # ... operaciones ...
#   end=$(date +%s)
#   elapsed=$(calculate_elapsed_time "$start" "$end")
#   log_info "Tiempo transcurrido: $elapsed"
#
calculate_elapsed_time() {
    local start="$1"
    local end="$2"

    local total_seconds=$((end - start))
    local hours=$((total_seconds / 3600))
    local minutes=$(((total_seconds % 3600) / 60))
    local seconds=$((total_seconds % 60))

    if [ $hours -gt 0 ]; then
        echo "${hours}h ${minutes}m ${seconds}s"
    elif [ $minutes -gt 0 ]; then
        echo "${minutes}m ${seconds}s"
    else
        echo "${seconds}s"
    fi
}
```

**Paso 2**: Usar en scripts

```bash
#!/bin/bash
source "$(dirname "$0")/../utils/common.sh"

start_time=$(date +%s)

# Operaciones...

end_time=$(date +%s)
elapsed=$(calculate_elapsed_time "$start_time" "$end_time")
log_info "Compilacion completada en $elapsed"
```

## Crear Nuevas Validaciones

### Agregar Validacion a validate_build.sh

**Requisito**: Validar que el artefacto contiene documentacion.

**Paso 1**: Editar `scripts/validate_build.sh`

```bash
# ... validaciones existentes ...

# Validacion 12: Documentacion presente
log_info "12. Verificando documentacion..."

# Extraer y verificar
tar -xzf "$ARTIFACT_PATH" -C "$TEMP_DIR"
PYTHON_DIR=$(find "$TEMP_DIR" -maxdepth 2 -name "python-*" -type d | head -1)

if [ ! -d "$PYTHON_DIR/share/doc" ]; then
    log_error "Directorio de documentacion no encontrado"
    exit 1
fi

DOC_SIZE=$(du -s "$PYTHON_DIR/share/doc" | cut -f1)
if [ $DOC_SIZE -lt 100 ]; then
    log_error "Documentacion muy pequena (posiblemente incompleta)"
    exit 1
fi

log_success "Documentacion presente"
```

**Paso 2**: Actualizar contador de validaciones

```bash
# Al inicio del script
log_info "=== Validacion de artefacto CPython ==="
log_info "Artefacto: $ARTIFACT_NAME"
log_info "Total de validaciones: 12"  # Actualizar numero
echo ""
```

### Crear Script de Validacion Independiente

**Requisito**: Validar performance del Python compilado.

**Paso 1**: Crear `scripts/validate_performance.sh`

```bash
#!/bin/bash
#
# validate_performance.sh - Validar performance de CPython
#
# Referencia: SPEC_INFRA_001
# Proposito: Verificar que optimizaciones PGO/LTO son efectivas
#
# Uso:
#   ./validate_performance.sh <python-binary>
#

set -euo pipefail

# Cargar utilidades
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/logging.sh"
source "$SCRIPT_DIR/../utils/validation.sh"

# Validar argumentos
if [ $# -lt 1 ]; then
    log_error "Uso: $0 <python-binary>"
    exit 1
fi

PYTHON_BIN="$1"

# Validar que binario existe
if ! validate_file_exists "$PYTHON_BIN"; then
    exit 1
fi

log_header "Validacion de Performance"

# Test 1: Startup time
log_info "Test 1: Tiempo de inicio..."
STARTUP_TIME=$( (time "$PYTHON_BIN" -c "pass") 2>&1 | grep real | awk '{print $2}')
log_info "  Tiempo de inicio: $STARTUP_TIME"

# Test 2: Import time
log_info "Test 2: Tiempo de import..."
IMPORT_TIME=$("$PYTHON_BIN" -c "import time; start = time.time(); import json, urllib, xml.etree.ElementTree; print(time.time() - start)")
log_info "  Tiempo de import: ${IMPORT_TIME}s"

# Test 3: Benchmark simple
log_info "Test 3: Benchmark de calculo..."
BENCH_TIME=$("$PYTHON_BIN" -c "import time; start = time.time(); sum(range(1000000)); print(time.time() - start)")
log_info "  Tiempo de benchmark: ${BENCH_TIME}s"

log_success "Validacion de performance completada"
```

**Paso 2**: Hacer ejecutable y agregar a workflow

```bash
chmod +x scripts/validate_performance.sh

# Agregar a build_cpython.sh al final
log_info "Validando performance..."
if ./scripts/validate_performance.sh "$INSTALL_PREFIX/bin/python3"; then
    log_success "Performance validada"
fi
```

## Modificar Scripts Existentes

### Agregar Nueva Feature a build_cpython.sh

**Requisito**: Agregar opcion para compilacion de debug.

**Paso 1**: Actualizar `config/versions.conf`

```bash
# Agregar al final
# Flags de compilacion de debug
CONFIGURE_FLAGS_DEBUG=(
    "--with-pydebug"
    "--with-assertions"
    "--enable-shared"
)
```

**Paso 2**: Modificar `scripts/build_cpython.sh`

```bash
# Agregar opcion de linea de comando
DEBUG_BUILD=false

# Parsear argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --debug)
            DEBUG_BUILD=true
            shift
            ;;
        *)
            PYTHON_VERSION="$1"
            shift
            ;;
    esac
done

# Usar flags apropiados
if [ "$DEBUG_BUILD" = true ]; then
    log_info "Modo debug activado"
    CONFIGURE_FLAGS=("${CONFIGURE_FLAGS_DEBUG[@]}")
    ARTIFACT_NAME="cpython-${PYTHON_VERSION}-${DISTRO}-build${BUILD_NUMBER}-debug.tgz"
else
    CONFIGURE_FLAGS=("${CONFIGURE_FLAGS[@]}")
fi
```

**Paso 3**: Actualizar documentacion de uso

```bash
# Al inicio del script
# Uso:
#   ./build_cpython.sh <version> [build-number] [--debug]
#
# Ejemplos:
#   ./build_cpython.sh 3.12.6
#   ./build_cpython.sh 3.12.6 2 --debug
```

### Refactorizar Codigo Duplicado

**Antes** (codigo duplicado en multiples scripts):

```bash
# En build_cpython.sh
if [ ! -f "$file" ]; then
    echo "[ERROR] File not found: $file"
    exit 1
fi

# En validate_build.sh
if [ ! -f "$artifact" ]; then
    echo "[ERROR] File not found: $artifact"
    exit 1
fi
```

**Despues** (usar utilidad):

```bash
# En ambos scripts
source "$(dirname "$0")/../utils/validation.sh"

if ! validate_file_exists "$file"; then
    exit 1
fi
```

## Extender el Sistema

### Agregar Soporte para Nuevo OS

**Requisito**: Agregar soporte para Debian 12.

**Paso 1**: Actualizar `config/versions.conf`

```bash
# Sistemas operativos soportados
SUPPORTED_DISTROS=(
    "ubuntu20.04"
    "debian12"
)

# Deteccion automatica
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID$VERSION_ID" | tr -d '.'
    else
        echo "unknown"
    fi
}
```

**Paso 2**: Actualizar `bootstrap.sh`

```bash
# Detectar distro
DISTRO=$(detect_distro)

case $DISTRO in
    ubuntu2204)
        echo "Ubuntu 20.04 detectado"
        ;;
    debian12)
        echo "Debian 12 detectado"
        # Instalar dependencias especificas de Debian
        ;;
    *)
        echo "Distro no soportada: $DISTRO"
        exit 1
        ;;
esac
```

**Paso 3**: Actualizar `Vagrantfile` con nuevo box

```ruby
# Configuracion multi-distro
DISTRO = ENV['DISTRO'] || 'ubuntu20.04'

case DISTRO
when 'ubuntu20.04'
  config.vm.box = "ubuntu/focal64"
when 'debian12'
  config.vm.box = "debian/bookworm64"
else
  abort("Distro not supported: #{DISTRO}")
end
```

### Agregar Script de Instalacion Automatica

**Requisito**: Script para instalar en servidor sin Vagrant.

**Paso 1**: Crear `scripts/install_native.sh`

```bash
#!/bin/bash
#
# install_native.sh - Instalar artefacto CPython en sistema nativo
#
# Uso:
#   ./install_native.sh <artifact-path> [install-prefix]
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/logging.sh"
source "$SCRIPT_DIR/../utils/validation.sh"
source "$SCRIPT_DIR/../utils/common.sh"

# Validar argumentos
if [ $# -lt 1 ]; then
    log_error "Uso: $0 <artifact-path> [install-prefix]"
    exit 1
fi

ARTIFACT_PATH="$1"
INSTALL_PREFIX="${2:-/opt}"

log_header "Instalacion de CPython"

# Validar artefacto
if ! validate_file_exists "$ARTIFACT_PATH"; then
    exit 1
fi

# Validar checksum si existe
if [ -f "$ARTIFACT_PATH.sha256" ]; then
    log_info "Validando checksum..."
    if ! validate_checksum "$ARTIFACT_PATH" "$ARTIFACT_PATH.sha256"; then
        exit 1
    fi
fi

# Extraer
log_info "Extrayendo artefacto..."
if ! extract_tarball "$ARTIFACT_PATH" "$INSTALL_PREFIX"; then
    log_error "Fallo al extraer artefacto"
    exit 1
fi

# Configurar PATH
PYTHON_VERSION=$(basename "$ARTIFACT_PATH" | sed 's/cpython-\([0-9.]*\)-.*/\1/')
PYTHON_DIR="$INSTALL_PREFIX/python-$PYTHON_VERSION"

log_info "Configurando PATH..."
cat > /etc/profile.d/python-$PYTHON_VERSION.sh <<EOF
export PATH="$PYTHON_DIR/bin:\$PATH"
export LD_LIBRARY_PATH="$PYTHON_DIR/lib:\$LD_LIBRARY_PATH"
EOF

log_success "Instalacion completada: $PYTHON_DIR"
log_info "Reiniciar shell o ejecutar: source /etc/profile.d/python-$PYTHON_VERSION.sh"
```

## Testing y Validacion

### Estructura de Tests

```
infrastructure/cpython/tests/
├── test_utils.sh          # Tests de utilidades
├── test_validation.sh     # Tests de validacion
├── test_build.sh          # Tests de compilacion
└── run_all_tests.sh       # Ejecutar todos los tests
```

### Template de Test

```bash
#!/bin/bash
#
# test_utils.sh - Tests de utilidades compartidas
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/logging.sh"

TESTS_PASSED=0
TESTS_FAILED=0

# Helper para aserciones
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"

    if [ "$expected" = "$actual" ]; then
        log_success "PASS: $test_name"
        ((TESTS_PASSED++))
    else
        log_error "FAIL: $test_name"
        log_error "  Expected: $expected"
        log_error "  Actual:   $actual"
        ((TESTS_FAILED++))
    fi
}

assert_true() {
    local condition="$1"
    local test_name="$2"

    if $condition; then
        log_success "PASS: $test_name"
        ((TESTS_PASSED++))
    else
        log_error "FAIL: $test_name"
        ((TESTS_FAILED++))
    fi
}

# Tests
test_get_python_major_minor() {
    source "$SCRIPT_DIR/../utils/common.sh"

    result=$(get_python_major_minor "3.12.6")
    assert_equals "3.12" "$result" "get_python_major_minor con 3.12.6"

    result=$(get_python_major_minor "3.11.9")
    assert_equals "3.11" "$result" "get_python_major_minor con 3.11.9"
}

test_validate_python_version() {
    source "$SCRIPT_DIR/../utils/validation.sh"

    if validate_python_version "3.12.6"; then
        log_success "PASS: validate_python_version con version valida"
        ((TESTS_PASSED++))
    else
        log_error "FAIL: validate_python_version con version valida"
        ((TESTS_FAILED++))
    fi

    if ! validate_python_version "3.12"; then
        log_success "PASS: validate_python_version rechaza version invalida"
        ((TESTS_PASSED++))
    else
        log_error "FAIL: validate_python_version acepta version invalida"
        ((TESTS_FAILED++))
    fi
}

# Ejecutar tests
log_header "Ejecutando Tests de Utilidades"

test_get_python_major_minor
test_validate_python_version

# Resumen
log_separator
log_info "Tests pasados: $TESTS_PASSED"
log_info "Tests fallidos: $TESTS_FAILED"

if [ $TESTS_FAILED -gt 0 ]; then
    log_error "Algunos tests fallaron"
    exit 1
else
    log_success "Todos los tests pasaron"
    exit 0
fi
```

### Ejecutar Tests

```bash
# Tests individuales
cd infraestructura/cpython/tests
./test_utils.sh

# Todos los tests
./run_all_tests.sh
```

## Mejores Practicas

### 1. Siempre Usar Utilidades Compartidas

**NO**:
```bash
echo "[ERROR] File not found"
exit 1
```

**SI**:
```bash
if ! validate_file_exists "$file"; then
    exit 1
fi
```

### 2. Validar Entrada Temprano

**NO**:
```bash
function process_file() {
    # 100 lineas de codigo
    if [ ! -f "$file" ]; then
        echo "Error"
    fi
}
```

**SI**:
```bash
function process_file() {
    local file="$1"

    # Validar inmediatamente
    if ! validate_file_exists "$file"; then
        return 1
    fi

    # Procesar
}
```

### 3. Usar set -euo pipefail

Siempre en scripts principales:

```bash
#!/bin/bash
set -euo pipefail  # Falla en errores, variables no definidas, pipes fallidos
```

### 4. Documentar Funciones

Cada funcion debe tener:
- Descripcion
- Uso
- Argumentos
- Return values
- Ejemplo

### 5. Usar Variables Locales

```bash
# NO (variable global)
process_data() {
    result="processed"
}

# SI (variable local)
process_data() {
    local result="processed"
    echo "$result"
}
```

### 6. Cleanup en Errores

```bash
#!/bin/bash
set -euo pipefail

# Configurar trap para cleanup
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

TEMP_DIR=$(mktemp -d)
# ... operaciones ...
```

### 7. Logging Apropiado

```bash
# Usar nivel apropiado
log_info "Descargando archivo..."      # Informacion
log_success "Descarga completa"        # Exito
log_warn "Archivo cache no encontrado" # Advertencia no critica
log_error "Fallo al descargar"         # Error critico
```

## Patrones de Codigo

### Patron: Wrapper de VM

```bash
#!/bin/bash
# Wrapper para ejecutar comando dentro de VM

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/logging.sh"

# Validar Vagrant
if ! command -v vagrant >/dev/null 2>&1; then
    log_error "Vagrant no instalado"
    exit 1
fi

# Validar VM corriendo
cd "$SCRIPT_DIR/.."
if ! vagrant status | grep -q "running"; then
    log_error "VM no esta corriendo. Ejecutar: vagrant up"
    exit 1
fi

# Ejecutar comando
log_info "Ejecutando en VM..."
vagrant ssh -c "cd /vagrant && ./scripts/comando.sh $*"
```

### Patron: Carga de Configuracion

```bash
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cargar utilidades
for util in logging validation common; do
    if [ -f "$SCRIPT_DIR/../utils/$util.sh" ]; then
        source "$SCRIPT_DIR/../utils/$util.sh"
    elif [ -f "/vagrant/utils/$util.sh" ]; then
        source "/vagrant/utils/$util.sh"
    else
        echo "[ERROR] Cannot find $util.sh"
        exit 1
    fi
done

# Cargar configuracion
if [ -f "$SCRIPT_DIR/../config/versions.conf" ]; then
    source "$SCRIPT_DIR/../config/versions.conf"
elif [ -f "/vagrant/config/versions.conf" ]; then
    source "/vagrant/config/versions.conf"
fi
```

### Patron: Download con Retry

```bash
download_with_retry() {
    local url="$1"
    local dest="$2"
    local max_retries="${3:-3}"
    local retry=0

    while [ $retry -lt $max_retries ]; do
        log_info "Intento $((retry + 1))/$max_retries: Descargando $url"

        if download_file "$url" "$dest"; then
            log_success "Descarga exitosa"
            return 0
        fi

        retry=$((retry + 1))
        if [ $retry -lt $max_retries ]; then
            log_warn "Reintentando en 5 segundos..."
            sleep 5
        fi
    done

    log_error "Descarga fallida despues de $max_retries intentos"
    return 1
}
```

### Patron: Progress Bar

```bash
show_progress() {
    local current="$1"
    local total="$2"
    local width=50

    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))

    printf "\r["
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' '-'
    printf "] %3d%%" "$percentage"

    if [ $current -eq $total ]; then
        echo ""
    fi
}

# Uso
total=100
for i in $(seq 1 $total); do
    # Procesar
    show_progress $i $total
    sleep 0.1
done
```

## Troubleshooting de Desarrollo

### Error: "source: not found"

**Causa**: Usar `sh` en lugar de `bash`

**Solucion**:
```bash
# Asegurar shebang correcto
#!/bin/bash

# Ejecutar con bash
bash script.sh
```

### Error: Variables no definidas

**Causa**: No usar `set -u`

**Solucion**:
```bash
set -euo pipefail

# Usar valores default
VERSION="${VERSION:-3.12.6}"
```

### Error: Funcion no encontrada

**Causa**: Utilidades no cargadas

**Solucion**:
```bash
# Verificar carga
if ! command -v log_info >/dev/null 2>&1; then
    echo "ERROR: Utilidades no cargadas"
    exit 1
fi
```

### Debug de Scripts

```bash
# Ejecutar con trace
bash -x script.sh

# Debug de seccion especifica
set -x
# codigo a debuggear
set +x
```

### Linting

```bash
# Instalar shellcheck
sudo apt-get install shellcheck

# Verificar script
shellcheck script.sh

# Verificar todos los scripts
find scripts/ utils/ -name "*.sh" -exec shellcheck {} \;
```

---

**Mantenido por**: Equipo DevOps - Infrastructure
**Propietarios**: @devops-lead @arquitecto-senior
**Ultima actualizacion**: 2025-11-07
**Version del documento**: 1.0.0
