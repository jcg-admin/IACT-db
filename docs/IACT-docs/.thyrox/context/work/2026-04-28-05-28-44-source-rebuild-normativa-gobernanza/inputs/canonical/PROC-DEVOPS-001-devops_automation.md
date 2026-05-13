---
id: PROC-DEVOPS-001
tipo: proceso
categoria: devops
subcategoria: automation
estado: activo
version: 2.0.0
fecha_creacion: 2025-11-06
autor: devops-lead
relacionados:
  - PROC-SDLC-001
  - RNF-002 (NO Redis)
  - restricciones_y_lineamientos.md
---

# DevOps Automation - Proyecto IACT

Automatizaci?n DevOps con shell scripts locales, integrada con SDLC.

## Restricciones Cr?ticas IACT

**ANTES DE CUALQUIER AUTOMATIZACI?N**:

```yaml
NO PROHIBIDO:
  - Redis/Memcached (RNF-002)
  - Email/SMTP
  - Dependencias externas no aprobadas

S? OBLIGATORIO:
  - Sesiones en MySQL (django.contrib.sessions.backends.db)
  - Notificaciones via buz?n interno
  - Scripts shell que funcionan offline
```

## Integraci?n con SDLC

```
Planning -> Feasibility -> Design -> Implementation -> Testing -> Deployment -> Maintenance
              ?              ?          ?             ?           ?            ?
           Scripts      Scripts    Scripts       Scripts     Scripts      Scripts
```

## ?reas de Automatizaci?n

### 1. Validaci?n Pre-Commit

**Scripts existentes**:

```bash
# scripts/validate_critical_restrictions.sh
#!/bin/bash
# Valida que NO se use Redis, email, etc.

echo "Validando restricciones cr?ticas IACT..."

# Check Redis prohibido
if grep -r "redis" api/callcentersite/settings*.py; then
    echo "ERROR: Redis detectado. Prohibido por RNF-002"
    exit 1
fi

# Check SESSION_ENGINE correcto
if ! grep -q "django.contrib.sessions.backends.db" api/callcentersite/settings*.py; then
    echo "ERROR: SESSION_ENGINE debe ser django.contrib.sessions.backends.db"
    exit 1
fi

# Check email prohibido
if grep -r "EmailMessage\|send_mail\|EmailMultiAlternatives" api/callcentersite/*.py; then
    echo "ERROR: Email prohibido. Usar InternalMessage"
    exit 1
fi

echo "? Todas las restricciones cr?ticas validadas"
```

**Instalaci?n**:

```bash
# scripts/install_hooks.sh
#!/bin/bash
# Instala hooks de validaci?n

cp scripts/validate_critical_restrictions.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo "? Pre-commit hooks instalados"
```

### 2. Testing Automatizado

**Script de test completo**:

```bash
#!/bin/bash
# scripts/run_all_tests.sh - Test completo local

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "========================================="
echo "TEST SUITE COMPLETO - IACT"
echo "========================================="

# 1. Backend tests
echo -e "\n[1/5] Backend Unit Tests..."
cd api/callcentersite
python manage.py test --parallel --keepdb

# 2. Coverage check
echo -e "\n[2/5] Coverage Analysis..."
pytest --cov=callcentersite --cov-report=term --cov-report=html --cov-fail-under=80

# 3. Security checks
echo -e "\n[3/5] Security Validation..."
bash ../../scripts/validate_security_config.sh

# 4. Database router validation
echo -e "\n[4/5] Database Router Check..."
bash ../../scripts/validate_database_router.sh

# 5. Critical restrictions
echo -e "\n[5/5] Critical Restrictions..."
bash ../../scripts/validate_critical_restrictions.sh

echo -e "\n========================================="
echo "? TODOS LOS TESTS PASARON"
echo "========================================="
```

### 3. Deployment Local

**Deploy script**:

```bash
#!/bin/bash
# scripts/deploy.sh - Deploy a ambiente

ENV=${1:-staging}

if [ "$ENV" != "staging" ] && [ "$ENV" != "production" ]; then
    echo "Uso: ./scripts/deploy.sh [staging|production]"
    exit 1
fi

echo "Desplegando a $ENV..."

# 1. Validaciones pre-deploy
./scripts/validate_critical_restrictions.sh || exit 1
./scripts/run_all_tests.sh || exit 1

# 2. Backup database
echo "Creando backup de base de datos..."
mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASSWORD iact_$ENV > backup_$(date +%Y%m%d_%H%M%S).sql

# 3. Migrations
echo "Aplicando migrations..."
cd api/callcentersite
python manage.py migrate --no-input

# 4. Collect static
echo "Colectando archivos est?ticos..."
python manage.py collectstatic --no-input

# 5. Restart services
echo "Reiniciando servicios..."
sudo systemctl restart gunicorn-iact-$ENV
sudo systemctl restart nginx

# 6. Health check
echo "Health check..."
sleep 5
curl -f http://localhost/api/health || {
    echo "ERROR: Health check fall?. Rollback..."
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD iact_$ENV < backup_*.sql
    exit 1
}

echo "? Deploy exitoso a $ENV"
```

### 4. Monitoreo y M?tricas

**Script de health check**:

```bash
#!/bin/bash
# scripts/health_check.sh

check_service() {
    SERVICE=$1
    URL=$2

    if curl -sf "$URL" > /dev/null; then
        echo "? $SERVICE: OK"
        return 0
    else
        echo "? $SERVICE: FAIL"
        return 1
    fi
}

echo "Health Check IACT"
echo "===================="

check_service "API Backend" "http://localhost:8000/api/health"
check_service "Database" "http://localhost:8000/api/db-check"
check_service "Sessions (MySQL)" "http://localhost:8000/api/session-check"

# Check session storage (debe ser MySQL, NO Redis)
SESSION_BACKEND=$(grep SESSION_ENGINE api/callcentersite/settings.py | grep -o "django.contrib.sessions.backends.db")
if [ -n "$SESSION_BACKEND" ]; then
    echo "? Sessions: MySQL (Correcto - RNF-002)"
else
    echo "? Sessions: NO en MySQL (Violaci?n RNF-002)"
    exit 1
fi
```

### 5. Database Maintenance

**Script de limpieza de sesiones**:

```bash
#!/bin/bash
# scripts/cleanup_sessions.sh
# Limpia sesiones expiradas de MySQL

cd api/callcentersite

# Limpiar sesiones viejas
python manage.py clearsessions

# Obtener estad?sticas
SESSION_COUNT=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -se \
    "SELECT COUNT(*) FROM django_session WHERE expire_date < NOW();" iact_production)

echo "Sesiones expiradas eliminadas: $SESSION_COUNT"

# Alert si tabla muy grande
TOTAL_SESSIONS=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -se \
    "SELECT COUNT(*) FROM django_session;" iact_production)

if [ "$TOTAL_SESSIONS" -gt 100000 ]; then
    echo "WARNING: Tabla django_session tiene $TOTAL_SESSIONS registros"
    echo "Considerar ejecutar cleanup m?s frecuente"
fi
```

**Cron job** (agregar a crontab):

```cron
# Limpiar sesiones cada 6 horas
0 */6 * * * /path/to/scripts/cleanup_sessions.sh >> /var/log/iact/cleanup.log 2>&1

# Health check cada 5 minutos
*/5 * * * * /path/to/scripts/health_check.sh >> /var/log/iact/health.log 2>&1
```

### 6. M?tricas DORA

**Script local de DORA metrics**:

```bash
#!/bin/bash
# scripts/dora_report.sh - Genera reporte DORA local

DAYS=${1:-30}

echo "DORA Metrics Report - ?ltimos $DAYS d?as"
echo "=========================================="

# 1. Deployment Frequency
DEPLOYMENTS=$(git log --since="$DAYS days ago" --grep="deploy:" --oneline | wc -l)
DEPLOY_FREQ=$(echo "scale=2; $DEPLOYMENTS / $DAYS" | bc)
echo "Deployment Frequency: $DEPLOY_FREQ deployments/d?a"

# 2. Lead Time for Changes
# Tiempo promedio entre commit y deploy
AVG_LEAD_TIME=$(git log --since="$DAYS days ago" --grep="deploy:" --format="%ct" | awk '{
    count++;
    sum += $1;
}
END {
    if (count > 0) print sum/count;
}')
echo "Lead Time: $(echo "($AVG_LEAD_TIME / 3600)" | bc) horas promedio"

# 3. Change Failure Rate
TOTAL_DEPLOYS=$(git log --since="$DAYS days ago" --grep="deploy:" | wc -l)
FAILED_DEPLOYS=$(git log --since="$DAYS days ago" --grep="rollback:\|hotfix:" | wc -l)
if [ "$TOTAL_DEPLOYS" -gt 0 ]; then
    CFR=$(echo "scale=2; ($FAILED_DEPLOYS / $TOTAL_DEPLOYS) * 100" | bc)
    echo "Change Failure Rate: $CFR%"
fi

# 4. MTTR (Mean Time To Recovery)
# Tiempo promedio entre incident y resolved
echo "MTTR: Ver issues con label 'incident' en GitHub"

echo "=========================================="
```

### 7. Analytics Service Management

**Template para gesti?n de requests de analytics**:

El proyecto IACT gestiona requests de an?lisis de m?tricas IVR mediante:

1. **Request Types Definidos**:
   - N-001: Dashboard m?tricas IVR en tiempo real
   - An?lisis de call flows
   - Reportes de abandono
   - Trending de volumen de llamadas

2. **Portal de Auto-servicio**:
```bash
# scripts/analytics_portal_setup.sh
#!/bin/bash
# Configura portal interno de analytics

echo "Configurando Analytics Service Portal..."

# Crear templates de solicitudes comunes
cat > api/callcentersite/templates/analytics_requests.md <<EOF
# Analytics Request Types

## 1. Dashboard Metrics (N-001)
**Descripci?n**: Dashboard de m?tricas IVR en tiempo real
**SLA**: 2 horas
**Datos requeridos**:
- Per?odo
- M?tricas espec?ficas
- Nivel de granularidad

## 2. Call Flow Analysis
**Descripci?n**: An?lisis de flujos de llamadas
**SLA**: 4 horas
**Datos requeridos**:
- IVR flow ID
- Rango de fechas
- Filtros opcionales

## 3. Abandonment Report
**Descripci?n**: Reporte de llamadas abandonadas
**SLA**: 2 horas
**Datos requeridos**:
- Per?odo
- Umbral de abandono
- Desglose (por hora/d?a)
EOF

echo "? Analytics portal configurado"
```

3. **Automatizaci?n de Requests**:
```bash
# scripts/process_analytics_request.sh
#!/bin/bash
# Procesa request de analytics autom?ticamente

REQUEST_TYPE=$1
REQUEST_ID=$2

case "$REQUEST_TYPE" in
    "dashboard_metrics")
        python manage.py generate_dashboard_report --request-id=$REQUEST_ID
        ;;
    "call_flow_analysis")
        python manage.py analyze_call_flows --request-id=$REQUEST_ID
        ;;
    "abandonment_report")
        python manage.py generate_abandonment_report --request-id=$REQUEST_ID
        ;;
    *)
        echo "Request type desconocido: $REQUEST_TYPE"
        exit 1
        ;;
esac

# Notificar v?a buz?n interno (NO email)
python manage.py notify_request_complete --request-id=$REQUEST_ID
```

4. **Queues y Priorizaci?n**:
```bash
# scripts/triage_analytics_requests.sh
#!/bin/bash
# Organiza requests por prioridad

mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD iact_production <<EOF
-- Priorizar requests por SLA
SELECT
    id,
    request_type,
    created_at,
    TIMESTAMPDIFF(HOUR, created_at, NOW()) as age_hours,
    CASE
        WHEN request_type = 'dashboard_metrics' AND age_hours > 2 THEN 'OVERDUE'
        WHEN request_type = 'call_flow_analysis' AND age_hours > 4 THEN 'OVERDUE'
        WHEN age_hours > 1 THEN 'URGENT'
        ELSE 'NORMAL'
    END as priority
FROM analytics_requests
WHERE status = 'pending'
ORDER BY priority DESC, created_at ASC;
EOF
```

### 8. Validaci?n de Documentaci?n

**Script de validaci?n docs** (ya existente mejorado):

```bash
# scripts/validar_estructura_docs.sh
#!/bin/bash

echo "Validando estructura de documentaci?n..."

# 1. No references a 'implementacion/'
if grep -r "docs/implementacion" docs/; then
    echo "ERROR: Referencias obsoletas a implementacion/"
    exit 1
fi

# 2. Todas las referencias a restricciones son correctas
if grep -r "Redis" docs/ | grep -v "NO Redis" | grep -v "prohibido"; then
    echo "ERROR: Referencias a Redis sin aclarar que est? prohibido"
    exit 1
fi

# 3. Metadata completo en archivos
find docs/ -name "*.md" -type f | while read file; do
    if ! head -20 "$file" | grep -q "^---$"; then
        echo "WARNING: $file sin metadata YAML frontmatter"
    fi
done

echo "? Estructura de docs validada"
```

## Best Practices IACT

### 1. Scripts Primero, CI/CD Despu?s

**CORRECTO** ?:
```bash
# Local primero
./scripts/run_all_tests.sh

# Si funciona local, agregar a CI/CD
```

**INCORRECTO** ?:
```yaml
# Solo en GitHub Actions, no funciona local
```

### 2. MySQL para Todo

**CORRECTO** ?:
```python
# settings.py
SESSION_ENGINE = 'django.contrib.sessions.backends.db'  # MySQL
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.db.DatabaseCache',  # MySQL
        'LOCATION': 'cache_table',
    }
}
```

**INCORRECTO** ?:
```python
SESSION_ENGINE = 'django.contrib.sessions.backends.cache'  # Redis ?
CACHES = { 'default': { 'BACKEND': 'django_redis...' } }  # Redis ?
```

### 3. Buz?n Interno, No Email

**CORRECTO** ?:
```python
# Notificar via InternalMessage
InternalMessage.objects.create(
    user=request_user,
    subject="Analytics Request Complete",
    body="Your dashboard is ready: /analytics/dashboard/123"
)
```

**INCORRECTO** ?:
```python
send_mail(  # ? EMAIL PROHIBIDO
    "Request Complete",
    "...",
    "noreply@iact.com",
    [user.email]
)
```

### 4. Shell Scripts Portables

```bash
#!/bin/bash
# Usar set -e para exit on error
set -e

# Detectar PROJECT_ROOT din?micamente
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

# Variables de entorno con defaults
DB_HOST=${DB_HOST:-localhost}
DB_USER=${DB_USER:-iact}

# Validar prerequisites
command -v python >/dev/null 2>&1 || { echo "Python requerido"; exit 1; }
```

## Roadmap de Automatizaci?n

### Fase 1: Scripts Locales (COMPLETADO)
- [x] validate_critical_restrictions.sh
- [x] validate_security_config.sh
- [x] validate_database_router.sh
- [x] validar_estructura_docs.sh

### Fase 2: Testing y Deploy (EN PROGRESO)
- [ ] run_all_tests.sh (test completo local)
- [ ] deploy.sh (deploy automatizado con validaci?n)
- [ ] health_check.sh (monitoring continuo)
- [ ] cleanup_sessions.sh (maintenance MySQL)

### Fase 3: Analytics Service Management (PR?XIMO)
- [ ] analytics_portal_setup.sh
- [ ] process_analytics_request.sh
- [ ] triage_analytics_requests.sh
- [ ] generate_analytics_reports.sh

### Fase 4: M?tricas y Observability (FUTURO)
- [ ] dora_report.sh (m?tricas DORA locales)
- [ ] performance_baseline.sh
- [ ] capacity_planning.sh
- [ ] incident_postmortem.sh

## Checklist de Deployment

```bash
# Pre-Deploy Checklist
[ ] ./scripts/validate_critical_restrictions.sh  # NO Redis, NO email
[ ] ./scripts/run_all_tests.sh                   # Coverage > 80%
[ ] ./scripts/validate_security_config.sh         # Security OK
[ ] mysqldump backup created                      # Rollback ready
[ ] python manage.py check --deploy              # Django checks

# Deploy
[ ] python manage.py migrate                     # DB migrations
[ ] python manage.py collectstatic               # Static files
[ ] systemctl restart services                   # Restart
[ ] ./scripts/health_check.sh                    # Health OK

# Post-Deploy
[ ] Monitoring 5 minutes                         # No errors
[ ] Check django_session table                   # Sessions OK (MySQL)
[ ] Notify team via InternalMessage              # NO email
[ ] Document in deployment log                   # Audit trail
```

## Referencias

- **Proceso SDLC**: `docs/gobernanza/procesos/SDLC_PROCESS.md`
- **Restricciones**: `docs/backend/requisitos/restricciones_y_lineamientos.md`
- **RNF-002**: NO Redis - Sesiones en MySQL
- **Scripts**: `scripts/*.sh`
- **DORA Calculator**: `scripts/dora_metrics.py`

---

**?ltima actualizaci?n**: 2025-11-06
**Versi?n**: 2.0
**Mantenedor**: @devops-lead
**Cambios v2.0**: Enfoque en shell scripts, eliminado Redis, agregado Analytics Service Management
