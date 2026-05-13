```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: pm:planning
author: [nombre]
status: Borrador
```

# PM Planning — Artefacto

---

## Project Management Plan — Resumen

### Scope Baseline

**Work Breakdown Structure (summary — top 2 niveles)**

```
1.0 [Nombre del Proyecto]
├── 1.1 [Entregable principal 1]
│   ├── 1.1.1 [Work Package]
│   └── 1.1.2 [Work Package]
├── 1.2 [Entregable principal 2]
│   ├── 1.2.1 [Work Package]
│   └── 1.2.2 [Work Package]
└── 1.3 Project Management
    ├── 1.3.1 Planning
    └── 1.3.2 Monitoring & Closing
```

| Campo | Contenido |
|-------|-----------|
| **Scope exclusions** | [Qué está explícitamente fuera del scope] |
| **Constraints** | [Limitaciones de scope que no pueden cambiarse] |
| **Acceptance criteria de scope** | [Cómo se verifica que el scope está completo] |

### Schedule Baseline

| Campo | Valor |
|-------|-------|
| **Duración total** | [N semanas / meses] |
| **Fecha de inicio** | [fecha] |
| **Fecha de completion** | [fecha] |
| **Critical Path** | [Actividades en el CP — secuencia] |
| **Float del CP** | 0 días (por definición) |
| **Schedule reserve** | [N días de buffer] |

**Key Milestones:**

| Milestone | Descripción | Fecha baseline | Predecessors |
|-----------|-------------|---------------|-------------|
| M-01 | Planning completado | [fecha] | — |
| M-02 | [Deliverable clave] | [fecha] | M-01 |
| M-03 | Producto final entregado | [fecha] | M-02 |

### Cost Baseline

| Concepto | Estimado | % del total |
|----------|---------|------------|
| Recursos humanos | $ | % |
| Infraestructura / licencias | $ | % |
| Herramientas | $ | % |
| Otros costos directos | $ | % |
| **Cost Baseline (BAC)** | **$** | **100%** |
| Contingency reserves (riesgos conocidos) | $ | — |
| Management reserves (riesgos desconocidos) | $ | — |
| **Budget Total** | **$** | — |

### Quality Management Plan

| Campo | Contenido |
|-------|-----------|
| **Estándares aplicables** | [ISO / OWASP / PCI / internos de la organización] |
| **QA approach** | [Proceso para asegurar calidad — auditorías, revisiones] |
| **QC approach** | [Proceso para controlar calidad — pruebas, inspecciones] |

**Métricas de calidad:**

| Métrica | Objetivo | Umbral de alerta | Frecuencia de medición |
|---------|---------|-----------------|----------------------|
| Defects density (defectos/KLOC) | < 5 | > 8 | Por sprint/iteración |
| Test coverage | ≥ 80% | < 70% | Continuous |
| [Métrica de negocio] | | | |

### Resource Management / RACI

| Deliverable / Actividad | PM | Dev Lead | Dev | QA | Sponsor |
|------------------------|----|---------|----|----|----|
| [Deliverable 1] | A | R | R/C | C | I |
| [Deliverable 2] | A | R | | C | I |
| Project Charter | A | I | | | R |
| Acceptance testing | I | R | C | R | A |

**Leyenda:** R=Responsible · A=Accountable (solo 1 por fila) · C=Consulted · I=Informed

### Risk Register — Top 10

| Risk ID | Descripción | Categoría | P | I | Score | Estrategia | Plan de respuesta | Owner | Trigger |
|---------|-------------|-----------|---|---|-------|-----------|-----------------|-------|---------|
| R-001 | | Técnico | H/M/L | H/M/L | | Mitigar/Evitar/Aceptar/Transferir | | | |

**Leyenda:** P = Probabilidad · I = Impacto · Score = P × I (H/M/L)

### Communications Plan

| Información | Audiencia | Frecuencia | Formato | Responsable |
|-------------|-----------|-----------|---------|-------------|
| Status report | Sponsor + Stakeholders clave | Semanal | Informe EVM + RAG | PM |
| Sprint review | Equipo + PO | Cada 2 semanas | Reunión + demo | PM |
| Risk review | Equipo + Sponsor | Mensual | Tabla de riesgos | PM |

### Stakeholder Engagement Plan

| Stakeholder | Estado actual | Estado deseado | Acciones | Responsable |
|-------------|-------------|--------------|---------|-------------|
| [nombre] | Neutral | Supportive | [acción específica] | PM |

---

## Aprobación del Project Management Plan

| Campo | Valor |
|-------|-------|
| **Sponsor** | [nombre] |
| **Fecha de aprobación** | [fecha] |
| **Decisión** | Aprobado / Aprobado con condiciones / Requiere revisión |
| **Condiciones (si aplica)** | [descripción de las condiciones] |

---

## Evaluación de completitud

- [ ] WBS completo con work packages a nivel de 8-80 horas
- [ ] Critical Path identificado y documentado
- [ ] Cost Baseline dentro del budget aprobado en Charter
- [ ] Risk Register con al menos 10 riesgos y planes de respuesta
- [ ] RACI completo — exactamente 1 Accountable por deliverable
- [ ] Communications Plan con frecuencia y responsable por ítem
- [ ] Project Management Plan aprobado por el sponsor

---

## Decisión de flujo

- [ ] **Avanzar a pm:executing** — Project Management Plan aprobado
- [ ] **Más iteración de planning** — Motivo: [WBS incompleto / estimaciones fuera de rango / riesgos sin respuesta]
