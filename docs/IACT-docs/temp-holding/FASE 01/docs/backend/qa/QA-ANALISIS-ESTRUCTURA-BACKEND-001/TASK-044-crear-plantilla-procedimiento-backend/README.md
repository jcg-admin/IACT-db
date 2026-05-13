---
id: TASK-REORG-BACK-044
tipo: tarea
categoria: plantillas
titulo: Crear plantilla-procedimiento-backend.md
fase: FASE_3
prioridad: ALTA
duracion_estimada: 25min
estado: pendiente
dependencias: []
metodologia: Auto-CoT, Self-Consistency
---

# TASK-REORG-BACK-044: Crear plantilla-procedimiento-backend.md

**Fase:** FASE 3 - Plantillas y Documentacion Estructurada
**Prioridad:** ALTA
**Duracion Estimada:** 25 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE
**Metodologia:** Auto-CoT (Auto-Chain of Thought), Self-Consistency

---

## Objetivo

Crear una plantilla estandarizada para procedimientos operacionales del backend (deployment, rollback, troubleshooting, mantenimiento), permitiendo documentar procesos repetibles de manera consistente y ejecutable.

---

## Auto-CoT: Razonamiento en Cadena

### Paso 1: Analizar tipos de procedimientos backend
**Pregunta:** ¿Que procedimientos son criticos en operaciones de backend?
**Razonamiento:**
- Deployment (staging, produccion, hotfixes)
- Rollback (plan de emergencia)
- Troubleshooting (debugging, diagnostico de incidentes)
- Mantenimiento (DB migrations, cleanup, backups)
- Escalado (horizontal, vertical)
- Disaster Recovery

### Paso 2: Identificar elementos de un procedimiento efectivo
**Pregunta:** ¿Que hace que un procedimiento sea ejecutable y confiable?
**Razonamiento:**
- Prerequisitos claros (permisos, accesos, herramientas)
- Pasos numerados y secuenciales
- Comandos copy-pasteable (bash, SQL, etc.)
- Validaciones en cada paso (como verificar que funciono)
- Rollback para cada paso critico
- Tiempo estimado de ejecucion
- Metricas de exito medibles

### Paso 3: Validar con Self-Consistency
**Perspectiva 1 - DevOps:** Necesita procedimientos precisos y testeados
**Perspectiva 2 - SRE:** Necesita playbooks para incidentes 24/7
**Perspectiva 3 - Desarrollador:** Necesita procedimientos de deployment claros
**Perspectiva 4 - DBA:** Necesita procedimientos de mantenimiento de DB seguros
**Consenso:** La plantilla debe ser ejecutable paso a paso, con validaciones y rollback en cada paso critico

---

## Prerequisitos

- [ ] Acceso a docs/backend/procedures/ o docs/backend/runbooks/
- [ ] Revision de procedimientos existentes
- [ ] Conocimiento de operaciones criticas del backend
- [ ] Comprension de CI/CD pipeline

---

## Pasos de Ejecucion

### Paso 1: Investigar Procedimientos Existentes
```bash
# Buscar procedimientos existentes
find /home/user/IACT -type f \( -name "*procedure*.md" -o -name "*runbook*.md" -o -name "*playbook*.md" \)

# Buscar documentacion de deployment
find /home/user/IACT/docs -name "*deploy*.md" -o -name "*rollback*.md"
```

**Resultado Esperado:** Lista de procedimientos existentes para referenciar

### Paso 2: Definir Estructura de Plantilla
Crear estructura con secciones:
1. **Metadata:** ID, tipo, criticidad, frecuencia, tiempo estimado
2. **Proposito:** Que hace este procedimiento y cuando usarlo
3. **Prerequisitos:** Permisos, accesos, herramientas, conocimiento previo
4. **Preparacion:** Verificaciones pre-ejecucion
5. **Pasos de Ejecucion:** Comandos numerados con validaciones
6. **Validacion Final:** Como confirmar exito del procedimiento
7. **Rollback:** Como revertir cambios si algo falla
8. **Troubleshooting:** Problemas comunes y soluciones
9. **Post-Ejecucion:** Tareas de cleanup, notificaciones

**Resultado Esperado:** Esquema detallado de la plantilla

### Paso 3: Crear Archivo plantilla-procedimiento-backend.md
```bash
# Crear directorio si no existe
mkdir -p /home/user/IACT/docs/backend/procedures

# Crear plantilla
touch /home/user/IACT/docs/backend/procedures/plantilla-procedimiento-backend.md
```

Contenido de la plantilla:
```markdown
---
id: PROC-BACKEND-XXX
tipo: [deployment|rollback|maintenance|troubleshooting|scaling|disaster-recovery]
categoria: backend
titulo: [Titulo Descriptivo del Procedimiento]
criticidad: [CRITICA|ALTA|MEDIA|BAJA]
frecuencia: [diaria|semanal|mensual|trimestral|on-demand|emergencia]
tiempo_estimado: XXmin
version: 1.0.0
ultima_actualizacion: YYYY-MM-DD
autor: [Nombre]
revisores: [Nombre1, Nombre2]
---

# PROC-BACKEND-XXX: [Titulo del Procedimiento]

**Tipo:** [deployment|rollback|maintenance|troubleshooting|scaling|disaster-recovery]
**Criticidad:** CRITICA | ALTA | MEDIA | BAJA
**Frecuencia:** [cuando se ejecuta este procedimiento]
**Tiempo Estimado:** XX minutos
**Ultima Ejecucion:** YYYY-MM-DD
**Tasa de Exito:** XX% (basado en ultimas YY ejecuciones)

---

## Proposito

### Que hace este procedimiento
[Descripcion clara y concisa de lo que hace este procedimiento]

### Cuando usarlo
[Situaciones en las que se debe ejecutar este procedimiento]

### Cuando NO usarlo
[Situaciones en las que este procedimiento NO es apropiado]

### Impacto
- **Usuarios:** [impacto en usuarios finales, downtime esperado]
- **Sistemas:** [sistemas afectados]
- **Datos:** [impacto en datos, posibilidad de perdida]
- **SLA:** [impacto en SLA/SLO]

---

## Prerequisitos

### Permisos y Accesos
- [ ] Acceso SSH a servidores: [servidor1, servidor2]
- [ ] Credenciales de base de datos: [DB1, DB2]
- [ ] Acceso a consola AWS/GCP/Azure: [servicios especificos]
- [ ] Acceso a CI/CD: [Jenkins, GitHub Actions, etc.]
- [ ] Permisos de sudo/root (si aplica)

### Herramientas Requeridas
- [ ] `kubectl` version X.Y.Z o superior
- [ ] `psql` o cliente de DB especifico
- [ ] `aws-cli` configurado con perfil correcto
- [ ] `git` con acceso al repositorio
- [ ] [Herramienta especifica del proyecto]

### Conocimiento Previo
- [ ] Comprension de arquitectura del backend
- [ ] Familiaridad con [tecnologia especifica]
- [ ] Lectura de [documento de referencia]

### Estado del Sistema
- [ ] Ambiente: [staging|production|dev]
- [ ] Version actual del backend: [vX.Y.Z]
- [ ] Estado de monitoreo: Activo y funcionando
- [ ] Ventana de mantenimiento: [si aplica]
- [ ] Aprobacion de: [Tech Lead, Product Manager, etc.]

---

## Preparacion (Pre-Flight Checks)

### Paso P1: Verificar Estado del Sistema
```bash
# Verificar servicios activos
systemctl status backend-api
systemctl status backend-worker

# Verificar conectividad a DB
psql -h db.example.com -U backend_user -c "SELECT 1;"

# Verificar metricas actuales
curl http://localhost:9090/metrics | grep "backend_requests_total"
```

**Resultado Esperado:** Todos los servicios UP, DB accesible, metricas normales

**Si falla:** [Acciones a tomar]

### Paso P2: Crear Backup de Seguridad
```bash
# Backup de base de datos
pg_dump -h db.example.com -U backend_user backend_db > backup_pre_procedure_$(date +%Y%m%d_%H%M%S).sql

# Backup de configuracion
tar -czf config_backup_$(date +%Y%m%d_%H%M%S).tar.gz /etc/backend/
```

**Resultado Esperado:** Archivos de backup creados exitosamente

**Ubicacion de Backups:** `/backups/procedures/PROC-XXX/`

### Paso P3: Notificar Inicio de Procedimiento
```bash
# Notificar en Slack/Teams
curl -X POST https://hooks.slack.com/services/XXX \
 -H 'Content-Type: application/json' \
 -d '{"text":"[PROD] Iniciando PROC-BACKEND-XXX: [Titulo]"}'

# Crear incident tracking (si aplica)
# Ejemplo: abrir ticket en Jira/PagerDuty
```

**Resultado Esperado:** Equipo notificado

---

## Pasos de Ejecucion

### Paso 1: [Titulo del Paso]
**Duracion Estimada:** X minutos
**Criticidad:** CRITICA | ALTA | MEDIA | BAJA
**Rollback Disponible:** SI | NO

```bash
# Comandos a ejecutar
[comando1]
[comando2]
```

**Resultado Esperado:** [Descripcion del resultado esperado]

**Validacion:**
```bash
# Como validar que este paso funciono
[comando de validacion]
```

**Salida Esperada:**
```
[Ejemplo de salida exitosa]
```

**Si falla:**
- [ ] Verificar [aspecto especifico]
- [ ] Revisar logs: `tail -f /var/log/backend/error.log`
- [ ] Ejecutar rollback del paso (ver seccion Rollback)

**Rollback de este paso:**
```bash
# Comandos para revertir este paso especificamente
[comando rollback 1]
[comando rollback 2]
```

---

### Paso 2: [Titulo del Paso]
[Repetir estructura del Paso 1...]

---

### Paso N: [Ultimo Paso]
[Repetir estructura...]

---

## Validacion Final

### Verificar Salud del Sistema
```bash
# Health check de API
curl -f http://backend.example.com/health || echo "FALLO: API no responde"

# Verificar error rate
# Debe ser < 1%
curl http://monitoring.example.com/api/error_rate

# Verificar latencia p95
# Debe ser < 200ms
curl http://monitoring.example.com/api/latency_p95
```

**Metricas de Exito:**
- [ ] API responde HTTP 200 en /health
- [ ] Error rate < 1% en ultimos 5 minutos
- [ ] Latencia p95 < 200ms
- [ ] Throughput dentro de rangos normales (X-Y req/s)
- [ ] 0 errores criticos en logs
- [ ] Todos los workers activos

### Pruebas Funcionales
```bash
# Ejecutar smoke tests
npm run test:smoke

# Ejecutar health checks end-to-end
./scripts/e2e-health-check.sh
```

**Resultado Esperado:** Todos los tests pasan

### Verificar Monitoreo
- [ ] Dashboard de Grafana: [link]
- [ ] Logs en Kibana/CloudWatch: [link]
- [ ] Alertas: 0 alertas activas
- [ ] Metricas de negocio: [verificacion especifica]

---

## Rollback Completo

**Cuando ejecutar rollback:**
- Error rate > 5%
- Latencia p99 > 1s
- Errores criticos en logs
- Funcionalidad core rota
- Instruccion de Tech Lead/Incident Commander

### Paso R1: Detener Operaciones en Progreso
```bash
# Cancelar procesos activos
pkill -f "proceso_especifico"

# Drenar trafico (si aplica)
kubectl drain node-backend-1 --ignore-daemonsets
```

### Paso R2: Restaurar Estado Previo
```bash
# Restaurar codigo (si deployment)
git checkout [commit-previo]
./deploy.sh

# Restaurar base de datos (si fue modificada)
psql -h db.example.com -U backend_user backend_db < backup_pre_procedure_YYYYMMDD_HHMMSS.sql

# Restaurar configuracion
tar -xzf config_backup_YYYYMMDD_HHMMSS.tar.gz -C /
```

### Paso R3: Validar Rollback
```bash
# Verificar que sistema volvio a estado previo
./scripts/health-check.sh

# Verificar version
curl http://backend.example.com/version
```

**Resultado Esperado:** Sistema en estado previo al procedimiento

### Paso R4: Notificar Rollback
```bash
# Notificar en Slack
curl -X POST https://hooks.slack.com/services/XXX \
 -H 'Content-Type: application/json' \
 -d '{"text":"[PROD] ROLLBACK ejecutado para PROC-BACKEND-XXX"}'
```

---

## Troubleshooting

### Problema 1: [Problema Comun]
**Sintomas:**
- [Sintoma 1]
- [Sintoma 2]

**Causa Probable:** [Explicacion]

**Solucion:**
```bash
# Comandos para resolver
[comando1]
[comando2]
```

**Referencias:** [Link a documentacion, ADR, etc.]

---

### Problema 2: [Otro Problema]
[Repetir estructura...]

---

## Post-Ejecucion

### Limpieza
```bash
# Eliminar archivos temporales
rm -f /tmp/procedure-*.tmp

# Limpiar logs antiguos (si aplica)
find /var/log/backend -name "*.log.*" -mtime +30 -delete
```

### Notificaciones
```bash
# Notificar finalizacion exitosa
curl -X POST https://hooks.slack.com/services/XXX \
 -H 'Content-Type: application/json' \
 -d '{"text":"[PROD] PROC-BACKEND-XXX completado exitosamente"}'

# Cerrar incident ticket (si aplica)
```

### Documentacion
- [ ] Actualizar tiempo real de ejecucion en metadata
- [ ] Registrar tasa de exito
- [ ] Documentar issues encontrados
- [ ] Actualizar runbook si se encontraron mejoras
- [ ] Compartir lecciones aprendidas con equipo

### Monitoreo Post-Procedimiento
- [ ] Observar metricas durante [X horas] post-ejecucion
- [ ] Verificar alertas: 0 alertas nuevas
- [ ] Revisar logs de errores
- [ ] Confirmar con stakeholders que todo funciona

---

## Metricas y KPIs

### Historial de Ejecuciones
| Fecha | Ejecutor | Duracion | Exito | Notas |
|-------|----------|----------|-------|-------|
| YYYY-MM-DD | [Nombre] | XXmin | SI/NO | [Observaciones] |
| ... | ... | ... | ... | ... |

### Estadisticas
- **Ejecuciones Totales:** XX
- **Tasa de Exito:** XX%
- **Tiempo Promedio:** XX minutos
- **Tiempo Minimo:** XX minutos
- **Tiempo Maximo:** XX minutos
- **Rollbacks Ejecutados:** XX

### Mejora Continua
[Notas sobre optimizaciones, lecciones aprendidas, mejoras futuras]

---

## Referencias

### Documentacion Relacionada
- ADR-XXX: [Decision arquitectonica relacionada]
- PROC-BACKEND-YYY: [Procedimiento relacionado]
- [Documentacion tecnica oficial]

### Contactos de Escalamiento
- **Tech Lead:** [Nombre] - [Slack/Email]
- **DBA:** [Nombre] - [Slack/Email]
- **DevOps:** [Nombre] - [Slack/Email]
- **On-Call:** [PagerDuty/Opsgenie]

### Recursos
- Dashboard de Monitoreo: [URL]
- Logs: [URL Kibana/CloudWatch]
- Runbook completo: [URL Confluence/Notion]

---

## Anexos

### Anexo A: Comandos Utiles
```bash
# Ver status de servicios
systemctl status backend-*

# Seguir logs en tiempo real
tail -f /var/log/backend/*.log

# Ver metricas
curl localhost:9090/metrics | grep backend
```

### Anexo B: Checklist Rapido
- [ ] Prerequisitos verificados
- [ ] Backup creado
- [ ] Equipo notificado
- [ ] Pasos 1-N ejecutados exitosamente
- [ ] Validacion final: PASS
- [ ] Monitoreo: Normal
- [ ] Documentacion actualizada

---

## Historial de Versiones

| Version | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | YYYY-MM-DD | [Nombre] | Version inicial |
| 1.1.0 | YYYY-MM-DD | [Nombre] | Añadido paso X, mejorado rollback |

---

## Aprobaciones

- **Creado por:** [Nombre] - [Fecha]
- **Revisado por:** [Nombre] - [Fecha]
- **Aprobado por:** [Tech Lead/Director] - [Fecha]
- **Testeado en:** [staging|pre-prod] - [Fecha]

---

**Documento creado:** YYYY-MM-DD
**Ultima actualizacion:** YYYY-MM-DD
**Version:** 1.0.0
**Proxima revision:** YYYY-MM-DD (cada 6 meses)
```

**Resultado Esperado:** Archivo plantilla-procedimiento-backend.md creado

### Paso 4: Validar Plantilla con Self-Consistency

```bash
# Perspectiva 1: DevOps Engineer
# ¿La plantilla tiene comandos ejecutables?
# ¿Incluye validaciones en cada paso?
# ¿El rollback es completo y claro?

# Perspectiva 2: SRE (Site Reliability Engineer)
# ¿Es usable durante un incidente a las 3am?
# ¿Tiene troubleshooting de problemas comunes?
# ¿Las metricas de exito son medibles?

# Perspectiva 3: Desarrollador Backend
# ¿Es suficientemente detallada para alguien nuevo?
# ¿Los prerequisitos estan claros?
# ¿Los comandos son copy-pasteable?

# Perspectiva 4: DBA
# ¿Los backups de DB estan cubiertos?
# ¿Las operaciones de DB son seguras?
# ¿Hay validacion de integridad de datos?
```

**Resultado Esperado:** Plantilla validada y ajustada segun feedback de 4 perspectivas

### Paso 5: Crear README en carpeta procedures/
```bash
cat > /home/user/IACT/docs/backend/procedures/README.md << 'EOF'
# Procedimientos Operacionales - Backend

Runbooks y procedimientos estandarizados para operaciones del backend.

## Tipos de Procedimientos

- **Deployment:** Despliegues a staging/production
- **Rollback:** Reversion de cambios
- **Maintenance:** Mantenimiento DB, cleanup, backups
- **Troubleshooting:** Diagnostico de incidentes
- **Scaling:** Escalado horizontal/vertical
- **Disaster Recovery:** Recuperacion ante desastres

## Como Crear un Procedimiento

1. Copiar `plantilla-procedimiento-backend.md`
2. Renombrar a `PROC-BACKEND-XXX-titulo-descriptivo.md`
3. Completar todas las secciones
4. Testear en staging/pre-prod
5. Someter a revision de DevOps/SRE
6. Ejecutar al menos 1 vez con supervision antes de aprobar

## Numeros de Procedimiento

Formato: PROC-BACKEND-001, PROC-BACKEND-002, etc.
Ver ultimo procedimiento para siguiente numero.

## Criticidad

- CRITICA: Afecta produccion, requiere aprobacion Tech Lead
- ALTA: Afecta sistemas importantes, requiere revision
- MEDIA: Operaciones rutinarias, seguir proceso estandar
- BAJA: Mantenimiento menor, documentar para referencia

## Mejora Continua

Actualizar procedimientos tras cada ejecucion con lecciones aprendidas.
Revision obligatoria cada 6 meses.
EOF
```

**Resultado Esperado:** README creado

### Paso 6: Crear Procedimiento de Ejemplo
```bash
# Crear un procedimiento de ejemplo simple
# PROC-BACKEND-000-ejemplo-health-check.md
```

**Resultado Esperado:** Procedimiento de ejemplo validando uso de plantilla

---

## Criterios de Exito

- [ ] Archivo plantilla-procedimiento-backend.md creado en docs/backend/procedures/
- [ ] Plantilla incluye: metadata, proposito, prerequisitos, preparacion, pasos, validacion, rollback, troubleshooting, post-ejecucion
- [ ] Frontmatter YAML con campos completos
- [ ] Cada paso incluye: comandos, resultado esperado, validacion, rollback
- [ ] Seccion de troubleshooting con problemas comunes
- [ ] Rollback completo documentado paso a paso
- [ ] Metricas de exito medibles
- [ ] README.md en carpeta procedures/ creado
- [ ] Plantilla validada desde 4 perspectivas (DevOps, SRE, Dev, DBA)
- [ ] Procedimiento de ejemplo creado (PROC-BACKEND-000)

---

## Validacion

```bash
# Verificar archivo existe
ls -lh /home/user/IACT/docs/backend/procedures/plantilla-procedimiento-backend.md

# Contar secciones principales
grep "^## " /home/user/IACT/docs/backend/procedures/plantilla-procedimiento-backend.md | wc -l

# Verificar tiene estructura de pasos
grep "^### Paso" /home/user/IACT/docs/backend/procedures/plantilla-procedimiento-backend.md

# Verificar frontmatter
head -15 /home/user/IACT/docs/backend/procedures/plantilla-procedimiento-backend.md | grep -E "^(id|tipo|criticidad|frecuencia):"

# Verificar README
cat /home/user/IACT/docs/backend/procedures/README.md
```

**Salida Esperada:** Archivo existe, tiene estructura correcta, README presente

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Procedimientos no testeados | ALTA | CRITICO | Requerir testing en staging antes de aprobar |
| Plantilla demasiado verbosa | MEDIA | MEDIO | Marcar secciones opcionales, crear version "quick" |
| Desactualizacion de procedimientos | ALTA | ALTO | Revision cada 6 meses, actualizar tras cada ejecucion |
| Rollback incompleto | BAJA | CRITICO | Peer review obligatorio de seccion de rollback |

---

## Evidencias a Capturar

1. Archivo `plantilla-procedimiento-backend.md` completo
2. README.md en carpeta procedures/
3. Procedimiento de ejemplo (PROC-BACKEND-000)
4. Validacion desde 4 perspectivas documentada
5. Screenshot de estructura

---

## Notas

- Los procedimientos deben ser ejecutables a las 3am durante un incidente
- Usar Auto-CoT para razonar sobre pasos criticos
- Validar con Self-Consistency: DevOps, SRE, Dev, DBA
- SIEMPRE incluir rollback completo
- Testear procedimientos en staging antes de produccion
- Los procedimientos son VIVOS: actualizar con cada ejecucion
- Mantener historial de ejecuciones para metricas

---

## Referencias Auto-CoT

**Chain 1 - Ejecutabilidad:**
¿Como asegurar que procedimiento es ejecutable? → Comandos copy-pasteable → Validaciones claras → Resultado esperado especifico → Procedimiento confiable

**Chain 2 - Seguridad:**
¿Como prevenir errores criticos? → Prerequisitos claros → Backups antes de cambios → Validacion en cada paso → Rollback disponible → Operacion segura

**Chain 3 - Mejora Continua:**
¿Como mantener procedimientos actualizados? → Documentar tiempo real → Registrar issues → Actualizar tras ejecucion → Revision periodica → Procedimientos mejoran con uso

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos
**Desviacion vs Estimado:** +/- __ minutos

---

## Checklist de Finalizacion

- [ ] plantilla-procedimiento-backend.md creado con estructura completa
- [ ] Frontmatter YAML validado
- [ ] Secciones de pasos con comandos, validacion, rollback
- [ ] Seccion de troubleshooting completa
- [ ] Rollback completo documentado
- [ ] README.md en carpeta procedures/ creado
- [ ] Procedimiento de ejemplo (PROC-BACKEND-000) creado
- [ ] Validacion Self-Consistency desde 4 perspectivas completada
- [ ] Plantilla revisada por DevOps/SRE
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
