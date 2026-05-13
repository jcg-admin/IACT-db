---
id: RNF-BACK-032
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

# RNF-BACK-032: RTO (Recovery Time Objective) < 4 horas

## Categoría

Disponibilidad

## Descripción

El sistema backend debe poder ser restaurado completamente en menos de 4 horas en caso de fallo catastrófico, minimizando el tiempo de inactividad prolongada y permitiendo la reanudación de operaciones del call center.

## Métrica Medible

**Métrica**: Recovery Time Objective (RTO) - tiempo máximo para restaurar servicio completo

**Valor objetivo**: < 4 horas

**Condiciones**:
- Medido desde detección de fallo hasta sistema 100% operacional
- Incluye: restore de backups, verificación, smoke tests
- Asume que backups están disponibles y válidos

## Método de Medición

**Herramienta de medición**:
- Simulacros de disaster recovery (DR drills)
- Documentación de procedimientos de restore
- Cronómetro durante ejecución de DR drill

**Frecuencia de medición**: Trimestral (DR drill completo)

**Proceso de medición**:
1. Programar DR drill trimestral
2. Simular fallo catastrófico (destruir BD de staging)
3. Iniciar cronómetro
4. Ejecutar procedimiento de restore documentado
5. Detener cronómetro cuando sistema está operacional
6. Verificar que tiempo total < 4 horas

**Responsable de medición**: DevOps + DBA + Arquitectura

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. **Procedimiento Documentado**: Runbook de disaster recovery paso a paso
2. **Restore Time**: Restore de backup completa en < 2 horas
3. **Verification Time**: Verificación y smoke tests en < 1 hora
4. **Total RTO**: Tiempo total < 4 horas
5. **Automation**: Restore parcialmente automatizado (scripts)

**Umbrales**:
- **Mínimo aceptable**: RTO < 8 horas
- **Objetivo**: RTO < 4 horas
- **Óptimo**: RTO < 1 hora (requiere HA/failover automático)

## Alcance

**Aplica a**: Sistema backend completo

**Módulos/Componentes afectados**:
- PostgreSQL database restore
- MariaDB database restore
- Gunicorn/Django application deployment
- Nginx configuration
- Redis configuration (si necesario)

**Excepciones**:
- Datos cached en Redis (se regeneran automáticamente)

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- Todos los casos de uso (recuperación de servicio)

**Derivado de Reglas de Negocio**:
- RN-AVAILABILITY-002: Sistema debe recuperarse rápidamente de fallos

**Relacionado con Requerimientos de Negocio**:
- RNEG-AVAILABILITY-002: Minimizar impacto de downtime en operaciones

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-190: Documentar runbook de disaster recovery
- RF-BACK-191: Script de restore automatizado para PostgreSQL
- RF-BACK-192: Script de restore automatizado para MariaDB
- RF-BACK-193: Checklist de verificación post-restore

**Tests de Validación**:
- TS-RNF-032-001: DR drill trimestral completo
- TS-RNF-032-002: Test restore PostgreSQL (medir tiempo)
- TS-RNF-032-003: Test smoke tests post-restore

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Crear runbook detallado de disaster recovery
- Automatizar pasos de restore con scripts
- Documentar dependencias y orden de inicio de servicios
- Implementar smoke tests para verificación rápida

**Componentes/Patrones requeridos**:
- Disaster Recovery Runbook: Procedimiento paso a paso
- Restore Scripts: Automatización parcial
- Smoke Tests: Verificación rápida de funcionalidad crítica
- Monitoring: Para detectar fallos rápidamente

## Validación

**Tipo de validación**: Disaster Recovery Drill trimestral

**Frecuencia de validación**: Trimestral (cada 3 meses)

**Criterio de éxito de validación**:
- DR drill completa en < 4 horas
- Sistema completamente funcional después de restore
- Todos los smoke tests pasan

**Acción si no se cumple**:
- Analizar cuellos de botella en procedimiento
- Automatizar pasos manuales lentos
- Mejorar documentación de runbook
- Optimizar proceso de restore

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
Downtime prolongado (> 4h) es inaceptable para operación de call center

**Riesgos si no se cumple**:
- Downtime prolongado afecta operaciones críticas
- Pérdida de ingresos por horas de inactividad
- Incumplimiento de SLA
- Daño reputacional

**Impacto de no cumplimiento**: Alto

## Estado de Cumplimiento

**Estado actual**: No implementado (sin DR drill ejecutado)

**Última medición**: N/A

**Último valor medido**: Desconocido (nunca medido)

**Comparación con objetivo**: Desconocido

**Acciones correctivas**:
- Documentar runbook de disaster recovery
- Crear scripts de restore automatizados
- Programar primer DR drill
- Medir RTO real y ajustar procedimiento

## Dependencias

**Dependencias técnicas**:
- Backups válidos disponibles (RNF-BACK-031)
- Runbook documentado y actualizado
- Scripts de restore
- Equipo entrenado en procedimiento

**Dependencias de otros RNF**:
- RNF-BACK-031: RPO (backups deben existir para restore)
- RNF-BACK-033: Backup automático (backups disponibles)
- RNF-BACK-030: Uptime (RTO es parte de disponibilidad)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | < 4h |

## Aprobación

**Especificado por**: Equipo de Arquitectura + DevOps + DBA IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
