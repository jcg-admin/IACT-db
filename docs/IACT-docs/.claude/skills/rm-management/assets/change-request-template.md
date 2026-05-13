```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: rm:management
author: [nombre]
status: Activo
```

# RM Management — Artefacto

---

## Baseline actual

| Campo | Valor |
|-------|-------|
| **Versión** | v[1.x] |
| **Fecha de baseline** | [fecha del último sign-off] |
| **Aprobado por** | [nombres + fechas] |
| **Documentos en baseline** | requirements-spec.md v[X] |
| **Estado del proceso** | Estable / En proceso de cambio / Con CRs activos |

---

## Log de Change Requests

| CR ID | Solicitante | Fecha solicitud | Descripción resumida | Impacto | Estado CCB | Versión baseline afectada |
|-------|-------------|----------------|---------------------|---------|-----------|--------------------------|
| CR-001 | [nombre / rol] | [fecha] | [descripción breve del cambio] | [Alto/Medio/Bajo] | Aprobado / Rechazado / En evaluación / Diferido | v1.1 |
| CR-002 | | | | | | |

---

## Change Request detallado — CR-[NNN]

> Usar una sección por cada CR activo o reciente.

### Información del cambio

| Campo | Contenido |
|-------|-----------|
| **CR ID** | CR-[NNN] |
| **Solicitante** | [nombre, rol, área] |
| **Fecha de solicitud** | [fecha] |
| **Urgencia** | Crítica (bloquea trabajo) / Alta (impacta sprint) / Normal / Baja |
| **Descripción del cambio** | [qué quiere cambiar el solicitante — con contexto de negocio] |
| **Justificación** | [por qué es necesario este cambio — razón de negocio o técnica] |

### Impacto del cambio

| Dimensión | Análisis de impacto |
|-----------|---------------------|
| **Requisitos afectados** | [lista de Req ID modificados / agregados / eliminados] |
| **Diseño / arquitectura** | [qué componentes deben cambiar] |
| **Tests existentes** | [qué tests se invalidan o deben actualizarse] |
| **Esfuerzo estimado** | [horas/días de trabajo] |
| **Costo estimado** | [si hay costo económico] |
| **Impacto en cronograma** | [días de retraso estimados] |
| **Riesgo** | [riesgos introducidos por el cambio] |
| **Dependencias** | [otros CRs o tareas que se ven afectados] |

### Opciones consideradas

| Opción | Descripción | Ventajas | Desventajas | Esfuerzo |
|--------|-------------|---------|------------|---------|
| A (recomendada) | [descripción] | [ventajas] | [desventajas] | [bajo/medio/alto] |
| B | [descripción] | | | |
| Rechazar | No implementar el cambio | [ventajas de no hacer] | [consecuencias] | 0 |

### Decisión CCB

| Campo | Valor |
|-------|-------|
| **Fecha CCB** | [fecha de la reunión o decisión] |
| **Decisión** | Aprobado / Rechazado / Diferido a versión X / Más información requerida |
| **Justificación** | [por qué se tomó esta decisión] |
| **Condiciones** | [si fue aprobado condicionalmente] |
| **Miembros CCB presentes** | [nombres y roles] |

### Plan de implementación (si aprobado)

| Actividad | Responsable | Fecha inicio | Fecha fin | Estado |
|-----------|-------------|-------------|----------|--------|
| Actualizar specification | [analista] | [fecha] | [fecha] | ⏳ / ✅ |
| Notificar al equipo de desarrollo | [PM] | | | |
| Actualizar trazabilidad | [analista] | | | |
| Actualizar tests | [QA] | | | |
| Verificar implementación | [analista] | | | |

---

## Matriz de trazabilidad (snapshot)

| Req ID | Descripción | Prioridad | Design | Code | Test | Estado |
|--------|-------------|-----------|--------|------|------|--------|
| REQ-001 | [descripción breve] | Must Have | UC-001 | [módulo] | TC-001 | ✅ Implementado |
| REQ-002 | | Should Have | | | | 🔄 En desarrollo |
| REQ-003 | | Must Have | | | | ❌ Pendiente |
| NFR-P01 | | Must Have | | | Test de carga | ✅ |

**Cobertura de trazabilidad:**
- Req → Design: [X]% trazados
- Req → Code: [X]% trazados
- Req → Test: [X]% trazados

---

## Kanban de CRs activos

| Estado | CR IDs |
|--------|--------|
| **Backlog (no evaluado)** | CR-005, CR-007 |
| **En evaluación (análisis de impacto)** | CR-003 |
| **En CCB (esperando decisión)** | CR-004 |
| **Aprobado / En implementación** | CR-001, CR-002 |
| **Cerrado** | CR-006 |

---

## Decisión de flujo

- [ ] **on_stable → cierre de RM** — baseline estable; todos los CRs cerrados o diferidos formalmente
- [ ] **on_change_request → rm:analysis** — CR aprobado que requiere re-análisis de impacto:
  - CR-[NNN]: [descripción del cambio a analizar en rm:analysis]
