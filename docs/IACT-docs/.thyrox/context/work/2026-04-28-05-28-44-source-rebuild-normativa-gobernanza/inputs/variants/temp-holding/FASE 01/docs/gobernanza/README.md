---
id: DOC-GOB-INDEX
estado: activo
propietario: equipo-gobernanza
ultima_actualizacion: 2025-11-18
relacionados: ["DOC-INDEX-GENERAL", "DOC-REQ-INDEX", "DOC-ARQ-INDEX"]
version: 2.1.0
---
# Gobernanza del Proyecto IACT

Este espacio documenta las políticas, estándares, procesos de revisión y control de cambios que rigen el desarrollo del proyecto IACT.

## Página padre
- [Índice de espacios documentales](../index.md)

## Páginas hijas

### Procesos Operativos
- [Procesos de Gobernanza](procesos/readme.md) [NUEVO]
  - [Procedimiento: Diseño Técnico](procesos/procedimiento_diseno_tecnico.md)
  - [Procedimiento: Análisis de Seguridad](procesos/procedimiento_analisis_seguridad.md)
  - [Procedimiento: Trazabilidad de Requisitos](procesos/procedimiento_trazabilidad_requisitos.md)

### Guías y Estándares
- [Estándares de Código](estandares_codigo.md)
- [Guía de Casos de Uso](casos_de_uso_guide.md)
- [Guía de Shell Scripting](shell_scripting_guide.md)

### Gobernanza por Dominio
- [Backend - Gobernanza](../backend/gobernanza/readme.md)
- [Frontend - Gobernanza](../frontend/gobernanza/readme.md)
- [Infrastructure - Gobernanza](../infrastructure/gobernanza/readme.md)

## Información clave

### Políticas de Desarrollo
- **Test-Driven Development (TDD)**: Implementación obligatoria para nuevas funcionalidades
- **Cobertura mínima**: 80% en todas las capas
- **Revisión de código**: Obligatoria antes de merge a develop/main
- **Conventional Commits**: Estándar para mensajes de commit

### Estándares de Calidad
- Análisis estático de código mediante linters
- **Output profesional**: Prohibido uso de emojis en scripts de producción
- Revisión de seguridad en dependencias
- Documentación obligatoria para APIs públicas
- Pruebas de integración para flujos críticos

Ver detalles completos en: [Estándares de Código](estandares_codigo.md)

### Proceso de Control de Cambios
1. Crear issue describiendo el cambio propuesto
2. Crear rama `feature/` desde develop
3. Implementar cambios siguiendo TDD
4. Crear Pull Request con descripción detallada
5. Pasar revisión de código y tests automatizados
6. Merge solo después de aprobación

### Arquitectura de Ramas
- `main/master`: Código en producción
- `develop`: Integración continua
- `feature/*`: Nuevas funcionalidades
- `hotfix/*`: Correcciones urgentes
- `bugfix/*`: Corrección de bugs
- `docs/*`: Cambios exclusivos de documentación

## Estado de cumplimiento

| Elemento | Estado | Observaciones |
|----------|--------|---------------|
| Políticas documentadas | [OK] | Documentado en este archivo |
| Estándares de código establecidos | [OK] | Ver `estandares_codigo.md` |
| Proceso de revisión definido | [OK] | Requiere PR review antes de merge |
| Procedimientos operativos | [OK] | 3 procedimientos core creados (2025-11-04) |
| Trazabilidad ISO 29148 | [PARCIAL] | Procedimiento creado, pendiente workflows CI/CD |
| Métricas de calidad activas | [PARCIAL] | Validaciones implementadas (FASE 4) |
| Validación de enlaces | [OK] | TASK-055: 44.97% enlaces válidos (2025-11-18) |
| Validación de READMEs | [PARCIAL] | TASK-056: 62.4% cumplimiento (2025-11-18) |
| Validación de metadatos YAML | [BAJO] | TASK-057: 0.18% metadatos válidos (2025-11-18) |
| Validación de nomenclatura | [PARCIAL] | TASK-058: 59.47% archivos, 72.34% directorios (2025-11-18) |

## Validaciones FASE 4 (2025-11-18)

### Resultados de Validación

**TASK-055: Integridad de Enlaces**
- Total archivos analizados: 1,393
- Enlaces válidos: 1,569 (44.97%)
- Enlaces rotos: 1,355 (38.83%)
- Enlaces externos: 565 (16.19%)

**TASK-056: Presencia de READMEs**
- Directorios con README: 229 de 367 (62.4%)
- Directorios sin README: 138 (37.6%)

**TASK-057: Metadatos YAML**
- Archivos con metadatos: 1,097 de 1,331 (82.42%)
- Metadatos válidos: 2 (0.18%)
- Metadatos inválidos: 1,095 (99.82%)

**TASK-058: Nomenclatura**
- Archivos válidos: 942 de 1,584 (59.47%)
- Directorios válidos: 306 de 423 (72.34%)

**TASK-059: Limpieza**
- Carpetas vacías eliminadas: 18

### Documentación Creada FASE 4

- [x] CHANGELOG.md actualizado con FASE 4
- [x] GUIA_NAVEGACION_BACKEND.md creada
- [x] README.md principal actualizado
- [x] INDEX.md actualizado a v2.1.0

## Acciones prioritarias

### Urgente (Próximas 2 semanas)
- [ ] **Corregir enlaces rotos**: 1,355 enlaces necesitan corrección (TASK-055)
- [ ] **Estandarizar metadatos YAML**: Solo 0.18% de metadatos son válidos (TASK-057)
- [ ] **Crear READMEs faltantes**: 138 directorios sin README (TASK-056)
- [ ] **Corregir nomenclatura**: 642 archivos y 117 directorios con nomenclatura inválida (TASK-058)

### Corto Plazo (1-2 meses)
- [ ] Implementar workflows CI/CD para trazabilidad ISO 29148
- [ ] Capacitar equipos en procedimientos operativos (4h sesión)
- [ ] Aplicar PROC-DISENO-TEC-001 a 3 componentes (piloto)
- [ ] Automatizar validaciones de FASE 4 en CI/CD

### Mediano Plazo (2-4 meses)
- [ ] Implementar dashboard de métricas de calidad
- [ ] Establecer SLAs para revisión de PRs
- [ ] Validar generación de índices ISO 29148 end-to-end
- [ ] Alcanzar 80% de cumplimiento en todas las validaciones

### Largo Plazo (4-6 meses)
- [ ] Documentar proceso de releases
- [ ] Definir proceso de escalamiento para decisiones arquitectónicas
- [ ] Crear registro de decisiones de gobernanza (GDR - Governance Decision Records)
- [ ] Certificar conformidad ISO/IEC/IEEE 29148:2018 Full Conformance

## Recursos relacionados

### Documentación General
- [Índice General](../INDEX.md)
- [README Principal](../../README.md)
- [Changelog](CHANGELOG.md)
- [Roadmap](ROADMAP.md)
- [Tareas Activas](TAREAS_ACTIVAS.md)

### Guías y Estándares
- [Guía de Estilo](GUIA_ESTILO.md)
- [Estándares de Código](estandares_codigo.md)
- [Guía de Casos de Uso](casos_de_uso_guide.md)
- [Guía de Shell Scripting](shell_scripting_guide.md)

### ADRs y Decisiones
- [ADRs](adr/)
- [Índice de ADRs](INDICE_ADRs.md)

### Reportes de Validación (FASE 4)
- Reporte de enlaces: `/tmp/link_validation_report.json`
- Reporte de READMEs: `/tmp/readme_validation_report.json`
- Reporte de metadatos: `/tmp/yaml_metadata_validation_report.json`
- Reporte de nomenclatura: `/tmp/nomenclature_validation_report.json`

### Integración con Herramientas
- [Convenciones de Claude Code](../../.github/claude-code-conventions.md)
- [Copilot Instructions](../../.github/copilot-instructions.md)
- [Documentación de QA](qa/)

---

**Última actualización**: 2025-11-18
**Versión**: 2.1.0
**Estado**: Activo - FASE 4 completada
