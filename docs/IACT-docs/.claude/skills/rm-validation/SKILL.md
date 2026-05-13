---
name: rm-validation
description: "Use when verifying that requirements meet quality standards and stakeholders approve them. rm:validation — conduct formal or informal inspection, obtain stakeholder sign-off, or return to analysis if corrections are needed."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["requirements validation", "requirements review RM", "sign-off requirements", "RM validation", "requirements approval"]
updated_at: 2026-04-17 00:00:00
---

# /rm-validation — Requirements Management: Validation

> *"Verification asks: did we build the thing right? Validation asks: did we build the right thing? Both are necessary. Confusing them is the root of most requirements failures."*

Ejecuta el paso **Validation** del ciclo de Requirements Management. Confirma que los requisitos especificados son correctos (verificación) y que resuelven la necesidad real (validación). Obtiene el sign-off formal antes de avanzar a gestión.

**THYROX Stage:** Stage 9 PILOT/VALIDATE.

---

## Foco en el ciclo RM

| Paso | Intensidad relativa | Rol en el ciclo |
|------|-------------------|----------------|
| Elicitation | Baja | Provee el contexto de necesidades que la validación debe confirmar |
| Analysis | Media | El checklist IEEE 830 de análisis es la base de la verificación formal |
| Specification | Alta | Provee el artefacto que este paso verifica y valida |
| **Validation** | **Alta** (este paso) | Gate de calidad y sign-off — confirma corrección y pertinencia |
| Management | Alta | Consume el baseline aprobado producido por este paso |

---

## Pre-condición

Requiere: `{wp}/rm-specification.md` con:
- Baseline de requisitos con versión y sign-off del autor
- Acceptance criteria verificables para cada Must Have
- Trazabilidad inicial (req → stakeholder origen)

---

## Cuándo usar este paso

- Cuando la especificación está completa con baseline establecido
- Para confirmar con stakeholders que los requisitos resuelven sus necesidades reales
- Para detectar defectos en la especificación antes de que se propaguen al diseño y desarrollo

## Cuándo NO usar este paso

- Sin baseline de especificación — no se puede validar lo que no está especificado
- Si los stakeholders clave no están disponibles para participar — programar las sesiones primero

---

## Actividades

### 1. Distinguir verificación de validación

Esta distinción es fundamental — confundirlas lleva a aprobar specs incorrectas:

| Dimensión | Verificación | Validación |
|-----------|-------------|------------|
| **Pregunta** | ¿El requisito cumple el estándar de calidad? | ¿El requisito resuelve la necesidad real del negocio? |
| **Evalúa** | Calidad interna del documento | Alineación con necesidades del stakeholder |
| **Técnica** | Inspección / walkthrough / checklist | Prototipo / UAT / sesión de review con usuario final |
| **Ejecuta** | Analista de requisitos + equipo técnico | Stakeholder / usuario final |
| **Resultado** | "Req correcto según estándar" | "Req resuelve mi necesidad real" |

> Un requisito puede pasar la verificación (bien escrito, testeable) y fallar la validación (no resuelve lo que el stakeholder realmente necesita). Ambas deben ejecutarse.

### 2. Elegir la técnica de validación según el contexto

| Técnica | Cuándo usar | Formalidad | Artefacto |
|---------|-------------|-----------|----------|
| **Walkthrough informal** | Equipos pequeños, proyectos internos, baja regulación | Baja | Notas de sesión |
| **Inspección Fagan** | Alta criticidad, sistemas regulados, grandes equipos | Alta | Defect log formal |
| **Prototipo de validación** | Req de UI/UX, stakeholders no técnicos, funcionalidades nuevas | Media | Prototipo + feedback registrado |
| **Test cases de aceptación (UAT)** | Sistemas en fase de validación final, req funcionales complejos | Alta | UAT plan + results |
| **Review session con stakeholder** | Validación de req de negocio con usuario final | Media | Acta de reunión + sign-off |

**Criterios de selección:**

| Contexto | Técnica recomendada |
|----------|---------------------|
| Regulación / auditoría / contrato legal | Inspección Fagan |
| Req funcionales con UI visible | Prototipo de validación |
| Equipo ágil / iterativo | Walkthrough + UAT por sprint |
| Sistema existente con usuarios reales | UAT con usuarios reales |

### 3. Inspección Fagan — protocolo formal

La Inspección Fagan (Fagan, 1976) es el método de inspección formal más riguroso para requisitos:

**Roles:**
| Rol | Responsabilidad |
|-----|----------------|
| **Moderator** | Facilita la inspección; neutral; certifica que se sigue el proceso |
| **Author** | El analista que escribió los requisitos; responde preguntas, NO defiende |
| **Reviewer(s)** | Lee y busca defectos antes de la reunión; al menos 2-3 personas |
| **Scribe** | Documenta los defectos encontrados durante la inspección |

**Proceso en 6 pasos:**
1. **Planning** — Moderator organiza; distribuye materiales con anticipación (≥ 48h)
2. **Overview** — Author presenta contexto del documento (opcional si el equipo lo conoce)
3. **Preparation** — Cada Reviewer lee el documento individualmente y marca defectos
4. **Inspection meeting** — Scribe documenta defectos; NO se discuten soluciones durante la reunión
5. **Rework** — Author corrige los defectos encontrados
6. **Follow-up** — Moderator verifica que las correcciones son correctas

**Taxonomía de defectos (para el defect log):**

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| **Missing** | Requisito incompleto o faltante | Sin acceptance criteria para un req Must Have |
| **Wrong** | Requisito incorrecto según la necesidad del stakeholder | Req que contradice el VOC documentado |
| **Extra** | Requisito que no tiene origen en ninguna necesidad | Feature sin stakeholder owner |
| **Ambiguous** | Puede interpretarse de múltiples formas | "El sistema debe ser rápido" |
| **Inconsistent** | Contradice otro requisito | Dos req con comportamientos opuestos para el mismo evento |

### 4. Sign-off matrix — aprobación formal

| Stakeholder | Rol | Tipo de aprobación | Fecha | Firma/confirmación |
|-------------|-----|-------------------|-------|-------------------|
| [Sponsor] | Aprueba business case + Must Haves | Formal | | |
| [Process Owner] | Confirma req operacionales | Formal | | |
| [Tech Lead] | Confirma factibilidad técnica de NFR | Técnica | | |
| [Usuario representativo] | Valida que resuelve su necesidad real | Usuario | | |

> **Regla de sign-off:** Si un stakeholder rechaza firmar sin explicación, es una señal de que la validación está incompleta o de que hay un conflicto no resuelto. No avanzar a gestión con sign-offs pendientes en Must Haves.

### 5. Decisión de retorno — ¿aprobar o corregir?

**Criterios para avanzar a `rm:management` (`on_approved`):**
- Todos los Must Have tienen sign-off de stakeholder relevante
- Cero defectos de tipo "Wrong" o "Inconsistent" sin resolver
- Defectos "Missing" en Must Have corregidos
- Prototipo o UAT aprobado (si se usaron)

**Criterios para retornar a `rm:analysis` (`on_corrections_needed`):**
- Defectos "Wrong" encontrados — requisitos que no reflejan la necesidad real
- Req Must Have sin acceptance criteria verificables
- Conflictos detectados durante la inspección no identificados en el análisis
- Sign-off rechazado por stakeholder clave con justificación

> **Documentar la decisión de retorno:** Si se retorna a análisis, registrar exactamente qué defectos requieren re-análisis. No repetir todo el análisis — enfocarse en los defectos identificados.

---

## Artefacto esperado

`{wp}/rm-validation.md`

usar template: [validation-report-template.md](./assets/validation-report-template.md)

---

## Red Flags — señales de validación mal ejecutada

- **Confundir verificación con validación** — aprobar que el req está "bien escrito" sin confirmar que resuelve la necesidad real
- **Sign-off de stakeholders equivocados** — aprobación del equipo técnico para req de negocio (o viceversa)
- **Walkthrough sin preparación previa** — revisores que leen el documento por primera vez en la reunión no encuentran defectos
- **Defectos "Wrong" ignorados o postergados** — un req que no refleja la necesidad real propagará el error al diseño y desarrollo
- **Sign-off informal** — email de "me parece bien" sin fecha ni versión del documento no cuenta como aprobación formal
- **Validación saltada por presión de tiempo** — los defectos encontrados en validación son 10-100× más baratos de corregir que en producción

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: rm:validation
flow: rm
```

**Al COMPLETAR** (sign-off formal obtenido):
```yaml
methodology_step: rm:validation  # completado → rm:management o rm:analysis (correcciones)
flow: rm
```

## Siguiente paso

- `on_approved` (sign-off completo, cero defectos críticos) → `rm:management`
- `on_corrections_needed` (defectos Wrong/Inconsistent encontrados) → `rm:analysis`

---

## Limitaciones

- La Inspección Fagan requiere entrenamiento del equipo — sin moderador experimentado, la inspección degrada a un walkthrough informal
- UAT con usuarios reales puede revelar necesidades no articuladas durante la elicitación — planificar iteraciones de elicitación si el UAT identifica gaps significativos
- Sign-off formal no garantiza que los req sean correctos — solo que los stakeholders acordaron con lo que leyeron; la validación real ocurre cuando el sistema está en uso

---

## Reference Files

### Assets
- [validation-report-template.md](./assets/validation-report-template.md) — Template de reporte de validación: técnica, defect log, sign-off matrix, decisión de flujo

### References
- [validation-checklist.md](./references/validation-checklist.md) — Checklist de 40 ítems por tipo de req, defect taxonomy (7 tipos), Inspección Fagan 6 fases, señales de warning con stakeholders
