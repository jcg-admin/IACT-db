---
name: rm-analysis
description: "Use when reviewing and prioritizing collected requirements. rm:analysis — analyze completeness, consistency and priority of requirements; resolve conflicts; decide whether to proceed or return to elicitation."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["requirements analysis RM", "RM analysis", "requirements prioritization", "conflict resolution requirements", "requirements completeness"]
updated_at: 2026-04-17 00:00:00
---

# /rm-analysis — Requirements Management: Analysis

> *"A requirement that cannot be tested cannot be implemented. A requirement that conflicts with another cannot be satisfied. Analysis is the quality gate before specification."*

Ejecuta el paso **Analysis** del ciclo de Requirements Management. Evalúa la calidad de los requisitos recopilados, resuelve conflictos, prioriza y decide si avanzar a especificación o retornar a elicitación.

**THYROX Stage:** Stage 3 DIAGNOSE / Stage 5 STRATEGY.

---

## Foco en el ciclo RM

| Paso | Intensidad relativa | Rol en el ciclo |
|------|-------------------|----------------|
| Elicitation | Alta | Provee los requisitos candidatos que este paso evalúa |
| **Analysis** | **Alta** (este paso) | Calidad, priorización y resolución de conflictos — gate de calidad |
| Specification | Media | Consume el análisis para producir el documento formal |
| Validation | Baja | Verifica que los requisitos analizados y especificados son correctos |
| Management | Baja | Puede requerir re-análisis cuando cambian los requisitos base |

---

## Pre-condición

Requiere: `{wp}/rm-elicitation.md` con:
- Lista de requisitos candidatos confirmados con stakeholders
- Conflictos identificados entre stakeholders
- Gaps pendientes documentados

---

## Cuándo usar este paso

- Cuando la elicitación está completa y confirmada
- Para evaluar la calidad y completitud de los requisitos antes de especificarlos
- Para resolver conflictos entre stakeholders antes de que se propaguen a la especificación

## Cuándo NO usar este paso

- Sin elicitación completa — analizar requisitos sin confirmarlos con stakeholders es analizar supuestos
- Si hay stakeholders clave que no participaron en la elicitación → retornar a `rm:elicitation` primero

---

## Actividades

### 1. Checklist de calidad de requisitos

Evaluar cada requisito candidato contra los criterios IEEE 830:

| Criterio | Pregunta | Problema si falla |
|----------|----------|-------------------|
| **Completeness** | ¿Define completamente el comportamiento esperado? | Implementación incompleta o con supuestos |
| **Consistency** | ¿Contradice algún otro requisito? | Imposible satisfacer ambos simultáneamente |
| **Unambiguity** | ¿Solo puede interpretarse de una manera? | Implementaciones distintas según el desarrollador |
| **Non-conflict** | ¿Existe en otro lugar con definición diferente? | Dos versiones del mismo requisito en conflicto |
| **Verifiability** | ¿Se puede probar con un test case? | No se puede confirmar que está implementado |
| **Feasibility** | ¿Es técnicamente realizable en el contexto dado? | Requisito que nunca se implementará |
| **Traceability** | ¿Tiene dueño (stakeholder owner) identificado? | Requisito sin sponsor = candidato a eliminación |

> **Regla de eliminación:** Un requisito que no tiene stakeholder owner identificado y que ningún stakeholder puede justificar debe ser marcado como "candidato a eliminar" — no eliminado directamente, sino devuelto a los stakeholders para decisión.

### 2. Resolución de conflictos

Para cada conflicto identificado en la elicitación:

| Tipo de conflicto | Técnica de resolución | Escalación |
|-------------------|----------------------|------------|
| **Conflicto de prioridad** (stakeholder A quiere A antes que B, stakeholder B al revés) | Workshop de priorización conjunta con MoSCoW | Si no hay consenso: sponsor decide |
| **Conflicto de alcance** (un stakeholder incluye X, otro explicitamente no) | Sesión de negociación con ambos stakeholders + analista | Si no hay acuerdo: escalar al project owner |
| **Conflicto técnico** (requisito técnicamente imposible con otro existente) | Revisión con equipo técnico; uno de los requisitos debe modificarse | Decisión técnica documentada |
| **Conflicto de negocio** (dos áreas con objetivos opuestos) | Análisis de impacto + escalación al sponsor | Solo el sponsor puede resolver conflictos de negocio |

### 3. Priorización con MoSCoW

MoSCoW es el método estándar de priorización en RM:

| Categoría | Definición | Criterio para asignar |
|-----------|------------|----------------------|
| **Must have** | Requisito crítico — sin él, el sistema no puede operar o no tiene valor | El usuario final no puede hacer su trabajo sin este requisito |
| **Should have** | Importante pero no crítico — el sistema funciona sin él pero de forma degradada | Alta frecuencia de uso; impacto significativo en la experiencia |
| **Could have** | Deseable — agrega valor pero es prescindible en el release actual | Baja frecuencia de uso; puede diferirse sin impacto |
| **Won't have (this time)** | Fuera del scope de este release — reconocido, no olvidado | Explícitamente acordado con stakeholders como fuera del alcance actual |

> **Regla de MoSCoW:** Si todo es Must Have, la priorización no funcionó. En un proyecto bien priorizado, Must Have es ≤ 60% del total de requisitos.

### 4. Análisis de modelo Kano (opcional — para productos con usuarios finales)

Complementa MoSCoW con la perspectiva del valor percibido:

| Categoría Kano | Descripción | Impacto |
|----------------|-------------|---------|
| **Must-be** (básicos) | Su ausencia genera insatisfacción severa; su presencia no genera satisfacción extra | Siempre incluir — son prerequisitos |
| **Performance** (lineales) | A más de esto, más satisfacción; a menos, más insatisfacción | Optimizar según resources disponibles |
| **Delighters** (excitadores) | Inesperados: su presencia genera deleite; su ausencia no genera insatisfacción | Incluir si hay capacidad — diferenciadores |
| **Indifferent** | Ni su presencia ni su ausencia afecta la satisfacción | Eliminar del scope |
| **Reverse** | Su presencia genera insatisfacción en algunos usuarios | Evaluar cuidadosamente antes de incluir |

### 5. Decisión de retorno — ¿avanzar o re-elicitar?

**Criterios para avanzar a `rm:specification`:**
- Todos los Must Have tienen stakeholder owner identificado
- No hay conflictos no resueltos
- ≥ 80% de los requisitos pasan el checklist de calidad IEEE 830
- Los conflictos de negocio están escalados (aunque no resueltos — se pueden especificar con ambas opciones)

**Criterios para retornar a `rm:elicitation` (`on_gaps_found`):**
- Gaps identificados en áreas funcionales que no fueron cubiertas
- Stakeholders clave identificados durante el análisis que no participaron en la elicitación
- Requisitos Must Have que no tienen stakeholder owner (nadie puede justificarlos → deben confirmarse o eliminarse)
- Más del 30% de los requisitos fallan el criterio de verifiability

> **Documentar la decisión de retorno:** Si se retorna a elicitación, registrar exactamente qué gaps deben cubrirse. La re-elicitación debe ser enfocada (no repetir toda la elicitación), con una lista de preguntas específicas para los stakeholders correctos.

---

## Artefacto esperado

`{wp}/rm-analysis.md`

usar template: [rm-analysis-template.md](./assets/rm-analysis-template.md)

---

## Red Flags — señales de análisis mal ejecutado

- **Requisito sin stakeholder owner** — si nadie puede justificar un requisito, probablemente no es necesario
- **Todo es Must Have** — la priorización no funcionó; repetir con criterios más estrictos
- **Conflictos ignorados** — propagar conflictos a la especificación garantiza re-trabajo tardío
- **Verificability no evaluada** — un requisito que no puede testearse no puede implementarse verificablemente
- **Re-elicitación sin lista de gaps específicos** — volver a elicitar sin saber exactamente qué buscar no resuelve los gaps
- **Análisis realizado antes de confirmar los requisitos con stakeholders** — si la confirmación de elicitación no ocurrió, el análisis es prematuro

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: rm:analysis
flow: rm
```

**Al COMPLETAR** (calidad verificada, priorización completada, decisión de flujo tomada):
```yaml
methodology_step: rm:analysis  # completado → rm:specification o rm:elicitation (gaps)
flow: rm
```

## Siguiente paso

- `on_success` (calidad y priorización completas) → `rm:specification`
- `on_gaps_found` (gaps identificados en análisis) → `rm:elicitation` con lista de gaps

---

## Limitaciones

- MoSCoW es subjetivo sin criterios de asignación claros — definir los criterios en el plan de RM antes de ejecutar la priorización
- El modelo Kano requiere datos de usuarios reales para ser válido — en ausencia de datos, usar como framework de discusión, no como herramienta de decisión
- Conflictos de negocio entre áreas de alta jerarquía pueden no resolverse dentro del proyecto — documentar la decisión pendiente y sus implicaciones en el diseño

---

## Reference Files

### Assets
- [rm-analysis-template.md](./assets/rm-analysis-template.md) — Template del artefacto de análisis: checklist de calidad, conflictos, priorización MoSCoW, Kano y decisión de flujo

### References
- [analysis-patterns.md](./references/analysis-patterns.md) — Patrones de análisis: MoSCoW tabla completa, conflict resolution (6 pasos), dependency mapping, priorización avanzada
