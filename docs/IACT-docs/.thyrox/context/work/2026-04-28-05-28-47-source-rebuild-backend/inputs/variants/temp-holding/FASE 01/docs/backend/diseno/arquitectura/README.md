---
title: Arquitectura del Backend IACT
date: 2025-11-18
domain: backend
status: active
---

# Arquitectura del Backend IACT

**Proposito**: Documentacion de arquitectura de software del backend Django
**Ultima actualizacion**: 2025-11-18

## Contenido

Este directorio contiene:

- **Patrones Arquitectónicos**: Decisiones y patrones de diseño aplicados
- **Arquitectura por Módulo**: Documentación específica de cada módulo
- **Guías de Decisión**: Criterios para selección de patrones
- **Lineamientos de Código**: Estándares y convenciones

## Archivos

### Documentos Principales

- `patrones_arquitectonicos.md`: Catálogo completo de patrones de diseño
- `guia_decision_patrones.md`: Guía para seleccionar patrones apropiados
- `permisos_granular.md`: Arquitectura del sistema de permisos
- `decoradores_y_middleware_permisos.md`: Implementación de middleware

### Arquitectura por Módulo

- `analytics.md`: Módulo de analíticas y métricas
- `audit.md`: Módulo de auditoría
- `authentication.md`: Módulo de autenticación
- `common.md`: Componentes comunes
- `configuration.md`: Módulo de configuración
- `dashboard.md`: Módulo de dashboard
- `etl.md`: Módulo ETL
- `ivr_legacy.md`: Integración con IVR legacy
- `notifications.md`: Módulo de notificaciones
- `reports.md`: Módulo de reportes
- `users.md`: Módulo de usuarios

### Lineamientos

- `lineamientos_codigo.md`: Estándares de código y convenciones

## Principios IACT

1. Separacion de concerns
2. Testabilidad (>= 80% coverage)
3. Mantenibilidad
4. Escalabilidad horizontal
5. Seguridad (OWASP Top 10)

## Restricciones Criticas

- RNF-002: NO Redis (sesiones en MySQL)
- Multi-database: MySQL + PostgreSQL + Cassandra
- NO emojis/iconos en codigo

## Gobernanza

Consulta **primero** la gobernanza global:
- [Diseño Global](../../../gobernanza/diseno/)
- [ADRs Backend](../../gobernanza/adr/)
- [Guías Arquitectónicas](../../../gobernanza/guias/)

## Decisiones Arquitectónicas (ADRs)

Las decisiones arquitectónicas formales se encuentran en:
- `decisions/`: ADRs específicos de arquitectura (vacío actualmente)
- [ADRs Globales Backend](../../gobernanza/adr/): Decisiones arquitectónicas principales

## Ownership

Maintainer: Arquitecto Senior
Review: Tech Lead + Arquitecto
