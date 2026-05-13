---
id: DOC-INFRA-CPYTHON-CHANGELOG
tipo: changelog
categoria: infraestructura
version: 1.0.0
fecha_creacion: 2025-11-07
propietario: devops-lead
relacionados: ["DOC-INFRA-CPYTHON-BUILDER", "SPEC_INFRA_001"]
---

# CHANGELOG - CPython Builder

Historial de cambios del sistema CPython Builder.

## Formato

Este CHANGELOG sigue el formato [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/) y se adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html) en la medida posible.

### Tipos de Cambios

- **Added**: Nuevas funcionalidades
- **Changed**: Cambios en funcionalidad existente
- **Deprecated**: Funcionalidades que seran removidas
- **Removed**: Funcionalidades removidas
- **Fixed**: Correcciones de bugs
- **Security**: Cambios relacionados con seguridad

---

## [1.2.1] - 2025-11-08

### Fixed

- **Bootstrap auto-repair**: `bootstrap.sh` ahora verifica el toolchain tras detectar estado previo y reinstala automáticamente `build-essential` y herramientas auxiliares si faltan `gcc` o `make`, evitando que `vagrant up` falle por cajas desalineadas.

### Added

- **Documentación de contingencia**: Se añadió al README del builder un procedimiento de respaldo para forzar la reinstalación del toolchain cuando la reparación automática no sea suficiente.

## [1.2.0] - 2025-11-08

### Added

- **Integración Dev Container**: El feature `infrastructure/cpython/installer` ahora referencia explícitamente los artefactos `cpython-3.12.6-ubuntu20.04-build1` y sus checksums generados por el builder para evitar desalineaciones entre entornos locales y releases.
- **Cobertura de validación**: Nuevos tests Ruby y Python aseguran que el Dev Container consuma tanto el tarball como el checksum publicados por la VM de compilación.
- **Documentación general**: Se añadió una sección dedicada al pipeline de artefactos en el README principal del repositorio y se creó un changelog global para visibilizar las entregas de infraestructura.

### Changed

- **Makefile y guías**: Se sincronizó la nomenclatura del objetivo `validate-cpython` y la documentación de soporte con la versión Ubuntu 20.04 utilizada por el builder.

## [1.1.0] - 2025-11-07

### Refactorizacion Mayor - Utilidades Compartidas y Configuracion Centralizada

Esta release introduce mejoras significativas de mantenibilidad y modularidad sin cambios en la funcionalidad del usuario.

### Added

#### Utilidades Compartidas (`utils/`)

- **`logger.sh`**: funciones de logging estandarizadas (`log_info`, `log_success`, `log_warning`, `log_error`, `log_step`).
- **`validator.sh`**: validaciones reutilizables (`ensure_command`, `ensure_file`, `ensure_directory`, validación de checksums y versiones de Python).
- **`filesystem.sh`**: helpers para gestionar artefactos y directorios temporales (descarga, extracción, limpieza).
- **`state_manager.sh`**: control de operaciones idempotentes y marcadores de progreso.
- **`network.sh`**, **`retry_handler.sh`**, **`name_parser.sh`** y **`environment.sh`**: utilidades auxiliares para detección de entorno, manejo de reintentos y construcción de nombres de artefactos.

#### Configuracion Centralizada (`config/`)

- **`config/versions.conf`**: Archivo de configuracion centralizada
  - `DEFAULT_PYTHON_VERSION`: Version default de Python
  - `DEFAULT_BUILD_NUMBER`: Numero de build default
  - `SUPPORTED_PYTHON_VERSIONS`: Array de versiones soportadas
  - `DISTRO`: Identificador de distribucion
  - `UBUNTU_VERSION`: Version de Ubuntu
  - `REQUIRED_MODULES`: Array de modulos nativos requeridos
  - `PYTHON_DOWNLOAD_BASE`: URL base de descargas de Python
  - `GITHUB_RELEASES_BASE`: URL base de GitHub Releases
  - `CONFIGURE_FLAGS`: Array de flags de compilacion

#### Documentacion

- **`docs/infrastructure/cpython-builder.md`**: Documentacion completa del sistema
  - Resumen ejecutivo
  - Arquitectura del sistema con diagramas
  - Descripcion detallada de componentes
  - Estructura de directorios
  - Guia de uso de utilidades compartidas
  - Referencia completa de scripts
  - Seccion de troubleshooting expandida
  - Referencias cruzadas

- **`docs/infrastructure/cpython-development-guide.md`**: Guia de desarrollo
  - Instrucciones para agregar funciones a utilidades
  - Como crear nuevas validaciones
  - Como modificar scripts existentes
  - Patrones de codigo y mejores practicas
  - Templates de funciones y tests
  - Ejemplos de extension del sistema

- **`docs/infrastructure/CHANGELOG-cpython.md`**: Este archivo

### Changed

#### Scripts Refactorizados

Todos los scripts fueron refactorizados para usar utilidades compartidas:

- **`scripts/build_cpython.sh`**:
  - Carga `utils/logger.sh`, `utils/validator.sh`, `utils/filesystem.sh`, `utils/state_manager.sh`
  - Carga `config/versions.conf`
  - Usa `validate_python_version()` para validar argumentos
  - Usa `get_python_major_minor()` para extraer version
  - Usa `get_artifact_name()` para generar nombres
  - Usa funciones `log_*()` para output estandarizado
  - Mantiene 100% de funcionalidad original

- **`scripts/validate_build.sh`**:
  - Carga utilidades compartidas (`logger.sh`, `validator.sh`, `filesystem.sh`)
  - Usa validaciones centralizadas para comprobar archivos, checksums y módulos nativos
  - Usa funciones de logging unificadas para reportes
  - Mantiene las 11 validaciones existentes

- **`scripts/install_prebuilt_cpython.sh`**:
  - Instalación idempotente de artefactos construidos previamente
  - Reutiliza utilidades de logging, validación y manejo de archivos
  - Soporta rutas relativas y absolutas con detección automática del proyecto

- **`scripts/build_wrapper.sh`**:
  - Usa funciones de logging estandarizadas
  - Mejoras en manejo de errores

- **`scripts/validate_wrapper.sh`**:
  - Usa funciones de logging estandarizadas
  - Validación mejorada de estado de VM

#### Vagrantfile

- **Network Configuration**:
  - **ANTES**: `config.vm.network "private_network", type: "dhcp"`
  - **AHORA**: `config.vm.network "private_network", ip: "192.168.56.10"`
  - **Razon**: Evitar timeouts y conflictos de DHCP
  - **Impacto**: VM ahora tiene IP estatica predecible

#### README.md

- Actualizada seccion "Estructura de Directorios" con nuevos componentes
- Agregada seccion "Cambios Recientes" con resumen de refactorizacion
- Agregada seccion "Documentacion Completa" con links a nuevos documentos
- Actualizada fecha de ultima modificacion

### Fixed

- **DHCP Lease Timeout**: Resuelto mediante cambio a IP estatica en Vagrantfile
- **Codigo Duplicado**: Eliminado mediante extraccion a utilidades compartidas
- **Validaciones Inconsistentes**: Estandarizadas mediante `utils/validation.sh`
- **Logging Inconsistente**: Unificado mediante `utils/logging.sh`

### Developer Experience Improvements

- **DRY (Don't Repeat Yourself)**: Codigo duplicado eliminado
- **Separation of Concerns**: Clara separacion entre logica de negocio y utilidades
- **Mantenibilidad**: Cambios ahora requieren modificar un solo lugar
- **Testing**: Funciones modulares facilitan testing unitario
- **Extensibilidad**: Sistema mas facil de extender con nuevas funcionalidades
- **Documentacion**: Guias completas para desarrolladores y usuarios

### Archivos Modificados

```
infrastructure/cpython/
├── Vagrantfile                  (MODIFICADO - IP estatica)
├── README.md                    (MODIFICADO - documentacion actualizada)
├── scripts/
│   ├── build_cpython.sh         (MODIFICADO - usa utils)
│   ├── validate_build.sh        (MODIFICADO - usa utils)
│   ├── install_prebuilt_cpython.sh (NUEVO - usa utils)
│   ├── build_wrapper.sh         (MODIFICADO - usa utils)
│   └── validate_wrapper.sh      (MODIFICADO - usa utils)
├── utils/                       (NUEVO)
│   ├── logger.sh                (NUEVO)
│   ├── validator.sh             (NUEVO)
│   ├── filesystem.sh            (NUEVO)
│   └── state_manager.sh         (NUEVO)
└── config/                      (NUEVO)
    └── versions.conf            (NUEVO)

docs/infrastructure/
├── cpython-builder.md           (NUEVO)
├── cpython-development-guide.md (NUEVO)
└── CHANGELOG-cpython.md         (NUEVO - este archivo)
```

### Breaking Changes

**NINGUNO**: Esta refactorizacion es completamente retrocompatible. Todos los scripts mantienen:
- Mismos argumentos de linea de comando
- Mismo comportamiento
- Mismos outputs
- Mismos exit codes
- Mismos artefactos generados

### Migration Guide

**NO REQUERIDO**: No se necesitan cambios en workflows existentes.

Los usuarios pueden continuar usando los scripts exactamente como antes:

```bash
# Estos comandos siguen funcionando igual
vagrant up
./scripts/build_cpython.sh 3.12.6
./scripts/validate_build.sh cpython-3.12.6-ubuntu20.04-build1.tgz
```

### Testing

Todos los scripts fueron probados manualmente:

- [x] `vagrant up` - Provisioning exitoso
- [x] `build_cpython.sh 3.12.6` - Compilacion exitosa
- [x] `validate_build.sh` - 11 validaciones pasan
- [x] Artefactos generados correctamente
- [x] Checksums validos
- [x] VM con IP estatica funcional

### Performance

No hay cambios en performance:
- Tiempo de compilacion: Sin cambios (~10-15 min)
- Tiempo de validacion: Sin cambios (~1-2 min)
- Uso de recursos: Sin cambios

### References

- Issue: [GitHub Issue relacionado si existe]
- PR: [PR relacionado]
- Commit: 3d5c754... (ver git log)
- SPEC: SPEC_INFRA_001
- ADR: ADR_008

---

## [1.0.0] - 2025-11-06

### Release Inicial

Primera version estable del sistema CPython Builder.

### Added

#### Core System

- **Vagrantfile**: Configuracion de VM Ubuntu 20.04 LTS
  - 4 GB RAM, 4 CPUs
  - Red privada con DHCP
  - Synced folders con UTF-8
  - Aprovisionamiento automatico

- **bootstrap.sh**: Script de aprovisionamiento
  - Instalacion de build essentials
  - Dependencias de Python (libssl-dev, libsqlite3-dev, etc.)
  - Configuracion de entorno

#### Scripts

- **`scripts/build_cpython.sh`**: Script de compilacion
  - Descarga codigo fuente de python.org
  - Configuracion con PGO + LTO
  - Compilacion e instalacion en /opt
  - Generacion de tarball
  - Calculo de checksum SHA256

- **`scripts/validate_build.sh`**: Script de validacion
  - 11 validaciones de integridad
  - Verificacion de modulos nativos
  - Validacion de estructura
  - Verificacion de checksums

- **`scripts/install_prebuilt_cpython.sh`**: Instalador de artefactos precompilados para Dev Container y entornos de CI
  - Descarga desde GitHub Releases
  - Validacion de checksums
  - Instalacion en /opt
  - Configuracion de PATH

- **`scripts/build_wrapper.sh`**: Wrapper para host
- **`scripts/validate_wrapper.sh`**: Wrapper de validacion

#### Documentacion

- **README.md**: Documentacion de usuario
  - Inicio rapido
  - Uso detallado
  - Troubleshooting
  - Referencias

#### Infrastructure

- Directorio `artifacts/` para artefactos generados
- Directorio `logs/` para logs de compilacion
- Directorio `tests/` para tests (placeholder)
- Directorio `installer/` para instaladores (placeholder)

### Features

- **Compilacion Optimizada**: PGO + LTO para maxima performance
- **Validacion Automatica**: 11 checks de integridad y funcionalidad
- **Entorno Reproducible**: VM Vagrant con versiones fijas
- **Artefactos Verificables**: Checksums SHA256 para todos los artefactos
- **Multi-version**: Soporte para Python 3.11.x, 3.12.x, 3.13.x
- **Build Numbers**: Sistema de versionado para rebuilds

### Specifications

- Sistema Operativo: Ubuntu 20.04 LTS
- Python Versions: 3.11.9, 3.12.6, 3.13.0
- Optimization Flags:
  - `--enable-optimizations` (PGO)
  - `--with-lto` (LTO)
  - `--enable-shared`
  - `--with-system-ffi`
  - `--enable-loadable-sqlite-extensions`

### Modulos Nativos Validados

- ssl
- sqlite3
- uuid
- lzma
- bz2
- zlib
- ctypes

### References

- SPEC: SPEC_INFRA_001 - CPython Precompilado
- ADR: ADR_008 - Features vs Imagen Base
- Upstream: https://www.python.org/downloads/source/

---

## [Unreleased]

### Planned

Funcionalidades planeadas para futuras releases:

#### Version 1.2.0 (Planeado)

- Suite de tests automatizados
- CI/CD pipeline para compilacion automatica
- Soporte para multiples distribuciones (Debian 12)
- Benchmarking automatico de performance
- Cache de downloads para compilaciones repetidas

#### Version 1.3.0 (Planeado)

- Compilacion incremental para rebuilds rapidos
- Soporte para patches personalizados
- Perfiles de compilacion (production, debug, minimal)
- Integracion con package managers
- Dashboard de builds

#### Mejoras de Documentacion (Continuo)

- Video tutoriales
- Ejemplos adicionales
- FAQ expandido
- Guias de troubleshooting especificas por OS

---

## Semantic Versioning

Este proyecto sigue Semantic Versioning:

- **MAJOR**: Cambios incompatibles en API/comportamiento
- **MINOR**: Nueva funcionalidad retrocompatible
- **PATCH**: Correcciones de bugs retrocompatibles

### Version History

```
1.1.0 (2025-11-07) - Refactorizacion mayor (utils + config)
1.0.0 (2025-11-06) - Release inicial
```

---

## Como Contribuir

### Reportar Issues

Reportar bugs o solicitar features en:
https://github.com/2-Coatl/IACT---project/issues

### Formato de Commit Messages

```
tipo(alcance): descripcion corta

Descripcion larga si es necesario.

Refs: #123
```

Tipos:
- `feat`: Nueva funcionalidad
- `fix`: Correccion de bug
- `docs`: Cambios en documentacion
- `refactor`: Refactorizacion de codigo
- `test`: Agregar o modificar tests
- `chore`: Mantenimiento general

### Actualizacion de CHANGELOG

Al agregar cambios:

1. Agregar entrada en seccion `[Unreleased]`
2. Categorizar segun tipo de cambio (Added, Changed, Fixed, etc.)
3. Incluir descripcion clara y concisa
4. Referenciar issues/PRs relacionados

---

**Mantenido por**: Equipo DevOps - Infrastructure
**Propietarios**: @devops-lead @arquitecto-senior
**Ultima actualizacion**: 2025-11-07
**Version del documento**: 1.0.0
