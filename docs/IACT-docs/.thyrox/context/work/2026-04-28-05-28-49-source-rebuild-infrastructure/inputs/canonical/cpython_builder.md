---
id: DOC-INFRA-CPYTHON-BUILDER
tipo: documentacion-tecnica
categoria: infraestructura
version: 1.0.0
fecha_creacion: 2025-11-07
propietario: devops-lead
relacionados: ["SPEC_INFRA_001", "ADR_008"]
---

# CPython Builder - Sistema de Compilacion

## Tabla de Contenidos

1. [Resumen Ejecutivo](#resumen-ejecutivo)
2. [Arquitectura del Sistema](#arquitectura-del-sistema)
3. [Componentes Principales](#componentes-principales)
4. [Estructura de Directorios](#estructura-de-directorios)
5. [Utilidades Compartidas](#utilidades-compartidas)
6. [Scripts Disponibles](#scripts-disponibles)
7. [Configuracion](#configuracion)
8. [Uso del Sistema](#uso-del-sistema)
9. [Validacion y Testing](#validacion-y-testing)
10. [Troubleshooting](#troubleshooting)
11. [Referencias](#referencias)

## Resumen Ejecutivo

### Proposito

El CPython Builder es un sistema automatizado para compilar CPython desde codigo fuente en un entorno reproducible. Proporciona artefactos precompilados optimizados para Ubuntu 20.04 LTS que pueden ser consumidos por Dev Containers y entornos de desarrollo.

### Caracteristicas Principales

- **Entorno Reproducible**: VM Vagrant con Ubuntu 20.04 LTS
- **Compilacion Optimizada**: Profile-Guided Optimization (PGO) + Link-Time Optimization (LTO)
- **Validacion Automatica**: 11 validaciones de integridad y funcionalidad
- **Utilidades Compartidas**: Biblioteca de funciones reutilizables para logging, validacion y operaciones comunes
- **Configuracion Centralizada**: Archivo unico de configuracion para versiones y parametros
- **Modular y Extensible**: Arquitectura basada en componentes independientes

### Cambios Recientes (Refactorizacion 2025-11-07)

1. **Fix Vagrantfile**: Cambio de DHCP a IP estatica (192.168.56.10) para evitar conflictos
2. **Utilidades Compartidas**: Creacion de directorio `utils/` con funciones reutilizables
3. **Configuracion Centralizada**: Archivo `config/versions.conf` para parametros comunes
4. **Refactorizacion de Scripts**: 5 scripts actualizados para usar utilidades compartidas
5. **Mejoras de Mantenibilidad**: Codigo DRY, mejor separacion de responsabilidades

## Arquitectura del Sistema

### Diagrama de Componentes

```
┌─────────────────────────────────────────────────────┐
│                    Host System                      │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │         infrastructure/cpython/            │   │
│  │                                             │   │
│  │  ┌──────────────┐  ┌──────────────┐        │   │
│  │  │  Vagrantfile │  │  bootstrap.sh│        │   │
│  │  └──────────────┘  └──────────────┘        │   │
│  │                                             │   │
│  │  ┌──────────────────────────────────────┐  │   │
│  │  │         scripts/                     │  │   │
│  │  │  - build_cpython.sh                  │  │   │
│  │  │  - validate_build.sh                 │  │   │
│  │  │  - feature_install.sh                │  │   │
│  │  │  - build_wrapper.sh                  │  │   │
│  │  │  - validate_wrapper.sh               │  │   │
│  │  └──────────────────────────────────────┘  │   │
│  │                                             │   │
│  │  ┌──────────────────────────────────────┐  │   │
│  │  │         utils/                       │  │   │
│  │  │  - logging.sh      (Logging)         │  │   │
│  │  │  - validation.sh   (Validaciones)    │  │   │
│  │  │  - common.sh       (Utilidades)      │  │   │
│  │  └──────────────────────────────────────┘  │   │
│  │                                             │   │
│  │  ┌──────────────────────────────────────┐  │   │
│  │  │         config/                      │  │   │
│  │  │  - versions.conf   (Configuracion)   │  │   │
│  │  └──────────────────────────────────────┘  │   │
│  │                                             │   │
│  │  ┌──────────────────────────────────────┐  │   │
│  │  │         artifacts/                   │  │   │
│  │  │  - cpython-X.Y.Z-ubuntu20.04-buildN │  │   │
│  │  │  - *.tgz.sha256                      │  │   │
│  │  └──────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────┘   │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │          Vagrant VM (Ubuntu 20.04)          │   │
│  │                                             │   │
│  │  ┌──────────────────────────────────────┐  │   │
│  │  │  Build Environment                   │  │   │
│  │  │  - GCC toolchain                     │  │   │
│  │  │  - Python build dependencies         │  │   │
│  │  │  - System libraries (ssl, sqlite)    │  │   │
│  │  └──────────────────────────────────────┘  │   │
│  │                                             │   │
│  │  ┌──────────────────────────────────────┐  │   │
│  │  │  /vagrant (synced folder)            │  │   │
│  │  │  - Acceso a scripts/                 │  │   │
│  │  │  - Acceso a utils/                   │  │   │
│  │  │  - Escritura en artifacts/           │  │   │
│  │  └──────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

### Flujo de Trabajo

```
1. vagrant up
   └─> Provisiona VM con bootstrap.sh
       └─> Instala dependencias
       └─> Configura entorno

2. build_cpython.sh 3.12.6
   └─> Carga utils/logging.sh
   └─> Carga utils/validation.sh
   └─> Carga utils/common.sh
   └─> Carga config/versions.conf
   └─> Descarga codigo fuente
   └─> Compila con PGO + LTO
   └─> Genera artefacto en artifacts/

3. validate_build.sh cpython-3.12.6-ubuntu20.04-build1.tgz
   └─> Carga utils/ (logging, validation, common)
   └─> Ejecuta 11 validaciones
   └─> Reporta resultado
```

## Componentes Principales

### 1. Vagrant VM

**Archivo**: `infrastructure/cpython/Vagrantfile`

**Proposito**: Define el entorno de compilacion reproducible

**Caracteristicas**:
- Ubuntu 20.04 LTS (focal64)
- 4 GB RAM, 4 CPUs
- IP estatica: 192.168.56.10 (nuevo: fix DHCP)
- Synced folders con soporte UTF-8
- Aprovisionamiento automatico via bootstrap.sh

**Red**:
```ruby
# Antes (DHCP - problematico):
config.vm.network "private_network", type: "dhcp"

# Ahora (IP estatica - estable):
config.vm.network "private_network", ip: "192.168.56.10"
```

### 2. Bootstrap Script

**Archivo**: `infrastructure/cpython/bootstrap.sh`

**Proposito**: Aprovisionar VM con dependencias de compilacion

**Instala**:
- Build essentials (gcc, make, etc.)
- Python build dependencies (libssl-dev, libsqlite3-dev, etc.)
- Herramientas de desarrollo (git, wget, curl)
- Dependencias opcionales (liblzma-dev, libbz2-dev, etc.)

### 3. Scripts de Compilacion

**Ubicacion**: `infrastructure/cpython/scripts/`

Scripts principales para construccion y validacion de artefactos.

### 4. Utilidades Compartidas

**Ubicacion**: `infrastructure/cpython/utils/`

Biblioteca de funciones reutilizables (nuevo en refactorizacion).

### 5. Configuracion Centralizada

**Ubicacion**: `infrastructure/cpython/config/`

Parametros de configuracion compartidos (nuevo en refactorizacion).

## Estructura de Directorios

```
infrastructure/cpython/
├── Vagrantfile                  # Configuracion de VM Vagrant
├── bootstrap.sh                 # Script de aprovisionamiento
├── README.md                    # Documentacion de uso
│
├── scripts/                     # Scripts principales
│   ├── build_cpython.sh         # Compilacion de CPython
│   ├── validate_build.sh        # Validacion de artefactos
│   ├── feature_install.sh       # Instalacion en Dev Container
│   ├── build_wrapper.sh         # Wrapper para ejecutar desde host
│   └── validate_wrapper.sh      # Wrapper de validacion desde host
│
├── utils/                       # Utilidades compartidas (NUEVO)
│   ├── logging.sh               # Funciones de logging
│   ├── validation.sh            # Funciones de validacion
│   └── common.sh                # Utilidades generales
│
├── config/                      # Configuracion (NUEVO)
│   └── versions.conf            # Versiones y parametros
│
├── artifacts/                   # Artefactos generados
│   ├── cpython/                 # Artefactos de CPython
│   │   ├── *.tgz                # Tarballs
│   │   └── *.tgz.sha256         # Checksums
│   └── .gitkeep
│
├── logs/                        # Logs de compilacion
│   └── .gitkeep
│
├── tests/                       # Tests del sistema
│   └── .gitkeep
│
└── installer/                   # Instaladores para otras plataformas
    └── README.md
```

## Utilidades Compartidas

### utils/logging.sh

Funciones de logging estandarizadas con colores.

**Funciones Disponibles**:

```bash
log_info "mensaje"       # Informacion (azul)
log_success "mensaje"    # Exito (verde)
log_warn "mensaje"       # Advertencia (amarillo)
log_warning "mensaje"    # Alias de log_warn
log_error "mensaje"      # Error (rojo)
log_step N M "mensaje"   # Paso N de M
log_header "titulo"      # Encabezado con separador
log_separator           # Linea separadora
```

**Variables de Color**:

```bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'  # No Color
```

**Ejemplo de Uso**:

```bash
#!/bin/bash
source "$(dirname "$0")/../utils/logging.sh"

log_header "Compilacion de CPython"
log_info "Iniciando proceso..."
log_step 1 3 "Descargando codigo fuente"
log_success "Descarga completada"
log_warn "Artefacto existente sera sobrescrito"
log_error "Fallo en compilacion"
```

### utils/validation.sh

Funciones de validacion reutilizables.

**Funciones Disponibles**:

```bash
validate_command_exists "cmd" ["mensaje_error"]
validate_python_version "X.Y.Z"
validate_checksum "archivo" "checksum_file"
validate_file_exists "archivo" ["mensaje_error"]
validate_dir_exists "directorio" ["mensaje_error"]
validate_python_modules "python_bin" "mod1" "mod2" ...
```

**Ejemplo de Uso**:

```bash
#!/bin/bash
source "$(dirname "$0")/../utils/validation.sh"

# Validar que wget existe
if ! validate_command_exists "wget" "wget no instalado"; then
    exit 1
fi

# Validar formato de version
if ! validate_python_version "3.12.6"; then
    exit 1
fi

# Validar modulos de Python
validate_python_modules "/usr/bin/python3" "ssl" "sqlite3" "uuid"
```

### utils/common.sh

Utilidades generales auxiliares.

**Funciones Disponibles**:

```bash
detect_os_version                         # Detecta version de OS
cleanup_temp_dir "dir"                    # Limpia directorio temporal
download_file "url" "destino"             # Descarga archivo (wget/curl)
extract_tarball "tarball" "destino"       # Extrae tarball
get_artifact_name "ver" "distro" "build"  # Genera nombre de artefacto
get_python_major_minor "X.Y.Z"            # Extrae major.minor (3.12)
```

**Ejemplo de Uso**:

```bash
#!/bin/bash
source "$(dirname "$0")/../utils/common.sh"

# Detectar version de OS
OS_VERSION=$(detect_os_version)
echo "OS Version: $OS_VERSION"

# Generar nombre de artefacto
ARTIFACT=$(get_artifact_name "3.12.6" "ubuntu20.04" "1")
# Resultado: cpython-3.12.6-ubuntu20.04-build1.tgz

# Descargar archivo
download_file "https://example.com/file.tgz" "/tmp/file.tgz"

# Limpiar temporales
cleanup_temp_dir "/tmp/build"
```

## Scripts Disponibles

### build_cpython.sh

**Proposito**: Compilar CPython desde codigo fuente

**Ubicacion**: `infrastructure/cpython/scripts/build_cpython.sh`

**Sintaxis**:

```bash
./build_cpython.sh <version> [build-number]
```

**Argumentos**:
- `version`: Version de Python en formato X.Y.Z (ejemplo: 3.12.6)
- `build-number`: Numero de build (opcional, default: 1)

**Ejemplos**:

```bash
# Build 1 de Python 3.12.6
./scripts/build_cpython.sh 3.12.6

# Build 2 (rebuild)
./scripts/build_cpython.sh 3.12.6 2

# Otra version
./scripts/build_cpython.sh 3.11.9
```

**Proceso**:
1. Carga utilidades (logging, validation, common)
2. Carga configuracion (versions.conf)
3. Valida version de Python
4. Descarga codigo fuente desde python.org
5. Extrae y configura
6. Compila con flags de optimizacion (PGO + LTO)
7. Instala en /opt/python-X.Y.Z
8. Genera tarball en artifacts/
9. Calcula checksum SHA256

**Flags de Compilacion**:
- `--enable-optimizations`: Profile-Guided Optimization (PGO)
- `--with-lto`: Link-Time Optimization
- `--enable-shared`: Librerias compartidas
- `--with-system-ffi`: Usar libffi del sistema
- `--enable-loadable-sqlite-extensions`: Extensiones SQLite

**Output**:
- Tarball: `cpython-<version>-ubuntu20.04-build<N>.tgz`
- Checksum: `cpython-<version>-ubuntu20.04-build<N>.tgz.sha256`
- Ubicacion: `infrastructure/cpython/artifacts/cpython/`

**Tiempo de Compilacion**: 10-15 minutos

### validate_build.sh

**Proposito**: Validar integridad y funcionalidad del artefacto

**Ubicacion**: `infrastructure/cpython/scripts/validate_build.sh`

**Sintaxis**:

```bash
./validate_build.sh <artifact-name>
```

**Ejemplo**:

```bash
./scripts/validate_build.sh cpython-3.12.6-ubuntu20.04-build1.tgz
```

**Validaciones Realizadas** (11 checks):

1. **Existencia del artefacto**: Verifica que el tarball existe
2. **Existencia del checksum**: Verifica que el archivo .sha256 existe
3. **Integridad SHA256**: Valida checksum del artefacto
4. **Tamano razonable**: Verifica que el tamano esta entre 30-150 MB
5. **Estructura de directorio**: Valida que contiene `opt/python-X.Y.Z/`
6. **Binarios presentes**: Verifica que python3 y pip3 existen
7. **Version del binario**: Valida que la version es correcta
8. **Modulos nativos**: Verifica ssl, sqlite3, uuid, lzma, bz2, zlib, ctypes
9. **pip disponible**: Valida que pip funciona
10. **Build info presente**: Verifica archivo .build-info
11. **LICENSE presente**: Verifica archivo LICENSE

**Exit Codes**:
- 0: Validacion exitosa
- 1: Validacion fallida

### feature_install.sh

**Proposito**: Instalar CPython en Dev Container Feature

**Ubicacion**: `infrastructure/cpython/scripts/feature_install.sh`

**Uso**: Llamado automaticamente por Dev Container Feature

**Proceso**:
1. Detecta version de Python solicitada
2. Descarga artefacto desde GitHub Releases
3. Valida checksum
4. Extrae en /opt/python-X.Y.Z
5. Configura PATH y variables de entorno
6. Crea symlinks

### build_wrapper.sh

**Proposito**: Ejecutar build_cpython.sh desde host (fuera de VM)

**Ubicacion**: `infrastructure/cpython/scripts/build_wrapper.sh`

**Sintaxis**:

```bash
./infraestructura/cpython/scripts/build_wrapper.sh <version> [build-number]
```

**Ejemplo**:

```bash
./infraestructura/cpython/scripts/build_wrapper.sh 3.12.6
```

**Proceso**:
1. Valida que Vagrant esta instalado
2. Valida que VM esta corriendo
3. Ejecuta build_cpython.sh dentro de VM via `vagrant ssh`

### validate_wrapper.sh

**Proposito**: Ejecutar validate_build.sh desde host

**Ubicacion**: `infrastructure/cpython/scripts/validate_wrapper.sh`

**Sintaxis**:

```bash
./infraestructura/cpython/scripts/validate_wrapper.sh <artifact-name>
```

**Ejemplo**:

```bash
./infraestructura/cpython/scripts/validate_wrapper.sh cpython-3.12.6-ubuntu20.04-build1.tgz
```

## Configuracion

### config/versions.conf

**Proposito**: Configuracion centralizada de versiones y parametros

**Ubicacion**: `infrastructure/cpython/config/versions.conf`

**Contenido**:

```bash
# Versiones de Python
DEFAULT_PYTHON_VERSION="3.12.6"
DEFAULT_BUILD_NUMBER="1"

# Versiones soportadas
SUPPORTED_PYTHON_VERSIONS=(
    "3.11.9"
    "3.12.6"
    "3.13.0"
)

# Sistema operativo
DISTRO="ubuntu20.04"
UBUNTU_VERSION="22.04"

# Modulos nativos requeridos
REQUIRED_MODULES=(
    "ssl"
    "sqlite3"
    "uuid"
    "lzma"
    "bz2"
    "zlib"
    "_ctypes"
)

# URLs base
PYTHON_DOWNLOAD_BASE="https://www.python.org/ftp/python"
GITHUB_RELEASES_BASE="https://github.com/2-Coatl/IACT---project/releases"

# Flags de compilacion
CONFIGURE_FLAGS=(
    "--enable-optimizations"
    "--with-lto"
    "--enable-shared"
    "--with-system-ffi"
    "--enable-loadable-sqlite-extensions"
)
```

**Uso en Scripts**:

```bash
#!/bin/bash

# Cargar configuracion
if [ -f "$SCRIPT_DIR/../config/versions.conf" ]; then
    source "$SCRIPT_DIR/../config/versions.conf"
fi

# Usar variables
echo "Version default: $DEFAULT_PYTHON_VERSION"
echo "Modulos requeridos: ${REQUIRED_MODULES[@]}"
```

## Uso del Sistema

### Inicio Rapido

#### 1. Iniciar VM

```bash
cd infraestructura/cpython
vagrant up
```

Primera vez: 10-15 minutos (descarga box + provisioning)

#### 2. Compilar CPython

Opcion A - Desde fuera de VM (recomendado):

```bash
./infraestructura/cpython/scripts/build_cpython.sh 3.12.6
```

Opcion B - Dentro de VM:

```bash
vagrant ssh
cd /vagrant
./scripts/build_cpython.sh 3.12.6
```

#### 3. Validar Artefacto

```bash
./infraestructura/cpython/scripts/validate_build.sh cpython-3.12.6-ubuntu20.04-build1.tgz
```

#### 4. Resultado

Artefactos en: `infrastructure/cpython/artifacts/cpython/`

```
cpython-3.12.6-ubuntu20.04-build1.tgz
cpython-3.12.6-ubuntu20.04-build1.tgz.sha256
```

### Gestion de VM

```bash
# Iniciar VM
vagrant up

# Conectar a VM
vagrant ssh

# Detener VM (libera RAM)
vagrant halt

# Reiniciar VM
vagrant reload

# Destruir VM (limpieza completa)
vagrant destroy

# Ver estado
vagrant status

# Re-provisionar
vagrant provision
```

### Compilacion de Multiples Versiones

```bash
# Compilar Python 3.11.9
./scripts/build_cpython.sh 3.11.9

# Compilar Python 3.12.6
./scripts/build_cpython.sh 3.12.6

# Compilar Python 3.13.0
./scripts/build_cpython.sh 3.13.0
```

### Rebuilds

```bash
# Rebuild de Python 3.12.6 (incrementa build number)
./scripts/build_cpython.sh 3.12.6 2

# Resultado: cpython-3.12.6-ubuntu20.04-build2.tgz
```

## Validacion y Testing

### Validacion Automatica

El sistema incluye validacion automatica de 11 checks:

```bash
./scripts/validate_build.sh cpython-3.12.6-ubuntu20.04-build1.tgz
```

**Output Esperado**:

```
=== Validacion de artefacto CPython ===
Artefacto: cpython-3.12.6-ubuntu20.04-build1.tgz

1. Verificando existencia del artefacto...
[SUCCESS] Artefacto existe

2. Verificando existencia de checksum...
[SUCCESS] Checksum existe

3. Verificando integridad SHA256...
[SUCCESS] Checksum valido: abc123...

4. Verificando tamano del artefacto...
[SUCCESS] Tamano razonable: 45 MB

5. Verificando contenido del tarball...
[SUCCESS] Estructura de directorio correcta

6. Verificando binarios...
[SUCCESS] Binarios presentes: python3, pip3

7. Verificando version del binario...
[SUCCESS] Version correcta: 3.12.6

8. Verificando modulos nativos...
[SUCCESS]   Modulo ssl: OK
[SUCCESS]   Modulo sqlite3: OK
[SUCCESS]   Modulo uuid: OK
[SUCCESS]   Modulo lzma: OK
[SUCCESS]   Modulo bz2: OK
[SUCCESS]   Modulo zlib: OK
[SUCCESS]   Modulo _ctypes: OK

9. Verificando pip...
[SUCCESS] pip funciona correctamente

10. Verificando build info...
[SUCCESS] .build-info presente

11. Verificando LICENSE...
[SUCCESS] LICENSE presente

=== VALIDACION EXITOSA ===
```

### Testing Manual

```bash
# Extraer artefacto
cd /tmp
tar -xzf /vagrant/artifacts/cpython/cpython-3.12.6-ubuntu20.04-build1.tgz

# Probar Python
/tmp/opt/python-3.12.6/bin/python3 --version
# Output: Python 3.12.6

# Probar pip
/tmp/opt/python-3.12.6/bin/pip3 --version

# Probar import de modulos
/tmp/opt/python-3.12.6/bin/python3 -c "import ssl; print(ssl.OPENSSL_VERSION)"
```

## Troubleshooting

### Error: "VM failed to start"

**Causa**: VirtualBox no instalado o configuracion incorrecta

**Solucion**:

```bash
# Verificar instalacion
vagrant version
vboxmanage --version

# Reinstalar provider
vagrant plugin install vagrant-vbguest
```

### Error: "DHCP lease timeout"

**Estado**: RESUELTO en refactorizacion

**Causa**: Conflictos de DHCP en red privada

**Solucion**: Aplicada en Vagrantfile - ahora usa IP estatica 192.168.56.10

```ruby
# Cambio realizado:
config.vm.network "private_network", ip: "192.168.56.10"
```

### Error: "Compilation failed"

**Causa**: Dependencias faltantes o codigo fuente corrupto

**Solucion**:

```bash
vagrant ssh
cd /vagrant

# Ver logs
tail -50 /tmp/cpython-build/Python-*/make.log

# Limpiar y reintentar
rm -rf /tmp/cpython-build
./scripts/build_cpython.sh 3.12.6
```

### Error: "Module X not found"

**Causa**: Libreria dev faltante en provisioning

**Solucion**:

```bash
vagrant ssh
sudo apt-get install lib<X>-dev  # Ejemplo: libssl-dev

# Re-compilar
cd /vagrant
./scripts/build_cpython.sh 3.12.6 2  # Nuevo build number
```

### VM muy lenta

**Causa**: Recursos insuficientes

**Solucion**:

1. Cerrar aplicaciones que consuman RAM
2. Aumentar recursos en Vagrantfile:

```ruby
vb.memory = "8192"  # 8 GB RAM
vb.cpus = 8         # 8 cores
```

3. Considerar compilacion nativa si OS es Ubuntu 20.04

### Artefacto muy grande (>150 MB)

**Causa**: Archivos de debug incluidos

**Solucion**:

```bash
vagrant ssh
cd /opt/python-X.Y.Z
find . -name "__pycache__" -type d -exec rm -rf {} +
find . -name "*.pyc" -delete

# Re-empaquetar
cd /opt
sudo tar czf /vagrant/artifacts/cpython/cpython-X.Y.Z-ubuntu20.04-build2.tgz python-X.Y.Z
```

### Error: "Cannot find utils/logging.sh"

**Causa**: Script ejecutado desde directorio incorrecto

**Solucion**:

Scripts deben ejecutarse desde:
- Dentro de VM: `/vagrant/scripts/`
- Fuera de VM: Usar wrappers en `infrastructure/cpython/scripts/`

## Referencias

### Documentacion del Proyecto

- [SPEC_INFRA_001: CPython Precompilado](/home/user/IACT---project/docs/specs/SPEC_INFRA_001_cpython_precompilado.md)
- [ADR_008: Features vs Imagen Base](/home/user/IACT---project/docs/adr/ADR_008_cpython_features_vs_imagen_base.md)
- [README del Sistema](/home/user/IACT---project/infrastructure/cpython/README.md)
- [Guia de Desarrollo](/home/user/IACT---project/docs/infrastructure/cpython-development-guide.md)
- [CHANGELOG](/home/user/IACT---project/docs/infrastructure/CHANGELOG-cpython.md)

### Documentacion Externa

- [CPython Build Instructions](https://devguide.python.org/getting-started/setup-building/)
- [Python Source Releases](https://www.python.org/downloads/source/)
- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [VirtualBox Manual](https://www.virtualbox.org/manual/)
- [Profile-Guided Optimization](https://en.wikipedia.org/wiki/Profile-guided_optimization)

### GitHub

- [Issues del Proyecto](https://github.com/2-Coatl/IACT---project/issues)
- [Releases](https://github.com/2-Coatl/IACT---project/releases)

---

**Mantenido por**: Equipo DevOps - Infrastructure
**Propietarios**: @devops-lead @arquitecto-senior
**Ultima actualizacion**: 2025-11-07
**Version del documento**: 1.0.0
