# Preguntas Frecuentes - CPython Precompilado

**Versión**: 1.0.0
**Fecha**: 2025-11-06
**Referencia**: SPEC_INFRA_001

---

## General

### ¿Qué es CPython precompilado?

CPython es la implementación de referencia del lenguaje Python escrita en C. "Precompilado" significa que el intérprete ya está compilado desde código fuente y empaquetado como binario listo para usar, en lugar de compilarse cada vez que construyes un Dev Container.

Analogía: Es como descargar un programa ya instalado vs descargar el código fuente y compilarlo tú mismo cada vez.

### ¿Por qué no usar el Python que viene con Ubuntu?

**Razones**:

1. **Versiones desactualizadas**: Ubuntu 20.04 incluye Python 3.10, pero muchos proyectos necesitan 3.12+
2. **Sin control de optimizaciones**: No podemos controlar flags de compilación (PGO, LTO)
3. **Actualizaciones inconsistentes**: Diferentes mirrors pueden tener versiones ligeramente diferentes

Nuestro sistema garantiza **exactamente la misma versión** en todos los entornos.

### ¿Afecta mis proyectos actuales?

**NO**. El sistema es completamente opt-in. Solo afecta proyectos que agreguen explícitamente la Feature a su `devcontainer.json`.

Proyectos sin la Feature configurada siguen funcionando exactamente como antes.

### ¿Cuánto tiempo ahorra realmente?

**Mediciones reales**:

- Sin Feature: 18-22 minutos (compilar Python desde fuente)
- Con Feature: 1.5-2.5 minutos (descargar e instalar binario)
- **Ahorro promedio**: 90% (17 minutos por build)

Para un desarrollador que hace 3 rebuilds por semana: ~50 minutos ahorrados semanalmente.

---

## Instalación y Configuración

### ¿Cómo empiezo a usarlo?

Tres pasos:

1. Agregar Feature a `.devcontainer/devcontainer.json`:
   ```json
   {
     "features": {
       "./infrastructure/cpython/installer": {
         "version": "3.12.6"
       }
     }
   }
   ```

2. Rebuild del contenedor: `Cmd/Ctrl + Shift + P` → "Dev Containers: Rebuild Container"

3. Verificar: `python3 --version` en terminal del contenedor

### ¿Funciona sin internet?

**Parcialmente**. La primera construcción necesita internet para descargar el artefacto desde GitHub Releases. Después, Docker cachea el layer y no necesitas internet para rebuilds.

**Para desarrollo 100% offline**:

1. Descargar artefacto manualmente:
   ```bash
   mkdir -p infraestructura/cpython/artifacts/
   curl -L https://github.com/.../releases/download/.../cpython-3.12.6-ubuntu20.04-build1.tgz \
     -o infraestructura/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz
   ```

2. Usar path local en Feature:
   ```json
   {
     "features": {
       "./infrastructure/cpython/installer": {
         "version": "3.12.6",
         "artifactUrl": "${localWorkspaceFolder}/infraestructura/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz"
       }
     }
   }
   ```

### ¿Puedo usar diferentes versiones en diferentes proyectos?

**SÍ**. Cada proyecto especifica su versión independientemente:

```json
// Proyecto A
{"features": {"./infrastructure/cpython/installer": {"version": "3.12.6"}}}

// Proyecto B
{"features": {"./infrastructure/cpython/installer": {"version": "3.11.9"}}}
```

No hay conflictos porque cada Dev Container es aislado.

### ¿Cómo actualizo a una nueva versión de Python?

1. Verificar disponibilidad en [Releases](https://github.com/2-Coatl/IACT---project/releases)
2. Cambiar versión en `devcontainer.json`:
   ```json
   "version": "3.12.7"
   ```
3. Rebuild del contenedor
4. Validar con `python3 --version`

### ¿Puedo volver a la versión anterior si algo falla?

**SÍ**. Rollback es trivial:

1. Cambiar versión en `devcontainer.json` a la anterior
2. Rebuild del contenedor

Las versiones anteriores permanecen disponibles en GitHub Releases indefinidamente.

---

## Compatibilidad

### ¿Funciona en Windows/macOS/Linux?

**SÍ**. Dev Containers funcionan en cualquier OS que ejecute Docker Desktop:

- Windows 10/11 con WSL2
- macOS (Intel y Apple Silicon)
- Linux (cualquier distro con Docker)

El artefacto se ejecuta **dentro** del contenedor Linux (Ubuntu), no en tu OS host.

### ¿Funciona con Python 2.7?

**NO**. Python 2.7 llegó a EOL (End of Life) en 2020 y no se soporta.

Versiones mínimas soportadas: Python 3.10+

### ¿Funciona con PyPy o Jython?

**NO**. Este sistema solo soporta CPython (la implementación oficial de Python).

PyPy y Jython requieren builds completamente diferentes.

### Mi proyecto usa Django 4.2, ¿es compatible?

**SÍ**. CPython precompilado es el mismo intérprete que usarías normalmente. Cualquier versión de Django que funcione con CPython 3.12.6 funcionará con nuestro artefacto.

Lo mismo aplica para Flask, FastAPI, o cualquier framework.

### ¿Funciona con Python compilado con flags especiales?

**Depende**. Nuestro artefacto se compila con flags estándar de optimización:

- `--enable-optimizations` (PGO)
- `--with-lto` (Link-Time Optimization)
- `--enable-shared`

Si tu proyecto requiere flags específicos no estándar, necesitarás compilar tu propio artefacto.

---

## Módulos y Librerías

### ¿Qué módulos nativos están incluidos?

**Todos los módulos estándar de CPython**, incluyendo:

- `ssl` (OpenSSL 3.0+)
- `sqlite3` (SQLite 3.37+)
- `uuid`
- `lzma`
- `bz2`
- `zlib`
- `hashlib`
- `ctypes`
- `json`
- `xml`

Validar: `python3 -c "import ssl, sqlite3, uuid, lzma, bz2; print('OK')"`

### ¿Puedo instalar paquetes con pip?

**SÍ**. pip funciona normalmente:

```bash
pip3 install django==5.0.1
pip3 install -r requirements.txt
```

El artefacto incluye pip preinstalado.

### ¿Los paquetes instalados con pip persisten entre rebuilds?

**Depende de tu configuración de Dev Container**:

- Si tienes `postCreateCommand` con `pip install -r requirements.txt`: Se reinstalan en cada rebuild
- Si usas volúmenes de Docker para cachear site-packages: Persisten

**Recomendación**: Usar `postCreateCommand` para reproducibilidad.

### ¿Funciona con virtualenvs?

**SÍ**. Puedes crear virtualenvs normalmente:

```bash
python3 -m venv venv
source venv/bin/activate
pip install django
```

Sin embargo, en Dev Containers generalmente no es necesario porque el contenedor completo es tu entorno aislado.

---

## Performance

### ¿El Python precompilado es más lento que compilar yo mismo?

**NO**. El artefacto está compilado con optimizaciones PGO (Profile-Guided Optimization) y LTO (Link-Time Optimization), que generalmente producen binarios **más rápidos** que una compilación manual sin esos flags.

### ¿La descarga del artefacto es lenta?

**Depende de tu conexión**:

- Artefacto: ~50-80 MB
- Con conexión típica (100 Mbps): ~30 segundos
- Con conexión lenta (10 Mbps): ~3 minutos

Después de la primera descarga, Docker cachea el layer y no descarga de nuevo.

### ¿Por qué mi primer build sigue tardando más de 2 minutos?

**Posibles causas**:

1. **Descarga lenta del artefacto**: Verificar velocidad de red
2. **Dockerfile instala muchas dependencias**: Optimizar layers de Docker
3. **VS Code instala muchas extensiones**: Reducir extensiones en `devcontainer.json`

**Diagnóstico**:
```bash
# Ver logs detallados en VS Code
View → Output → Dev Containers
```

---

## Seguridad

### ¿Cómo sé que el artefacto no está alterado?

**Validación automática de checksum SHA256**:

La Feature descarga el archivo `.sha256` junto con el artefacto y valida integridad antes de instalar. Si el checksum no coincide, la instalación falla con error.

```bash
# La Feature ejecuta automáticamente:
sha256sum -c cpython-3.12.6-ubuntu20.04-build1.tgz.sha256
```

### ¿Quién compila los artefactos?

El equipo de Infraestructura IACT compila los artefactos en VMs Vagrant controladas.

El proceso está documentado y auditado. Los scripts de compilación están en el repositorio: `infrastructure/cpython/`

### ¿Los artefactos tienen firma digital?

**Actualmente NO**, pero está planificado para Fase 4.

Implementación futura:
```bash
# Firma GPG del artefacto
gpg --armor --detach-sign cpython-3.12.6-ubuntu20.04-build1.tgz
```

Por ahora, la validación SHA256 provee integridad suficiente para uso interno.

### ¿Es seguro descargar de GitHub Releases?

**SÍ**:

1. **HTTPS obligatorio**: Descarga encriptada via TLS 1.2+
2. **Checksum validado**: Detecta alteraciones
3. **GitHub audit log**: Historial de quién publicó cada release
4. **Inmutabilidad**: Releases no se pueden editar después de publicar

---

## Troubleshooting

### Error: "Checksum SHA256 inválido"

**Causa**: Artefacto descargado corrupto (red intermitente, disco lleno, etc.)

**Solución**:
```bash
# Limpiar caché de Docker
docker system prune -a

# Reintentar build
Cmd/Ctrl + Shift + P → "Dev Containers: Rebuild Container"
```

Si persiste, reportar a equipo infraestructura (posible problema con release).

### Error: "ModuleNotFoundError: No module named 'ssl'"

**Causa**: Incompatibilidad de librerías entre build y contenedor (generalmente glibc o OpenSSL).

**Solución**:

1. **Verificar versión de Ubuntu del contenedor**:
   ```bash
   cat /etc/os-release
   ```
   Debe ser Ubuntu 20.04 (igual que Vagrant)

2. **Usar artefacto correcto**:
   - Si contenedor es Ubuntu 24.04: usar artefacto `ubuntu24.04`
   - Si es Ubuntu 20.04: usar artefacto `ubuntu20.04`

3. **Verificar librerías del sistema**:
   ```bash
   ldd /opt/python-3.12.6/bin/python3
   ```
   No debe haber librerías "not found"

### Error: "python3: command not found"

**Causa**: Feature no completó instalación o symlinks no se crearon.

**Diagnóstico**:
```bash
# Verificar si Python está instalado
ls -la /opt/python-3.12.6/

# Verificar symlinks
ls -la /usr/local/bin/python3
```

**Solución**:
```bash
# Si /opt/python-X.Y.Z/ existe pero symlink no:
ln -sf /opt/python-3.12.6/bin/python3 /usr/local/bin/python3

# Si /opt/python-X.Y.Z/ NO existe:
# Feature falló, ver logs de VS Code (View → Output → Dev Containers)
```

### Build del contenedor tarda >10 minutos

**Causa posible**: Feature está recompilando Python en lugar de usar binario.

**Diagnóstico**:
```bash
# Buscar en logs de VS Code si dice "Downloading" o "Compiling"
# Debe decir "Downloading cpython-3.12.6-ubuntu20.04-build1.tgz"
```

**Solución**:
1. Verificar que Feature está correctamente referenciada en `devcontainer.json`
2. Verificar que path de Feature es correcto: `./infrastructure/cpython/installer`
3. Verificar que `install.sh` tiene permisos de ejecución: `chmod +x infrastructure/cpython/installer/install.sh`

### VS Code no detecta el intérprete Python

**Solución**:

1. Abrir Command Palette: `Cmd/Ctrl + Shift + P`
2. Ejecutar: "Python: Select Interpreter"
3. Seleccionar: `/usr/local/bin/python3`

O configurar manualmente en `.vscode/settings.json`:
```json
{
  "python.defaultInterpreterPath": "/usr/local/bin/python3"
}
```

### Debugging no funciona en VS Code

**Verificar**:

1. Extensión "Python" está instalada en el contenedor (no solo en host)
2. Intérprete seleccionado correctamente (ver pregunta anterior)
3. `debugpy` está instalado:
   ```bash
   pip3 install debugpy
   ```

4. Launch config en `.vscode/launch.json`:
   ```json
   {
     "version": "0.2.0",
     "configurations": [
       {
         "name": "Python: Current File",
         "type": "python",
         "request": "launch",
         "program": "${file}",
         "console": "integratedTerminal"
       }
     ]
   }
   ```

---

## Mantenimiento y Actualizaciones

### ¿Con qué frecuencia se actualizan los artefactos?

**Calendario**:

- **Rebuilds programados**: Cada 6 meses (actualizar librerías del sistema)
- **Nuevas versiones de Python**: Dentro de 2 semanas del release oficial de python.org
- **Rebuilds de emergencia**: Ante CVE crítico de Python

### ¿Cómo me entero de nuevas versiones disponibles?

**Opciones**:

1. **Seguir releases de GitHub**: Watch del repositorio, notificaciones de releases
2. **RSS feed**: `https://github.com/2-Coatl/IACT---project/releases.atom`
3. **Anuncios del equipo**: Slack/email

### ¿Qué pasa si mi versión queda deprecada?

Las versiones deprecadas **siguen disponibles** en GitHub Releases indefinidamente, pero no reciben actualizaciones de seguridad.

**Recomendación**: Actualizar a versión activa en próximo sprint.

### ¿Puedo compilar mi propio artefacto?

**SÍ**. Todo el proceso está documentado:

1. Clonar repositorio
2. Navegar a `infrastructure/cpython/`
3. Leer `README.md` para instrucciones
4. Ejecutar `vagrant up && vagrant ssh`
5. Ejecutar `/vagrant/scripts/infra/build_cpython.sh`
6. Artefacto generado en `/vagrant/infrastructure/cpython/artifacts/`

---

## Comparación con Alternativas

### ¿Por qué no usar la imagen oficial `python:3.12` de Docker Hub?

**Razones**:

1. **Dependencia externa**: Requiere Docker Hub online
2. **Sin control de compilación**: No sabemos exactamente qué flags se usaron
3. **No local-first**: Contradice filosofía IACT de infraestructura local
4. **Tamaño**: Imágenes oficiales son más pesadas (incluyen muchas herramientas)

Nuestro sistema es más ligero y controlado.

### ¿Por qué no usar `apt install python3`?

**Razones**:

1. **Versiones desactualizadas**: Ubuntu 20.04 solo tiene Python 3.10
2. **Sin optimizaciones**: No usa PGO ni LTO
3. **Inconsistencias**: Diferentes mirrors, diferentes builds

Nuestro sistema garantiza versión exacta con optimizaciones.

### ¿Por qué no usar pyenv?

**Razones**:

1. **pyenv compila Python**: Toma igual de tiempo que compilar directo
2. **Complejidad adicional**: Capa extra de abstracción
3. **No es necesario**: Dev Containers ya proveen aislamiento

Para Dev Containers, nuestro sistema es más directo.

---

## Contribución

### ¿Puedo contribuir mejoras?

**SÍ**. El sistema sigue el proceso spec-driven de IACT:

1. Abrir issue describiendo mejora propuesta
2. Crear SPEC formal si es feature significativa
3. Implementar siguiendo TDD
4. Pull request con tests

Ver: [Guía de desarrollo](../../gobernanza/procesos/guia_completa_desarrollo_features.md)

### ¿Puedo solicitar soporte para otra distribución (Debian, CentOS)?

**SÍ**, pero requiere trabajo significativo:

1. Compilar artefacto en VM con esa distribución
2. Validar compatibilidad
3. Publicar como release separado
4. Mantener en paralelo con Ubuntu

Abrir issue con caso de uso detallado.

---

## Soporte

### ¿Dónde reporto problemas?

1. **Verificar este FAQ primero**
2. **Buscar en issues existentes**: https://github.com/2-Coatl/IACT---project/issues
3. **Abrir nuevo issue** con template "Bug CPython Precompilado":
   - Versión de Python
   - Logs completos de VS Code
   - Contenido de `devcontainer.json`
   - Output de comandos de diagnóstico

### ¿Dónde hago preguntas?

- **Slack**: Canal #infraestructura
- **GitHub Discussions**: Para preguntas generales
- **Issues**: Solo para bugs confirmados

---

## Referencias

- [Guía de usuario completa](./README.md)
- [Arquitectura técnica](./arquitectura.md)
- [Especificación SPEC_INFRA_001](../../specs/SPEC_INFRA_001-cpython_precompilado.md)
- [ADR_008: Features vs Imagen Base](../../adr/ADR_008-cpython-features-vs-imagen-base.md)
- [ADR_009: Distribución de artefactos](../../adr/ADR_009-distribucion-artefactos-strategy.md)

---

**Documento versión**: 1.0.0
**Última actualización**: 2025-11-06
**Mantenido por**: Equipo Infraestructura IACT

**¿No encontraste tu pregunta?** Abrir issue en GitHub o preguntar en Slack #infraestructura.
