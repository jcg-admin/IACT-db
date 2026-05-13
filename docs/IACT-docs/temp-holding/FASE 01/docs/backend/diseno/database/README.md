---
title: Diseño de Base de Datos - Backend IACT
date: 2025-11-18
domain: backend
status: active
---

# Diseño de Base de Datos - Backend IACT

**Propósito**: Documentación de diseño de base de datos, esquemas, migraciones y estrategias de datos
**Última actualización**: 2025-11-18

## Contenido

Este directorio contiene:

- **Estrategias de Migraciones**: Planificación y gestión de migraciones de BD
- **Plantillas de Diseño**: Templates para documentar esquemas de base de datos
- **Diagramas ER**: Diagramas entidad-relación de los modelos de datos

## Archivos

### Documentos Principales

- `migrations_strategy.md`: Estrategia completa de migraciones de base de datos
- `plantilla_database_design.md`: Plantilla para documentar diseño de BD

### Diagramas

- `diagramas/permisos_granular_er.puml`: Diagrama ER del sistema de permisos granular

## Configuración Multi-Database

El proyecto IACT usa múltiples bases de datos:

### MySQL
- **Uso**: Datos transaccionales, sesiones de usuario
- **Características**: ACID, integridad referencial
- **Módulos**: authentication, permissions, users

### PostgreSQL
- **Uso**: Analytics, reportes, datos complejos
- **Características**: JSON, consultas avanzadas
- **Módulos**: analytics, reports, metrics

### Cassandra
- **Uso**: Datos de alto volumen, series temporales
- **Características**: Escalabilidad horizontal, write-optimized
- **Módulos**: logs, audit, events

## Restricciones Críticas

### RNF-002: Sesiones en MySQL
- NO usar Redis para sesiones
- Implementar `django.contrib.sessions.backends.db`
- Configurar tabla de sesiones optimizada

### Integridad de Datos
- Todas las migraciones deben ser reversibles
- Testing obligatorio antes de producción
- Backups automáticos antes de cada migración

## Estrategia de Migraciones

### Workflow de Migraciones

```bash
# 1. Crear migración
python manage.py makemigrations

# 2. Revisar SQL generado
python manage.py sqlmigrate app_name migration_number

# 3. Ejecutar en desarrollo
python manage.py migrate

# 4. Testing
pytest tests/migrations/

# 5. Deploy a producción (con backup)
./scripts/migrate_production.sh
```

### Convenciones

1. **Nombres descriptivos**: Usar `--name` para migraciones complejas
2. **Atomic operations**: Usar `atomic=False` solo cuando sea necesario
3. **Data migrations**: Separar schema y data migrations
4. **Reversibilidad**: Implementar `reverse_code` en todas las data migrations

## Diagramas ER

### Generación de Diagramas

```bash
# Generar diagrama ER desde PlantUML
plantuml -tsvg diagramas/permisos_granular_er.puml

# Generar todos los diagramas
plantuml -tsvg diagramas/*.puml
```

### Nomenclatura

Según ADR-GOB-004:
```
TIPO-DOMINIO-###-descripcion.puml

Ejemplos:
- CLASS-BACK-020-modelo-llamadas.puml
- ER-PERM-001-permisos-granular.puml
```

## Herramientas

### Django Extensions

```bash
# Generar diagrama ER automático desde modelos Django
python manage.py graph_models -a -o models.png

# Generar por app específica
python manage.py graph_models permissions -o permissions_er.png
```

### Database Schema Management

```bash
# Exportar schema actual
python manage.py dbshell < dump_schema.sql

# Comparar schemas
python manage.py diffsettings
```

## Gobernanza

Consulta **primero** la gobernanza global:
- [Diseño Global de BD](../../../gobernanza/diseno/)
- [ADR-BACK-011: PostgreSQL + MariaDB Multi-Database](../../gobernanza/adr/ADR-BACK-011-postgresql-mariadb-multi-database.md)
- [Lineamientos de Migraciones](../../lineamientos_codigo.md)

## Estado Actual

### Diagramas ER Existentes
- [OK] Sistema de permisos granular (`permisos_granular_er.puml`)

### Diagramas ER Pendientes (Prioridad CRÍTICA)
- Módulo de llamadas (core negocio)
- Módulo de analytics/métricas
- Módulo ETL (integración IVR)
- Módulo de usuarios
- Módulo de auditoría

## Próximos Pasos

1. Completar diagramas ER para módulos core
2. Documentar estrategia de sharding (si aplica)
3. Implementar monitoring de migraciones
4. Crear scripts de rollback automatizados
5. Documentar plan de disaster recovery

## Referencias

- [Django Migrations](https://docs.djangoproject.com/en/5.0/topics/migrations/)
- [PostgreSQL Best Practices](https://wiki.postgresql.org/wiki/Don't_Do_This)
- [MySQL Performance](https://dev.mysql.com/doc/refman/8.0/en/optimization.html)
- [Cassandra Data Modeling](https://cassandra.apache.org/doc/latest/data_modeling/)

## Ownership

Maintainer: Arquitecto de Datos + DBA
Review: Tech Lead + Arquitecto Senior
