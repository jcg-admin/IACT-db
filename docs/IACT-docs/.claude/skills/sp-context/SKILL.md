---
name: sp-context
description: "Use when starting a strategic planning process. sp:context — define organizational context, mission/vision/values, stakeholder landscape, and current strategic position."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
updated_at: 2026-04-17 03:00:00
---

# /sp-context — Strategic Planning: Context

> *"Strategy without context is a map without a territory. Before charting a course, you must know where you stand."*

Ejecuta el paso **Context** del ciclo Strategic Planning. Produce el documento de contexto organizacional que fundamenta todo el proceso estratégico.

**THYROX Stage:** Stage 1 DISCOVER.

**Tollgate:** Documento de contexto aprobado por el sponsor/liderazgo antes de avanzar a sp:analysis.

---

## Ciclo Strategic Planning — foco en Context

```mermaid
flowchart LR
    CTX[Context\nMisión + Stakeholders]:::active --> ANL[Analysis\nSWOT + Entorno]
    ANL --> GAP[Gaps\nDiagnóstico]
    GAP --> FOR[Formulate\nBSC + OKRs]
    FOR --> PLN[Plan\nIniciativas + KPIs]
    PLN --> EXE[Execute\nImplementar]
    EXE --> MON[Monitor\nDashboards]
    MON --> ADJ[Adjust\nAdaptación]
    classDef active fill:#4a9eff,color:#fff
```

## Pre-condición

- Work package activo con descripción inicial del desafío o iniciativa estratégica.
- Sponsor o liderazgo identificado con autoridad para aprobar el rumbo estratégico.
- Acceso a documentos fundacionales de la organización (estatutos, planes previos, reportes anuales).

---

## Cuándo usar este paso

- Al iniciar un ciclo de planificación estratégica formal (anual, plurianual, o por crisis).
- Cuando la organización atraviesa un cambio de liderazgo, fusión, expansión o pivote.
- Cuando los objetivos estratégicos están desactualizados o desalineados con la realidad del mercado.
- Como primer paso obligatorio del namespace `sp:` — ninguna otra fase puede ejecutarse sin este contexto.

## Cuándo NO usar este paso

- Si el contexto ya está documentado y aprobado en un ciclo reciente (menos de 12 meses) — ir directamente a sp:analysis para actualizar el baseline.
- Para problemas operacionales puntuales sin implicación estratégica — usar PDCA o DMAIC en su lugar.
- Si no hay sponsor con autoridad real — sin liderazgo comprometido, el proceso estratégico no tiene tracción.

---

## Actividades

### 1. Misión, Visión y Valores — fundamentos organizacionales

La misión, visión y valores son el punto de partida del proceso estratégico. Sin ellos, los objetivos no tienen ancla.

| Elemento | Pregunta central | Formato recomendado |
|----------|-----------------|---------------------|
| **Misión** | ¿Por qué existimos? ¿Qué hacemos y para quién? | 1-2 oraciones concisas, tiempo presente |
| **Visión** | ¿Dónde queremos estar en 3-10 años? | 1 oración aspiracional con horizonte temporal |
| **Valores** | ¿Qué principios no negociamos? | Lista de 4-7 valores con descripción breve |

**Criterios de calidad:**

- La misión describe el negocio actual, no el aspiracional
- La visión es específica y medible — *"Ser líderes en LATAM para 2030"* es mejor que *"Ser los mejores"*
- Los valores se evidencian en decisiones concretas, no son decorativos

### 2. Análisis de Stakeholders

Identificar quiénes tienen interés o influencia en la estrategia es crítico antes de cualquier análisis ambiental.

| Stakeholder | Tipo | Nivel de influencia | Nivel de interés | Expectativa principal |
|-------------|------|--------------------|-----------------|-----------------------|
| [Nombre/Grupo] | Interno / Externo | Alto / Medio / Bajo | Alto / Medio / Bajo | [Qué esperan del proceso] |

**Matriz de poder-interés:**

```
Alto interés + Alta influencia → Gestionar de cerca (co-diseño de estrategia)
Alto interés + Baja influencia → Mantener informados (comunicación regular)
Bajo interés + Alta influencia → Satisfacer (consulta puntual)
Bajo interés + Baja influencia → Monitorear (actualizaciones periódicas)
```

### 3. Posición Estratégica Actual

Descripción objetiva del estado actual de la organización en relación con su entorno competitivo.

| Dimensión | Estado actual | Fuente de datos |
|-----------|--------------|-----------------|
| **Mercado** | Segmento(s) que atiende, share aproximado | Informes, CRM, datos de ventas |
| **Modelo de negocio** | Cómo genera valor y captura ingresos | Mapa de negocio, P&L |
| **Capacidades clave** | Qué sabe hacer bien la organización | Entrevistas, benchmarks |
| **Brechas evidentes** | Qué capacidades le faltan | Retroalimentación de clientes, auditorías |
| **Desempeño financiero** | Tendencias de los últimos 2-3 años | Estados financieros |

### 4. Horizonte Estratégico

Definir el período que abarcará el plan estratégico:

```
Horizonte corto:  1 año  → Objetivos operacionales, ajustes tácticos
Horizonte medio:  3 años → Transformaciones organizacionales, nuevos mercados
Horizonte largo:  5+ años → Cambios de modelo de negocio, posicionamiento estructural
```

El horizonte determina el nivel de ambición y el tipo de decisiones que se tomarán en fases posteriores.

### 5. Contexto Histórico Estratégico

Revisar decisiones estratégicas anteriores para evitar repetir errores y construir sobre aprendizajes:

| Período | Iniciativa estratégica | Resultado | Lección aprendida |
|---------|----------------------|-----------|------------------|
| [Año-Año] | [Qué se intentó] | [Éxito / Parcial / Fracaso] | [Por qué] |

> Sin contexto histórico, los equipos estratégicos cometen los mismos errores en cada ciclo.

### 6. Mandatos y Restricciones Conocidas

Identificar desde el inicio los límites no negociables que acotan el espacio estratégico:

| Tipo de restricción | Descripción | Impacto en estrategia |
|--------------------|-------------|----------------------|
| **Regulatoria** | Leyes, normas sectoriales, licencias | Zonas de juego prohibidas |
| **Financiera** | Presupuesto disponible, acceso a capital | Techo de inversión |
| **Organizacional** | Cultura, capacidades actuales, sindicatos | Velocidad de cambio posible |
| **Tecnológica** | Deuda técnica, sistemas legacy, patentes | Habilitadores o frenos |
| **Estratégica** | Compromisos con socios, contratos largos | Opciones cerradas |

### 7. Declaración de Contexto Estratégico

Síntesis ejecutiva en formato narrativo (1 página máxima) que integra todos los elementos anteriores. Debe responder:

1. **¿Quiénes somos?** (Misión + valores)
2. **¿Dónde estamos?** (Posición actual + contexto histórico)
3. **¿Para quién trabajamos?** (Stakeholders clave)
4. **¿Hacia dónde queremos ir?** (Visión + horizonte)
5. **¿Qué nos limita?** (Restricciones conocidas)

---

## Artefacto esperado

`{wp}/sp-context.md` — usar template: [sp-context-template.md](./assets/sp-context-template.md)

---

## Red Flags — señales de Context mal ejecutado

- **Misión genérica sin diferenciación** — *"Ofrecer valor a nuestros clientes"* no es misión, es vacío
- **Visión sin horizonte temporal** — una visión sin fecha no genera urgencia ni accountability
- **Stakeholders = lista de nombres** — si no se analiza influencia e interés, la lista no sirve para gestión
- **Posición actual sin datos** — las afirmaciones sobre el estado actual deben respaldarse con evidencia
- **Restricciones ignoradas** — un contexto que no identifica límites reales producirá una estrategia inviable
- **Misión y visión redactadas en reunión de 20 minutos** — requieren iteración y validación con equipos

### Anti-racionalización — excusas comunes para saltarse Context

| Racionalización | Por qué es trampa | Respuesta correcta |
|----------------|-------------------|--------------------|
| *"Todos saben cuál es nuestra misión"* | El conocimiento implícito no alinea — cada persona tiene una versión diferente | Documentar, validar y publicar la misión formalmente |
| *"Los stakeholders son obvios"* | Los stakeholders que no se identifican explícitamente son los que generan sorpresas negativas | Hacer el mapeo aunque parezca redundante |
| *"El contexto es el mismo de siempre"* | El entorno cambia — un contexto de hace 2 años puede ser incorrecto | Revisar y actualizar, no copiar del ciclo anterior |
| *"Podemos hacer el contexto rápido y seguir"* | Un contexto superficial produce análisis superficial y estrategia superficial | Dar el tiempo necesario — es la única base del proceso |

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: sp:context
flow: sp
```

**Al COMPLETAR** (Declaración de Contexto Estratégico aprobada por sponsor):
```yaml
methodology_step: sp:context  # completado → listo para sp:analysis
flow: sp
```

## Siguiente paso

Cuando la Declaración de Contexto Estratégico está aprobada → `sp:analysis`

---

## Limitaciones

- El contexto es una foto del momento — requiere revisión cuando el entorno cambia significativamente.
- La misión y visión deben ser construidas con participación real del liderazgo, no redactadas por un solo consultor.
- Los mandatos y restricciones pueden ser incompletos en la primera iteración — se refinan con sp:analysis (PESTEL, regulatorio).
- El horizonte estratégico debe alinearse con los ciclos de presupuesto y gobernanza de la organización.

---

## Reference Files

### Assets
- [sp-context-template.md](./assets/sp-context-template.md) — Template completo del documento de contexto estratégico con misión/visión/valores, mapa de stakeholders, posición actual y restricciones

### References
- [stakeholder-analysis-guide.md](./references/stakeholder-analysis-guide.md) — Guía de análisis de stakeholders: matriz poder-interés, técnicas de elicitación, estrategias de gestión por cuadrante
