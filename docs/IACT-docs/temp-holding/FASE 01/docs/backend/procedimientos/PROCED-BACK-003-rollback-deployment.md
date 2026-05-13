---
id: PROCED-BACK-003
tipo: procedimiento
categoria: deployment
titulo: Procedimiento de Rollback de Deployment
version: 1.0.0
fecha_creacion: 2025-11-18
fecha_actualizacion: 2025-11-18
estado: activo
responsable: Equipo DevOps / Backend
frecuencia: por_incidente
---

# PROCED-BACK-003: Rollback de Deployment

**ID:** PROCED-BACK-003
**Version:** 1.0.0
**Fecha:** 2025-11-18
**Categoria:** Deployment / Rollback / Recovery

---

## 1. PROPOSITO

### 1.1 Objetivo
Establecer un procedimiento de emergencia rapido y seguro para revertir un deployment defectuoso al ultimo estado estable conocido, minimizando el impacto en usuarios y servicios.

### 1.2 Problemas que Resuelve
- Deployment defectuoso en staging o produccion
- Funcionalidades criticas no operativas
- Errores criticos detectados post-deployment
- Migraciones de base de datos fallidas
- Incompatibilidades de dependencias
- Corrupcion de datos por deployment incorrecto

### 1.3 Beneficios Esperados
- Restauracion rapida de servicio (< 10 minutos)
- Minimizacion de impacto en usuarios
- Proceso de rollback predecible y probado
- Reduccion de tiempo de downtime
- Preservacion de integridad de datos

---

## 2. ALCANCE

### 2.1 Incluye
- Rollback de codigo a version anterior
- Restauracion de base de datos desde backup
- Reversion de archivos estaticos
- Reinicio de servicios
- Validacion post-rollback
- Documentacion de incidente
- Notificacion a stakeholders

### 2.2 Excluye
- Rollback de infraestructura (ver PROCED-DEVOPS-003)
- Recuperacion de desastres completos
- Migracion de datos entre versiones
- Rollback de datos de usuario (requiere aprobacion)
- Cambios de DNS o load balancers

### 2.3 Cuando Ejecutar
- **Critico:** Servicio completamente caido
- **Alto:** Funcionalidad critica no operativa
- **Medio:** Errores afectando >50% de usuarios
- **Preventivo:** Tests post-deployment fallando masivamente

---

## 3. ROLES Y RESPONSABILIDADES

### 3.1 Matriz RACI

| Actividad | DevOps | Desarrollador | Tech Lead | DBA | Incident Manager |
|-----------|--------|---------------|-----------|-----|-----------------|
| Declarar necesidad de rollback | I | C | A | I | R |
| Ejecutar rollback | R | C | C | C | I |
| Restaurar base de datos | C | I | C | R | I |
| Validar rollback | C | R | A | C | I |
| Investigar causa raiz | I | R | C | I | A |
| Documentar incidente | C | C | R | I | A |

**Leyenda:**
- R: Responsable de ejecutar
- A: Aprobador final
- C: Consultado durante proceso
- I: Informado de resultados

### 3.2 Perfiles Requeridos

**DevOps Engineer:**
- Acceso completo a servidores
- Experiencia en rollback procedures
- Capacidad de decision bajo presion
- Conocimiento de arquitectura del sistema

**DBA (Database Administrator):**
- Acceso a backups de base de datos
- Experiencia en restauracion rapida
- Conocimiento de replicacion y consistencia

---

## 4. PREREQUISITOS

### 4.1 Tecnicos
- [ ] Backups de base de datos disponibles (< 24h)
- [ ] Tags Git de deployment identificados
- [ ] Acceso SSH a servidores
- [ ] Acceso a sistema de backups
- [ ] Credentials de base de datos
- [ ] VPN activa (si aplica)

### 4.2 Organizacionales
- [ ] Aprobacion de Tech Lead o Incident Manager
- [ ] Stakeholders criticos notificados
- [ ] Canal de comunicacion activo (#incidents)
- [ ] Equipo de rollback disponible

### 4.3 Conocimientos
- [ ] Arquitectura del sistema
- [ ] Proceso de deployment normal
- [ ] Comandos Git para rollback
- [ ] Restauracion de base de datos PostgreSQL
- [ ] Systemd / Docker commands

---

## 5. PROCEDIMIENTO DETALLADO

### ETAPA 1: EVALUACION Y DECISION (5 minutos)

#### Paso 1.1: Confirmar Necesidad de Rollback
**Criterios para rollback inmediato:**
- [ ] Servicio completamente caido (HTTP 500/503)
- [ ] Errores criticos en logs (rate > 100/min)
- [ ] Base de datos inaccesible o corrupta
- [ ] Perdida de datos detectada
- [ ] Funcionalidad critica no responde

**Documentar:**
```markdown
## Incidente: YYYY-MM-DD-HHMM
- Sintomas observados: [descripcion]
- Severidad: CRITICO|ALTO|MEDIO
- Impacto: [usuarios/funcionalidades afectadas]
- Decision: ROLLBACK APROBADO por [nombre]
```

#### Paso 1.2: Identificar Version Objetivo
```bash
# Listar tags recientes
git tag --sort=-creatordate | head -10

# Identificar ultimo deployment estable
# Ejemplo: staging-deploy-20251117-1430
TARGET_TAG="staging-deploy-20251117-1430"
```

**Criterio de Exito:** Tag de version estable identificado

#### Paso 1.3: Verificar Backup Disponible
```bash
# Listar backups disponibles
ls -lth /backups/iact_staging_*.sql | head -5

# Identificar backup correspondiente a version estable
BACKUP_FILE="/backups/iact_staging_20251117_1430.sql"

# Verificar integridad del backup
test -f $BACKUP_FILE && echo "Backup OK" || echo "Backup NOT FOUND"
```

**CRITICO:** Si no hay backup valido, escalar a Tech Lead

**Criterio de Exito:** Backup identificado y verificado

#### Paso 1.4: Notificar Inicio de Rollback
**Comunicar en canal #incidents:**
```
ROLLBACK INICIADO - STAGING
Hora: [HH:MM]
Razon: [descripcion breve]
Version objetivo: [tag]
ETA: 10 minutos
Ejecutado por: [nombre]
```

---

### ETAPA 2: DETENCION DE SERVICIOS (2 minutos)

#### Paso 2.1: Conectar a Servidor
```bash
# Conectar via SSH
ssh staging-server

# Cambiar a directorio de aplicacion
cd /var/www/iact-backend
```

**Criterio de Exito:** Conexion SSH establecida

#### Paso 2.2: Detener Servicios de Aplicacion
```bash
# Detener gunicorn
sudo systemctl stop gunicorn

# Detener celery workers
sudo systemctl stop celery

# Verificar que se detuvieron
ps aux | grep -E 'gunicorn|celery' | grep -v grep
```

**Criterio de Exito:** No hay procesos gunicorn/celery activos

#### Paso 2.3: Poner Pagina de Mantenimiento (Opcional)
```bash
# Activar pagina de mantenimiento en nginx
sudo cp /etc/nginx/maintenance.html.template /usr/share/nginx/html/maintenance.html
sudo systemctl reload nginx
```

**Criterio de Exito:** Pagina de mantenimiento activa

---

### ETAPA 3: ROLLBACK DE CODIGO (3 minutos)

#### Paso 3.1: Revertir a Version Anterior
```bash
# Activar entorno virtual
source /var/www/iact-backend/venv/bin/activate

# Checkout a tag estable
git fetch --tags
git checkout $TARGET_TAG

# Verificar version
git log -1 --oneline
```

**Criterio de Exito:** Codigo revertido a version estable

#### Paso 3.2: Restaurar Dependencias
```bash
# Reinstalar dependencias de version anterior
pip install --force-reinstall -r requirements.txt

# Verificar versiones criticas
pip show Django djangorestframework celery
```

**Criterio de Exito:** Dependencias correctas instaladas

#### Paso 3.3: Restaurar Archivos Estaticos
```bash
# Limpiar estaticos actuales
rm -rf /var/www/iact-backend/staticfiles/*

# Recolectar estaticos de version anterior
python manage.py collectstatic --noinput

# Verificar
ls -lh /var/www/iact-backend/staticfiles/
```

**Criterio de Exito:** Archivos estaticos restaurados

---

### ETAPA 4: ROLLBACK DE BASE DE DATOS (10 minutos)

**ADVERTENCIA:** Esta es la etapa mas critica. Ejecutar con cuidado.

#### Paso 4.1: Crear Backup de Estado Actual (Por Seguridad)
```bash
# Backup del estado actual (por si rollback falla)
pg_dump -h localhost -U iact_user -d iact_staging > /backups/pre_rollback_$(date +%Y%m%d_%H%M%S).sql

# Verificar
ls -lh /backups/pre_rollback_*.sql | tail -1
```

**Criterio de Exito:** Backup de seguridad creado

#### Paso 4.2: Verificar Conexiones Activas
```bash
# Terminar conexiones activas a la base de datos
psql -h localhost -U iact_user -d postgres -c "
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'iact_staging' AND pid <> pg_backend_pid();
"
```

**Criterio de Exito:** Conexiones activas terminadas

#### Paso 4.3: Restaurar Base de Datos
```bash
# Eliminar base de datos actual
dropdb -h localhost -U iact_user iact_staging

# Crear base de datos limpia
createdb -h localhost -U iact_user iact_staging

# Restaurar desde backup
psql -h localhost -U iact_user -d iact_staging < $BACKUP_FILE

# Verificar restauracion
psql -h localhost -U iact_user -d iact_staging -c "SELECT COUNT(*) FROM django_migrations;"
```

**CRITICO:** Monitorear este paso de cerca. Si falla, usar backup de seguridad.

**Criterio de Exito:** Base de datos restaurada exitosamente

#### Paso 4.4: Verificar Migraciones
```bash
# Verificar estado de migraciones
python manage.py showmigrations

# Deben estar todas aplicadas [X] sin pendientes [ ]
```

**Criterio de Exito:** Migraciones consistentes con codigo

---

### ETAPA 5: REINICIO DE SERVICIOS (3 minutos)

#### Paso 5.1: Reiniciar Gunicorn
```bash
# Reiniciar gunicorn
sudo systemctl start gunicorn

# Esperar arranque
sleep 5

# Verificar estado
sudo systemctl status gunicorn

# Verificar logs
sudo tail -20 /var/log/gunicorn/error.log
```

**Criterio de Exito:** Gunicorn activo sin errores

#### Paso 5.2: Reiniciar Celery
```bash
# Reiniciar celery
sudo systemctl start celery

# Verificar estado
sudo systemctl status celery

# Verificar workers
celery -A config inspect active
```

**Criterio de Exito:** Celery workers activos

#### Paso 5.3: Desactivar Pagina de Mantenimiento
```bash
# Remover pagina de mantenimiento
sudo rm -f /usr/share/nginx/html/maintenance.html

# Reload nginx
sudo systemctl reload nginx
```

**Criterio de Exito:** Trafico normal restaurado

---

### ETAPA 6: VALIDACION POST-ROLLBACK (5 minutos)

#### Paso 6.1: Health Check
```bash
# Verificar health endpoint
curl -f http://localhost:8000/api/health/

# Debe retornar HTTP 200
```

**Criterio de Exito:** Health check responde correctamente

#### Paso 6.2: Smoke Tests
```bash
# Ejecutar smoke tests criticos
pytest tests/smoke/test_critical.py -v

# Verificar endpoints principales
curl -f https://staging.iact.example.com/api/v1/status/
curl -f https://staging.iact.example.com/api/v1/auth/health/
```

**Criterio de Exito:** Smoke tests pasan

#### Paso 6.3: Validacion de Funcionalidades Criticas
Verificar manualmente:
- [ ] Login de usuario funcional
- [ ] API principal responde
- [ ] Panel admin accesible
- [ ] Queries a base de datos exitosos
- [ ] Tareas celery ejecutandose

**Criterio de Exito:** Funcionalidades criticas operativas

#### Paso 6.4: Monitoreo de Logs
```bash
# Monitorear logs en tiempo real (2 minutos)
sudo tail -f /var/log/gunicorn/error.log &
sudo tail -f /var/log/celery/worker.log &

# Esperar y observar por errores
sleep 120

# Detener monitoring
killall tail
```

**Criterio de Exito:** Sin errores criticos en logs

---

### ETAPA 7: DOCUMENTACION Y CIERRE (10 minutos)

#### Paso 7.1: Crear Reporte de Rollback
Crear documento:
```
docs/backend/incidents/ROLLBACK-YYYY-MM-DD-HHMM.md
```

**Contenido minimo:**
```markdown
# Rollback Incident - YYYY-MM-DD HH:MM

## Informacion del Incidente
- Fecha/Hora inicio: YYYY-MM-DD HH:MM
- Fecha/Hora resolucion: YYYY-MM-DD HH:MM
- Duracion total: XX minutos
- Ambiente: STAGING|PRODUCTION
- Severidad: CRITICO|ALTO|MEDIO

## Causa del Rollback
[Descripcion detallada del problema]

## Versiones
- Version defectuosa: [tag/commit]
- Version restaurada: [tag/commit]
- Backup utilizado: [archivo]

## Timeline
- HH:MM - Problema detectado
- HH:MM - Rollback aprobado
- HH:MM - Servicios detenidos
- HH:MM - Codigo revertido
- HH:MM - DB restaurada
- HH:MM - Servicios reiniciados
- HH:MM - Validacion completada

## Impacto
- Usuarios afectados: [numero/porcentaje]
- Funcionalidades afectadas: [lista]
- Downtime total: XX minutos
- Datos perdidos: SI/NO [descripcion]

## Causa Raiz
[Analisis de causa raiz - puede completarse despues]

## Acciones Correctivas
- [ ] [Accion 1]
- [ ] [Accion 2]

## Lecciones Aprendidas
- [Leccion 1]
- [Leccion 2]
```

**Artefacto:** ROLLBACK-YYYY-MM-DD-HHMM.md

#### Paso 7.2: Notificar Resolucion
**Comunicar en canales apropiados:**
```
ROLLBACK COMPLETADO - STAGING
Hora finalizacion: [HH:MM]
Duracion: XX minutos
Version restaurada: [tag]
Estado actual: ESTABLE
Validacion: OK
Reporte: [link]
Proximos pasos: [investigacion causa raiz]
```

#### Paso 7.3: Actualizar Estado de Incidente
- Cerrar ticket de incidente (si aplica)
- Actualizar status page (si aplica)
- Notificar a Product Owner
- Programar post-mortem meeting

---

## 6. ARTEFACTOS GENERADOS

### 6.1 Documentos de Incidente

| Archivo | Ubicacion | Proposito |
|---------|-----------|-----------|
| Reporte de rollback | docs/backend/incidents/ROLLBACK-*.md | Documentacion |
| Backup pre-rollback | /backups/pre_rollback_*.sql | Seguridad |
| Logs de rollback | /var/log/rollback-YYYYMMDD-HHMM.log | Troubleshooting |

### 6.2 Evidencias
- Screenshots de errores
- Logs de aplicacion
- Metricas de monitoreo
- Timeline de acciones

---

## 7. CRITERIOS DE EXITO

### 7.1 Cuantitativos
- [ ] Rollback completado en < 15 minutos
- [ ] Downtime adicional < 5 minutos
- [ ] 100% funcionalidades criticas restauradas
- [ ] 0 errores criticos post-rollback
- [ ] 0 perdida de datos

### 7.2 Cualitativos
- [ ] Servicio estable post-rollback
- [ ] Usuarios pueden operar normalmente
- [ ] Equipo confia en estabilidad
- [ ] Causa raiz identificada
- [ ] Plan de re-deployment definido

### 7.3 Metricas de Calidad
- [ ] Reporte de incidente documentado
- [ ] Backups preservados
- [ ] Lecciones aprendidas capturadas
- [ ] Acciones correctivas definidas

---

## 8. VALIDACION POST-ROLLBACK

### 8.1 Checklist de Validacion Inmediata
- [ ] Health check HTTP 200
- [ ] Servicios activos (gunicorn, celery, nginx)
- [ ] Base de datos accesible
- [ ] Smoke tests pasan
- [ ] Sin errores en logs (ultimos 5 min)

### 8.2 Checklist de Validacion Extendida (30 min)
- [ ] Monitoreo estable (CPU, memoria, DB)
- [ ] Tareas celery ejecutandose
- [ ] APIs respondiendo en < 500ms
- [ ] Sin errores acumulandose en logs
- [ ] Feedback de usuarios positivo

### 8.3 Script de Validacion Automatica
```bash
#!/bin/bash
echo "=== Validacion Post-Rollback ==="

# 1. Health check
curl -f http://localhost:8000/api/health/ || exit 1

# 2. Servicios
systemctl is-active gunicorn || exit 1
systemctl is-active celery || exit 1

# 3. Base de datos
python manage.py dbshell -c "SELECT 1;" || exit 1

# 4. Smoke tests
pytest tests/smoke/ -q || exit 1

echo "=== Rollback Validado Exitosamente ==="
```

---

## 9. ROLLBACK DE ROLLBACK

### 9.1 Si Rollback Mismo Falla

**Escenario critico:** El rollback introdujo mas problemas

**Accion:**
```bash
# Usar backup de seguridad creado en Paso 4.1
psql -h localhost -U iact_user -d iact_staging < /backups/pre_rollback_[TIMESTAMP].sql

# Reiniciar servicios
sudo systemctl restart gunicorn celery

# Escalar a Tech Lead y DBA inmediatamente
```

### 9.2 Plan de Contingencia Ultima Instancia
1. Restaurar desde backup mas antiguo conocido estable
2. Reconstruir base de datos desde replicas
3. Contactar proveedor de hosting/cloud
4. Escalar a CTO/Director de Ingenieria

---

## 10. RIESGOS Y MITIGACIONES

### 10.1 Riesgos Tecnicos

| Riesgo | Probabilidad | Impacto | Mitigacion | Plan Contingencia |
|--------|-------------|---------|-----------|-------------------|
| Backup corrupto o incompleto | BAJA | CRITICO | Validar backups regularmente | Usar backup N-1 |
| Restauracion DB falla | BAJA | CRITICO | Backup de seguridad pre-rollback | Restaurar desde replicas |
| Servicios no reinician | MEDIA | ALTO | Scripts de healthcheck | Debug manual + restart |
| Perdida de datos recientes | MEDIA | CRITICO | Aceptado en rollback | Documentar y recuperar manual |
| Incompatibilidad codigo-DB | BAJA | ALTO | Validar migraciones | Ajustar manualmente |

### 10.2 Riesgos Operacionales

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Personal no disponible | BAJA | ALTO | On-call rotation definida |
| Falta de accesos | BAJA | CRITICO | Validar accesos preventivamente |
| Comunicacion inefectiva | MEDIA | MEDIO | Canal #incidents activo |
| Decision incorrecta de rollback | BAJA | MEDIO | Validacion con Tech Lead |

---

## 11. MEJORES PRACTICAS

### 11.1 Antes de Rollback
1. Confirmar con Tech Lead (excepto emergencia critica)
2. Verificar que backups estan disponibles
3. Notificar a stakeholders inmediatamente
4. Tener plan B listo
5. Documentar decision y razon

### 11.2 Durante Rollback
1. Seguir procedimiento estrictamente
2. No improvisar pasos
3. Documentar cada accion tomada
4. Mantener comunicacion constante
5. Validar cada etapa antes de continuar

### 11.3 Despues de Rollback
1. Validar exhaustivamente antes de declarar resuelto
2. Monitorear por 1 hora minimo
3. Documentar lecciones aprendidas
4. Programar post-mortem
5. Crear plan para re-deployment

---

## 12. HERRAMIENTAS Y REFERENCIAS

### 12.1 Herramientas Requeridas
- SSH client
- PostgreSQL client (psql, pg_dump, pg_restore)
- Git 2.x+
- systemctl
- curl / wget
- pytest (para smoke tests)

### 12.2 Scripts de Rollback
```bash
# /scripts/emergency-rollback.sh
#!/bin/bash
# Script de rollback automatizado
# [Contenido del script]
```

### 12.3 Documentos Relacionados
- PROCED-BACK-002: Deployment a Staging
- PROCED-BACK-005: Deployment a Produccion
- docs/backend/deployment/DISASTER-RECOVERY.md
- docs/backend/deployment/BACKUP-STRATEGY.md

### 12.4 Contactos de Emergencia
- Tech Lead: [telefono/slack]
- DBA: [telefono/slack]
- DevOps Lead: [telefono/slack]
- On-call Engineer: [telefono]
- CTO: [telefono] (solo emergencias criticas)

---

## 13. CONTROL DE CAMBIOS

### Version 1.0.0 (2025-11-18)
- Creacion inicial del procedimiento
- Basado en mejores practicas de incident response
- 7 etapas definidas
- Tiempo estimado: 15 minutos (rapido) a 30 minutos (completo)

### Proximas Versiones
- v1.1.0: Agregar rollback automatizado
- v1.2.0: Integracion con sistema de alertas
- v2.0.0: Blue-green deployment (sin rollback)

---

## 14. APROBACIONES

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| Autor | Equipo DevOps | ________ | 2025-11-18 |
| Revisor Tecnico | DBA Lead | ________ | YYYY-MM-DD |
| Aprobador | Tech Lead | ________ | YYYY-MM-DD |
| Aprobador | CTO | ________ | YYYY-MM-DD |

---

## 15. ANEXOS

### Anexo A: Checklist de Emergencia Rapida

**ROLLBACK RAPIDO (Critico):**
1. [ ] Detener servicios: `systemctl stop gunicorn celery`
2. [ ] Revertir codigo: `git checkout [TAG-ESTABLE]`
3. [ ] Restaurar DB: `psql ... < backup.sql`
4. [ ] Reinstalar deps: `pip install -r requirements.txt`
5. [ ] Iniciar servicios: `systemctl start gunicorn celery`
6. [ ] Validar: `curl localhost:8000/api/health/`
7. [ ] Notificar equipo

### Anexo B: Tiempo Estimado por Etapa

| Etapa | Tiempo | Acumulado |
|-------|--------|-----------|
| Evaluacion | 5 min | 5 min |
| Detencion servicios | 2 min | 7 min |
| Rollback codigo | 3 min | 10 min |
| Rollback DB | 10 min | 20 min |
| Reinicio servicios | 3 min | 23 min |
| Validacion | 5 min | 28 min |
| Documentacion | 10 min | 38 min |

**Tiempo total estimado: 30-40 minutos**
**Rollback rapido (sin DB): 10-15 minutos**

### Anexo C: Decision Tree

```
Problema detectado
    |
    +-- Critico (servicio caido)?
    |       YES --> Rollback inmediato
    |       NO --> Evaluar con Tech Lead
    |
    +-- Afecta a usuarios?
    |       YES --> Rollback si >10% usuarios
    |       NO --> Puede esperar fix
    |
    +-- Hay backup valido?
            YES --> Proceder con rollback
            NO --> Escalar a DBA/CTO
```

### Anexo D: Comandos Rapidos de Emergencia

```bash
# Ver ultimo deployment estable
git tag --sort=-creatordate | head -5

# Ver backups disponibles
ls -lth /backups/*.sql | head -5

# Detener todo
sudo systemctl stop gunicorn celery nginx

# Iniciar todo
sudo systemctl start gunicorn celery nginx

# Ver logs en vivo
sudo journalctl -u gunicorn -f

# Health check rapido
curl -I http://localhost:8000/api/health/
```

---

**Procedimiento creado:** 2025-11-18
**Ultima revision:** 2025-11-18
**Proxima revision programada:** 2026-01-18 (2 meses - critico)
**Estado:** ACTIVO
**Version:** 1.0.0
