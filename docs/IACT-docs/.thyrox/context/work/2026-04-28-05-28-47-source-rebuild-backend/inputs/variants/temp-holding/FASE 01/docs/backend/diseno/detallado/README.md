---
id: DOC-DIS-BACKEND
estado: activo
propietario: equipo-backend
ultima_actualizacion: 2025-11-18
relacionados: ["DOC-ARQ-BACKEND", "DOC-REQ-INDEX", "DOC-UX-INDEX"]
date: 2025-11-18
---
# Diseño Detallado del Backend

Extiende las decisiones de arquitectura hacia especificaciones técnicas por módulo del backend. Este espacio sirve como puente entre requisitos priorizados y el trabajo de desarrollo siguiendo TDD.

## Contenido

Este directorio contiene:

- **Diseños Técnicos por Módulo**: Especificaciones detalladas de implementación
- **Diagramas UML**: Diagramas de secuencia, actividad, casos de uso, y ER
- **Contratos de Servicio**: Interfaces y APIs entre componentes

## Archivos

### Documentos de Diseño

- `diseno_tecnico_autenticacion.md`: Diseño técnico completo del módulo de autenticación

### Diagramas

El subdirectorio `diagramas/` está organizado por tipo:

#### Diagramas de Actividad (`diagramas/actividad/`)
- `UC-001_generar_reporte_metricas_act.puml`
- `UC-002_registrar_llamada_entrante_act.puml`
- `UC-003_consultar_estado_pedido_act.puml`

#### Diagramas de Casos de Uso (`diagramas/casos_de_uso/`)
- `UC-001_generar_reporte_metricas.puml`
- `UC-002_registrar_llamada_entrante.puml`
- `UC-003_consultar_estado_pedido.puml`
- `UC-PERM-001_asignar_grupo.puml`
- `UC-PERM-002_revocar_grupo_seq.puml`
- `UC-PERM-003_conceder_excepcional_seq.puml`
- `UC-PERM-007_verificar_permiso_seq.puml`
- `UC-PERM-008_menu_dinamico_seq.puml`

#### Diagramas de Base de Datos (`diagramas/database/`)
- `permisos_granular_er.puml`: Diagrama ER del sistema de permisos

#### Diagramas de Secuencia (`diagramas/secuencia/`)
- `UC-001_generar_reporte_metricas_seq.puml`
- `UC-002_registrar_llamada_entrante_seq.puml`
- `UC-003_consultar_estado_pedido_seq.puml`
- `UC-PERM-001_asignar_grupo_seq.puml`

## Página padre
- [`../README.md`](../README.md)

## Páginas hijas
- [Diseño Técnico Autenticación](./diseno_tecnico_autenticacion.md)
- Diagramas UML (ver subdirectorios)

## Información clave

### Rol dentro del flujo de documentación
- Recibe acuerdos priorizados para convertirlos en diseños concretos
- Alimenta listas de materiales técnicas para anexar en [`../../anexos/`](../../anexos/)
- Proporciona checklists de revisión técnica antes de liberar trabajo a desarrollo y QA

### Artefactos esperados
- Modelos de datos y contratos de servicio (usar `../../plantilla_database_design.md` y `../../plantilla_api_reference.md`)
- Diagramas de secuencia y estados (basarse en plantillas UML)
- Catálogo de módulos del monolito modular y sus dependencias

## Estado de cumplimiento
| Elemento en la base maestra | ¿Existe en repositorio? | Observaciones |
| --- | --- | --- |
| Portada del espacio de diseño detallado | [OK] Sí | Este archivo mantiene la jerarquía y metadatos requeridos para el backend |
| Modelos de datos/documentación técnica | [OK] Parcial | Existe diseño de autenticación, faltan otros módulos |
| Diagramas UML | [OK] Sí | 15+ diagramas UML organizados por tipo |
| Catálogo de módulos del monolito | En progreso | Pendiente de definir tras las sesiones de arquitectura |
| Checklist de revisión técnica | [ERROR] No | Debe derivarse en coordinación con QA y DevOps |

## Integración con el flujo documental principal
- Toma decisiones base de [`../arquitectura/README.md`](../arquitectura/README.md)
- Mantiene coherencia con runbooks de despliegue
- Coordina validaciones con [`../../qa/`](../../qa/)

## Generación de Diagramas

```bash
# Generar todos los diagramas de actividad
plantuml -tsvg diagramas/actividad/*.puml

# Generar todos los diagramas de secuencia
plantuml -tsvg diagramas/secuencia/*.puml

# Generar todos los diagramas
plantuml -tsvg diagramas/**/*.puml
```

## Gobernanza

Consulta **primero** la gobernanza global:
- [Diseño Global](../../../gobernanza/diseno/)
- [ADR-GOB-004: PlantUML para Diagramas](../../../gobernanza/adr/ADR-GOB-004-plantuml-para-diagramas.md)
- [GUIA-GOB-008: Crear Diagramas PlantUML](../../../gobernanza/guias/GUIA-GOB-008-crear-diagramas-plantuml.md)

## Acciones prioritarias
- [x] WKF-SDLC-140 – Documentar módulos iniciales _(Completado: autenticación)_
- [x] WKF-SDLC-141 – Definir convenciones de diagramación _(Completado: siguiendo ADR-GOB-004)_
- [ ] WKF-SDLC-142 – Crear checklist de revisión técnica _(Pendiente; complementar paso de liberación)_
- [ ] WKF-SDLC-143 – Completar diseños de módulos core _(En progreso)_

## Próximos Pasos

1. Completar diseño técnico de módulos core (llamadas, analytics, ETL)
2. Generar diagramas ER para todos los módulos
3. Documentar contratos de servicio entre módulos
4. Crear checklist de revisión técnica
5. Validar diseños con stakeholders

## Ownership

Maintainer: Tech Lead Backend
Review: Arquitecto Senior + Equipo Backend
