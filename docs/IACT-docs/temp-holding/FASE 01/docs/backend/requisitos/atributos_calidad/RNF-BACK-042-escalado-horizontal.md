---
id: RNF-BACK-042
tipo: atributo_calidad
subtipo: escalabilidad
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: media
---

# RNF-BACK-042: Escalado Horizontal (Stateless Workers)

## Categoría

Escalabilidad

## Descripción

El sistema backend debe estar diseñado para escalado horizontal, con workers stateless que permitan agregar más instancias de aplicación para aumentar capacidad sin cambios arquitectónicos.

## Métrica Medible

**Métrica**: Capacidad de agregar workers sin cambios de código

**Valor objetivo**: 100% stateless (sin estado en workers)

**Condiciones**:
- Sesiones en Redis (NO en memoria del worker)
- Caché compartido en Redis
- Sin archivos locales (usar S3 o storage compartido)
- Sin procesos background en workers

## Método de Medición

**Herramienta de medición**: Inspección de código y arquitectura

**Frecuencia de medición**: Por cada release

**Proceso de medición**:
1. Revisar código para detectar estado en workers
2. Verificar que sesiones usan backend Redis
3. Verificar que no hay archivos escritos en /tmp local
4. Probar agregar worker adicional y verificar funcionamiento
5. Confirmar que throughput escala linealmente con workers

**Responsable de medición**: Arquitectura + Backend

## Criterios de Aceptación

1. **Sesiones**: Almacenadas en Redis, NO en memoria
2. **Caché**: Caché compartido en Redis
3. **Archivos**: Sin escritura en filesystem local (usar S3)
4. **Background Jobs**: Ejecutados por APScheduler separado, NO en workers
5. **Escalado**: Agregar worker aumenta capacidad ~linealmente

**Umbrales**:
- **Mínimo aceptable**: 80% stateless
- **Objetivo**: 100% stateless
- **Óptimo**: 100% stateless + auto-scaling configurado

## Trazabilidad

### Trazabilidad Ascendente

**Derivado de**: RNEG-INFRA-002 (Arquitectura escalable)

### Trazabilidad Descendente

**Implementado en**:
- RF-BACK-240: SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
- RF-BACK-241: CACHES backend = Redis
- RF-BACK-242: File storage = S3 (django-storages)
- RF-BACK-243: Background jobs en proceso separado

**Tests**: TS-RNF-042-001 (Test escalado horizontal)

## Impacto en Arquitectura

**Componentes requeridos**:
- Redis: Sesiones y caché compartido
- S3: Almacenamiento de archivos
- APScheduler: Background jobs en proceso dedicado
- Nginx: Load balancing entre workers

## Prioridad**: Media

**Riesgos**: Incapacidad de escalar horizontalmente si hay estado

## Estado de Cumplimiento**: Parcialmente implementado

**Última medición**: Sesiones en Redis OK, algunos archivos locales

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | 100% stateless |
