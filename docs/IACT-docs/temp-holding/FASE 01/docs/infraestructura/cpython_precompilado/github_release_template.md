# Template: GitHub Release - CPython Precompilado

Use este template al crear una GitHub Release para publicar un artefacto CPython.

---

## Título del Release

```
CPython {VERSION} Precompilado - Build {BUILD_NUMBER}
```

**Ejemplo**: `CPython 3.12.6 Precompilado - Build 1`

---

## Tag

```
cpython-{VERSION}-build{BUILD_NUMBER}
```

**Ejemplo**: `cpython-3.12.6-build1`

---

## Descripción del Release (Body)

```markdown
## CPython {VERSION} Precompilado - Build {BUILD_NUMBER}

### Características

- **Versión**: Python {VERSION}
- **Optimizaciones**: PGO + LTO habilitadas
- **Sistema base**: Ubuntu 20.04 LTS (jammy)
- **Arquitectura**: x86_64
- **Build date**: {DATE}
- **Toolchain**: GCC 11.4.0

### Módulos Nativos Incluidos

- OpenSSL 3.0.2
- SQLite 3.37.2
- lzma/bz2 compression
- uuid, ctypes, readline
- tkinter, ncurses
- zlib, ssl

### Artefactos

| Archivo | Tamaño | Descripción |
|---------|--------|-------------|
| `cpython-{VERSION}-ubuntu20.04-build{BUILD_NUMBER}.tgz` | ~60 MB | Binario completo con todas las dependencias |
| `cpython-{VERSION}-ubuntu20.04-build{BUILD_NUMBER}.tgz.sha256` | 89 bytes | Checksum SHA256 para validación |
| `LICENSE` | 14 KB | Python Software Foundation License |

### Uso en Dev Container

Agregar a `.devcontainer/devcontainer.json`:

```json
{
  "features": {
    "./infrastructure/cpython/installer": {
      "version": "{VERSION}",
      "artifactUrl": "https://github.com/2-Coatl/IACT---project/releases/download/cpython-{VERSION}-build{BUILD_NUMBER}/cpython-{VERSION}-ubuntu20.04-build{BUILD_NUMBER}.tgz"
    }
  }
}
```

### Validación del Artefacto

```bash
# Descargar artefactos
curl -LO https://github.com/2-Coatl/IACT---project/releases/download/cpython-{VERSION}-build{BUILD_NUMBER}/cpython-{VERSION}-ubuntu20.04-build{BUILD_NUMBER}.tgz
curl -LO https://github.com/2-Coatl/IACT---project/releases/download/cpython-{VERSION}-build{BUILD_NUMBER}/cpython-{VERSION}-ubuntu20.04-build{BUILD_NUMBER}.tgz.sha256

# Validar checksum
sha256sum -c cpython-{VERSION}-ubuntu20.04-build{BUILD_NUMBER}.tgz.sha256
# Esperado: cpython-{VERSION}-ubuntu20.04-build{BUILD_NUMBER}.tgz: OK

# Extraer y probar (opcional)
mkdir /tmp/test-cpython
tar -xzf cpython-{VERSION}-ubuntu20.04-build{BUILD_NUMBER}.tgz -C /tmp/test-cpython
/tmp/test-cpython/bin/python3 --version
# Esperado: Python {VERSION}
```

### Tests Ejecutados

- - Checksum SHA256 validado
- - Python ejecuta correctamente
- - `python3 --version` muestra {VERSION}
- - Módulos nativos importan sin errores:
  - `import ssl` -
  - `import sqlite3` -
  - `import lzma` -
  - `import bz2` -
  - `import uuid` -
  - `import ctypes` -
- - `pip3 --version` funciona
- - `pip3 list` muestra paquetes base
- - LICENSE incluido en tarball

### Changelog

**Cambios en este build:**

{BUILD_SPECIFIC_CHANGES}

**Ejemplo para Build 1:**
```
- Primera release oficial de CPython precompilado
- Implementa SPEC_INFRA_001 Fases 0-2
- Build reproducible desde Vagrant
- Sistema de validación completo
- Integración con Dev Containers
```

### Compatibilidad

**Dev Containers compatibles:**
- Ubuntu 20.04 (jammy)
- Debian 11 (bullseye) - compatible con glibc 2.31+
- Debian 12 (bookworm) - compatible

**No compatible:**
- Ubuntu 20.04 (glibc 2.31 vs 2.35)
- Alpine Linux (musl libc vs glibc)
- Fedora/CentOS (diferencias en OpenSSL)

### Compilación

Compilado usando:
```bash
./infraestructura/cpython/scripts/build_cpython.sh {VERSION} {BUILD_NUMBER}
```

En entorno:
- Vagrant VM: Ubuntu 20.04 LTS
- RAM: 4 GB
- CPU: 4 cores
- Tiempo de compilación: ~60 minutos

### Flags de Compilación

```bash
--prefix=/opt/python-{VERSION}
--enable-optimizations
--with-lto
--enable-shared
--with-ensurepip=install
--enable-loadable-sqlite-extensions
```

### Documentación

- **Especificación**: [SPEC_INFRA_001](../../../specs/SPEC_INFRA_001-cpython_precompilado.md)
- **Procedimiento Fase 3**: [FASE_3_PROCEDIMIENTO.md](FASE_3_PROCEDIMIENTO.md)
- **ADR Features vs Imagen**: [ADR_008](../../adr/ADR_008-cpython-features-vs-imagen-base.md)
- **ADR Distribución**: [ADR_009](../../adr/ADR_009-distribucion-artefactos-strategy.md)
- **Preguntas Frecuentes**: [FAQ](preguntas_frecuentes.md)

### Soporte

Para reportar issues con este artefacto:
1. Verificar compatibilidad del sistema base
2. Ejecutar validación con checksum
3. Revisar [FAQ](preguntas_frecuentes.md)
4. Abrir issue en GitHub con:
   - Versión del artefacto
   - Sistema base (OS, versión)
   - Logs de instalación

### Próxima Release

**Estimado**: 6 meses (mayo 2026) o ante vulnerabilidades críticas de seguridad.

**Versiones planeadas:**
- Python 3.12.7 (si se libera)
- Python 3.13.x (cuando sea estable)

---

**Maintainer**: Equipo Infraestructura
**Contact**: [GitHub Issues](https://github.com/2-Coatl/IACT---project/issues)
**License**: Python Software Foundation License (PSF)
```

---

## Archivos a Adjuntar

1. **cpython-{VERSION}-ubuntu20.04-build{BUILD_NUMBER}.tgz**
   - Ubicación: `infrastructure/cpython/artifacts/`
   - Generado por: `make build_cpython VERSION={VERSION} BUILD={BUILD_NUMBER}`

2. **cpython-{VERSION}-ubuntu20.04-build{BUILD_NUMBER}.tgz.sha256**
   - Ubicación: `infrastructure/cpython/artifacts/`
   - Generado automáticamente junto con el tarball

3. **LICENSE**
   - Ubicación: Incluir Python Software Foundation License
   - Puede obtenerse de: https://docs.python.org/3/license.html

---

## Configuración del Release

- [ ] Tag creado: `cpython-{VERSION}-build{BUILD_NUMBER}`
- [ ] Título configurado correctamente
- [ ] Descripción completa con el template
- [ ] 3 archivos adjuntos (.tgz, .tgz.sha256, LICENSE)
- [ ] Marcar como **Pre-release** si es la primera vez
- [ ] Desmarcar **Pre-release** cuando esté validado en producción
- [ ] Publicar Release

---

## Comandos para Crear Release

### Vía GitHub Web UI

1. Ir a: https://github.com/2-Coatl/IACT---project/releases/new
2. Completar formulario con la información del template
3. Arrastrar archivos
4. Publicar

### Vía GitHub CLI

```bash
# Variables
VERSION="3.12.6"
BUILD="1"
TAG="cpython-${VERSION}-build${BUILD}"
ARTIFACTS_DIR="infrastructure/cpython/artifacts"

# Crear release
gh release create "${TAG}" \
  --title "CPython ${VERSION} Precompilado - Build ${BUILD}" \
  --notes-file docs/infrastructure/cpython_precompilado/github_release_template.md \
  --prerelease \
  "${ARTIFACTS_DIR}/cpython-${VERSION}-ubuntu20.04-build${BUILD}.tgz" \
  "${ARTIFACTS_DIR}/cpython-${VERSION}-ubuntu20.04-build${BUILD}.tgz.sha256"

# Verificar
gh release view "${TAG}"
```

---

## Post-Publicación

Después de publicar el Release:

1. **Actualizar devcontainer.json** para usar URL de GitHub Release:
   ```json
   {
     "artifactUrl": "https://github.com/2-Coatl/IACT---project/releases/download/cpython-3.12.6-build1/cpython-3.12.6-ubuntu20.04-build1.tgz"
   }
   ```

2. **Validar descarga funciona**:
   ```bash
   curl -I https://github.com/2-Coatl/IACT---project/releases/download/cpython-3.12.6-build1/cpython-3.12.6-ubuntu20.04-build1.tgz
   # Esperado: HTTP 200 OK
   ```

3. **Rebuild Dev Container** y medir tiempo

4. **Actualizar ARTIFACTS.md** con entrada del nuevo release

5. **Anunciar** en canal de equipo/documentación

---

**Documento creado**: 2025-11-06
**Propietario**: Equipo Infraestructura
**Uso**: Template para todas las releases de CPython precompilado
