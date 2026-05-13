---
id: DOC-INFRA-CPYTHON-FASE3
tipo: procedimiento
estado: activo
propietario: equipo-infraestructura
ultima_actualizacion: 2025-11-06
relacionados: ["SPEC_INFRA_001", "ADR_008", "ADR_009"]
---

# Procedimiento: Fase 3 - Integración y Validación CPython Precompilado

## Objetivo

Completar la integración de CPython precompilado mediante la generación del primer artefacto, publicación en GitHub Releases, y validación en proyecto piloto.

---

## Pre-requisitos

- [ ] Fases 0-2 completadas (infraestructura lista)
- [ ] Vagrant instalado localmente (>= 2.3.0)
- [ ] VirtualBox instalado (>= 6.1)
- [ ] Permisos para crear GitHub Releases en el repositorio
- [ ] Espacio en disco: ~10 GB libres

---

## Paso 1: Generar Primer Artefacto CPython

### 1.1 Verificar Sistema Host

```bash
# Verificar Vagrant
vagrant --version
# Esperado: Vagrant 2.3.0+

# Verificar VirtualBox
VBoxManage --version
# Esperado: 6.1.0+

# Verificar espacio en disco
df -h .
# Requerido: >10 GB libres
```

### 1.2 Iniciar VM de Compilación

```bash
cd /ruta/al/proyecto/IACT---project

# Opción A: Usar Makefile (recomendado)
make vagrant-cpython-up

# Opción B: Manual
cd infraestructura/cpython
vagrant up
```

**Tiempo estimado**: 5-10 minutos (primera vez)

**Resultado esperado**:
```
VM "iact-cpython-builder" iniciada
SSH disponible en 127.0.0.1:2222
```

### 1.3 Compilar CPython 3.12.6

```bash
# Desde raíz del proyecto
make build_cpython VERSION=3.12.6 BUILD=1

# O manualmente
./infraestructura/cpython/scripts/build_cpython.sh 3.12.6 1
```

**Tiempo estimado**: 45-90 minutos (depende de CPU)

**Proceso interno**:
1. Descarga CPython 3.12.6 source
2. Instala dependencias nativas (OpenSSL, SQLite, etc.)
3. Compila con PGO + LTO
4. Empaqueta en tarball
5. Genera checksum SHA256

**Resultado esperado**:
```
Artefacto generado: infrastructure/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz
Checksum: infrastructure/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz.sha256
Tamaño: ~50-70 MB
```

### 1.4 Validar Artefacto

```bash
make validate-cpython ARTIFACT=cpython-3.12.6-ubuntu20.04-build1.tgz

# O manualmente
./infraestructura/cpython/scripts/validate-cpython.sh cpython-3.12.6-ubuntu20.04-build1.tgz
```

**Validaciones ejecutadas**:
- - Checksum SHA256
- - Estructura de directorios
- - `python3 --version`
- - Módulos nativos (ssl, sqlite3, lzma, etc.)
- - pip funcional

**Resultado esperado**:
```
[SUCCESS] Todas las validaciones pasaron
[INFO] Artefacto listo para distribución
```

---

## Paso 2: Publicar en GitHub Releases

### 2.1 Crear Release Tag

```bash
# Crear tag local
git tag -a cpython-3.12.6-build1 -m "CPython 3.12.6 precompilado - Build 1"

# Push tag a remoto
git push origin cpython-3.12.6-build1
```

### 2.2 Crear GitHub Release

**Opción A: Interfaz Web GitHub**

1. Ir a: https://github.com/2-Coatl/IACT---project/releases/new
2. Seleccionar tag: `cpython-3.12.6-build1`
3. Título: `CPython 3.12.6 Precompilado - Build 1`
4. Descripción (usar template):

```markdown
## CPython 3.12.6 Precompilado - Build 1

### Características

- **Versión**: Python 3.12.6
- **Optimizaciones**: PGO + LTO habilitadas
- **Sistema base**: Ubuntu 20.04 LTS (jammy)
- **Arquitectura**: x86_64
- **Build date**: 2025-11-06

### Módulos Nativos Incluidos

- OpenSSL 3.0+
- SQLite 3.37+
- lzma/bz2 compression
- uuid, ctypes, readline
- tkinter, ncurses

### Artefactos

- `cpython-3.12.6-ubuntu20.04-build1.tgz` - Binario completo (~60 MB)
- `cpython-3.12.6-ubuntu20.04-build1.tgz.sha256` - Checksum de validación

### Uso

```json
{
  "features": {
    "./infrastructure/cpython/installer": {
      "version": "3.12.6",
      "artifactUrl": "https://github.com/2-Coatl/IACT---project/releases/download/cpython-3.12.6-build1/cpython-3.12.6-ubuntu20.04-build1.tgz"
    }
  }
}
```

### Validación

```bash
# Descargar
curl -LO https://github.com/2-Coatl/IACT---project/releases/download/cpython-3.12.6-build1/cpython-3.12.6-ubuntu20.04-build1.tgz
curl -LO https://github.com/2-Coatl/IACT---project/releases/download/cpython-3.12.6-build1/cpython-3.12.6-ubuntu20.04-build1.tgz.sha256

# Validar checksum
sha256sum -c cpython-3.12.6-ubuntu20.04-build1.tgz.sha256
```

### Changelog

- Primera release de CPython precompilado
- Implementa SPEC_INFRA_001 Fase 1-2
- Build reproducible desde Vagrant
```

5. Adjuntar archivos:
   - `cpython-3.12.6-ubuntu20.04-build1.tgz`
   - `cpython-3.12.6-ubuntu20.04-build1.tgz.sha256`
   - `LICENSE` (PSF License)

6. Marcar como **Pre-release** (primera vez)
7. Publicar

**Opción B: GitHub CLI**

```bash
gh release create cpython-3.12.6-build1 \
  --title "CPython 3.12.6 Precompilado - Build 1" \
  --notes-file docs/infrastructure/cpython_precompilado/release-notes-template.md \
  --prerelease \
  infrastructure/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz \
  infrastructure/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz.sha256
```

### 2.3 Verificar Release

```bash
# Listar releases
gh release list

# Ver detalles
gh release view cpython-3.12.6-build1

# Descargar para prueba
gh release download cpython-3.12.6-build1 -D /tmp/test-release
```

---

## Paso 3: Integrar en Proyecto Piloto

### 3.1 Actualizar devcontainer.json

**Ubicación**: `.devcontainer/devcontainer.json`

**Cambio**:

```diff
  "features": {
-   "ghcr.io/devcontainers/features/python:1": {
-     "version": "3.11"
-   },
+   "./infrastructure/cpython/installer": {
+     "version": "3.12.6",
+     "artifactUrl": "https://github.com/2-Coatl/IACT---project/releases/download/cpython-3.12.6-build1/cpython-3.12.6-ubuntu20.04-build1.tgz"
+   },
    "ghcr.io/devcontainers/features/git:1": {
      "version": "latest"
    },
```

**Nota**: Si quieres probar localmente sin GitHub Release:

```json
{
  "features": {
    "./infrastructure/cpython/installer": {
      "version": "3.12.6",
      "artifactUrl": "/workspaces/${localWorkspaceFolderBasename}/infraestructura/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz"
    }
  }
}
```

### 3.2 Rebuild Dev Container

**En VS Code**:
1. `Ctrl+Shift+P` → "Dev Containers: Rebuild Container"
2. O: `Ctrl+Shift+P` → "Dev Containers: Rebuild Container Without Cache"

**Desde Terminal**:
```bash
# Si tienes devcontainer CLI
devcontainer build --workspace-folder .
```

### 3.3 Medir Tiempo de Build

**Antes (con feature oficial Python)**:
```
Tiempo aproximado: 10-20 minutos
(instala Python desde apt + compila extensiones)
```

**Después (con CPython precompilado)**:
```
Tiempo esperado: <2 minutos
(solo extrae tarball)
```

**Registro de métricas**:
```bash
# Tiempo de build
time devcontainer build --workspace-folder .

# O manualmente cronometrar en VS Code
```

---

## Paso 4: Validar Integración

### 4.1 Verificar Python en Contenedor

```bash
# Dentro del Dev Container
python3 --version
# Esperado: Python 3.12.6

which python3
# Esperado: /opt/python-3.12.6/bin/python3

python3 -c "import sys; print(sys.prefix)"
# Esperado: /opt/python-3.12.6

# Verificar módulos nativos
python3 -c "import ssl, sqlite3, lzma, bz2; print('OK')"
# Esperado: OK
```

### 4.2 Ejecutar Tests de Proyecto

```bash
# Tests de infraestructura
pytest infraestructura/cpython/tests/ -v

# Tests de integración
pytest infraestructura/cpython/tests/test_cpython_feature.py -v -m critical
```

### 4.3 Verificar Extensiones VS Code

```bash
# Verificar Python extension detecta intérprete
code --list-extensions | grep python

# Verificar pylance
code --list-extensions | grep pylance
```

---

## Paso 5: Documentar Resultados

### 5.1 Registrar Métricas

Crear archivo: `docs/infrastructure/cpython_precompilado/fase-3-resultados.md`

```markdown
# Fase 3 - Resultados de Validación

## Métricas de Build

| Métrica | Antes | Después | Mejora |
|---------|-------|---------|--------|
| Tiempo de build | 18 min | 1.5 min | 92% |
| Tamaño de imagen | 1.2 GB | 950 MB | 21% |
| Pasos fallidos | 2/10 | 0/10 | 100% |

## Validaciones

- - Python 3.12.6 instalado correctamente
- - Todos los módulos nativos funcionan
- - pip instala paquetes correctamente
- - Tests críticos: 25/25 pasaron
- - Extensiones VS Code funcionan
- - Checksum validado correctamente

## Issues Encontrados

Ninguno.

## Fecha de Validación

2025-11-06
```

### 5.2 Actualizar ARTIFACTS.md

```bash
echo "
| 3.12.6 | ubuntu20.04 | build1 | 2025-11-06 | cpython-3.12.6-ubuntu20.04-build1.tgz | $(sha256sum infraestructura/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz | cut -d' ' -f1) | GitHub Release |
" >> infraestructura/artifacts/ARTIFACTS.md
```

---

## Paso 6: Marcar Fase 3 como Completada

### 6.1 Checklist de Completitud

- [ ] Artefacto CPython 3.12.6 generado
- [ ] Checksum SHA256 validado
- [ ] GitHub Release publicado
- [ ] devcontainer.json actualizado
- [ ] Dev Container rebuild exitoso
- [ ] Tiempo de build <2 minutos
- [ ] Tests de integración: 100% pass
- [ ] Módulos nativos verificados
- [ ] Documentación actualizada
- [ ] Métricas registradas

### 6.2 Commit Final

```bash
git add -A
git commit -m "feat: completar Fase 3 - integración CPython precompilado

Implementado:
- Generado primer artefacto CPython 3.12.6
- Publicado en GitHub Release cpython-3.12.6-build1
- Actualizado devcontainer.json para usar feature personalizada
- Validado: tiempo de build reducido de 18 min a 1.5 min
- Tests de integración: 25/25 pasaron

Referencia: SPEC_INFRA_001 Fase 3
"

git push origin <branch-name>
```

---

## Criterios de Éxito (Fase 3)

| Criterio | Meta | Estado |
|----------|------|--------|
| Artefacto generado | CPython 3.12.6 | ⏳ Pendiente |
| Publicado en GitHub | Release público | ⏳ Pendiente |
| Tiempo de build | <2 minutos | ⏳ Pendiente |
| Tests pasando | 100% | ⏳ Pendiente |
| Proyecto piloto | 1 proyecto usando | ⏳ Pendiente |

---

## Troubleshooting

### Error: "Vagrant VM no inicia"

```bash
# Verificar logs
cd infraestructura/cpython
vagrant up --debug

# Reiniciar
vagrant halt
vagrant destroy -f
vagrant up
```

### Error: "Compilación falla"

```bash
# SSH a VM
vagrant ssh

# Ver logs
cat /vagrant/logs/build-*.log

# Verificar dependencias
apt list --installed | grep -E "lib.*-dev"
```

### Error: "Checksum no coincide"

```bash
# Regenerar checksum
sha256sum cpython-3.12.6-ubuntu20.04-build1.tgz > cpython-3.12.6-ubuntu20.04-build1.tgz.sha256

# Validar
sha256sum -c cpython-3.12.6-ubuntu20.04-build1.tgz.sha256
```

### Error: "Dev Container no encuentra artefacto"

```bash
# Verificar URL en devcontainer.json
cat .devcontainer/devcontainer.json | grep artifactUrl

# Probar descarga manual
curl -I https://github.com/2-Coatl/IACT---project/releases/download/cpython-3.12.6-build1/cpython-3.12.6-ubuntu20.04-build1.tgz
```

---

## Próximos Pasos (Fase 4)

Una vez completada Fase 3, continuar con:

1. Implementar wheelhouse de dependencias
2. Expandir a 3+ proyectos adicionales
3. Agregar firma GPG de artefactos
4. Sistema de actualización automatizado
5. Publicar feature a ghcr.io

**Referencia**: Ver `docs/specs/SPEC_INFRA_001_cpython_precompilado.md` sección 9.2

---

**Documento creado**: 2025-11-06
**Propietario**: Equipo Infraestructura
**Estado**: Activo
