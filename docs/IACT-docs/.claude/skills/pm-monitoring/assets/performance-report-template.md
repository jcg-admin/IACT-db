```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: pm:monitoring
reporting_period: [YYYY-MM-DD a YYYY-MM-DD]
author: [nombre]
status: Borrador
```

# PM Monitoring & Controlling — Artefacto

---

## EVM — Earned Value Management — Periodo [YYYY-MM-DD]

### Variables fundamentales

| Variable | Valor | Fórmula |
|----------|-------|---------|
| **BAC** (Budget at Completion) | $ | Definido en Planning |
| **PV** (Planned Value) | $ | % Planeado × BAC |
| **EV** (Earned Value) | $ | % Completado real × BAC |
| **AC** (Actual Cost) | $ | Costo real incurrido |

### Índices de varianza

| Indicador | Valor | Interpretación |
|-----------|-------|---------------|
| **SV** (Schedule Variance) = EV − PV | $ | > 0: adelante · < 0: atrasado |
| **CV** (Cost Variance) = EV − AC | $ | > 0: bajo presupuesto · < 0: sobre presupuesto |
| **SPI** (Schedule Performance Index) = EV/PV | | > 1: adelante · < 1: atrasado |
| **CPI** (Cost Performance Index) = EV/AC | | > 1: eficiente · < 1: ineficiente |

### Proyecciones

| Proyección | Valor | Fórmula |
|------------|-------|---------|
| **EAC** (Estimate at Completion) | $ | BAC / CPI |
| **ETC** (Estimate to Complete) | $ | EAC − AC |
| **VAC** (Variance at Completion) | $ | BAC − EAC |
| **TCPI** (To-Complete Performance Index) | | (BAC − EV) / (BAC − AC) |

### Interpretación del periodo

**Estado general:**
- SPI: [valor] → [análisis: ej. "el proyecto está un 15% más lento que lo planificado"]
- CPI: [valor] → [análisis: ej. "estamos gastando $1.15 por cada $1.00 de valor entregado"]
- EAC: $[valor] → [análisis: ej. "al ritmo actual, el costo final será $X vs BAC de $Y"]

**Causas principales de varianza:**
- [Causa 1: ej. "estimaciones optimistas en módulo X — requiere 2x el tiempo estimado"]
- [Causa 2: ej. "riesgo R-005 materializado — 3 días de retraso en integración"]

**Nota de causalidad:** Las varianzas EVM indican síntomas, no causas. Validar las causas con el equipo antes de reportar al sponsor.

---

## Schedule Control

| Campo | Valor |
|-------|-------|
| **Hitos completados este periodo** | [lista] |
| **Hitos atrasados** | [lista con días de retraso] |
| **Float del Critical Path** | [N días] |
| **Actividades en Critical Path con varianza** | [lista] |

**Acciones de compresión implementadas:**

| Acción | Tipo | Actividades afectadas | Costo adicional | Días recuperados |
|--------|------|----------------------|----------------|-----------------|
| | Fast Tracking / Crashing | | $ | |

---

## Change Requests del periodo

| CR ID | Descripción | Solicitante | Impacto en scope | Impacto en schedule | Impacto en cost | Estado CCB | Decisión |
|-------|-------------|------------|-----------------|--------------------|-----------------|-----------|---------| 
| CR-001 | | | | | | Aprobado/Rechazado/En evaluación | |

**CRs que requieren re-baseline:**
- [ ] Re-baseline de schedule — motivo: [CR-NNN afecta el baseline significativamente]
- [ ] Re-baseline de costo — motivo: [CR-NNN aumenta BAC > 10%]

---

## Quality Control — Resultados del periodo

| Deliverable | Técnica QC | Defectos encontrados | Severity | Estado | Acción |
|-------------|-----------|---------------------|---------|--------|--------|
| | Code review / Testing / Inspección | | Critical/Major/Minor | Abierto/Cerrado | |

**Resumen de defectos:**

| Severity | Encontrados | Resueltos | Pendientes |
|----------|------------|-----------|-----------|
| Critical (bloquea) | | | |
| Major (impacta) | | | |
| Minor (mejora) | | | |
| **Total** | | | |

---

## Risk Register — Actualizaciones

| Risk ID | Descripción | Cambio este periodo | Nuevo estado | Acción tomada |
|---------|-------------|--------------------|---------| --------------|
| R-001 | | Materializado / Probabilidad aumentó / Cerrado | Activo/Cerrado | |

**Riesgos nuevos identificados este periodo:**

| Risk ID | Descripción | P | I | Score | Plan de respuesta | Owner |
|---------|-------------|---|---|-------|--------------------|-------|
| | | H/M/L | H/M/L | | | |

---

## Acciones correctivas / preventivas

| Tipo | Descripción | Causa raíz | Impacto esperado | Responsable | Fecha límite | Estado |
|------|-------------|-----------|-----------------|-------------|-------------|--------|
| Correctiva | | | | | | |
| Preventiva | | | | | | |

---

## RAG Status — Resumen ejecutivo

| Dimensión | Estado | Tendencia | Comentario ejecutivo |
|-----------|--------|-----------|---------------------|
| **Scope** | 🟢/🟡/🔴 | ↑→↓ | |
| **Schedule** | 🟢/🟡/🔴 | ↑→↓ | |
| **Cost** | 🟢/🟡/🔴 | ↑→↓ | |
| **Quality** | 🟢/🟡/🔴 | ↑→↓ | |
| **Risks** | 🟢/🟡/🔴 | ↑→↓ | |

**Decisión del periodo:**
- [ ] Continuar plan actual — varianzas dentro de umbrales aceptables
- [ ] Acción correctiva activada — CR generado: [CR-NNN]
- [ ] Escalar al sponsor — varianza crítica que requiere decisión ejecutiva
- [ ] Activar cierre (pm:closing) — todos los deliverables verificados y aceptados
