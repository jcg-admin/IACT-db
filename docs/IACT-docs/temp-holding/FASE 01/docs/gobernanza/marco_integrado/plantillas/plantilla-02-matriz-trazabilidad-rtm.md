---
title: Plantilla 2 - Matriz de Trazabilidad Extendida (RTM)
date: 2025-11-16
domain: general
status: active
tipo: plantilla
plantilla_numero: 2
---

# Plantilla 2: Matriz de Trazabilidad Extendida (RTM)

### Propósito

Matriz completa de trazabilidad que conecta necesidades de negocio con requisitos, casos de uso, pruebas e implementación.

### Estructura de la Plantilla

```markdown
# Matriz de Trazabilidad de Requisitos (RTM): [COMPONENTE]

**ID:** RTM-[XXX]
**Versión:** X.Y
**Fecha:** YYYY-MM-DD
**Área:** [Área del sistema]

## 1. Resumen de Trazabilidad

| Métrica | Cantidad |
|---------|----------|
| Necesidades de Negocio | [N] |
| Procesos | [N] |
| Reglas de Negocio | [N] |
| Casos de Uso | [N] |
| Requisitos Funcionales | [N] |
| Requisitos No Funcionales | [N] |
| Casos de Prueba | [N] |
| Componentes Implementados | [N] |

## 2. Matriz Principal: Necesidad → Requisito → Prueba → Implementación

| ID Necesidad | Descripción | ID Proceso | ID UC | ID Requisito | Prioridad | ID Prueba | Estado Prueba | ID Implementación | Estado Impl |
|--------------|-------------|-----------|-------|--------------|-----------|-----------|--------------|-------------------|-------------|
| N-001 | [Descripción] | PROC-X | UC-X | RF-X | MUST | TS-X | Pasó | backend/auth | Completo |
| N-001 | [Descripción] | PROC-X | UC-Y | RF-Y | MUST | TS-Y | Pendiente | - | Pendiente |

## 3. Matriz Reglas de Negocio → Impacto

| ID Regla | Tipo | Nombre | Procesos Impactados | UC Impactados | Requisitos Derivados |
|----------|------|--------|-------------------|--------------|---------------------|
| RN-[X] | Restricción | [Nombre] | PROC-A, PROC-B | UC-1, UC-2 | RF-10, RF-11 |

## 4. Matriz UC → Requisitos → Pruebas

| ID UC | Nombre UC | Paso | ID RF | Nombre RF | Criterios Aceptación | ID Prueba | Estado |
|-------|-----------|------|-------|-----------|---------------------|-----------|--------|
| UC-001 | [Nombre] | 3 | RF-005 | [Nombre] | [Criterios] | TS-RF-005-001 | Pasó |
| UC-001 | [Nombre] | 5 | RF-006 | [Nombre] | [Criterios] | TS-RF-006-001 | Pasó |

## 5. Cobertura de Pruebas

| Tipo de Requisito | Total Requisitos | Requisitos con Prueba | % Cobertura |
|------------------|----------------|---------------------|-------------|
| Funcionales (MUST) | [N] | [N] | [%] |
| Funcionales (SHOULD) | [N] | [N] | [%] |
| No Funcionales | [N] | [N] | [%] |
| **TOTAL** | [N] | [N] | [%] |

## 6. Estado de Implementación

| Componente | Requisitos Asignados | Requisitos Implementados | % Completitud |
|-----------|-------------------|------------------------|---------------|
| Backend - Auth | [N] | [N] | [%] |
| Backend - Permisos | [N] | [N] | [%] |
| Frontend - UI | [N] | [N] | [%] |
| **TOTAL** | [N] | [N] | [%] |

## 7. Trazabilidad Inversa (Backward)

### 7.1 Requisitos Huérfanos

Lista de requisitos sin trazabilidad hacia arriba (no vinculados a UC o necesidad):

| ID Requisito | Nombre | Acción Requerida |
|--------------|--------|------------------|
| RF-[X] | [Nombre] | Vincular a UC-[Y] o eliminar |

### 7.2 Casos de Uso Sin Requisitos

Lista de casos de uso que no derivaron requisitos:

| ID UC | Nombre | Acción Requerida |
|-------|--------|------------------|
| UC-[X] | [Nombre] | Derivar requisitos o eliminar UC |

## 8. Trazabilidad Forward (Adelante)

### 8.1 Necesidades Sin Implementación

Lista de necesidades de negocio sin requisitos o sin implementación:

| ID Necesidad | Descripción | Estado | Acción Requerida |
|--------------|-------------|--------|------------------|
| N-[X] | [Descripción] | Sin requisitos | Analizar y derivar requisitos |
| N-[Y] | [Descripción] | Con requisitos, sin implementación | Priorizar implementación |

### 8.2 Requisitos Sin Pruebas

Lista de requisitos sin casos de prueba:

| ID Requisito | Nombre | Prioridad | Acción Requerida |
|--------------|--------|-----------|------------------|
| RF-[X] | [Nombre] | MUST | CREAR PRUEBA URGENTE |
| RF-[Y] | [Nombre] | SHOULD | Planificar creación de prueba |

## 9. Análisis de Cambios

### 9.1 Impacto de Cambios Recientes

| Fecha | Elemento Cambiado | Elementos Impactados | Estado de Propagación |
|-------|------------------|---------------------|---------------------|
| [Fecha] | RN-[X] modificada | RF-[A], RF-[B], TS-[C] | Actualizado |
| [Fecha] | UC-[Y] agregado | RF-[D] derivado | Prueba pendiente |

### 9.2 Cambios Pendientes

| Elemento | Cambio Solicitado | Fecha Solicitud | Elementos a Actualizar | Responsable |
|----------|------------------|---------------|----------------------|-------------|
| RF-[X] | Modificar criterio | [Fecha] | TS-[X], Implementación | [Nombre] |

## 10. Métricas de Calidad

### 10.1 Índice de Trazabilidad

```
Índice de Trazabilidad = (Requisitos con trazabilidad completa / Total de requisitos) * 100

Trazabilidad Completa = Requisito tiene:
- Vínculo a Necesidad/Proceso/UC (upward)
- Vínculo a Prueba (forward)
- Vínculo a Implementación (forward)

Valor Actual: [X%]
Meta: >= 95%
```

### 10.2 Índice de Cobertura de Pruebas

```
Cobertura de Pruebas = (Requisitos con prueba / Total de requisitos) * 100

Valor Actual: [X%]
Meta: >= 90% (MUST), >= 70% (SHOULD)
```

### 10.3 Índice de Completitud de Implementación

```
Completitud = (Requisitos implementados / Total de requisitos) * 100

Valor Actual: [X%]
Meta: >= 100% (MUST), >= 80% (SHOULD)
```

---

**Fin de la Plantilla RTM**
```

---

## Referencias

Esta plantilla fue extraída de: [06_plantillas_integradas_iact.md](../06_plantillas_integradas_iact.md)

Para más información sobre el marco integrado de análisis, consulte la documentación completa en el directorio padre.
