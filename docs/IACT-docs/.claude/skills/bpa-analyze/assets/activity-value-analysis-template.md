# Activity Value Analysis — Template

```yml
created_at: [timestamp]
project: [nombre del proyecto]
work_package: [wp-id]
phase: bpa:analyze
author: [nombre]
status: Borrador
```

---

## Proceso analizado

| Campo | Valor |
|-------|-------|
| **Proceso** | [nombre del proceso] |
| **Versión del mapa As-Is** | [1.0] |
| **Tiempo de ciclo total As-Is** | [X días / X horas] |
| **Analista** | [nombre] |
| **Fecha del análisis** | [YYYY-MM-DD] |

---

## Activity Value Analysis

| # | Activity | Role | Time | VA/BVA/NVA | Issue Identified | Recommendation |
|---|----------|------|------|-----------|-----------------|---------------|
| 1 | [Nombre actividad] | [Actor] | [X min/h] | VA | — | Preservar |
| 2 | [Nombre actividad] | [Actor] | [X min/h] | BVA | [por qué existe; es realmente obligatorio?] | Simplificar / Preservar |
| 3 | [Nombre actividad] | [Actor] | [X min/h] | NVA | [tipo de desperdicio: espera / retrabajo / sobreprocessing / etc.] | Eliminar / Automatizar |
| 4 | [Nombre actividad] | [Actor] | [X min/h] | NVA | [causa raíz del desperdicio] | Eliminar |
| 5 | [Nombre actividad] | [Actor] | [X min/h] | VA | — | Preservar |

*Tipos NVA: Espera · Retrabajo · Transporte innecesario · Sobreprocessing · Inventario · Movimiento · Defectos*
*Ver clasificación completa: [value-classification.md](../references/value-classification.md)*

---

## Resumen cuantitativo VA/BVA/NVA

| Categoría | N° actividades | Tiempo total | % del tiempo de ciclo |
|-----------|---------------|-------------|----------------------|
| **VA** | [N] | [X h] | [%] |
| **BVA** | [N] | [X h] | [%] |
| **NVA** | [N] | [X h] | [%] |
| **Total** | [N] | [X h] | 100% |

**Potencial de mejora estimado:** [X%] del tiempo de ciclo (NVA + BVA simplificable)

---

## Cuellos de botella identificados

| Actividad | Tiempo tarea | Tiempo espera | Ratio | Tipo de cuello de botella |
|-----------|-------------|--------------|-------|--------------------------|
| [Actividad X] | [X h] | [X h] | [ratio] | Espera / Capacidad / Calidad |

### 5 Whys — cuello de botella principal

**Cuello de botella:** [descripción]

| Why | Causa |
|-----|-------|
| ¿Por qué? (1) | [causa inmediata] |
| ¿Por qué? (2) | [causa de la causa] |
| ¿Por qué? (3) | [nivel más profundo] |
| ¿Por qué? (4) | [nivel más profundo] |
| ¿Por qué? (5) | **[causa raíz]** |

**Intervención:** [qué hay que atacar en el rediseño]

---

## Oportunidades de mejora priorizadas

| # | Oportunidad | Impacto (1-5) | Esfuerzo (1-5) | Cuadrante | Decisión |
|---|------------|--------------|---------------|-----------|---------|
| 1 | [Eliminar / simplificar / automatizar X] | [1-5] | [1-5] | Quick Win / Proyecto / Fill-in / Evitar | Implementar / Planificar / Descartar |
| 2 | | | | | |
| 3 | | | | | |

---

## Validación del análisis

| Validador | Rol | Fecha | Estado | Comentarios |
|-----------|-----|-------|--------|-------------|
| [nombre] | Process Owner | [YYYY-MM-DD] | ✅ Aprobado / ❌ Pendiente | [notas] |
| [nombre] | Ejecutor del proceso | [YYYY-MM-DD] | ✅ Aprobado / ❌ Pendiente | [notas] |
