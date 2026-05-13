# Requirements Lifecycle — [Nombre del proyecto]

```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: ba:requirements-lifecycle
baseline_version: v1.0
author: [nombre]
status: Borrador
```

---

## Traceability Matrix (RTM)

| Req ID | Descripción | Origen (Need ID) | MoSCoW | Componente / Feature | Test Case | Estado |
|--------|-------------|:----------------:|:------:|---------------------|:---------:|:------:|
| REQ-001 | [descripción breve] | NEED-001 | Must | [componente] | TC-001 | Aprobado |
| REQ-002 | [descripción] | NEED-001 | Should | [componente] | TC-002 | En implementación |
| REQ-003 | [descripción] | NEED-002 | Must | [componente] | — | Borrador |

**Leyenda de estados:**

| Estado | Descripción |
|--------|-------------|
| Identificado | Capturado en elicitación; sin análisis formal |
| Analizado | Modelado y especificado; pendiente de sign-off |
| Aprobado | Firmado por el stakeholder relevante |
| En implementación | Siendo construido por el equipo técnico |
| Implementado | Construido; test case creado |
| Verificado | Tests pasados; cumple la especificación |
| Validado | Confirmado por stakeholder que satisface la necesidad original |
| Diferido | Pospuesto para versión futura |
| Cancelado | Ya no aplica — ver CR asociado |
| Reemplazado | Supersedido por otro requisito — ver CR asociado |

---

## Baseline actual

| Campo | Valor |
|-------|-------|
| **Versión** | v1.0 |
| **Fecha de baseline** | [fecha] |
| **Aprobado por** | [nombre / rol] |
| **Total requisitos en baseline** | [#] |
| **Must Have** | [#] |
| **Should Have** | [#] |
| **Could Have** | [#] |

> **Regla:** Modificar requisitos en baseline requiere CR formal. Sin este control, la baseline pierde su valor como punto de referencia.

---

## Change Requests activos

| CR ID | Descripción | Tipo | Requisitos afectados | Análisis de impacto | Prioridad | Estado |
|-------|-------------|:----:|:--------------------:|--------------------|-----------:|:------:|
| CR-001 | [descripción del cambio solicitado] | Nuevo / Modificación / Cancelación | REQ-00X | [componentes, tests, schedule afectados] | Alta | En evaluación |
| CR-002 | | | | | | |

**Historial de CRs procesados:**
| CR ID | Descripción | Decisión | Fecha | Decidido por |
|-------|-------------|:--------:|-------|-------------|
| CR-000 | [descripción] | Aprobado / Rechazado / Diferido | [fecha] | [sponsor/CCB] |

---

## Métricas del ciclo de vida

| Estado | # Requisitos | % del total |
|--------|:-----------:|:-----------:|
| Identificado | 0 | 0% |
| Analizado | 0 | 0% |
| Aprobado | 0 | 0% |
| En implementación | 0 | 0% |
| Implementado | 0 | 0% |
| Verificado | 0 | 0% |
| Validado | 0 | 0% |
| Diferido | 0 | 0% |
| Cancelado | 0 | 0% |
| **Total** | **0** | **100%** |

**Cobertura de traceabilidad:**
- % requisitos con componente asignado: [%]
- % requisitos con test case: [%]
- % requisitos verificados: [%]
- % requisitos validados: [%]

---

## Evaluación de completitud de este ciclo

- [ ] RTM actualizada con todos los eventos del periodo (aprobaciones, implementaciones, CRs)
- [ ] CRs activos evaluados con análisis de impacto completo
- [ ] Decisiones de governance documentadas (aprobar / rechazar / diferir)
- [ ] Stakeholders notificados de los cambios aprobados
- [ ] Estados de la RTM reflejan el estado real del proyecto

---

## Routing — próxima KA

| Situación | Próxima KA |
|-----------|-----------|
| CRs requieren re-análisis mayor de requisitos | `ba:requirements-analysis` |
| Se necesita información adicional para evaluar impacto de un CR | `ba:elicitation` |
| CRs afectan la estrategia de negocio | `ba:strategy` |
| Todos los requisitos en estado "Validado" | `ba:solution-evaluation` |
| RTM estable; continuar monitoring | Continuar en esta KA |

**Decisión:** [KA seleccionada + razón]
