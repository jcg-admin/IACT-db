---
id: PROC-BACKEND-XXX
tipo: procedimiento
categoria: [deployment|rollback|maintenance|troubleshooting|scaling|disaster-recovery]
titulo: [Título Descriptivo del Procedimiento]
criticidad: [CRITICA|ALTA|MEDIA|BAJA]
frecuencia: [diaria|semanal|mensual|trimestral|on-demand|emergencia]
tiempo_estimado: XXmin
version: 1.0.0
ultima_actualizacion: YYYY-MM-DD
autor: [Nombre]
revisores: [Nombre1, Nombre2]
---

# PROC-BACKEND-XXX: [Título del Procedimiento]

**Tipo:** deployment | rollback | maintenance | troubleshooting | scaling | disaster-recovery
**Criticidad:** CRITICA | ALTA | MEDIA | BAJA
**Frecuencia:** [cuándo se ejecuta este procedimiento]
**Tiempo Estimado:** XX minutos
**Última Ejecución:** YYYY-MM-DD
**Tasa de Éxito:** XX% (basado en últimas YY ejecuciones)

---

## Propósito

### Qué hace este procedimiento
[Descripción clara y concisa de lo que hace este procedimiento]

### Cuándo usarlo
[Situaciones en las que se debe ejecutar este procedimiento]

### Cuándo NO usarlo
[Situaciones en las que este procedimiento NO es apropiado]

### Impacto
- **Usuarios:** [impacto en usuarios finales, downtime esperado]
- **Sistemas:** [sistemas afectados]
- **Datos:** [impacto en datos, posibilidad de pérdida]
- **SLA:** [impacto en SLA/SLO]

---

## Prerequisitos

### Permisos y Accesos
- [ ] Acceso SSH a servidores: [servidor1, servidor2]
- [ ] Credenciales de base de datos: [DB1, DB2]
- [ ] Acceso a consola AWS/GCP/Azure: [servicios específicos]
- [ ] Acceso a CI/CD: [Jenkins, GitHub Actions, etc.]
- [ ] Permisos de sudo/root (si aplica)
- [ ] VPN conectada (si aplica)

### Herramientas Requeridas
- [ ] `kubectl` versión X.Y.Z o superior (si aplica)
- [ ] `psql` o cliente de DB específico
- [ ] `aws-cli` / `gcloud` / `az` configurado
- [ ] `git` con acceso al repositorio
- [ ] `docker` / `docker-compose`
- [ ] [Herramienta específica del proyecto]

### Conocimiento Previo
- [ ] Comprensión de arquitectura del backend
- [ ] Familiaridad con [tecnología específica]
- [ ] Lectura de [documento de referencia]

### Estado del Sistema
- [ ] Ambiente: [staging|production|dev]
- [ ] Versión actual del backend: [vX.Y.Z]
- [ ] Estado de monitoreo: Activo y funcionando
- [ ] Ventana de mantenimiento: [si aplica]
- [ ] Aprobación de: [Tech Lead, Product Manager, etc.]
- [ ] Backup reciente disponible

---

## Preparación (Pre-Flight Checks)

### Paso P1: Verificar Estado del Sistema
```bash
# Verificar servicios activos
systemctl status backend-api
systemctl status backend-worker

# Verificar conectividad a DB
psql -h db.example.com -U backend_user -c "SELECT 1;"

# Verificar métricas actuales
curl http://localhost:9090/metrics | grep "backend_requests_total"
```

**Resultado Esperado:** Todos los servicios UP, DB accesible, métricas normales

**Si falla:** [Acciones a tomar antes de proceder]

### Paso P2: Crear Backup de Seguridad
```bash
# Backup de base de datos
pg_dump -h db.example.com -U backend_user backend_db > backup_pre_procedure_$(date +%Y%m%d_%H%M%S).sql

# Verificar tamaño del backup
ls -lh backup_pre_procedure_*.sql

# Backup de configuración
tar -czf config_backup_$(date +%Y%m%d_%H%M%S).tar.gz /etc/backend/
```

**Resultado Esperado:** Archivos de backup creados exitosamente

**Ubicación de Backups:** `/backups/procedures/PROC-XXX/`

### Paso P3: Notificar Inicio de Procedimiento
```bash
# Notificar en Slack/Teams
curl -X POST https://hooks.slack.com/services/XXX \
 -H 'Content-Type: application/json' \
 -d '{"text":"[PROD] Iniciando PROC-BACKEND-XXX: [Título] - Estimado: XX minutos"}'

# Crear incident tracking (si aplica)
# Ejemplo: abrir ticket en Jira/PagerDuty
```

**Resultado Esperado:** Equipo notificado, ticket creado

---

## Pasos de Ejecución

### Paso 1: [Título del Paso]
**Duración Estimada:** X minutos
**Criticidad:** CRITICA | ALTA | MEDIA | BAJA
**Rollback Disponible:** SI | NO

```bash
# Comandos a ejecutar
[comando1]
[comando2]
[comando3]
```

**Resultado Esperado:** [Descripción del resultado esperado]

**Validación:**
```bash
# Cómo validar que este paso funcionó
[comando de validación]
```

**Salida Esperada:**
```
[Ejemplo de salida exitosa]
```

**Si falla:**
- [ ] Verificar [aspecto específico]
- [ ] Revisar logs: `tail -f /var/log/backend/error.log`
- [ ] Verificar permisos/conectividad
- [ ] Ejecutar rollback del paso (ver sección Rollback)

**Rollback de este paso:**
```bash
# Comandos para revertir este paso específicamente
[comando rollback 1]
[comando rollback 2]
```

---

### Paso 2: [Título del Paso]
**Duración Estimada:** X minutos
**Criticidad:** CRITICA | ALTA | MEDIA | BAJA
**Rollback Disponible:** SI | NO

[Repetir estructura del Paso 1...]

---

### Paso N: [Último Paso]
[Repetir estructura...]

---

## Validación Final

### Verificar Salud del Sistema
```bash
# Health check de API
curl -f http://backend.example.com/health || echo "FALLO: API no responde"

# Verificar error rate (debe ser < 1%)
curl http://monitoring.example.com/api/error_rate

# Verificar latencia p95 (debe ser < 200ms)
curl http://monitoring.example.com/api/latency_p95

# Verificar throughput
curl http://monitoring.example.com/api/throughput
```

**Métricas de Éxito:**
- [ ] API responde HTTP 200 en /health
- [ ] Error rate < 1% en últimos 5 minutos
- [ ] Latencia p95 < 200ms
- [ ] Throughput dentro de rangos normales (X-Y req/s)
- [ ] 0 errores críticos en logs
- [ ] Todos los workers activos
- [ ] DB connections normales

### Pruebas Funcionales
```bash
# Ejecutar smoke tests
npm run test:smoke

# Ejecutar health checks end-to-end
./scripts/e2e-health-check.sh

# Verificar funcionalidad crítica manualmente
# [Lista de pasos manuales si aplica]
```

**Resultado Esperado:** Todos los tests pasan, funcionalidad crítica verificada

### Verificar Monitoreo
- [ ] Dashboard de Grafana: [link] - Sin anomalías
- [ ] Logs en Kibana/CloudWatch: [link] - Sin errores críticos
- [ ] Alertas: 0 alertas activas
- [ ] Métricas de negocio: [verificación específica]

---

## Rollback Completo

**Cuándo ejecutar rollback:**
- Error rate > 5%
- Latencia p99 > 1s
- Errores críticos en logs
- Funcionalidad core rota
- Datos corrompidos/inconsistentes
- Instrucción de Tech Lead/Incident Commander

### Paso R1: Detener Operaciones en Progreso
```bash
# Cancelar procesos activos
pkill -f "proceso_especifico"

# Drenar tráfico (si aplica)
kubectl drain node-backend-1 --ignore-daemonsets

# Poner sistema en modo mantenimiento
touch /var/www/maintenance.flag
```

**Duración estimada:** 2 minutos

### Paso R2: Restaurar Estado Previo
```bash
# Restaurar código (si deployment)
cd /opt/backend
git checkout [commit-previo]
./deploy.sh

# Restaurar base de datos (si fue modificada)
# CUIDADO: Esto eliminará cambios posteriores
psql -h db.example.com -U backend_user backend_db < backup_pre_procedure_YYYYMMDD_HHMMSS.sql

# Restaurar configuración
tar -xzf config_backup_YYYYMMDD_HHMMSS.tar.gz -C /
systemctl restart backend-api
```

**Duración estimada:** 5-10 minutos

### Paso R3: Validar Rollback
```bash
# Verificar que sistema volvió a estado previo
./scripts/health-check.sh

# Verificar versión
curl http://backend.example.com/version

# Verificar funcionalidad crítica
./scripts/smoke-test.sh
```

**Resultado Esperado:** Sistema en estado previo al procedimiento, funcional

### Paso R4: Notificar Rollback
```bash
# Notificar en Slack
curl -X POST https://hooks.slack.com/services/XXX \
 -H 'Content-Type: application/json' \
 -d '{"text":"[PROD] [WARNING] ROLLBACK ejecutado para PROC-BACKEND-XXX. Sistema restaurado a estado previo."}'

# Actualizar incident ticket
# [Comandos específicos]
```

**Duración estimada:** 1 minuto

**Tiempo total de rollback:** ~10-15 minutos

---

## Troubleshooting

### Problema 1: [Problema Común]
**Síntomas:**
- [Síntoma 1]
- [Síntoma 2]
- [Mensaje de error específico]

**Causa Probable:** [Explicación]

**Solución:**
```bash
# Comandos para resolver
[comando1]
[comando2]
```

**Referencias:** [Link a documentación, ADR, issue de GitHub]

---

### Problema 2: [Otro Problema Común]
**Síntomas:**
- [Síntoma 1]
- [Síntoma 2]

**Causa Probable:** [Explicación]

**Solución:**
```bash
# Comandos para resolver
[comando1]
[comando2]
```

**Referencias:** [Link a documentación]

---

### Problema 3: Permission Denied / Acceso Denegado
**Síntomas:**
- Comandos fallan con "Permission denied"
- "Access denied" en DB

**Causa Probable:** Permisos insuficientes, VPN desconectada

**Solución:**
```bash
# Verificar usuario actual
whoami

# Verificar permisos sudo
sudo -l

# Verificar VPN
ping internal-server.local

# Reconectar VPN si necesario
# [Comandos específicos]
```

---

## Post-Ejecución

### Limpieza
```bash
# Eliminar archivos temporales
rm -f /tmp/procedure-*.tmp

# Limpiar logs antiguos (si aplica)
find /var/log/backend -name "*.log.*" -mtime +30 -delete

# Remover flag de mantenimiento
rm -f /var/www/maintenance.flag
```

### Notificaciones
```bash
# Notificar finalización exitosa
curl -X POST https://hooks.slack.com/services/XXX \
 -H 'Content-Type: application/json' \
 -d '{"text":"[PROD] [OK] PROC-BACKEND-XXX completado exitosamente. Duración: XX min."}'

# Cerrar incident ticket (si aplica)
# [Comandos específicos]
```

### Documentación
- [ ] Actualizar tiempo real de ejecución en metadata
- [ ] Registrar tasa de éxito en historial
- [ ] Documentar issues encontrados
- [ ] Actualizar runbook si se encontraron mejoras
- [ ] Compartir lecciones aprendidas con equipo
- [ ] Actualizar FAQ si se resolvieron problemas nuevos

### Monitoreo Post-Procedimiento
- [ ] Observar métricas durante [X horas] post-ejecución
- [ ] Verificar alertas: 0 alertas nuevas
- [ ] Revisar logs de errores
- [ ] Confirmar con stakeholders que todo funciona
- [ ] Verificar métricas de negocio (si aplica)

---

## Métricas y KPIs

### Historial de Ejecuciones
| Fecha | Ejecutor | Duración | Éxito | Notas |
|-------|----------|----------|-------|-------|
| YYYY-MM-DD | [Nombre] | XXmin | SI/NO | [Observaciones] |
| ... | ... | ... | ... | ... |

### Estadísticas
- **Ejecuciones Totales:** XX
- **Tasa de Éxito:** XX%
- **Tiempo Promedio:** XX minutos
- **Tiempo Mínimo:** XX minutos
- **Tiempo Máximo:** XX minutos
- **Rollbacks Ejecutados:** XX

### Mejora Continua
[Notas sobre optimizaciones, lecciones aprendidas, mejoras futuras]

---

## Referencias

### Documentación Relacionada
- ADR-BACKEND-XXX: [Decisión arquitectónica relacionada]
- PROC-BACKEND-YYY: [Procedimiento relacionado]
- [Documentación técnica oficial]

### Contactos de Escalamiento
- **Tech Lead:** [Nombre] - [@slack / email]
- **DBA:** [Nombre] - [@slack / email]
- **DevOps:** [Nombre] - [@slack / email]
- **On-Call:** [PagerDuty/Opsgenie link]

### Recursos
- Dashboard de Monitoreo: [URL Grafana]
- Logs: [URL Kibana/CloudWatch]
- Runbook completo: [URL Confluence/Notion]
- Incident Response Plan: [URL]

---

## Anexos

### Anexo A: Comandos Útiles
```bash
# Ver status de servicios backend
systemctl status backend-*

# Seguir logs en tiempo real
tail -f /var/log/backend/*.log

# Ver métricas
curl localhost:9090/metrics | grep backend

# Ver procesos backend
ps aux | grep backend

# Ver conexiones de DB
psql -h db.example.com -U backend_user -c "SELECT * FROM pg_stat_activity;"
```

### Anexo B: Checklist Rápido
- [ ] Prerequisitos verificados
- [ ] Backup creado
- [ ] Equipo notificado
- [ ] Pasos 1-N ejecutados exitosamente
- [ ] Validación final: PASS
- [ ] Monitoreo: Normal
- [ ] Documentación actualizada

### Anexo C: Decision Tree para Rollback
```
¿El procedimiento falló?
 NO → Continuar con validación final
 SI → ¿Es crítico?
 SI → Rollback inmediato
 NO → ¿Se puede resolver en < 15 min?
 SI → Intentar fix
 NO → Rollback
```

---

## Historial de Versiones

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | YYYY-MM-DD | [Nombre] | Versión inicial |
| 1.1.0 | YYYY-MM-DD | [Nombre] | Añadido paso X, mejorado rollback |

---

## Aprobaciones

- **Creado por:** [Nombre] - [Fecha]
- **Revisado por:** [Nombre] - [Fecha]
- **Aprobado por:** [Tech Lead/Director] - [Fecha]
- **Testeado en:** [staging|pre-prod] - [Fecha]

---

**Documento creado:** YYYY-MM-DD
**Última actualización:** YYYY-MM-DD
**Versión:** 1.0.0
**Próxima revisión:** YYYY-MM-DD (cada 6 meses)

---

## Instrucciones de Uso

1. **Copiar esta plantilla** para crear un nuevo procedimiento
2. **Nombrar el archivo**: `PROC-BACKEND-XXX-titulo-descriptivo.md`
 - XXX: Número secuencial (001, 002, etc.)
 - titulo-descriptivo: Descripción breve en kebab-case
3. **Completar todas las secciones** relevantes
4. **Testear en staging/pre-prod** antes de ejecutar en producción
5. **Someter a revisión** de DevOps/SRE/Tech Lead
6. **Ejecutar al menos 1 vez con supervisión** antes de aprobar
7. **Actualizar** después de cada ejecución con lecciones aprendidas

## Ejemplo de Nomenclatura

```
PROC-BACKEND-001-deployment-production.md
PROC-BACKEND-002-database-backup-restore.md
PROC-BACKEND-003-rollback-emergency.md
```

## Enlaces Relacionados

- [Índice de Procedimientos](./README.md)
- [ADRs Backend](../arquitectura/decisions/README.md)
- [Disaster Recovery Plan](../../operaciones/disaster_recovery.md)
