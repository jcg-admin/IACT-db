---
id: MATRIZ-[DOMINIO]-[###]
tipo: matriz_trazabilidad
categoria: [DOMINIO]
alcance: [modulo|sistema|subsistema]
version: 1.0.0
fecha_creacion: [YYYY-MM-DD]
ultima_actualizacion: [YYYY-MM-DD]
autor: [NOMBRE_AUTOR]
---

# MATRIZ-[DOMINIO]-[###]: Trazabilidad de [Nombre del Módulo/Sistema]

<!--
INSTRUCCIONES:
- Reemplace [DOMINIO] con: BACK, FRONT, DEVOPS, QA, AI, GOB
- Reemplace [###] con número secuencial: 001, 002, 003, etc.
- Las matrices de trazabilidad proporcionan vista panorámica de relaciones entre artefactos

PROPÓSITO:
Las matrices de trazabilidad permiten:
- Ver todas las relaciones de un vistazo
- Identificar gaps (requisitos sin implementar, casos de uso sin RF)
- Analizar impacto de cambios
- Validar cobertura completa

TIPOS DE MATRICES:
1. Matriz Vertical: Muestra jerarquía completa RN → RNEG → UC → RF → RNF
2. Matriz Horizontal: Muestra todos los artefactos relacionados con un elemento específico
3. Matriz de Cobertura: Muestra qué está cubierto y qué no

Este template incluye los tres tipos. Use el que sea más apropiado para su propósito,
o use varios.
-->

## Información General

**Alcance**: [Módulo específico | Sistema completo | Subsistema]

**Descripción**: [Breve descripción de qué cubre esta matriz]

**Última actualización**: [YYYY-MM-DD]

**Estado**: [Completa | En progreso | Requiere actualización]

## Resumen Ejecutivo

<!--
Proporcione un resumen de alto nivel de la trazabilidad
-->

**Total de artefactos rastreados**:
- Reglas de Negocio (RN): [número]
- Requerimientos de Negocio (RNEG): [número]
- Casos de Uso (UC): [número]
- Requisitos Funcionales (RF): [número]
- Atributos de Calidad (RNF): [número]

**Cobertura**:
- RN con UC relacionados: [número] / [total RN] ([porcentaje]%)
- UC con RF relacionados: [número] / [total UC] ([porcentaje]%)
- RF con tests: [número] / [total RF] ([porcentaje]%)

**Gaps identificados**: [número de artefactos sin relaciones esperadas]

---

## TIPO 1: Matriz Vertical (Jerarquía Completa)

<!--
Esta matriz muestra la jerarquía completa desde RN hasta RNF.
Es útil para ver flujos completos de trazabilidad.

INSTRUCCIONES:
- Cada fila representa un flujo completo de trazabilidad
- Las celdas muestran los IDs de artefactos relacionados
- Celdas vacías indican que no hay relación en ese nivel
- Si un UC deriva múltiples RF, agréguelos en la misma celda separados por <br>
-->

| RN | RNEG | UC | RF | RNF |
|---|---|---|---|---|
| [RN-DOMINIO-###] | [RNEG-DOMINIO-###] | [UC-DOMINIO-###] | [RF-DOMINIO-###]<br>[RF-DOMINIO-###] | [RNF-DOMINIO-###] |
| [RN-DOMINIO-###] | [RNEG-DOMINIO-###] | [UC-DOMINIO-###] | [RF-DOMINIO-###] | [RNF-DOMINIO-###]<br>[RNF-DOMINIO-###] |
| [RN-DOMINIO-###] |  | [UC-DOMINIO-###] | [RF-DOMINIO-###] |  |
|  | [RNEG-DOMINIO-###] | [UC-DOMINIO-###] | [RF-DOMINIO-###] | [RNF-DOMINIO-###] |

<!--
EJEMPLO: Módulo de Autenticación

| RN | RNEG | UC | RF | RNF |
|---|---|---|---|---|
| RN-BACK-001 | RNEG-BACK-001 | UC-BACK-001 | RF-BACK-010<br>RF-BACK-011<br>RF-BACK-012 | RNF-BACK-005<br>RNF-BACK-006<br>RNF-BACK-007 |
| RN-BACK-001 | RNEG-BACK-001 | UC-BACK-002 | RF-BACK-013 | RNF-BACK-007 |
| RN-BACK-001 | RNEG-BACK-001 | UC-BACK-003 | RF-BACK-014<br>RF-BACK-015 | RNF-BACK-005 |
| RN-BACK-028 | RNEG-BACK-001 | UC-BACK-001 | RF-BACK-016 |  |

Leyenda:
- RN-BACK-001: Usuario debe estar autenticado
- RN-BACK-028: Solo usuarios activos pueden iniciar sesión
- RNEG-BACK-001: Sistema de autenticación seguro
- UC-BACK-001: Iniciar Sesión
- UC-BACK-002: Cerrar Sesión
- UC-BACK-003: Cambiar Contraseña
- RF-BACK-010: Validar credenciales
- RF-BACK-011: Generar token JWT
- RNF-BACK-005: Contraseña >= 8 caracteres
-->

### Leyenda de Artefactos (Matriz Vertical)

<!--
Liste los IDs con sus nombres completos para referencia rápida
-->

**Reglas de Negocio**:
- [RN-DOMINIO-###]: [Nombre de la regla]
- [RN-DOMINIO-###]: [Nombre de la regla]

**Requerimientos de Negocio**:
- [RNEG-DOMINIO-###]: [Nombre del requerimiento]

**Casos de Uso**:
- [UC-DOMINIO-###]: [Nombre del caso de uso]
- [UC-DOMINIO-###]: [Nombre del caso de uso]

**Requisitos Funcionales**:
- [RF-DOMINIO-###]: [Breve descripción]
- [RF-DOMINIO-###]: [Breve descripción]

**Atributos de Calidad**:
- [RNF-DOMINIO-###]: [Breve descripción]
- [RNF-DOMINIO-###]: [Breve descripción]

---

## TIPO 2: Matriz Horizontal (Por Caso de Uso)

<!--
Esta matriz muestra TODOS los artefactos relacionados con un caso de uso específico.
Útil para análisis de impacto: "Si cambio este UC, ¿qué más debo revisar?"

INSTRUCCIONES:
- Crear una tabla por cada caso de uso principal
- Incluir TODOS los tipos de relaciones (ascendentes y descendentes)
- Agregar más secciones según sea necesario
-->

### Matriz para UC-[DOMINIO]-[###]: [Nombre del Caso de Uso]

| Tipo de Artefacto | ID | Nombre/Descripción | Relación |
|---|---|---|---|
| **Regla de Negocio** | [RN-DOMINIO-###] | [Nombre de la regla] | [Influye en este UC] |
| **Regla de Negocio** | [RN-DOMINIO-###] | [Nombre de la regla] | [Restringe este UC] |
| **Requerimiento de Negocio** | [RNEG-DOMINIO-###] | [Nombre] | [Este UC implementa este RNEG] |
| **Requisito Funcional** | [RF-DOMINIO-###] | [Descripción] | [Derivado de este UC] |
| **Requisito Funcional** | [RF-DOMINIO-###] | [Descripción] | [Derivado de este UC] |
| **Atributo de Calidad** | [RNF-DOMINIO-###] | [Descripción] | [Aplica a este UC] |
| **Atributo de Calidad** | [RNF-DOMINIO-###] | [Descripción] | [Aplica a este UC] |
| **Test** | [TS-DOMINIO-###-001] | [Descripción del test] | [Valida este UC] |
| **Test** | [TS-DOMINIO-###-002] | [Descripción del test] | [Valida este UC] |

<!--
EJEMPLO: UC-BACK-001 Iniciar Sesión

| Tipo de Artefacto | ID | Nombre/Descripción | Relación |
|---|---|---|---|
| Regla de Negocio | RN-BACK-001 | Usuario debe estar autenticado | Justifica existencia de este UC |
| Regla de Negocio | RN-BACK-028 | Solo usuarios activos pueden iniciar sesión | Restringe quién puede ejecutar |
| Requerimiento de Negocio | RNEG-BACK-001 | Sistema de autenticación seguro | Este UC implementa este RNEG |
| Requisito Funcional | RF-BACK-010 | Validar credenciales contra BD | Derivado de paso 3 del UC |
| Requisito Funcional | RF-BACK-011 | Generar token JWT | Derivado de paso 6 del UC |
| Requisito Funcional | RF-BACK-012 | Registrar en log de auditoría | Derivado de paso 7 del UC |
| Atributo de Calidad | RNF-BACK-005 | Contraseña >= 8 caracteres | Validación en paso 2 |
| Atributo de Calidad | RNF-BACK-006 | Respuesta < 2 segundos | Aplica a todo el UC |
| Atributo de Calidad | RNF-BACK-007 | Sesión expira en 30 min | Postcondición del UC |
| Test | TS-BACK-001-001 | Test login exitoso | Valida flujo normal |
| Test | TS-BACK-001-002 | Test credenciales incorrectas | Valida flujo alterno 3.1 |
| Test | TS-BACK-001-003 | Test usuario bloqueado | Valida excepción 3.1.1 |
-->

<!-- Agregar más matrices horizontales para otros casos de uso clave -->

---

## TIPO 3: Matriz de Cobertura

<!--
Esta matriz identifica gaps: artefactos sin relaciones esperadas.
Útil para validación de completitud.

INSTRUCCIONES:
- Marcar con ✓ si tiene relación esperada
- Marcar con ✗ si NO tiene pero DEBERÍA tener (gap)
- Marcar con N/A si no aplica
-->

### Cobertura: RN → UC

<!--
¿Todas las RN tienen al menos un UC que las implemente o referencie?
-->

| Regla de Negocio | Casos de Uso Relacionados | Estado |
|---|---|:---:|
| [RN-DOMINIO-###]: [Nombre] | [UC-DOMINIO-###], [UC-DOMINIO-###] | ✓ |
| [RN-DOMINIO-###]: [Nombre] | [UC-DOMINIO-###] | ✓ |
| [RN-DOMINIO-###]: [Nombre] | Ninguno | ✗ |
| [RN-DOMINIO-###]: [Nombre] | N/A (regla interna sin UC) | N/A |

**Resumen**:
- Total RN: [número]
- RN con UC: [número] ([porcentaje]%)
- RN sin UC (gap): [número]

**Acciones requeridas**:
- [RN-DOMINIO-###]: Crear UC-DOMINIO-XXX para implementar esta regla
- [RN-DOMINIO-###]: Validar si realmente requiere UC o es solo política interna

### Cobertura: UC → RF

<!--
¿Todos los UC tienen RF que los implementen?
-->

| Caso de Uso | Requisitos Funcionales Derivados | Estado |
|---|---|:---:|
| [UC-DOMINIO-###]: [Nombre] | [RF-DOMINIO-###], [RF-DOMINIO-###], [RF-DOMINIO-###] | ✓ |
| [UC-DOMINIO-###]: [Nombre] | [RF-DOMINIO-###] | ✓ |
| [UC-DOMINIO-###]: [Nombre] | Ninguno | ✗ |

**Resumen**:
- Total UC: [número]
- UC con RF: [número] ([porcentaje]%)
- UC sin RF (gap): [número]

**Acciones requeridas**:
- [UC-DOMINIO-###]: Derivar RF de los pasos del flujo normal
- [UC-DOMINIO-###]: Validar si UC es demasiado alto nivel y debe descomponerse

### Cobertura: RF → Tests

<!--
¿Todos los RF tienen tests que los validen?
-->

| Requisito Funcional | Tests Relacionados | Estado |
|---|---|:---:|
| [RF-DOMINIO-###]: [Descripción] | [TS-###-001], [TS-###-002] | ✓ |
| [RF-DOMINIO-###]: [Descripción] | [TS-###-001] | ✓ |
| [RF-DOMINIO-###]: [Descripción] | Ninguno | ✗ |

**Resumen**:
- Total RF: [número]
- RF con tests: [número] ([porcentaje]%)
- RF sin tests (gap): [número]

**Acciones requeridas**:
- [RF-DOMINIO-###]: Crear tests unitarios y de integración
- [RF-DOMINIO-###]: Crear tests E2E

---

## Análisis de Impacto

<!--
OPCIONAL: Use esta sección para documentar análisis de impacto de cambios propuestos.
-->

### Cambio Propuesto: [Descripción del cambio]

**Artefacto a modificar**: [ID y nombre]

**Tipo de cambio**: [Menor | Mayor | Breaking]

**Artefactos impactados** (según matriz de trazabilidad):

| Artefacto | Impacto | Acción Requerida | Responsable | Estado |
|---|---|---|---|:---:|
| [ID] | [Descripción del impacto] | [Qué debe actualizarse] | [Quién] | ⏳ |
| [ID] | [Descripción del impacto] | [Qué debe actualizarse] | [Quién] | ✓ |
| [ID] | [Descripción del impacto] | [Qué debe actualizarse] | [Quién] | ✗ |

**Leyenda**:
- ⏳ = Pendiente
- ✓ = Completado
- ✗ = Bloqueado/Problema

---

## Visualización Gráfica

<!--
OPCIONAL: Si existe un diagrama visual de la trazabilidad, referencie aquí.
Puede ser un diagrama PlantUML, Mermaid, o imagen.
-->

![Diagrama de Trazabilidad](../diagramas/trazabilidad/TRACE-[DOMINIO]-[###].svg)

**Fuente**: [Ruta al archivo fuente del diagrama]

---

## Notas y Observaciones

<!--
OPCIONAL: Cualquier nota relevante sobre la trazabilidad de este módulo.
-->

**Observaciones**:
- [Observación 1]
- [Observación 2]

**Decisiones tomadas**:
- [Decisión 1]: [Justificación]
- [Decisión 2]: [Justificación]

**Riesgos identificados**:
- [Riesgo 1]: [Descripción y mitigación]

---

## Mantenimiento de la Matriz

**Frecuencia de actualización**: [Semanal | Por cada sprint | Mensual | Por cambios mayores]

**Responsable de mantenimiento**: [Rol o persona]

**Última validación completa**: [YYYY-MM-DD]

**Próxima validación programada**: [YYYY-MM-DD]

**Proceso de actualización**:
1. [Paso 1]
2. [Paso 2]
3. [Paso 3]

---

## Historial de Cambios de la Matriz

| Versión | Fecha | Autor | Cambios | Artefactos Agregados/Modificados |
|---------|-------|-------|---------|----------------------------------|
| 1.0.0 | [YYYY-MM-DD] | [Autor] | Creación inicial | [número] artefactos |
| 1.1.0 | [YYYY-MM-DD] | [Autor] | Agregado UC-DOMINIO-005 | +3 RF, +2 RNF |

<!--
Es importante trackear cambios en la matriz para entender su evolución
-->
