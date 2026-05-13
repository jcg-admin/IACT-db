---
id: PROCED-INFRA-006
tipo: procedimiento
categoria: infraestructura
subcategoria: cpython-maintenance
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Haiku 4.5)
estado: activo
relacionados: ["TASK-049", "PROCED-INFRA-001"]
---

# PROCED-INFRA-006: Actualizar Toolchain CPython

## Objetivo

Proporcionar pasos detallados y paso a paso para actualizar la toolchain de CPython en el ambiente de desarrollo, incluyendo compilación desde source, validación de compilación, actualización de virtual environments, verificación de compatibilidad, y rollback en caso de problemas.

Este es un procedimiento operacional avanzado para mantener CPython actualizado.

---

## Alcance

Este procedimiento cubre:
- Verificación de versión actual de CPython
- Descarga y validación de source CPython
- Compilación desde source (optimizada)
- Instalación de versión nueva
- Coexistencia de múltiples versiones
- Actualización de virtual environments
- Tests de compatibilidad
- Performance tuning
- Rollback a versión anterior
- Limpieza de recursos

**NO cubre**:
- Instalación de packages (pip)
- Configuración específica de aplicaciones Django/FastAPI
- Tuning avanzado de performance para producción
- Compilación de extensiones C específicas

---

## Pre-requisitos

Antes de ejecutar este procedimiento, verificar:

### Hardware
- [ ] Mínimo 8 GB RAM
- [ ] Mínimo 100 GB espacio libre en disco
- [ ] CPU multi-core (4+ cores recomendado)
- [ ] Tiempo disponible (2-3 horas)

### Software Requerido
- [ ] Build tools instalados (gcc, make)
- [ ] Headers de desarrollo (python3-dev, etc.)
- [ ] OpenSSL development libraries
- [ ] Zlib development libraries
- [ ] Git (para descargar source)

### Verificación de Requisitos

```bash
# Verificar build tools
gcc --version
make --version
which pkg-config

# Esperado: todas las herramientas disponibles

# Verificar development headers
dpkg -l | grep -i python3-dev
dpkg -l | grep -i libssl-dev

# Esperado: paquetes instalados

# Verificar espacio
df -h /opt
# Esperado: >= 100 GB libres
```

### Conocimiento Requerido
- Compilación de aplicaciones desde source
- Configuración de ./configure y make
- Virtual environments Python
- Conceptos de versiones múltiples de Python

---

## Roles y Responsabilidades

| Rol | Responsabilidad |
|-----|-----------------|
| **DevOps Engineer** | Ejecuta compilación, valida build, gestiona rollback |
| **Developer** | Valida compatibilidad, prueba aplicación |
| **Tech Lead** | Aprueba actualización, revisa logs de compilación |

---

## Procedimiento Detallado

### PASO 1: Preparar Ambiente para Compilación

#### 1.1 Verificar versión actual de CPython

```bash
# Ver versión actual
python3 --version
python3 -c "import sys; print(sys.version_info)"

# Guardar información
CURRENT_PYTHON=$(python3 --version 2>&1)
echo "Versión actual: $CURRENT_PYTHON"

# Esperado: versión actual visible (ej: Python 3.9.x)
```

#### 1.2 Instalar dependencias de compilación

```bash
# Actualizar índice de paquetes
sudo apt-get update

# Instalar build dependencies
sudo apt-get install -y \
  build-essential \
  libssl-dev \
  libffi-dev \
  libncurses-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  curl \
  git \
  pkg-config \
  xz-utils

# Esperado: todas las dependencias instaladas
```

#### 1.3 Verificar compilador

```bash
# Verificar GCC y Make
gcc --version
make --version

# Test compile simple
cd /tmp
echo 'int main() { return 0; }' > test.c
gcc test.c -o test && ./test && echo "Compiler OK"
rm -f test.c test

# Esperado: compilación exitosa
```

#### 1.4 Crear directorio de trabajo

```bash
# Crear estructura
mkdir -p /opt/python-builds
mkdir -p /opt/python-builds/sources
mkdir -p /opt/python-builds/logs

cd /opt/python-builds

# Verificar espacio
df -h .

# Esperado: >= 100 GB libres
```

---

### PASO 2: Descargar CPython Source

#### 2.1 Seleccionar versión a compilar

```bash
# Decidir versión (ejemplo: 3.12.0)
TARGET_VERSION="3.12.0"

# Verificar disponibilidad
curl -s https://www.python.org/ftp/python/ | grep -o ">${TARGET_VERSION}<" > /dev/null && \
  echo "Versión $TARGET_VERSION disponible" || \
  echo "Versión no encontrada"

# Esperado: versión confirma disponible
```

#### 2.2 Descargar source code

```bash
cd /opt/python-builds/sources

# Descargar tarball
TARGET_VERSION="3.12.0"
wget https://www.python.org/ftp/python/${TARGET_VERSION}/Python-${TARGET_VERSION}.tar.xz

# Verificar descarga
file Python-${TARGET_VERSION}.tar.xz
# Esperado: XZ compressed data

# Descargar checksum para validación
wget https://www.python.org/ftp/python/${TARGET_VERSION}/Python-${TARGET_VERSION}.tar.xz.asc

# Esperado: archivos descargados exitosamente
```

#### 2.3 Validar integridad

```bash
cd /opt/python-builds/sources

# Obtener hash esperado de website
# (Usualmente disponible en el sitio)

# Calcular hash local
sha256sum Python-${TARGET_VERSION}.tar.xz

# Comparar con website (idealmente)
# Si coincide: OK

# Extraer source
tar xf Python-${TARGET_VERSION}.tar.xz

# Esperado: directorio Python-${TARGET_VERSION} creado
```

---

### PASO 3: Configurar Compilación

#### 3.1 Preparar directorio de compilación

```bash
cd /opt/python-builds/sources/Python-3.12.0

# Ver opciones de configuración
./configure --help | head -50

# Esperado: opciones disponibles
```

#### 3.2 Configurar con optimizaciones

```bash
TARGET_VERSION="3.12.0"
cd /opt/python-builds/sources/Python-${TARGET_VERSION}

# Configurar para optimización
./configure \
  --prefix=/opt/python-${TARGET_VERSION} \
  --enable-optimizations \
  --enable-loadable-sqlite-extensions \
  --with-openssl=/usr/include/openssl \
  --with-openssl-rpath=auto \
  --enable-ipv6 \
  --with-system-expat \
  --enable-shared \
  2>&1 | tee /opt/python-builds/logs/configure-${TARGET_VERSION}.log

# Esperado: configuración completada sin errores críticos
```

#### 3.3 Validar configuración

```bash
# Ver archivos generados
ls -la Makefile config.h

# Listar opciones configuradas
cat config.h | grep -E "^#define" | head -20

# Esperado: Makefile presente, configuración guardada
```

---

### PASO 4: Compilar CPython

#### 4.1 Ejecutar compilación

```bash
TARGET_VERSION="3.12.0"
cd /opt/python-builds/sources/Python-${TARGET_VERSION}

# Compilar con múltiples CPUs
NUM_JOBS=$(nproc)
echo "Compilando con $NUM_JOBS jobs"

# Iniciar compilación
make -j${NUM_JOBS} 2>&1 | tee /opt/python-builds/logs/make-${TARGET_VERSION}.log

# Tiempo estimado: 20-60 minutos según hardware

# Esperado: compilación completada sin errores críticos
# (advertencias son OK)
```

#### 4.2 Monitorear progreso

```bash
# En otra terminal, monitorear:
watch -n 5 "ps aux | grep gcc | wc -l"

# O:
tail -f /opt/python-builds/logs/make-${TARGET_VERSION}.log

# Ver último número de objeto compilado
tail -20 /opt/python-builds/logs/make-${TARGET_VERSION}.log
```

#### 4.3 Validar compilación sin errores críticos

```bash
# Después de completar, revisar log
TARGET_VERSION="3.12.0"

# Contar errores
grep -c "^.*error" /opt/python-builds/logs/make-${TARGET_VERSION}.log

# Esperado: 0 errores, algunas advertencias OK

# Si hay errores críticos, revisar
grep "error" /opt/python-builds/logs/make-${TARGET_VERSION}.log | head -10
```

---

### PASO 5: Ejecutar Tests

#### 5.1 Ejecutar suite de tests

```bash
TARGET_VERSION="3.12.0"
cd /opt/python-builds/sources/Python-${TARGET_VERSION}

# Ejecutar tests básicos
make test -j4 2>&1 | tee /opt/python-builds/logs/test-${TARGET_VERSION}.log

# Tiempo estimado: 20-40 minutos

# Esperado: mayoría de tests pasan
```

#### 5.2 Validar tests

```bash
# Revisar resumen de tests
tail -50 /opt/python-builds/logs/test-${TARGET_VERSION}.log | grep -E "^(test|OK|FAILED)"

# Contar fallos
grep -c "FAILED" /opt/python-builds/logs/test-${TARGET_VERSION}.log

# Esperado: pocos fallos (platform-specific OK)
```

#### 5.3 Tests de módulos críticos

```bash
TARGET_VERSION="3.12.0"
cd /opt/python-builds/sources/Python-${TARGET_VERSION}

# Tests de módulos específicos
./python -m test test_ssl
./python -m test test_sqlite3
./python -m test test_json
./python -m test test_venv

# Esperado: tests pasan sin errores críticos
```

---

### PASO 6: Instalar CPython

#### 6.1 Realizar instalación

```bash
TARGET_VERSION="3.12.0"
cd /opt/python-builds/sources/Python-${TARGET_VERSION}

# Instalar
sudo make install 2>&1 | tee /opt/python-builds/logs/install-${TARGET_VERSION}.log

# Esperado: instalación completada
```

#### 6.2 Verificar instalación

```bash
# Verificar ejecutable
/opt/python-3.12.0/bin/python3 --version

# Crear symlink
sudo ln -sf /opt/python-3.12.0/bin/python3 /usr/local/bin/python3.12

# Verificar
python3.12 --version

# Esperado: versión nueva accesible
```

#### 6.3 Crear virtual environment con nueva versión

```bash
# Crear venv test
/opt/python-3.12.0/bin/python3 -m venv /tmp/test-venv-3.12

# Activar
source /tmp/test-venv-3.12/bin/activate

# Verificar
python --version
pip --version

# Salir
deactivate

# Esperado: venv funcionando
```

---

### PASO 7: Actualizar Virtual Environments Existentes

#### 7.1 Actualizar venv backend

```bash
# Navegar a backend
cd /home/user/IACT/backend

# Si tiene venv antiguo
if [ -d venv ]; then
  # Opción 1: Recrear venv
  rm -rf venv
  /opt/python-3.12.0/bin/python3 -m venv venv

  # Opción 2: Upgrade venv existente
  source venv/bin/activate
  python -m pip install --upgrade pip setuptools wheel
  pip install -r requirements.txt
  deactivate
fi

# Esperado: venv actualizado
```

#### 7.2 Actualizar Django y dependencias

```bash
cd /home/user/IACT/backend
source venv/bin/activate

# Verificar versión de Django
django-admin --version

# Actualizar dependencias
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt --upgrade

# Verificar importa
python -c "import django; print(django.VERSION)"

# Salir
deactivate

# Esperado: dependencias actualizadas
```

#### 7.3 Ejecutar migraciones (si aplicable)

```bash
cd /home/user/IACT/backend
source venv/bin/activate

# Verificar migraciones pendientes
python manage.py showmigrations

# Aplicar migraciones
python manage.py migrate

# Esperado: migraciones aplicadas exitosamente
deactivate
```

---

### PASO 8: Validación de Compatibilidad

#### 8.1 Tests unitarios backend

```bash
cd /home/user/IACT/backend
source venv/bin/activate

# Ejecutar tests
pytest tests/ --tb=short 2>&1 | tee /tmp/pytest-results.log

# Ver resumen
tail -20 /tmp/pytest-results.log

# Esperado: tests pasan
deactivate
```

#### 8.2 Validación de imports

```bash
cd /home/user/IACT/backend
source venv/bin/activate

# Test imports críticos
python << 'EOF'
import sys
print(f"Python version: {sys.version}")

modules = [
    'django',
    'psycopg2',
    'pytest',
    'celery',
    'redis',
    'requests'
]

for mod in modules:
    try:
        __import__(mod)
        print(f"OK: {mod}")
    except ImportError as e:
        print(f"FAIL: {mod} - {e}")
EOF

deactivate

# Esperado: todos los módulos importan
```

#### 8.3 Validación de compilación (si hay extensiones C)

```bash
# Si backend tiene módulos compilados C
cd /home/user/IACT/backend
source venv/bin/activate

# Reinstalar paquetes compilados
pip install --force-reinstall --no-cache-dir psycopg2
pip install --force-reinstall --no-cache-dir cryptography

# Verificar
python -c "import psycopg2; print(psycopg2.__version__)"

deactivate

# Esperado: módulos compilados funcionan
```

---

### PASO 9: Performance Testing

#### 9.1 Benchmark básico

```bash
# Comparar performance
cd /tmp

# Test con versión anterior
python3.11 << 'EOF'
import timeit
result = timeit.timeit(
    'sum(range(1000))',
    number=100000
)
print(f"Python 3.11: {result:.4f} seconds")
EOF

# Test con versión nueva
python3.12 << 'EOF'
import timeit
result = timeit.timeit(
    'sum(range(1000))',
    number=100000
)
print(f"Python 3.12: {result:.4f} seconds")
EOF

# Esperado: Python 3.12 es >= tan rápido
```

#### 9.2 Validación de memoria

```bash
# Monitorear uso de memoria
cd /home/user/IACT/backend

# Con Python 3.11
python3.11 -c "
import psutil
import os
proc = psutil.Process(os.getpid())
print(f'Memory (3.11): {proc.memory_info().rss / 1024 / 1024:.2f} MB')
"

# Con Python 3.12
python3.12 -c "
import psutil
import os
proc = psutil.Process(os.getpid())
print(f'Memory (3.12): {proc.memory_info().rss / 1024 / 1024:.2f} MB')
"

# Esperado: similares o mejor
```

#### 9.3 Validación de startup time

```bash
# Medir startup time
time python3.11 -c "print('3.11 loaded')"
time python3.12 -c "print('3.12 loaded')"

# Esperado: tiempos similares (< 1 segundo)
```

---

### PASO 10: Limpieza y Rollback Prep

#### 10.1 Organizar instalaciones

```bash
# Listar versiones instaladas
ls -lah /opt/python-*/bin/python3 | head

# Crear script de switch entre versiones
cat > /opt/switch-python.sh << 'EOF'
#!/bin/bash
if [ "$1" = "3.11" ]; then
  sudo ln -sf /opt/python-3.11.8/bin/python3 /usr/bin/python3
elif [ "$1" = "3.12" ]; then
  sudo ln -sf /opt/python-3.12.0/bin/python3 /usr/bin/python3
fi
python3 --version
EOF

chmod +x /opt/switch-python.sh

# Esperado: script de switch creado
```

#### 10.2 Crear backup de configuración

```bash
# Guardar paths actuales
cat > /opt/python-builds/version-info.txt << 'EOF'
Previous Python: $(python3.11 --version)
New Python: $(python3.12 --version)
Compilation: $(date)
Build log: /opt/python-builds/logs/make-3.12.0.log
EOF

# Guardar información de venvs
find /home/user/IACT -name pyvenv.cfg -exec ls -lah {} \;

# Esperado: información guardada para rollback
```

#### 10.3 Limpiar sources (opcional)

```bash
# Liberar espacio (source no se necesita más)
cd /opt/python-builds

# Mantener fuentes comprimidas
tar czf sources-backup-$(date +%Y%m%d).tar.gz sources/
du -sh sources-backup-*.tar.gz

# Opcionalmente, remover sources
# rm -rf sources/

# Espacio liberado
df -h /opt

# Esperado: espacio significativo liberado
```

---

## Validaciones por Paso

| Paso | Validación | Comando |
|------|-----------|---------|
| **1** | Versión actual OK | `python3 --version` |
| **1** | Dependencias instaladas | `gcc --version`, `make --version` |
| **1** | Espacio disponible | `df -h /opt` (>= 100GB) |
| **2** | Source descargado | `file Python-*.tar.xz` |
| **2** | Integridad validada | `sha256sum` coincide |
| **3** | Configuración OK | `./configure` sin errores críticos |
| **4** | Compilación OK | `make` sin errores |
| **5** | Tests OK | `make test` sin fallos críticos |
| **6** | Instalación OK | `/opt/python-3.12.0/bin/python3 --version` |
| **7** | Venv actualizado | `venv/bin/python --version` |
| **8** | Tests compatibilidad | `pytest` todos PASS |
| **8** | Imports OK | Todos los módulos importan |
| **9** | Performance OK | Tiempo similar o mejor |
| **10** | Rollback prep | Script de switch existe |

---

## Troubleshooting

### Problema 1: Compilación falla con OpenSSL

**Síntomas**:
```
configure: error: Openssl development libraries or headers are not available
```

**Causa**: libssl-dev no instalado

**Solución**:
```bash
# Instalar desarrollo headers
sudo apt-get install -y libssl-dev

# Reconfigurar con ruta explícita
./configure --with-openssl=/usr/include/openssl --with-openssl-rpath=auto

# Recompilar
make -j$(nproc)
```

---

### Problema 2: Compilación lenta

**Síntomas**:
```
Compilación tarda > 2 horas
```

**Causa**: Solo usa 1 CPU

**Solución**:
```bash
# Usar múltiples CPUs
NUM_JOBS=$(nproc)
make -j${NUM_JOBS}

# Prioridad baja si afecta sistema
nice -n 19 make -j${NUM_JOBS}

# Esperado: compilación más rápida
```

---

### Problema 3: Tests fallan

**Síntomas**:
```
FAILED test_ssl, FAILED test_socket
```

**Causa**: Problemas de red o plataforma

**Solución**:
```bash
# Ejecutar solo tests que importan
make test TESTFLAGS="-x test_core test_builtin test_sqlite3"

# Si falla test_ssl, pode ser setup de OpenSSL
# Proceder si tests críticos pasan
```

---

## Rollback

### Rollback A: Volver a versión anterior

```bash
# 1. Cambiar symlink
sudo ln -sf /opt/python-3.11.8/bin/python3 /usr/local/bin/python3

# 2. Recrear venvs
cd /home/user/IACT/backend
rm -rf venv
/opt/python-3.11.8/bin/python3 -m venv venv

# 3. Reinstalar dependencias
source venv/bin/activate
pip install -r requirements.txt
deactivate

# 4. Validar
python3 --version
```

---

### Rollback B: Desinstalación completa

```bash
# Remover instalación nueva
sudo rm -rf /opt/python-3.12.0

# Remover symlinks
sudo unlink /usr/local/bin/python3.12

# Restaurar versión anterior
sudo apt-get install python3.11
python3 --version

# Recrear venvs con apt python
python3 -m venv /home/user/IACT/backend/venv
```

---

## Criterios de Éxito

Una actualización exitosa cumple TODOS estos criterios:

- [x] Compilación completada sin errores críticos
- [x] Suite de tests pasa (>95%)
- [x] Nueva versión instalada en /opt/python-X.Y.Z/
- [x] Symlinks creados correctamente
- [x] Virtual environments actualizados
- [x] Django y dependencias importan sin errores
- [x] Tests unitarios backend PASS
- [x] Performance similar o mejor
- [x] Rollback script funcional
- [x] Información de build guardada
- [x] Documentación actualizada

---

## Tiempo Estimado

| Paso | Tiempo | Total |
|------|--------|-------|
| **Paso 1**: Preparar ambiente | 10 min | 10 min |
| **Paso 2**: Descargar source | 10 min | 20 min |
| **Paso 3**: Configurar | 5 min | 25 min |
| **Paso 4**: Compilar | 60-120 min | 85-145 min |
| **Paso 5**: Tests | 30-40 min | 115-185 min |
| **Paso 6**: Instalar | 5 min | 120-190 min |
| **Paso 7**: Actualizar venvs | 15 min | 135-205 min |
| **Paso 8**: Validación compatibilidad | 20 min | 155-225 min |
| **Paso 9**: Performance testing | 10 min | 165-235 min |
| **Paso 10**: Limpieza y prep | 10 min | 175-245 min |

**Tiempo Total Estimado**: 180-250 minutos (3-4 horas)
**Compilación es el cuello de botella**: 60-120 minutos

---

## Comandos Frecuentes (Quick Reference)

```bash
# Verificar versión
python3 --version
python3.12 --version

# Compilar
./configure --prefix=/opt/python-3.12.0 --enable-optimizations
make -j$(nproc)
sudo make install

# Cambiar versión
sudo ln -sf /opt/python-3.12.0/bin/python3 /usr/local/bin/python3

# Test
python -m test test_ssl
pytest tests/

# Crear venv
python3.12 -m venv /tmp/test-venv
source /tmp/test-venv/bin/activate

# Performance
time python -c "sum(range(1000000))"
```

---

## Referencias

### Documentación Interna
- [PROCED-INFRA-001: Provisión VM Vagrant](./PROCED-INFRA-001-provision-vm-vagrant.md)

### Documentación Externa
- [CPython Developer Guide](https://devguide.python.org/)
- [CPython Compilation on Linux](https://devguide.python.org/getting-started/setup-building/)
- [Python Source Releases](https://www.python.org/ftp/python/)

---

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-18 | Claude Code (Haiku 4.5) | Versión inicial - Procedimiento completo de Actualizar Toolchain CPython |

---

## Aprobación

- **Autor**: Claude Code (Haiku 4.5)
- **Revisado por**: Pendiente
- **Aprobado por**: Pendiente
- **Fecha de próxima revisión**: 2026-02-18
- **Estado**: ACTIVO
