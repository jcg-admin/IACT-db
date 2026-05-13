---
title: Scripts de CI/CD del Proyecto IACT
date: 2025-11-13
domain: general
status: active
---

# Scripts de CI/CD del Proyecto IACT

Documentacion completa de scripts de integracion continua y deployment continuo.

## Ubicacion

`/home/user/IACT---project/scripts/ci/`

## Scripts Disponibles

### backend_test.sh

**Proposito:** Ejecutar suite completa de tests del backend Django.

**Uso:**
```bash
# Tests con MySQL (default)
./scripts/ci/backend_test.sh mysql

# Tests con PostgreSQL
./scripts/ci/backend_test.sh postgresql

# Tests con ambas BD
./scripts/ci/backend_test.sh all
```

**Que hace:**
1. Ejecuta linters (flake8, black, isort)
2. Valida restricciones IACT (RNF-002: NO Redis, NO email)
3. Ejecuta tests con MySQL
4. Ejecuta tests con PostgreSQL (opcional)
5. Genera reporte de coverage (target: >80%)
6. Ejecuta integration tests
7. Valida restricciones criticas

**Output esperado:**
```
[INFO] Backend CI Script - Starting...
[INFO] Test database: all
[INFO] Step 1/6: Running linters...
[OK] flake8 passed
[INFO] Step 2/6: Validating IACT restrictions (RNF-002)...
[OK] NO Redis usage detected
[OK] Session backend correctly configured (MySQL)
[INFO] Step 3/6: Running tests with MySQL...
[OK] MySQL tests passed with coverage > 80%
[INFO] Step 4/6: Running tests with PostgreSQL...
[OK] PostgreSQL tests passed
[INFO] Step 5/6: Running integration tests...
[INFO] Step 6/6: Running validation scripts...
[OK] Backend CI completed successfully!
```

**Prerequisitos:**
- Python 3.11+
- MySQL o PostgreSQL corriendo
- Variables de entorno: `DB_USER`, `DB_PASSWORD`, `DB_HOST`

**Validaciones RNF-002:**
- NO Redis en settings
- NO django_redis
- Session backend debe ser `django.contrib.sessions.backends.db`
- Email usage detectado (warning)

---

### frontend_test.sh

**Proposito:** Ejecutar suite completa de tests del frontend React.

**Uso:**
```bash
./scripts/ci/frontend_test.sh
```

**Que hace:**
1. Instala dependencias (npm install)
2. Ejecuta linter (ESLint)
3. Ejecuta tests unitarios (Jest)
4. Ejecuta tests E2E (Cypress/Playwright)
5. Genera reporte de coverage

**Output esperado:**
```
[INFO] Frontend CI Script - Starting...
[INFO] Step 1/4: Installing dependencies...
[OK] Dependencies installed
[INFO] Step 2/4: Running linter...
[OK] Linting passed
[INFO] Step 3/4: Running unit tests...
[OK] Unit tests passed (coverage: 87%)
[INFO] Step 4/4: Running E2E tests...
[OK] E2E tests passed
[OK] Frontend CI completed successfully!
```

**Prerequisitos:**
- Node.js 18+
- npm o yarn

---

### security_scan.sh

**Proposito:** Ejecutar escaneos de seguridad en backend y frontend.

**Uso:**
```bash
./scripts/ci/security_scan.sh
```

**Que hace:**
1. Escanea dependencias Python (Bandit, Safety)
2. Escanea dependencias Node (npm audit)
3. Detecta secretos en codigo (detect-secrets)
4. Valida configuracion de seguridad

**Output esperado:**
```
[INFO] Security Scan - Starting...
[INFO] Step 1/4: Scanning Python dependencies...
[OK] No vulnerabilities found in Python dependencies
[INFO] Step 2/4: Scanning Node dependencies...
[WARNING] 2 moderate vulnerabilities found (see npm audit)
[INFO] Step 3/4: Detecting secrets...
[OK] No secrets detected
[INFO] Step 4/4: Validating security config...
[OK] Security config validated
[OK] Security scan completed
```

**Herramientas utilizadas:**
- **Bandit**: Analisis estatico de seguridad Python
- **Safety**: Chequeo de vulnerabilidades en dependencias Python
- **npm audit**: Chequeo de vulnerabilidades Node
- **detect-secrets**: Deteccion de secretos en codigo

---

### test_pyramid_check.sh

**Proposito:** Validar distribucion de tests segun Test Pyramid (60% unit, 30% integration, 10% E2E).

**Uso:**
```bash
./scripts/ci/test_pyramid_check.sh
```

**Que hace:**
1. Cuenta tests backend (unit, integration, E2E)
2. Cuenta tests frontend (unit, integration, E2E)
3. Calcula distribucion porcentual
4. Valida contra targets (60/30/10 con tolerancia)
5. Genera reporte

**Output esperado:**
```
============================================
TEST PYRAMID METRICS
============================================
Total Tests: 125

Unit Tests: 75 (60%)
Integration Tests: 38 (30%)
E2E Tests: 12 (10%)
============================================

[INFO] Validating Test Pyramid (Target: 60% Unit, 30% Integration, 10% E2E)...

[OK] Unit tests are 60% (>= 50%)
[OK] Integration tests are 30% (20-40%)
[OK] E2E tests are 10% (<= 20%)

============================================
[OK] Test pyramid validation PASSED
============================================
```

**Targets:**
- Unit tests: >= 50% (target 60%)
- Integration tests: 20-40% (target 30%)
- E2E tests: <= 20% (target 10%)

**Falla si:**
- Unit tests < 50%

**Warning si:**
- Integration tests fuera de rango 20-40%
- E2E tests > 20%

**Generar reporte:**
```bash
REPORT_FILE=test-pyramid-report.md ./scripts/ci/test_pyramid_check.sh
```

---

## Integration con GitHub Actions

### Workflow: Backend CI

`.github/workflows/backend-ci.yml`

```yaml
name: Backend CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  backend-tests:
    runs-on: ubuntu-latest

    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: test_iact
        ports:
          - 3306:3306

    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: pip install -r api/requirements.txt

      - name: Run backend tests
        run: ./scripts/ci/backend_test.sh mysql
        env:
          DB_USER: root
          DB_PASSWORD: root
          DB_HOST: 127.0.0.1
          DB_PORT: 3306
```

### Workflow: Frontend CI

`.github/workflows/frontend-ci.yml`

```yaml
name: Frontend CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  frontend-tests:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Run frontend tests
        run: ./scripts/ci/frontend_test.sh
```

### Workflow: Test Pyramid

`.github/workflows/test-pyramid.yml`

```yaml
name: Test Pyramid Validation

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test-pyramid:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Validate test pyramid
        run: ./scripts/ci/test_pyramid_check.sh

      - name: Upload pyramid report
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: test-pyramid-report
          path: test-pyramid-report.md
```

---

## Scripts de Deployment

### deploy.sh

**Ubicacion:** `/home/user/IACT---project/scripts/deploy.sh`

**Proposito:** Deploy a staging o production con blue-green deployment.

**Uso:**
```bash
# Deploy a staging
./scripts/deploy.sh staging

# Deploy a production
./scripts/deploy.sh production
```

**Fases del deployment:**
1. Pre-deployment checks
2. Backup de BD
3. Migraciones
4. Blue-green swap
5. Smoke tests
6. Post-deployment validation

**Ejemplo:**
```bash
./scripts/deploy.sh staging

[INFO] Deployment to staging - Starting...
[INFO] Phase 1: Pre-deployment checks
[OK] All pre-deployment checks passed
[INFO] Phase 2: Database backup
[OK] Database backup created: backup_20251107_103000.sql
[INFO] Phase 3: Running migrations
[OK] Migrations applied successfully
[INFO] Phase 4: Blue-green deployment
[OK] Blue environment ready
[OK] Traffic switched to blue
[INFO] Phase 5: Smoke tests
[OK] All smoke tests passed
[INFO] Phase 6: Post-deployment validation
[OK] Deployment completed successfully
[INFO] Rollback available: ./scripts/deploy/rollback.sh backup_20251107_103000.sql
```

---

### health_check.sh

**Proposito:** Verificar salud de aplicacion desplegada.

**Uso:**
```bash
./scripts/health_check.sh staging
```

**Checks realizados:**
- Endpoint `/health` responde 200
- Base de datos accesible
- Cassandra accesible (logs)
- Redis NO debe estar presente
- Tiempos de respuesta < 500ms

---

## Ejecucion Local

### Backend Tests

```bash
# Navegar a directorio del proyecto
cd /home/user/IACT---project

# Ejecutar backend tests
./scripts/ci/backend_test.sh mysql

# Con coverage detallado
./scripts/ci/backend_test.sh mysql --coverage-report html
# Ver reporte en: api/htmlcov/index.html
```

### Frontend Tests

```bash
cd /home/user/IACT---project

# Ejecutar frontend tests
./scripts/ci/frontend_test.sh

# Solo unit tests
cd frontend && npm run test:unit

# Solo E2E
cd frontend && npm run test:e2e
```

### Test Pyramid Check

```bash
cd /home/user/IACT---project

# Validar test pyramid
./scripts/ci/test_pyramid_check.sh

# Con reporte
REPORT_FILE=pyramid-report.md ./scripts/ci/test_pyramid_check.sh
cat pyramid-report.md
```

---

## Troubleshooting

### Backend tests fallan con error de BD

**Sintoma:** `django.db.utils.OperationalError: Can't connect to MySQL`

**Solucion:**
```bash
# Verificar que MySQL corre
mysqladmin ping -h 127.0.0.1

# Iniciar MySQL si no corre
sudo systemctl start mysql

# Verificar credenciales
export DB_USER=root
export DB_PASSWORD=root
./scripts/ci/backend_test.sh mysql
```

### Coverage < 80%

**Sintoma:** Tests pasan pero coverage es bajo

**Solucion:**
```bash
# Ver que modulos tienen bajo coverage
pytest --cov=. --cov-report=term-missing

# Agregar tests para archivos sin coverage
# Priorizar archivos core del negocio
```

### Test pyramid falla

**Sintoma:** `Test pyramid validation FAILED - Unit tests are only 45%`

**Solucion:**
```bash
# Ver distribucion actual
./scripts/ci/test_pyramid_check.sh

# Agregar mas unit tests
# Los unit tests deben:
# - Testear funciones/componentes aislados
# - No tener dependencias externas (BD, API)
# - Ser rapidos (< 100ms cada uno)
```

### Security scan detecta vulnerabilidades

**Sintoma:** `2 high vulnerabilities found`

**Solucion:**
```bash
# Ver detalles
npm audit

# Actualizar dependencias vulnerables
npm audit fix

# Si no hay fix automatico
npm audit fix --force  # Cuidado: puede romper compatibilidad
```

---

## Mejores Practicas

1. **Ejecutar CI localmente antes de push:**
   ```bash
   ./scripts/ci/backend_test.sh all
   ./scripts/ci/frontend_test.sh
   ./scripts/ci/test_pyramid_check.sh
   ```

2. **Mantener coverage > 80%:**
   - Focus en unit tests
   - Priorizar codigo de negocio
   - Evitar tests de UI/CSS

3. **Respetar test pyramid:**
   - 60% unit tests (rapidos, aislados)
   - 30% integration tests (moderados)
   - 10% E2E tests (lentos, fragiles)

4. **Fix security issues inmediatamente:**
   - Revisar `npm audit` y `safety check` regularmente
   - Actualizar dependencias vulnerables
   - No ignorar warnings de seguridad

5. **Validar restricciones criticas:**
   ```bash
   ./scripts/validate_critical_restrictions.sh
   ```

---

## Referencias

- **Scripts CI:** `/home/user/IACT---project/scripts/ci/`
- **Workflows GitHub:** `/home/user/IACT---project/.github/workflows/`
- **Deploy script:** `/home/user/IACT---project/scripts/deploy.sh`
- **Validation scripts:** `/home/user/IACT---project/scripts/validate_*.sh`

---

**Ultima actualizacion:** 2025-11-07
**Version:** 1.0
**Mantenedores:** @devops-lead, @tech-lead
