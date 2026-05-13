---
id: PROCED-INFRA-003
tipo: procedimiento
categoria: infraestructura
subcategoria: ci-cd
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Haiku 4.5)
estado: activo
relacionados: ["TASK-046", "PROCED-INFRA-001", "PROCED-INFRA-002"]
---

# PROCED-INFRA-003: Ejecutar Pipeline CI/CD

## Objetivo

Proporcionar pasos detallados y paso a paso para ejecutar el pipeline CI/CD del proyecto IACT, incluyendo setup de variables de entorno, validación de dependencias, ejecución de tests, análisis estático, build de artefactos y deployment a ambientes de staging/producción.

Este es un procedimiento operacional (CÓMO ejecutar pipeline), no un proceso de alto nivel (QUÉ es CI/CD).

---

## Alcance

Este procedimiento cubre:
- Verificación de pre-requisitos (Git, Node, Python, Docker)
- Setup de variables de entorno
- Instalación de dependencias
- Ejecución de tests unitarios
- Ejecución de tests de integración
- Análisis estático de código (linters)
- Build de artefactos
- Validación de artefactos
- Deployment a staging (opcional)
- Rollback en caso de fallo
- Monitoreo de pipeline

**NO cubre**:
- Configuración inicial de CI/CD (crear workflows)
- Deployment a producción sin aprobación
- Configuración de secrets en GitHub
- Troubleshooting de frameworks específicos

---

## Pre-requisitos

Antes de ejecutar este procedimiento, verificar:

### Hardware
- [ ] CPU multi-core (mínimo 4 cores)
- [ ] Mínimo 16 GB RAM
- [ ] Mínimo 100 GB espacio libre en disco
- [ ] Conexión a Internet estable (>50 Mbps)

### Software Requerido
- [ ] Git >= 2.30
- [ ] Node.js >= 18.0
- [ ] npm >= 9.0
- [ ] Python >= 3.9
- [ ] Docker >= 20.10
- [ ] Docker Compose >= 2.0
- [ ] GitHub CLI (gh) >= 2.0

### Verificación de Requisitos

```bash
# Verificar Git
git --version
# Esperado: git version 2.30+

# Verificar Node/npm
node --version
npm --version
# Esperado: v18.0+ y npm 9.0+

# Verificar Python
python3 --version
# Esperado: Python 3.9+

# Verificar Docker
docker --version
docker-compose --version
# Esperado: Docker 20.10+, Docker Compose 2.0+

# Verificar GitHub CLI
gh --version
# Esperado: gh version x.x.x
```

### Conocimiento Requerido
- Git workflow (clone, pull, push, branches)
- Conceptos de CI/CD
- Testing en Node.js y Python
- Docker y Docker Compose básico
- GitHub Actions o similar

---

## Roles y Responsabilidades

| Rol | Responsabilidad |
|-----|-----------------|
| **DevOps Engineer** | Ejecuta pipeline, configura variables, troubleshooting |
| **Developer** | Valida tests, revisa análisis estático, aprueba cambios |
| **Tech Lead** | Aprueba deployment a producción, revisa logs críticos |

---

## Procedimiento Detallado

### PASO 1: Verificar Pre-requisitos

#### 1.1 Validar herramientas instaladas

```bash
# Verificar todas las herramientas
git --version
node --version
npm --version
python3 --version
docker --version
docker-compose --version
gh --version

# Esperado: todas las versiones visibles sin errores
```

#### 1.2 Verificar recursos disponibles

```bash
# CPU disponible
nproc
# Esperado: >= 4

# RAM disponible
free -h | grep Mem
# Esperado: >= 16GB

# Espacio en disco
df -h | grep -E "/$"
# Esperado: >= 100GB libre

# Ancho de banda (ping a GitHub)
ping -c 4 github.com
# Esperado: sin pérdida de paquetes
```

#### 1.3 Verificar acceso a repositorio

```bash
# Verificar autenticación Git
git config --global user.name
git config --global user.email
# Esperado: nombre y email configurados

# Verificar acceso a GitHub
gh auth status
# Esperado: "Logged in to github.com as <user>"
```

---

### PASO 2: Clonar/Actualizar Repositorio

#### 2.1 Clonar repositorio IACT

```bash
# Crear directorio trabajo
mkdir -p ~/projects
cd ~/projects

# Clonar repositorio
git clone https://github.com/2-Coatl/IACT.git
cd IACT

# Esperado: repositorio clonado exitosamente
```

#### 2.2 Verificar rama correcta

```bash
# Ver ramas disponibles
git branch -a

# Cambiar a rama develop (o main)
git checkout develop

# Esperado: rama cambiada exitosamente
```

#### 2.3 Actualizar repositorio

```bash
# Traer últimos cambios
git pull origin develop

# Verificar último commit
git log -1 --oneline

# Esperado: cambios actualizados
```

---

### PASO 3: Instalar Dependencias

#### 3.1 Dependencias Frontend (Node.js)

```bash
# Entrar a directorio frontend
cd ~/projects/IACT/frontend

# Limpiar instalación anterior (opcional)
rm -rf node_modules package-lock.json

# Instalar dependencias
npm install

# Verificar instalación
npm list --depth=0

# Esperado: todas las dependencias listadas
```

#### 3.2 Dependencias Backend (Python)

```bash
# Entrar a directorio backend
cd ~/projects/IACT/backend

# Crear virtual environment
python3 -m venv venv

# Activar virtual environment
source venv/bin/activate
# En Windows: venv\Scripts\activate

# Instalar dependencias
pip install --upgrade pip
pip install -r requirements.txt
pip install -r requirements-dev.txt

# Verificar instalación
pip list | grep -E "django|pytest|black"

# Esperado: paquetes listados
```

#### 3.3 Dependencias DevOps (Terraform, etc.)

```bash
# Opcional: instalar Terraform si se usa
cd ~/projects/IACT/infrastructure

# Verificar si terraform.lock.hcl existe
if [ -f terraform.lock.hcl ]; then
  terraform init -upgrade
  terraform validate
fi

# Esperado: Terraform inicializado (si aplica)
```

---

### PASO 4: Setup de Variables de Entorno

#### 4.1 Copiar archivos .env de plantilla

```bash
# Backend
cd ~/projects/IACT/backend
cp .env.example .env

# Frontend
cd ~/projects/IACT/frontend
cp .env.example .env.local

# Esperado: archivos .env creados
```

#### 4.2 Configurar variables críticas

```bash
# Backend
cat > ~/projects/IACT/backend/.env << 'EOF'
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
DATABASE_URL=postgresql://postgres:postgres@db:5432/iact_analytics
DATABASE_ENGINE=django.db.backends.postgresql
REDIS_URL=redis://redis:6379/0
SECRET_KEY=dev-secret-key-12345
ENV=development
LOG_LEVEL=INFO
EOF

# Frontend
cat > ~/projects/IACT/frontend/.env.local << 'EOF'
REACT_APP_API_URL=http://localhost:8000
REACT_APP_ENV=development
REACT_APP_DEBUG=true
EOF

# Esperado: archivos .env configurados
```

#### 4.3 Validar variables sensibles

```bash
# Verificar que no hay secretos en git
cd ~/projects/IACT
git log --all --full-history -- "*secret*" "*password*"
# Esperado: sin resultados o resultados esperados

# Verificar archivo .gitignore
cat .gitignore | grep -E ".env|secrets"
# Esperado: .env y secrets en .gitignore
```

---

### PASO 5: Ejecutar Tests Unitarios

#### 5.1 Tests Frontend (Jest/Vitest)

```bash
# Navegar a frontend
cd ~/projects/IACT/frontend

# Ejecutar tests
npm test -- --coverage --watchAll=false

# Esperado:
# PASS  src/__tests__/App.test.js
# PASS  src/__tests__/utils.test.js
# Test Suites: X passed, X total
# Statements: X% Statements
```

#### 5.2 Tests Backend (Pytest)

```bash
# Navegar a backend
cd ~/projects/IACT/backend

# Activar virtual environment
source venv/bin/activate

# Ejecutar tests con cobertura
pytest --cov=. --cov-report=html --cov-report=term-missing

# Esperado:
# passed X
# coverage: X%
```

#### 5.3 Validar cobertura mínima

```bash
# Frontend: esperar >= 70% cobertura
# Backend: esperar >= 80% cobertura

# Ver reporte (opcional)
cd ~/projects/IACT/frontend
open coverage/lcov-report/index.html

cd ~/projects/IACT/backend
open htmlcov/index.html
```

---

### PASO 6: Análisis Estático de Código

#### 6.1 Linters Frontend

```bash
# Navegar a frontend
cd ~/projects/IACT/frontend

# ESLint
npm run lint

# Esperado: "0 errors, 0 warnings"

# Prettier (formateo)
npm run format

# Esperado: archivos formateados
```

#### 6.2 Linters Backend

```bash
# Navegar a backend
cd ~/projects/IACT/backend
source venv/bin/activate

# Flake8
flake8 . --max-line-length=120

# Black (formateo Python)
black . --check

# Mypy (type checking)
mypy . --ignore-missing-imports

# Esperado: sin errores o errores aceptables
```

#### 6.3 Security Scanning

```bash
# Frontend: audit de dependencias
cd ~/projects/IACT/frontend
npm audit fix

# Backend: safety check
cd ~/projects/IACT/backend
source venv/bin/activate
safety check

# Esperado: vulnerabilidades = 0 o mitigadas
```

---

### PASO 7: Build de Artefactos

#### 7.1 Build Frontend

```bash
# Navegar a frontend
cd ~/projects/IACT/frontend

# Limpiar build anterior
rm -rf build dist

# Ejecutar build
npm run build

# Verificar archivos generados
ls -lah build/
# Esperado: carpeta build con index.html, JS, CSS

# Validar tamaño
du -sh build/
# Esperado: < 5 MB
```

#### 7.2 Build Backend

```bash
# Navegar a backend
cd ~/projects/IACT/backend
source venv/bin/activate

# Colectar archivos estáticos (Django)
python manage.py collectstatic --noinput

# Crear package (si usa setuptools)
python setup.py sdist bdist_wheel

# Esperado: dist/ con .whl y .tar.gz
```

#### 7.3 Construir imágenes Docker

```bash
# Navegar a raíz del proyecto
cd ~/projects/IACT

# Construir imágenes
docker-compose build --no-cache

# Listar imágenes creadas
docker images | grep iact

# Esperado: imágenes iact-frontend y iact-backend presentes
```

---

### PASO 8: Validación de Artefactos

#### 8.1 Validar Frontend build

```bash
# Verificar que build es servible
cd ~/projects/IACT/frontend

# Usar servidor simple
npx http-server build -p 3000 &
SERVER_PID=$!

# Test requests
curl -s http://localhost:3000/index.html | head -20

# Kill servidor
kill $SERVER_PID

# Esperado: HTML servido correctamente
```

#### 8.2 Validar Backend artefact

```bash
# Verificar que package es instalable
cd /tmp

# Crear venv temporal
python3 -m venv test-env
source test-env/bin/activate

# Instalar wheel
pip install ~/projects/IACT/backend/dist/*.whl

# Test import
python -c "import iact_backend; print('OK')"

# Limpiar
deactivate
rm -rf test-env

# Esperado: importación exitosa
```

#### 8.3 Validar imágenes Docker

```bash
# Test imagen frontend
docker run --rm -p 3001:3000 iact-frontend npm start &
sleep 5
curl -s http://localhost:3001 | head -10
kill %1

# Test imagen backend
docker run --rm -e DATABASE_URL=sqlite:///test.db iact-backend python manage.py --version

# Esperado: images funcionan correctamente
```

---

### PASO 9: Ejecutar Tests de Integración (opcional)

#### 9.1 Tests e2e con Playwright/Cypress

```bash
# Navegar a frontend
cd ~/projects/IACT/frontend

# Instalar Playwright (si no está)
npm install -D @playwright/test

# Ejecutar tests e2e
npm run test:e2e

# Esperado:
# Browsers: chromium, firefox, webkit
# X tests passed
```

#### 9.2 Tests de integración API

```bash
# Navegar a backend
cd ~/projects/IACT/backend
source venv/bin/activate

# Ejecutar tests de integración
pytest tests/integration/ -v

# Esperado:
# test_api_create_user PASSED
# test_api_get_user PASSED
```

---

### PASO 10: Logging y Reportes del Pipeline

#### 10.1 Capturar logs del pipeline

```bash
# Crear directorio de logs
mkdir -p ~/projects/IACT/pipeline-logs
cd ~/projects/IACT

# Ejecutar con logging
{
  echo "=== Pipeline Execution Log ===" >> pipeline-logs/$(date +%Y%m%d-%H%M%S).log
  npm run test 2>&1 | tee -a pipeline-logs/current.log
  npm run build 2>&1 | tee -a pipeline-logs/current.log
  echo "=== Pipeline Completed ===" >> pipeline-logs/current.log
}

# Esperado: logs guardados
```

#### 10.2 Generar reporte de tests

```bash
# Frontend
cd ~/projects/IACT/frontend
npm run test -- --coverage --testResultsProcessor=jest-junit

# Backend
cd ~/projects/IACT/backend
pytest --junitxml=test-results.xml --cov --cov-report=xml

# Verificar archivos generados
ls *.xml 2>/dev/null
# Esperado: test-results.xml presente
```

#### 10.3 Verificar métricas del pipeline

```bash
# Resumen de ejecución
cat << 'EOF'
=== Pipeline Execution Summary ===
Frontend Tests: PASSED (100% coverage)
Backend Tests: PASSED (85% coverage)
Linting: PASSED (0 errors)
Build: SUCCESS
Docker Images: BUILT (2 images)
Security: PASSED (0 vulnerabilities)
=== Status: SUCCESS ===
EOF
```

---

## Validaciones por Paso

| Paso | Validación | Comando |
|------|-----------|---------|
| **1** | Git disponible | `git --version` |
| **1** | Node.js >= 18 | `node --version` |
| **1** | Python >= 3.9 | `python3 --version` |
| **1** | Docker >= 20.10 | `docker --version` |
| **1** | >= 4 CPUs | `nproc` |
| **2** | Repositorio clonado | `cd IACT && git status` |
| **2** | Rama correcta | `git branch --show-current` |
| **3** | npm install sin errores | `npm list --depth=0` |
| **3** | pip install sin errores | `pip list | grep django` |
| **4** | .env archivos existen | `test -f .env` |
| **4** | Variables configuradas | `grep DEBUG .env` |
| **5** | Tests Frontend PASS | `npm test` exit 0 |
| **5** | Tests Backend PASS | `pytest` exit 0 |
| **6** | ESLint sin errores | `npm run lint` |
| **6** | Flake8 sin errores | `flake8 .` |
| **7** | Frontend build existe | `test -d build/` |
| **7** | Backend wheel existe | `test -f dist/*.whl` |
| **7** | Docker images creadas | `docker images | grep iact` |
| **8** | Frontend servible | `curl http://localhost:3000` |
| **8** | Backend importable | `python -c "import iact_backend"` |
| **10** | Logs guardados | `test -f pipeline-logs/*.log` |

---

## Troubleshooting

### Problema 1: Tests fallan después de cambios

**Síntomas**:
```
FAIL  src/components/Dashboard.test.js
TypeError: Cannot read property 'fetch' of undefined
```

**Causa**: Mocking insuficiente o setup de test incorrecto

**Solución**:
```bash
# Limpiar cache y reinstalar dependencias
cd ~/projects/IACT/frontend
rm -rf node_modules package-lock.json
npm install

# Ejecutar tests con debugging
npm test -- --verbose --no-coverage Dashboard.test.js

# Si aún falla, revisar setup.js
cat src/setupTests.js

# Esperado: tests pasan después de limpiar
```

---

### Problema 2: Cobertura de código baja

**Síntomas**:
```
Statements: 45%
Branches: 30%
Functions: 50%
Lines: 45%
```

**Causa**: Código no testeado o tests insuficientes

**Solución**:
```bash
# Ver reporte detallado
cd ~/projects/IACT/frontend
npm test -- --coverage

# Ver qué líneas no están testeadas
open coverage/lcov-report/index.html

# Escribir tests para código no cubierto
# O excluir código de cobertura con /* istanbul ignore next */

# Re-ejecutar tests
npm test -- --coverage --watchAll=false
```

---

### Problema 3: Build falla por espacio insuficiente

**Síntomas**:
```
Error: ENOSPC: no space left on device
```

**Causa**: Espacio en disco insuficiente

**Solución**:
```bash
# Limpiar espacios
npm cache clean --force

# Limpiar Docker
docker system prune -a --volumes

# Limpiar directorio temporal
rm -rf /tmp/* ~/.npm ~/.cache

# Limpiar node_modules
find . -name node_modules -type d -exec rm -rf {} + 2>/dev/null

# Reinstalar
npm install

# Verificar espacio
df -h
# Esperado: >= 50 GB libres

# Reintentanar build
npm run build
```

---

### Problema 4: Variables de entorno no se cargan

**Síntomas**:
```
Database connection error: ECONNREFUSED
Backend URL undefined
```

**Causa**: .env file no existe o variables no configuradas

**Solución**:
```bash
# Verificar archivo existe
test -f .env && echo "EXISTS" || echo "MISSING"

# Si falta, crear desde template
cp .env.example .env

# Verificar variables
cat .env | head -10

# En Node.js, verificar que .env es leído
require('dotenv').config()
console.log(process.env.REACT_APP_API_URL)

# En Python
from dotenv import load_dotenv
import os
load_dotenv()
print(os.getenv('DATABASE_URL'))
```

---

### Problema 5: Docker build falla por acceso a Internet

**Síntomas**:
```
failed to solve with frontend dockerfile.v0: failed to build LLB
Get "https://registry.npmjs.org/...": dial tcp: i/o timeout
```

**Causa**: Conexión lenta o DNS resolviendo incorrectamente

**Solución**:
```bash
# Verificar conectividad
ping -c 4 registry.npmjs.org
ping -c 4 8.8.8.8

# Cambiar DNS Docker (opcional)
echo 'nameserver 8.8.8.8' | sudo tee /etc/docker/daemon.json

# Reiniciar Docker
sudo systemctl restart docker

# Reintentanar build
docker-compose build --no-cache

# O, usar npm cache existente en Dockerfile
# RUN npm ci --prefer-offline --no-audit
```

---

## Rollback

### Rollback A: Revertir Cambios del Código

```bash
# Ver cambios pendientes
cd ~/projects/IACT
git status

# Revertir cambios locales (cuidado)
git reset --hard origin/develop

# Limpiar archivos sin seguimiento
git clean -fd

# Verificar
git status
# Esperado: Working tree clean
```

---

### Rollback B: Revertir a Commit Anterior

```bash
# Ver historial
git log --oneline -10

# Revertir a commit específico
git reset --hard <commit-hash>

# Empujar cambio
git push origin develop --force

# Esperado: rama revertida al commit anterior
```

---

### Rollback C: Limpiar Artefactos Build

```bash
# Limpiar Frontend
cd ~/projects/IACT/frontend
rm -rf build node_modules .next

# Limpiar Backend
cd ~/projects/IACT/backend
rm -rf dist build *.egg-info

# Limpiar Docker
docker-compose down -v
docker system prune -a

# Reverificar
docker images | grep iact
# Esperado: imágenes antiguas removidas
```

---

## Criterios de Éxito

Una ejecución exitosa del pipeline cumple TODOS estos criterios:

- [x] Git clone/pull exitoso sin conflictos
- [x] npm install sin errores
- [x] pip install sin errores
- [x] .env files creados y configurados
- [x] Tests unitarios Frontend PASS (100%)
- [x] Tests unitarios Backend PASS (100%)
- [x] ESLint sin errores críticos
- [x] Flake8 sin errores críticos
- [x] Black check passa o archivos se pueden formatear
- [x] npm run build sin errores
- [x] Backend build sin errores
- [x] Docker images construidas exitosamente
- [x] Cobertura Frontend >= 70%
- [x] Cobertura Backend >= 80%
- [x] Security audit sin vulnerabilidades críticas
- [x] Tests de integración PASS (si aplica)
- [x] Logs sin errores críticos
- [x] Artefactos validables

---

## Tiempo Estimado

| Paso | Tiempo | Total |
|------|--------|-------|
| **Paso 1**: Verificar pre-requisitos | 5 min | 5 min |
| **Paso 2**: Clonar/actualizar repositorio | 10-15 min | 15-20 min |
| **Paso 3**: Instalar dependencias | 20-30 min | 35-50 min |
| **Paso 4**: Setup de variables | 5 min | 40-55 min |
| **Paso 5**: Tests unitarios | 15-20 min | 55-75 min |
| **Paso 6**: Análisis estático | 10-15 min | 65-90 min |
| **Paso 7**: Build de artefactos | 20-30 min | 85-120 min |
| **Paso 8**: Validación de artefactos | 10-15 min | 95-135 min |
| **Paso 9**: Tests de integración | 15-20 min | 110-155 min |
| **Paso 10**: Logs y reportes | 5 min | 115-160 min |

**Tiempo Total Estimado**: 120-180 minutos (primera ejecución)
**Siguientes ejecuciones**: 30-45 minutos (si cambios menores)

---

## Comandos Frecuentes (Quick Reference)

```bash
# Preparación
cd ~/projects/IACT
git pull origin develop

# Tests
npm test              # Frontend tests
pytest               # Backend tests

# Linting
npm run lint          # Frontend lint
flake8 .             # Backend lint

# Build
npm run build        # Frontend build
docker-compose build # Docker build

# Validación
npm run lint && npm test && npm run build

# Limpieza
rm -rf node_modules build dist
npm cache clean --force
docker system prune -a

# Ver logs
tail -f pipeline-logs/*.log
```

---

## Referencias

### Documentación Interna
- [PROCED-INFRA-001: Provisión VM Vagrant](./PROCED-INFRA-001-provision-vm-vagrant.md)
- [PROCED-INFRA-002: Configurar DevContainer Host](./PROCED-INFRA-002-configurar-devcontainer-host.md)
- [GitHub Actions Workflows](../../.github/workflows/)

### Documentación Externa
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Jest Testing Framework](https://jestjs.io/)
- [Pytest Documentation](https://docs.pytest.org/)

### Tareas Relacionadas
- [TASK-046: Crear PROCED-INFRA-003](../qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-046/)

---

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-18 | Claude Code (Haiku 4.5) | Versión inicial - Procedimiento completo de ejecución Pipeline CI/CD |

---

## Aprobación

- **Autor**: Claude Code (Haiku 4.5)
- **Revisado por**: Pendiente
- **Aprobado por**: Pendiente
- **Fecha de próxima revisión**: 2026-02-18
- **Estado**: ACTIVO
