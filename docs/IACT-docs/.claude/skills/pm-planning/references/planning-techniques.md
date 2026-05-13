# pm-planning — Técnicas de planificación (referencia detallada)

> Cargar cuando se necesitan detalles de WBS, CPM/PERT, estimación de costos, risk, RACI.

## WBS — Work Breakdown Structure

**Construir el WBS:**

| Nivel | Descripción | Ejemplo |
|-------|-------------|---------|
| **Nivel 1** | Proyecto completo | "Sistema de Gestión de Pedidos" |
| **Nivel 2** | Fases o componentes principales | "1. Módulo de clientes · 2. Módulo de pedidos · 3. Módulo de pagos" |
| **Nivel 3** | Deliverables de cada componente | "1.1 Registro de clientes · 1.2 Gestión de perfiles" |
| **Nivel N** | Work Packages — unidad más pequeña planificable | "1.1.1 API de registro · 1.1.2 Validación de datos" |

**Regla de los 8/80:** Un Work Package no debería tomar menos de 8 horas ni más de 80 horas. Si es más, descomponerlo.

**WBS Dictionary:** Para cada Work Package definir:
- Descripción del trabajo
- Criterio de aceptación
- Responsable (de la RACI)
- Estimación de esfuerzo
- Dependencias

## Schedule Management — CPM y PERT

**Critical Path Method (CPM):**

| Concepto | Descripción |
|----------|-------------|
| **Forward Pass** | Calcular Early Start (ES) y Early Finish (EF) para cada actividad |
| **Backward Pass** | Calcular Late Start (LS) y Late Finish (LF) para cada actividad |
| **Float (Slack)** | Float = LS − ES = LF − EF. Actividades con Float = 0 están en el Critical Path |
| **Critical Path** | La secuencia de actividades con el menor float total — determina la duración mínima del proyecto |

**PERT (Program Evaluation and Review Technique):**

| Variable | Fórmula | Descripción |
|----------|---------|-------------|
| **Optimistic (O)** | — | Mejor caso posible |
| **Most Likely (M)** | — | Estimación más probable |
| **Pessimistic (P)** | — | Peor caso posible |
| **PERT Estimate** | (O + 4M + P) / 6 | Estimación ponderada |
| **Std Dev** | (P − O) / 6 | Incertidumbre de la estimación |

> **Cuándo usar PERT:** Para actividades con alta incertidumbre (nueva tecnología, proveedores no conocidos, requisitos ambiguos). Para actividades bien conocidas, la estimación directa es suficiente.

**Técnicas de compresión del cronograma:**

| Técnica | Descripción | Costo |
|---------|-------------|-------|
| **Fast Tracking** | Actividades en serie → en paralelo | Mayor riesgo de retrabajo |
| **Crashing** | Agregar recursos al Critical Path | Mayor costo |
| **Reducir scope** | Mover deliverables de Must Have a Should Have | Requiere aprobación del sponsor |

## Cost Management — Estimación y Cost Baseline

**Técnicas de estimación de costos:**

| Técnica | Precisión | Cuándo usar |
|---------|-----------|-------------|
| **Analogous (top-down)** | ±50% | Inicio del proyecto — usa datos de proyectos similares |
| **Parametric** | ±20-30% | Cuando hay relaciones cuantificables (ej: $/línea de código, $/función) |
| **Bottom-up** | ±10% | Cuando el WBS es detallado — estimar cada Work Package |
| **Three-point (PERT)** | ±10-15% | Work Packages con incertidumbre alta |

**Cost Baseline = Suma de los costos de todos los Work Packages + reservas de contingencia por riesgo**

> Las reservas de gerencia (management reserves) están por encima del Cost Baseline y no son parte de él.

## Risk Management — Risk Register completo

**Identify Risks → Qualitative Analysis → Quantitative Analysis → Plan Responses:**

| Campo | Descripción |
|-------|-------------|
| **Risk ID** | R-001, R-002, ... |
| **Descripción** | Causa → Evento → Efecto |
| **Categoría** | Técnico / Externo / Organizacional / PM |
| **Probabilidad** | Alta (> 70%) / Media (30-70%) / Baja (< 30%) |
| **Impacto** | Alto / Medio / Bajo — evaluado en scope, schedule, cost, quality |
| **P × I** | Probability × Impact = Risk Score |
| **Estrategia** | Avoid / Transfer / Mitigate / Accept (amenazas) / Exploit / Share / Enhance / Accept (oportunidades) |
| **Plan de respuesta** | Acción específica si el riesgo ocurre |
| **Trigger** | Señal de que el riesgo está a punto de materializarse |
| **Responsable** | Quién ejecuta el plan de respuesta |

**Probability × Impact Matrix:**

| | Bajo impacto | Medio impacto | Alto impacto |
|--|-------------|--------------|-------------|
| **Alta probabilidad** | Media | Alta | Crítica |
| **Media probabilidad** | Baja | Media | Alta |
| **Baja probabilidad** | Baja | Baja | Media |

## Communications Management Plan

| Información | Audiencia | Frecuencia | Formato | Responsable |
|------------|-----------|-----------|---------|-------------|
| Status Report | Sponsor + equipo | Semanal | Documento + email | PM |
| Executive Dashboard | Steering Committee | Mensual | Dashboard + RAG | PM |
| Team Standup | Equipo | Diario | Meeting | Scrum Master / PM |
| Change Requests | CCB | Ad hoc | Documento formal | PM |
| Risk Updates | Sponsor | Quincenal | Sección en Status Report | PM |

## RACI Matrix

| Letra | Significado | Cuántas personas por actividad |
|-------|------------|-------------------------------|
| **R** | Responsible — hace el trabajo | 1 o más (pero idealmente 1) |
| **A** | Accountable — rinde cuentas por el resultado | Exactamente 1 |
| **C** | Consulted — da input antes de la decisión | 0 o más |
| **I** | Informed — se notifica después de la decisión | 0 o más |

> **Regla:** Cada actividad debe tener exactamente 1 A. Múltiples R en la misma actividad es aceptable. Sin R o sin A = accountability gap.
