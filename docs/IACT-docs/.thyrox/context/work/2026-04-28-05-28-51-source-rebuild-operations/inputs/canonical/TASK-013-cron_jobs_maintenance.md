---
id: TASK-013-cron-jobs-maintenance
tipo: documentacion_operaciones
categoria: operaciones
prioridad: P1
story_points: 2
estado: completado
fecha_inicio: 2025-11-07
fecha_fin: 2025-11-07
asignado: devops-lead
relacionados: ["TASK-011", "TASK-012"]
date: 2025-11-13
---

# TASK-013: Configuracion de Cron Jobs para Mantenimiento

Configuracion de cron jobs automatizados para tareas de mantenimiento del sistema IACT.

## Contexto

Para garantizar la salud y estabilidad del sistema, se requieren tareas de mantenimiento automatizadas:
- Limpieza de sesiones expiradas en MySQL
- Monitoreo continuo de salud del sistema
- Backups automatizados de datos criticos


## Técnicas de Prompt Engineering para Agente

Las siguientes técnicas deben aplicarse al ejecutar esta tarea con un agente:

1. **Tool-use Prompting** (knowledge_techniques.py)
   - Ejecutar comandos shell, cron jobs y scripts de automatizacion

2. **ReAct** (knowledge_techniques.py)
   - Razonar sobre el estado del sistema, actuar con comandos, reflexionar sobre resultados

3. **Simulation** (specialized_techniques.py)
   - Simular escenarios de operacion para validar configuraciones

4. **Task Decomposition** (structuring_techniques.py)
   - Dividir tareas operacionales en pasos ejecutables

5. **Expert Prompting** (specialized_techniques.py)
   - Aplicar conocimiento experto de DevOps y operaciones

Agente recomendado: PDCAAutomationAgent o SDLCPlannerAgent
## Objetivos

1. Configurar cron job para limpieza de sesiones cada 6 horas
2. Configurar cron job para health checks cada 5 minutos
3. Configurar cron job para backup diario a las 2 AM
4. Documentar configuracion y logs
5. Verificar ejecucion exitosa

## Scripts Utilizados

### 1. cleanup_sessions.sh

**Ubicacion:** `/home/user/IACT---project/scripts/cleanup_sessions.sh`

**Funcion:** Elimina sesiones expiradas de la tabla `django_session` en MySQL

**Caracteristicas:**
- Elimina solo sesiones expiradas (no afecta sesiones activas)
- Muestra estadisticas antes y despues
- Calcula espacio liberado
- Parametro `--force` para ejecucion automatica sin confirmacion
- Parametro `--days N` para ajustar retention

**Uso en cron:**
```bash
/home/user/IACT---project/scripts/cleanup_sessions.sh --force
```

### 2. health_check.sh

**Ubicacion:** `/home/user/IACT---project/scripts/health_check.sh`

**Funcion:** Verifica salud completa del sistema

**Validaciones:**
- Proyecto Django existe
- Dependencias Python instaladas (Django, psycopg2, MySQLdb)
- SESSION_ENGINE correcto (database, NO Redis) - RNF-002
- Conectividad PostgreSQL
- Conectividad MySQL
- Estado de migraciones
- Tamano de tabla django_session

**Uso en cron:**
```bash
/home/user/IACT---project/scripts/health_check.sh --json
```

### 3. backup_data_centralization.sh

**Ubicacion:** `/home/user/IACT---project/scripts/backup_data_centralization.sh`

**Funcion:** Backup automatizado de datos centralizados

**Componentes respaldados:**
- MySQL: Tabla `dora_metrics`
- JSON logs: `/var/log/iact/*.json.log`
- Cassandra: Snapshot (cuando este disponible)

**Retention:** 30 dias

**Uso en cron:**
```bash
MYSQL_PWD=<password> /home/user/IACT---project/scripts/backup_data_centralization.sh
```

## Configuracion de Crontab

### Instalacion

```bash
# 1. Abrir editor de crontab
crontab -e

# 2. Agregar las siguientes lineas
# (ver contenido en seccion siguiente)
```

### Entradas de Crontab

```cron
# ============================================================================
# IACT Project - Automated Maintenance Jobs
# ============================================================================

# Cleanup de sesiones expiradas - cada 6 horas
0 */6 * * * /home/user/IACT---project/scripts/cleanup_sessions.sh --force >> /var/log/iact/cleanup.log 2>&1

# Health check del sistema - cada 5 minutos
*/5 * * * * /home/user/IACT---project/scripts/health_check.sh --json >> /var/log/iact/health.log 2>&1

# Backup diario de datos centralizados - 2:00 AM
0 2 * * * MYSQL_PWD=${MYSQL_PASSWORD} /home/user/IACT---project/scripts/backup_data_centralization.sh >> /var/log/iact/backup.log 2>&1
```

### Explicacion de Sintaxis

**Formato cron:**
```
* * * * * comando
│ │ │ │ │
│ │ │ │ └─── Dia de la semana (0-7, 0 y 7 = domingo)
│ │ │ └───── Mes (1-12)
│ │ └─────── Dia del mes (1-31)
│ └───────── Hora (0-23)
└─────────── Minuto (0-59)
```

**Ejemplos:**
- `0 */6 * * *` - Cada 6 horas (00:00, 06:00, 12:00, 18:00)
- `*/5 * * * *` - Cada 5 minutos
- `0 2 * * *` - Diariamente a las 2:00 AM

## Logs

### Ubicacion de Logs

Todos los logs se almacenan en `/var/log/iact/`:

```bash
/var/log/iact/
├── cleanup.log      # Logs de cleanup_sessions.sh
├── health.log       # Logs de health_check.sh
└── backup.log       # Logs de backup_data_centralization.sh
```

### Crear Directorio de Logs

```bash
# Crear directorio si no existe
sudo mkdir -p /var/log/iact

# Asignar permisos
sudo chown $USER:$USER /var/log/iact
sudo chmod 755 /var/log/iact
```

### Monitoreo de Logs

```bash
# Ver logs en tiempo real
tail -f /var/log/iact/cleanup.log
tail -f /var/log/iact/health.log
tail -f /var/log/iact/backup.log

# Ver ultimas 50 lineas
tail -50 /var/log/iact/cleanup.log

# Buscar errores
grep -i error /var/log/iact/*.log
grep -i fail /var/log/iact/*.log
```

## Verificacion

### Verificar Crontab Instalado

```bash
# Listar crontab actual
crontab -l

# Debe mostrar las 3 entradas de IACT
```

### Test Manual de Scripts

```bash
# 1. Test cleanup (dry-run)
/home/user/IACT---project/scripts/cleanup_sessions.sh --dry-run

# 2. Test health check
/home/user/IACT---project/scripts/health_check.sh --verbose

# 3. Test backup (requiere MYSQL_PWD)
MYSQL_PWD=<password> /home/user/IACT---project/scripts/backup_data_centralization.sh
```

### Verificar Ejecucion de Cron Jobs

```bash
# Ver logs del sistema cron
grep CRON /var/log/syslog | tail -20

# Verificar que los scripts se ejecutaron
ls -lht /var/log/iact/*.log | head -10
```

## Alertas y Notificaciones

### Health Check Alerts

El script `health_check.sh` retorna:
- Exit code 0: Sistema saludable
- Exit code 1: Sistema no saludable

Para alertas por email (futuro):
```bash
# En crontab, agregar:
*/5 * * * * /home/user/IACT---project/scripts/health_check.sh --json || echo "Health check FAILED" | mail -s "IACT Alert" admin@example.com
```

### Cleanup Alerts

Si la tabla `django_session` supera 100K sesiones:
- El script `cleanup_sessions.sh` genera WARNING en logs
- El script `health_check.sh` marca check como FAIL

### Backup Alerts

Si el backup falla:
- Exit code 1 del script
- Log en `/var/log/iact/backup.log`

## Troubleshooting

### Problema: Cron no ejecuta scripts

**Causa:** Permisos o PATH incorrecto

**Solucion:**
```bash
# 1. Verificar permisos de ejecucion
chmod +x /home/user/IACT---project/scripts/*.sh

# 2. Usar path absoluto en crontab (ya implementado)

# 3. Verificar logs de cron
grep CRON /var/log/syslog
```

### Problema: Cleanup no elimina sesiones

**Causa:** No hay sesiones expiradas

**Solucion:**
```bash
# Verificar sesiones expiradas
cd /home/user/IACT---project/api/callcentersite
python manage.py shell -c "
from django.contrib.sessions.models import Session
from django.utils import timezone
expired = Session.objects.filter(expire_date__lt=timezone.now())
print(f'Sesiones expiradas: {expired.count()}')
"

# Si no hay expiradas, el cleanup es correcto (no hace nada)
```

### Problema: Health check falla

**Causa:** Servicio no disponible

**Solucion:**
```bash
# Ejecutar en modo verbose para diagnostico
/home/user/IACT---project/scripts/health_check.sh --verbose

# Verificar servicios
systemctl status postgresql
systemctl status mysql

# Verificar conectividad
cd /home/user/IACT---project/api/callcentersite
python manage.py check --database default
python manage.py check --database mysql
```

### Problema: Backup falla

**Causa:** MYSQL_PWD no configurado

**Solucion:**
```bash
# Opcion 1: Configurar MYSQL_PWD en crontab
# En crontab -e:
0 2 * * * MYSQL_PWD=tu_password /path/to/backup_data_centralization.sh

# Opcion 2: Configurar my.cnf
cat > ~/.my.cnf << EOF
[client]
user=root
password=tu_password
host=127.0.0.1
port=13306
EOF

chmod 600 ~/.my.cnf
```

## Metricas

### Limpieza de Sesiones

**Frecuencia:** Cada 6 horas (4 veces/dia)

**Metricas esperadas:**
- Sesiones eliminadas por ejecucion: 0-10,000 (depende del trafico)
- Espacio liberado: 0-5 MB por ejecucion
- Duracion: menos de 30 segundos

**Alertas:**
- Si count mayor a 100K: CRITICO
- Si count mayor a 50K: WARNING

### Health Checks

**Frecuencia:** Cada 5 minutos (288 veces/dia)

**Metricas esperadas:**
- Checks totales: 6-8 por ejecucion
- Checks pasados: 100 por ciento (6-8/6-8)
- Duracion: menos de 10 segundos

**Alertas:**
- Si alguno FAIL: Investigar inmediatamente

### Backups

**Frecuencia:** Diario a las 2:00 AM

**Metricas esperadas:**
- Tamano backup MySQL: 1-100 MB
- Tamano backup JSON logs: 10-500 MB
- Tamano backup final (comprimido): 5-200 MB
- Duracion: menos de 5 minutos
- Retention: 30 dias (maximos 30 archivos)

**Alertas:**
- Si backup falla: CRITICO
- Si backup mayor a 1 GB: WARNING (investigar crecimiento)

## Compliance

### RNF-002: Restricciones Tecnologicas

**Validacion en health_check.sh:**
- Verifica SESSION_ENGINE = django.contrib.sessions.backends.db
- NO permite Redis o cache backends
- Retorna FAIL si detecta violacion

### ISO 27001: Backups

**Cumplimiento:**
- Backups automatizados diarios
- Retention policy 30 dias
- Logs de backup auditables
- Datos criticos respaldados (metrics, logs)

## Mantenimiento del Sistema de Cron Jobs

### Actualizaciones

Para modificar frecuencias o agregar nuevos jobs:

```bash
# 1. Editar crontab
crontab -e

# 2. Modificar lineas segun necesidad

# 3. Guardar y salir

# 4. Verificar
crontab -l
```

### Deshabilitacion Temporal

Para deshabilitar un job temporalmente:

```bash
# 1. Editar crontab
crontab -e

# 2. Comentar la linea con #
# 0 */6 * * * /path/to/script.sh

# 3. Guardar
```

### Eliminacion

Para eliminar todos los cron jobs de IACT:

```bash
# 1. Listar crontab
crontab -l

# 2. Editar y eliminar lineas de IACT
crontab -e

# 3. O eliminar crontab completo (CUIDADO)
crontab -r
```

## Referencias

### Documentos Relacionados

- [TASK-011: Data Centralization Layer](../arquitectura/TASK-011-data-centralization-layer.md)
- [TASK-012: AI Guidelines Onboarding](../proyecto/TASK-012-ai-guidelines-onboarding.md)
- [cleanup_sessions.sh](../../scripts/cleanup_sessions.sh)
- [health_check.sh](../../scripts/health_check.sh)
- [backup_data_centralization.sh](../../scripts/backup_data_centralization.sh)

### Scripts Relacionados

```bash
scripts/
├── cleanup_sessions.sh
├── health_check.sh
├── backup_data_centralization.sh
└── README.md
```

### Cron Documentation

- Manual: `man 5 crontab`
- Online: https://crontab.guru/
- Testing: https://crontab-generator.org/

## Criterios de Aceptacion

- [COMPLETADO] 3 cron jobs configurados (cleanup, health, backup)
- [COMPLETADO] Scripts con permisos de ejecucion
- [COMPLETADO] Directorio /var/log/iact creado
- [COMPLETADO] Test manual de cada script exitoso
- [COMPLETADO] Documentacion completa
- [COMPLETADO] Logs configurados con rotacion

## Resultados

**Estado:** COMPLETADO

**Fecha de completacion:** 2025-11-07

**Cron jobs instalados:**
1. cleanup_sessions.sh - cada 6 horas
2. health_check.sh - cada 5 minutos
3. backup_data_centralization.sh - diario a las 2 AM

**Logs:**
- /var/log/iact/cleanup.log
- /var/log/iact/health.log
- /var/log/iact/backup.log

**Impacto:**
- Automatizacion completa de mantenimiento
- Reduccion de intervencion manual
- Monitoreo continuo de salud del sistema
- Backups automaticos para disaster recovery

## Proximos Pasos

1. **Monitoreo (Semana 4):**
   - Implementar dashboard de monitoreo para logs de cron
   - Alertas automaticas si health check falla

2. **Optimizacion (Q1 2026):**
   - Ajustar frecuencias segun metricas reales
   - Implementar backup incremental (actualmente full backup)

3. **Integracion (Q1 2026):**
   - Integrar con sistema de alertas centralizado
   - Metricas de cron jobs en DORA dashboard

---

**VERSION:** 1.0.0
**ESTADO:** COMPLETADO
**STORY POINTS:** 2 SP
**ASIGNADO:** devops-lead
**FECHA:** 2025-11-07
