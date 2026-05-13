---
id: RNF-BACK-033
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

# RNF-BACK-033: Backup Diario Automático

## Categoría

Disponibilidad

## Descripción

El sistema backend debe ejecutar backups completos automáticos diarios de todas las bases de datos y configuraciones críticas, garantizando que siempre exista un punto de restore reciente y confiable.

## Métrica Medible

**Métrica**: Frecuencia y éxito de backups automatizados

**Valor objetivo**:
- Backups completos: 1 vez al día (diario)
- Backups incrementales: Cada hora (para cumplir RPO)
- Tasa de éxito: >= 99% mensual

**Condiciones**:
- Ejecutados automáticamente vía cron
- Verificados automáticamente (corruption check)
- Almacenados off-site (S3 o similar)
- Retención: 30 días completos, 90 días semanales, 1 año mensuales

## Método de Medición

**Herramienta de medición**:
- Logs de cron jobs de backup
- Monitoreo de success/failure de backups
- Verificación de tamaño y presencia de archivos en S3

**Frecuencia de medición**: Diaria (verificación automática)

**Proceso de medición**:
1. Verificar que cron job de backup se ejecutó
2. Verificar exit code del script de backup (0 = success)
3. Verificar que archivo de backup existe en S3
4. Verificar tamaño de archivo (debe ser > tamaño mínimo esperado)
5. Calcular tasa de éxito mensual: (Backups exitosos / Total días) * 100

**Responsable de medición**: DevOps (automatizado con alerting)

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. **Frecuencia**: Backup completo diario (ejecutado a las 2 AM)
2. **Cobertura**: PostgreSQL + MariaDB + config files
3. **Verificación**: Backup verificado automáticamente (pg_restore --list)
4. **Storage**: Almacenado en S3 o almacenamiento off-site
5. **Retención**:
 - Diarios: 30 días
 - Semanales: 90 días
 - Mensuales: 1 año
6. **Alerting**: Notificación inmediata si backup falla

**Umbrales**:
- **Mínimo aceptable**: Tasa de éxito >= 95% mensual
- **Objetivo**: Tasa de éxito >= 99% mensual
- **Óptimo**: Tasa de éxito = 100% mensual

## Alcance

**Aplica a**: Todos los datos críticos del sistema

**Módulos/Componentes afectados**:
- PostgreSQL database (analytics)
- MariaDB database (IVR legacy)
- Django settings files (configuración)
- Nginx/Apache config
- SSL certificates
- Media files (si hay uploads)

**Excepciones**:
- Redis (cache volátil, no requiere backup)
- Logs temporales (tienen backup separado con retención más corta)

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- Todos los casos de uso (protección de datos)

**Derivado de Reglas de Negocio**:
- RN-DATA-002: Backups deben ejecutarse automáticamente

**Relacionado con Requerimientos de Negocio**:
- RNEG-DATA-001: Garantizar integridad y disponibilidad de datos

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-200: Script backup-databases.sh ejecutado por cron diario
- RF-BACK-201: Upload de backups a S3 después de creación
- RF-BACK-202: Verificación automática de backups (pg_restore --list)
- RF-BACK-203: Rotación automática según política de retención
- RF-BACK-204: Alerting si backup falla (email + Slack)

**Tests de Validación**:
- TS-RNF-033-001: Test script de backup genera archivo válido
- TS-RNF-033-002: Test backup se sube a S3 correctamente
- TS-RNF-033-003: Test alerting funciona si backup falla

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Crear script backup-databases.sh unificado
- Configurar cron job para ejecución diaria (2 AM)
- Implementar verificación automática de backups
- Configurar S3 bucket con lifecycle policies para retención

**Componentes/Patrones requeridos**:
- Cron: Scheduling de backups
- pg_dump / mysqldump: Herramientas de backup
- S3 CLI: Upload a almacenamiento off-site
- Monitoring: Healthchecks.io o similar para alerting
- Rotation Scripts: Implementar política de retención

## Validación

**Tipo de validación**: Monitoreo diario automatizado

**Frecuencia de validación**: Diaria (automatizada)

**Criterio de éxito de validación**:
- Backup ejecutado exitosamente cada día
- Archivo de backup presente en S3
- Verificación de backup exitosa
- Tasa de éxito mensual >= 99%

**Acción si no se cumple**:
- Alerta inmediata por email/Slack
- Investigación de causa raíz
- Re-ejecución manual si necesario
- Corrección de configuración

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
Backups son la última línea de defensa contra pérdida de datos

**Riesgos si no se cumple**:
- Pérdida total de datos en caso de fallo catastrófico
- Incapacidad de cumplir RPO/RTO
- Violación de obligaciones regulatorias
- Daño irreparable a negocio

**Impacto de no cumplimiento**: Crítico

## Estado de Cumplimiento

**Estado actual**: Parcialmente implementado

**Última medición**: 2025-01-17

**Último valor medido**: Backups manuales esporádicos (no automatizados)

**Comparación con objetivo**: No cumple

**Acciones correctivas**:
- Crear script backup-databases.sh
- Configurar cron job diario
- Configurar S3 bucket para backups
- Implementar verificación automática
- Configurar alerting (Healthchecks.io)

## Dependencias

**Dependencias técnicas**:
- Cron configurado y funcionando
- S3 bucket con credenciales
- pg_dump / mysqldump instalados
- AWS CLI para S3 upload
- Healthchecks.io para monitoring

**Dependencias de otros RNF**:
- RNF-BACK-031: RPO (backups son necesarios para cumplir RPO)
- RNF-BACK-032: RTO (backups válidos son necesarios para restore)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | Diario |

## Aprobación

**Especificado por**: Equipo de Arquitectura + DevOps + DBA IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
