```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: rup:elaboration
rup_iteration: [N]
author: [nombre]
status: Borrador
```

# RUP Elaboration — Artefacto

---

## SAD — Software Architecture Document

> Criterios de architecture baseline: [architecture-baseline.md](../references/architecture-baseline.md)

### Architectural Goals y Quality Attributes

| Quality Attribute | Descripción | Métrica objetivo | Prioridad |
|------------------|-------------|-----------------|-----------|
| Performance | [descripción] | [p95 < Xms / throughput > Y req/s] | Alta / Media / Baja |
| Availability | [descripción] | [uptime %] | |
| Security | [descripción] | [requisito específico] | |
| Scalability | [descripción] | [N usuarios / volumen de datos] | |
| Maintainability | [descripción] | [test coverage %, TD ratio] | |

### Architectural Constraints

| Tipo | Constraint | Fuente |
|------|-----------|--------|
| Tecnológico | [tecnología mandatada, versión] | [contrato / decisión de negocio] |
| De integración | [sistema externo obligatorio] | [fuente del requisito] |
| Regulatorio | [norma / compliance] | [regulación aplicable] |
| De equipo | [tecnologías conocidas, limitaciones] | [team assessment] |

### Patterns y decisiones arquitectónicas

> Formato completo de ADR para RUP: [architecture-baseline.md](../references/architecture-baseline.md)

| Decisión | Pattern / Approach elegido | Alternativas consideradas | Justificación | Consecuencias |
|----------|---------------------------|--------------------------|---------------|---------------|
| [Decisión 1] | [Layered / Microservices / Event-driven / etc.] | [Alt A, Alt B] | [Por qué este pattern] | [Trade-offs aceptados] |
| [Decisión 2] | | | | |

### Diagrama de subsistemas

```
[Diagrama ASCII o referencia a diagrama externo]

┌─────────────────┐     ┌─────────────────┐
│  Subsistema A   │────▶│  Subsistema B   │
│  [responsab.]   │     │  [responsab.]   │
└─────────────────┘     └─────────────────┘
         │
         ▼
┌─────────────────┐
│  Subsistema C   │
│  [responsab.]   │
└─────────────────┘
```

### Critical Use Case Realizations

> Solo los UC arquitecturalmente significativos de Inception.

| Use Case | Subsistemas involucrados | Flujo arquitectónico | Riesgo que mitiga |
|----------|------------------------|---------------------|------------------|
| UC-001: [Nombre] | [A → B → C] | [secuencia simplificada] | R-00X |

### Architecture Risks Addressed

| Risk ID | Descripción | Cómo el SAD lo aborda | Estado |
|---------|-------------|----------------------|--------|
| R-001 | [riesgo de Inception] | [decisión arquitectónica que lo mitiga] | Mitigado / Reducido / Abierto |

---

## Architecture Prototype

> Criterios de selección de UC para el prototype: SKILL.md actividad 2.

**Escenarios probados:**

| UC / Escenario | Objetivo del test | Criterio de éxito | Resultado |
|---------------|-----------------|-------------------|-----------|
| [UC crítico] | [qué demuestra] | [métrica cuantificada] | Pasó ✅ / Falló ❌ |

**Resultados de performance:**

| Métrica | NFR objetivo | Resultado obtenido | Entorno |
|---------|-------------|-------------------|---------|
| Tiempo de respuesta p95 | [X ms] | [Y ms] | [Dev / Staging] |
| Throughput | [N req/s] | [M req/s] | |

**Código / repositorio:** [referencia al prototype]

**Conclusión:**
> El Architecture Prototype [confirma / no confirma] que la arquitectura es viable para los escenarios críticos.

---

## Use Case Model (80%)

> UC completados con flujos principal, alternativo y de excepción.

### UC-001: [Nombre del Use Case]

| Campo | Contenido |
|-------|-----------|
| **Actor principal** | [actor] |
| **Precondiciones** | [estado del sistema antes de iniciar] |
| **Postcondiciones** | [estado del sistema al terminar con éxito] |

**Flujo principal (Happy Path):**
1. [Paso 1]
2. [Paso 2]
3. [Paso N]

**Flujos alternativos:**
- **A1:** [condición] → [variación del flujo]

**Flujos de excepción:**
- **E1:** [condición de error] → [manejo del error]

*(repetir por cada UC)*

**Cobertura UC Model:**

| UC | Especificado | Flujos cubiertos | Prioridad |
|----|-------------|-----------------|-----------|
| UC-001 | ✅ | Principal + Alt + Exc | Alta |
| UC-002 | ✅ | Principal + Alt | Alta |
| UC-NNN | ⏳ | Pendiente (Construction) | Baja |
| **Total** | **X / Y** | | |

---

## Risk List (actualizada)

| Risk ID | Estado | Cambio vs Inception | Acción tomada |
|---------|--------|--------------------|--------------:|
| R-001 | ✅ Cerrado | Architecture Prototype demostró que el riesgo fue mitigado | |
| R-002 | ⚠️ Reducido | Probabilidad bajó de Alta a Media | |
| R-003 | 🔴 Abierto | Persiste — plan reforzado | |
| R-NNN | 🆕 Nuevo | Descubierto durante diseño de arquitectura | |

---

## Plan de Construction

| Iteración | Features / UC incluidos | Criterio de éxito | Duración estimada |
|-----------|------------------------|------------------|------------------|
| C-1 | [UC Must Have priority] | [funcionalidad mínima operativa] | [X semanas] |
| C-2 | [UC Must / Should Have] | [feature set completo para IOC] | [X semanas] |

**Criterio IOC:** [funcionalidad mínima que habilita el inicio de Transition]

**Equipo de Construction:**

| Rol | Persona / perfil | Dedicación |
|-----|-----------------|-----------|
| Tech Lead | [nombre / perfil] | [%] |
| Dev Backend | [N personas] | [%] |
| Dev Frontend | [N personas] | [%] |
| QA | [N personas] | [%] |

**Estimación de esfuerzo Construction:** [semanas-persona] *(±20% accuracy)*

---

## Evaluación milestone LCA

> Criterios detallados: [lca-criteria.md](../references/lca-criteria.md)

- [ ] Architecture Prototype ejecutable y estable bajo los escenarios críticos
- [ ] ≥ 80% del Use Case Model especificado (happy + alternate + exception paths)
- [ ] Riesgos técnicos top-5 mitigados o con plan concreto y creíble
- [ ] SAD completo con decisiones arquitectónicas justificadas
- [ ] Plan de Construction con iteraciones definidas y aceptado por el sponsor

**Resultado de la evaluación:**

| Criterio | Estado | Observación |
|----------|--------|-------------|
| Architecture Prototype estable | ✅ / ⚠️ / ❌ | |
| ≥ 80% UC Model especificado | ✅ / ⚠️ / ❌ | |
| Top-5 riesgos técnicos mitigados | ✅ / ⚠️ / ❌ | |
| SAD completo | ✅ / ⚠️ / ❌ | |
| Plan de Construction aceptado | ✅ / ⚠️ / ❌ | |

---

## Decisión

- [ ] **Avanzar a rup:construction** — LCA alcanzado (todos los criterios ✅)
- [ ] **Nueva iteración de Elaboration** — Motivo: [Architecture Prototype falló / riesgos abiertos / UC críticos sin especificar / plan rechazado]

---

## Retrospectiva de iteración

| Dimensión | Observación |
|-----------|-------------|
| **Qué funcionó bien** | [diseño, architecture prototype, especificación UC] |
| **Qué fue difícil** | [integración compleja, stakeholders, datos de performance] |
| **Qué cambiar en la próxima iteración** | [si aplica] |
| **Lecciones para Construction** | [supuestos de arquitectura que deben verificarse, áreas de riesgo residual] |
