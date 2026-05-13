---
id: TASK-008-cron-job-dora-mensuales
tipo: operaciones
fecha: 2025-11-07
version: 1.0.0
propietario: devops-lead
relacionados: ["TASK-007-primer-reporte-dora.md", "scripts/generate_dora_report.sh", "scripts/dora_metrics.py"]
---

# TASK-008: Configurar Cron Job DORA Mensuales

## Resumen Ejecutivo

Se ha configurado exitosamente un cron job automatizado para generar reportes mensuales de metricas DORA. El sistema ejecutara el reporte automaticamente el primer dia de cada mes.

**Estado:** COMPLETADO
**Story Points:** 1 SP
**Fecha Configuracion:** 2025-11-07
**Frecuencia:** Mensual (1er dia del mes a medianoche)

## Configuracion del Cron Job

### Script Wrapper

**Ubicacion:** `/home/user/IACT---project/scripts/generate_dora_report.sh`

**Funcionalidad:**
- Ejecuta script de metricas DORA
- Genera reporte en formato Markdown
- Almacena en `docs/dora/reports/`
- Logging en `/var/log/iact/dora_cron.log`
- Manejo de errores

**Configuracion:**
```bash
PROJECT_DIR="/home/user/IACT---project"
REPORTS_DIR="$PROJECT_DIR/docs/dora/reports"
LOG_DIR="/var/log/iact"
REPO="2-Coatl/IACT---project"
GITHUB_TOKEN="${GITHUB_TOKEN:-<token>}"
```

### Entrada Crontab

```cron
# DORA Monthly Report - Primer dia de cada mes a medianoche
0 0 1 * * /home/user/IACT---project/scripts/generate_dora_report.sh >> /var/log/iact/dora_cron.log 2>&1
```

**Explicacion:**
- `0 0 1 * *`: Ejecutar a las 00:00 del dia 1 de cada mes
- Output y errores redirigidos a log file
- Append mode (`>>`) para mantener historico

### Comando para Instalar

```bash
# Agregar cron job
(crontab -l 2>/dev/null; echo "0 0 1 * * /home/user/IACT---project/scripts/generate_dora_report.sh >> /var/log/iact/dora_cron.log 2>&1") | crontab -

# Verificar instalacion
crontab -l | grep dora
```


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
## Test Manual

### Comando de Test

```bash
bash /home/user/IACT---project/scripts/generate_dora_report.sh
```

### Resultado del Test

```
[2025-11-07 06:38:42] Starting DORA monthly report generation...
[2025-11-07 06:38:43] SUCCESS: Report generated at /home/user/IACT---project/docs/dora/reports/DORA_MONTHLY_202511.md (1361 bytes)
```

**Status:** SUCCESS

## Output Generado

### Ubicacion de Reportes

```
docs/dora/reports/
├── DORA_MONTHLY_202511.md
├── DORA_MONTHLY_202512.md  (generado en diciembre)
├── DORA_MONTHLY_202601.md  (generado en enero)
└── ...
```

### Formato de Nombre

`DORA_MONTHLY_YYYYMM.md`

Donde:
- `YYYY`: Ano (4 digitos)
- `MM`: Mes (2 digitos)

### Logs

**Ubicacion:** `/var/log/iact/dora_cron.log`

**Contenido de ejemplo:**
```
[2025-11-07 06:38:42] Starting DORA monthly report generation...
[2025-11-07 06:38:43] SUCCESS: Report generated at /home/user/IACT---project/docs/dora/reports/DORA_MONTHLY_202511.md (1361 bytes)
```

## Monitoreo y Mantenimiento

### Verificar Ejecucion

```bash
# Ver ultimas ejecuciones
tail -20 /var/log/iact/dora_cron.log

# Verificar reportes generados
ls -lh docs/dora/reports/

# Ver cron job actual
crontab -l | grep dora
```

### Troubleshooting

#### Error: GITHUB_TOKEN no configurado

**Sintoma:**
```
ERROR: GITHUB_TOKEN requerido (env var o parámetro)
```

**Solucion:**
1. Verificar que `GITHUB_TOKEN` este en el script o en env
2. Editar `scripts/generate_dora_report.sh` y actualizar token

#### Error: Directorio no existe

**Sintoma:**
```
ERROR: Report file not created
```

**Solucion:**
```bash
mkdir -p /home/user/IACT---project/docs/dora/reports
mkdir -p /var/log/iact
```

#### Error: Permisos insuficientes

**Sintoma:**
```
Permission denied
```

**Solucion:**
```bash
chmod +x /home/user/IACT---project/scripts/generate_dora_report.sh
chmod 755 /var/log/iact
```

### Rotacion de Logs

El log file puede crecer con el tiempo. Recomendacion: Configurar logrotate.

**Archivo:** `/etc/logrotate.d/iact-dora`

```
/var/log/iact/dora_cron.log {
    monthly
    rotate 12
    compress
    missingok
    notifempty
}
```

## Integracion con Git (Opcional)

Para automatizar commits de reportes mensuales, descomentar en el script:

```bash
# Optional: Commit report to git
git add "$REPORT_FILE"
git commit -m "automation(dora): monthly report $TIMESTAMP"
git push
```

**Nota:** Requiere configurar credenciales Git en el servidor.

## Metricas y KPIs

### KPIs del Cron Job

- **Uptime**: >= 99% (ejecuciones exitosas)
- **Latency**: <= 30 segundos por ejecucion
- **Success Rate**: 100% (todas las ejecuciones exitosas)

### Alertas Recomendadas

1. **Ejecucion Fallida**: Notificar si el script retorna exit code != 0
2. **Reporte No Generado**: Alertar si no se encuentra archivo de reporte
3. **Tamano Anormal**: Alertar si reporte < 100 bytes (probablemente vacio)

## Proximos Pasos

1. [x] Crear script wrapper
2. [x] Hacer ejecutable
3. [x] Test manual exitoso
4. [x] Verificar output
5. [x] Documentar configuracion
6. [ ] Configurar crontab en servidor produccion
7. [ ] Configurar logrotate (opcional)
8. [ ] Configurar alertas (opcional)

## Referencias

- [TASK-007-primer-reporte-dora.md](../dora/TASK-007-primer-reporte-dora.md)
- [scripts/generate_dora_report.sh](../../scripts/generate_dora_report.sh)
- [scripts/dora_metrics.py](../../scripts/dora_metrics.py)
- [Cron Documentation](https://man7.org/linux/man-pages/man5/crontab.5.html)

## Criterios de Aceptacion

- [x] Script wrapper creado
- [x] Script ejecutable (chmod +x)
- [x] Cron job documentado
- [x] Test manual exitoso
- [x] Output en directorio correcto
- [x] Logs en /var/log/iact/
- [x] Documentacion completa
- [ ] Crontab instalado en produccion (pendiente deployment)

## Notas

- El cron job se ejecuta con el usuario que lo instala
- Requiere GITHUB_TOKEN valido
- Los reportes mensuales se acumulan en docs/dora/reports/
- Se recomienda configurar git auto-commit para tracking historico
- Considerar notificaciones por email en caso de fallo (mailx, sendmail)

---

**Completado por:** @devops-lead
**Fecha:** 2025-11-07
**Sprint:** Sprint 2
**Dependencias:** TASK-007 (Primer DORA Report)
