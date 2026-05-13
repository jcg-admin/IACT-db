# Gap Analysis — Template

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
| **Fecha del análisis** | [YYYY-MM-DD] |
| **Fuente As-Is** | bpa:map — [fecha del mapa] |
| **Estado To-Be** | Objetivo de mejora definido por [Process Owner / Management] |

---

## Gap Analysis — As-Is vs. To-Be

| Dimensión | As-Is State | To-Be Target | Gap | Root Cause | Intervention |
|-----------|-------------|-------------|-----|-----------|-------------|
| **Tiempo de ciclo total** | [X días] | [Y días] | [-Z días] | [causa raíz — ej: 60% del tiempo son esperas entre handoffs] | [eliminar handoffs / automatizar notificaciones] |
| **Tasa de error / retrabajo** | [X%] | [Y%] | [-Z%] | [causa raíz — ej: información incompleta en el inicio del proceso] | [validación en el punto de entrada / checklist] |
| **% Actividades NVA** | [X%] | [Y%] | [-Z%] | [causa raíz — ej: pasos de verificación redundantes heredados] | [eliminar N pasos de verificación duplicados] |
| **N° de handoffs** | [N] | [M] | [-K handoffs] | [causa raíz — ej: proceso fragmentado entre 4 departamentos] | [integrar responsabilidades / single point of contact] |
| **N° de aprobaciones** | [N] | [M] | [-K aprobaciones] | [causa raíz — ej: aprobación centralizada sin delegación] | [matriz de autorización con límites por monto/tipo] |
| **Satisfacción del ejecutor** | [score actual] | [score objetivo] | [delta] | [causa raíz — ej: alta fricción en step X] | [simplificar / automatizar step X] |
| **Satisfacción del cliente** | [score actual / SLA actual] | [score objetivo / SLA objetivo] | [delta] | [causa raíz — ej: tiempo de ciclo total excede expectativa] | [reducción de tiempo de ciclo] |

*Agregar o eliminar filas según las dimensiones relevantes del proceso analizado*

---

## Análisis de brechas críticas

*Las 3 brechas con mayor impacto en el negocio:*

### Brecha 1 — [Dimensión más crítica]

**As-Is:** [estado actual con dato]
**To-Be:** [objetivo con dato]
**Impacto del gap:** [qué significa para el negocio / cliente no cerrar esta brecha]
**Causa raíz confirmada:** [resultado del 5 Whys del análisis]
**Intervención propuesta:** [acción concreta para cerrar la brecha]

### Brecha 2 — [Segunda dimensión crítica]

**As-Is:** [estado actual]
**To-Be:** [objetivo]
**Impacto del gap:** [impacto en negocio]
**Causa raíz confirmada:** [resultado del 5 Whys]
**Intervención propuesta:** [acción concreta]

### Brecha 3 — [Tercera dimensión crítica]

**As-Is:** [estado actual]
**To-Be:** [objetivo]
**Impacto del gap:** [impacto en negocio]
**Causa raíz confirmada:** [resultado del 5 Whys]
**Intervención propuesta:** [acción concreta]

---

## Resumen de intervenciones recomendadas

| Intervención | Brecha que cierra | Tipo de cambio | Complejidad |
|-------------|-----------------|---------------|------------|
| [Descripción intervención 1] | [Dimensión] | Eliminar / Simplificar / Integrar / Automatizar | Alta / Media / Baja |
| [Descripción intervención 2] | [Dimensión] | | |
| [Descripción intervención 3] | [Dimensión] | | |

*Estas intervenciones son los insumos principales para bpa:design*

---

## Restricciones conocidas

*Factores que pueden limitar el cierre de las brechas:*

| Restricción | Tipo | Impacto en el To-Be |
|-------------|------|---------------------|
| [Ej: sistema legacy sin API] | Técnica | [limita automatización de step X] |
| [Ej: regulación requiere aprobación manual] | Regulatoria | [no se puede eliminar aprobación Y] |
| [Ej: presupuesto limitado para este ciclo] | Financiera | [posponer automatización a siguiente ciclo] |

*Las restricciones técnicas y regulatorias se detallan en bpa:constraints (si el WP incluye esa fase)*

---

## Validación del Gap Analysis

| Validador | Rol | Fecha | Estado | Comentarios |
|-----------|-----|-------|--------|-------------|
| [nombre] | Process Owner | [YYYY-MM-DD] | ✅ Aprobado / ❌ Pendiente | [notas] |
| [nombre] | Management / Sponsor | [YYYY-MM-DD] | ✅ Aprobado / ❌ Pendiente | [notas] |
