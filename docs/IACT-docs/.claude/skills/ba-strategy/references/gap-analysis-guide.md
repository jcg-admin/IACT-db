# Gap Analysis Guide — Análisis de Brechas para Strategy Analysis

## Qué es y cuándo usar el gap analysis

El gap analysis identifica la brecha entre el estado actual (cómo funciona el negocio hoy) y el estado futuro (cómo debería funcionar). Sin esta brecha documentada con métricas, los requisitos no tienen justificación de negocio.

**Cuándo es obligatorio:** Siempre que se ejecuta `ba:strategy`. No hay Strategy Analysis sin gap analysis.
**Cuándo es opcional:** Si el estado futuro ya está definido y acordado, el gap analysis puede ser simplificado.

---

## Current State Analysis — metodología

### Dimensiones del estado actual

| Dimensión | Qué capturar | Fuente de datos |
|-----------|-------------|----------------|
| **Procesos** | Flujo de pasos, responsables, handoffs, tiempos | Observación, entrevistas, documentos de proceso |
| **Personas** | Roles que ejecutan, skills disponibles, gaps de capacidad | Org chart, entrevistas, evaluaciones de desempeño |
| **Tecnología** | Sistemas existentes, integraciones, limitaciones técnicas | IT, arquitectura actual, inventario de sistemas |
| **Datos** | Qué datos se capturan, calidad, disponibilidad | Bases de datos, reportes, entrevistas con usuarios |
| **Métricas** | KPIs actuales, cómo se miden, tendencias | Reportes de negocio, sistemas de BI |
| **Problemas** | Pain points recurrentes, frecuencia, magnitud | Issue logs, incidentes, entrevistas |
| **Restricciones** | Regulatorio, técnico, de recursos, contractual | Legal, IT, finanzas |

### Cómo cuantificar el estado actual

**Métricas de tiempo:**
- Tiempo de ciclo = tiempo total desde inicio hasta fin del proceso
- Lead time = tiempo total incluyendo esperas
- Valor añadido = tiempo donde se hace trabajo real vs tiempo total

**Métricas de calidad:**
- Tasa de error = # errores / # transacciones totales × 100
- Tasa de retrabajo = # items que requirieron corrección / total
- First-time-right = % completados correctamente en el primer intento

**Métricas de costo:**
- Costo por transacción = costo total del proceso / # transacciones
- Costo de error = costo de detectar + costo de corregir + costo de oportunidad

**Métricas de satisfacción:**
- NPS (Net Promoter Score) = % promotores (9-10) - % detractores (1-6)
- CSAT = # satisfechos / # encuestados × 100
- CES (Customer Effort Score) = esfuerzo percibido (1-7)

---

## Future State Definition — metodología

### Business Need — formato preciso

El Business Need articula el problema con suficiente precisión para justificar la inversión:

| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| **Problema** | Qué no funciona — sin proponer soluciones | "El proceso de aprobación de créditos es manual y lento" |
| **Impacto** | Consecuencia cuantificada del problema | "30% de solicitantes abandona; pérdida estimada $500K/año" |
| **Stakeholders** | Quiénes sufren el problema | "Clientes solicitantes, equipo de créditos, ventas" |
| **Métrica del problema** | Cómo se mide hoy | "Tiempo promedio de aprobación: 5.2 días; tasa de abandono: 31%" |

**Error frecuente:** "El negocio necesita un sistema CRM" — esto es una solución, no un Business Need. El Business Need correcto sería: "El equipo de ventas no tiene visibilidad del historial del cliente en tiempo real, lo que resulta en propuestas duplicadas y pérdida de oportunidades (15% de cierre vs 24% benchmark sectorial)".

### Estructura del estado futuro

El estado futuro describe capacidades, no tecnologías:

| Elemento | Capacidad (correcto) | Tecnología (incorrecto) |
|----------|---------------------|------------------------|
| Notificaciones | "Los usuarios reciben notificaciones automáticas de estado en < 5 minutos" | "Se implementará Firebase Push Notifications" |
| Reportes | "Los gerentes tienen visibilidad del KPI en tiempo real" | "Se construirá un dashboard en Power BI" |
| Integración | "El sistema accede al buró de crédito automáticamente" | "Se integrará con API REST del Buró" |

---

## Gap Analysis — categorización y priorización

### Categorías de gaps (BABOK)

| Categoría | Descripción | Ejemplo |
|-----------|-------------|---------|
| **Capability gap** | Capacidad que no existe en el estado actual | "No hay sistema de notificaciones push" |
| **Performance gap** | Capacidad existe pero no al nivel requerido | "Las notificaciones existen pero tardan 2 días" |
| **Knowledge gap** | Información o habilidades faltantes | "El equipo no sabe cómo usar el sistema actual" |
| **Process gap** | Proceso que debe crearse o rediseñarse | "No hay proceso formal de escalación de créditos" |

### Matriz de priorización de gaps

| Gap | Impacto en el negocio | Complejidad de resolver | Prioridad |
|-----|:--------------------:|:----------------------:|:---------:|
| Capability gap crítico | Alta | Cualquiera | **Alta** |
| Performance gap con SLA comprometido | Alta | Baja | **Alta** |
| Process gap que causa errores frecuentes | Media | Baja | **Media** |
| Knowledge gap resolvible con training | Baja | Baja | **Baja** |
| Capability gap nice-to-have | Baja | Alta | **Baja** |

---

## SWOT aplicado al estado actual de negocio

### Propósito del SWOT en Strategy Analysis

El SWOT del estado actual **no** es el SWOT del proyecto o de la empresa en general. Es el SWOT del dominio específico que se está analizando:

- **Fortalezas:** Qué funciona bien que no debe romperse
- **Debilidades:** Los gaps y problemas documentados
- **Oportunidades:** Factores externos que la solución puede aprovechar
- **Amenazas:** Factores externos que pueden complicar o invalidar la solución

### Plantilla SWOT

| | **Positivo** | **Negativo** |
|--|-------------|-------------|
| **Interno** | **Fortalezas** (qué funciona bien hoy) | **Debilidades** (gaps y problemas documentados) |
| **Externo** | **Oportunidades** (factores externos favorables) | **Amenazas** (factores externos de riesgo) |

### Uso del SWOT en el análisis

- Las **Fortalezas** se convierten en restricciones del estado futuro (preservar lo que funciona)
- Las **Debilidades** alimentan directamente el gap analysis
- Las **Oportunidades** informan las opciones de solución recomendadas
- Las **Amenazas** se convierten en riesgos del cambio

---

## Opciones de solución — evaluación comparativa

### Dimensiones de evaluación

| Dimensión | Descripción | Cómo medir |
|-----------|-------------|-----------|
| **Cobertura de gaps** | % de gaps que resuelve | # gaps resueltos / # gaps totales |
| **Costo de implementación** | Estimación ROM | Bajo ($) / Medio ($$) / Alto ($$$) |
| **Tiempo de implementación** | Estimación de duración | Semanas / Meses |
| **Riesgo técnico** | Complejidad de implementación | Bajo / Medio / Alto |
| **Riesgo de adopción** | Probabilidad de resistencia al cambio | Bajo / Medio / Alto |
| **Beneficio recurrente** | Valor que entrega después de implementado | $ / año o % mejora |
| **ROI estimado** | Retorno sobre la inversión | (Beneficio - Costo) / Costo |

### Señales de análisis de opciones incompleto

| Señal | Problema | Corrección |
|-------|---------|-----------|
| Solo una opción presentada | No hubo análisis real de alternativas | Evaluar mínimo 2 opciones + status quo |
| Opción recomendada sin justificación | Decisión basada en preferencia, no en análisis | Justificar con métricas del gap analysis |
| Status quo no incluido | Se omite la opción de no hacer nada | Incluir siempre — es una opción válida |
| ROI sin baseline de costo del problema | No se puede calcular el beneficio real | Cuantificar el impacto del problema primero |
