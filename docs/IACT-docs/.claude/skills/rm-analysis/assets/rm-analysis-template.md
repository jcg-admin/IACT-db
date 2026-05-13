```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: rm:analysis
author: [nombre]
status: Borrador
```

# RM Analysis — Artefacto

---

## Checklist de calidad de requisitos

> Ver patrones de análisis detallados: [analysis-patterns.md](../references/analysis-patterns.md)

| Criterio | Definición | # Aprobados | # Con issues | % Aprobación |
|----------|-----------|------------|------------|-------------|
| **Completo** | Contiene toda la información necesaria | | | |
| **Correcto** | Refleja con exactitud la necesidad del stakeholder | | | |
| **Factible** | Puede implementarse con los recursos disponibles | | | |
| **No ambiguo** | Una sola interpretación posible | | | |
| **Verificable** | Existe un criterio de aceptación medible | | | |
| **Trazable** | Tiene origen identificado (stakeholder / sesión) | | | |
| **Consistente** | No contradice otros requisitos | | | |

**Total:** [N requisitos candidatos] / Aprobación promedio: [X]%

---

## Requisitos con issues de calidad

| Req-C ID | Criterio fallido | Descripción del issue | Acción requerida | Responsable | Estado |
|----------|-----------------|---------------------|-----------------|------------|--------|
| RC-001 | Ambiguo | ["siempre" — sin frecuencia definida] | Consultar a [stakeholder] para cuantificar | [nombre] | Pendiente |
| RC-002 | No verificable | [sin acceptance criteria cuantificado] | Agregar métrica de aceptación | | |

---

## Análisis de conflictos y resolución

| CF ID | Conflicto | Stakeholders | Tipo | Resolución | Estado |
|-------|-----------|-------------|------|-----------|--------|
| CF-001 | [RC-003 pide X; RC-007 pide lo opuesto] | [A vs B] | Negocio / Técnico / Prioridad | [decisión tomada + justificación] | Resuelto ✅ / Pendiente ⚠️ |

**Conflictos sin resolver:** [lista de CF pendientes → escalar o retornar a elicitación]

---

## Análisis de dependencias

| Req-C ID | Depende de | Tipo de dependencia | Impacto si no se resuelve |
|----------|-----------|--------------------|--------------------------:|
| RC-005 | RC-002 | Funcional (RC-005 no puede existir sin RC-002) | RC-005 no implementable |
| RC-008 | RC-001 | De datos (RC-008 usa datos creados por RC-001) | |

---

## Priorización MoSCoW

> Criterios de asignación definidos por el equipo antes de la sesión de priorización:
> - **Must Have:** Sin esto, el sistema no cumple su objetivo principal
> - **Should Have:** Importante, pero hay workaround aceptable
> - **Could Have:** Agrega valor pero no es crítico para el lanzamiento inicial
> - **Won't Have (this release):** Fuera de scope — registrado para futuras versiones

| Categoría | Cantidad | % del total | IDs de requisitos |
|-----------|---------|------------|------------------|
| **Must Have** | [N] | [X]% | RC-001, RC-002, ... |
| **Should Have** | [N] | [X]% | RC-006, RC-007, ... |
| **Could Have** | [N] | [X]% | RC-010, RC-011, ... |
| **Won't Have** | [N] | [X]% | RC-015, ... |

**Stakeholders que participaron en la priorización:**
- [nombre / rol] — [fecha]

---

## Análisis Kano (opcional — aplicar cuando hay incertidumbre sobre valor percibido)

| Categoría Kano | Descripción | Requisitos |
|---------------|-------------|-----------|
| **Básicos (Must-be)** | Su ausencia causa insatisfacción extrema; su presencia no genera satisfacción | RC-001, RC-003 |
| **Performance (One-dimensional)** | Más es mejor; satisfacción proporcional | RC-005, RC-008 |
| **Deleite (Attractive)** | Inesperados pero apreciados; su ausencia no genera insatisfacción | RC-012 |
| **Indiferentes** | No afectan la satisfacción | RC-015 |
| **Inversos** | Su presencia genera insatisfacción | RC-016 |

---

## Requisitos candidatos aprobados (post-análisis)

| Req ID | Descripción (reformulada si era ambigua) | Prioridad MoSCoW | Origen | Dependencias |
|--------|----------------------------------------|-----------------|--------|-------------|
| REQ-001 | [descripción clara, verificable, sin ambigüedad] | Must Have | RC-001 (S-01) | — |
| REQ-002 | | Should Have | RC-003 (S-02) | REQ-001 |

**Total aprobados:** [N] / **Retornados a elicitación:** [N] / **Descartados:** [N]

---

## Decisión de flujo

- [ ] **Avanzar a rm:specification** — criterios de calidad cumplidos; conflictos resueltos; priorización acordada
- [ ] **Retornar a rm:elicitation** — gaps identificados que requieren nuevas sesiones:
  - Gap 1: [descripción + stakeholders a consultar]
  - Gap 2: [descripción + técnica recomendada]
