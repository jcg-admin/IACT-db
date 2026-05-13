# Requirements Analysis — [Nombre del proyecto]

```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: ba:requirements-analysis
iteration: [N]
author: [nombre]
status: Borrador
```

---

## Use Case Model

| UC ID | Nombre | Actor principal | Prioridad MoSCoW | Estado |
|-------|--------|----------------|:----------------:|--------|
| UC-001 | [Nombre UC] | [Actor] | Must Have | Borrador |
| UC-002 | [Nombre UC] | [Actor] | Should Have | Borrador |

---

### UC-001: [Nombre del Use Case]

**Actor principal:** [Quién inicia el UC]
**Trigger:** [Qué evento dispara el UC]
**Precondiciones:** [Estado del sistema antes del UC]

**Flujo principal:**
1. [paso 1]
2. [paso 2]
3. [paso 3]
4. Sistema [respuesta del sistema]

**Flujos alternativos:**
- [ALT-1]: Si [condición], entonces [pasos alternativos]

**Flujos de excepción:**
- [EXC-1]: Si [falla], el sistema [qué hace] y notifica [a quién]

**Postcondiciones:** [Estado del sistema después del UC exitoso]

**Reglas de negocio:** 
- RN-001: [regla]
- RN-002: [regla]

---

## User Stories (contexto ágil)

| Story ID | Historia | Criterios de aceptación | INVEST | Prioridad |
|----------|----------|------------------------|:------:|-----------|
| US-001 | Como [rol], quiero [capacidad] para [beneficio] | [criterios] | ✅/⚠️ | Must Have |
| US-002 | | | | |

### US-001: [Título]

**Historia:** Como [rol del usuario], quiero [capacidad / feature], para [beneficio de negocio].

**Criterios de aceptación:**
- **Dado** [contexto], **cuando** [acción], **entonces** [resultado esperado]
- **Dado** [contexto alternativo], **cuando** [acción], **entonces** [resultado]
- **Dado** [condición de error], **cuando** [acción], **entonces** [manejo del error]

**Verificación INVEST:**
| Criterio | ✅/⚠️/❌ | Observación |
|---------|:-------:|------------|
| Independent | | |
| Negotiable | | |
| Valuable | | |
| Estimable | | |
| Small | | |
| Testable | | |

---

## Verificación de requisitos

| Req ID | Requisito | Completo | Consistente | No ambiguo | Verificable | Factible | Trazable | Resultado |
|--------|-----------|:--------:|:-----------:|:----------:|:-----------:|:--------:|:--------:|:---------:|
| REQ-001 | [descripción] | ✅/❌ | ✅/❌ | ✅/❌ | ✅/❌ | ✅/❌ | ✅/❌ | ✅ Aprobado |
| REQ-002 | | | | | | | | |

**Defectos encontrados en verificación:**
| Req ID | Criterio fallido | Descripción del defecto | Acción correctiva |
|--------|-----------------|------------------------|------------------|
| REQ-00X | [criterio] | [descripción] | [corrección] |

---

## Validación con stakeholders

| Req ID | Validado por | Rol | Fecha | Resultado | Observaciones |
|--------|-------------|-----|-------|:---------:|--------------|
| REQ-001 | [nombre] | SME | [fecha] | ✅ Aceptado | — |
| REQ-002 | [nombre] | Usuario | [fecha] | ⚠️ Modificar | [qué cambiar] |

---

## Priorización MoSCoW

| Categoría | # Requisitos | % del total | IDs |
|-----------|:-----------:|:-----------:|-----|
| **Must Have** | [#] | [%] | REQ-00X, REQ-00Y |
| **Should Have** | [#] | [%] | |
| **Could Have** | [#] | [%] | |
| **Won't Have** | [#] | [%] | |
| **Total** | [#] | 100% | |

> **Regla:** Must Have ≤ 60% del total. Si supera 60%, el scope debe reducirse.

**¿Must Have > 60%?** [ ] Sí — revisar scope con sponsor · [ ] No — distribución aceptable

---

## Opciones de diseño de alto nivel

| Opción | Descripción general | Pros | Contras | Restricciones | Recomendación |
|--------|--------------------|----|---------|--------------|:-------------:|
| Opción A | [qué hace, no cómo] | [lista] | [lista] | [restricciones] | ✅/❌ |
| Opción B | [alternativa] | [lista] | [lista] | [restricciones] | ✅/❌ |

**Opción recomendada:** [A/B] — [justificación basada en gap analysis de ba:strategy]

---

## Evaluación de completitud

- [ ] Todos los requisitos tienen ID único y criterios de aceptación verificables
- [ ] Use Cases / User Stories cubren el 100% de las capacidades del gap analysis
- [ ] Verificación completa: todos los requisitos son completos, consistentes, no ambiguos, verificables, factibles y trazables
- [ ] Validación completa: stakeholders clave confirmaron que los requisitos representan sus necesidades
- [ ] Priorización MoSCoW documentada con Must Have ≤ 60%

---

## Routing — próxima KA

| Situación | Próxima KA |
|-----------|-----------|
| Requisitos especificados necesitan trazabilidad | `ba:requirements-lifecycle` |
| Se necesita información adicional | `ba:elicitation` |
| Solución implementada → evaluar valor | `ba:solution-evaluation` |
| Gap en especificación → nueva iteración | `ba:requirements-analysis` (iteración N+1) |

**Decisión:** [KA seleccionada + razón]
