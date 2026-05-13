# Arquitectura del Sistema CPython Precompilado

**Versión**: 1.0.0
**Fecha**: 2025-11-06
**Referencia**: SPEC_INFRA_001
**Audiencia**: Desarrolladores de Infraestructura, Arquitectos

---

## Visión General

El sistema de CPython precompilado sigue una arquitectura de 4 componentes independientes que se integran mediante estándares abiertos (GitHub Releases, Dev Containers Features).

**Principio rector**: "Build once, run everywhere"

---

## Componentes del Sistema

### Componente 1: Fábrica de Compilación (Vagrant)

**Responsabilidad**: Compilar CPython desde código fuente en entorno controlado y reproducible.

**Tecnologías**:
- Vagrant >= 2.3.0
- VirtualBox 7.0 (provider)
- Ubuntu 20.04 LTS (guest OS)
- Bash scripts para automatización

**Entradas**:
- Código fuente de CPython desde python.org
- Script de configuración: `build_cpython.sh`
- Flags de optimización definidos

**Salidas**:
- Tarball: `cpython-X.Y.Z-ubuntu20.04-buildN.tgz`
- Checksum: `cpython-X.Y.Z-ubuntu20.04-buildN.tgz.sha256`
- Metadata de build (fecha, versión de libs)

**Ubicación en proyecto**:
```
infrastructure/cpython/
├── Vagrantfile
├── build_cpython.sh
├── validate_build.sh
└── README.md
```

**Flujo de compilación**:
```
1. Vagrant provision
   ├─> Instalar dependencias dev (OpenSSL, SQLite, etc.)
   ├─> Descargar código fuente CPython
   ├─> Verificar firma GPG (opcional)
   └─> Configurar con flags de optimización

2. Compilación
   ├─> ./configure --enable-optimizations --with-lto ...
   ├─> make -j$(nproc)
   └─> make install (a /opt/python-X.Y.Z)

3. Validación
   ├─> Verificar módulos nativos (ssl, sqlite3, uuid, lzma, bz2)
   ├─> Ejecutar test suite básico
   └─> Verificar versión

4. Empaquetado
   ├─> Crear tarball desde /opt/python-X.Y.Z
   ├─> Generar SHA256 checksum
   └─> Incluir LICENSE (PSF)

5. Output
   └─> Copiar a /vagrant/infrastructure/cpython/artifacts/
```

**Flags de compilación críticos**:
```bash
--prefix=/opt/python-X.Y.Z       # Instalación aislada
--enable-optimizations           # PGO (Profile-Guided Optimization)
--with-lto                        # Link-Time Optimization
--enable-shared                   # Librerías compartidas
--with-system-ffi                 # Usar libffi del sistema
--with-openssl=/usr               # OpenSSL system
--with-sqlite3=/usr               # SQLite system
```

**Consideraciones de reproducibilidad**:
- Misma versión de Ubuntu que Dev Containers (22.04)
- Mismas versiones de dependencias del sistema (apt packages)
- Documentar versiones exactas en metadata de artefacto

---

### Componente 2: Sistema de Distribución (GitHub Releases)

**Responsabilidad**: Almacenar, versionar y distribuir artefactos de forma segura y confiable.

**Tecnologías**:
- GitHub Releases
- gh CLI para automatización
- HTTPS para descarga

**Estructura de Release**:
```
Release Tag: cpython-3.12.6-build1
├── Title: "CPython 3.12.6 Build 1 (Ubuntu 20.04)"
├── Notes: Metadata de compilación, versiones de libs
└── Assets:
    ├── cpython-3.12.6-ubuntu20.04-build1.tgz       (50-80 MB)
    └── cpython-3.12.6-ubuntu20.04-build1.tgz.sha256 (< 1 KB)
```

**Naming convention** (semántico):
```
cpython-<major>.<minor>.<patch>-<distro>-build<n>.tgz

Ejemplos:
- cpython-3.12.6-ubuntu20.04-build1.tgz
- cpython-3.12.6-ubuntu24.04-build1.tgz
- cpython-3.11.9-ubuntu20.04-build2.tgz
```

**Proceso de publicación**:
```bash
# Desde Vagrant (manual)
cd /vagrant/infraestructura/cpython/artifacts/

gh release create cpython-3.12.6-build1 \
  cpython-3.12.6-ubuntu20.04-build1.tgz \
  cpython-3.12.6-ubuntu20.04-build1.tgz.sha256 \
  --title "CPython 3.12.6 Build 1 (Ubuntu 20.04)" \
  --notes "Compilado con OpenSSL 3.0.2, SQLite 3.37.2, ..."

# Actualizar registro
echo "| 3.12.6 | 1 | ubuntu20.04 | 2025-11-06 | <sha256> | <url> | Activo |" \
  >> ../../ARTIFACTS.md
```

**URLs de descarga** (estables):
```
Base URL: https://github.com/2-Coatl/IACT---project/releases/download/
          <tag>/<filename>

Ejemplo:
https://github.com/2-Coatl/IACT---project/releases/download/
cpython-3.12.6-build1/cpython-3.12.6-ubuntu20.04-build1.tgz
```

**Política de retención**:
- Mantener últimas 3 versiones activas
- Versiones antiguas marcar como "deprecadas" (no eliminar)
- Archivar versiones >1 año sin uso

---

### Componente 3: Feature de Dev Container

**Responsabilidad**: Descargar, validar e instalar CPython en Dev Container durante construcción.

**Tecnologías**:
- Dev Containers Features Specification
- Bash scripts (install.sh)
- JSON descriptor (devcontainer_feature.json)

**Ubicación en proyecto**:
```
infrastructure/cpython/installer/
├── devcontainer_feature.json    # Metadata y opciones
├── install.sh                   # Lógica de instalación
└── README.md                    # Documentación de Feature
```

**Descriptor de Feature** (`devcontainer_feature.json`):
```json
{
  "id": "cpython-prebuilt",
  "version": "1.0.0",
  "name": "CPython Precompilado",
  "description": "Instala CPython precompilado desde artefacto verificado",
  "options": {
    "version": {
      "type": "string",
      "default": "3.12.6",
      "description": "Versión de Python a instalar"
    },
    "artifactUrl": {
      "type": "string",
      "description": "URL del artefacto (opcional, usa GitHub Releases por defecto)"
    },
    "buildNumber": {
      "type": "string",
      "default": "1",
      "description": "Número de build del artefacto"
    }
  }
}
```

**Flujo de instalación** (`install.sh`):
```
1. Detección idempotente
   └─> if [ -d "/opt/python-${VERSION}" ]; then exit 0; fi

2. Construcción de URL
   ├─> Si artifactUrl está definido: usar eso
   └─> Si no: construir URL desde GitHub Releases

3. Descarga
   ├─> wget artefacto.tgz
   └─> wget artefacto.tgz.sha256

4. Validación de integridad
   ├─> cd /tmp && sha256sum -c artefacto.tgz.sha256
   └─> if fail: error y exit 1

5. Extracción
   └─> tar xzf /tmp/artefacto.tgz -C /

6. Configuración del sistema
   ├─> ln -sf /opt/python-${VERSION}/bin/python3 /usr/local/bin/python3
   ├─> ln -sf /opt/python-${VERSION}/bin/pip3 /usr/local/bin/pip3
   ├─> echo "/opt/python-${VERSION}/lib" > /etc/ld.so.conf.d/python.conf
   └─> ldconfig

7. Validación post-instalación
   ├─> python3 --version
   ├─> python3 -c "import ssl, sqlite3, uuid, lzma, bz2"
   └─> if fail: error con diagnóstico

8. Limpieza
   └─> rm /tmp/artefacto.tgz*
```

**Idempotencia**:
La Feature detecta si Python ya está instalado y no reinstala, reduciendo tiempos en rebuilds:
```bash
if [ -d "/opt/python-${VERSION}" ] && [ -x "/opt/python-${VERSION}/bin/python3" ]; then
    echo "Python ${VERSION} ya instalado, saltando..."
    exit 0
fi
```

---

### Componente 4: Dev Container (Consumidor)

**Responsabilidad**: Ejecutar el entorno de desarrollo con Python precompilado integrado.

**Configuración** (`.devcontainer/devcontainer.json`):
```json
{
  "name": "IACT Django Project",
  "build": {
    "dockerfile": "Dockerfile",
    "context": ".."
  },
  "features": {
    "./infrastructure/cpython/installer": {
      "version": "3.12.6",
      "buildNumber": "1"
    }
  },
  "customizations": {
    "vscode": {
      "settings": {
        "python.defaultInterpreterPath": "/usr/local/bin/python3"
      },
      "extensions": [
        "ms-python.python",
        "ms-python.vscode-pylance",
        "ms-python.debugpy"
      ]
    }
  }
}
```

**Integración con VS Code**:
```
VS Code
├─> Detecta .devcontainer/
├─> Ejecuta docker build
│   └─> Ejecuta Features durante build
│       └─> cpython-prebuilt instala Python
├─> Monta código fuente
├─> Configura extensiones
└─> Desarrollador trabaja con Python funcional
```

**Tiempo de build esperado**:
```
Primera construcción (cold):
├─> Docker: pull base image (~30s)
├─> Dockerfile: instalar deps sistema (~45s)
├─> Feature CPython: download + install (~30s)
└─> VS Code: configuración extensiones (~15s)
Total: ~2 minutos

Rebuilds (warm):
├─> Docker: cache layers (~5s)
├─> Feature: detección idempotente (~5s)
└─> VS Code: configuración (~5s)
Total: <20 segundos
```

---

## Diagrama de Arquitectura Completo

```
┌─────────────────────────────────────────────────────────────────────────┐
│  FASE 1: BUILD (Una vez, controlada)                                     │
│                                                                           │
│  ┌──────────────┐   build_cpython.sh   ┌─────────────────────────┐     │
│  │   Vagrant    │ ──────────────────> │  CPython 3.12.6         │     │
│  │  (Ubuntu     │                      │  + OpenSSL 3.0          │     │
│  │   22.04)     │                      │  + SQLite 3.37          │     │
│  └──────────────┘                      │  + Optimizaciones PGO   │     │
│                                         └─────────────────────────┘     │
│                                                    │                     │
│                                                    │ tar czf             │
│                                                    ▼                     │
│                                         ┌─────────────────────────┐     │
│                                         │ cpython-3.12.6-         │     │
│                                         │ ubuntu20.04-build1.tgz  │     │
│                                         │ + .sha256 checksum      │     │
│                                         └─────────────────────────┘     │
└─────────────────────────────────────────────────────────────────────────┘
                                                    │
                                                    │ gh release create
                                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  FASE 2: DISTRIBUCIÓN (GitHub, global)                                   │
│                                                                           │
│           ┌────────────────────────────────────────────────┐            │
│           │         GitHub Releases                        │            │
│           │  Tag: cpython-3.12.6-build1                    │            │
│           │  Assets:                                       │            │
│           │    - cpython-3.12.6-ubuntu20.04-build1.tgz     │            │
│           │    - cpython-3.12.6-ubuntu20.04-build1.tgz.sha │            │
│           │  URL: https://github.com/.../releases/...      │            │
│           └────────────────────────────────────────────────┘            │
└─────────────────────────────────────────────────────────────────────────┘
                                                    │
                                                    │ wget (HTTPS)
                                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  FASE 3: INSTALACIÓN (Dev Container build time)                          │
│                                                                           │
│  ┌──────────────────────┐          ┌─────────────────────────────┐     │
│  │ devcontainer.json    │ ──────> │  Feature: cpython-prebuilt  │     │
│  │  features:           │  activa  │  - install.sh               │     │
│  │    cpython-prebuilt  │          │  - download artefacto       │     │
│  └──────────────────────┘          │  - validar SHA256           │     │
│                                     │  - extract a /opt/          │     │
│                                     │  - symlinks                 │     │
│                                     └─────────────────────────────┘     │
│                                                    │                     │
│                                                    │ instala en          │
│                                                    ▼                     │
│                                     ┌─────────────────────────────┐     │
│                                     │ /opt/python-3.12.6/         │     │
│                                     │ /usr/local/bin/python3 →    │     │
│                                     └─────────────────────────────┘     │
└─────────────────────────────────────────────────────────────────────────┘
                                                    │
                                                    │ uso diario
                                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  FASE 4: USO (Desarrollo diario)                                         │
│                                                                           │
│  ┌──────────────┐      usa      ┌─────────────────────┐                │
│  │   VS Code    │ ────────────> │  Python 3.12.6      │                │
│  │  Extensions  │               │  Django 5.0         │                │
│  │  - Pylance   │               │  PostgreSQL client  │                │
│  │  - Debugger  │               │  Desarrollador      │                │
│  └──────────────┘               │  codifica           │                │
│                                  └─────────────────────┘                │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Flujo de Datos

### Datos en Reposo

| Ubicación | Tipo | Tamaño | Versionado |
|-----------|------|--------|------------|
| `infrastructure/cpython/` | Scripts de build | ~10 KB | Git |
| `infrastructure/cpython/artifacts/` (local Vagrant) | Tarball compilado | 50-80 MB | No versionado (temporal) |
| GitHub Releases | Tarball publicado | 50-80 MB | Tag de Git |
| `artifacts/ARTIFACTS.md` (Git) | Metadata de artefactos | <10 KB | Git |
| `.devcontainer/features/` | Scripts de Feature | ~5 KB | Git |
| `/opt/python-X.Y.Z/` (contenedor) | Python instalado | 50-80 MB | Efímero (por contenedor) |

### Datos en Tránsito

| Origen | Destino | Protocolo | Seguridad |
|--------|---------|-----------|-----------|
| python.org | Vagrant | HTTPS | TLS 1.2+, GPG signature (opcional) |
| Vagrant | artifacts/ local | Filesystem | N/A (mismo host) |
| artifacts/ | GitHub Releases | HTTPS (gh CLI) | TLS 1.2+, GitHub auth |
| GitHub Releases | Dev Container | HTTPS (wget) | TLS 1.2+, SHA256 verificación |

---

## Matriz de Compatibilidad

### Sistemas Operativos

| OS Vagrant | OS Dev Container | Compatible | Notas |
|------------|------------------|------------|-------|
| Ubuntu 20.04 | Ubuntu 20.04 | Sí | Configuración recomendada |
| Ubuntu 20.04 | Ubuntu 24.04 | Probablemente | Validar glibc version |
| Ubuntu 24.04 | Ubuntu 20.04 | No | glibc too new en build |
| Ubuntu 20.04 | Debian 11 | Probablemente | Validar libs |
| Ubuntu 20.04 | Alpine | No | musl vs glibc incompatible |

**Regla de oro**: Vagrant y Dev Container deben usar la misma versión de Ubuntu.

### Versiones de Python

| Python | Ubuntu 20.04 | Ubuntu 24.04 | Estado |
|--------|--------------|--------------|--------|
| 3.12.6 | Soportado | Soportado | Activo |
| 3.12.x | Soportado | Soportado | Bajo demanda |
| 3.11.x | Soportado | Soportado | Bajo demanda |
| 3.10.x | Soportado | Soportado | Bajo demanda |
| <3.10 | No recomendado | No recomendado | EOL cercano |

---

## Seguridad

### Validaciones de Integridad

**En compilación** (Vagrant):
```bash
# Opcional: verificar firma GPG de código fuente CPython
gpg --verify Python-3.12.6.tgz.asc Python-3.12.6.tgz

# Generar checksum del artefacto
sha256sum cpython-3.12.6-ubuntu20.04-build1.tgz > cpython-3.12.6-ubuntu20.04-build1.tgz.sha256
```

**En instalación** (Feature):
```bash
# OBLIGATORIO: validar checksum antes de extraer
sha256sum -c cpython-3.12.6-ubuntu20.04-build1.tgz.sha256
if [ $? -ne 0 ]; then
    echo "ERROR: Checksum inválido, artefacto corrupto o alterado"
    exit 1
fi
```

### Superficie de Ataque

**Riesgos identificados**:

1. **Artefacto comprometido en GitHub**
   - Mitigación: Validación SHA256 obligatoria
   - Futuro: Firma GPG de artefactos

2. **Man-in-the-Middle durante descarga**
   - Mitigación: HTTPS obligatorio, checksum valida integridad

3. **Código malicioso en build script**
   - Mitigación: Scripts versionados en Git, code review
   - Validación: Pre-commit hooks, bandit, ruff

4. **CVE en versión de CPython**
   - Mitigación: Monitoreo semestral, rebuild ante CVE crítico

---

## Performance

### Benchmarks Esperados

| Métrica | Sin Feature (compilar) | Con Feature | Mejora |
|---------|------------------------|-------------|--------|
| Primera construcción | 20 min | 2 min | 90% |
| Rebuild (sin cambios) | 18 min | 15 seg | 98% |
| Descarga artefacto | N/A | 30 seg | N/A |
| Validación checksum | N/A | 3 seg | N/A |
| Extracción tarball | N/A | 25 seg | N/A |

### Bottlenecks

- **Descarga de GitHub**: Limitado por ancho de banda de red
  - Mitigación: Artefacto local opcional
- **Extracción del tarball**: Limitado por I/O de disco
  - Mitigación: Docker con overlay2 filesystem

---

## Escalabilidad

### Límites del Sistema

| Recurso | Límite | Notas |
|---------|--------|-------|
| Tamaño de artefacto | 2 GB | Límite de GitHub Releases (actual ~80 MB) |
| Número de releases | Ilimitado | GitHub Free |
| Descargas simultáneas | Ilimitado | CDN de GitHub |
| Proyectos usando Feature | Ilimitado | Feature es reutilizable |
| Versiones de Python | 5 activas recomendado | Mantenimiento manual |

### Escalabilidad Horizontal

El sistema escala horizontalmente sin modificaciones:
- Cada proyecto es independiente
- Cada desarrollador descarga una vez (luego caché)
- GitHub Releases usa CDN global

---

## Mantenimiento

### Tareas Periódicas

**Semestrales**:
- Rebuild de todas las versiones activas (actualizar libs del sistema)
- Revisión de CVEs de CPython
- Limpieza de versiones deprecadas

**Por versión nueva de Python**:
- Compilar nuevo artefacto en Vagrant
- Publicar en GitHub Releases
- Actualizar `ARTIFACTS.md`
- Notificar a desarrolladores

**Por CVE crítico**:
- Rebuild urgente de versión afectada
- Publicar nuevo build incrementado
- Comunicación prioritaria

---

## Monitoreo y Observabilidad

### Métricas Clave

| Métrica | Herramienta | Umbral Alerta |
|---------|-------------|---------------|
| Tiempo de build de contenedor | Logs VS Code | >5 min |
| Tasa de error de checksum | Logs Feature | >1% |
| Descargas de artefactos | GitHub Insights | Informacional |
| Uso de espacio en Releases | GitHub | >1.5 GB |

### Logs

**Build de Vagrant**:
```
infrastructure/cpython/.vagrant/logs/build-YYYY-MM-DD.log
```

**Instalación de Feature**:
```
# En VS Code Dev Container logs
View → Output → Dev Containers
```

**Validación**:
```bash
# Dentro del contenedor
cat /opt/python-3.12.6/.build-info
```

---

## Referencias

- [SPEC_INFRA_001: Especificación completa](../../specs/SPEC_INFRA_001-cpython_precompilado.md)
- [ADR_008: Decisión Features vs Imagen Base](../../adr/ADR_008-cpython-features-vs-imagen-base.md)
- [ADR_009: Decisión distribución artefactos](../../adr/ADR_009-distribucion-artefactos-strategy.md)
- [Dev Containers Specification](https://containers.dev/)
- [GitHub Releases Documentation](https://docs.github.com/en/repositories/releasing-projects-on-github)

---

**Documento versión**: 1.0.0
**Última actualización**: 2025-11-06
**Mantenido por**: Equipo Infraestructura IACT
