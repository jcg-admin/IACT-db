# Change Control Process — Guía de referencia

> Reference for rm:management. CCB proceso detallado, impact assessment, change log format.

---

## ¿Qué es el Control de Cambios?

El **Change Control** es el proceso que garantiza que los cambios a los requisitos baseline sean evaluados, aprobados por las personas correctas e implementados de forma controlada — sin introducir inconsistencias en la especificación, el diseño o los tests.

**Sin change control:** Los cambios se implementan informalmente → la especificación diverge del código → los tests son obsoletos → imposible saber qué fue acordado.

---

## CCB — Change Control Board

### Composición del CCB

| Rol | Responsabilidad en el CCB | Participación |
|-----|--------------------------|--------------|
| **Product Owner / Sponsor** | Aprueba cambios de scope y prioridad | Obligatoria para cambios de scope |
| **Analista de RM** | Presenta el análisis de impacto | Obligatoria siempre |
| **Arquitecto / Tech Lead** | Evalúa impacto técnico y factibilidad | Obligatoria para cambios técnicos |
| **Project Manager** | Evalúa impacto en cronograma y presupuesto | Obligatoria para cambios con impacto de proyecto |
| **QA Lead** | Evalúa impacto en cobertura de tests | Recomendada |
| **Stakeholder solicitante** | Presenta el CR y responde preguntas | Recomendada |

### Quórum mínimo

- Para CRs de impacto **Alto:** PO + Tech Lead + Analista RM (obligatorio)
- Para CRs de impacto **Medio:** Analista RM + Tech Lead (mínimo)
- Para CRs de impacto **Bajo:** Analista RM (puede aprobar solo, con notificación)

### Frecuencia del CCB

| Contexto | Frecuencia recomendada |
|----------|----------------------|
| Proyecto en construction activa | Semanal (reunión fija) |
| Proyecto en maintenance | Quincenal o mensual |
| CR urgente / bloqueante | Asincrónico (email/Slack con quórum mínimo) |

---

## Pipeline de un Change Request

```
SOLICITUD
    │
    ▼
[Registro del CR]
    │ CR ID, solicitante, fecha, descripción
    │
    ▼
[Análisis de impacto] ← Analista RM + Tech Lead
    │ Requisitos afectados, esfuerzo, riesgo, opciones
    │
    ▼
[Revisión CCB]
    │
    ├── Aprobado ──────────────────────────────────►[Implementar]
    │                                                    │
    ├── Aprobado con condiciones ─────────────────►[Implementar con restricciones]
    │                                                    │
    ├── Diferido ────────────────────────────────►[Backlog para versión X]
    │
    └── Rechazado ──────────────────────────────►[Documentar razón + notificar]
                                                        │
                                                        ▼
                                                [Implementación]
                                                    │
                                                    ▼
                                                [Actualizar spec]
                                                    │
                                                    ▼
                                                [Actualizar trazabilidad]
                                                    │
                                                    ▼
                                                [Nueva baseline]
                                                    │
                                                    ▼
                                                [Notificar stakeholders]
                                                    │
                                                    ▼
                                                [Cerrar CR]
```

---

## Impact Assessment — plantilla de análisis

### Sección 1: Alcance del cambio

```
¿Qué exactamente cambia?
  Requisito modificado: [REQ-NNN: descripción actual → descripción propuesta]
  Requisito eliminado: [REQ-NNN]
  Requisito nuevo: [descripción]

¿Por qué cambia? (contexto de negocio)
  [razón de negocio, evento externo, error identificado]

¿Quién lo solicitó y con qué urgencia?
  Solicitante: [nombre / rol] — Urgencia: [Crítica / Alta / Normal / Baja]
```

### Sección 2: Análisis de impacto técnico

| Área | Impacto | Esfuerzo estimado |
|------|---------|------------------|
| Especificación (actualizar req) | [descripción] | [h] |
| Diseño / Arquitectura | [componentes afectados] | [h] |
| Base de datos (schema changes) | [tablas/columnas afectadas] | [h] |
| Backend (código) | [módulos afectados] | [h] |
| Frontend (UI) | [pantallas afectadas] | [h] |
| Tests (actualizar / nuevos) | [casos de prueba afectados] | [h] |
| Documentación | [docs a actualizar] | [h] |
| **Total estimado** | | **[H total]** |

### Sección 3: Análisis de impacto en proyecto

| Dimensión | Impacto |
|-----------|---------|
| Cronograma | [+N días / sin impacto / crítico] |
| Presupuesto | [$N / sin costo adicional] |
| Scope | [aumenta / reduce / no afecta] |
| Calidad | [riesgo de regresión / mejora / neutro] |
| Dependencias | [otros CRs o tareas bloqueados] |

### Sección 4: Riesgos del cambio

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|---------|-----------|
| [riesgo de regresión] | Alta / Media / Baja | Alto / Medio / Bajo | [mitigación] |
| [riesgo de cronograma] | | | |

### Sección 5: Recomendación del analista

```
[ ] Aprobar — impacto bajo, factible en el sprint/iteración actual
[ ] Aprobar con ajuste de cronograma — impacto [N días], requiere ajuste
[ ] Diferir a versión [X] — importante pero no urgente; no afecta el release actual
[ ] Rechazar — [razón: scope, costo, riesgo técnico no justificado]
```

---

## Change Log — formato estándar

El change log documenta la historia completa de cambios a la especificación:

```markdown
# Change Log — Requirements Specification

## v1.3 — [fecha]
### Added
- REQ-025: [descripción] — CR-008 (aprobado [fecha])

### Modified
- REQ-007: [descripción del cambio] — CR-006 (aprobado [fecha])
  Before: [texto anterior]
  After: [texto nuevo]

### Removed
- REQ-018: [justificación de la eliminación] — CR-007 (aprobado [fecha])

---

## v1.2 — [fecha]
[...]
```

**Reglas del change log:**
- Una entrada por CR cerrado
- Siempre incluir el ID del CR y la fecha de aprobación
- Para modificaciones: documentar el texto anterior y el nuevo
- Las eliminaciones deben incluir la justificación

---

## Matriz de trazabilidad — gestión y actualización

### Niveles de trazabilidad

| Nivel | Traza | Propósito |
|-------|-------|-----------|
| **Horizontal** | Req ← → Req | Detectar conflictos y dependencias |
| **Vertical hacia adelante** | Req → Design → Code → Test | Verificar que cada req fue implementado |
| **Vertical hacia atrás** | Test → Code → Design → Req | Verificar que cada test tiene un req que lo justifica |
| **Origen** | Req → Stakeholder / Sesión | Saber quién pidió qué (para resolver conflictos) |

### Cuándo actualizar la trazabilidad

| Evento | Qué actualizar |
|--------|---------------|
| Nuevo requisito aprobado | Agregar fila con Req ID, origen, estado |
| Requisito modificado | Actualizar descripción + incrementar versión |
| Requisito eliminado | Marcar como "Eliminado (CR-NNN)" — no borrar |
| Diseño completado | Agregar columna Design con referencia al componente |
| Código completado | Agregar columna Code con referencia al módulo |
| Test completado | Agregar columna Test con referencia al caso de prueba |
| CR aprobado | Actualizar todas las columnas afectadas |

### Señales de deuda de trazabilidad

- Tests sin req que los justifiquen (código sin requisito → gold plating)
- Req sin tests asociados (req no verificable → feature sin cobertura)
- Req "en diseño" por más de 2 iteraciones (bloqueado)
- Columna "Code" inconsistente con la rama actual del repositorio

---

## Patrones de change request por tipo

### CR tipo: Nuevo requisito

**Señal:** El stakeholder pide algo que no está en la especificación actual.

**Pre-validación antes de aceptar el CR:**
1. ¿Ya existe un req similar? (prevenir duplicados)
2. ¿Está en el scope del proyecto? (si no → diferir o escalar a PO)
3. ¿Tiene impacto en la arquitectura o en otros requisitos?

### CR tipo: Modificación de requisito existente

**Señal:** Un requisito aprobado debe cambiar (prioridad, criterio, descripción).

**Pre-validación:**
1. Identificar todos los documentos que hacen referencia al req (spec, tests, diseño)
2. Evaluar si el cambio invalida tests existentes
3. Evaluar si el cambio crea conflictos con otros req

### CR tipo: Eliminación de requisito

**Señal:** Un requisito aprobado debe quitarse del scope.

**Pre-validación:**
1. ¿Otros requisitos dependen del req a eliminar? (revisar dependencias)
2. ¿Ya fue parcialmente implementado? (implicaciones de código a eliminar)
3. ¿El stakeholder entiende las implicaciones de la eliminación?

**Nota:** Nunca eliminar físicamente de la especificación — marcar como "Eliminado" con referencia al CR. El historial de lo que se quitó es valioso.

### CR tipo: Defecto en requisito

**Señal:** Un req aprobado contiene un error (ambigüedad, inconsistencia, dato incorrecto).

**Proceso simplificado:** Si el defecto es de escritura y no cambia la intención del negocio:
- El analista puede corregirlo directamente sin CCB formal
- Documentar la corrección en el change log como "Fixed typo / Clarification (sin CR)"
- Notificar al stakeholder de origen

Si el defecto cambia la intención del negocio → proceso completo de CR.
