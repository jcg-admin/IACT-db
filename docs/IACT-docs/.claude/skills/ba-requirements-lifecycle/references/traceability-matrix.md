# Traceability Matrix — Guía de Construcción y Gestión

## Qué es y por qué importa

La Traceability Matrix (RTM) es el artefacto central de Requirements Lifecycle Management. Permite:

1. **Trazabilidad hacia atrás (backward):** Cada requisito puede rastrearse a la necesidad de negocio que lo originó → asegura que no se implementa nada sin justificación
2. **Trazabilidad hacia adelante (forward):** Cada requisito puede rastrearse a su implementación y tests → asegura cobertura completa
3. **Análisis de impacto:** Cuando un requisito cambia, la RTM muestra qué componentes y tests se ven afectados
4. **Gestión del scope:** La RTM es la fuente de verdad sobre qué está y qué no está en scope

---

## Construcción de la RTM paso a paso

### Paso 1: Crear la columna Origen

Cada requisito debe poder rastrearse a una necesidad de negocio identificada en Elicitation o Strategy:

```
NEED-001 (Reducir tiempo de proceso) → REQ-001, REQ-002, REQ-003
NEED-002 (Notificaciones en tiempo real) → REQ-004, REQ-005
```

**Señal de problema:** Un requisito sin NEED-ID es un requisito sin justificación de negocio — candidato a eliminación o a cuestionamiento.

### Paso 2: Asignar componentes de diseño

Cuando el equipo técnico define la arquitectura, cada requisito debe mapearse a uno o más componentes:

```
REQ-001 → Módulo de workflow + API de aprobación
REQ-004 → Servicio de notificaciones
```

**Momento:** Al completar el diseño técnico (no antes — asignar componentes antes de diseñar es prematuro).

### Paso 3: Vincular test cases

Cada requisito verificable debe tener al menos un test case asociado:

```
REQ-001 → TC-001 (happy path), TC-002 (timeout), TC-003 (rechazo)
```

**Cobertura mínima recomendada:** 1 test por requisito Must Have (mínimo); 3 tests para requisitos críticos (flujo nominal + 2 excepciones).

### Paso 4: Mantener el estado actualizado

El estado de cada requisito en la RTM debe reflejar el estado real del trabajo:

| Evento en el proyecto | Actualización en RTM |
|----------------------|---------------------|
| BA firma especificación | Estado: Analizado → Aprobado |
| Stakeholder da sign-off | Estado: Aprobado (confirmar) |
| Dev inicia implementación | Estado: Aprobado → En implementación |
| Dev completa implementación | Estado: En implementación → Implementado |
| QA pasa los tests | Estado: Implementado → Verificado |
| Stakeholder valida en UAT | Estado: Verificado → Validado |
| CR aprobado modifica requisito | Actualizar descripción + nueva versión |
| CR aprobado cancela requisito | Estado: Cancelado + referencia al CR |

---

## Process de Change Request para requisitos

### Flujo completo de un CR

```
Stakeholder identifica necesidad de cambio
  ↓
BA documenta CR (CR-NNN)
  ↓
Análisis de impacto (BA + IT)
  ↓
Evaluación de prioridad (BA + PM)
  ↓
Decisión de governance (Sponsor / CCB)
  ├── Aprobado → Actualizar RTM + notificar equipo + implementar
  ├── Rechazado → Documentar razón en CR + notificar solicitante
  └── Diferido → Marcar como diferido + revisar en próxima release
```

### Template de Change Request

| Campo | Contenido |
|-------|-----------|
| **CR ID** | CR-NNN (secuencial) |
| **Fecha de solicitud** | YYYY-MM-DD |
| **Solicitado por** | Nombre + rol |
| **Tipo de cambio** | Nuevo requisito / Modificación / Cancelación / Prioridad |
| **Descripción** | Qué se pide cambiar y por qué |
| **Justificación** | Necesidad de negocio que lo motiva |
| **Requisitos afectados** | REQ-NNN (lista) |
| **Análisis de impacto — Scope** | Qué cambia en el alcance |
| **Análisis de impacto — Schedule** | Cuántos días adicionales / reducción |
| **Análisis de impacto — Costo** | Estimación de costo del cambio |
| **Análisis de impacto — Calidad** | Riesgo para la integridad del sistema |
| **Análisis de impacto — Tests** | Cuántos test cases afectados / nuevos |
| **Recomendación del BA** | Aprobar / Rechazar / Diferir + razón |
| **Decisión** | Aprobado / Rechazado / Diferido |
| **Fecha de decisión** | YYYY-MM-DD |
| **Decidido por** | Nombre + rol |
| **Fecha de implementación** | YYYY-MM-DD (si aprobado) |

---

## Ciclo de vida de estados — máquina de estados

```
[*] → Identificado
Identificado → Analizado: BA completa el modelado
Analizado → Aprobado: Stakeholder da sign-off
Analizado → Identificado: Stakeholder pide correcciones
Aprobado → En implementación: Dev inicia trabajo
Aprobado → En cambio: Se crea un CR sobre este requisito
En cambio → Aprobado: CCB aprueba el CR
En cambio → Diferido: CCB difiere
En implementación → Implementado: Dev entrega
Implementado → Verificado: QA pasa los tests
Verificado → Validado: UAT con stakeholder exitoso
Verificado → En implementación: UAT falla; retrabajo
Aprobado → Diferido: CR lo difiere a futuro
Diferido → Analizado: Se retoma en futura release
Aprobado → Cancelado: CR lo cancela
```

---

## Métricas de salud de la RTM

### Indicadores de cobertura

| Métrica | Fórmula | Target |
|---------|---------|--------|
| **Cobertura backward** | # Req con NEED-ID / Total req | 100% |
| **Cobertura de diseño** | # Req con componente / Total Must+Should | > 90% |
| **Cobertura de tests** | # Req con ≥ 1 test case / Total req | 100% Must Have |
| **% Validados** | # Req Validados / Total req | 100% al cierre |

### Señales de RTM problemática

| Señal | Causa probable | Acción |
|-------|---------------|--------|
| > 20% sin NEED-ID | Requisitos sin trazabilidad al negocio | Rastrear o eliminar |
| > 30% sin test case al final del desarrollo | Cobertura de QA insuficiente | Crear tests antes de release |
| Estado en "Implementado" sin moverse a "Verificado" en > 2 sprints | Tests bloqueados o no ejecutados | Investigar con QA |
| CRs que se aprueban sin RTM actualizada | Proceso de governance incompleto | Exigir actualización RTM en cada CR |
| RTM solo en Excel local del BA | Riesgo de pérdida; sin visibilidad del equipo | Migrar a repositorio compartido |

---

## Gestión de baselines

### Cuándo crear una baseline

| Momento | Tipo de baseline | Propósito |
|---------|-----------------|-----------|
| Al completar la especificación de los Must Have | Baseline inicial | Punto de partida para el desarrollo |
| Al inicio de cada sprint (ágil) | Baseline de sprint | Requisitos confirmados para el sprint |
| Al planificar cada release | Baseline de release | Qué va en el release |
| Después de un CR mayor aprobado | Baseline de re-scope | Nuevo punto de referencia después del cambio |

### Versionado de baselines

```
v1.0 — Baseline inicial (2026-04-15) — 45 requisitos
v1.1 — Post-CR-003 (2026-04-28) — 47 requisitos (+2 nuevos, -0)
v1.2 — Post-CR-007 (2026-05-10) — 45 requisitos (+1 nuevo, -3 cancelados)
```

**Regla:** La baseline no se modifica retroactivamente. Siempre se crea una nueva versión.
