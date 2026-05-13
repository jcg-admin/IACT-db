```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: rup:construction
rup_iteration: [N]
author: [nombre]
status: Borrador
```

# RUP Construction — Iteración [N]

---

## Plan de iteración [N]

| Campo | Detalle |
|-------|---------|
| **UC / Features incluidos** | [lista de UC y features de esta iteración] |
| **Duración** | [X semanas — del DD/MM al DD/MM] |
| **Objetivo de la iteración** | [qué funcionalidad específica estará operativa al final] |
| **Criterio de éxito** | [qué define "done" para esta iteración] |

**Definition of Done (por UC / Feature):**

- [ ] Flujos principal, alternativo y de excepción implementados
- [ ] Tests unitarios con cobertura ≥ [X]%
- [ ] Tests de integración pasando
- [ ] Code review realizado y aprobado
- [ ] Sin defectos Severity 1 o 2 abiertos
- [ ] Performance verificada vs NFR en el entorno de desarrollo
- [ ] Documentación técnica actualizada (si aplica)

---

## UC implementados en esta iteración

| UC | Flujos completados | Tests (Unit / Int) | Cobertura | Estado |
|----|------------------|-------------------|-----------|--------|
| UC-001: [Nombre] | Principal ✅ / Alt ✅ / Exc ✅ | Unit: ✅ / Int: ✅ | [X]% | Done ✅ |
| UC-002: [Nombre] | Principal ✅ / Alt ⚠️ / Exc ❌ | Unit: ✅ / Int: ⏳ | [X]% | En progreso |

---

## Defectos encontrados y resueltos

| ID | Severidad | Componente | Descripción | Estado | Versión fix |
|----|-----------|-----------|-------------|--------|------------|
| D-001 | Severity 1 | [componente] | [descripción breve] | Resuelto ✅ | [versión] |
| D-002 | Severity 2 | | | Abierto ⚠️ | [versión target] |

**Resumen de defectos:**

| Severidad | Encontrados | Resueltos | Pendientes |
|-----------|------------|-----------|-----------|
| Severity 1 (Critical) | | | 0 (requerido para IOC) |
| Severity 2 (Major) | | | |
| Severity 3 (Minor) | | | |
| Severity 4 (Trivial) | | | |

---

## Deuda técnica acumulada

> Solo registrar deuda que impacta futuros cambios o genera riesgo. No registrar "mejoras deseables".

| ID | Tipo | Descripción | Impacto | Estimación pago | Iteración target |
|----|------|-------------|---------|----------------|-----------------|
| TD-001 | Código | [descripción del shortcut tomado] | [qué se dificulta] | [X días] | C-[N+1] |
| TD-002 | Tests | [cobertura insuficiente en] | [riesgo de regresión] | [X días] | |
| TD-003 | Documentación | [componente sin documentar] | [dificultad de onboarding] | [X horas] | |

---

## Métricas de la iteración

| Métrica | Valor | Objetivo | Estado |
|---------|-------|----------|--------|
| UC / Story points completados | [N] | [N target] | ✅ / ⚠️ / ❌ |
| Velocity vs iteración anterior | [+X% / -X%] | Estable | |
| Defectos encontrados | [N] | | |
| Defectos resueltos en la iteración | [N] | ≥ encontrados | |
| Cobertura de tests (promedio) | [X]% | ≥ [target]% | |
| Performance p95 (ruta crítica) | [X ms] | < [NFR ms] | |
| Deuda técnica acumulada (total) | [N horas] | En control | |

---

## Evaluación milestone IOC

> Criterios detallados: [ioc-criteria.md](../references/ioc-criteria.md)

*(Completar solo en la iteración donde se evalúa si se alcanzó el IOC)*

- [ ] Funcionalidad suficiente para beta — todas las features Must Have implementadas y aceptadas por PO
- [ ] Severity 1 = 0 defectos abiertos
- [ ] Deuda técnica documentada y acotada (no bloqueante para Transition)
- [ ] Performance cumple NFR en staging (no solo en desarrollo)
- [ ] PO / Usuario beta aprueba explícitamente el inicio de Transition

**Resultado de la evaluación IOC:**

| Criterio | Estado | Observación |
|----------|--------|-------------|
| Must Have features completas | ✅ / ⚠️ / ❌ | |
| Severity 1 = 0 | ✅ / ⚠️ / ❌ | |
| Deuda técnica controlada | ✅ / ⚠️ / ❌ | |
| Performance en staging | ✅ / ⚠️ / ❌ | |
| PO aprueba inicio de Transition | ✅ / ⚠️ / ❌ | |

---

## Decisión

- [ ] **Avanzar a rup:transition** — IOC alcanzado (todos los criterios ✅)
- [ ] **Nueva iteración de Construction** — Motivo: [features incompletas / Severity 1 abiertos / performance / PO no aprueba]

---

## Retrospectiva de iteración

| Dimensión | Observación |
|-----------|-------------|
| **Velocidad** | [UC completados vs planeados; razones de diferencia] |
| **Calidad** | [defectos encontrados vs esperados; área problemática] |
| **Deuda técnica** | [nueva deuda generada; deuda pagada; tendencia] |
| **Proceso** | [qué funcionó bien; qué obstaculizó el trabajo] |
| **Riesgos** | [nuevos riesgos; estado de riesgos de Elaboration] |
| **Para la próxima iteración** | [acciones concretas a cambiar] |
