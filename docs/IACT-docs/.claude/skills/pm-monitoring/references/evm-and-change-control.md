# pm-monitoring — EVM y Change Control (referencia detallada)

> Cargar cuando se necesitan las fórmulas EVM completas o el proceso de Change Control.

## Earned Value Management (EVM) — Variables y métricas

EVM integra scope, schedule y cost en una sola visión de desempeño.

### Variables fundamentales

| Variable | Nombre | Definición | Fórmula |
|----------|--------|-----------|---------|
| **PV** | Planned Value | Valor del trabajo planificado a la fecha de corte | Costo presupuestado del trabajo planificado |
| **EV** | Earned Value | Valor del trabajo realmente completado | % completado × Budget at Completion (BAC) |
| **AC** | Actual Cost | Costo real del trabajo completado a la fecha | Dato del sistema de costos |
| **BAC** | Budget at Completion | Presupuesto total del proyecto | Costo baseline total |

### Métricas de varianza (negativo = problema)

| Métrica | Fórmula | Interpretación | Umbral de alerta |
|---------|---------|---------------|-----------------|
| **SV** | EV − PV | Varianza de cronograma en $ | SV < −10% del PV |
| **CV** | EV − AC | Varianza de costo en $ | CV < −10% del EV |
| **SPI** | EV / PV | Eficiencia del cronograma | SPI < 0.85 |
| **CPI** | EV / AC | Eficiencia del costo | CPI < 0.85 |

> **Regla de interpretación:** SPI/CPI = 1.0 es perfecto. > 1.0 es ahead of schedule / under budget. < 1.0 es behind schedule / over budget.

### Métricas de proyección

| Métrica | Fórmula | Significado |
|---------|---------|------------|
| **EAC** (CPI actual continúa) | BAC / CPI | Estimación más probable del costo total |
| **EAC** (nueva estimación) | AC + ETC (bottom-up) | Cuando el CPI histórico no es representativo |
| **ETC** | EAC − AC | Cuánto más costará completar el proyecto |
| **VAC** | BAC − EAC | Varianza de costo al final del proyecto |
| **TCPI** (basado en BAC) | (BAC − EV) / (BAC − AC) | Eficiencia necesaria para terminar dentro del presupuesto |
| **TCPI** (basado en EAC) | (BAC − EV) / (EAC − AC) | Eficiencia necesaria para terminar dentro del EAC |

> **TCPI > 1.10:** el presupuesto original (BAC) es prácticamente inalcanzable — reportar al sponsor y ajustar EAC.

> **ADVERTENCIA sobre causalidad:** EVM detecta correlaciones entre work performance y cost/schedule. Una SPI baja puede tener muchas causas. EVM identifica QUÉ está pasando — no explica POR QUÉ. El análisis de causas requiere investigación adicional.

## Perform Integrated Change Control — Proceso CCB

Todo cambio al scope, schedule o cost baseline debe pasar por el Change Control Board (CCB):

| Paso | Descripción | Responsable |
|------|-------------|-------------|
| **Identificar cambio** | Cualquier miembro del equipo puede identificar una solicitud | Equipo / stakeholders |
| **Crear Change Request** | Documentar el cambio propuesto con impacto en scope/schedule/cost/quality | PM |
| **Evaluar impacto** | Analizar el impacto en todas las áreas del proyecto | PM + equipo técnico |
| **Presentar al CCB** | Presentar el Change Request al Change Control Board para decisión | PM |
| **Decisión CCB** | Approve / Reject / Defer | CCB |
| **Implementar si aprobado** | Actualizar el Project Management Plan y los baselines afectados | PM + equipo |
| **Comunicar decisión** | Notificar a todos los stakeholders afectados | PM |

**Change Request template:**

| Campo | Descripción |
|-------|-------------|
| **CR ID** | CR-001, CR-002, ... |
| **Solicitante** | Quién solicita el cambio |
| **Descripción** | Qué cambio se solicita |
| **Justificación** | Por qué se necesita el cambio |
| **Impacto en Scope** | Qué se agrega, modifica o elimina del scope |
| **Impacto en Schedule** | Días adicionales o reducción de tiempo |
| **Impacto en Cost** | Costo adicional o ahorro |
| **Impacto en Calidad** | Efecto sobre los criterios de calidad |
| **Riesgos** | Nuevos riesgos introducidos por el cambio |
| **Recomendación del PM** | Approve / Reject con justificación |
| **Decisión del CCB** | Aprobado / Rechazado / Diferido + fecha |
