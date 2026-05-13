# Procedimientos Operacionales - Backend

Runbooks y procedimientos estandarizados para operaciones del backend.

---

## ¿Qué es un Procedimiento Operacional?

Un procedimiento operacional (también conocido como runbook o playbook) es un documento que describe paso a paso cómo ejecutar una tarea operacional específica. Los procedimientos ayudan a:

- **Estandarizar operaciones** críticas
- **Reducir errores** humanos
- **Facilitar onboarding** de nuevos miembros del equipo
- **Asegurar consistencia** entre ejecuciones
- **Documentar rollbacks** para casos de emergencia
- **Reducir MTTR** (Mean Time To Recovery)

---

## Tipos de Procedimientos

### 1. Deployment
Despliegues de código a diferentes ambientes.

**Ejemplos:**
- Deployment a staging
- Deployment a producción
- Hotfix deployment
- Canary deployment
- Blue-green deployment

### 2. Rollback
Reversión de cambios cuando algo falla.

**Ejemplos:**
- Rollback de deployment
- Rollback de migración de DB
- Emergency rollback
- Rollback parcial

### 3. Maintenance
Mantenimiento rutinario del sistema.

**Ejemplos:**
- Database backup y restore
- Log rotation y cleanup
- Limpieza de datos obsoletos
- Actualización de dependencias
- Renovación de certificados SSL

### 4. Troubleshooting
Diagnóstico y resolución de incidentes.

**Ejemplos:**
- Debugging de alta latencia
- Investigación de memory leaks
- Resolución de problemas de DB
- Troubleshooting de API errors
- Análisis de CPU spikes

### 5. Scaling
Escalado horizontal o vertical del sistema.

**Ejemplos:**
- Añadir nodes al cluster
- Incrementar recursos de DB
- Configurar auto-scaling
- Load balancer configuration

### 6. Disaster Recovery
Recuperación ante desastres.

**Ejemplos:**
- Restauración completa del sistema
- Failover a región secundaria
- Recuperación de datos perdidos
- Incident response

---

## Cómo Crear un Procedimiento

### 1. ¿Cuándo crear un procedimiento?

Crea un procedimiento cuando una tarea operacional:

- [ ] Se ejecuta **regularmente** (diario, semanal, mensual)
- [ ] Es **crítica** para el negocio
- [ ] Es **compleja** con múltiples pasos
- [ ] Tiene **alto riesgo** de error humano
- [ ] Requiere **coordinación** entre varios sistemas
- [ ] Necesita ser ejecutada por **diferentes personas**
- [ ] Tiene **impacto en producción**

### 2. Proceso de Creación

```bash
# Paso 1: Copiar la plantilla
cp plantilla-procedimiento-backend.md PROC-BACKEND-XXX-titulo-descriptivo.md

# Paso 2: Completar el procedimiento
# - Reemplazar XXX con el siguiente número secuencial
# - Documentar cada paso con comandos ejecutables
# - Incluir validaciones después de cada paso
# - Documentar rollback para cada paso crítico

# Paso 3: Testear en staging/pre-prod
# - Ejecutar el procedimiento completo en staging
# - Validar que todos los comandos funcionan
# - Verificar que el rollback funciona
# - Documentar problemas encontrados

# Paso 4: Crear PR
git checkout -b proc/backend-xxx-titulo
git add PROC-BACKEND-XXX-titulo-descriptivo.md
git commit -m "docs(procedures): añadir PROC-BACKEND-XXX [tema]"
git push origin proc/backend-xxx-titulo

# Paso 5: Revisión
# - Solicitar revisión de DevOps/SRE/Tech Lead
# - Ejecutar con supervisión al menos 1 vez
# - Incorporar feedback

# Paso 6: Aprobación
# - Actualizar con lecciones aprendidas
# - Mergear PR
# - Comunicar procedimiento al equipo
```

### 3. Numeración de Procedimientos

- Formato: `PROC-BACKEND-001`, `PROC-BACKEND-002`, etc.
- **Números secuenciales** (no reutilizar números)
- Ver último procedimiento para siguiente número disponible
- Usar números con 3 dígitos (001, 002, ... 010, 011)

---

## Plantillas Disponibles

- [`plantilla-procedimiento-backend.md`](./plantilla-procedimiento-backend.md) - Plantilla estándar para procedimientos operacionales

---

## Índice de Procedimientos

### Por Criticidad

#### CRITICA
| ID | Título | Tipo | Frecuencia | Duración |
|----|--------|------|-----------|----------|
| [PROC-BACKEND-001](./PROC-BACKEND-001-ejemplo.md) | Ejemplo de Procedimiento | Ejemplo | On-demand | 15min |

<!-- Añadir procedimientos críticos aquí -->

#### ALTA
| ID | Título | Tipo | Frecuencia | Duración |
|----|--------|------|-----------|----------|

<!-- Añadir procedimientos de alta prioridad aquí -->

#### MEDIA
| ID | Título | Tipo | Frecuencia | Duración |
|----|--------|------|-----------|----------|

<!-- Añadir procedimientos de media prioridad aquí -->

### Por Tipo

#### Deployment
- Ninguno aún

#### Rollback
- Ninguno aún

#### Maintenance
- Ninguno aún

#### Troubleshooting
- Ninguno aún

#### Scaling
- Ninguno aún

#### Disaster Recovery
- Ninguno aún

---

## Criticidad de Procedimientos

### CRITICA
- Afecta producción directamente
- Downtime esperado
- Requiere aprobación de Tech Lead/Management
- Debe tener rollback bien definido
- Requiere comunicación a stakeholders

**Ejemplos:** Deployment a producción, failover de DB, disaster recovery

### ALTA
- Afecta sistemas importantes
- Riesgo medio de downtime
- Requiere revisión de DevOps/SRE
- Debe testearse en staging primero

**Ejemplos:** Migraciones de DB, actualizaciones de seguridad, scaling

### MEDIA
- Operaciones rutinarias
- Bajo riesgo
- Seguir proceso estándar

**Ejemplos:** Backups, log cleanup, monitoreo

### BAJA
- Mantenimiento menor
- Sin impacto en producción
- Documentar para referencia

**Ejemplos:** Actualización de docs, configuración de dev environment

---

## Mejores Prácticas

### Al Escribir un Procedimiento

1. **Comandos copy-pasteable:** Todos los comandos deben ser ejecutables sin modificación
2. **Validaciones claras:** Después de cada paso, incluir comando de validación
3. **Resultado esperado:** Documentar qué salida esperar de cada comando
4. **Rollback para todo:** Cada paso crítico debe tener rollback documentado
5. **Tiempo estimado:** Incluir duración estimada por paso y total
6. **Troubleshooting:** Documentar problemas comunes y soluciones
7. **Prerequisitos claros:** Listar todos los permisos, herramientas y conocimientos necesarios

### Al Ejecutar un Procedimiento

1. **Leer completo primero:** No empezar hasta haber leído todo
2. **Verificar prerequisitos:** Asegurar que se cumplen todos antes de empezar
3. **Crear backup:** Siempre crear backup antes de cambios
4. **Notificar al equipo:** Comunicar inicio y fin del procedimiento
5. **Validar cada paso:** No continuar si un paso falla
6. **Documentar desvíos:** Registrar cualquier problema o diferencia
7. **Actualizar procedimiento:** Añadir lecciones aprendidas después

### Al Revisar un Procedimiento

1. **Testear en staging:** Ejecutar procedimiento completo en staging
2. **Validar comandos:** Verificar que todos los comandos son correctos
3. **Verificar rollback:** Asegurar que el rollback funciona
4. **Revisar tiempo:** Validar estimaciones de duración
5. **Revisar criticidad:** Confirmar nivel de criticidad asignado

---

## Mantenimiento de Procedimientos

### Revisión Periódica

Los procedimientos deben revisarse según su frecuencia de uso:

- **Procedimientos diarios/semanales:** Revisar cada 3 meses
- **Procedimientos mensuales:** Revisar cada 6 meses
- **Procedimientos trimestrales/on-demand:** Revisar cada año

### Actualización Post-Ejecución

Después de cada ejecución:

- Actualizar tiempo real de ejecución
- Registrar tasa de éxito
- Documentar problemas encontrados
- Añadir a troubleshooting si es nuevo
- Actualizar comandos si cambiaron

### Versionado

- Usar versionado semántico: `X.Y.Z`
- **MAJOR (X):** Cambios que rompen compatibilidad (pasos nuevos/removidos)
- **MINOR (Y):** Mejoras o pasos opcionales añadidos
- **PATCH (Z):** Correcciones menores, typos

---

## Ejecución Durante Incidentes

### Procedimientos de Emergencia

Para incidentes en producción:

1. **Identificar el incidente:** Determinar qué está fallando
2. **Buscar procedimiento:** Verificar si hay runbook aplicable
3. **Seguir procedimiento:** Ejecutar paso a paso, no improvisar
4. **Escalar si necesario:** Si procedimiento no resuelve, escalar
5. **Documentar:** Registrar todo lo que se hizo (incident report)

### Modificaciones On-the-Fly

Si durante un incidente necesitas desviarte del procedimiento:

- Documentar exactamente qué hiciste diferente
- Explicar por qué te desviaste
- Actualizar procedimiento después con lecciones aprendidas
- Nunca modificar procedimiento durante el incidente

---

## Métricas y KPIs

### Métricas por Procedimiento

Trackear para cada procedimiento:

- Número de ejecuciones
- Tasa de éxito (% de ejecuciones exitosas)
- Tiempo promedio de ejecución
- Número de rollbacks ejecutados
- Tiempo promedio de rollback

### Métricas Globales

- Total de procedimientos documentados
- % de procedimientos testeados en último trimestre
- % de operaciones críticas con procedimiento documentado
- MTTR (Mean Time To Recovery) usando procedimientos

---

## Seguridad y Compliance

### Información Sensible

- **NUNCA** incluir credenciales en procedimientos
- **USAR** variables de entorno para secrets: `${DB_PASSWORD}`
- **REFERENCIAR** donde obtener credenciales: "Ver 1Password vault X"
- **DOCUMENTAR** qué permisos se necesitan sin revelar credenciales

### Auditoría

- Todos los procedimientos críticos deben ser auditables
- Registrar quién ejecutó qué y cuándo
- Mantener logs de ejecución por al menos 90 días

---

## Contribuir Nuevos Procedimientos

### Criterios de Aceptación

Un procedimiento debe:

- [ ] Resolver necesidad operacional recurrente
- [ ] Estar testeado en staging
- [ ] Incluir todos los prerequisitos
- [ ] Tener rollback documentado (si aplica)
- [ ] Incluir validaciones por paso
- [ ] Documentar troubleshooting común
- [ ] Ser revisado por al menos 1 DevOps/SRE
- [ ] Estar documentado en este índice

### Proceso

1. Crear procedimiento usando plantilla
2. Testear en staging al menos 1 vez
3. Añadir entrada en tabla de índice
4. Crear PR con título "docs(procedures): añadir PROC-BACKEND-XXX"
5. Solicitar revisión de DevOps/SRE/Tech Lead
6. Ejecutar con supervisión en producción
7. Mergear tras aprobación

---

## Plantillas y Recursos

- [Plantilla de Procedimiento](./plantilla-procedimiento-backend.md)
- [ADRs Backend](../arquitectura/decisions/README.md)
- [Disaster Recovery Plan](../../operaciones/disaster_recovery.md)
- [Incident Response Plan](../../operaciones/incident_response.md)

---

## Contacto

**Maintainer:** DevOps Team / SRE
**Revisores:** Tech Lead, DevOps Lead
**Slack:** #backend-operations
**Issues:** Reportar en GitHub con label `procedures`

---

**Última actualización:** 2025-11-18
**Versión:** 1.0.0
