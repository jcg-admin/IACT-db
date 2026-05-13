---
id: RNF-BACK-052
tipo: atributo_calidad
subtipo: usabilidad
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: media
---

# RNF-BACK-052: Logs Estructurados (JSON, ELK)

## Categoría

Usabilidad (para DevOps y debugging)

## Descripción

El sistema backend debe generar logs estructurados en formato JSON que puedan ser fácilmente parseados, indexados y buscados en un stack ELK (Elasticsearch, Logstash, Kibana) para facilitar debugging y monitoreo.

## Métrica Medible

**Métrica**: Porcentaje de logs en formato JSON estructurado

**Valor objetivo**: 100% de logs en formato JSON

**Condiciones**:
- Logs de aplicación en JSON
- Logs incluyen: timestamp, level, logger, message, context
- Compatible con ELK stack
- Logs de acceso en formato estructurado

## Método de Medición

**Herramienta de medición**: Inspección de logs

**Frecuencia de medición**: Por cada release

**Proceso de medición**:
1. Revisar archivo de logs de aplicación
2. Verificar que cada línea es JSON válido
3. Verificar que contiene campos estándar
4. Probar parsing en Elasticsearch
5. Verificar que 100% de logs son JSON

**Responsable de medición**: DevOps + Backend

## Criterios de Aceptación

**Formato de log estructurado**:
```json
{
 "timestamp": "2025-01-17T10:30:45.123Z",
 "level": "INFO",
 "logger": "apps.llamadas.views",
 "message": "Llamada registrada exitosamente",
 "context": {
 "user_id": 123,
 "llamada_id": 456,
 "ip_address": "192.168.1.100",
 "duration_ms": 150
 }
}
```

**Criterios**:
1. **Formato**: JSON válido (una línea por log)
2. **Campos estándar**: timestamp, level, logger, message
3. **Context**: Información adicional en objeto context
4. **Niveles**: DEBUG, INFO, WARNING, ERROR, CRITICAL
5. **Compatible ELK**: Puede ser indexado en Elasticsearch

**Umbrales**:
- **Mínimo aceptable**: 70% logs estructurados
- **Objetivo**: 100% logs estructurados
- **Óptimo**: 100% + enviados automáticamente a ELK

## Trazabilidad

### Trazabilidad Ascendente

**Derivado de**: RNF-BACK-024 (Auditoría acciones críticas)

### Trazabilidad Descendente

**Implementado en**:
- RF-BACK-290: python-json-logger configurado en LOGGING
- RF-BACK-291: Formatter JSON para todos los handlers
- RF-BACK-292: Logging middleware captura request/response

**Tests**: TS-RNF-052-001 (Test logs son JSON válido)

## Impacto en Arquitectura

**Componentes requeridos**:
- python-json-logger: Formatter JSON
- ELK Stack: Elasticsearch + Logstash + Kibana
- Filebeat: Shipping de logs a Logstash
- Log Rotation: logrotate configurado

## Prioridad**: Media

**Riesgos**: Debugging difícil sin logs estructurados searchables

## Estado de Cumplimiento**: No implementado

**Última medición**: Logs en formato text plano

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | 100% JSON |
