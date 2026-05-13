# Sistema de Ambientes Virtualizados

Sistema de "caparazones" aislados para servicios de bases de datos y cache.

Similar a `venv` de Python, pero para servicios completos.

## Concepto

Cada ambiente es un **contenedor Docker aislado** con:
- Puerto propio
- Datos propios
- Red propia
- Configuración independiente

## Servicios Soportados

- **PostgreSQL** - Base de datos relacional
- **MySQL** - Base de datos relacional
- **Redis** - Cache en memoria

## Instalación

```bash
# El script usa Docker, asegúrate de tenerlo instalado
docker --version

# El script está listo para usar
cd scripts/infraestructura
./virtualize.sh
```

## Uso Básico

### 1. Crear Ambiente

```bash
# PostgreSQL para desarrollo
./virtualize.sh create postgres dev 5432

# MySQL para testing
./virtualize.sh create mysql test 3307

# Redis para staging
./virtualize.sh create redis staging 6380
```

### 2. Iniciar Ambiente

```bash
./virtualize.sh start postgres dev

# Salida:
# [INFO] Iniciando postgres-dev...
# [OK] postgres-dev esta corriendo y saludable
#
# Ambiente PostgreSQL: dev
#   Host: localhost
#   Port: 5432
#   Database: iact_dev
#   User: dev_user
#
# Conectar:
#   psql -h localhost -p 5432 -U dev_user -d iact_dev
```

### 3. Detener Ambiente

```bash
./virtualize.sh stop postgres dev
```

### 4. Listar Ambientes

```bash
./virtualize.sh list

# Salida:
# Ambientes virtualizados disponibles:
#   [OK] postgres-dev (running)
#   [ERROR] mysql-test (stopped)
#   [OK] redis-staging (running)
```

### 5. Activar Ambiente (cargar variables)

```bash
# En tu shell
source <(./virtualize.sh activate postgres dev)

# Ahora tienes:
echo $DB_HOST      # localhost
echo $DB_PORT      # 5432
echo $DB_NAME      # iact_dev
echo $DB_USER      # dev_user
echo $DB_PASSWORD  # dev_password
```

### 6. Destruir Ambiente

```bash
./virtualize.sh destroy postgres dev

# ADVERTENCIA: Elimina TODOS los datos
```

## Casos de Uso

### Caso 1: Desarrollo Local con PostgreSQL

```bash
# 1. Crear ambiente de desarrollo
./virtualize.sh create postgres dev 5432

# 2. Iniciar
./virtualize.sh start postgres dev

# 3. Configurar .env
cat >> .env << EOF
ENVIRONMENT=development
DB_VM_HOST=localhost
DB_VM_PORT=5432
DB_VM_NAME=iact_dev
DB_VM_USER=dev_user
DB_VM_PASSWORD=dev_password
EOF

# 4. Usar en tu aplicación
python3 test_case1_viabilidad.py
# Se conecta automáticamente al PostgreSQL virtualizado
```

### Caso 2: Testing con MySQL Limpio

```bash
# 1. Crear ambiente de testing
./virtualize.sh create mysql test 3307

# 2. Iniciar para cada test run
./virtualize.sh start mysql test

# 3. Ejecutar tests
pytest tests/

# 4. Destruir y recrear para tests limpios
./virtualize.sh destroy mysql test
./virtualize.sh create mysql test 3307
```

### Caso 3: Múltiples Ambientes Simultáneos

```bash
# Desarrollo - PostgreSQL en puerto 5432
./virtualize.sh create postgres dev 5432
./virtualize.sh start postgres dev

# Testing - PostgreSQL en puerto 5433
./virtualize.sh create postgres test 5433
./virtualize.sh start postgres test

# Staging - MySQL en puerto 3307
./virtualize.sh create mysql staging 3307
./virtualize.sh start mysql staging

# Todos corriendo simultáneamente sin conflictos
./virtualize.sh list
# [OK] postgres-dev (running)
# [OK] postgres-test (running)
# [OK] mysql-staging (running)
```

### Caso 4: Cambiar entre Ambientes

```bash
# Trabajar con desarrollo
source <(./virtualize.sh activate postgres dev)
python3 manage.py migrate

# Cambiar a testing
source <(./virtualize.sh activate postgres test)
python3 manage.py migrate

# Cambiar a staging
source <(./virtualize.sh activate mysql staging)
python3 manage.py migrate
```

## Arquitectura

```
Proyecto/
├── .venvs/                        # Directorio de ambientes virtualizados
│   ├── postgres-dev/              # Ambiente PostgreSQL dev
│   │   ├── docker-compose.yml    # Configuración Docker
│   │   └── connection.sh         # Variables de conexión
│   ├── postgres-test/             # Ambiente PostgreSQL test
│   ├── mysql-staging/             # Ambiente MySQL staging
│   └── redis-cache/               # Ambiente Redis cache
│
└── scripts/infrastructure/
    └── virtualize.sh              # Script principal
```

## Estructura de un Ambiente

Cada ambiente tiene:

```
.venvs/postgres-dev/
├── docker-compose.yml    # Configuración del contenedor
│                        # - Imagen
│                        # - Puertos
│                        # - Volúmenes
│                        # - Red
│
└── connection.sh        # Variables de entorno
                        # - DB_HOST
                        # - DB_PORT
                        # - DB_NAME
                        # - DB_USER
                        # - DB_PASSWORD
```

## Integración con Código

### Python / Django

```python
# settings.py
import os
import subprocess

# Activar ambiente virtualizado si existe
venv_name = os.getenv("DB_VENV", "postgres-dev")
try:
    result = subprocess.run(
        ["./scripts/infraestructura/virtualize.sh", "activate", "postgres", "dev"],
        capture_output=True,
        text=True
    )
    # Variables ya están en os.environ
except:
    pass

# Usar variables de entorno
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('DB_NAME', 'iact_dev'),
        'USER': os.getenv('DB_USER', 'dev_user'),
        'PASSWORD': os.getenv('DB_PASSWORD', 'dev_password'),
        'HOST': os.getenv('DB_HOST', 'localhost'),
        'PORT': os.getenv('DB_PORT', '5432'),
    }
}
```

### Environment Config Integration

```python
# scripts/ai/shared/environment_config.py

def get_database_config(self) -> Dict[str, Any]:
    """Detecta si hay ambiente virtualizado activo."""

    # Verificar si hay ambiente virtualizado
    db_host = os.getenv("DB_HOST")
    if db_host:
        # Usar ambiente virtualizado
        return {
            "host": db_host,
            "port": int(os.getenv("DB_PORT", "5432")),
            "database": os.getenv("DB_NAME"),
            "user": os.getenv("DB_USER"),
            "password": os.getenv("DB_PASSWORD"),
            "use_vm": False,
            "virtualized": True
        }

    # Fallback a configuración por ambiente
    if self.is_dev:
        return self._get_dev_db_config()
    # ...
```

## Comandos Útiles

### Ver logs del contenedor

```bash
# Logs en vivo
docker logs -f postgres-dev

# Últimas 100 líneas
docker logs --tail 100 postgres-dev
```

### Ejecutar comandos dentro del contenedor

```bash
# PostgreSQL
docker exec -it postgres-dev psql -U dev_user -d iact_dev

# MySQL
docker exec -it mysql-test mysql -u test_user -ptest_password iact_test

# Redis
docker exec -it redis-cache redis-cli -a cache_password
```

### Hacer backup

```bash
# PostgreSQL
docker exec postgres-dev pg_dump -U dev_user iact_dev > backup.sql

# MySQL
docker exec mysql-test mysqldump -u test_user -ptest_password iact_test > backup.sql
```

### Restaurar backup

```bash
# PostgreSQL
cat backup.sql | docker exec -i postgres-dev psql -U dev_user -d iact_dev

# MySQL
cat backup.sql | docker exec -i mysql-test mysql -u test_user -ptest_password iact_test
```

## Ventajas vs Vagrant

| Aspecto | Vagrant | Ambientes Virtualizados |
|---------|---------|------------------------|
| **Inicio** | 2-5 minutos | 5-10 segundos |
| **Memoria** | 1-2 GB por VM | 100-200 MB por contenedor |
| **Disco** | 5-10 GB por VM | 100-500 MB por contenedor |
| **Múltiples** | Difícil (consume mucho) | Fácil (ligeros) |
| **Limpieza** | `vagrant destroy` | `./virtualize.sh destroy` |
| **Portabilidad** | Requiere Vagrant | Solo Docker |

## Ventajas vs Instalación Local

| Aspecto | Instalación Local | Ambientes Virtualizados |
|---------|-------------------|------------------------|
| **Conflictos** | Posibles (mismo puerto) | Ninguno (puertos propios) |
| **Limpieza** | Difícil (desinstalar) | Fácil (destroy) |
| **Múltiples versiones** | Complejo | Simple |
| **Testing** | Requiere limpiar DB | Crear/destruir rápido |
| **CI/CD** | Requiere setup | Ya containerizado |

## Solución de Problemas

### Error: "Docker daemon not running"

```bash
# Linux
sudo systemctl start docker

# Mac
# Abrir Docker Desktop

# Windows
# Abrir Docker Desktop
```

### Error: "Port already in use"

```bash
# Ver qué está usando el puerto
lsof -i :5432

# Usar puerto diferente
./virtualize.sh create postgres dev 5433
```

### Error: "Container unhealthy"

```bash
# Ver logs
docker logs postgres-dev

# Reiniciar
./virtualize.sh stop postgres dev
./virtualize.sh start postgres dev
```

### Limpiar todo

```bash
# Detener todos los contenedores
docker stop $(docker ps -aq)

# Eliminar todos los volúmenes
docker volume prune -f

# Recrear ambientes
./virtualize.sh create postgres dev 5432
```

## Ejemplos Avanzados

### Script de Setup Completo

```bash
#!/bin/bash
# setup_dev.sh - Levanta entorno completo de desarrollo

set -e

echo "Configurando ambiente de desarrollo..."

# PostgreSQL
./scripts/infraestructura/virtualize.sh create postgres dev 5432
./scripts/infraestructura/virtualize.sh start postgres dev

# Redis
./scripts/infraestructura/virtualize.sh create redis cache 6379
./scripts/infraestructura/virtualize.sh start redis cache

# Esperar a que estén listos
sleep 5

# Migrar base de datos
source <(./scripts/infraestructura/virtualize.sh activate postgres dev)
python3 manage.py migrate

echo "Ambiente listo!"
```

### CI/CD Integration

```yaml
# .github/workflows/test.yml
name: Tests

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup ambientes virtualizados
        run: |
          ./scripts/infrastructure/virtualize.sh create postgres test 5432
          ./scripts/infrastructure/virtualize.sh start postgres test

      - name: Run tests
        run: |
          source <(./scripts/infrastructure/virtualize.sh activate postgres test)
          pytest

      - name: Cleanup
        run: |
          ./scripts/infrastructure/virtualize.sh destroy postgres test
```

## Resumen

El sistema de ambientes virtualizados te da:

[OK] **Aislamiento** - Cada ambiente es independiente
[OK] **Rapidez** - Inicia en segundos
[OK] **Ligero** - 100-200 MB por ambiente
[OK] **Múltiples** - Corre varios simultáneamente
[OK] **Limpieza** - Destruir y recrear fácilmente
[OK] **Portabilidad** - Solo requiere Docker
[OK] **CI/CD Ready** - Ya containerizado

Es como tener `venv` de Python, pero para servicios completos.
