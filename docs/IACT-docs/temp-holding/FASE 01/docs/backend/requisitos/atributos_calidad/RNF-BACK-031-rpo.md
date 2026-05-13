---
id: RNF-BACK-031
tipo: atributo_calidad
subtipo: disponibilidad
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: alta
---

# RNF-BACK-031: RPO (Recovery Point Objective) < 1 hora

## Categoría

Disponibilidad

## Descripción

El sistema backend debe garantizar que en caso de fallo catastrófico, la pérdida máxima de datos sea de 1 hora, implementando backups y replicación apropiados para cumplir con el Recovery Point Objective (RPO).

## Métrica Medible

**Métrica**: Recovery Point Objective (RPO) - máxima pérdida de datos aceptable

**Valor objetivo**: < 1 hora (pérdida máxima de 1 hora de datos)

**Condiciones**:
- Medido en caso de fallo completo de base de datos
- Aplica a PostgreSQL (analytics) y MariaDB (IVR legacy)
- Basado en frecuencia de backups y replicación

## Método de Medición

**Herramienta de medición**:
- Revisión de logs de backup
- Tests de restore desde backup
- Análisis de timestamps de backups

**Frecuencia de medición**: Mensual (test de restore) + auditoría trimestral

**Proceso de medición**:
1. Revisar schedule de backups configurado
2. Verificar que backups se ejecutan cada hora (o replicación continua)
3. Ejecutar test de restore desde último backup
4. Medir tiempo transcurrido desde backup hasta "ahora"
5. Verificar que tiempo < 1 hora

**Responsable de medición**: DevOps + DBA

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. **Backups**: Ejecutados cada hora (automated)
2. **Replicación**: Replicación continua a standby (streaming replication)
3. **Verificación**: Backups verificados mensualmente con test restore
4. **Retención**: Backups mantenidos >= 30 días
5. **Storage**: Backups almacenados off-site (diferente ubicación física)

**Umbrales**:
- **Mínimo aceptable**: RPO < 4 horas (backups cada 4h)
- **Objetivo**: RPO < 1 hora (backups cada 1h o replicación)
- **Óptimo**: RPO < 5 min (replicación síncrona)

## Alcance

**Aplica a**: Todas las bases de datos del sistema

**Módulos/Componentes afectados**:
- PostgreSQL database (analytics data)
- MariaDB database (IVR legacy data)
- Archivos de configuración críticos
- Archivos de media/uploads (si hay)

**Excepciones**:
- Redis cache (datos volátiles, no requiere backup)
- Logs (respaldados pero RPO más relajado)

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- Todos los casos de uso (protección de datos)

**Derivado de Reglas de Negocio**:
- RN-DATA-001: Datos de llamadas deben ser preservados

**Relacionado con Requerimientos de Negocio**:
- RNEG-DATA-001: Garantizar integridad y disponibilidad de datos históricos

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-180: Configurar pg_basebackup para backups PostgreSQL
- RF-BACK-181: Configurar mysqldump para backups MariaDB
- RF-BACK-182: Script de backup automatizado cada hora (cron)
- RF-BACK-183: Almacenar backups en S3/almacenamiento off-site

**Tests de Validación**:
- TS-RNF-031-001: Test restore PostgreSQL desde backup de 1h atrás
- TS-RNF-031-002: Test restore MariaDB desde backup de 1h atrás
- TS-RNF-031-003: Verificar backups se ejecutan cada hora

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Implementar backups automatizados cada hora vía cron
- Configurar PostgreSQL streaming replication (opcional para RPO óptimo)
- Almacenar backups en S3 o almacenamiento externo
- Implementar script de verificación de backups

**Componentes/Patrones requeridos**:
- pg_basebackup + WAL archiving (PostgreSQL)
- mysqldump (MariaDB)
- Cron jobs para automatización
- S3/Cloud Storage para almacenamiento off-site
- Monitoring de success/failure de backups

## Validación

**Tipo de validación**: Test de restore mensual

**Frecuencia de validación**: Mensual (test de restore completo)

**Criterio de éxito de validación**:
- Backup de hace <= 1h se puede restaurar exitosamente
- Restore completa en tiempo razonable (< RTO)
- Datos restaurados son consistentes y válidos

**Acción si no se cumple**:
- Investigar fallo de backup
- Corregir configuración de cron/backup scripts
- Alertar inmediatamente si backup falla

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
Datos de llamadas son activo crítico del negocio; pérdida es inaceptable

**Riesgos si no se cumple**:
- Pérdida de datos de llamadas
- Incapacidad de generar reportes históricos
- Incumplimiento de obligaciones regulatorias
- Pérdida de información de facturación

**Impacto de no cumplimiento**: Crítico

## Estado de Cumplimiento

**Estado actual**: Parcialmente implementado

**Última medición**: 2025-01-17

**Último valor medido**: Backups diarios (RPO ~24h) - NO cumple

**Comparación con objetivo**: No cumple

**Acciones correctivas**:
- Cambiar cron de backups de diario a horario
- Implementar PostgreSQL WAL archiving
- Configurar S3 para almacenamiento off-site
- Implementar monitoreo de backups

## Dependencias

**Dependencias técnicas**:
- PostgreSQL pg_basebackup
- MariaDB mysqldump
- Cron para scheduling
- S3 o cloud storage
- Monitoring de backups

**Dependencias de otros RNF**:
- RNF-BACK-032: RTO (backups deben ser restaurables en < RTO)
- RNF-BACK-033: Backup diario automático (requisito base)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | < 1h |

## Aprobación

**Especificado por**: Equipo de Arquitectura + DevOps + DBA IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
