# Redesign Principles — BPA:Design

Los 4 principios de rediseño de proceso: Eliminate, Simplify, Integrate, Automate.

---

## Orden de aplicación (CRÍTICO)

```
1. ELIMINATE  →  2. SIMPLIFY  →  3. INTEGRATE  →  4. AUTOMATE
```

**Por qué este orden importa:**
- Automatizar NVA es el error más costoso en BPA — perpetúa el desperdicio a mayor velocidad
- Integrar antes de simplificar puede crear un proceso consolidado pero aún complejo
- Solo después de eliminar y simplificar, la automatización agrega valor real

> Regla mnemotécnica: "No digitalices la basura — primero bótala."

---

## Principio 1 — ELIMINATE

### Definición
Remover completamente una actividad del proceso porque no agrega valor (NVA) y no existe restricción que la obligue a estar.

### Cuándo aplicar
- Actividad clasificada como NVA en bpa:analyze
- Actividad BVA cuya justificación no se sostiene al cuestionarla
- Actividad que existe por legado histórico sin propósito actual

### Cómo aplicar
1. Identificar la actividad NVA del Activity Value Analysis
2. Preguntar: *"¿Qué pasaría si simplemente no lo hiciéramos?"*
3. Si la respuesta es "nada" o "podemos mitigarlo de otra forma" → eliminar
4. Documentar la razón de eliminación y el mecanismo de mitigación si aplica

### Criterios de verificación antes de eliminar
- ¿La actividad detecta errores? ¿Con qué frecuencia? (si tasa = 0, es candidata a eliminar)
- ¿La actividad tiene un requisito regulatorio o de contrato? (si sí → no es NVA, es BVA)
- ¿Alguien usa el output de esta actividad? (si no hay consumidor del output → eliminar)

### Ejemplos por dominio

| Dominio | Actividad eliminada | Razón |
|---------|--------------------|----|
| Finanzas | Segunda firma de aprobación en gastos < $100 | Tasa de error detectado = 0% en 12 meses; riesgo no justifica el paso |
| RRHH | Formulario de solicitud de vacaciones en papel + formulario digital | Duplicación: el sistema digital es suficiente |
| Operaciones | Reporte diario de stock que nadie lee | El sistema tiene dashboard en tiempo real; el reporte es overhead |
| Ventas | Aprobación de descuento < 5% por gerente | El equipo de ventas puede otorgar descuentos < 5% con tabla de precios predefinida |

### Anti-patrones de Eliminate

| Error | Descripción | Corrección |
|-------|-------------|-----------|
| Eliminar sin verificar el consumidor del output | La actividad parece NVA pero su output lo usa un equipo aguas abajo | Mapear todos los consumidores del output antes de eliminar |
| Eliminar actividades BVA sin validar con compliance | "Creemos que podemos eliminar esa aprobación" sin consultar con legal | Siempre validar eliminaciones con compliance/legal antes de implementar |
| Eliminar sin plan de transición | Actividad eliminada sin comunicar al equipo | Documentar cuándo se elimina y qué hacer si surge el caso de uso |

---

## Principio 2 — SIMPLIFY

### Definición
Reducir la complejidad, el número de pasos, campos, o tiempo de una actividad que debe permanecer en el proceso (BVA o VA necesario pero con overhead).

### Cuándo aplicar
- Actividad BVA obligatoria pero con más pasos de los necesarios
- Actividad VA con demasiada fricción para los ejecutores
- Formulario, reporte, o entregable con más información de la que se consume
- Aprobación en cadena donde se puede consolidar

### Cómo aplicar
1. Identificar el overhead: ¿qué parte de la actividad agrega valor y qué es overhead?
2. Diseñar la versión simplificada: menos campos, menos pasos, menos actores
3. Verificar que la versión simplificada cumple el mismo propósito

### Ejemplos por dominio

| Dominio | As-Is | To-Be simplificado | Reducción |
|---------|-------|-------------------|-----------|
| Compras | Formulario de solicitud con 25 campos | Formulario con 8 campos obligatorios + campos opcionales | 68% menos campos |
| Legal | 4 revisores leen el contrato en secuencia | 1 revisor principal + comentarios paralelos de 2 revisores especializados | 70% menos tiempo de ciclo |
| IT | Proceso de onboarding con 15 tickets separados | 1 ticket único con template que genera sub-tareas automáticamente | 1 punto de entrada |
| Finanzas | Reporte mensual de 40 páginas | Dashboard ejecutivo de 1 página + detalle disponible bajo demanda | Tiempo de preparación -80% |

### Técnicas de simplificación

| Técnica | Descripción | Cuándo usar |
|---------|-------------|-------------|
| **Field reduction** | Eliminar campos no usados de formularios | Formularios con campos que raramente se completan |
| **Approval consolidation** | Reemplazar cadena de aprobaciones por aprobación única con criterios claros | Cuando múltiples aprobadores revisan lo mismo |
| **Template standardization** | Reemplazar documentos ad-hoc por templates con estructura fija | Documentos que se recrean desde cero en cada instancia |
| **Exception-based review** | Revisar solo los casos que superan un umbral, no todos | Cuando la mayoría de casos son rutinarios |
| **Batch → real-time** | Procesar solicitudes a medida que llegan en lugar de en lotes | Cuando el batch genera colas de espera |

---

## Principio 3 — INTEGRATE

### Definición
Consolidar actividades fragmentadas, múltiples actores, o sistemas separados en un flujo más cohesivo con menos handoffs.

### Cuándo aplicar
- Proceso con muchos handoffs entre departamentos que generan demoras y pérdida de contexto
- Información re-ingresada manualmente entre sistemas
- Múltiples puntos de entrada para el mismo tipo de solicitud
- Varias personas hacen partes de una tarea que podría hacer una sola

### Tipos de integración

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| **Integración de actores** | Consolidar roles fragmentados en un responsable end-to-end | Case manager único en lugar de 4 departamentos handoff |
| **Integración de sistemas** | Conectar sistemas desconectados para eliminar re-ingreso de datos | API entre CRM y sistema de facturación |
| **Integración de canales** | Unificar múltiples puntos de entrada en uno solo | Portal único para todos los tipos de solicitud |
| **Integración de fases** | Hacer en paralelo lo que se hacía en secuencia | Verificación de crédito y verificación de stock simultáneas |

### Ejemplos por dominio

| Dominio | As-Is fragmentado | To-Be integrado | Beneficio |
|---------|-----------------|----------------|-----------|
| Atención al cliente | Cliente contacta ventas, luego soporte, luego facturación | Agente único con acceso a todos los sistemas | Resolución en 1 contacto |
| Onboarding | IT, RRHH y Facilities actúan por separado sin coordinación | Proceso coordinado con un responsable y sistema unificado | -50% tiempo de onboarding |
| Procurement | Solicitud → aprobación → cotización → orden: 4 sistemas separados | Sistema integrado P2P con flujo único | Eliminación del re-ingreso manual |

---

## Principio 4 — AUTOMATE

### Definición
Configurar un sistema para ejecutar automáticamente una actividad que cumple reglas claras y predecibles, sin necesitar juicio humano en cada instancia.

### Cuándo aplicar
- Actividad rutinaria con reglas claras (if/then sin ambigüedad)
- Alto volumen de instancias (el ROI de la automatización justifica la inversión)
- La actividad ya fue Eliminada de todo NVA y Simplificada al mínimo necesario
- La actividad es repetitiva, propensa a error humano, o requiere velocidad de respuesta

### Cuándo NO automatizar

| Situación | Por qué no automatizar |
|-----------|----------------------|
| Actividad con alta variabilidad y excepciones frecuentes | La automatización se rompe; el costo de mantenimiento excede el beneficio |
| Actividad que requiere juicio humano o empatía | Los sistemas no reemplazan la evaluación contextual |
| Volumen muy bajo (< 5 instancias/mes) | El ROI es negativo — costo de desarrollo > costo humano |
| Actividad NVA no eliminada | Automatizar desperdicio es desperdicio acelerado |
| Proceso en rediseño continuo | Automatizar lo que cambia frecuentemente genera deuda técnica |

### Tipos de automatización en procesos de negocio

| Tipo | Descripción | Herramientas típicas |
|------|-------------|---------------------|
| **Notificaciones automáticas** | Avisar al siguiente actor cuando una tarea está lista | Email triggers, Slack bots, sistemas BPM |
| **Routing automático** | Asignar solicitudes al actor correcto según reglas | Workflows en JIRA, ServiceNow, Salesforce |
| **Validaciones automáticas** | Verificar completitud y formato en el punto de entrada | Formularios con validación, scripts de QA |
| **Generación de documentos** | Crear documentos desde templates con datos existentes | Word merge, PDFs programáticos |
| **Integración de datos** | Sincronizar datos entre sistemas sin re-ingreso manual | APIs, ETL, RPA (Robotic Process Automation) |
| **Escaladas automáticas** | Notificar a supervisores cuando un paso supera un SLA | Timer events en sistemas BPM |

### Ejemplos por dominio

| Dominio | Actividad manual As-Is | Automatización To-Be |
|---------|----------------------|---------------------|
| Procurement | Email manual al proveedor para cotizar | Solicitud automática enviada al proveedor al crear la orden |
| RRHH | Recordatorio manual de revisión de desempeño | Notificación automática 30 días antes de la fecha de revisión |
| Finanzas | Re-ingreso manual de datos de facturas en el sistema | OCR + integración API para captura automática de facturas |
| Ventas | Asignación manual de leads al equipo de ventas | Routing automático por territorio y producto |

---

## Tabla de selección de principio

| Situación | Principio recomendado |
|-----------|----------------------|
| Actividad NVA sin restricción que la obligue | ELIMINATE |
| Actividad NVA con restricción parcial | SIMPLIFY (mantener lo mínimo requerido) |
| Actividad BVA con más pasos de los necesarios | SIMPLIFY |
| Múltiples actores hacen partes de lo mismo | INTEGRATE |
| Re-ingreso de datos entre sistemas | INTEGRATE + AUTOMATE |
| Actividad rutinaria de alto volumen con reglas claras | AUTOMATE |
| Actividad VA que el cliente valora pero es lenta | AUTOMATE o SIMPLIFY |
| Actividad con alta variabilidad y juicio | Preservar como Unchanged |
