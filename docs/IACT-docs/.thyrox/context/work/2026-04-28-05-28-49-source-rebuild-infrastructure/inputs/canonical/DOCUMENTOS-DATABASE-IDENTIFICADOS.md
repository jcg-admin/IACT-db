# Documentos de Diseño de Base de Datos Identificados

## Resumen Ejecutivo

Se han identificado **23 documentos y scripts** relacionados con diseño, estrategia e implementación de base de datos dispersos en 8 ubicaciones diferentes del repositorio IACT.

**Objetivo**: Consolidar todos en `diseno/database/` manteniendo la separación clara entre:
- **Estrategia y Diseño** (nivel arquitectónico)
- **Implementación** (nivel infra-estructura)
- **Análisis** (documentación de scripts existentes)

---

## 1. Documentación de Diseño Existente (Backend)

### Ubicación: `/docs/backend/diseno/database/`

| Archivo | Tipo | Descripción | Acción |
|---------|------|-------------|--------|
| `README.md` | Diseño | Guía principal de BD, estrategia multi-database | CONSOLIDAR como base |
| `migrations_strategy.md` | Diseño | Estrategia completa de migraciones Django | MOVER a `estrategia/` |
| `plantilla_database_design.md` | Template | Plantilla para documentar esquemas | MOVER a `esquemas/` |
| `diagramas/permisos_granular_er.puml` | Diagrama | ER del sistema de permisos granular | MOVER a `diagramas/` |

**Total**: 4 documentos/archivos existentes

---

## 2. Análisis de Scripts de Database

### Ubicación: `/docs/scripts/analisis/`

| Archivo | Tipo | Descripción | Acción |
|---------|------|-------------|--------|
| `database_postgres.sh_analysis.md` | Análisis | Análisis detallado setup PostgreSQL | EXTRAER a `implementacion/` |
| `database_postgres.sh_analysis.json` | Análisis | Versión JSON del análisis PostgreSQL | REFERENCIA |
| `database_mariadb.sh_analysis.md` | Análisis | Análisis detallado setup MariaDB | EXTRAER a `implementacion/` |
| `database_mariadb.sh_analysis.json` | Análisis | Versión JSON del análisis MariaDB | REFERENCIA |
| `database.sh_analysis.md` | Análisis | Análisis genérico de database.sh | EXTRAER a `implementacion/` |
| `database.sh_analysis.json` | Análisis | Versión JSON del análisis general | REFERENCIA |

**Total**: 6 documentos de análisis

---

## 3. Infraestructura y Configuración (Infrastructure Code)

### Ubicación A: `/infrastructure/devcontainer/utils/`

| Archivo | Tipo | Descripción | Acción |
|---------|------|-------------|--------|
| `database_mariadb.sh` | Script | Setup MariaDB en ambiente devcontainer | DOCUMENTAR en `implementacion/devcontainer/` |
| `database_postgres.sh` | Script | Setup PostgreSQL en ambiente devcontainer | DOCUMENTAR en `implementacion/devcontainer/` |

**Nota**: Estos scripts tienen análisis documentados en `/docs/scripts/analisis/`

### Ubicación B: `/infrastructure/vagrant/`

#### Subdirectorio: `scripts/`
| Archivo | Tipo | Descripción | Acción |
|---------|------|-------------|--------|
| `setup_mariadb_database.sh` | Script | Setup MariaDB para Vagrant | DOCUMENTAR en `implementacion/vagrant/` |
| `setup_postgres_database.sh` | Script | Setup PostgreSQL para Vagrant | DOCUMENTAR en `implementacion/vagrant/` |
| `mariadb_install.sh` | Script | Instalación de MariaDB | DOCUMENTAR en `implementacion/vagrant/` |
| `postgres_install.sh` | Script | Instalación de PostgreSQL | REFERENCIA |

#### Subdirectorio: `utils/`
| Archivo | Tipo | Descripción | Acción |
|---------|------|-------------|--------|
| `database.sh` | Utilidad | Funciones comunes para database setup | DOCUMENTAR |

**Total**: 6 scripts en Vagrant

### Ubicación C: `/infrastructure/box/`

#### Subdirectorio: `config/mariadb/`
| Archivo | Tipo | Descripción | Acción |
|---------|------|-------------|--------|
| `mariadb/` (directorio) | Config | Archivos de configuración MariaDB | DOCUMENTAR estructura |

**Contenido**: Archivos .cnf, .sql, scripts de inicialización

#### Subdirectorio: `install/`
| Archivo | Tipo | Descripción | Acción |
|---------|------|-------------|--------|
| `mariadb.sh` | Script | Instalación de MariaDB en box | DOCUMENTAR |

#### Raíz: `/infrastructure/box/`
| Archivo | Tipo | Descripción | Acción |
|---------|------|-------------|--------|
| `fix_db_connectivity.sh` | Herramienta | Script para resolver problemas conectividad BD | DOCUMENTAR troubleshooting |

**Total**: 3 archivos en box/

---

## 4. Tareas y Especificaciones de Infraestructura

### Ubicación: `/docs/infraestructura/qa/tareas/`

| Archivo | Tipo | Descripción | Acción |
|---------|------|-------------|--------|
| `TASK-018-cassandra_cluster_setup.md` | Tarea | Setup y configuración cluster Cassandra | CONSOLIDAR en `estrategia/cassandra_strategy.md` |

**Total**: 1 tarea relacionada con BD

---

## 5. Documentación General de Infraestructura

### Ubicación: `/docs/infraestructura/`

| Archivo | Tipo | Descripción | Relación BD |
|---------|------|-------------|------------|
| `storage_architecture.md` | Arquitectura | Estrategia general de almacenamiento | REFERENCIA (puede mencionar BD) |
| `ambientes_virtualizados.md` | Especificación | Configuración de ambientes | REFERENCIA (menciona BD setup) |

**Nota**: Estos archivos pueden mencionar BD pero no son documentos de diseño de BD específicos.

---

## Resumen de Consolidación

### Por Tipo de Documento

| Tipo | Cantidad | Acción Primaria |
|------|----------|-----------------|
| Documentos de Diseño | 4 | MOVER a estructura |
| Análisis de Scripts | 6 | EXTRAER a implementación |
| Scripts de Setup | 9 | DOCUMENTAR referencias |
| Archivos de Config | 3+ | DOCUMENTAR estructura |
| Tareas/Specs | 1 | CONSOLIDAR en estrategia |
| **TOTAL** | **23+** | **CONSOLIDAR** |

### Por Ubicación

| Ubicación Actual | Documentos | Acción |
|------------------|-----------|--------|
| `/docs/backend/diseno/database/` | 4 | MOVER |
| `/docs/scripts/analisis/` | 6 | EXTRAER |
| `/infrastructure/devcontainer/utils/` | 2 scripts | DOCUMENTAR |
| `/infrastructure/vagrant/` | 6 scripts | DOCUMENTAR |
| `/infrastructure/box/` | 3+ archivos | DOCUMENTAR |
| `/docs/infraestructura/qa/tareas/` | 1 | CONSOLIDAR |

---

## Identificación de Contenido Crítico

### 1. Estrategia Dual Database (CRÍTICA)

**Fuentes Actuales**:
- `/docs/backend/diseno/database/README.md` - Líneas 32-49
- Configuración en múltiples scripts

**Consolidar en**: `diseno/database/estrategia/dual_database_strategy.md`

**Contenido clave**:
- MariaDB: transaccional, sesiones, ACID
- PostgreSQL: analytics, JSON, queries complejas
- Cassandra: alto volumen, series temporales

### 2. Restricciones Críticas (CRÍTICA)

**Fuentes Actuales**:
- `/docs/backend/diseno/database/README.md` - Líneas 51-62
- RNF-002: Sesiones en MySQL (NO Redis)

**Consolidar en**: `diseno/database/estrategia/restricciones_criticas.md`

**Contenido clave**:
- RNF-002: Sesiones DEBEN estar en MySQL
- NO Redis para sesiones
- `django.contrib.sessions.backends.db`
- Integridad referencial requerida

### 3. Migraciones Django

**Fuentes Actuales**:
- `/docs/backend/diseno/database/README.md` - Líneas 63-90
- `migrations_strategy.md`

**Consolidar en**: `diseno/database/estrategia/migraciones_django.md`

### 4. Cassandra Setup (Nuevo)

**Fuentes Actuales**:
- `/docs/infraestructura/qa/tareas/TASK-018-cassandra_cluster_setup.md`

**Consolidar en**: `diseno/database/estrategia/cassandra_strategy.md`

---

## Plan de Acción Fase 1

Para la fase de Preparación y Análisis:

### Paso 1: Crear estructura base
```bash
mkdir -p diseno/database/{estrategia,esquemas,diagramas,implementacion/{devcontainer,vagrant,box},gobernanza}
```

### Paso 2: Listar archivos a mover
```bash
# Documentos a mover
ls -la /docs/backend/diseno/database/

# Archivos a documentar
find /infrastructure -name "*database*" -o -name "*mariadb*"
```

### Paso 3: Crear referencias
```bash
# En cada ubicación, crear README explicando que BD está consolidado
# en diseno/database/
```

### Paso 4: Validar Self-Consistency
```bash
# No debe haber archivos database fuera de diseno/database/
find docs infrastructure -name "*database*" -type f ! -path "*/diseno/database/*"
```

---

## Referencias Cruzadas

### Documentos que mencionan contenido de BD
- `/docs/gobernanza/diseno/README_diseno_detallado.md` - Referencias a BD
- `/docs/backend/diseno/README.md` - Índice general
- `/docs/infraestructura/diseno/README.md` - Referencias a arquitectura BD

### ADRs relacionados
- `ADR-BACK-011-postgresql-mariadb-multi-database.md`
- Posible nuevo: `ADR-INFRA-XXX-consolidation-database-design.md`

---

## Notas Especiales

1. **Respeto de Git History**: Algunos de estos archivos tienen historia significativa. Usar `git mv` preserva los logs.

2. **Scripts vs Documentación**: Los scripts (`.sh`) NO se mueven, solo se documentan referencias en `implementacion/`

3. **Análisis Automáticos**: Los archivos `.json` en `analisis/` son generados. Documentar proceso de regeneración.

4. **Configuración Específica**: Archivos en `/infrastructure/box/config/mariadb/` son específicos del ambiente. Documentar sin mover.

---

**Creado**: 2025-11-18
**Estado**: LISTA PARA CONSOLIDACIÓN
**Fase**: PREPARACIÓN (Phase 1)

