---
id: PROC-BACKEND-001
tipo: procedimiento
categoria: maintenance
titulo: Ejemplo - Health Check del Sistema Backend
criticidad: BAJA
frecuencia: on-demand
tiempo_estimado: 15min
version: 1.0.0
ultima_actualizacion: 2025-11-18
autor: Tech Lead Backend
revisores: [DevOps Lead, SRE]
---

# PROC-BACKEND-001: Ejemplo - Health Check del Sistema Backend

**Tipo:** maintenance
**Criticidad:** BAJA
**Frecuencia:** On-demand (para validar plantilla)
**Tiempo Estimado:** 15 minutos
**Última Ejecución:** 2025-11-18
**Tasa de Éxito:** 100% (basado en 1 ejecución)

---

## Propósito

### Qué hace este procedimiento
Este es un procedimiento de ejemplo que demuestra cómo usar la plantilla `plantilla-procedimiento-backend.md`. Ejecuta health checks básicos del sistema backend para validar que la plantilla es completa y útil.

### Cuándo usarlo
- Para familiarizarse con la plantilla de procedimientos
- Como referencia al crear nuevos procedimientos
- Para validar que un sistema backend está funcionando correctamente

### Cuándo NO usarlo
- En emergencias (este es solo un ejemplo educativo)
- Para diagnóstico profundo de problemas (es un check superficial)

### Impacto
- **Usuarios:** Ninguno (solo lectura)
- **Sistemas:** Ninguno (no hace cambios)
- **Datos:** Ninguno (solo consultas de lectura)
- **SLA:** Ninguno

---

## Prerequisitos

### Permisos y Accesos
- [ ] Acceso SSH a servidores backend
- [ ] Acceso de lectura a base de datos
- [ ] Acceso a métricas/monitoreo

### Herramientas Requeridas
- [ ] `curl` instalado
- [ ] `psql` o cliente de DB
- [ ] Acceso a navegador web (para dashboards)

### Conocimiento Previo
- [ ] Comprensión básica de arquitectura del backend
- [ ] Familiaridad con comandos de terminal

### Estado del Sistema
- [ ] Ambiente: cualquiera (dev/staging/production)
- [ ] Sistema debe estar activo (no en mantenimiento)

---

## Preparación (Pre-Flight Checks)

### Paso P1: Verificar Conectividad
```bash
# Verificar conectividad a internet
ping -c 3 google.com

# Verificar conectividad a servidor backend (ajustar URL)
ping -c 3 backend.example.com
```

**Resultado Esperado:** Respuestas exitosas de ping

**Si falla:** Verificar conexión de red, VPN si aplica

### Paso P2: Verificar Herramientas
```bash
# Verificar curl
curl --version

# Verificar psql (si aplica)
psql --version
```

**Resultado Esperado:** Versiones de herramientas mostradas

**Si falla:** Instalar herramientas faltantes

---

## Pasos de Ejecución

### Paso 1: Health Check de API
**Duración Estimada:** 2 minutos
**Criticidad:** MEDIA
**Rollback Disponible:** NO (solo lectura)

```bash
# Health check endpoint (ajustar URL a tu backend)
curl -f http://backend.example.com/health

# O si estás en el servidor directamente
curl -f http://localhost:8000/health
```

**Resultado Esperado:**
```json
{
 "status": "healthy",
 "timestamp": "2025-11-18T10:00:00Z"
}
```

**Validación:**
```bash
# Verificar que retorna HTTP 200
curl -o /dev/null -s -w "%{http_code}\n" http://backend.example.com/health
```

**Salida Esperada:**
```
200
```

**Si falla:**
- [ ] Verificar que el servicio backend está corriendo
- [ ] Revisar logs: `tail -f /var/log/backend/error.log`
- [ ] Verificar puerto correcto
- [ ] No hay rollback necesario (solo lectura)

---

### Paso 2: Verificar Base de Datos
**Duración Estimada:** 3 minutos
**Criticidad:** ALTA
**Rollback Disponible:** NO (solo lectura)

```bash
# Conectar a DB y ejecutar query simple (ajustar credenciales)
psql -h localhost -U backend_user -d backend_db -c "SELECT 1 AS test;"

# Verificar número de conexiones activas
psql -h localhost -U backend_user -d backend_db -c "SELECT count(*) FROM pg_stat_activity;"
```

**Resultado Esperado:**
```
 test
------
 1
(1 row)
```

**Validación:**
```bash
# Debe retornar exit code 0
echo $?
```

**Salida Esperada:**
```
0
```

**Si falla:**
- [ ] Verificar que PostgreSQL está corriendo: `systemctl status postgresql`
- [ ] Verificar credenciales
- [ ] Verificar conectividad de red a DB
- [ ] Revisar logs de PostgreSQL

---

### Paso 3: Verificar Servicios del Sistema
**Duración Estimada:** 2 minutos
**Criticidad:** MEDIA
**Rollback Disponible:** NO (solo lectura)

```bash
# Verificar servicios backend (ajustar nombres de servicios)
systemctl status backend-api
systemctl status backend-worker

# Verificar procesos
ps aux | grep backend | grep -v grep
```

**Resultado Esperado:**
Servicios activos y corriendo

**Validación:**
```bash
# Verificar que servicios están activos
systemctl is-active backend-api
systemctl is-active backend-worker
```

**Salida Esperada:**
```
active
active
```

**Si falla:**
- [ ] Intentar iniciar servicio: `systemctl start backend-api`
- [ ] Revisar logs: `journalctl -u backend-api -n 50`
- [ ] Verificar configuración del servicio

---

### Paso 4: Verificar Métricas Básicas
**Duración Estimada:** 3 minutos
**Criticidad:** BAJA
**Rollback Disponible:** NO (solo lectura)

```bash
# Verificar endpoint de métricas (Prometheus format)
curl http://localhost:9090/metrics | grep "backend_requests_total"

# Verificar uso de CPU
top -b -n 1 | grep backend

# Verificar uso de memoria
free -h
```

**Resultado Esperado:** Métricas disponibles, recursos dentro de límites normales

**Validación:**
```bash
# Verificar que endpoint de métricas responde
curl -o /dev/null -s -w "%{http_code}\n" http://localhost:9090/metrics
```

**Salida Esperada:**
```
200
```

**Si falla:**
- [ ] Verificar que Prometheus/metrics server está corriendo
- [ ] Verificar configuración de métricas
- [ ] Esto no es crítico, solo informativo

---

### Paso 5: Verificar Logs
**Duración Estimada:** 5 minutos
**Criticidad:** MEDIA
**Rollback Disponible:** NO (solo lectura)

```bash
# Ver últimos logs (ajustar path)
tail -n 100 /var/log/backend/app.log

# Buscar errores recientes
grep -i "error" /var/log/backend/app.log | tail -n 20

# Buscar warnings
grep -i "warning" /var/log/backend/app.log | tail -n 20
```

**Resultado Esperado:** Logs sin errores críticos recientes

**Validación:**
```bash
# Contar errores en última hora
grep "$(date -d '1 hour ago' '+%Y-%m-%d %H')" /var/log/backend/app.log | grep -i "error" | wc -l
```

**Salida Esperada:**
```
0
```
(o número bajo de errores no críticos)

**Si falla:**
- [ ] Investigar errores encontrados
- [ ] Correlacionar con métricas y servicios
- [ ] Escalar si hay errores críticos

---

## Validación Final

### Verificar Salud del Sistema
```bash
# Summary check - todos los componentes
echo "=== API Health ==="
curl -f http://backend.example.com/health

echo "=== DB Connection ==="
psql -h localhost -U backend_user -d backend_db -c "SELECT 1;"

echo "=== Services ==="
systemctl is-active backend-api backend-worker
```

**Métricas de Éxito:**
- [ ] API responde HTTP 200 en /health
- [ ] DB accesible y responde a queries
- [ ] Todos los servicios backend activos
- [ ] No hay errores críticos en logs recientes
- [ ] Métricas disponibles y normales

### Pruebas Funcionales
```bash
# Smoke test básico - hacer request simple a API
curl -X GET http://backend.example.com/api/v1/status

# Expected: respuesta válida, no error 500
```

**Resultado Esperado:** Respuesta válida de la API

### Verificar Monitoreo
- [ ] Dashboard de Grafana accesible (si aplica)
- [ ] Logs accesibles
- [ ] Sin alertas activas críticas

---

## Rollback Completo

**Este procedimiento es de solo lectura - no requiere rollback**

No se hacen cambios al sistema, por lo que no hay nada que revertir.

---

## Troubleshooting

### Problema 1: API No Responde
**Síntomas:**
- `curl` a /health falla
- HTTP 500 o connection refused
- Timeout

**Causa Probable:** Servicio backend caído o mal configurado

**Solución:**
```bash
# Verificar status del servicio
systemctl status backend-api

# Revisar logs
journalctl -u backend-api -n 100

# Intentar restart (solo si es ambiente de dev/staging)
systemctl restart backend-api

# Esperar 10 segundos y verificar
sleep 10
curl -f http://localhost:8000/health
```

**Referencias:** [Documentación de troubleshooting]

---

### Problema 2: DB Connection Failed
**Síntomas:**
- `psql` falla con "connection refused"
- "password authentication failed"

**Causa Probable:** PostgreSQL caído o credenciales incorrectas

**Solución:**
```bash
# Verificar que PostgreSQL está corriendo
systemctl status postgresql

# Si está caído, iniciar (solo dev/staging)
systemctl start postgresql

# Verificar credenciales
cat /etc/backend/db-config.env

# Intentar conectar con credenciales correctas
psql -h localhost -U [user] -d [database]
```

---

## Post-Ejecución

### Limpieza
```bash
# No hay limpieza necesaria (solo lectura)
# Opcionalmente, limpiar archivos temporales si se crearon
```

### Notificaciones
```bash
# Si se encontraron problemas, notificar al equipo
# Ejemplo:
echo "Health check completado. Resumen: [OK/ISSUES]"
```

### Documentación
- [ ] Este ejemplo sirvió para validar la plantilla
- [ ] Si ejecutaste este procedimiento, documenta tu experiencia
- [ ] Sugiere mejoras a la plantilla

### Monitoreo Post-Procedimiento
- No aplica (no se hicieron cambios)

---

## Métricas y KPIs

### Historial de Ejecuciones
| Fecha | Ejecutor | Duración | Éxito | Notas |
|-------|----------|----------|-------|-------|
| 2025-11-18 | Tech Lead Backend | 15min | SI | Validación inicial de plantilla |

### Estadísticas
- **Ejecuciones Totales:** 1
- **Tasa de Éxito:** 100%
- **Tiempo Promedio:** 15 minutos
- **Rollbacks Ejecutados:** 0

### Mejora Continua
Este es un procedimiento de ejemplo. En un procedimiento real, documentar aquí:
- Optimizaciones realizadas
- Problemas recurrentes encontrados
- Mejoras sugeridas para futuras versiones

---

## Referencias

### Documentación Relacionada
- [Plantilla de Procedimientos](./plantilla-procedimiento-backend.md)
- [ADR sobre monitoring](../arquitectura/decisions/README.md)

### Contactos de Escalamiento
- **Tech Lead:** [Nombre] - [@slack]
- **DevOps:** [Nombre] - [@slack]
- **On-Call:** [PagerDuty link]

### Recursos
- Dashboard de Monitoreo: [URL]
- Logs: [URL]

---

## Anexos

### Anexo A: Comandos Útiles
```bash
# Ver todos los servicios backend
systemctl list-units | grep backend

# Ver consumo de recursos
htop

# Ver conexiones de red
netstat -tulpn | grep backend
```

### Anexo B: Checklist Rápido
- [ ] API health check: OK
- [ ] DB connection: OK
- [ ] Services running: OK
- [ ] Metrics available: OK
- [ ] Logs clean: OK

---

## Historial de Versiones

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-18 | Tech Lead Backend | Versión inicial (ejemplo) |

---

## Aprobaciones

- **Creado por:** Tech Lead Backend - 2025-11-18
- **Revisado por:** [Pendiente] - [Fecha]
- **Aprobado por:** [Pendiente] - [Fecha]
- **Testeado en:** dev - 2025-11-18

---

**Documento creado:** 2025-11-18
**Última actualización:** 2025-11-18
**Versión:** 1.0.0
**Próxima revisión:** 2026-05-18
