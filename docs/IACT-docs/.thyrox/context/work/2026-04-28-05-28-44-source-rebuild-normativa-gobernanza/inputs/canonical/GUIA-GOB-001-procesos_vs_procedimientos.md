---
id: GUIA-GOB-001
tipo: guia
categoria: gobernanza
subcategoria: conceptos-fundamentales
version: 1.0.0
fecha_creacion: 2025-11-17
autor: Claude Code (Sonnet 4.5)
estado: activo
relacionados: ["PROC-001"]
---

# PROCESOS vs PROCEDIMIENTOS: Diferencias Fundamentales

## Resumen Ejecutivo

**Proceso** y **Procedimiento** son conceptos relacionados pero DISTINTOS en gestión de proyectos y gobernanza. Entender la diferencia es crítico para organizar correctamente la documentación y los flujos de trabajo.

---

## PROCESO

### Definición

**Proceso**: Conjunto de actividades interrelacionadas que transforman ENTRADAS en SALIDAS, agregando valor en el camino.

**Características**:
- ALTO NIVEL (visión macro)
- QUE se hace (objetivos)
- SECUENCIA de actividades
- MULTIPLES procedimientos
- ORIENTADO A RESULTADOS
- FLUJO de trabajo completo

**Ejemplo**: Proceso de Desarrollo de Software

```
ENTRADA → [Proceso SDLC] → SALIDA
├─ Requerimientos       ├─ Software funcionando
├─ Recursos             ├─ Documentación
└─ Tiempo               └─ Tests pasando
```

### Componentes de un Proceso

1. **Entradas** (Inputs): Requisitos, recursos, información
2. **Actividades**: Pasos de alto nivel
3. **Responsables**: Roles involucrados
4. **Salidas** (Outputs): Productos entregables
5. **Métricas**: KPIs del proceso

---

## PROCEDIMIENTO

### Definición

**Procedimiento**: Conjunto de instrucciones DETALLADAS y ESPECIFICAS que describen COMO ejecutar una actividad particular dentro de un proceso.

**Características**:
- BAJO NIVEL (visión detallada)
- COMO se hace (pasos específicos)
- INSTRUCCIONES paso a paso
- PARTE de un proceso
- ORIENTADO A EJECUCIÓN
- RECETA a seguir

**Ejemplo**: Procedimiento de Code Review

```
PROCEDIMIENTO: Code Review
1. Developer crea Pull Request
2. Asignar 2 reviewers
3. Reviewers verifican:
   a. Tests pasan
   b. Coverage >= 80%
   c. Estilo de código
4. Si aprobado → Merge
5. Si rechazado → Developer corrige
```

### Componentes de un Procedimiento

1. **Objetivo**: Para qué sirve este procedimiento
2. **Alcance**: Qué cubre y qué NO
3. **Responsables**: Quién ejecuta cada paso
4. **Pre-requisitos**: Qué debe existir antes
5. **Pasos detallados**: Instrucciones específicas
6. **Criterios de éxito**: Cómo validar que se hizo bien

---

## COMPARACIÓN DIRECTA

| Aspecto | PROCESO | PROCEDIMIENTO |
|---------|---------|---------------|
| **Nivel** | Alto (estratégico) | Bajo (operacional) |
| **Pregunta** | QUE hacemos | COMO lo hacemos |
| **Alcance** | Amplio (end-to-end) | Específico (una tarea) |
| **Flexibilidad** | Flexible (adaptable) | Rígido (paso a paso) |
| **Documentación** | Diagramas de flujo | Listas de pasos |
| **Ejemplo** | Desarrollo de Software | Ejecutar tests unitarios |
| **Contiene** | Varios procedimientos | Pasos específicos |
| **Medición** | Tiempo total, calidad final | Cumplimiento de pasos |
| **Audiencia** | Managers, Product Owners | Ejecutores, Developers |

---

## RELACIÓN ENTRE PROCESO Y PROCEDIMIENTO

### Jerarquía

```
PROCESO (QUE)
├── Procedimiento 1 (COMO)
│   ├── Paso 1
│   ├── Paso 2
│   └── Paso 3
├── Procedimiento 2 (COMO)
│   ├── Paso 1
│   └── Paso 2
└── Procedimiento 3 (COMO)
    ├── Paso 1
    ├── Paso 2
    └── Paso 3
```

### Ejemplo Concreto: Proceso de Deployment

**PROCESO**: Deployment a Producción

```
[Proceso de Deployment]
├── Procedimiento 1: Preparar Release
│   ├── 1. Crear branch release/vX.Y.Z
│   ├── 2. Ejecutar suite de tests
│   ├── 3. Generar changelog
│   └── 4. Actualizar versión en package.json
│
├── Procedimiento 2: Ejecutar Tests de Integración
│   ├── 1. Levantar ambiente staging
│   ├── 2. Ejecutar tests E2E
│   ├── 3. Validar métricas de performance
│   └── 4. Generar reporte de tests
│
├── Procedimiento 3: Deploy a Staging
│   ├── 1. Hacer backup de BD staging
│   ├── 2. Ejecutar migraciones
│   ├── 3. Deploy de aplicación
│   └── 4. Smoke tests
│
└── Procedimiento 4: Deploy a Producción
    ├── 1. Hacer backup de BD producción
    ├── 2. Activar maintenance mode
    ├── 3. Ejecutar migraciones
    ├── 4. Deploy de aplicación
    ├── 5. Smoke tests
    ├── 6. Monitorear métricas
    └── 7. Desactivar maintenance mode
```

---

## DONDE UBICAR EN DOCUMENTACIÓN

### Estructura Recomendada en docs/gobernanza/

```
docs/gobernanza/
├── procesos/                    # PROCESOS (QUE)
│   ├── proceso_sdlc.md          # Proceso completo SDLC
│   ├── proceso_deployment.md    # Proceso de deployment
│   ├── proceso_onboarding.md    # Proceso de onboarding
│   └── proceso_incident_response.md
│
└── procedimientos/              # PROCEDIMIENTOS (COMO)
    ├── procedimiento_code_review.md
    ├── procedimiento_ejecutar_tests.md
    ├── procedimiento_deploy_staging.md
    ├── procedimiento_rollback.md
    └── procedimiento_crear_migracion.md
```

---

## DIFERENCIAS PRÁCTICAS

### Cuándo Documentar como PROCESO

**Documenta como PROCESO cuando**:
- Describe un flujo de trabajo completo
- Involucra múltiples roles/equipos
- Tiene múltiples fases o etapas
- Necesita métricas de resultado final
- Puede variar según contexto

**Ejemplos de PROCESOS**:
- Proceso de Desarrollo de Software (SDLC)
- Proceso de Gestión de Incidentes
- Proceso de Onboarding de Empleados
- Proceso de Code Review
- Proceso de Release Management

---

### Cuándo Documentar como PROCEDIMIENTO

**Documenta como PROCEDIMIENTO cuando**:
- Describe COMO hacer una tarea específica
- Pasos secuenciales y detallados
- Una sola persona/rol ejecuta
- Resultado específico y medible
- Pasos deben seguirse en orden

**Ejemplos de PROCEDIMIENTOS**:
- Procedimiento para Ejecutar Tests Unitarios
- Procedimiento para Hacer Backup de Base de Datos
- Procedimiento para Configurar Ambiente Local
- Procedimiento para Crear Pull Request
- Procedimiento para Ejecutar Migración de Django

---

## PIPELINE DE TRABAJO: ¿Proceso o Procedimiento?

### Análisis

**Pipeline de trabajo** es un PROCESO porque:
- Define el FLUJO completo de trabajo
- Involucra múltiples etapas
- Contiene varios procedimientos
- Visión de alto nivel (QUE se hace)
- Transformación de entrada a salida

**Ubicación recomendada**: `docs/gobernanza/procesos/PROC-001-pipeline_trabajo_iact.md`

---

### Ejemplo: Pipeline de Trabajo para IACT

**PROCESO**: Pipeline de Trabajo de Desarrollo

```
[ENTRADA: Issue/Requerimiento]
    ↓
[ETAPA 1: Análisis]
    ├─ Procedimiento: Crear branch de feature
    ├─ Procedimiento: Analizar requisitos
    └─ Procedimiento: Diseñar solución
    ↓
[ETAPA 2: Implementación]
    ├─ Procedimiento: Escribir código
    ├─ Procedimiento: Escribir tests
    └─ Procedimiento: Ejecutar linters
    ↓
[ETAPA 3: Code Review]
    ├─ Procedimiento: Crear Pull Request
    ├─ Procedimiento: Revisión por pares
    └─ Procedimiento: Aprobar/Rechazar
    ↓
[ETAPA 4: Testing]
    ├─ Procedimiento: Tests unitarios
    ├─ Procedimiento: Tests de integración
    └─ Procedimiento: Tests E2E
    ↓
[ETAPA 5: Deployment]
    ├─ Procedimiento: Deploy a staging
    ├─ Procedimiento: Validación staging
    └─ Procedimiento: Deploy a producción
    ↓
[SALIDA: Feature en Producción]
```

---

## PLANTILLAS

### Plantilla de PROCESO

```markdown
---
id: PROC-XXX-001
tipo: proceso
---

# Proceso: [Nombre del Proceso]

## Objetivo
Descripción de QUE se busca lograr con este proceso.

## Alcance
Qué cubre y qué NO cubre este proceso.

## Roles Involucrados
- Product Owner: Define requisitos
- Developer: Implementa
- QA: Valida

## Entradas (Inputs)
- Lista de entradas necesarias

## Etapas del Proceso

### Etapa 1: [Nombre]
- Procedimiento 1: [Referencia]
- Procedimiento 2: [Referencia]

### Etapa 2: [Nombre]
- Procedimiento 3: [Referencia]

## Salidas (Outputs)
- Lista de entregables

## Métricas
- KPI 1: Tiempo total del proceso
- KPI 2: Tasa de éxito
```

---

### Plantilla de PROCEDIMIENTO

```markdown
---
id: PROCED-XXX-001
tipo: procedimiento
proceso_padre: PROC-XXX-001
---

# Procedimiento: [Nombre del Procedimiento]

## Objetivo
Para qué sirve este procedimiento.

## Pre-requisitos
Qué debe existir antes de ejecutar.

## Responsable
Quién ejecuta este procedimiento.

## Pasos

### Paso 1: [Título]
Descripción detallada del paso.
```bash
# Comando si aplica
comando ejemplo
```

### Paso 2: [Título]
Descripción detallada.

### Paso 3: [Título]
Descripción detallada.

## Criterios de Éxito
Cómo validar que se ejecutó correctamente.

## Troubleshooting
Problemas comunes y soluciones.
```

---

## RECOMENDACIONES PARA IACT

### 1. Organizar Documentación Actual

**Revisar y reubicar**:
- Archivos en `docs/gobernanza/procesos/` → Validar que sean PROCESOS
- Crear carpeta `docs/gobernanza/procedimientos/` → Mover procedimientos
- Actualizar índices y referencias

### 2. Nomenclatura Clara

**Usar prefijos**:
- `PROC-` para procesos
- `PROCED-` para procedimientos
- `GUIA-` para guías (ni proceso ni procedimiento)

### 3. Vincular Correctamente

**En documentos de PROCESO**:
```markdown
## Etapa 2: Implementación
- Ver: [Procedimiento de Code Review](../procedimientos/PROCED-CODE-REVIEW-001.md)
- Ver: [Procedimiento de Tests](../procedimientos/PROCED-TESTS-001.md)
```

**En documentos de PROCEDIMIENTO**:
```markdown
## Parte del Proceso
Este procedimiento es parte del [Proceso SDLC](../procesos/PROC-SDLC-001.md)
```

---

## CONCLUSIONES

1. **PROCESO** = QUE hacemos (alto nivel, flujo completo)
2. **PROCEDIMIENTO** = COMO lo hacemos (bajo nivel, pasos específicos)
3. **Pipeline de trabajo** = PROCESO (va en `procesos/`)
4. Un proceso CONTIENE múltiples procedimientos
5. Un procedimiento es PARTE de un proceso

---

## DOCUMENTOS RELACIONADOS

**Ver**: `docs/gobernanza/procesos/PROC-001-pipeline_trabajo_iact.md`

Este documento define el PROCESO completo de trabajo, desde que se identifica un requerimiento hasta que se deploya a producción.

---

**Fecha de creación**: 2025-11-17
**Versión**: 1.0.0
**Próxima revisión**: Cuando se cree el pipeline de trabajo
