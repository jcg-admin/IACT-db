# LCA Criteria — Lifecycle Architecture Milestone

> Reference for rup:elaboration. LCA is the gate between Elaboration and Construction.
> Decision: advance to Construction OR iterate Elaboration.

---

## ¿Qué es el LCA?

El **Lifecycle Architecture (LCA)** milestone es la evaluación de que la arquitectura del sistema está suficientemente estabilizada para iniciar la construcción incremental. Es el milestone más importante de RUP — una arquitectura incorrecta en este punto es extremadamente costosa de corregir en Construction.

**Pregunta central del LCA:** *"¿Tenemos evidencia (no solo diseño) de que la arquitectura soporta los requisitos más críticos y riesgosos?"*

---

## Criterios de evaluación LCA

### Criterio 1: Architecture Prototype ejecutable y estable

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Prototype es código ejecutable | Repositorio con código funcional | Solo diagramas o slides |
| Prueba el escenario de mayor riesgo | Test con condiciones realistas de carga | Prueba en condiciones ideales |
| Performance medida vs NFR | Métricas cuantificadas | Performance "parece bien" |
| Integración crítica demostrada | Flujo end-to-end real | Integración mockeada |
| Repetible por cualquier miembro del equipo | Instrucciones de setup documentadas | Solo el arquitecto lo puede ejecutar |

**Criterio mínimo de performance:**

| NFR | Criterio LCA | Acción si no cumple |
|-----|-------------|-------------------|
| Tiempo de respuesta | Dentro del 150% del objetivo | Arquitectura no viable — nueva iteración |
| Throughput | ≥ 70% del objetivo | Investigar bottleneck antes de Construction |
| Availability | Prototipo sin fallos en 2h de test | Revisar mecanismos de failover |

### Criterio 2: ≥ 80% del Use Case Model especificado

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| UC Must Have 100% especificados | Lista de UC Must Have vs especificados | UC críticos sin flujo completo |
| UC Should Have ≥ 60% especificados | Lista parcial con justificación | UC Should Have todos pendientes |
| Flujos alternativos incluidos | ≥ 2 alternativas por UC crítico | Solo happy path especificado |
| Flujos de excepción incluidos | Manejo de errores por UC | Sin flujos de excepción |
| Trazabilidad UC → SAD | Cada UC arquitectonicamente significativo traza al SAD | UC sin impacto arquitectónico identificado |

**Distribución aceptable del 80%:**

| Prioridad UC | % especificado requerido |
|-------------|------------------------|
| Must Have | 100% |
| Should Have | ≥ 60% |
| Could Have | 0% (Construction) |
| Won't Have | N/A |

### Criterio 3: Riesgos técnicos top-5 mitigados

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Identificación explícita del top-5 | Lista ordenada por P×I | Lista sin priorización |
| Cada riesgo tiene evidencia de mitigación | Resultado del prototype / spike / investigación | "Confiamos en que no ocurrirá" |
| Nuevos riesgos descubiertos documentados | Risk List actualizada | Risk List = copia de Inception |
| Riesgos cancelatorios resueltos | Decisión explícita (continuar / cancelar) | Riesgo cancelatorio "pendiente" |

**Estado esperado de riesgos al LCA:**

| Estado | Significado | % de riesgos top-5 |
|--------|-------------|-------------------|
| Cerrado | Evidence-based — prototype o investigación lo descartó | ≥ 60% |
| Reducido | P o I bajó; plan concreto documentado | ≤ 30% |
| Abierto con plan | Plan documentado + owner + fecha | ≤ 10% |
| Abierto sin plan | **Inaceptable para LCA** | 0% |

### Criterio 4: SAD completo

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Architectural Goals con métricas | Quality attributes medibles | "El sistema debe ser rápido y seguro" |
| Constraints documentados | Lista exhaustiva | Constraints omitidos que aparecen en Construction |
| Pattern decisions justificadas | ADR por cada decisión major | "Usamos microservicios" sin justificación |
| Diagrama de subsistemas | Componentes con responsabilidades claras | Solo diagrama sin responsabilidades |
| Risks addressed section | Cada riesgo técnico top-5 traza al SAD | Riesgos sin respuesta arquitectónica |
| SAD review por el equipo | ACK de cada desarrollador en secciones técnicas | Solo el arquitecto revisó |

**Longitud esperada del SAD:**

| Tamaño del proyecto | Páginas esperadas del SAD |
|--------------------|--------------------------|
| Pequeño (< 6 meses) | 5-10 páginas |
| Mediano (6-18 meses) | 10-20 páginas |
| Grande (> 18 meses) | 20-30 páginas |

> SAD > 30 páginas en Elaboration: Architecture Astronaut — sobrediseñado.

### Criterio 5: Plan de Construction aceptado por el sponsor

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Iteraciones definidas | N iteraciones con duración y features | "Construiremos hasta que esté listo" |
| Features/UC por iteración | Asignación específica | Features sin iteración asignada |
| Criterio IOC definido | Funcionalidad mínima para Transition | IOC = "todo terminado" |
| Estimación ±20% | Justificada con Use Case Points o function points | Estimación sin base |
| Sponsor firmó el plan | Sign-off del plan de Construction | Sponsor "está revisando" |

---

## Checklist de concurrencia — ¿quiénes deben aprobar el LCA?

| Rol | Aprueba | Criterios que valida |
|-----|---------|---------------------|
| **Arquitecto / Tech Lead** | Obligatorio | SAD completo, Architecture Prototype, Risk List técnica |
| **Equipo de desarrollo** | Obligatorio | Viabilidad técnica del SAD, Plan de Construction |
| **Project Manager** | Obligatorio | Plan de Construction, estimaciones, recursos |
| **Sponsor** | Obligatorio | Plan de Construction, presupuesto, criterio IOC |
| **QA Lead** | Recomendado | Testabilidad de la arquitectura, criterios de calidad |

---

## Decisiones típicas en el LCA

### Decisión 1: Avanzar a Construction

**Condición:** Todos los criterios evaluados como ✅ o ⚠️ con plan documentado.

### Decisión 2: Nueva iteración de Elaboration

**Causa → Acción:**

| Criterio fallido | Acción recomendada | Duración típica de corrección |
|-----------------|-------------------|------------------------------|
| Architecture Prototype falla | Investigar bottleneck + rediseñar componente problemático | 1-2 semanas |
| Riesgos técnicos abiertos | Spikes adicionales + consultar expertos | 1 semana por riesgo |
| < 80% UC especificados | Sprint de especificación con PM + BA + dev | 1 semana por 10 UC |
| SAD incompleto o rechazado | Review arquitectónico + revisión de decisiones | 3-5 días |
| Plan de Construction rechazado | Re-estimación + ajuste de scope | 3-5 días |

---

## Señales de LCA fallido (post-hoc)

Señales de que Elaboration fue insuficiente, visibles en Construction:

| Señal en Construction | Causa probable en Elaboration |
|---------------------|-------------------------------|
| Arquitectura rediseñada en la 1ª iteración | Architecture Prototype no probó el escenario real |
| Riesgo técnico crítico aparece en Construction | Risk List incompleta o mitigación superficial |
| UC Must Have requieren reescribir subsistemas | Use Cases mal especificados en Elaboration |
| Performance falla en staging | NFR no medidos en el Architecture Prototype |
| Estimaciones de Construction erróneas en > 50% | Plan de Construction basado en supuestos no validados |
