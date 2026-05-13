---
id: TASK-021-alerting-system
tipo: documentacion_observabilidad
categoria: observabilidad
prioridad: P2
story_points: 3
estado: completado
fecha_inicio: 2025-11-07
fecha_fin: 2025-11-07
asignado: backend-lead
relacionados: ["TASK-020", "RNF-002"]
date: 2025-11-13
---

# TASK-021: Alerting System

Sistema de alertas self-hosted compliant con RNF-002 (NO Prometheus/Alertmanager).

## Implementacion

**Tecnologia:** Django Signals + Python logging
**Compliance:** [OK] Self-hosted, NO Prometheus/Alertmanager

## Técnicas de Prompt Engineering para Agente

Las siguientes técnicas deben aplicarse al ejecutar esta tarea con un agente:

1. **Tool-use Prompting** (knowledge_techniques.py)
 - Configurar dashboards, queries y alertas de monitoreo

2. **Expert Prompting** (specialized_techniques.py)
 - Aplicar conocimiento experto de observabilidad y SRE practices

3. **Task Decomposition** (structuring_techniques.py)
 - Dividir setup de observabilidad en layers (metrics, logs, traces)

4. **Constitutional AI** (optimization_techniques.py)
 - Validar que alertas y dashboards cumplan con SLOs/SLIs

5. **Simulation** (specialized_techniques.py)
 - Simular escenarios de fallo para validar alertas

Agente recomendado: SDLCPlannerAgent o PDCAAutomationAgent
## Arquitectura

```
Alert Triggers → Django Signals → Handlers → Notifications
 ↓ ↓ ↓
check_health() critical_alert logging
 warning_alert (email)
```

## Alertas Implementadas

### 1. DORA Metrics Alerts

**check_dora_metrics_health():**
- No deployments en 7 dias → CRITICAL
- Change failure rate >20% → WARNING

### 2. System Health Alerts

**check_system_health():**
- Session table >100K → CRITICAL
- Session table >50K → WARNING

## Escalation Policies

**CRITICAL:**
1. Log en /var/log/iact/
2. Notification via logging handler
3. TODO: Email/Slack notification

**WARNING:**
1. Log en /var/log/iact/
2. Notification via logging handler

## Ejecucion

```python
# Manual check
from dora_metrics.alerts import check_dora_metrics_health, check_system_health
check_dora_metrics_health()
check_system_health()
```

**Automatico:** Via cron (cada hora recomendado)

```bash
# Agregar a crontab
0 * * * * cd /home/user/IACT---project/api/callcentersite && python manage.py shell -c "from dora_metrics.alerts import check_dora_metrics_health, check_system_health; check_dora_metrics_health(); check_system_health()"
```

## Configuracion

**Ubicacion:** `api/callcentersite/dora_metrics/alerts.py`

**Signals:**
- `critical_alert` - Alertas criticas
- `warning_alert` - Alertas de warning

## Notificaciones (Futuro)

```python
# Email notifications
def send_email_alert(level, message, context):
 send_mail(
 subject=f'[{level}] IACT Alert',
 message=f'{message}\n\nContext: {context}',
 from_email='alerts@iact.com',
 recipient_list=['admin@iact.com']
 )

# Slack/Webhook notifications
def send_webhook_alert(level, message, context):
 import requests
 requests.post(
 'https://hooks.slack.com/...',
 json={'text': f'[{level}] {message}'}
 )
```

## Compliance RNF-002

[OK] NO usa Prometheus
[OK] NO usa Alertmanager
[OK] Self-hosted (Django signals)
[OK] NO usa servicios externos

---

**VERSION:** 1.0.0
**ESTADO:** COMPLETADO
**STORY POINTS:** 3 SP
**FECHA:** 2025-11-07
