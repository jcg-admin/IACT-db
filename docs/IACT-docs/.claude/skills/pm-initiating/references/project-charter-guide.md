# Project Charter Guide — Guía de referencia

> Reference for pm:initiating. Charter template completo, Power/Interest Grid, técnicas de identificación de stakeholders.

---

## ¿Qué es el Project Charter?

El **Project Charter** es el documento que **autoriza formalmente el proyecto** y le da al PM la autoridad para aplicar recursos de la organización. Sin Charter firmado, el PM no tiene autoridad formal.

**Función dual:**
1. Define el *qué* (business need, objetivos, high-level scope)
2. Autoriza el *quién* (PM asignado + nivel de autoridad)

**No contiene:** arquitectura técnica, plan detallado, estimaciones de alta precisión.

---

## Técnicas de identificación de stakeholders

### Técnica 1: Expert Judgment

Consultar a personas con experiencia en proyectos similares o en la organización para identificar stakeholders no obvios.

**Fuentes:**
- PMO (si existe)
- PM de proyectos anteriores similares
- Subject Matter Experts del dominio

### Técnica 2: Stakeholder Analysis por impacto

1. Identificar áreas que **usan** el producto → usuarios finales
2. Identificar áreas que **aprueban** el presupuesto → sponsors
3. Identificar áreas que **proveen** recursos → managers de línea
4. Identificar áreas que **son afectadas** por el cambio → áreas de negocio adyacentes
5. Identificar reguladores / auditores externos

### Técnica 3: Representación de redes

Revisar organigramas + stakeholders ya identificados → preguntar: *"¿A quién más debería consultar sobre esto?"*

### Técnica 4: Brainstorming con el sponsor

Sesión con el sponsor para generar lista completa de stakeholders desde su perspectiva de negocio.

---

## Power/Interest Grid — 4 cuadrantes

```
        │ ALTO PODER
        │
  Keep  │  Manage
Satisfied│  Closely
        │
──────────────────────── Interés
        │
Monitor │  Keep
        │  Informed
        │
        │ BAJO PODER
```

### Cuadrante 1: Alto Poder / Alto Interés → Manage Closely

**Estrategia:** Involucrar proactivamente; reuniones regulares; consultar antes de decisiones.

**Ejemplos típicos:** Sponsor, Champion, Product Owner

**Riesgo si se descuida:** Pérdida de apoyo, cambios de prioridad tardíos, scope creep.

### Cuadrante 2: Alto Poder / Bajo Interés → Keep Satisfied

**Estrategia:** Informar sobre hitos clave; no sobrecargar con detalle; involucrar en decisiones de alto nivel.

**Ejemplos típicos:** CTO, CFO (si el presupuesto es estándar), Legal (en ausencia de riesgos regulatorios)

**Riesgo si se descuida:** Veto tardío o redistribución de recursos.

### Cuadrante 3: Bajo Poder / Alto Interés → Keep Informed

**Estrategia:** Actualizaciones regulares; capturar su conocimiento del dominio; pueden convertirse en aliados.

**Ejemplos típicos:** Usuarios finales, analistas, SMEs técnicos

**Riesgo si se descuida:** Pérdida de conocimiento de dominio; resistencia durante la adopción.

### Cuadrante 4: Bajo Poder / Bajo Interés → Monitor

**Estrategia:** Monitorear cambios; incluir en comunicaciones masivas (no individuales).

**Riesgo si se descuida:** Bajo. Pero pueden migrar de cuadrante si cambia el contexto.

---

## Engagement Levels — Gestión proactiva

| Nivel | Descripción | Señales | Acción |
|-------|-------------|---------|--------|
| **Unaware** | No sabe del proyecto | No responde; no asiste a reuniones | Sesión de awareness; comunicado del sponsor |
| **Resistant** | Opone activamente | Objeciones frecuentes; bloquea decisiones | 1:1 para entender preocupaciones; plan de gestión de resistencia |
| **Neutral** | Ni apoya ni se opone | Participa pero no contribuye activamente | Buscar quick wins que demuestren valor para su área |
| **Supportive** | Apoya el proyecto | Participa, recomienda | Mantener con información y reconocimiento |
| **Leading** | Promueve activamente | Convence a otros; toma iniciativa | Empoderar como champion |

**Objetivo:** mover todos los stakeholders clave hacia Supportive o Leading antes de Executing.

---

## Escribir objetivos SMART

| Criterio | Definición | Anti-patrón | Correcto |
|----------|-----------|------------|---------|
| **S** — Specific | Qué exactamente se va a lograr | "mejorar la plataforma" | "reducir errores de procesamiento en módulo X" |
| **M** — Measurable | Con qué métrica se mide | "mejorar la satisfacción" | "NPS ≥ 7.5" |
| **A** — Achievable | Factible con los recursos disponibles | "cero defectos" | "reducir defectos Severity 1 en 80%" |
| **R** — Relevant | Alineado con el objetivo de negocio | "añadir feature Y" sin contexto | "feature Y reduce churn en [segmento]" |
| **T** — Time-bound | Con fecha límite | "próximamente" | "antes de Q3 2026" |

---

## Estimación de orden de magnitud (ROM)

El Charter requiere estimaciones con **±50% de accuracy** — este es el rango esperado para esta etapa, no una imprecisión.

| Técnica | Precisión | Datos necesarios |
|---------|-----------|-----------------|
| **Analogous estimating** | -25% a +75% | Proyectos históricos similares |
| **Expert judgment** | -30% a +60% | Experto con experiencia en el dominio |
| **Parametric estimating** | -20% a +40% | Parámetros medibles del proyecto (LOC, story points) |
| **Bottom-up (no en Charter)** | -10% a +15% | WBS completo — usar solo en Planning |

**Regla:** Si el sponsor pide estimaciones de alta precisión en Initiating, explicar que esa precisión solo es posible después de Planning (±10%).

---

## Señales de Charter incompleto

| Señal | Problema | Corrección |
|-------|---------|-----------|
| Sin fecha de firma | No hay autorización formal | Solicitar firma antes de iniciar Planning |
| Objectives sin métrica | No verificables | Agregar KPI cuantificable por objetivo |
| Riesgos vacíos | Risk analysis no realizado | Mínimo 5 riesgos con P×I |
| "PM: por definir" | PM sin autoridad | Asignar PM antes de Planning |
| Scope de 3 palabras | Business need no entendido | Taller de visión con sponsor |
| Budget: "TBD" | Proyecto sin financiamiento | Escalar a sponsor antes de continuar |
