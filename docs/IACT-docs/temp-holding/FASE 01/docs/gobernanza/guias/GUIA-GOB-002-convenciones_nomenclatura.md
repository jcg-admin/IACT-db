---
id: GUIA-GOB-002
tipo: guia
categoria: gobernanza
subcategoria: estandares
version: 1.0.0
fecha_creacion: 2025-11-17
autor: Claude Code (Sonnet 4.5)
estado: activo
aprobado_por: pendiente
relacionados: ["GUIA-001", "ANALISIS-INCONSISTENCIAS-NOMENCLATURA-001"]
---

# GUIA: Convenciones de Nomenclatura de Documentacion

## Objetivo

Establecer convenciones consistentes para nombrar archivos de documentacion en el proyecto IACT, asegurando:
- Claridad y organizacion
- Facilidad de busqueda y referencia
- Cumplimiento de estandares del proyecto
- Trazabilidad y versionado

---

## Patron General de Nomenclatura

Todos los archivos de documentacion (excepto README.md y plantillas) DEBEN seguir el patron:

```
PREFIX-DOMINIO-###-snake_case_title.md
```

### Componentes del Patron

| Componente | Descripcion | Formato | Ejemplo |
|------------|-------------|---------|---------|
| PREFIX | Tipo de documento | MAYUSCULAS con guion | `ADR-`, `PROC-`, `GUIA-` |
| DOMINIO | Area o dominio | MAYUSCULAS abreviadas | `BACK`, `FRONT`, `QA`, `GOB` |
| ### | Numero secuencial | 3 digitos (001-999) | `001`, `012`, `123` |
| snake_case_title | Titulo descriptivo | Minusculas con guiones bajos | `pipeline_trabajo_iact` |
| .md | Extension Markdown | Siempre `.md` | `.md` |

### Separadores

- Entre PREFIX y DOMINIO: **Guion** `-`
- Entre DOMINIO y numero: **Guion** `-`
- Entre numero y titulo: **Guion** `-`
- Entre palabras del titulo: **Guion bajo** `_`

### Dominios Establecidos

| Codigo | Dominio | Descripcion |
|--------|---------|-------------|
| `BACK` | Backend | Django, APIs REST, Base de datos, Modelos |
| `FRONT` | Frontend | React, UI/UX, Componentes visuales |
| `DEVOPS` | DevOps | CI/CD, Infrastructure, Deployment, Containers |
| `QA` | Quality Assurance | Testing, Cobertura, Estrategias de calidad |
| `AI` | Inteligencia Artificial | Agentes, ML, Automatizacion inteligente |
| `GOB` | Gobernanza | Procesos generales, Metodologias, Estandares |
| `DEV` | Desarrollo | SDLC, Metodologias de desarrollo, Workflows |

### Ventajas del Patron con Dominio

1. **Organizacion clara**: El ID indica inmediatamente el area responsable
2. **Evita colisiones**: Cada dominio tiene su propio rango numerico secuencial
3. **Escalable**: Multiples equipos pueden trabajar en paralelo sin conflictos
4. **Mas descriptivo**: `PROC-QA-015` vs `PROC-015` (se entiende que es de QA)
5. **Busqueda facil**: `ls PROC-BACK-*.md` lista todos los procesos de backend

---

## Prefijos por Tipo de Documento

### Documentos de Arquitectura y Decisiones

#### ADR (Architecture Decision Record)

**Patron**: `ADR-DOMINIO-###-snake_case_title.md`

**Ejemplos**:
```
ADR-BACK-001-vagrant_mod_wsgi.md
ADR-BACK-012-sistema_permisos_sin_roles_jerarquicos.md
ADR-DEVOPS-001-ci_cd_pipeline.md
ADR-FRONT-001-redux_state_management.md
ADR-AI-001-planning_architecture.md
```

**Ubicacion**: `docs/gobernanza/adr/`

**Descripcion**: Documentos que registran decisiones arquitectonicas significativas del proyecto. El dominio indica el area afectada por la decision.

---

### Tareas y Proyectos de AI/IA

#### TASK (Tareas de IA)

**Patron**: `TASK-AI-###-snake_case_title.md`

**Ejemplos**:
```
TASK-AI-009-comunicacion_ai_stance.md
TASK-AI-012-ai_guidelines_onboarding.md
TASK-AI-024-ai_telemetry_system.md
```

**Ubicacion**: `docs/gobernanza/ai/`

**Descripcion**: Tareas, proyectos y documentacion relacionada con sistemas de IA y agentes. Todas las TASK son del dominio AI.

---

### Procesos de Negocio

#### PROC (Proceso)

**Patron**: `PROC-DOMINIO-###-snake_case_title.md`

**Ejemplos**:
```
PROC-DEV-001-pipeline_trabajo_iact.md
PROC-DEV-002-sdlc_process.md
PROC-DEVOPS-001-devops_automation.md
PROC-QA-001-estrategia_qa.md
PROC-GOB-001-mapeo_procesos_templates.md
```

**Ubicacion**: `docs/gobernanza/procesos/`

**Descripcion**: Procesos de alto nivel que definen QUE se hace (flujos completos de trabajo). El dominio indica el area principal del proceso.

**Ver**: [GUIA-GOB-001: Procesos vs Procedimientos](GUIA-GOB-001-procesos_vs_procedimientos.md)

---

### Procedimientos Operacionales

#### PROCED (Procedimiento)

**Patron**: `PROCED-DOMINIO-###-snake_case_title.md`

**Ejemplos**:
```
PROCED-DEV-001-code_review.md
PROCED-QA-001-ejecutar_tests.md
PROCED-DEVOPS-001-deploy_staging.md
PROCED-DEVOPS-002-rollback.md
```

**Ubicacion**: `docs/gobernanza/procedimientos/`

**Descripcion**: Procedimientos detallados que describen COMO se ejecutan tareas especificas (paso a paso). El dominio indica el area del procedimiento.

**Ver**: [GUIA-GOB-001: Procesos vs Procedimientos](GUIA-GOB-001-procesos_vs_procedimientos.md)

---

### Guias y Documentacion General

#### GUIA (Guia)

**Patron**: `GUIA-DOMINIO-###-snake_case_title.md`

**Ejemplos**:
```
GUIA-GOB-001-procesos_vs_procedimientos.md
GUIA-GOB-002-convenciones_nomenclatura.md
GUIA-GOB-003-ubicaciones_artefactos.md
GUIA-DEV-001-quickstart.md
GUIA-QA-001-testing_strategy.md
```

**Ubicacion**: `docs/gobernanza/guias/`

**Descripcion**: Guias, tutoriales y documentacion que no es ni proceso ni procedimiento. El dominio indica el area de la guia.

---

## Archivos Especiales (Excepciones)

### README.md

**Patron**: `README.md` (sin cambios)

**Ubicacion**: Cualquier directorio

**Descripcion**: Archivo indice estandar de GitHub. NO requiere prefijo ni numero.

**Ejemplo valido**:
```
docs/gobernanza/README.md
docs/gobernanza/adr/README.md
docs/gobernanza/procesos/README.md
```

---

### Plantillas

**Patron**: `plantilla_*.md` o `template_*.md`

**Ubicacion**: `docs/gobernanza/plantillas/`

**Descripcion**: Archivos plantilla que sirven como base para crear nuevos documentos.

**Ejemplos validos**:
```
plantilla_adr.md
template_requisito_negocio.md
plantilla_caso_de_uso.md
```

---

### Reportes y Analisis con Fecha y Hora

**Patron**: `TIPO_DESCRIPCION_YYYYMMDD_HHMMSS.md`

**Ubicacion**: `docs/gobernanza/qa/`, `docs/gobernanza/planificacion/`

**Descripcion**: Reportes temporales o analisis puntuales con fecha y hora de generacion.

**Formato timestamp**:
- `YYYYMMDD`: Fecha compacta (20251117 = 2025-11-17)
- `HHMMSS`: Hora en formato 24h (143022 = 14:30:22)

**IMPORTANTE**: El timestamp debe reflejar la **hora de INICIO** del analisis/reporte, NO la hora de finalizacion.

Ejemplo: Si un analisis comienza a las 14:30 y termina a las 15:45, el archivo debe ser:
```
ANALISIS_PROYECTO_20251117_143000.md  # Hora de inicio: 14:30
```

**Ejemplos validos**:
```
REPORTE_EMOJIS_DOCS_GOBERNANZA_20251117_140530.md
ANALISIS_COMPLETO_PROYECTO_IACT_20251117_153045.md
VERIFICACION_REAL_ESTADO_ARCHIVOS_20251117_154530.md
```

**Justificacion**:
- Estos archivos son snapshots temporales, no documentacion permanente versionada
- El timestamp con hora evita colisiones si se generan multiples reportes el mismo dia
- Permite trazabilidad granular y ordenamiento cronologico preciso

**Patron legacy aceptado** (archivos existentes, no crear nuevos):
```
TIPO_DESCRIPCION_2025_11_17.md  # Solo fecha (pre-actualizacion)
```

---

## Frontmatter YAML Requerido

TODOS los archivos de documentacion DEBEN incluir frontmatter YAML con los siguientes campos minimos:

```yaml
---
id: PREFIX-###
tipo: [proceso|procedimiento|guia|adr|task|analisis|reporte]
categoria: [gobernanza|desarrollo|qa|arquitectura|ai]
subcategoria: [opcional]
version: X.Y.Z
fecha_creacion: YYYY-MM-DD
autor: Nombre del autor
estado: [borrador|revision|activo|obsoleto]
aprobado_por: [nombre|pendiente]
relacionados: ["ID-1", "ID-2"]
---
```

### Consistencia ID con Nombre de Archivo

**CRITICO**: El campo `id` en el frontmatter DEBE coincidir con el prefijo-numero del archivo.

**Correcto**:
```markdown
Archivo: PROC-001-pipeline_trabajo_iact.md

---
id: PROC-001
tipo: proceso
---
```

**Incorrecto**:
```markdown
Archivo: PROC-001-pipeline_trabajo_iact.md

---
id: PROC-PIPELINE-TRABAJO-001  # INCORRECTO
tipo: proceso
---
```

---

## Estructura de Directorios

### Estructura Actual

```
docs/gobernanza/
├── adr/                    # ADR-###-*.md
├── ai/                     # TASK-###-*.md
├── procesos/               # PROC-###-*.md
├── procedimientos/         # PROCED-###-*.md (a crear)
├── guias/                  # GUIA-###-*.md
├── qa/                     # Reportes temporales con fecha
├── planificacion/          # Planes y roadmaps
├── plantillas/             # plantilla_*.md, template_*.md
└── [otros]/                # Archivos legacy en proceso de migracion
```

### Carpeta Faltante: procedimientos/

**Estado**: NO EXISTE todavia

**Ubicacion planeada**: `docs/gobernanza/procedimientos/`

**Contenido futuro**:
```
docs/gobernanza/procedimientos/
├── README.md
├── PROCED-001-code_review.md
├── PROCED-002-ejecutar_tests.md
├── PROCED-003-deploy_staging.md
└── PROCED-004-rollback.md
```

**Razon de retraso**: Aun no se han creado procedimientos formales. La carpeta se creara cuando se documente el primer procedimiento.

---

## Ejemplos Completos

### Ejemplo 1: Architecture Decision Record

**Nombre archivo**: `ADR-025-fastapi_backend_migration.md`

```yaml
---
id: ADR-025
tipo: adr
categoria: arquitectura
subcategoria: backend
version: 1.0.0
fecha_creacion: 2025-11-17
autor: Equipo Backend
estado: revision
aprobado_por: pendiente
relacionados: ["ADR-001", "PROC-001"]
---

# ADR-025: Migracion de Django a FastAPI

## Contexto

Descripcion del contexto...
```

---

### Ejemplo 2: Proceso

**Nombre archivo**: `PROC-004-incident_response.md`

```yaml
---
id: PROC-004
tipo: proceso
categoria: operaciones
subcategoria: soporte
version: 1.0.0
fecha_creacion: 2025-11-17
autor: Equipo DevOps
estado: activo
aprobado_por: Tech Lead
relacionados: ["PROC-001", "PROCED-010"]
---

# PROC-004: Proceso de Respuesta a Incidentes

## Objetivo

Definir el flujo completo de respuesta a incidentes...
```

---

### Ejemplo 3: Guia

**Nombre archivo**: `GUIA-005-configuracion_ambiente_local.md`

```yaml
---
id: GUIA-005
tipo: guia
categoria: desarrollo
subcategoria: setup
version: 2.1.0
fecha_creacion: 2025-11-17
autor: Equipo DevOps
estado: activo
aprobado_por: Tech Lead
relacionados: ["GUIA-003"]
---

# GUIA-005: Configuracion de Ambiente Local

## Objetivo

Guiar al desarrollador en la configuracion inicial...
```

---

## Migracion de Archivos Legacy

### Archivos con Nomenclatura Antigua

Los archivos con nomenclatura antigua deben migrarse gradualmente:

#### Patrones Obsoletos Identificados

| Patron Obsoleto | Patron Nuevo | Ejemplo Antiguo | Ejemplo Nuevo |
|----------------|--------------|-----------------|---------------|
| `adr_2025_###_*.md` | `ADR-###-*.md` | `adr_2025_001_vagrant.md` | `ADR-001-vagrant_mod_wsgi.md` |
| `ADR_###_*.md` | `ADR-###-*.md` | `ADR_013_webpack.md` | `ADR-013-webpack_bundler.md` |
| `TITULO_MAYUS.md` | `GUIA-###-titulo.md` | `QUICKSTART.md` | `GUIA-003-quickstart.md` |
| `TITULO_MAYUS.md` | `PROC-###-titulo.md` | `SDLC_PROCESS.md` | `PROC-002-sdlc_process.md` |

#### Estrategia de Migracion

1. Identificar archivos con patron obsoleto
2. Asignar numero secuencial (siguiente disponible)
3. Renombrar archivo usando `git mv`
4. Actualizar frontmatter (id, version)
5. Actualizar referencias en otros archivos
6. Commit con mensaje descriptivo

**Ver**: [Reporte de Inconsistencias](../qa/ANALISIS_INCONSISTENCIAS_NOMENCLATURA_2025_11_17.md)

---

## Herramientas de Validacion

### Script de Validacion (Futuro)

```bash
# Validar nomenclatura de todos los archivos
scripts/validacion/validar_nomenclatura.sh docs/gobernanza/

# Salida esperada:
# PASS: ADR-001-vagrant_mod_wsgi.md
# FAIL: adr_2025_003_dora.md (patron obsoleto)
# FAIL: QUICKSTART.md (sin prefijo GUIA-###)
```

### Pre-commit Hook (Futuro)

Validacion automatica en cada commit para rechazar archivos con nomenclatura incorrecta.

---

## Preguntas Frecuentes

### Como numerar un nuevo documento?

1. Identificar el PREFIX correcto (ADR, PROC, GUIA, etc.)
2. Listar archivos existentes con ese PREFIX
3. Tomar el numero mas alto + 1

**Ejemplo**:
```bash
# Listar ADRs existentes
ls docs/gobernanza/adr/ADR-*.md | sort

# Ultimo ADR: ADR-054-planning_architecture.md
# Proximo numero: 055
# Nuevo ADR: ADR-055-nueva_decision.md
```

### Que hacer con archivos duplicados?

Si existen dos archivos con el mismo contenido pero diferente nombre:
1. Conservar el archivo con nomenclatura correcta
2. Eliminar el archivo con nomenclatura obsoleta
3. Actualizar referencias (si existen)
4. Commit explicando la eliminacion

### Puedo cambiar el titulo del archivo?

Si, mientras mantengas el PREFIX-### consistente con el frontmatter.

**Permitido**:
```
Antes: PROC-001-pipeline_trabajo_iact.md
Despues: PROC-001-pipeline_principal.md
```

**NO permitido**:
```
Antes: PROC-001-pipeline_trabajo_iact.md
Despues: PROC-002-pipeline_principal.md  # Numero cambio sin razon
```

### Que pasa si elimino un archivo?

El numero NO se reutiliza. Si eliminas `ADR-025`, el proximo ADR sera `ADR-055` (no `ADR-025`).

**Razon**: Evitar confusion con referencias historicas en commits, PRs o documentacion externa.

---

## Resumen Ejecutivo

| Aspecto | Requisito |
|---------|-----------|
| Patron general | `PREFIX-###-snake_case_title.md` |
| Separadores | Guiones `-` entre componentes, guiones bajos `_` en titulo |
| Numeracion | 3 digitos (001-999), secuencial, no reutilizar |
| Frontmatter | Obligatorio con `id` consistente con nombre archivo |
| Excepciones | README.md, plantillas, reportes con fecha |
| Prefijos validos | ADR, TASK, PROC, PROCED, GUIA |
| Case sensitivity | Prefijos en MAYUSCULAS, titulos en minusculas |
| Migracion legacy | Gradual, priorizar archivos criticos primero |

---

## Documentos Relacionados

- [GUIA-001: Procesos vs Procedimientos](GUIA-001-procesos_vs_procedimientos.md)
- [Reporte de Inconsistencias de Nomenclatura](../qa/ANALISIS_INCONSISTENCIAS_NOMENCLATURA_2025_11_17.md)
- [Plan de Remediacion de Documentacion](../planificacion/PLAN_REMEDIACION_DOCS_GOBERNANZA.md)

---

## Referencias

- GitHub File Naming Conventions: https://docs.github.com/en/repositories
- Markdown Style Guide: https://www.markdownguide.org/
- ADR Process: https://adr.github.io/

---

**Fecha de creacion**: 2025-11-17
**Version**: 1.0.0
**Proxima revision**: Trimestral o cuando se identifiquen nuevos patrones
**Aprobacion**: Pendiente validacion de Tech Lead
