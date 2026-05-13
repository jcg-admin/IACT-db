---
id: DOC-METODOLOGIAS-INDEX
estado: activo
tipo: indice
categoria: metodologia
prioridad: alta
version: 1.0.0
ultima_actualizacion: 2025-11-06
relacionados: ["DOC-GOBERNANZA-INDEX", "DOC-PROCESOS-INDEX", "AGENTES_SDLC"]
date: 2025-11-13
---

# Indice: Metodologias de Desarrollo

## Proposito

Este directorio contiene las metodologias y enfoques de desarrollo utilizados en el proyecto IACT. Incluye documentacion sobre:
- Metodologias de desarrollo especificas del proyecto
- Arquitectura y automatizacion con agentes IA
- Workflows completos de CI/CD
- Estrategias de desarrollo por lotes

## Archivos

### Metodologias

| Archivo | Descripcion | Estado |
|---------|-------------|--------|
| [METODOLOGIA_DESARROLLO_POR_LOTES.md](METODOLOGIA_DESARROLLO_POR_LOTES.md) | Metodologia de desarrollo incremental por lotes, con enfoque en entregas pequenas y validacion continua | Activo |
| [WORKFLOWS_COMPLETOS.md](WORKFLOWS_COMPLETOS.md) | Documentacion completa de workflows CI/CD implementados en el proyecto | Activo |

### Agentes IA y Automatizacion

| Archivo | Descripcion | Estado |
|---------|-------------|--------|
| [automatizacion_servicios.md](automatizacion_servicios.md) | Vision general de agentes IA para automatizacion de tareas de desarrollo | Activo |
| [arquitectura_servicios_especializados.md](arquitectura_servicios_especializados.md) | Arquitectura detallada de agentes SDLC especializados por fase | Activo |

## Relacion con Otros Documentos

### Procedimientos
Los procedimientos en `docs/gobernanza/procesos/procedimientos/` implementan estas metodologias:
- `procedimiento_desarrollo_local.md` - Implementa metodologia de desarrollo por lotes
- `guia_completa_desarrollo_features.md` - Sigue metodologia incremental

### Agentes SDLC
Los agentes documentados aqui estan implementados en:
- `scripts/ai/agents/` - Implementacion de agentes especializados
- `docs/gobernanza/procesos/AGENTES_SDLC.md` - Documentacion completa de agentes

### Workflows CI/CD
Los workflows documentados aqui estan en:
- `.github/workflows/` - Implementacion de workflows
- `docs/gobernanza/ci_cd/` - Documentacion de workflows CI/CD
- `.claude/workflow_template_mapping.json` - Mapeo de workflows a templates

## Uso

### Para Developers
1. Leer `METODOLOGIA_DESARROLLO_POR_LOTES.md` antes de empezar desarrollo
2. Consultar `WORKFLOWS_COMPLETOS.md` para entender CI/CD
3. Ver `arquitectura_servicios_especializados.md` para usar agentes IA

### Para Tech Leads
1. Usar estas metodologias como base para planning
2. Validar que el equipo sigue las metodologias documentadas
3. Actualizar metodologias cuando sea necesario

### Para QA
1. Validar que el desarrollo sigue la metodologia de lotes
2. Verificar que workflows CI/CD se ejecutan correctamente
3. Revisar que agentes generan documentacion esperada

## Actualizaciones

**Responsable:** Tech Lead

**Cuando actualizar:**
- Al cambiar metodologia de desarrollo
- Al agregar/modificar agentes IA
- Al implementar nuevos workflows CI/CD
- Al identificar mejoras en procesos

**Proceso:**
1. Actualizar archivo relevante
2. Validar con el equipo
3. Actualizar version y fecha
4. Commit: `docs(metodologias): <descripcion>`
5. Notificar al equipo

## Referencias

### Documentos Relacionados
- [INDICE General](../../INDICE.md)
- [Gobernanza](../README.md)
- [Procesos](../procesos/README.md)
- [Agentes SDLC](../procesos/AGENTES_SDLC.md)
- [CI/CD](../ci_cd/INDICE.md)

### Standards
- BABOK v3 - Business Analysis Knowledge Areas
- PMBOK 7 - Project Management Body of Knowledge
- ISO/IEC/IEEE 29148:2018 - Requirements engineering

## Changelog

| Version | Fecha | Cambios | Autor |
|---------|-------|---------|-------|
| 1.0.0 | 2025-11-06 | Creacion inicial - migracion desde docs_legacy/desarrollo/ | Equipo Gobernanza |

---

**Para navegacion rapida:**
- Volver a [Gobernanza](../README.md)
- Volver a [INDICE General](../../INDICE.md)
