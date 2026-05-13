# dmaic-project-charter — Template de artefacto

```yml
created_at: [timestamp]
project: [nombre del proyecto]
work_package: [wp-id]
phase: dmaic:define
author: [nombre]
status: Borrador
```

---

## VOC — Voice of Customer recopilado

| Técnica usada | N° de fuentes / muestra | Hallazgos clave |
|---------------|------------------------|-----------------|
| [Entrevistas / Encuestas / Quejas / Gemba / Focus group] | [n] | [qué dijeron los clientes] |

> Sin VOC real documentado, los CTQs son hipótesis del equipo — registrar explícitamente si aplica.

*Ver catálogo de 6 técnicas VOC y conversión VOC→CTQ: [voc-techniques.md](./references/voc-techniques.md)*

---

## VOB — Voice of Business

| Dimensión | Dato | Fuente |
|-----------|------|--------|
| Impacto financiero | [$/período] | [fuente] |
| Métrica interna fuera de objetivo | [métrica = valor vs objetivo] | [sistema/reporte] |
| Regulatorio / SLA | [qué cumplimiento está en riesgo] | [contrato/normativa] |
| Estratégico | [qué objetivo del plan anual se ve afectado] | [plan anual] |

---

## Problem Statement

> Criterio: síntoma observable + magnitud numérica + período de tiempo + impacto en negocio. Sin causas asumidas.

**Problem Statement:**
[Texto del problem statement — ej: "El 18% de los pedidos se entrega fuera del plazo prometido (datos ene-mar 2026), generando $45K en créditos mensuales al negocio."]

---

## CTQs — Critical to Quality

| CTQ | Unidad de medida | Especificación / objetivo | Fuente VOC |
|-----|-----------------|--------------------------|------------|
| [CTQ 1] | [métrica] | [umbral LSL/USL o meta] | [técnica VOC] |
| [CTQ 2] | [métrica] | [umbral] | [técnica VOC] |

---

## SIPOC

| S — Suppliers | I — Inputs | P — Process (5-7 pasos) | O — Outputs | C — Customers |
|---------------|-----------|------------------------|-------------|--------------|
| [proveedor 1] | [input 1] | 1. [Paso 1] | [output 1] | [cliente 1] |
| [proveedor 2] | [input 2] | 2. [Paso 2] | [output 2] | [cliente 2] |
| | | 3. [Paso 3] | | |
| | | 4. [Paso 4] | | |
| | | 5. [Paso 5] | | |

*Ver guía paso a paso para construir SIPOC y errores comunes: [sipoc-guide.md](./references/sipoc-guide.md)*

---

## Goal Statement

> Formato: "Reducir [CTQ] de [baseline] a [meta] para [fecha], manteniendo [restricciones]."

**Goal Statement:**
[Texto — ej: "Reducir el % de pedidos fuera de plazo de 18% a menos de 5% para 2026-07-01, sin incrementar el costo de logística por unidad."]

---

## Business Case

| Elemento | Valor |
|----------|-------|
| Costo actual del problema | [$/período] |
| Beneficio esperado si se alcanza el Goal | [$/período] |
| Inversión estimada | [$ + tiempo del equipo] |
| ROI estimado | [beneficio / inversión] |
| Riesgo de no actuar | [qué pasa si el problema continúa] |

---

## Scope

| In Scope | Out of Scope |
|----------|-------------|
| [Procesos, sistemas, áreas incluidos] | [Qué no se va a tocar — ser explícito] |

---

## RACI del proyecto

| Rol | Nombre | R | A | C | I |
|-----|--------|---|---|---|---|
| Sponsor | [nombre] | | ✅ Aprueba Charter | | ✅ Informes de avance |
| Black Belt / Green Belt | [nombre] | ✅ Lidera | | | |
| Process Owner | [nombre] | ✅ Ejecuta mejoras | | ✅ Revisa soluciones | |
| Equipo técnico | [nombres] | ✅ Implementa | | | |
| Clientes afectados | [representante] | | | ✅ Validan CTQs | ✅ Resultados |

---

## Timeline DMAIC estimado

| Fase | Inicio estimado | Entrega / tollgate |
|------|----------------|-------------------|
| Define | [YYYY-MM-DD] | Charter aprobado: [fecha] |
| Measure | [YYYY-MM-DD] | Baseline + MSA: [fecha] |
| Analyze | [YYYY-MM-DD] | Causas raíz validadas: [fecha] |
| Improve | [YYYY-MM-DD] | Piloto validado: [fecha] |
| Control | [YYYY-MM-DD] | Control Plan activo: [fecha] |

---

## Project Charter — Aprobación

| Campo | Valor |
|-------|-------|
| **Sponsor** | [Nombre] |
| **Fecha de aprobación** | [YYYY-MM-DD] |
| **Condiciones de aprobación** | [Ninguna / Sujeta a: ...] |
| **Próxima revisión de Charter** | [Fecha — si el scope cambia significativamente] |
