# Auditoria de Nombres de Archivos Genericos

Fecha: 2025-11-16
Objetivo: Identificar archivos con nombres poco descriptivos y proponer renombramientos

---

## Resumen Ejecutivo

**Archivos auditados:** 862 archivos .md
**Problemas encontrados:** 150+ archivos con nombres genéricos
**Categorias de problemas:** 4

---

## CATEGORIA 1: Archivos con Numeros Secuenciales (NO DESCRIPTIVOS)

### Problema
Archivos nombrados con números secuenciales (_001, _002, etc.) no indican su contenido.

### 1.1 QA/Testing (YA IDENTIFICADOS)

**Problema:**
```
backend/qa/testing_001.md         # ¿Qué tests?
frontend/qa/testing_002.md        # ¿Qué tests?
gobernanza/qa/testing_003.md      # ¿Qué tests?
```

**Propuesta:**
```bash
# Backend
mv backend/qa/testing_001.md backend/qa/guia_ejecutar_pytest.md

# Frontend
mv frontend/qa/testing_002.md frontend/qa/guia_ejecutar_jest_e2e.md

# Gobernanza
mv gobernanza/qa/testing_003.md gobernanza/qa/estrategia_test_pyramid.md
```

### 1.2 Onboarding (8 archivos)

**Problema:**
```
gobernanza/onboarding/onboarding_001.md  # Configurar Entorno de Desarrollo Local
gobernanza/onboarding/onboarding_002.md  # Ejecutar Proyecto Localmente
gobernanza/onboarding/onboarding_003.md  # Estructura del Proyecto IACT
gobernanza/onboarding/onboarding_004.md  # Configurar Variables de Entorno
gobernanza/onboarding/onboarding_005.md  # Usar Agentes SDLC - Planning
gobernanza/onboarding/onboarding_006.md  # Validar Documentacion
gobernanza/onboarding/onboarding_007.md  # Generar Indices de Requisitos
gobernanza/onboarding/onboarding_008_atencion_cliente.md  # (ya tiene descripcion)
```

**Propuesta:**
```bash
mv onboarding_001.md configurar_entorno_desarrollo.md
mv onboarding_002.md ejecutar_proyecto_localmente.md
mv onboarding_003.md estructura_proyecto_iact.md
mv onboarding_004.md configurar_variables_entorno.md
mv onboarding_005.md usar_agentes_sdlc_planning.md
mv onboarding_006.md validar_documentacion.md
mv onboarding_007.md generar_indices_requisitos.md
mv onboarding_008_atencion_cliente.md operaciones_agente_call_center.md
```

### 1.3 Deployment (5 archivos)

**Problema:**
```
devops/deployment/deployment_001.md  # No indica que deployment es
devops/deployment/deployment_002.md  # No indica que deployment es
devops/deployment/deployment_003_implementacion_permisos_granular.md  # OK - descriptivo
devops/deployment/deployment_004_tdd_backend_permisos_granular.md     # OK - descriptivo
devops/deployment/deployment_005_tdd_frontend_permisos_granular.md    # OK - descriptivo
```

**Necesito ver contenido:**
```bash
# Revisar deployment_001.md y deployment_002.md para renombrar apropiadamente
```

### 1.4 Troubleshooting

**Problema:**
```
operaciones/troubleshooting/troubleshooting_001.md  # ¿Qué troubleshooting?
```

**Propuesta:**
```bash
# Necesita revisarse para nombre descriptivo
```

### 1.5 ADRs Duplicados con Formato Viejo

**Problema:**
```
# Formato viejo (guiones bajos)
infraestructura/ADR_2025_001_vagrant_mod_wsgi.md
infraestructura/ADR_2025_002_suite_calidad_codigo.md
ai/ADR_2025_003_dora_sdlc_integration.md
backend/ADR_2025_004_centralized_log_storage.md
backend/ADR_2025_005_grupos_funcionales_sin_jerarquia.md

# Formato nuevo (guiones)
gobernanza/adr/ADR-020-organizacion-documentacion-por-dominio.md
gobernanza/adr/ADR-040-schema-validator-agent.md
```

**Propuesta:**
```bash
# Estandarizar TODO a formato: ADR-NNN-descripcion-kebab-case.md
# Mover ADRs sueltos a subdirectorios adr/ de cada dominio
```

**Convención recomendada:** `ADR-NNN-descripcion-kebab-case.md`

---

## CATEGORIA 2: Archivos en MAYUSCULAS (Deberían ser minúsculas)

### Problema
Archivos en MAYÚSCULAS que NO son especiales (README, CHANGELOG, etc.)

### 2.1 Infraestructura (7 archivos)

**Actual:**
```
infraestructura/ESTRATEGIA_GIT_HOOKS.md
infraestructura/WASI_ENVIRONMENT_INTEGRATION.md
infraestructura/SHELL_SCRIPTS_CONSTITUTION.md
infraestructura/STORAGE_ARCHITECTURE.md
infraestructura/IMPLEMENTATION_REPORT.md
infraestructura/ESTRATEGIA_MIGRACION_SHELL_SCRIPTS.md
infraestructura/AMBIENTES_VIRTUALIZADOS.md
infraestructura/TAREAS_ACTIVAS.md
```

**Propuesta:**
```bash
mv ESTRATEGIA_GIT_HOOKS.md estrategia_git_hooks.md
mv WASI_ENVIRONMENT_INTEGRATION.md wasi_environment_integration.md
mv SHELL_SCRIPTS_CONSTITUTION.md shell_scripts_constitution.md
mv STORAGE_ARCHITECTURE.md storage_architecture.md
mv IMPLEMENTATION_REPORT.md implementation_report.md
mv ESTRATEGIA_MIGRACION_SHELL_SCRIPTS.md estrategia_migracion_shell_scripts.md
mv AMBIENTES_VIRTUALIZADOS.md ambientes_virtualizados.md
mv TAREAS_ACTIVAS.md tareas_activas.md
```

### 2.2 Gobernanza/Procesos (Muchos archivos)

**Actual:**
```
gobernanza/procesos/AGENTES_SDLC.md
gobernanza/procesos/DEVOPS_AUTOMATION.md
gobernanza/procesos/INDICE_WORKFLOWS.md
gobernanza/procesos/MAPEO_PROCESOS_TEMPLATES.md
gobernanza/procesos/SDLC_PROCESS.md
```

**Propuesta:**
```bash
mv AGENTES_SDLC.md agentes_sdlc.md
mv DEVOPS_AUTOMATION.md devops_automation.md
mv INDICE_WORKFLOWS.md indice_workflows.md
mv MAPEO_PROCESOS_TEMPLATES.md mapeo_procesos_templates.md
mv SDLC_PROCESS.md sdlc_process.md
```

### 2.3 AI (Muchísimos archivos)

**Actual:**
```
ai/ADVANCED_PROMPTING_TECHNIQUES.md
ai/AGENTES_Y_TECNICAS_APLICADAS.md
ai/ANALISIS_POLITICA_NO_EMOJIS.md
ai/CASOS_DE_USO_SDLC.md
ai/CHANGELOG.md                                # OK - archivo especial
ai/ESTRATEGIA_CREDITOS_LLM.md
ai/FINE_TUNING_TINYLLAMA.md
ai/FLUJO_CONEXION_DATABASE.md
ai/META_AGENTS_PROGRESS.md
ai/PLAN_EJECUCION_COMPLETO.md
ai/REPORTE_FINAL_IACT.md
ai/REPORTE_FINAL_SESION.md
ai/REPORTE_FINAL_SESION_001.md
ai/REPORTE_INTERMEDIO_001.md
ai/ROADMAP.md
ai/SDLC_AGENTS_GUIDE.md
ai/TAREAS_PENDIENTES_AGENTES_IA.md
ai/TDD_STATUS.md
ai/VERIFICATION_REPORT.md
```

**Propuesta:**
```bash
# Mantener MAYÚSCULAS solo para:
# - CHANGELOG.md (especial)
# - ROADMAP.md (podría argumentarse)

# Convertir resto a snake_case minúsculas:
mv ADVANCED_PROMPTING_TECHNIQUES.md advanced_prompting_techniques.md
mv AGENTES_Y_TECNICAS_APLICADAS.md agentes_y_tecnicas_aplicadas.md
mv ANALISIS_POLITICA_NO_EMOJIS.md analisis_politica_no_emojis.md
# ... etc (19+ archivos)
```

### 2.4 Sesiones/2025-11 (Muchos reportes)

**Actual:**
```
sesiones/2025-11/ANALISIS_COMPLETITUD_REORGANIZACION.md
sesiones/2025-11/PROPUESTA_FINAL_REESTRUCTURACION.md
sesiones/2025-11/CATALOGO_TODOS_PENDIENTES.md
sesiones/2025-11/REPORTE_DUPLICADOS.md
sesiones/2025-11/AGENTS.md
sesiones/2025-11/ANUNCIO_EQUIPO_REORGANIZACION.md
sesiones/2025-11/REPORTE_REORGANIZACION.md
sesiones/2025-11/TDD_REFACTOR_RESUMEN.md
# ... 20+ archivos más
```

**Decision:**
Archivos de sesiones/reportes históricos pueden mantenerse en MAYÚSCULAS (son "archivos especiales" de sesión) O convertir todos a minúsculas para consistencia.

**Recomendación:** Convertir a minúsculas para consistencia global.

### 2.5 Backend

**Actual:**
```
backend/ARQUITECTURA-MODULOS-COMPLETA.md
backend/ANALISIS_CONGRUENCIA_DOCS_CODIGO.md
backend/ANALISIS_IMPLEMENTACION_PRIORIDAD_02.md
backend/CASOS_DE_USO_SISTEMA_PERMISOS.md
backend/GUIA_USO_PRIORIDAD_02.md
backend/IMPLEMENTACION_PERMISOS_GRANULAR.md
backend/MODULOS_IMPLEMENTADOS_20251111.md
backend/OBSERVABILITY_LAYERS.md
backend/PLAN_MAESTRO_PRIORIDAD_02.md
backend/PYTEST_ENVIRONMENT_FIX.md
backend/REPORTE_EJECUCION_TASK_001_004.md
backend/REPORTE_INTERMEDIO_01.md
backend/RESUMEN_IMPLEMENTACION_COMPLETA.md
backend/SDLC_COMPLETE_RUN_TDD_PROMPTING_TECHNIQUES.md
backend/TDD_IMPLEMENTACION.md
backend/TODO.md
```

**Propuesta:** Convertir todos a snake_case minúsculas

---

## CATEGORIA 3: Archivos con Nombres Ambiguos/Genéricos

### 3.1 README.md vs Archivos Descriptivos

**Problema:**
Algunos READMEs son demasiado grandes y específicos para ser un README

**Ejemplo:**
```
gobernanza/procesos/README.md (15KB)  # Demasiado grande - debería dividirse
```

### 3.2 Archivos "index.md"

**Problema:**
```
infraestructura/index.md  # ¿Por qué "index" y no "README"?
```

**Propuesta:**
```bash
# Si es índice de directorio, renombrar a README.md
# Si es índice específico, nombre descriptivo
```

### 3.3 TODO.md vs TAREAS_ACTIVAS.md vs tareas/

**Problema:** Inconsistencia en cómo se nombran listas de tareas

**Ejemplos:**
```
backend/TODO.md
infraestructura/TAREAS_ACTIVAS.md
infraestructura/tareas/  (directorio)
```

**Propuesta:** Estandarizar
```bash
# Opción 1: Todo en directorios tareas/
backend/tareas/pendientes.md
infraestructura/tareas/activas.md

# Opción 2: Usar solo TODO.md (GitHub lo reconoce)
backend/TODO.md
infraestructura/TODO.md
```

---

## CATEGORIA 4: Formato de Prefijos Inconsistente

### 4.1 Archivos con Prefijos

**Observado:**
```
# TASK-XXX (correcto - números)
TASK-008-cron-job-dora-mensuales.md
TASK-015-actualizacion-documentacion.md

# ADR-XXX vs ADR_YYYY_XXX (inconsistente)
ADR-020-organizacion-documentacion-por-dominio.md
ADR_2025_003_dora_sdlc_integration.md

# SPEC_INFRA_XXX (OK - pero podría mejorarse)
SPEC_INFRA_001_cpython_precompilado.md
```

**Propuesta de Estandarización:**
```bash
# TASK: TASK-NNN-descripcion-kebab-case.md
# ADR: ADR-NNN-descripcion-kebab-case.md
# SPEC: SPEC-DOMINIO-NNN-descripcion.md

# Ejemplos:
TASK-008-cron-job-dora-mensuales.md      # OK
ADR-003-dora-sdlc-integration.md          # Estandarizado
SPEC-INFRA-001-cpython-precompilado.md   # Estandarizado
```

---

## RECOMENDACIONES GLOBALES

### Convención Propuesta

```yaml
Archivos Especiales (MAYÚSCULAS):
  - README.md          # Índice de directorio
  - CHANGELOG.md       # Historial de cambios
  - CONTRIBUTING.md    # Guía de contribución
  - LICENSE.md         # Licencia
  - ADR-NNN-*.md       # Decisiones arquitecturales
  - TASK-NNN-*.md      # Tareas/issues
  - SPEC-*-NNN-*.md    # Especificaciones

Archivos Normales (snake_case minúsculas):
  - estrategia_qa.md
  - guia_pytest.md
  - procedimiento_deployment.md
  - configurar_entorno.md

Prefijos Descriptivos (opcionales pero recomendados):
  - guia_*              # Guías de usuario
  - procedimiento_*     # Procedimientos paso a paso
  - estrategia_*        # Documentos de estrategia
  - analisis_*          # Análisis técnicos
  - reporte_*           # Reportes de sesión/proyecto

Evitar:
  - Números secuenciales sin descripción (_001, _002)
  - Nombres genéricos (file.md, doc.md, test.md)
  - MAYÚSCULAS para archivos normales
```

---

## PLAN DE ACCION

### Fase 1: Renombrar Archivos Críticos (Prioridad ALTA)
1. QA/Testing con números secuenciales
2. Onboarding con números secuenciales
3. ADRs con formato inconsistente

### Fase 2: Estandarizar MAYÚSCULAS (Prioridad MEDIA)
1. Infraestructura (8 archivos)
2. Backend (16 archivos)
3. AI (19+ archivos)
4. Gobernanza/Procesos (10+ archivos)

### Fase 3: Sesiones Históricas (Prioridad BAJA)
1. sesiones/2025-11/ (20+ archivos)
- Pueden mantenerse como están (históricos)
- O convertir para consistencia total

### Fase 4: Crear ADR-021
Documentar convenciones de nomenclatura oficiales

---

## METRICAS

**Total archivos a renombrar:** 80-100 archivos
**Archivos críticos (números secuenciales):** 20 archivos
**Archivos MAYÚSCULAS a convertir:** 50-60 archivos
**Archivos ADR a estandarizar:** 10-15 archivos

**Tiempo estimado:**
- Fase 1: 30 minutos
- Fase 2: 45 minutos
- Fase 3: 20 minutos
- ADR-021: 30 minutos

---

## REFERENCIAS

- ADR-020: Organizacion de Documentacion por Dominio
- Discusión: Uso de snake_case vs MAYÚSCULAS
- Estándar industria: snake_case para archivos normales

---

**Generado:** 2025-11-16
**Siguiente paso:** Crear ADR-021 con convenciones oficiales
