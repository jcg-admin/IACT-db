# Indice - Dominio INFRAESTRUCTURA

**Dominio:** infraestructura  
**Proposito:** Documentacion completa del dominio infraestructura del proyecto IACT

---

## Estructura del Dominio

Este dominio sigue la arquitectura estandar por dominios (ADR-010) con 12 subdirectorios:

- **guias/** (1 archivos MD)
- **procedimientos/** (1 archivos MD)
- **qa/** (1 archivos MD)
- **solicitudes/** (1 archivos MD)
- **planificacion_y_releases/** (1 archivos MD)
- **plans/** (1 archivos MD)
- **sesiones/** (1 archivos MD)
- **diseno_detallado/** (1 archivos MD)
- **testing/** (1 archivos MD)
- **tareas/** (1 archivos MD)
- **arquitectura/** (1 archivos MD)
- **requisitos/** (18 archivos MD)

---

## Archivos Principales

- ADR_2025_001_vagrant_mod_wsgi.md
- ADR_2025_002_suite_calidad_codigo.md
- ADR_2025_007_git_hooks_validation_strategy.md
- ADR_2025_011_wasi_style_virtualization.md
- ADR_2025_012_cpython_features_vs_imagen_base.md
- ADR_2025_013_distribucion_artefactos_strategy.md
- CHANGELOG-cpython.md
- README.md
- TASK-017-layer3_infrastructure_logs.md
- ambientes_virtualizados.md
- cpython_builder.md
- cpython_development_guide.md
- estrategia_git_hooks.md
- estrategia_migracion_shell_scripts.md
- implementation_report.md
- index.md
- matriz_trazabilidad_rtm.md
- shell_scripts_constitution.md
- spec_infra_001_cpython_precompilado.md
- srs_software_requirements.md
- storage_architecture.md
- tareas_activas.md
- template_requisito_no_funcional.md
- wasi_environment_integration.md

---

## Navegacion Rapida

### Documentacion Tecnica
- [Arquitectura](arquitectura/) - Decisiones arquitectonicas del dominio
- [Diseño Detallado](diseno_detallado/) - Especificaciones tecnicas
- [Requisitos](requisitos/) - Requisitos del dominio

### Desarrollo
- [Tareas](tareas/) - Tareas de desarrollo
- [Testing](testing/) - Tests y validaciones
- [Plans](plans/) - Planes de ejecucion

### Gestion
- [Planificacion y Releases](planificacion_y_releases/) - Planning y releases
- [Solicitudes](solicitudes/) - Solicitudes de cambio
- [Sesiones](sesiones/) - Sesiones de trabajo

### Operaciones
- [QA](qa/) - Quality Assurance
- [Guias](guias/) - Guias de uso
- [Procedimientos](procedimientos/) - Procedimientos operativos

---

## Recursos Transversales

- [Gobernanza](../gobernanza/) - Estandares y politicas
- [DevOps](../devops/) - CI/CD y automatizacion
- [Documentacion Root](../) - Indice maestro

---

## Tareas del Dominio

**Total TASKs:** 2

- [TASK-018-cassandra_cluster_setup.md](tareas/TASK-018-cassandra_cluster_setup.md)
- [TASK-017-layer3_infrastructure_logs.md](TASK-017-layer3_infrastructure_logs.md)

---

**Ultima actualizacion:** 2025-11-16
