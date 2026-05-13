---
id: RNF-BACK-024
tipo: atributo_calidad
subtipo: seguridad
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: alta
---

# RNF-BACK-024: Auditoría de Acciones Críticas

## Categoría

Seguridad

## Descripción

El sistema backend debe registrar (loguear) todas las acciones críticas de seguridad y negocio para permitir auditorías, detección de anomalías, investigación forense, y cumplimiento de regulaciones.

## Métrica Medible

**Métrica**: Porcentaje de acciones críticas logueadas

**Valor objetivo**: 100% de acciones críticas registradas

**Condiciones**:
- Logs estructurados en formato JSON
- Incluir: timestamp, user_id, action, resource, IP, resultado
- Almacenamiento >= 90 días
- Logs inmutables (append-only)

## Método de Medición

**Herramienta de medición**:
- Revisión de código para verificar logging
- Análisis de logs en producción
- Tests automatizados de auditoría

**Frecuencia de medición**: Por cada release + auditoría mensual

**Proceso de medición**:
1. Identificar acciones críticas en código
2. Verificar que cada acción tiene logging statement
3. Ejecutar acción crítica en staging
4. Verificar que se generó log con campos requeridos
5. Confirmar que 100% de acciones críticas están logueadas

**Responsable de medición**: Equipo Backend + Seguridad + Compliance

## Criterios de Aceptación

**Criterios de cumplimiento - Acciones Críticas a Loguear**:
1. **Autenticación**: Login (exitoso/fallido), logout, cambio contraseña
2. **Autorización**: Concesiones/revocaciones de permisos
3. **Datos sensibles**: Acceso a información confidencial
4. **Cambios críticos**: Modificación de configuración, eliminación de datos
5. **Admin**: Todas las acciones en Django Admin

**Formato de Log**:
```json
{
 "timestamp": "2025-01-17T10:30:45Z",
 "user_id": 123,
 "username": "jperez",
 "action": "LOGIN_SUCCESS",
 "resource": "User",
 "ip_address": "192.168.1.100",
 "user_agent": "Mozilla/5.0...",
 "result": "success",
 "details": {...}
}
```

**Umbrales**:
- **Mínimo aceptable**: 90% de acciones críticas logueadas
- **Objetivo**: 100% de acciones críticas logueadas
- **Óptimo**: 100% + análisis automático de anomalías

## Alcance

**Aplica a**: Todas las acciones críticas del sistema

**Módulos/Componentes afectados**:
- Autenticación (login, logout, cambio contraseña)
- Permisos (concesiones, revocaciones)
- Django Admin (todas las acciones)
- APIs de datos sensibles (llamadas, analytics)
- Configuración del sistema

**Excepciones**:
- Acciones de solo lectura no críticas (ej: ver dashboard)

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- UC-AUTH-001: Iniciar Sesión (loguear)
- UC-PERM-005: Conceder Permiso (loguear)
- UC-PERM-006: Revocar Permiso (loguear)
- UC-ADMIN-*: Todas las acciones admin

**Derivado de Reglas de Negocio**:
- RN-SEC-005: Acciones críticas deben ser auditables

**Relacionado con Requerimientos de Negocio**:
- RNEG-COMPLIANCE-001: Cumplir con requisitos de auditoría

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-140: Implementar AuditLog middleware
- RF-BACK-141: Loguear todas las autenticaciones
- RF-BACK-142: Loguear cambios en permisos
- RF-BACK-143: Loguear acciones en Django Admin

**Tests de Validación**:
- TS-RNF-024-001: Test login genera log con campos requeridos
- TS-RNF-024-002: Test concesión permiso genera log
- TS-RNF-024-003: Test logs son inmutables

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Implementar AuditLog middleware para capturar acciones
- Usar python logging con JSONFormatter
- Almacenar logs en sistema append-only (ELK stack o similar)
- Implementar rotación de logs con retención >= 90 días

**Componentes/Patrones requeridos**:
- Django Middleware: AuditLogMiddleware
- python-json-logger: Logs estructurados JSON
- ELK Stack (Elasticsearch, Logstash, Kibana): Almacenamiento y análisis
- Audit Trail: Modelo para acciones críticas

## Validación

**Tipo de validación**: Tests automatizados + auditoría manual

**Frecuencia de validación**: Por cada release + auditoría mensual

**Criterio de éxito de validación**:
- Todas las acciones críticas generan log
- Logs contienen campos requeridos
- Logs son searchable en ELK

**Acción si no se cumple**:
- Bloquear release si acción crítica no genera log
- Agregar logging a código faltante
- Revisar configuración de logging

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
Auditoría es crítica para seguridad, compliance, y detección de incidentes

**Riesgos si no se cumple**:
- Incapacidad de investigar incidentes de seguridad
- Incumplimiento de regulaciones de auditoría
- Sin evidencia para análisis forense
- Detección tardía de anomalías

**Impacto de no cumplimiento**: Alto

## Estado de Cumplimiento

**Estado actual**: Parcialmente implementado

**Última medición**: 2025-01-17

**Último valor medido**: ~40% (solo algunas acciones auth logueadas)

**Comparación con objetivo**: No cumple

**Acciones correctivas**:
- Implementar AuditLogMiddleware completo
- Agregar logging a todas las acciones críticas identificadas
- Configurar ELK stack para almacenamiento centralizado
- Crear dashboard de auditoría en Kibana

## Dependencias

**Dependencias técnicas**:
- python-json-logger
- ELK Stack (Elasticsearch, Logstash, Kibana)
- Django middleware custom
- Filebeat para shipping de logs

**Dependencias de otros RNF**:
- RNF-BACK-052: Logs estructurados (formato JSON)
- RNF-BACK-020: OWASP compliance (logging es parte de A09)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | 100% logged |

## Aprobación

**Especificado por**: Equipo de Seguridad + Compliance + Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
