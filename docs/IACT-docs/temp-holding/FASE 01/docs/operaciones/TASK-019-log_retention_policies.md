---
id: TASK-019-log-retention-policies
tipo: documentacion_operaciones
categoria: operaciones
prioridad: P2
story_points: 2
estado: completado
fecha_inicio: 2025-11-07
fecha_fin: 2025-11-07
asignado: devops-lead
relacionados: ["TASK-017", "TASK-018"]
date: 2025-11-13
---

# TASK-019: Log Retention Policies

Configuracion de politicas de retencion de logs y metrics.

## Retention Policies

### Cassandra Logs (Infrastructure Layer 3)

**TTL:** 90 dias automatico
**Configuracion:** `default_time_to_live = 7776000` (90 dias en segundos)
**Auto-expiracion:** SI - Cassandra elimina automaticamente logs antiguos
**Ubicacion:** `scripts/cassandra/schemas/infrastructure_logs.cql`

### MySQL Metrics (DORA)

**Retention:** PERMANENTE (sin TTL)
**Razon:** Metricas DORA son criticas para analytics historicos
**Backup:** Backups diarios via `backup_data_centralization.sh`

### Application Logs (Layer 2)

**Retention:** File rotation - 10 archivos x 100MB = 1GB max
**Configuracion:** Django logging settings (RotatingFileHandler)


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
## Backup Policies

**Frecuencia:** Diario a las 2 AM
**Script:** `scripts/backup_data_centralization.sh`
**Retention backups:** 30 dias

## Cleanup Manual

```bash
# Si necesario, cleanup manual de logs viejos
# (No deberia ser necesario con TTL automatico)
cqlsh -e "DELETE FROM logging.infrastructure_logs WHERE log_date < '2024-08-01';"
```

---

**VERSION:** 1.0.0
**ESTADO:** COMPLETADO
**STORY POINTS:** 2 SP
**FECHA:** 2025-11-07
