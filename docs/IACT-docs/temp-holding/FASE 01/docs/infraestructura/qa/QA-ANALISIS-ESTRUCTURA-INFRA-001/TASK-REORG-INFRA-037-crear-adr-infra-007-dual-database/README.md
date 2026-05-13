---
id: TASK-REORG-INFRA-037
tipo: tarea_contenido
categoria: adr
fase: FASE_3_CONTENIDO_NUEVO
prioridad: ALTA
duracion_estimada: 4h
estado: pendiente
dependencias: [TASK-REORG-INFRA-031]
tags: [adr, database, mariadb, postgresql, dual-strategy, decision, infraestructura]
tecnica_prompting: Template-based Prompting + Auto-CoT + Self-Consistency
fecha_creacion: 2025-11-18
---

# TASK-REORG-INFRA-037: Crear ADR-INFRA-007 (Dual Database Strategy - MariaDB/PostgreSQL)

## Auto-CoT: Razonamiento de la Decisión Multi-Database

### 1. Identificación del Problema
- **Pregunta central:** ¿Soportar una sola base de datos o múltiples para máxima flexibilidad?
- **Contexto:** IACT es un proyecto multi-stack que puede necesitar diferentes BDs
- **Requisito:** Balance entre flexibilidad y complejidad operacional

### 2. Evaluación Detallada (Chain-of-Thought)

**Paso 1: Analizar requisitos del proyecto**
```
IACT necesita:
- ORM support (SQLAlchemy, Django ORM)
- ACID compliance
- JSON support (para documentos)
- Full-text search (opcional)
- Replication support (future)
- Community adoption

Current context:
- MariaDB: Usado en legacy, compatible MySQL
- PostgreSQL: Modern, advanced features
```

**Paso 2: Evaluar ventajas de cada BD**

**MariaDB:**
- Pros: MySQL compatible, familiar, smaller footprint
- Cons: Menos advanced features vs PG
- Use cases: Simple CRUD, legacy compatibility

**PostgreSQL:**
- Pros: JSONB, full-text search, better performance, advanced features
- Cons: Larger footprint, steeper learning curve
- Use cases: Complex queries, JSON data, analytics

**Paso 3: Considerar strategy dual**
```
¿Qué problema resuelve soportar ambas?

1. Developer choice: Elegir BD según proyecto
2. Legacy compatibility: MariaDB para código existente
3. Modern projects: PostgreSQL para nuevos features
4. Flexible architecture: No lock-in a una BD

¿Impacto operacional?
- Doble testing
- Doble provisioning
- Doble maintenance
- Pero: ORM abstrae mayoría de diferencias
```

**Paso 4: Viabilidad técnica**
```
Con ORM (SQLAlchemy):
- Mismo código funciona ambas BDs [OK]
- Tests deben pasar ambas [OK]
- Migrations tool-agnostic [OK]
- Connection strings diferencia mínima [OK]

CI/CD con dual database:
- Github Actions matrix strategy [OK]
- Test container support [OK]
- Docker Compose con ambas [OK]
```

### 3. Impacto en Arquitectura
- **Positivo:** Máxima flexibilidad para proyectos
- **Positivo:** No lock-in a una BD
- **Positivo:** Legacy MariaDB compatibility
- **Negativo:** Doble testing, doble provisioning
- **Neutral:** Requiere documentation clara

## Descripción de la Tarea

Esta tarea documenta formalmente la decisión de **soportar MariaDB y PostgreSQL en paralelo** en DevContainer, permitiendo a los desarrolladores elegir según requisitos del proyecto.

Es el **séptimo ADR formal de infraestructura**, definiendo la estrategia flexible de base de datos.

## Objetivo

Crear un Architecture Decision Record (ADR) que:
- Documente necesidad de múltiples bases de datos
- Compare MariaDB vs PostgreSQL con casos de uso
- Justifique la estrategia dual
- Establezca criterios de compatibilidad ORM
- Defina testing strategy para ambas BDs

## Alineación

**Canvases de referencia:**
- `/docs/infraestructura/diseno/arquitectura/devcontainer-host-vagrant.md`
- `/docs/backend/diseno/arquitectura/database-strategy.md`

**Decisión:** ADR-INFRA-007 define la estrategia flexible de database.

## Contenido a Generar

### Archivo Principal
- **Ubicación:** `/docs/infraestructura/adr/ADR-INFRA-007-dual-database-strategy.md`
- **Formato:** Markdown con frontmatter YAML
- **Secciones:** 8 secciones completas

### Estructura del ADR

1. **Contexto y Problema**
   - Requisitos de BD del proyecto
   - Legacy MariaDB vs Modern PostgreSQL
   - Necesidad de flexibilidad
   - Use cases diferentes

2. **Factores de Decisión**
   - Flexibility (Alto)
   - Legacy compatibility (Alto)
   - Performance (Medio)
   - Operational overhead (Medio)
   - Community adoption (Bajo)

3. **Opciones Consideradas**
   - Solo MariaDB (legacy)
   - Solo PostgreSQL (modern)
   - Dual database strategy (RECOMENDADA)
   - Microservices-based (rechazado)

4. **Decisión**
   - Soportar MariaDB y PostgreSQL en paralelo

5. **Justificación**
   - Máxima flexibilidad para proyectos
   - ORM abstrae diferencias
   - CI/CD matrix testing viable
   - No lock-in a una BD

6. **Consecuencias**
   - Positivas: Flexibilidad, compatibility, no lock-in
   - Negativas: Doble testing, doble provisioning
   - Neutrales: Documentation, training

7. **Plan de Implementación**
   - Fase 1: Dual database en docker-compose.yml (1 día)
   - Fase 2: Environment variables para selección (1 día)
   - Fase 3: CI/CD matrix testing (1-2 días)
   - Fase 4: Documentation + examples (1 día)

8. **Validación y Métricas**
   - Criterios: Mismo código funciona ambas BDs
   - Medición: Tests pasen 100% en MariaDB y PG
   - Compatibility: ORM migrations idénticas

## Self-Consistency: Validación de Coherencia

### Checklist de Completitud

- [ ] 8 secciones presentes en el ADR
- [ ] Frontmatter YAML completo
- [ ] Requisitos de BD documentados
- [ ] Comparación detallada MariaDB vs PostgreSQL
- [ ] Use cases para cada BD
- [ ] ORM compatibility analysis
- [ ] CI/CD matrix strategy
- [ ] Plan de implementación con fases
- [ ] Migración strategy documentada
- [ ] Referencias a ejemplos reales

### Alineación Verificada

| Concepto | MariaDB | PostgreSQL | Status |
|----------|---------|-----------|--------|
| ACID compliance | [OK] | [OK] | OK |
| ORM support | [OK] | [OK] | OK |
| JSON support | [OK] | [OK] | OK |
| Full-text search | [OK] | [OK] | OK |
| Testing in CI | [ ] | [ ] | Pendiente |
| Documentation | [ ] | [ ] | Pendiente |

### Coherencia del Razonamiento

**Verificación Chain-of-Thought:**
```
1. ¿Problema claramente definido?
   → Sí: Necesidad de flexibilidad BD

2. ¿Opciones exhaustivas?
   → Sí: 4 opciones evaluadas

3. ¿Impacto operacional analizado?
   → Sí: Testing, provisioning, maintenance

4. ¿Viabilidad técnica confirmada?
   → Sí: ORM abstrae, CI/CD matrix posible

5. ¿Plan realista e implementable?
   → Sí: 4 fases con timeframe

Conclusión: Decisión técnicamente sólida
```

## Decisión Capturada (Preliminary)

**Opción elegida:** Dual database strategy (MariaDB + PostgreSQL)

**Justificación:**
- Máxima flexibilidad: Developers eligen según proyecto
- ORM-based: SQLAlchemy/Django ORM abstrae BD
- No lock-in: No quedar atrapado en una BD
- Legacy compatible: Soporte para MariaDB existente
- Future-proof: PostgreSQL para advanced features

## Database Selection Matrix

```
Usa MariaDB cuando:
├─ Migración desde legacy MySQL
├─ CRUD simple, schemas simples
├─ Team familiarizado con MySQL
└─ Performance es critical (smaller footprint)

Usa PostgreSQL cuando:
├─ Nuevo proyecto, greenfield
├─ JSONB, full-text search requerido
├─ Complex queries, advanced features
├─ Analytics, reporting workloads
└─ Team quiere modern tooling

Default: PostgreSQL (nueva recomendación)
Fallback: MariaDB (legacy support)
```

## Implementation Architecture

```
Docker Compose Services:
├─ mariadb:11 (legacy support)
├─ postgresql:15 (default modern)
└─ phpmyadmin (optional, MariaDB)

Environment Variables:
DATABASE_ENGINE=postgresql # or mysql
DATABASE_HOST=localhost
DATABASE_PORT=5432 # 3306 para MySQL
DATABASE_NAME=iact_dev
DATABASE_USER=dev
DATABASE_PASSWORD=dev_password

ORM Configuration:
SQLAlchemy:
  - Connection string: postgresql://...
  - Or: mysql+pymysql://...
  - Same code, different backend

CI/CD Matrix:
tests:
  strategy:
    matrix:
      database: [mariadb, postgresql]
```

## Próximos Pasos

1. Desarrollar ADR-INFRA-007 con 8 secciones
2. Comparación detallada MariaDB vs PostgreSQL
3. ORM compatibility matrix
4. Docker Compose dual setup
5. CI/CD matrix testing config
6. Developer guide para selección de BD
7. Migration examples (MariaDB → PostgreSQL)

## Referencias

- **MariaDB Docs:** https://mariadb.com/docs/
- **PostgreSQL Docs:** https://www.postgresql.org/docs/
- **SQLAlchemy:** https://www.sqlalchemy.org/
- **Docker Compose:** https://docs.docker.com/compose/
- **Plantilla ADR:** `/docs/gobernanza/adr/plantilla_adr.md`

## Criterios de Aceptación

- [ ] ADR-INFRA-007 creado con 8 secciones
- [ ] Comparación detallada MariaDB vs PostgreSQL
- [ ] ORM compatibility verified
- [ ] Docker Compose con ambas BDs
- [ ] CI/CD matrix config creado
- [ ] Migration examples (MariaDB → PostgreSQL)
- [ ] Developer selection guide
- [ ] Self-Consistency validado

---

**Estado:** PENDIENTE
**Fecha Creación:** 2025-11-18
**Fase:** FASE_3_CONTENIDO_NUEVO
**Responsable:** Equipo de Arquitectura + Backend + DevOps
