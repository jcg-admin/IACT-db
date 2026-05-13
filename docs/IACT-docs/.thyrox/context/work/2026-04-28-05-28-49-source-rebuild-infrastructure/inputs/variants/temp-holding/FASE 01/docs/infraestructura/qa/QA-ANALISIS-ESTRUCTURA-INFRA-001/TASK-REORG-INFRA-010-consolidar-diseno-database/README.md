---
id: TASK-REORG-INFRA-010
tipo: tarea_reorganizacion
categoria: consolidacion
fase: FASE_2_REORGANIZACION_CRITICA
prioridad: MEDIA
duracion_estimada: 2h
estado: pendiente
dependencias: [TASK-REORG-INFRA-007]
tags: [diseno, database, consolidacion]
tecnica_prompting: Chain-of-Thought + Self-Consistency
---

# TASK-REORG-INFRA-010: Consolidar diseño/database/

## Objetivo
Centralizar y consolidar todos los archivos de diseño de base de datos dispersos en el repositorio en una estructura coherente bajo `diseno/database/`, garantizando la separación clara entre diseño de BD y otros artefactos arquitectónicos.

## Problema Identificado (AUTO-CoT Step 1)

Actualmente, los archivos de diseño de base de datos están dispersos:
- `/docs/backend/diseno/database/` (estrategias de migraciones, plantillas, diagramas ER)
- `/docs/scripts/analisis/database_*.sh_analysis.*` (análisis de scripts de configuración)
- `/docs/infraestructura/qa/tareas/TASK-018-cassandra_cluster_setup.md` (configuración Cassandra)
- `/infrastructure/devcontainer/utils/database_*.sh` (scripts de setup)
- `/infrastructure/vagrant/scripts/setup_*_database.sh` (scripts de setup)
- `/infrastructure/vagrant/utils/database.sh` (utilidades database)
- `/infrastructure/box/` (archivos de configuración MariaDB)

Esta dispersión causa:
- Confusión sobre dónde documentar decisiones de BD
- Dificultad para mantener estrategia dual database (MariaDB/PostgreSQL)
- Separación incompleta entre diseño e implementación
- Referencias inconsistentes a restricciones críticas (RNF-002: NO Redis para sesiones)

## Documentos de Base de Datos Identificados (AUTO-CoT Step 2)

### Backend Design (Diseño Existente)
| Archivo | Ubicación | Descripción |
|---------|-----------|-------------|
| README.md | `/docs/backend/diseno/database/` | Guía principal de BD (estrategia multi-database) |
| migrations_strategy.md | `/docs/backend/diseno/database/` | Estrategia de migraciones Django |
| plantilla_database_design.md | `/docs/backend/diseno/database/` | Plantilla para documentar esquemas |
| permisos_granular_er.puml | `/docs/backend/diseno/database/diagramas/` | Diagrama ER del sistema de permisos |

### Scripts de Análisis (Documentación de Implementación)
| Archivo | Ubicación | Descripción |
|---------|-----------|-------------|
| database_postgres.sh_analysis.md | `/docs/scripts/analisis/` | Análisis setup PostgreSQL |
| database_mariadb.sh_analysis.md | `/docs/scripts/analisis/` | Análisis setup MariaDB |
| database.sh_analysis.md | `/docs/scripts/analisis/` | Análisis setup database general |
| database_*_analysis.json | `/docs/scripts/analisis/` | Análisis en formato JSON |

### Infraestructura y Configuración
| Archivo | Ubicación | Descripción |
|---------|-----------|-------------|
| TASK-018-cassandra_cluster_setup.md | `/docs/infraestructura/qa/tareas/` | Setup y configuración Cassandra |
| database_mariadb.sh | `/infrastructure/devcontainer/utils/` | Setup MariaDB en devcontainer |
| database_postgres.sh | `/infrastructure/devcontainer/utils/` | Setup PostgreSQL en devcontainer |
| database.sh | `/infrastructure/vagrant/utils/` | Utilidades database para Vagrant |
| setup_mariadb_database.sh | `/infrastructure/vagrant/scripts/` | Setup MariaDB en Vagrant |
| setup_postgres_database.sh | `/infrastructure/vagrant/scripts/` | Setup PostgreSQL en Vagrant |
| mariadb/ | `/infrastructure/box/config/` | Archivos configuración MariaDB |
| mariadb.sh | `/infrastructure/box/install/` | Script instalación MariaDB en box |
| fix_db_connectivity.sh | `/infrastructure/box/` | Herramienta fix conectividad BD |

## Estrategia de Consolidación (AUTO-CoT Step 3)

### Estructura de Consolidación

```
diseno/
├── database/
│   ├── README.md                          (Documento maestro - este)
│   │
│   ├── estrategia/
│   │   ├── dual_database_strategy.md      (MariaDB + PostgreSQL)
│   │   ├── cassandra_strategy.md          (Alto volumen, series temporales)
│   │   ├── restricciones_criticas.md      (RNF-002 y otras)
│   │   └── migraciones_django.md          (Estrategia de migraciones)
│   │
│   ├── esquemas/
│   │   ├── plantilla_diseno_bd.md         (Template para nuevos esquemas)
│   │   ├── permisos_granular_schema.md    (Esquema actual de permisos)
│   │   ├── usuarios_schema.md             (Módulo usuarios)
│   │   ├── llamadas_schema.md             (Módulo core)
│   │   ├── analytics_schema.md            (Analytics y reportes)
│   │   └── audit_eventos_schema.md        (Auditoría y eventos)
│   │
│   ├── diagramas/
│   │   ├── permisos_granular_er.puml      (ER permisos)
│   │   ├── usuarios_er.puml               (ER usuarios)
│   │   ├── llamadas_er.puml               (ER llamadas - TODO)
│   │   ├── analytics_er.puml              (ER analytics - TODO)
│   │   └── README.md                      (Guía generación diagramas)
│   │
│   ├── implementacion/
│   │   ├── devcontainer/
│   │   │   ├── mariadb_setup.md           (Setup MariaDB en devcontainer)
│   │   │   └── postgres_setup.md          (Setup PostgreSQL en devcontainer)
│   │   │
│   │   ├── vagrant/
│   │   │   ├── mariadb_setup.md           (Setup MariaDB en Vagrant)
│   │   │   └── postgres_setup.md          (Setup PostgreSQL en Vagrant)
│   │   │
│   │   └── box/
│   │       ├── mariadb_configuration.md   (Configuración MariaDB en box)
│   │       └── connectivity_troubleshooting.md
│   │
│   └── gobernanza/
│       ├── adr_dual_database.md           (ADR decisión multi-database)
│       ├── convenciones_nombres.md        (Convenciones de nombrado)
│       └── changelog.md                   (Historial cambios BD)
```

### Contenido Clave por Sección

#### 1. Estrategia (estrategia/)
- **dual_database_strategy.md**: Explicar por qué MariaDB + PostgreSQL
  - MariaDB: transaccional, sesiones, datos ACID
  - PostgreSQL: analytics, JSON, consultas complejas
  - Cassandra: alto volumen, series temporales

- **restricciones_criticas.md**: Documentar limitaciones vinculantes
  - RNF-002: Sesiones DEBEN estar en MySQL (django.contrib.sessions.backends.db)
  - NO Redis para sesiones
  - Integridad referencial requerida en MySQL
  - Write-optimized para Cassandra

- **migraciones_django.md**: Workflow completo de migraciones

#### 2. Esquemas (esquemas/)
- Documentar estructura actual y futura
- Usar plantilla para consistencia
- Separar por módulo de negocio

#### 3. Diagramas (diagramas/)
- Diagramas ER en PlantUML
- Nomenclatura: ER-DOMINIO-###-descripcion.puml
- Generar SVG automáticamente

#### 4. Implementación (implementacion/)
- Documentar scripts de setup
- Separar por environment (devcontainer, vagrant, box)
- Análisis de scripts existentes

#### 5. Gobernanza (gobernanza/)
- ADRs sobre decisiones de BD
- Convenciones de nomenclaturas de tablas
- Changelog de cambios estructurales

## Tareas Específicas (AUTO-CoT Step 4)

### Phase 1: Preparación y Análisis
- [ ] Crear estructura de directorios `diseno/database/` con subdirectorios
- [ ] Auditar todos documentos de BD existentes
- [ ] Crear mapping: archivo origen -> ubicación destino
- [ ] Identificar duplicados o contenido redundante
- [ ] Documentar restricciones críticas en `restricciones_criticas.md`

### Phase 2: Consolidación de Documentación Existente
- [ ] Mover `/docs/backend/diseno/database/*` a `diseno/database/`
- [ ] Extraer información de análisis scripts a `diseno/database/implementacion/`
- [ ] Crear `dual_database_strategy.md` consolidando estrategia de BD
- [ ] Consolidar TASK-018-cassandra_cluster_setup.md en `cassandra_strategy.md`
- [ ] Documentar setup scripts como guías en `implementacion/`

### Phase 3: Documentación de Esquemas (Missing)
- [ ] Crear plantilla estándar (`plantilla_diseno_bd.md`)
- [ ] Generar README en `esquemas/` explicando estructura
- [ ] Documentar esquema actual de permisos con plantilla
- [ ] Crear templates para esquemas pendientes (usuarios, llamadas, analytics)

### Phase 4: Diagramas y Visualización
- [ ] Mover `permisos_granular_er.puml` a `diagramas/`
- [ ] Crear README en `diagramas/` con instrucciones de generación
- [ ] Documentar herramientas: PlantUML, Django Extensions
- [ ] Listado de diagramas TODO (usuarios, llamadas, analytics)

### Phase 5: Integración y Referencias
- [ ] Actualizar todos los enlaces internos
- [ ] Crear enlaces bidireccionales con gobernanza/adr/
- [ ] Validar referencias a restricciones RNF-002
- [ ] Actualizar índices de documentación

### Phase 6: Validación (Self-Consistency)
- [ ] Verificar que NO haya archivos de BD fuera de `diseno/database/`
- [ ] Validar separación: diseño vs implementación
- [ ] Confirmar restricciones críticas documentadas explícitamente
- [ ] Testing de links cruzados

## Self-Consistency Checklist

Para validar consolidación exitosa:

```bash
# 1. Verificar que archivos de BD están centralizados
find diseno/database -type f | wc -l  # Debe incluir todos los documentos

# 2. Verificar NO hay archivos de BD dispersos
find docs -path "*database*" -type f ! -path "*/diseno/database/*" ! -path "*backend/diseno/database*" 2>/dev/null

# 3. Validar completitud de estructura
test -d diseno/database/estrategia && \
test -d diseno/database/esquemas && \
test -d diseno/database/diagramas && \
test -d diseno/database/implementacion && \
test -d diseno/database/gobernanza && \
echo "Estructura completa" || echo "Falta estructura"

# 4. Validar restricciones críticas documentadas
grep -r "RNF-002\|NO Redis\|sesiones.*MySQL" diseno/database/ | wc -l

# 5. Contar documentos consolidados
echo "Documentos consolidados: $(find diseno/database -type f -name "*.md" | wc -l)"
```

## Criterios de Aceptación

- [x] Estructura `diseno/database/` creada con 5 subdirectorios principales
- [ ] Todos los documentos de BD movidos a `diseno/database/`
- [ ] Estrategia dual database documentada explícitamente
- [ ] Restricciones críticas (RNF-002) destacadas y referenciables
- [ ] Diagramas ER consolidados en `diagramas/`
- [ ] Scripts de implementación documentados en `implementacion/`
- [ ] Plantilla de esquema BD disponible para nuevos módulos
- [ ] Todos los enlaces internos actualizados
- [ ] Self-Consistency validada: cero archivos de BD fuera de `diseno/database/`
- [ ] Referencias a `diseno/database/` funcionan desde cualquier ubicación

## Beneficios de la Consolidación

1. **Centralidad**: Un único punto de entrada para diseño de BD
2. **Claridad**: Separación clara entre diseño, estrategia e implementación
3. **Consistencia**: Estructura uniforme para documentar nuevos esquemas
4. **Gobernanza**: Facilita revisión de cambios de BD (migration review)
5. **Descubrimiento**: Nuevos desarrolladores encuentran estrategia de BD rápidamente
6. **Trazabilidad**: Historial de decisiones arquitectónicas de BD (ADRs)

## Restricciones Vinculantes (CRÍTICAS)

### RNF-002: Sesiones en MySQL
- Las sesiones DEBEN almacenarse en MySQL
- Usar `django.contrib.sessions.backends.db`
- NO usar Redis
- Tabla de sesiones debe estar optimizada para escritura

### Integridad de Datos
- Todas las migraciones DEBEN ser reversibles
- Testing obligatorio antes de deploy
- Backups automáticos antes de cada migración

## Referencias y Dependencias

- **TASK-REORG-INFRA-007**: Consolidación de diseno/detallado (dependencia previa)
- **ADR-BACK-011**: PostgreSQL + MariaDB Multi-Database Decision
- **docs/backend/diseno/database/README.md**: Documentación base actual
- **docs/gobernanza/diseno/arquitectura/**: Lineamientos globales

## Notas de Implementación

1. **Respeto por Git History**: Usar `git mv` para preservar historial
2. **Commits Atómicos**: Commits por sección (estrategia, esquemas, etc.)
3. **Validation Scripts**: Mantener scripts de validación en evidencias/
4. **Documentation Links**: Actualizar referencias en índices maestros
5. **ADR Registry**: Registrar cambios en adr/adr_database_consolidation.md

## Técnica de Prompting Utilizada

- **Auto-CoT (Chain-of-Thought)**: Análisis paso a paso de documentos dispersos
- **Self-Consistency**: Validación que BD está separado de otros diseños
- **Decomposition**: Dividir consolidación en 6 fases

---

**Creado**: 2025-11-18
**Última actualización**: 2025-11-18
**Estado**: PENDIENTE
**Técnica de prompting**: Chain-of-Thought + Self-Consistency
