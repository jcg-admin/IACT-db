```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: pm:closing
author: [nombre]
status: Borrador
```

# PM Closing — Artefacto

---

## Final Acceptance

| Campo | Valor |
|-------|-------|
| **Sponsor / Cliente** | [nombre, rol] |
| **Fecha de aceptación** | [fecha] |
| **Deliverables aceptados** | [lista completa] |
| **Outstanding issues transferidos a operaciones** | [lista — si aplica] |
| **Condiciones especiales** | [restricciones post-entrega, garantías, SLA] |

---

## Performance vs Baseline — Resumen final

### EVM Final

| Indicador | Valor final | Interpretación |
|-----------|------------|---------------|
| **BAC** | $ | Budget original |
| **EAC** (costo final real) | $ | |
| **VAC** (Variance at Completion) | $ | BAC − EAC · positivo = bajo presupuesto |
| **SPI final** | | > 1: terminó adelante · < 1: terminó tarde |
| **CPI final** | | > 1: eficiente · < 1: sobre costo |

### Baseline vs Real

| Dimensión | Baseline | Real | Varianza | Causa principal |
|-----------|---------|------|---------|----------------|
| **Fecha de completion** | [fecha] | [fecha] | [±N días] | |
| **Costo total** | $ | $ | [±$] | |
| **Scope entregado** | [lista] | [lista] | [diferencias] | |

---

## Lecciones Aprendidas

> Formato: Qué funcionó bien → repetir · Qué no funcionó → mejorar · Sorpresa → a considerar

### Integration Management
- **Bien:** [práctica efectiva de coordinación general]
- **Mejorar:** [área de coordinación que generó problemas]

### Scope Management
- **Bien:** [qué salió bien en la gestión del scope]
- **Mejorar:** [cómo se pueden prevenir cambios de scope no controlados]

### Schedule Management
- **Bien:** [qué salió bien en la estimación y seguimiento]
- **Mejorar:** [qué causó las varianzas de cronograma más significativas]

### Cost Management
- **Bien:** [qué salió bien en la gestión del presupuesto]
- **Mejorar:** [qué causó las varianzas de costo más significativas]

### Quality Management
- **Bien:** [prácticas de QA/QC que funcionaron]
- **Mejorar:** [defectos que llegaron tarde y pudieron detectarse antes]

### Resource Management
- **Bien:** [cómo se gestionaron los recursos efectivamente]
- **Mejorar:** [conflictos de recursos que se pudieron prevenir]

### Communications Management
- **Bien:** [qué aspectos de comunicación funcionaron bien]
- **Mejorar:** [stakeholders o canales que requirieron más atención]

### Risk Management
- **Riesgos que se materializaron:** [lista con causa e impacto real]
- **Riesgos identificados que NO se materializaron:** [lista]
- **Riesgos que NO fueron identificados:** [lista — los que sorprendieron]
- **Mejorar:** [qué habría mejorado la identificación de riesgos]

### Stakeholder Management
- **Bien:** [stakeholders bien gestionados]
- **Mejorar:** [resistencias que se pudieron gestionar mejor]

### Recomendaciones para proyectos futuros

| Recomendación | Contexto de aplicación | Prioridad |
|---------------|----------------------|-----------|
| | | Alta / Media / Baja |

---

## Artefactos Archivados

| Categoría | Artefacto | Ubicación | Responsable del archivo |
|-----------|-----------|-----------|------------------------|
| Project Charter | pm-initiating.md | [path/repositorio] | PM |
| Project Management Plan | pm-planning.md | | PM |
| Status Reports | pm-executing.md (iteraciones) | | PM |
| EVM Reports | pm-monitoring.md (periodos) | | PM |
| Risk Register final | | | PM |
| Lecciones aprendidas | pm-closing.md | | PM |
| Código fuente | [repositorio] | | Dev Lead |
| Documentación técnica | [path] | | Dev Lead |

---

## Release del Equipo

| Miembro | Rol en el proyecto | Fecha de release | Próxima asignación | Evaluación de desempeño |
|---------|-------------------|-----------------|-------------------|------------------------|
| | | | | Entregada / Pendiente |

---

## Cierre de Contratos (si aplica)

| Contrato | Proveedor | Servicio | Estado | Fecha de cierre formal | Observaciones |
|----------|-----------|---------|--------|----------------------|---------------|
| | | | Cerrado / Pendiente documentación | | |

---

## Final Project Report — Resumen ejecutivo

### Objectives Achieved

| Objetivo (del Charter) | Resultado | % Achievement | Comentario |
|------------------------|---------|--------------|-----------|
| [Objetivo SMART 1] | [resultado real] | % | |

### Key Decisions Made

| Decisión | Fecha | Razón | Resultado |
|---------|-------|-------|---------|
| | | | |

### Recommendations for Operations

| Recomendación | Área | Prioridad |
|--------------|------|-----------|
| [Acción de seguimiento post-entrega] | Ops / IT / Negocio | Alta / Media |

---

## Checklist de cierre

- [ ] Final Acceptance firmado por sponsor/cliente
- [ ] Lecciones aprendidas documentadas y compartidas con PMO
- [ ] Todos los artefactos del proyecto archivados en repositorio organizacional
- [ ] Equipo liberado con evaluaciones de desempeño entregadas
- [ ] Contratos cerrados formalmente (si aplica)
- [ ] Final Project Report entregado al sponsor
- [ ] Outstanding issues transferidos a operaciones con owner definido

---

## Decisión de flujo

- [ ] **Proyecto cerrado formalmente** — todos los criterios de cierre cumplidos
- [ ] **Fase cerrada** — iniciar nuevo Initiating para la siguiente fase del programa
