---
id: MAPEO-MIGRACION-BACKEND-001
tipo: mapeo
categoria: reorganizacion
titulo: Mapeo de Migracion docs/backend
version: 1.0.0
fecha_creacion: 2025-11-18
responsable: Equipo Backend
relacionados: ["PLAN-REORG-BACKEND-001"]
---

# MAPEO-MIGRACION-BACKEND-001: Matriz de Migracion docs/backend

**Version:** 1.0.0
**Fecha:** 2025-11-18
**Proposito:** Documentar mapeo detallado origen → destino para reorganizacion

---

## 1. RESUMEN EJECUTIVO

### 1.1 Estadisticas

| Metrica | Valor |
|---------|-------|
| Carpetas nuevas creadas | 13 |
| Carpetas a consolidar | 12 |
| Archivos raiz a mover | 11 |
| Total de archivos a migrar | ~50+ |
| Fases de migracion | 3 |

### 1.2 Carpetas Nuevas (FASE 1 - Completada)

1. OK adr/ - Architecture Decision Records
2. OK catalogos/ - Catalogos de componentes
3. OK ci_cd/ - Documentacion CI/CD
4. OK ejemplos/ - Ejemplos de codigo
5. OK estilos/ - Guias de estilo
6. OK glosarios/ - Glosario tecnico
7. OK metodologias/ - Metodologias aplicadas
8. OK plantillas/ - Plantillas de documentos
9. OK procesos/ - Procesos high-level
10. OK referencias/ - Referencias tecnicas
11. OK templates/ - Templates adicionales
12. OK trazabilidad/ - Matrices de trazabilidad
13. OK vision_y_alcance/ - Vision estrategica

---

## 2. MATRIZ DE MIGRACION - FASE 2 (CRITICA)

### 2.1 Consolidacion de diseno/

#### 2.1.1 arquitectura/ → diseno/arquitectura/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| arquitectura/diagramas/analisis_arquitectura_completo.puml | diseno/arquitectura/diagramas/analisis_arquitectura_completo.puml | MOVER | Consolidar todos los diseños arquitectonicos |
| arquitectura/decisions/README.md | diseno/arquitectura/decisions/README.md | MOVER | Mantener decisiones con arquitectura |
| arquitectura/decisions/ADR-BACKEND-001-ejemplo.md | adr/ADR-BACK-001-arquitectura-permisos.md | MOVER + RENOMBRAR | Convertir a ADR formal |

**Accion Post-Migracion:**
```bash
# Eliminar carpeta vacia
rmdir docs/backend/arquitectura/decisions/
rmdir docs/backend/arquitectura/diagramas/
rmdir docs/backend/arquitectura/
```

---

#### 2.1.2 diseno_detallado/ → diseno/detallado/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| diseno_detallado/diagramas/** | diseno/detallado/diagramas/** | MOVER | Ya existe estructura, consolidar |
| diseno_detallado/README.md | diseno/detallado/README.md | ACTUALIZAR | Merge con README existente |

**Nota:** La carpeta `diseno/detallado/` ya existe con contenido. Consolidar ambas.

---

#### 2.1.3 permisos/ → diseno/permisos/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| permisos/arquitectura_permisos_granular.md | diseno/permisos/arquitectura_permisos_granular.md | MOVER | Diseño de permisos |
| permisos/ARQUITECTURA_PERMISOS_UML.md | diseno/permisos/ARQUITECTURA_PERMISOS_UML.md | MOVER | Diagramas UML de permisos |
| permisos/API-permisos.md | diseno/permisos/API-permisos.md | MOVER | Diseño de API de permisos |
| permisos/OPTIMIZACIONES_PERFORMANCE.md | diseno/permisos/OPTIMIZACIONES_PERFORMANCE.md | MOVER | Diseño de optimizaciones |
| permisos/MEJORAS_MIDDLEWARE_PROPUESTAS.md | diseno/permisos/MEJORAS_MIDDLEWARE_PROPUESTAS.md | MOVER | Propuestas de diseño |
| permisos/ANALISIS_RESTRICCIONES_VS_MEJORAS.md | diseno/permisos/ANALISIS_RESTRICCIONES_VS_MEJORAS.md | MOVER | Analisis de diseño |
| permisos/promptops/** | diseno/permisos/promptops/** | MOVER | Scripts relacionados con permisos |

**Accion Post-Migracion:**
```bash
# Eliminar carpeta vacia
rmdir docs/backend/permisos/
```

---

#### 2.1.4 Crear diseno/database/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| migrations_strategy.md | diseno/database/migrations_strategy.md | MOVER | Estrategia de BD |
| template_requisito_funcional.md (seccion DB) | diseno/database/database-schema.md | EXTRAER | Diseño de esquema |
| plantilla_database_design.md | plantillas/plantilla-database-design.md | MOVER | Consolidar plantillas |

---

### 2.2 Consolidacion de planificacion/

#### 2.2.1 feasibility/ → planificacion/feasibility/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| feasibility/feasibility_analysis.md | planificacion/feasibility/feasibility_analysis.md | MOVER | Analisis de viabilidad |

---

#### 2.2.2 planning/ + planificacion_y_releases/ → planificacion/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| planning/planning_output.md | planificacion/planning/planning_output.md | MOVER | Salidas de planificacion |
| planificacion_y_releases/README.md | planificacion/releases/README.md | MOVER | Info de releases |

---

#### 2.2.3 analisis_negocio/ → planificacion/analisis_negocio/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| analisis_negocio/** | planificacion/analisis_negocio/** | MOVER | Analisis de negocio en planificacion |

---

#### 2.2.4 analisis/ → Distribuir segun contenido

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| analisis_congruencia_docs_codigo.md | qa/analisis_congruencia_docs_codigo.md | MOVER | Es QA |

---

### 2.3 Consolidacion de sesiones/

#### 2.3.1 2025-11-11/ → sesiones/SESION-2025-11-11/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| 2025-11-11/README.md | sesiones/SESION-2025-11-11/README.md | MOVER | Sesion de trabajo |
| 2025-11-11/analisis_cobertura_requisitos.md | sesiones/SESION-2025-11-11/analisis_cobertura_requisitos.md | MOVER | Analisis de sesion |
| 2025-11-11/requirements_session_summary.md | sesiones/SESION-2025-11-11/requirements_session_summary.md | MOVER | Resumen de sesion |

---

#### 2.3.2 registros/ → sesiones/registros/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| registros/2025_02_16_ejecucion_pytest.md | sesiones/registros/2025-02-16-ejecucion-pytest.md | MOVER + RENOMBRAR | Normalizar nombre |
| registros/2025_11_02_ejecucion_pytest.md | sesiones/registros/2025-11-02-ejecucion-pytest.md | MOVER + RENOMBRAR | Normalizar nombre |

---

#### 2.3.3 tareas/ → sesiones/tareas/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| tareas/README.md | sesiones/tareas/README.md | MOVER | Tareas operacionales |
| TASK-*.md (raiz) | sesiones/tareas/TASK-*.md | MOVER | Consolidar tareas |

---

### 2.4 Consolidacion de qa/

#### 2.4.1 validaciones/ → qa/validaciones/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| validaciones/VALIDACION_RAPIDA.md | qa/validaciones/VALIDACION_RAPIDA.md | MOVER | Validacion de QA |
| validaciones/VALIDACION_API_CALLCENTERSITE.md | qa/validaciones/VALIDACION_API_CALLCENTERSITE.md | MOVER | Validacion de API |
| validaciones/INDICE_VALIDACION.md | qa/validaciones/INDICE_VALIDACION.md | MOVER | Indice de validaciones |
| validaciones/CORRECCIONES_MENORES.md | qa/validaciones/CORRECCIONES_MENORES.md | MOVER | Correcciones |
| validaciones/RESUMEN_VALIDACION.md | qa/validaciones/RESUMEN_VALIDACION.md | MOVER | Resumen |
| validaciones/ANALISIS_URLS_COMPLETO.md | qa/validaciones/ANALISIS_URLS_COMPLETO.md | MOVER | Analisis |

---

### 2.5 Consolidacion de procedimientos/

#### 2.5.1 deployment/ → procedimientos/deployment/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| deployment/README.md | procedimientos/deployment/README.md | MOVER | Procedimientos de deploy |
| deployment/deployment_plan.md | procedimientos/deployment/deployment_plan.md | MOVER | Plan de deployment |

---

## 3. ARCHIVOS EN RAIZ - REDISTRIBUCION

### 3.1 Plantillas → plantillas/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| plantilla_api_reference.md | plantillas/plantilla-api-reference.md | MOVER + RENOMBRAR | Consolidar plantillas |
| plantilla_database_design.md | plantillas/plantilla-database-design.md | MOVER + RENOMBRAR | Consolidar plantillas |
| plantilla_etl_job.md | plantillas/plantilla-etl-job.md | MOVER + RENOMBRAR | Consolidar plantillas |
| plantilla_plan.md | plantillas/plantilla-plan.md | MOVER + RENOMBRAR | Consolidar plantillas |
| plantilla_spec.md | plantillas/plantilla-spec.md | MOVER + RENOMBRAR | Consolidar plantillas |
| plantilla_tdd.md | plantillas/plantilla-tdd.md | MOVER + RENOMBRAR | Consolidar plantillas |

**Convencion de Nomenclatura:** Usar guion medio (-) en lugar de guion bajo (_)

---

### 3.2 Documentos Tecnicos → Ubicaciones Especificas

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| implementacion_permisos_granular.md | diseno/permisos/implementacion_permisos_granular.md | MOVER | Implementacion de diseño |
| management_commands_permisos.md | guias/management_commands_permisos.md | MOVER | Guia de comandos |
| analisis_congruencia_docs_codigo.md | qa/analisis_congruencia_docs_codigo.md | MOVER | Analisis de QA |
| lineamientos_codigo.md | gobernanza/lineamientos_codigo.md | MANTENER | Ya en ubicacion correcta |
| calidad_codigo_automatizacion.md | gobernanza/calidad_codigo_automatizacion.md | MANTENER | Ya en ubicacion correcta |

---

### 3.3 Casos de Uso → requisitos/casos_uso/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| UC-PERM-001_asignar_grupo_a_usuario.md | requisitos/casos_uso/UC-PERM-001-asignar-grupo-a-usuario.md | MOVER + RENOMBRAR | Casos de uso en requisitos |
| UC-PERM-002_revocar_grupo_a_usuario.md | requisitos/casos_uso/UC-PERM-002-revocar-grupo-a-usuario.md | MOVER + RENOMBRAR | Normalizar nombre |
| UC-PERM-003_conceder_permiso_excepcional.md | requisitos/casos_uso/UC-PERM-003-conceder-permiso-excepcional.md | MOVER + RENOMBRAR | Normalizar nombre |
| UC-PERM-004_revocar_permiso_excepcional.md | requisitos/casos_uso/UC-PERM-004-revocar-permiso-excepcional.md | MOVER + RENOMBRAR | Normalizar nombre |
| UC-PERM-005_crear_grupo_permisos.md | requisitos/casos_uso/UC-PERM-005-crear-grupo-permisos.md | MOVER + RENOMBRAR | Normalizar nombre |
| UC-PERM-006_asignar_capacidades_grupo.md | requisitos/casos_uso/UC-PERM-006-asignar-capacidades-grupo.md | MOVER + RENOMBRAR | Normalizar nombre |
| UC-PERM-007_verificar_permiso_usuario.md | requisitos/casos_uso/UC-PERM-007-verificar-permiso-usuario.md | MOVER + RENOMBRAR | Normalizar nombre |
| UC-PERM-008_generar_menu_dinamico.md | requisitos/casos_uso/UC-PERM-008-generar-menu-dinamico.md | MOVER + RENOMBRAR | Normalizar nombre |
| UC-PERM-010_consultar_auditoria.md | requisitos/casos_uso/UC-PERM-010-consultar-auditoria.md | MOVER + RENOMBRAR | Normalizar nombre |

**Convencion:** Cambiar guion bajo (_) por guion medio (-) en nombres

---

### 3.4 Tareas → sesiones/tareas/

| Archivo Origen | Archivo Destino | Accion | Justificacion |
|----------------|-----------------|--------|---------------|
| TASK-002-validar_restricciones_criticas.md | sesiones/tareas/TASK-002-validar-restricciones-criticas.md | MOVER + RENOMBRAR | Tareas operacionales |
| TASK-003-verificar_sessionengine_en_settings.md | sesiones/tareas/TASK-003-verificar-sessionengine-en-settings.md | MOVER + RENOMBRAR | Normalizar nombre |
| TASK-005-sistema_de_metrics_interno_mysql.md | sesiones/tareas/TASK-005-sistema-de-metrics-interno-mysql.md | MOVER + RENOMBRAR | Normalizar nombre |
| TASK-021-alerting_system.md | sesiones/tareas/TASK-021-alerting-system.md | MOVER | Mantener nombre |
| TASK-022-performance_optimization.md | sesiones/tareas/TASK-022-performance-optimization.md | MOVER | Mantener nombre |
| TASK-027-advanced_analytics.md | sesiones/tareas/TASK-027-advanced-analytics.md | MOVER | Mantener nombre |
| TASK-028-etl_pipeline_automation.md | sesiones/tareas/TASK-028-etl-pipeline-automation.md | MOVER | Mantener nombre |
| TASK-030-api_rate_limiting.md | sesiones/tareas/TASK-030-api-rate-limiting.md | MOVER | Mantener nombre |
| TASK-031-api_versioning.md | sesiones/tareas/TASK-031-api-versioning.md | MOVER | Mantener nombre |
| TASK-032-integration_tests_suite.md | sesiones/tareas/TASK-032-integration-tests-suite.md | MOVER | Mantener nombre |
| TASK-035-performance_benchmarking.md | sesiones/tareas/TASK-035-performance-benchmarking.md | MOVER | Mantener nombre |
| TASK-037-load_testing.md | sesiones/tareas/TASK-037-load-testing.md | MOVER | Mantener nombre |

---

## 4. ARCHIVOS A MANTENER (NO MOVER)

| Archivo | Ubicacion Actual | Justificacion |
|---------|------------------|---------------|
| README.md | docs/backend/ | Indice principal |
| INDEX.md | docs/backend/ | Indice de contenido |
| TODO.md | docs/backend/ | Lista de pendientes |
| lineamientos_codigo.md | docs/backend/ | Lineamientos generales (considerar mover a gobernanza/) |
| calidad_codigo_automatizacion.md | docs/backend/ | QA general (considerar mover a qa/) |
| observability_layers.md | docs/backend/ | Observabilidad (considerar mover a guias/) |
| migrations_strategy.md | docs/backend/ | MOVER a diseno/database/ |

---

## 5. CARPETAS A ELIMINAR POST-MIGRACION

Una vez completada la migracion y verificado que todo funciona:

```bash
# FASE 2 - Post consolidacion
rmdir docs/backend/api
rmdir docs/backend/arquitectura
rmdir docs/backend/deployment
rmdir docs/backend/diseno_detallado # Solo si se consolido completamente
rmdir docs/backend/feasibility
rmdir docs/backend/permisos
rmdir docs/backend/planificacion_y_releases
rmdir docs/backend/planning
rmdir docs/backend/registros
rmdir docs/backend/rest_apis
rmdir docs/backend/tareas
rmdir docs/backend/validaciones
rmdir docs/backend/analisis
rmdir docs/backend/analisis_negocio
rmdir docs/backend/2025-11-11
```

**IMPORTANTE:** Solo eliminar carpetas cuando:
1. OK Todos los archivos fueron movidos
2. OK Enlaces actualizados
3. OK Tests de validacion pasaron
4. OK Revisado por Tech Lead

---

## 6. FASE 3 - CONTENIDO NUEVO

Documentos a crear en carpetas nuevas (FASE 3):

### 6.1 catalogos/
- [ ] CATALOGO-APIs.md
- [ ] CATALOGO-SERVICIOS.md
- [ ] CATALOGO-MODELOS.md
- [ ] CATALOGO-ENDPOINTS.md

### 6.2 procesos/
- [ ] PROC-BACK-001-desarrollo-features.md
- [ ] PROC-BACK-002-gestion-dependencias.md
- [ ] INDICE_PROCESOS.md

### 6.3 trazabilidad/
- [ ] MATRIZ-requisitos-tests.md
- [ ] MATRIZ-requisitos-codigo.md
- [ ] MATRIZ-casos-uso-endpoints.md

### 6.4 plantillas/
- [ ] plantilla-adr-backend.md
- [ ] plantilla-procedimiento-backend.md

### 6.5 vision_y_alcance/
- [ ] vision-backend-2025.md
- [ ] roadmap-backend.md

### 6.6 metodologias/
- [ ] TDD-metodologia.md
- [ ] clean-architecture.md

### 6.7 referencias/
- [ ] django-references.md
- [ ] drf-references.md
- [ ] python-libraries.md

### 6.8 ejemplos/
- [ ] ejemplo-test-unitario.py
- [ ] ejemplo-api-endpoint.py

### 6.9 glosarios/
- [ ] GLOSARIO-BACKEND.md

### 6.10 ci_cd/
- [ ] CI-CD-001-pipeline-tests-backend.md
- [ ] CI-CD-002-deployment-staging.md

---

## 7. CONVENCIONES DE NOMENCLATURA

### 7.1 Cambios Aplicados

| Patron Antiguo | Patron Nuevo | Ejemplo |
|----------------|--------------|---------|
| guion_bajo (_) | guion-medio (-) | plantilla_api → plantilla-api |
| UC-PERM-001_nombre | UC-PERM-001-nombre | UC-PERM-001_asignar → UC-PERM-001-asignar |
| TASK-###_nombre | TASK-###-nombre | TASK-002_validar → TASK-002-validar |
| fecha_YYYY_MM_DD | fecha-YYYY-MM-DD | 2025_11_02 → 2025-11-02 |

### 7.2 Prefijos Estandarizados

- **ADR:** Architecture Decision Record → `ADR-BACK-###`
- **PROC:** Proceso → `PROC-BACK-###`
- **PROCED:** Procedimiento → `PROCED-BACK-###`
- **CATALOGO:** Catalogo → `CATALOGO-nombre`
- **MATRIZ:** Matriz de trazabilidad → `MATRIZ-origen-destino`
- **UC:** Caso de Uso → `UC-DOMINIO-###`
- **TASK:** Tarea → `TASK-###`

---

## 8. VALIDACIONES REQUERIDAS

### 8.1 Pre-Migracion
- [ ] Backup creado (tag Git)
- [ ] Estructura objetivo existe (13 carpetas)
- [ ] READMEs creados en carpetas nuevas
- [ ] Mapeo documentado (este documento)

### 8.2 Durante Migracion
- [ ] Verificar cada archivo movido
- [ ] Actualizar enlaces internos
- [ ] Renombrar segun convenciones
- [ ] Crear subcarpetas necesarias

### 8.3 Post-Migracion
- [ ] Validar integridad de enlaces
- [ ] Verificar READMEs actualizados
- [ ] Validar nomenclatura
- [ ] Tests de validacion ejecutados
- [ ] Carpetas legacy vacias eliminadas

---

## 9. RESTRICCIONES DEL PROYECTO

Consideraciones especiales durante migracion:

### 9.1 Restricciones Tecnicas Criticas
- **NO Redis:** Documentos no deben referenciar Redis
- **NO SMTP:** No incluir funcionalidad de email
- **Sesiones MySQL:** Sesiones en base de datos
- **Dual DB:** IVR (read-only) + Analytics (write)

### 9.2 Documentos Afectados
- Validar que documentacion de configuracion refleje restricciones
- Actualizar ejemplos para usar MySQL sessions
- Documentar configuracion dual DB en diseño

---

## 10. TIMELINE DE EJECUCION

| Fase | Duracion | Estado |
|------|----------|--------|
| FASE 1: Preparacion | Semana 1 | OK COMPLETADA |
| - TASK-001: Backup | - | OK |
| - TASK-002: Crear carpetas | - | OK |
| - TASK-003: Crear READMEs | - | OK |
| - TASK-004: .gitkeep | - | OK |
| - TASK-005: Mapeo | - | OK |
| FASE 2: Reorganizacion | Semanas 2-3 | PENDIENTE |
| FASE 3: Contenido nuevo | Semanas 4-5 | PENDIENTE |
| FASE 4: Validacion | Semana 6 | PENDIENTE |

---

## 11. SCRIPTS DE MIGRACION

### 11.1 Script de Validacion Pre-Migracion

```bash
#!/bin/bash
# validate-pre-migration.sh

echo "Validando pre-requisitos de migracion..."

# Verificar backup
if git tag | grep -q "backup-reorganizacion-backend-2025-11-18"; then
 echo "OK Backup tag existe"
else
 echo " Falta backup tag"
 exit 1
fi

# Verificar 13 carpetas nuevas
EXPECTED=13
ACTUAL=$(ls -d docs/backend/{adr,catalogos,ci_cd,ejemplos,estilos,glosarios,metodologias,plantillas,procesos,referencias,templates,trazabilidad,vision_y_alcance} 2>/dev/null | wc -l)

if [ "$ACTUAL" -eq "$EXPECTED" ]; then
 echo "OK 13 carpetas nuevas existen"
else
 echo " Faltan carpetas: $ACTUAL/$EXPECTED"
 exit 1
fi

echo "OK Pre-requisitos cumplidos"
```

### 11.2 Script de Migracion Fase 2.1

```bash
#!/bin/bash
# migrate-fase-2-1-diseno.sh

echo "Iniciando migracion FASE 2.1: Consolidacion diseno/"

# Crear estructura
mkdir -p docs/backend/diseno/{arquitectura,permisos,database,detallado}

# Mover arquitectura
echo "Moviendo arquitectura..."
mv docs/backend/arquitectura/* docs/backend/diseno/arquitectura/

# Mover permisos
echo "Moviendo permisos..."
mv docs/backend/permisos/* docs/backend/diseno/permisos/

# Mover archivos de BD
echo "Moviendo documentos de BD..."
mv docs/backend/migrations_strategy.md docs/backend/diseno/database/

echo "OK Fase 2.1 completada"
```

---

## 12. CONTACTO Y SOPORTE

**Responsable:** Equipo Backend
**Revisor:** Tech Lead
**Preguntas:** Crear issue en repositorio

---

**Documento creado:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** ACTIVO
