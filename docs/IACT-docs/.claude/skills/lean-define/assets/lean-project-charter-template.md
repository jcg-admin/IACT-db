# lean-project-charter — Template de artefacto

```yml
created_at: [timestamp]
project: [nombre del proyecto]
work_package: [wp-id]
phase: lean:define
author: [nombre]
status: Borrador
```

---

## VOC — Voice of Customer: definición de Valor

| Técnica usada | N° de fuentes / muestra | Hallazgos clave | Definición de Valor derivada |
|---------------|------------------------|-----------------|------------------------------|
| [Entrevistas / Gemba / Quejas / Encuestas] | [n] | [qué dijeron los clientes] | [qué es valor para ellos] |

> El VOC en Lean define qué es valor para el cliente. Todo lo que no es valor es desperdicio potencial. Sin VOC real, los desperdicios identificados son suposiciones del equipo.

---

## TIMWOOD — Desperdicios identificados en el proceso

| ID | Waste | ¿Presente? | Evidencia observada | Impacto estimado |
|----|-------|-----------|--------------------|-----------------| 
| T | Transportation (Transporte innecesario) | Sí / No / Probable | [evidencia] | Alto / Medio / Bajo |
| I | Inventory (Inventario excesivo / WIP) | Sí / No / Probable | [evidencia] | Alto / Medio / Bajo |
| M | Motion (Movimiento innecesario de personas) | Sí / No / Probable | [evidencia] | Alto / Medio / Bajo |
| W | Waiting (Espera entre pasos) | Sí / No / Probable | [evidencia] | Alto / Medio / Bajo |
| O | Overproduction (Sobreproducción) | Sí / No / Probable | [evidencia] | Alto / Medio / Bajo |
| O | Overprocessing (Sobreprocesamiento) | Sí / No / Probable | [evidencia] | Alto / Medio / Bajo |
| D | Defects (Defectos / Reproceso) | Sí / No / Probable | [evidencia] | Alto / Medio / Bajo |
| T* | Talent (Skills no aprovechados) | Sí / No / Probable | [evidencia] | Alto / Medio / Bajo |

**Desperdicios dominantes (top 2-3):** [Listar los de mayor impacto — estos guiarán lean:measure y lean:analyze]

---

## Problem Statement Lean

> Criterio: desperdicio observable + magnitud cuantitativa (tiempo, unidades, %) + período + impacto en el cliente o negocio. Sin causas asumidas ni soluciones propuestas.

**Problem Statement:**
[Texto — ej: "El proceso de aprobación de facturas tiene un lead time promedio de 8 días (datos Q1 2026), con el 73% del tiempo en esperas entre pasos — vs objetivo de 3 días, generando retrasos en pagos a proveedores y $X en penalidades."]

---

## Goal Statement Lean

> Formato: "Reducir [waste/métrica] en [proceso] de [baseline] a [meta] para [fecha], manteniendo [restricciones]."

**Goal Statement:**
[Texto — ej: "Reducir el lead time del proceso de aprobación de facturas de 8 días a 3 días para 2026-07-01, sin incrementar errores de aprobación por encima del 1%."]

---

## SIPOC — Mapa de alto nivel con marcado VA/NVA

| S — Suppliers | I — Inputs | P — Process (5-7 pasos) | VA/NVA | O — Outputs | C — Customers |
|---------------|-----------|------------------------|--------|-------------|--------------|
| [proveedor 1] | [input 1] | 1. [Paso 1] | VA / NVA-N / NVA-P | [output 1] | [cliente 1] |
| [proveedor 2] | [input 2] | 2. [Paso 2] | VA / NVA-N / NVA-P | [output 2] | [cliente 2] |
| | | 3. [Paso 3] | | | |
| | | 4. [Paso 4] | | | |
| | | 5. [Paso 5] | | | |

> VA = Value-Added · NVA-N = No Value-Added Necesario · NVA-P = No Value-Added Puro (eliminar)  
> Los handoffs entre áreas son candidatos a waste de Transportation.

---

## Business Case Lean

| Elemento | Valor |
|----------|-------|
| Waste actual cuantificado | [Lead time extra / horas de reproceso / costo de WIP excesivo — con datos] |
| Costo anual estimado del waste | [$/año o h/año] |
| Beneficio esperado si se alcanza el Goal | [$/año o h/año liberadas] |
| Inversión estimada (Kaizen events) | [días-equipo × tarifa] |
| ROI estimado | [beneficio / inversión] |
| Riesgo de no actuar | [qué pasa con la competitividad/costo si el waste continúa] |

---

## Scope del proyecto Lean

| In Scope | Out of Scope |
|----------|-------------|
| [Proceso específico + fronteras: desde [inicio] hasta [fin]] | [Procesos upstream / downstream no incluidos — ser explícito] |

> El scope debe ser un flujo de valor delimitado que pueda mapearse en un VSM manejable. Un scope demasiado amplio → VSM inmanejable → Kaizen event sin foco.

---

## RACI del proyecto Lean

| Rol | Nombre | R | A | C | I |
|-----|--------|---|---|---|---|
| Sponsor | [nombre] | | ✅ Aprueba Charter + Kaizen events | | ✅ Informes de avance |
| Lean Champion / Green Belt | [nombre] | ✅ Lidera proyecto | | | |
| Process Owner | [nombre] | ✅ Autoriza cambios en proceso | | ✅ Revisa mejoras | |
| Kaizen Team | [nombres] | ✅ Participa en eventos | | | |
| Clientes / Usuarios finales | [representante] | | | ✅ Validan definición de valor | ✅ Resultados |

---

## Timeline Lean estimado

| Fase | Inicio estimado | Entrega / tollgate |
|------|----------------|-------------------|
| Define | [YYYY-MM-DD] | Charter aprobado: [fecha] |
| Measure (VSM As-Is) | [YYYY-MM-DD] | VSM + métricas: [fecha] |
| Analyze (causa raíz) | [YYYY-MM-DD] | Causas raíz validadas: [fecha] |
| Improve (Kaizen events) | [YYYY-MM-DD] | VSM To-Be implementado: [fecha] |
| Control (sostenibilidad) | [YYYY-MM-DD] | Plan sostenibilidad activo 4 semanas: [fecha] |

---

## Lean Project Charter — Aprobación

| Campo | Valor |
|-------|-------|
| **Sponsor** | [Nombre] |
| **Fecha de aprobación** | [YYYY-MM-DD] |
| **Condiciones de aprobación** | [Ninguna / Sujeta a: ...] |
| **Recursos comprometidos** | [Días-equipo para Kaizen events / herramientas / formación] |
| **Próxima revisión del Charter** | [Fecha — si el scope cambia significativamente] |
