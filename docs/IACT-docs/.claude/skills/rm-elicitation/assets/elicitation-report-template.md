```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: rm:elicitation
author: [nombre]
status: Borrador
```

# RM Elicitation — Artefacto

---

## Plan de elicitación

> Técnicas disponibles: [elicitation-techniques.md](../references/elicitation-techniques.md)

| Campo | Detalle |
|-------|---------|
| **Objetivo de elicitación** | [qué necesidades se van a explorar en esta sesión/ciclo] |
| **Alcance** | [procesos, sistemas, áreas cubiertas] |
| **Período** | [fechas del ciclo de elicitación] |

**Stakeholders participantes:**

| Stakeholder | Rol | Área | Disponibilidad | Técnica asignada |
|-------------|-----|------|---------------|-----------------|
| [nombre] | [rol en el negocio] | [área / departamento] | [días/horas] | [Entrevista / Workshop / Observación] |

**Técnicas seleccionadas y justificación:**

| Técnica | Stakeholders | Justificación de selección | Sesiones planificadas |
|---------|-------------|--------------------------|----------------------|
| [Entrevista / Workshop / Observación / Encuesta / Prototipo / Análisis documental / Otros] | [quiénes] | [por qué esta técnica para estos stakeholders] | [N sesiones × duración] |

**Calendario de sesiones:**

| Sesión | Fecha | Técnica | Participantes | Objetivo específico |
|--------|-------|---------|--------------|--------------------:|
| S-01 | [fecha] | [técnica] | [participantes] | [qué se explorar] |
| S-02 | | | | |

---

## Hallazgos por sesión

### Sesión S-01: [fecha] — [técnica] con [stakeholder]

**Necesidades identificadas:**

| # | Necesidad expresada (literal) | Contexto / por qué la necesita | Prioridad percibida |
|---|------------------------------|-------------------------------|---------------------|
| N-001 | "[cita literal o paráfrasis fiel]" | [contexto del negocio] | Alta / Media / Baja |
| N-002 | | | |

**Restricciones y constraints expresados:**

| Tipo | Descripción |
|------|-------------|
| Técnico | [sistema existente, tecnología mandatada] |
| Negocio | [proceso obligatorio, regulación] |
| Temporal | [deadline fijo] |

**Preguntas sin responder / a seguir:**

- [Pregunta que quedó sin responder — agendar seguimiento]

*(repetir sección por cada sesión)*

---

## Requisitos candidatos (pre-análisis)

> Lista de necesidades tal como fueron expresadas — sin filtrar, sin interpretar.
> El análisis de calidad, conflictos y priorización ocurre en rm:analysis.

| Req-C ID | Fuente (stakeholder / sesión) | Necesidad expresada | Categoría tentativa |
|----------|------------------------------|---------------------|---------------------|
| RC-001 | [stakeholder] / S-01 | [necesidad literal] | Funcional / NFR / Restricción |
| RC-002 | | | |

**Total de requisitos candidatos:** [N]

---

## Conflictos y tensiones identificados

| ID | Descripción del conflicto | Stakeholders involucrados | Impacto potencial |
|----|--------------------------|--------------------------|------------------|
| CF-001 | [A dice X, B dice lo contrario] | [stakeholder A vs B] | [qué se ve afectado] |

---

## Confirmación con stakeholders

| Stakeholder | Fecha | Método | Resumen enviado | Feedback recibido | ¿Aprobado? |
|-------------|-------|--------|----------------|------------------|-----------|
| [nombre] | [fecha] | Email / Reunión / Portal | ✅ / ⏳ | [qué agregaron / corrigieron] | ✅ / ⚠️ pendiente |

---

## Gaps pendientes

| Gap ID | Descripción | Stakeholder a consultar | Próxima acción |
|--------|-------------|------------------------|----------------|
| GP-001 | [qué quedó sin responder] | [quién sabe esto] | Nueva sesión S-0N / Email / Workshop |

---

## Decisión de flujo

- [ ] **Avanzar a rm:analysis** — requisitos candidatos suficientes para análisis; gaps no críticos documentados
- [ ] **Nueva sesión de elicitación** — Motivo: [gaps críticos / stakeholder clave no disponible / conflictos sin datos suficientes]
