---
id: SPEC_INFRA_001
tipo: especificacion
categoria: infraestructura
version: 1.0.0
fecha_creacion: 2025-11-06
propietario: equipo-infraestructura
relacionados: ["ADR_008", "ADR_009", "PLAN-INFRA-001"]
---

# Especificación de Feature: CPython Precompilado en Dev Containers

## Metadata

- **ID de Especificación**: SPEC_INFRA_001
- **Nombre de Feature**: Integración de CPython Precompilado en Dev Containers
- **Versión**: 1.0.0
- **Fecha de Creación**: 2025-11-06
- **Autor**: Equipo Infraestructura
- **Estado**: Borrador
- **Prioridad**: Alta
- **Release Target**: Infraestructura v2.0.0

## Trazabilidad

- **Requisitos relacionados**: REQ-INFRA-001, REQ-INFRA-002
- **Issue de GitHub**: Por crear
- **Epic relacionado**: Optimización de Dev Containers
- **ADR relacionado**: ADR_008 (Features vs Imagen Base), ADR_009 (Distribución Artefactos)
- **Casos de uso**: REQ-UC-INFRA-001
- **Reglas de negocio**: N/A

---

## 1. Resumen Ejecutivo

### 1.1 Descripción

Esta feature implementa un sistema de distribución de CPython precompilado para Dev Containers en VS Code, reduciendo drásticamente los tiempos de construcción de entornos de desarrollo. El sistema se basa en compilar el intérprete Python una sola vez en una VM Vagrant controlada y distribuirlo como binario precompilado mediante una Feature personalizada de Dev Containers.

Actualmente, cada vez que un desarrollador construye un Dev Container, el proceso compila CPython desde el código fuente, lo que toma entre 15-20 minutos. Este tiempo se multiplica por cada desarrollador, cada proyecto y cada rebuild, generando pérdida significativa de productividad. La solución propuesta reduce este tiempo a menos de 2 minutos mediante la reutilización de un binario precompilado verificado y versionado.

El enfoque "build once, run everywhere" garantiza reproducibilidad total entre entornos de desarrollo mientras mantiene todas las capacidades nativas de Python (ssl, sqlite3, uuid, lzma, bz2) y la integración completa con VS Code (debugging, linting, testing).

### 1.2 Valor de Negocio

**Reducción de tiempo de onboarding**: Nuevos desarrolladores pueden empezar a trabajar en menos de 5 minutos en lugar de esperar 20+ minutos por cada proyecto.

**Ahorro de costos**: Elimina la dependencia de servicios CI/CD cloud para builds de Python, reduciendo uso de GitHub Actions minutes.

**Estandarización**: Todos los desarrolladores usan exactamente la misma versión de Python con las mismas librerías nativas compiladas, eliminando problemas de "funciona en mi máquina".

**Métricas de éxito**:
- **Tiempo de build de Dev Container**: Reducción de 20 minutos a <2 minutos (90% mejora)
- **Tasa de error por incompatibilidad de entorno**: <1% de builds fallidos
- **Adopción**: >=5 proyectos usando el sistema en primeros 3 meses
- **Cobertura de tests críticos**: 100% de validaciones pasan

### 1.3 Stakeholders

- **Product Owner**: Equipo Infraestructura
- **Patrocinador de Negocio**: Tech Lead IACT
- **Usuarios Finales**: Desarrolladores Python del ecosistema IACT (estimado 5-10 personas)
- **Desarrolladores Asignados**: Por asignar

---

## 2. Contexto y Motivación

### 2.1 Problema Actual

**Pain Points identificados**:

1. **Tiempo de build excesivo**: Cada construcción de Dev Container tarda 15-20 minutos compilando CPython desde fuente. Este tiempo se multiplica por:
   - Cada desarrollador nuevo (onboarding)
   - Cada proyecto nuevo (multi-repo)
   - Cada rebuild por cambios en configuración
   - Cada actualización de versión de Python

2. **Inconsistencias de entorno**: Pequeñas diferencias en versiones de librerías del sistema (OpenSSL, SQLite) pueden causar que Python se compile con diferentes capacidades, generando bugs difíciles de reproducir.

3. **Desperdicio de recursos**: GitHub Actions compila Python repetidamente en CI/CD, consumiendo minutes valiosos del plan gratuito.

4. **Barrera de entrada**: Desarrolladores nuevos se frustran esperando largos builds antes de poder contribuir.

5. **Falta de reproducibilidad**: No hay garantía de que todos usen exactamente el mismo binario de Python con las mismas optimizaciones de compilación.

### 2.2 Solución Propuesta

Implementar un sistema de CPython precompilado distribuido mediante Feature personalizada de Dev Containers, estructurado en 5 componentes:

1. **VM Vagrant como fábrica de compilación**: Una VM con configuración controlada compila CPython con todas las dependencias nativas y optimizaciones necesarias.

2. **Artefacto versionado**: El binario compilado se empaqueta en tarball con checksum SHA256, licencia PSF y metadata de versión.

3. **Distribución via GitHub Releases**: Los artefactos se publican como releases del repositorio, permitiendo descarga pública sin Git LFS.

4. **Feature personalizada**: Un componente declarativo de Dev Container que descarga, valida e instala el artefacto automáticamente.

5. **Validación automática**: Pre-push hooks y tests críticos verifican integridad e integración del sistema.

### 2.3 Alternativas Consideradas

1. **Alternativa A: Imagen base Docker custom con Python preinstalado**
   - Pros: Muy simple, todo incluido en la imagen
   - Contras: Difícil de actualizar, menos flexible, requiere mantener imágenes por versión de Python
   - Razón de descarte: No es composable con otras features, requiere infraestructura de registry

2. **Alternativa B: Script de instalación en Dockerfile**
   - Pros: Implementación trivial
   - Contras: Se repite en cada proyecto, no es reutilizable, no sigue mejores prácticas de Dev Containers
   - Razón de descarte: No promueve reutilización entre proyectos

3. **Alternativa C: Usar Python de paquetes APT del sistema**
   - Pros: Instalación instantánea
   - Contras: Versiones desactualizadas, no permite optimizaciones personalizadas, dependencia de mirrors de Ubuntu
   - Razón de descarte: No permite control total sobre versión y compilación

4. **Alternativa D: Usar imagen oficial Python de Docker Hub**
   - Pros: Mantenida por la comunidad, múltiples versiones
   - Contras: Dependencia externa, no permite customización de compilación, no sigue filosofía "local-first" de IACT
   - Razón de descarte: Pérdida de control sobre toolchain y optimizaciones

---

## 3. Requisitos Funcionales

### 3.1 Casos de Uso

#### UC-1: Compilar CPython en Vagrant

**Actor**: Desarrollador de Infraestructura

**Precondiciones**:
- VM Vagrant está disponible y funcionando
- Conexión a internet para descargar código fuente de CPython
- Directorio `infrastructure/cpython/artifacts/` existe

**Flujo Principal**:
1. Desarrollador ejecuta `make build_cpython`
2. Sistema levanta VM Vagrant con Ubuntu 20.04
3. Sistema instala dependencias de compilación (OpenSSL, SQLite, etc.)
4. Sistema descarga código fuente de CPython desde python.org
5. Sistema configura compilación con flags de optimización
6. Sistema compila CPython con todas las extensiones nativas
7. Sistema empaqueta binario en tarball versionado
8. Sistema genera checksum SHA256
9. Sistema copia artefacto a `infrastructure/cpython/artifacts/`

**Flujo Alterno 1a**: Descarga de código fuente falla
1. Sistema reintenta hasta 3 veces
2. Si falla, muestra error y detiene proceso
3. Desarrollador verifica conectividad y reintenta

**Flujo Alterno 1b**: Compilación falla por falta de dependencias
1. Sistema muestra lista de dependencias faltantes
2. Desarrollador actualiza script de instalación
3. Desarrollador reintenta compilación

**Postcondiciones**:
- Artefacto `.tgz` existe en `infrastructure/cpython/artifacts/`
- Archivo `.sha256` con checksum está presente
- Validación de módulos nativos pasa correctamente

#### UC-2: Instalar CPython Precompilado en Dev Container

**Actor**: Desarrollador (automático al abrir proyecto)

**Precondiciones**:
- Proyecto tiene `.devcontainer/devcontainer.json` configurado
- Feature `cpython-prebuilt` está referenciada
- Artefacto está disponible en GitHub Releases o localmente

**Flujo Principal**:
1. Desarrollador abre proyecto en VS Code
2. VS Code detecta configuración de Dev Container
3. Sistema construye contenedor ejecutando Feature
4. Feature descarga artefacto desde URL configurada
5. Feature valida checksum SHA256
6. Feature descomprime artefacto en `/opt/python-X.Y.Z/`
7. Feature crea symlinks a `python3` y `pip3`
8. Feature configura `LD_LIBRARY_PATH`
9. Feature ejecuta validación de instalación
10. VS Code completa construcción del contenedor
11. Desarrollador empieza a trabajar con Python funcional

**Flujo Alterno 2a**: Checksum SHA256 no coincide
1. Feature muestra error de validación
2. Sistema detiene instalación
3. Desarrollador reporta problema a equipo infraestructura
4. Equipo verifica integridad del artefacto publicado

**Flujo Alterno 2b**: Módulos nativos no funcionan
1. Validación detecta fallo en importación de ssl/sqlite3
2. Sistema muestra error con diagnóstico
3. Desarrollador verifica compatibilidad glibc
4. Equipo infraestructura recompila con configuración ajustada

**Postcondiciones**:
- Python está instalado en `/opt/python-X.Y.Z/`
- Comando `python3 --version` retorna versión correcta
- Módulos nativos (ssl, sqlite3, uuid, lzma, bz2) funcionan
- VS Code puede debuggear código Python

#### UC-3: Actualizar Versión de CPython

**Actor**: Equipo Infraestructura

**Precondiciones**:
- Nueva versión de CPython está disponible en python.org
- Se ha evaluado compatibilidad con proyectos existentes

**Flujo Principal**:
1. Equipo actualiza versión en script de compilación
2. Equipo ejecuta `make build_cpython`
3. Sistema genera nuevo artefacto versionado
4. Equipo ejecuta tests de validación
5. Equipo publica artefacto en GitHub Releases
6. Equipo actualiza documentación de versiones disponibles
7. Equipo notifica a desarrolladores de nueva versión
8. Proyectos actualizan `devcontainer.json` opt-in

**Flujo Alterno 3a**: Tests de validación fallan
1. Equipo investiga incompatibilidades
2. Equipo ajusta configuración de compilación
3. Equipo recompila y retesta
4. Si persiste, se pospone actualización

**Postcondiciones**:
- Nueva versión está disponible en releases
- Documentación refleja nueva versión
- Versión anterior sigue disponible para rollback

### 3.2 Reglas de Negocio

| ID | Regla | Prioridad | Validación |
|----|-------|-----------|------------|
| BR-001 | Mismo sistema base entre Vagrant y contenedor (Ubuntu 20.04 o 24.04) | Alta | Script de build valida versión OS |
| BR-002 | Checksum SHA256 DEBE validarse antes de instalar artefacto | Crítica | Feature ejecuta `sha256sum -c` |
| BR-003 | Artefactos DEBEN incluir LICENSE de CPython (PSF) | Media | Validación manual en checklist |
| BR-004 | Rebuild de CPython cada 6 meses o ante CVE crítico | Alta | Calendario de mantenimiento |
| BR-005 | Mantener últimas 3 versiones de artefactos disponibles | Media | Script de cleanup automático |
| BR-006 | Feature DEBE ser idempotente (detectar instalación existente) | Alta | Test de idempotencia |
| BR-007 | Módulos nativos obligatorios: ssl, sqlite3, uuid, lzma, bz2 | Crítica | Test automatizado marca como @critical |

### 3.3 Criterios de Aceptación

**CA-001**: Build de CPython en Vagrant genera artefacto válido
```gherkin
Given una VM Vagrant limpia con Ubuntu 20.04
When ejecuto el script build_cpython.sh
Then se genera un tarball cpython-X.Y.Z-ubuntu20.04-buildN.tgz
And el tarball contiene el directorio opt/python-X.Y.Z/
And existe archivo .sha256 con checksum correcto
And python3 --version retorna la versión esperada dentro del artefacto
```

**CA-002**: Feature instala CPython correctamente en Dev Container
```gherkin
Given un Dev Container con la Feature cpython-prebuilt configurada
And el artefacto está disponible en GitHub Releases
When VS Code construye el contenedor
Then el build completa en menos de 2 minutos
And python3 --version retorna la versión configurada
And todos los módulos nativos (ssl, sqlite3, uuid, lzma, bz2) se importan sin error
And VS Code puede ejecutar debugging Python
```

**CA-003**: Validación de checksum previene instalación de artefacto corrupto
```gherkin
Given un artefacto con checksum SHA256 inválido
When la Feature intenta instalarlo
Then el proceso falla con mensaje de error claro
And Python NO queda instalado parcialmente
And se documenta el error en logs del contenedor
```

**CA-004**: Feature es idempotente
```gherkin
Given un Dev Container con CPython ya instalado
When se ejecuta la Feature nuevamente
Then detecta la instalación existente
And NO reinstala Python
And completa en menos de 10 segundos
```

**CA-005**: Sistema es opt-in por proyecto
```gherkin
Given un proyecto sin la Feature configurada en devcontainer.json
When se construye el Dev Container
Then Python se instala por el método tradicional
And el comportamiento NO cambia respecto al estado actual
```

**CA-006**: Pre-push hook valida specs antes de push
```gherkin
Given una rama feature/cpython_precompilado con commits
And existe SPEC_INFRA_001 en docs/specs/
When desarrollador ejecuta git push
Then el pre-push hook valida existencia de spec
And valida que tests críticos pasen
And permite el push si todo es válido
```

---

## 4. Requisitos No Funcionales

### 4.1 Performance

- **Tiempo de build de Dev Container**: <2 minutos desde inicio hasta contenedor listo (reducción de 90% vs 20 minutos actuales)
- **Tiempo de descarga de artefacto**: <30 segundos con conexión típica (artefacto ~50-80 MB)
- **Tiempo de validación de checksum**: <5 segundos
- **Tiempo de descompresión e instalación**: <1 minuto
- **Overhead de Feature en rebuilds**: <10 segundos si ya está instalado (idempotencia)

### 4.2 Seguridad

- **Validación de integridad**: Checksum SHA256 OBLIGATORIO antes de instalar
- **Firma digital**: Implementar firma GPG de artefactos (Fase 4)
- **Licenciamiento**: Incluir LICENSE PSF en cada artefacto
- **Auditoría**: Registro de versión y hash en ARTIFACTS.md
- **CVE monitoring**: Revisión semestral de vulnerabilidades de CPython
- **No secrets en artefactos**: Validación automática con detect-secrets

### 4.3 Disponibilidad

- **Disponibilidad de artefactos**: 99.9% (limitado por SLA de GitHub)
- **Fallback**: Documentar procedimiento manual si GitHub está caído
- **Caché local**: Artefactos se cachean en contenedor para rebuilds
- **Versionado**: Mantener 3 últimas versiones disponibles para rollback

### 4.4 Escalabilidad

- **Número de proyectos soportados**: Ilimitado (Feature es reutilizable)
- **Número de versiones de Python**: Hasta 5 versiones simultáneas mantenidas
- **Tamaño de artefactos**: Hasta 100 MB por tarball
- **Storage en GitHub Releases**: Límite de 2 GB por release (suficiente para 20+ artefactos)

### 4.5 Usabilidad

- **Zero-configuration**: Desarrolladores solo agregan 3 líneas en devcontainer.json
- **Mensajes de error claros**: Errores incluyen diagnóstico y pasos de solución
- **Documentación completa**: README, FAQ, troubleshooting guide
- **Compatibilidad VS Code**: 100% compatible con extensiones Python oficiales

### 4.6 Mantenibilidad

- **Cobertura de tests**: >=80% en scripts de compilación
- **Tests críticos**: 100% pasan marcados con @pytest.mark.critical
- **Documentación**: README en cada componente (vagrant/, features/, scripts/)
- **Logging**: Logs detallados de compilación y instalación
- **Versionado semántico**: Artefactos siguen semver (cpython-3.12.6-ubuntu20.04-build1)
- **Trazabilidad**: Todos los archivos referencian SPEC_INFRA_001

---

## 5. Diseño de Solución

### 5.1 Arquitectura de Alto Nivel

```
+------------------------------------------------------------------+
|                     COMPONENTE 1: BUILD                          |
|                                                                   |
|  +-------------+      +----------------+      +-------------+    |
|  |  Vagrant    |----->| build_cpython  |----->|  Artefacto  |    |
|  |  (Ubuntu    |      |     .sh        |      |   .tgz +    |    |
|  |   22.04)    |      |                |      |   .sha256   |    |
|  +-------------+      +----------------+      +-------------+    |
+------------------------------------------------------------------+
                                  |
                                  | publish-artifact.sh
                                  v
+------------------------------------------------------------------+
|                  COMPONENTE 2: DISTRIBUCIÓN                      |
|                                                                   |
|             +-------------------------------+                    |
|             |   GitHub Releases             |                    |
|             |   cpython-3.12.6-build1.tgz   |                    |
|             |   + SHA256 checksum           |                    |
|             |   + LICENSE (PSF)             |                    |
|             +-------------------------------+                    |
+------------------------------------------------------------------+
                                  |
                                  | download via HTTPS
                                  v
+------------------------------------------------------------------+
|                  COMPONENTE 3: INSTALACIÓN                       |
|                                                                   |
|  +-------------------+      +------------------------+           |
|  | devcontainer.json |----->|  Feature: cpython-     |           |
|  | features:         |      |  prebuilt              |           |
|  |   cpython-prebuilt|      |  - install.sh          |           |
|  +-------------------+      |  - validate checksum   |           |
|                             |  - extract to /opt     |           |
|                             |  - create symlinks     |           |
|                             +------------------------+           |
+------------------------------------------------------------------+
                                  |
                                  v
+------------------------------------------------------------------+
|                  COMPONENTE 4: USO (Dev Container)               |
|                                                                   |
|  +-------------+      +---------------+      +----------------+  |
|  |  VS Code    |----->| Python 3.12.6 |----->| Django Project |  |
|  | Extensions  |      | /opt/python-  |      |                |  |
|  | (debugging, |      | 3.12.6/       |      |                |  |
|  |  linting)   |      +---------------+      +----------------+  |
+------------------------------------------------------------------+
```

### 5.2 Modelo de Datos

**Artefacto CPython**: Estructura del tarball

```
cpython-3.12.6-ubuntu20.04-build1.tgz
  /opt/
    /python-3.12.6/
      /bin/
        python3
        python3.12
        pip3
        pip3.12
      /lib/
        libpython3.12.so
        /python3.12/
          /site-packages/
          /lib-dynload/
            _ssl.cpython-312-x86_64-linux-gnu.so
            _sqlite3.cpython-312-x86_64-linux-gnu.so
            _uuid.cpython-312-x86_64-linux-gnu.so
            _lzma.cpython-312-x86_64-linux-gnu.so
            _bz2.cpython-312-x86_64-linux-gnu.so
      /include/
        /python3.12/
          Python.h
      /share/
        /man/
```

**Metadata de Artefacto**: `artifacts/ARTIFACTS.md`

```markdown
| Versión | Build | Distro | Fecha | SHA256 | URL Release | Estado |
|---------|-------|--------|-------|--------|-------------|--------|
| 3.12.6  | 1     | ubuntu20.04 | 2025-11-06 | abc123... | https://... | Activo |
| 3.12.5  | 2     | ubuntu20.04 | 2025-09-15 | def456... | https://... | Deprecado |
```

**No se requieren cambios en base de datos Django**

### 5.3 API Endpoints

**No aplica** - Esta feature no expone endpoints HTTP. La distribución es via HTTPS estático (GitHub Releases).

### 5.4 Lógica de Negocio

**Algoritmo de compilación** (`build_cpython.sh`):

```bash
# Pseudocódigo de lógica de compilación

function build_cpython():
    # 1. Preparación
    validate_os_version()  # Debe ser Ubuntu 20.04 o 24.04
    install_build_dependencies()  # OpenSSL, SQLite, etc.

    # 2. Descarga
    download_cpython_source(version)
    verify_gpg_signature()  # Firma de Python Release Team

    # 3. Configuración
    configure_flags = [
        "--prefix=/opt/python-{version}",
        "--enable-optimizations",  # PGO + LTO
        "--with-lto",
        "--enable-shared",
        "--with-system-ffi",
        "--with-openssl=/usr",
        "--with-sqlite3=/usr"
    ]

    # 4. Compilación
    run_configure(configure_flags)
    run_make(jobs=cpu_count())
    run_make_install()

    # 5. Validación
    validate_modules(['ssl', 'sqlite3', 'uuid', 'lzma', 'bz2'])

    # 6. Empaquetado
    create_tarball()
    generate_sha256()
    include_license()

    return artifact_path
```

**Algoritmo de instalación** (`install.sh` en Feature):

```bash
# Pseudocódigo de lógica de instalación

function install_cpython_prebuilt():
    # 1. Detección idempotente
    if python_already_installed(version):
        log("Python {version} ya instalado, saltando...")
        return

    # 2. Descarga
    artifact_url = get_artifact_url(version)
    download_file(artifact_url, "/tmp/cpython.tgz")
    download_file(artifact_url + ".sha256", "/tmp/cpython.tgz.sha256")

    # 3. Validación de integridad
    if not verify_checksum("/tmp/cpython.tgz", "/tmp/cpython.tgz.sha256"):
        error("Checksum inválido, artefacto corrupto o alterado")
        exit(1)

    # 4. Extracción
    extract_tarball("/tmp/cpython.tgz", "/")

    # 5. Configuración de sistema
    create_symlink("/opt/python-{version}/bin/python3", "/usr/local/bin/python3")
    create_symlink("/opt/python-{version}/bin/pip3", "/usr/local/bin/pip3")

    # 6. Configuración de librerías compartidas
    write_file("/etc/ld.so.conf.d/python.conf", "/opt/python-{version}/lib")
    run_ldconfig()

    # 7. Validación post-instalación
    validate_installation():
        assert run("python3 --version").contains(version)
        assert run("python3 -c 'import ssl'").success
        assert run("python3 -c 'import sqlite3'").success
        # ... validar otros módulos

    log("CPython {version} instalado correctamente")
```

### 5.5 Interfaces de Usuario

**No aplica** - Esta feature es de infraestructura sin UI gráfica.

La "interfaz" es la configuración declarativa en `devcontainer.json`:

```json
{
  "name": "IACT Django Project",
  "features": {
    "./infrastructure/cpython/installer": {
      "version": "3.12.6",
      "artifactUrl": "https://github.com/2-Coatl/IACT---project/releases/download/cpython-3.12.6-build1/cpython-3.12.6-ubuntu20.04-build1.tgz"
    }
  }
}
```

---

## 6. Dependencias

### 6.1 Dependencias Técnicas

**Nuevas librerías requeridas**: Ninguna (solo herramientas de sistema)

**Servicios externos**:
- **python.org**: Descarga de código fuente de CPython (SLA: 99.9%)
- **GitHub Releases**: Hosting de artefactos (SLA: 99.9%)
- **APT repositories Ubuntu**: Dependencias de compilación (mirrors oficiales)

**Herramientas de sistema requeridas**:
- Vagrant >= 2.3.0
- VirtualBox >= 7.0 (o provider equivalente)
- `gh` CLI para publicar releases
- `wget` o `curl` para descargas
- `sha256sum` para validación
- `tar` para empaquetado

### 6.2 Dependencias de Otras Features

- **Sistema spec-driven**: SPEC_INFRA_001 debe existir antes de implementar
- **Pre-push hook**: Valida specs y tests antes de push
- **Constitution AI**: Agentes validan contra principios (no emojis, trazabilidad)

### 6.3 Dependencias de Infraestructura

**Vagrant VM**:
- Ubuntu 20.04 LTS (alineado con Dev Containers)
- Mínimo 2 GB RAM, 10 GB disco
- Conexión a internet para descargas

**Dev Containers**:
- VS Code >= 1.80.0
- Docker Desktop >= 4.20.0
- Extensión Dev Containers instalada

**Git**:
- Git >= 2.30.0
- Git LFS (opcional, solo si se usa para distribución)

**Variables de entorno**: Ninguna requerida (todo en configuración declarativa)

---

## 7. Plan de Testing

### 7.1 Estrategia de Testing

- **Tests Unitarios**: Scripts individuales (build, validate, install) - Cobertura 80%
- **Tests de Integración**: Build completo en Vagrant → Instalación en Dev Container
- **Tests Críticos**: Marcados con `@pytest.mark.critical` ejecutados en pre-push
- **Tests de Compatibilidad**: Validar en Ubuntu 20.04 y 24.04
- **Tests de Performance**: Medir tiempos de build <2min
- **Tests de Seguridad**: Validación de checksums, detección de secrets

### 7.2 Casos de Prueba

| ID | Descripción | Tipo | Prioridad | Criterio Aceptación |
|----|-------------|------|-----------|---------------------|
| CP-001 | Build de CPython genera artefacto válido | Integración | Crítica | CA-001 |
| CP-002 | Feature instala CPython en <2min | Performance | Crítica | CA-002 |
| CP-003 | Validación de checksum detecta corrupción | Seguridad | Crítica | CA-003 |
| CP-004 | Feature es idempotente | Funcional | Alta | CA-004 |
| CP-005 | Módulos nativos ssl, sqlite3 funcionan | Funcional | Crítica | CA-002 |
| CP-006 | VS Code debugging funciona | Integración | Alta | CA-002 |
| CP-007 | Rollback a versión anterior funciona | Funcional | Media | N/A |
| CP-008 | Feature no afecta proyectos sin configuración | Regresión | Alta | CA-005 |
| CP-009 | Pre-push hook valida spec | Integración | Alta | CA-006 |

### 7.3 Datos de Prueba

**Artefactos de prueba**:
- CPython 3.12.6 compilado en Ubuntu 20.04
- Artefacto corrupto (para test de checksum)
- Artefacto con checksum inválido

**Proyectos de prueba**:
- Proyecto Django simple con Django 5.0
- Proyecto con requirements.txt extenso
- Proyecto sin Feature (control negativo)

---

## 8. Plan de Despliegue

### 8.1 Estrategia de Deploy

- **Tipo**: Manual gradual por fases (no requiere CD automatizado)
- **Fase 0**: Solo documentación (sin código)
- **Fase 1**: Build en Vagrant (local, sin distribución)
- **Fase 2**: Feature local (sin GitHub Releases)
- **Fase 3**: Integración completa con 1 proyecto piloto
- **Fase 4**: Expansión a múltiples proyectos
- **Rollback plan**: Remover Feature de `devcontainer.json` (3 líneas)

### 8.2 Configuración Requerida

**Variables de entorno**: Ninguna requerida

**Cambios en archivos de proyecto**:

En `.devcontainer/devcontainer.json` (opt-in por proyecto):
```json
{
  "features": {
    "./infrastructure/cpython/installer": {
      "version": "3.12.6"
    }
  }
}
```

En `mkdocs.yml` (documentación):
```yaml
nav:
  - Infraestructura:
    - CPython Precompilado:
      - README: infraestructura/cpython_precompilado/README.md
```

**No se requieren cambios en settings.py de Django**

### 8.3 Migraciones de Datos

**No aplica** - Esta feature no modifica bases de datos.

### 8.4 Documentación para Despliegue

- **Runbook**: `docs/infrastructure/cpython_precompilado/README.md`
- **Rollback procedure**: Remover Feature de `devcontainer.json` y rebuild
- **Troubleshooting**: `docs/infrastructure/cpython_precompilado/preguntas_frecuentes.md`

---

## 9. Plan de Rollout

### 9.1 Feature Flags

**No aplica** - La Feature es opt-in por naturaleza (se activa agregándola a `devcontainer.json`).

No se requiere sistema de feature flags porque cada proyecto decide individualmente si la usa.

### 9.2 Fases de Rollout

**Fase 0 - Especificación y Diseño** (1 semana):
- Crear SPEC_INFRA_001, ADRs, documentación
- Validar diseño con equipo
- Aprobación de stakeholders

**Fase 1 - Compilación en Vagrant** (1 semana):
- Implementar scripts de build
- Generar primer artefacto
- Validar módulos nativos

**Fase 2 - Feature Personalizada** (1 semana):
- Implementar Feature de Dev Container
- Tests de instalación local
- Documentación de uso

**Fase 3 - Integración y Validación** (1 semana):
- Publicar en GitHub Releases
- Integrar en 1 proyecto piloto
- Tests de integración completos

**Fase 4 - Optimización y Escalado** (2 semanas):
- Wheelhouse de dependencias
- Expansión a 3+ proyectos
- Sistema de actualización automatizado

### 9.3 Métricas de Monitoreo

**Métricas clave a monitorear**:
- **Tiempo de build de Dev Container**: Objetivo <2 minutos (alerta si >3min)
- **Tasa de fallo de builds**: Objetivo <1% (alerta si >5%)
- **Descargas de artefactos**: Tracking de GitHub Release insights
- **Adopción por proyecto**: Objetivo >=5 proyectos en 3 meses
- **Tests críticos**: 100% pasan (alerta si alguno falla)

---

## 10. Riesgos e Impacto

### 10.1 Riesgos Identificados

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Incompatibilidad glibc entre Vagrant y Dev Container | Media | Alto | Usar exactamente Ubuntu 20.04 en ambos, validar versión |
| Artefacto corrupto o alterado | Baja | Crítico | Validación SHA256 obligatoria, firma GPG en Fase 4 |
| GitHub Releases no disponible | Baja | Medio | Documentar fallback manual, considerar mirror local |
| Módulos nativos faltan por libs dev ausentes | Media | Alto | Checklist de dependencias, validación automática post-build |
| Artefactos grandes inflan repositorio Git | Alta | Bajo | Usar GitHub Releases (NO Git LFS ni commit directo) |
| CVE en versión de Python sin actualización | Media | Alto | Monitoreo semestral, rebuild obligatorio ante CVE crítico |
| Desarrollador no tiene `gh` CLI instalado | Media | Bajo | Documentar instalación, incluir en onboarding |

### 10.2 Impacto en Usuarios

- **Usuarios afectados**: 0 inicialmente (opt-in), potencial 5-10 desarrolladores en 3 meses
- **Cambios en UX**: Mejora significativa - builds 90% más rápidos
- **Migración requerida**: No - proyectos actuales siguen funcionando sin cambios
- **Curva de aprendizaje**: Mínima - solo agregar 3 líneas en `devcontainer.json`

### 10.3 Impacto en Sistema

- **Performance**: Mejora dramática - builds de 20min a <2min
- **Almacenamiento**: +50-80 MB por artefacto en GitHub Releases (límite 2GB total)
- **Ancho de banda**: ~50-80 MB de descarga por build (caché local reduce rebuilds)
- **Costos**: Reducción de GitHub Actions minutes (ahorro estimado 50%)

---

## 11. Documentación

### 11.1 Documentación Técnica

- [x] Arquitectura documentada en `docs/infrastructure/cpython_precompilado/arquitectura.md`
- [x] ADR_008 creado: Features vs Imagen Base
- [x] ADR_009 creado: Estrategia de distribución
- [ ] Scripts documentados con docstrings y comentarios
- [ ] Diagramas de flujo en PlantUML/Mermaid

### 11.2 Documentación de Usuario

- [x] README creado en `docs/infrastructure/cpython_precompilado/README.md`
- [x] FAQ creado en `preguntas_frecuentes.md`
- [ ] Release notes para cada versión de artefacto
- [ ] Tutorial en video (opcional, Fase 4)

### 11.3 Documentación de Operaciones

- [ ] Runbook de compilación en Vagrant
- [ ] Runbook de publicación de releases
- [ ] Procedimiento de actualización semestral
- [ ] Troubleshooting guide completo

---

## 12. Criterios de Completitud

Esta feature se considera completa cuando:

- [x] SPEC_INFRA_001 creado y validado con `make validate_spec`
- [ ] ADR_008 y ADR_009 aprobados
- [ ] Scripts de compilación funcionan en Vagrant
- [ ] Primer artefacto generado y validado
- [ ] Feature de Dev Container instalada correctamente
- [ ] Tests críticos marcan 100% pasan
- [ ] Build de Dev Container <2 minutos confirmado
- [ ] Módulos nativos (ssl, sqlite3, uuid, lzma, bz2) funcionan
- [ ] VS Code debugging funciona
- [ ] Proyecto piloto funciona sin errores
- [ ] Documentación completa y revisada
- [ ] Pre-push hook valida spec y tests
- [ ] Artefacto publicado en GitHub Releases
- [ ] ARTIFACTS.md actualizado con metadata
- [ ] Rollback testeado exitosamente

---

## 13. Aprobaciones

| Rol | Nombre | Fecha | Firma/Aprobación |
|-----|--------|-------|------------------|
| Product Owner | Por asignar | | |
| Arquitecto | Por asignar | | |
| Tech Lead | Por asignar | | |
| DevOps Lead | Por asignar | | |

---

## 14. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-06 | Equipo Infraestructura | Versión inicial de especificación |

---

## Referencias

- [ISO 29148:2018](https://www.iso.org/standard/72089.html) - Requirements engineering
- [Guía de desarrollo de features](../../gobernanza/procesos/guia_completa_desarrollo_features.md)
- [Constitution para agentes AI](../../gobernanza/agentes/constitution.md)
- [Guía de estilo](../../gobernanza/GUIA_ESTILO.md)
- [Dev Containers Specification](https://containers.dev/)
- [CPython Build Instructions](https://devguide.python.org/getting-started/setup-building/)
- [PSF License](https://docs.python.org/3/license.html)
- ADR_008: Features vs Imagen Base Custom
- ADR_009: Estrategia de Distribución de Artefactos

---

**Documento generado siguiendo plantilla formal ISO 29148:2018**
**Referencia**: SPEC_INFRA_001
**Trazabilidad**: Todos los componentes deben referenciar este spec
