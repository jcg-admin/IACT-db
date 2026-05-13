---
id: PROCED-BACK-002
tipo: procedimiento
categoria: deployment
titulo: Procedimiento de Deployment a Staging
version: 1.0.0
fecha_creacion: 2025-11-18
fecha_actualizacion: 2025-11-18
estado: activo
responsable: Equipo DevOps / Backend
frecuencia: por_demanda
---

# PROCED-BACK-002: Deployment a Staging

**ID:** PROCED-BACK-002
**Version:** 1.0.0
**Fecha:** 2025-11-18
**Categoria:** Deployment / Staging / CI/CD

---

## 1. PROPOSITO

### 1.1 Objetivo
Establecer un procedimiento sistematico y seguro para realizar deployment de la aplicacion backend al ambiente de staging, garantizando que los cambios sean validados antes de llegar a produccion.

### 1.2 Problemas que Resuelve
- Deployments inconsistentes entre ambientes
- Falta de validacion pre-produccion
- Configuraciones incorrectas en staging
- Downtime no planificado
- Falta de trazabilidad de deployments
- Rollbacks complejos por falta de procedimiento

### 1.3 Beneficios Esperados
- Proceso de deployment predecible y repetible
- Deteccion de problemas antes de produccion
- Reduccion de downtime a menos de 2 minutos
- Trazabilidad completa de cambios deployados
- Capacidad de rollback rapido (< 5 minutos)

---

## 2. ALCANCE

### 2.1 Incluye
- Deployment de codigo backend Django
- Ejecucion de migraciones de base de datos
- Actualizacion de archivos estaticos
- Reinicio de servicios (gunicorn, celery)
- Validacion post-deployment
- Generacion de reporte de deployment
- Notificacion a stakeholders

### 2.2 Excluye
- Deployment a produccion (ver PROCED-BACK-005)
- Deployment de frontend (ver PROCED-FRONT-002)
- Cambios de infraestructura (ver PROCED-DEVOPS-001)
- Actualizacion de versiones mayores de Python/Django
- Migraciones destructivas de datos

### 2.3 Frecuencia de Ejecucion
- **Regular:** 2-3 veces por semana
- **Ad-hoc:** Cuando hay features listas para validacion
- **Hotfix:** Segun necesidad critica
- **Pre-Release:** Antes de cada deployment a produccion

---

## 3. ROLES Y RESPONSABILIDADES

### 3.1 Matriz RACI

| Actividad | DevOps | Desarrollador | QA | Tech Lead | PO |
|-----------|--------|---------------|-----|-----------|-----|
| Preparar deployment | R | C | I | I | I |
| Ejecutar deployment | R | C | I | I | I |
| Ejecutar migraciones | R | C | I | C | I |
| Validar deployment | C | R | A | C | I |
| Ejecutar smoke tests | I | C | R | I | I |
| Aprobar para QA | I | I | A | C | C |
| Notificar stakeholders | C | I | I | R | A |

**Leyenda:**
- R: Responsable de ejecutar
- A: Aprobador final
- C: Consultado durante proceso
- I: Informado de resultados

### 3.2 Perfiles Requeridos

**DevOps Engineer:**
- Acceso SSH a servidor staging
- Conocimiento de Docker/Kubernetes
- Experiencia con deployment automation
- Capacidad de troubleshooting rapido

**Desarrollador Backend:**
- Conocimiento de migraciones Django
- Familiaridad con arquitectura de la aplicacion
- Capacidad de validacion funcional

---

## 4. PREREQUISITOS

### 4.1 Tecnicos
- [ ] Codigo mergeado a rama staging
- [ ] Tests CI/CD pasando exitosamente
- [ ] Migraciones validadas localmente
- [ ] Variables de entorno configuradas
- [ ] Acceso SSH a servidor staging
- [ ] VPN conectada (si aplica)
- [ ] Base de datos staging respaldada

### 4.2 Organizacionales
- [ ] Aprobacion de Tech Lead para deployment
- [ ] No hay deployments concurrentes en progreso
- [ ] Equipo QA notificado y disponible
- [ ] Ventana de deployment reservada
- [ ] Plan de rollback revisado

### 4.3 Conocimientos
- [ ] Django deployment workflow
- [ ] Docker compose / Kubernetes
- [ ] Nginx / Gunicorn configuration
- [ ] Database migrations
- [ ] Git flow y branching strategy

---

## 5. PROCEDIMIENTO DETALLADO

### ETAPA 1: PREPARACION PRE-DEPLOYMENT (15 minutos)

#### Paso 1.1: Verificar Estado del Codigo
```bash
# Conectar al servidor staging
ssh staging-server

# Verificar rama actual
cd /var/www/iact-backend
git branch

# Verificar ultimos commits
git log --oneline -5
```

**Criterio de Exito:** Rama staging identificada y actualizada

#### Paso 1.2: Crear Backup de Base de Datos
```bash
# Crear backup de base de datos staging
pg_dump -h localhost -U iact_user -d iact_staging > /backups/iact_staging_$(date +%Y%m%d_%H%M%S).sql

# Verificar que backup se creo correctamente
ls -lh /backups/ | tail -1
```

**CRITICO:** No continuar sin backup exitoso

**Criterio de Exito:** Archivo de backup creado con tamano > 0 bytes

#### Paso 1.3: Verificar Servicios Actuales
```bash
# Verificar estado de servicios
sudo systemctl status gunicorn
sudo systemctl status celery
sudo systemctl status nginx

# Verificar procesos en ejecucion
ps aux | grep -E 'gunicorn|celery'
```

**Criterio de Exito:** Todos los servicios running

#### Paso 1.4: Crear Tag de Deployment
```bash
# Crear tag para tracking
git tag -a staging-deploy-$(date +%Y%m%d-%H%M) -m "Deployment staging $(date +%Y-%m-%d)"

# Push tag a remoto
git push origin staging-deploy-$(date +%Y%m%d-%H%M)
```

**Criterio de Exito:** Tag creado y pushed exitosamente

---

### ETAPA 2: ACTUALIZACION DE CODIGO (10 minutos)

#### Paso 2.1: Detener Servicios
```bash
# Detener gunicorn
sudo systemctl stop gunicorn

# Detener celery workers
sudo systemctl stop celery

# Verificar que se detuvieron
ps aux | grep -E 'gunicorn|celery'
```

**Criterio de Exito:** Ningun proceso gunicorn/celery activo

#### Paso 2.2: Pull de Cambios
```bash
# Actualizar codigo desde staging branch
cd /var/www/iact-backend
git fetch origin
git checkout staging
git pull origin staging

# Verificar que pull fue exitoso
git log -1 --oneline
```

**Criterio de Exito:** Codigo actualizado sin conflictos

#### Paso 2.3: Activar Entorno Virtual
```bash
# Activar virtualenv
source /var/www/iact-backend/venv/bin/activate

# Verificar que esta activo
which python
```

**Criterio de Exito:** Entorno virtual activo

#### Paso 2.4: Actualizar Dependencias
```bash
# Actualizar pip
pip install --upgrade pip

# Instalar/actualizar dependencias
pip install -r requirements.txt

# Verificar instalacion
pip list | grep -E 'Django|djangorestframework|celery'
```

**Criterio de Exito:** Dependencias actualizadas sin errores

---

### ETAPA 3: MIGRACIONES Y CONFIGURACION (15 minutos)

#### Paso 3.1: Verificar Migraciones Pendientes
```bash
# Verificar migraciones pendientes
python manage.py showmigrations | grep "\[ \]"

# Hacer dry-run de migraciones
python manage.py migrate --plan
```

**Criterio de Exito:** Lista de migraciones a aplicar identificada

#### Paso 3.2: Ejecutar Migraciones
```bash
# Aplicar migraciones
python manage.py migrate --noinput

# Verificar resultado
echo $?
# Debe ser 0 (exitoso)
```

**Criterio de Exito:** Migraciones aplicadas exitosamente

#### Paso 3.3: Recolectar Archivos Estaticos
```bash
# Limpiar estaticos antiguos
rm -rf /var/www/iact-backend/staticfiles/*

# Recolectar nuevos estaticos
python manage.py collectstatic --noinput

# Verificar que se copiaron
ls -lh /var/www/iact-backend/staticfiles/
```

**Criterio de Exito:** Archivos estaticos actualizados

#### Paso 3.4: Verificar Configuracion
```bash
# Verificar settings
python manage.py check --deploy

# Verificar variables de entorno criticas
printenv | grep -E 'DJANGO_SETTINGS_MODULE|DATABASE_URL|REDIS_URL'
```

**Criterio de Exito:** Check pasa sin errores criticos

---

### ETAPA 4: REINICIO DE SERVICIOS (10 minutos)

#### Paso 4.1: Reiniciar Gunicorn
```bash
# Reiniciar gunicorn
sudo systemctl start gunicorn

# Esperar 5 segundos
sleep 5

# Verificar estado
sudo systemctl status gunicorn
```

**Criterio de Exito:** Gunicorn activo y running

#### Paso 4.2: Reiniciar Celery
```bash
# Reiniciar celery workers
sudo systemctl start celery

# Verificar estado
sudo systemctl status celery

# Verificar logs
sudo journalctl -u celery -n 20
```

**Criterio de Exito:** Celery workers activos

#### Paso 4.3: Reiniciar Nginx
```bash
# Verificar configuracion nginx
sudo nginx -t

# Reload nginx (sin downtime)
sudo systemctl reload nginx

# Verificar estado
sudo systemctl status nginx
```

**Criterio de Exito:** Nginx recargado exitosamente

#### Paso 4.4: Verificar Conectividad
```bash
# Hacer curl a health check endpoint
curl -f http://localhost:8000/api/health/

# Verificar respuesta
# Debe retornar HTTP 200
```

**Criterio de Exito:** Health check responde HTTP 200

---

### ETAPA 5: VALIDACION POST-DEPLOYMENT (20 minutos)

#### Paso 5.1: Smoke Tests Automatizados
```bash
# Ejecutar smoke tests
pytest tests/smoke/ -v

# Verificar endpoints criticos
curl -f https://staging.iact.example.com/api/v1/status/
curl -f https://staging.iact.example.com/api/v1/auth/health/
```

**Criterio de Exito:** Todos los smoke tests pasan

#### Paso 5.2: Validacion de Base de Datos
```bash
# Verificar conexion a DB
python manage.py dbshell -c "SELECT version();"

# Verificar migraciones aplicadas
python manage.py showmigrations | grep "\[X\]" | wc -l

# Verificar integridad de datos criticos
python manage.py shell <<EOF
from apps.permissions.models import Permission
print(f"Total permissions: {Permission.objects.count()}")
EOF
```

**Criterio de Exito:** Base de datos accesible y consistente

#### Paso 5.3: Validacion de Logs
```bash
# Revisar logs de gunicorn
sudo tail -50 /var/log/gunicorn/error.log | grep -i error

# Revisar logs de celery
sudo tail -50 /var/log/celery/worker.log | grep -i error

# Revisar logs de nginx
sudo tail -50 /var/log/nginx/error.log
```

**Criterio de Exito:** Sin errores criticos en logs

#### Paso 5.4: Validacion Funcional Manual
Verificar funcionalidades criticas:
- [ ] Login de usuario funcional
- [ ] APIs principales responden
- [ ] Panel de admin accesible
- [ ] Tareas de celery se ejecutan
- [ ] Endpoints de permisos funcionales

**Criterio de Exito:** Todas las funcionalidades criticas operando

---

### ETAPA 6: DOCUMENTACION Y NOTIFICACION (10 minutos)

#### Paso 6.1: Generar Reporte de Deployment
Crear documento:
```
docs/backend/deployment/DEPLOY-STAGING-YYYY-MM-DD-HHMM.md
```

**Contenido minimo:**
```markdown
# Deployment Staging - YYYY-MM-DD HH:MM

## Informacion General
- Fecha: YYYY-MM-DD HH:MM
- Version deployada: vX.Y.Z
- Tag: staging-deploy-YYYYMMDD-HHMM
- Ejecutado por: [Nombre]

## Cambios Deployados
- [Lista de commits/PRs incluidos]

## Migraciones Aplicadas
- [Lista de migraciones]

## Resultados
- Tiempo total: XX minutos
- Downtime: XX segundos
- Tests: PASS/FAIL
- Estado: SUCCESS/ROLLBACK

## Problemas Encontrados
- [Ninguno / Descripcion]

## Validaciones
- [ ] Health check OK
- [ ] Smoke tests OK
- [ ] Logs OK
- [ ] Funcionalidad critica OK
```

**Artefacto:** DEPLOY-STAGING-YYYY-MM-DD-HHMM.md

#### Paso 6.2: Actualizar Changelog
```bash
# Agregar entrada a CHANGELOG.md
echo "## [Staging] $(date +%Y-%m-%d)" >> CHANGELOG.md
git log --oneline staging-deploy-last..HEAD >> CHANGELOG.md
```

**Criterio de Exito:** Changelog actualizado

#### Paso 6.3: Notificar a Stakeholders
Enviar notificacion a:
- Canal Slack #deployments
- Equipo QA (para iniciar testing)
- Tech Lead (confirmacion)
- Product Owner (para validacion funcional)

**Template de notificacion:**
```
Deployment a STAGING completado
Fecha: YYYY-MM-DD HH:MM
Version: vX.Y.Z
Estado: SUCCESS
Validacion: PENDING QA
URL: https://staging.iact.example.com
Reporte: [link]
```

---

## 6. ARTEFACTOS GENERADOS

### 6.1 Archivos de Deployment

| Archivo | Ubicacion | Proposito |
|---------|-----------|-----------|
| Backup de DB | /backups/iact_staging_YYYYMMDD.sql | Rollback |
| Tag Git | staging-deploy-YYYYMMDD-HHMM | Tracking |
| Reporte | docs/backend/deployment/DEPLOY-STAGING-*.md | Documentacion |
| Changelog | CHANGELOG.md | Historial |

### 6.2 Logs de Deployment
- /var/log/deployment/staging-YYYYMMDD-HHMM.log
- /var/log/gunicorn/error.log
- /var/log/celery/worker.log

---

## 7. CRITERIOS DE EXITO

### 7.1 Cuantitativos
- [ ] Deployment completado en < 60 minutos
- [ ] Downtime < 2 minutos
- [ ] 100% smoke tests pasando
- [ ] 0 errores criticos en logs
- [ ] Health check responde en < 500ms

### 7.2 Cualitativos
- [ ] Servicios estables post-deployment
- [ ] Funcionalidades criticas operativas
- [ ] Base de datos consistente
- [ ] Equipo QA puede iniciar testing
- [ ] Rollback disponible si necesario

### 7.3 Metricas de Calidad
- [ ] Backup de DB creado exitosamente
- [ ] Tag de deployment creado
- [ ] Reporte documentado
- [ ] Stakeholders notificados

---

## 8. VALIDACION POST-DEPLOYMENT

### 8.1 Checklist de Validacion Tecnica
```bash
# Script de validacion automatica
#!/bin/bash
echo "=== Validacion Post-Deployment ==="

# 1. Health check
curl -f https://staging.iact.example.com/api/health/ || exit 1

# 2. Servicios activos
systemctl is-active gunicorn || exit 1
systemctl is-active celery || exit 1
systemctl is-active nginx || exit 1

# 3. Base de datos
python manage.py dbshell -c "SELECT 1;" || exit 1

# 4. Migraciones
python manage.py showmigrations | grep "\[ \]" && exit 1

echo "=== Validacion Exitosa ==="
```

### 8.2 Checklist de Validacion Funcional
- [ ] Login/logout funcional
- [ ] CRUD de recursos principales
- [ ] APIs respondiendo correctamente
- [ ] Panel admin accesible
- [ ] Tareas async ejecutandose

---

## 9. ROLLBACK

### 9.1 Si Deployment Falla Durante Ejecucion

**Accion Inmediata:**
```bash
# 1. Detener servicios
sudo systemctl stop gunicorn celery

# 2. Volver a version anterior
git checkout staging-deploy-[TAG-ANTERIOR]

# 3. Restaurar backup de DB (si migraciones se aplicaron)
psql -h localhost -U iact_user -d iact_staging < /backups/iact_staging_[BACKUP].sql

# 4. Reinstalar dependencias anteriores
pip install -r requirements.txt

# 5. Reiniciar servicios
sudo systemctl start gunicorn celery

# 6. Validar
curl -f http://localhost:8000/api/health/
```

**Tiempo estimado de rollback: 5-10 minutos**

### 9.2 Si Problemas Detectados Post-Deployment
```bash
# Ejecutar PROCED-BACK-003 (Rollback Deployment)
# Ver procedimiento completo en ese documento
```

### 9.3 Notificacion de Rollback
Comunicar inmediatamente:
- Razon del rollback
- Version restaurada
- Impacto en testing
- Plan de re-deployment

---

## 10. RIESGOS Y MITIGACIONES

### 10.1 Riesgos Tecnicos

| Riesgo | Probabilidad | Impacto | Mitigacion | Plan Contingencia |
|--------|-------------|---------|-----------|-------------------|
| Migracion destructiva falla | MEDIA | CRITICO | Dry-run + backup obligatorio | Restaurar desde backup |
| Dependencias incompatibles | BAJA | ALTO | Testing en ambiente local | Rollback inmediato |
| Servicios no reinician | BAJA | ALTO | Scripts de healthcheck | Restart manual + debug |
| Timeout en deployment | BAJA | MEDIO | Ventana de tiempo adecuada | Completar en siguiente ventana |
| Disco lleno en servidor | BAJA | CRITICO | Monitoreo de espacio | Limpiar logs/backups antiguos |

### 10.2 Riesgos Operacionales

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Deployment concurrente | BAJA | ALTO | Lock de deployment |
| Falta de backup | BAJA | CRITICO | Checklist obligatorio |
| Falta de acceso SSH | BAJA | ALTO | Validar accesos pre-deployment |
| QA no disponible | MEDIA | MEDIO | Coordinar horarios |

---

## 11. MEJORES PRACTICAS

### 11.1 Antes de Deployment
1. Ejecutar tests localmente (PROCED-BACK-001)
2. Revisar commits incluidos en deployment
3. Validar migraciones en DB local
4. Coordinar con QA y stakeholders
5. Verificar accesos y permisos

### 11.2 Durante Deployment
1. Seguir procedimiento paso a paso
2. No omitir backup de base de datos
3. Documentar cualquier desviacion
4. Capturar logs en caso de error
5. Mantener comunicacion con equipo

### 11.3 Despues de Deployment
1. Esperar confirmacion de QA antes de cerrar
2. Monitorear logs por 30 minutos
3. Mantener tag de backup 7 dias
4. Actualizar documentacion
5. Programar limpieza de backups antiguos

---

## 12. HERRAMIENTAS Y REFERENCIAS

### 12.1 Herramientas Requeridas
- SSH client
- Git 2.x+
- PostgreSQL client
- curl / wget
- systemctl
- Docker / Docker Compose (si aplica)

### 12.2 Scripts de Automatizacion
```bash
# /scripts/deploy-staging.sh
#!/bin/bash
set -e

# Wrapper script para deployment
# [Contenido del script de automatizacion]
```

### 12.3 Documentos Relacionados
- PROCED-BACK-001: Ejecutar Tests Backend
- PROCED-BACK-003: Rollback Deployment
- PROCED-BACK-004: Actualizar Dependencias
- docs/backend/deployment/README.md

### 12.4 Endpoints de Monitoreo
- Health: https://staging.iact.example.com/api/health/
- Status: https://staging.iact.example.com/api/status/
- Metrics: https://staging.iact.example.com/api/metrics/

---

## 13. CONTROL DE CAMBIOS

### Version 1.0.0 (2025-11-18)
- Creacion inicial del procedimiento
- Basado en mejores practicas Django deployment
- Incluye 6 etapas definidas
- Tiempo estimado total: 80 minutos

### Proximas Versiones
- v1.1.0: Automatizacion completa con scripts
- v1.2.0: Integracion con GitHub Actions
- v2.0.0: Blue-green deployment

---

## 14. APROBACIONES

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| Autor | Equipo DevOps | ________ | 2025-11-18 |
| Revisor Tecnico | [Pendiente] | ________ | YYYY-MM-DD |
| Aprobador | Tech Lead | ________ | YYYY-MM-DD |

---

## 15. ANEXOS

### Anexo A: Checklist Rapido

**Pre-Deployment:**
- [ ] Codigo mergeado a staging
- [ ] Tests CI/CD pasando
- [ ] Aprobaciones obtenidas
- [ ] Equipo notificado

**Deployment:**
- [ ] Backup de DB creado
- [ ] Servicios detenidos
- [ ] Codigo actualizado
- [ ] Migraciones aplicadas
- [ ] Servicios reiniciados

**Post-Deployment:**
- [ ] Smoke tests OK
- [ ] Validacion funcional OK
- [ ] Logs revisados
- [ ] Reporte creado
- [ ] Stakeholders notificados

### Anexo B: Tiempo Estimado por Etapa

| Etapa | Tiempo | Acumulado |
|-------|--------|-----------|
| Preparacion | 15 min | 15 min |
| Actualizacion codigo | 10 min | 25 min |
| Migraciones | 15 min | 40 min |
| Reinicio servicios | 10 min | 50 min |
| Validacion | 20 min | 70 min |
| Documentacion | 10 min | 80 min |

**Tiempo total estimado: 80 minutos**
**Con automatizacion: 30-40 minutos**

### Anexo C: Contacts de Emergencia
- DevOps Lead: [email/slack]
- Tech Lead: [email/slack]
- Database Admin: [email/slack]
- On-call Engineer: [telefono]

---

**Procedimiento creado:** 2025-11-18
**Ultima revision:** 2025-11-18
**Proxima revision programada:** 2026-02-18 (3 meses)
**Estado:** ACTIVO
**Version:** 1.0.0
