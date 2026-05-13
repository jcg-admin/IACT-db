# IOC Criteria — Initial Operational Capability Milestone

> Reference for rup:construction. IOC is the gate between Construction and Transition.
> Decision: advance to Transition OR iterate Construction.

---

## ¿Qué es el IOC?

El **Initial Operational Capability (IOC)** milestone marca que el sistema tiene funcionalidad suficiente para ser desplegado en un entorno beta (no necesariamente producción) y ser evaluado por usuarios reales.

**Pregunta central del IOC:** *"¿El sistema tiene la funcionalidad mínima para que usuarios beta puedan usarlo y darnos feedback real?"*

IOC ≠ feature complete. IOC = listo para Transition (que incluirá correcciones post-beta antes del PD).

---

## Criterios de evaluación IOC

### Criterio 1: Funcionalidad Must Have completa

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Todos los UC Must Have implementados | Lista de UC Must Have vs estado | UC Must Have en "En progreso" |
| UC Must Have aceptados por PO | Sign-off del Product Owner por UC | Solo el equipo técnico verificó |
| Flujos de excepción implementados | Tests de excepción pasando | Solo happy path implementado |
| Integración con sistemas externos funcional | Tests de integración E2E pasando | Integración mockeada en staging |

**Clasificación de features para IOC:**

| Prioridad | Requerimiento IOC | Justificación |
|-----------|------------------|---------------|
| **Must Have** | 100% completado y aceptado | Sin estos, el sistema no tiene valor para beta |
| **Should Have** | ≥ 70% completado | Los restantes pueden terminar en Transition |
| **Could Have** | 0% requerido | Opcional; solo si hay capacidad |
| **Won't Have** | Excluido explícitamente | No en scope de esta release |

### Criterio 2: Severity 1 = 0

| Clasificación de severidad | Definición | IOC |
|--------------------------|-----------|-----|
| **Severity 1 — Critical** | Sistema inutilizable, pérdida de datos, falla de seguridad | **= 0 para IOC** |
| **Severity 2 — Major** | Funcionalidad importante no disponible, workaround no viable | = 0 recomendado |
| **Severity 3 — Minor** | Funcionalidad degradada, workaround disponible | Documentados y acotados |
| **Severity 4 — Trivial** | Cosmético, inconveniente menor | No bloquea IOC |

> Si hay Severity 2 al IOC: documentar, obtener aprobación del PO, y comprometerse a corregir antes del PD.

### Criterio 3: Deuda técnica documentada y acotada

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Deuda registrada en backlog | Lista con tipo, descripción, estimación | "Hay deuda pero no está documentada" |
| Sin deuda crítica que bloquee Transition | Evaluación del impacto de la deuda | Deuda que haría imposible el mantenimiento |
| Plan de pago acordado | Iteración target para cada item de deuda | Deuda sin owner ni fecha |
| Equipo de Transition informado | Deuda comunicada a quien mantiene el sistema | Deuda "sorpresa" en Transition |

**Clasificación de deuda técnica por impacto:**

| Nivel | Descripción | IOC |
|-------|-------------|-----|
| **Bloqueante** | Hace imposible modificar el sistema o genera fallas frecuentes | ❌ No permite IOC |
| **Alta** | Dificulta significativamente el mantenimiento | ⚠️ Requiere plan concreto de pago |
| **Media** | Ineficiencia técnica sin impacto inmediato | Documentada y priorizada |
| **Baja** | Mejoras de estilo o nomenclatura | Registrada, no prioritaria |

### Criterio 4: Performance cumple NFR en staging

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Tests de performance en staging (no dev) | Reporte de test en entorno staging | Solo performance en localhost |
| Cobertura de paths críticos | Todos los UC Must Have bajo carga | Solo el happy path testeado |
| Performance vs NFR del Vision Document | Tabla comparativa | "Se ve bien" sin números |
| Sin memory leaks detectables | Test de duración con perfil de memoria | Sin test de duración |

**Criterio de aceptación de performance:**

| Métrica | Criterio mínimo IOC | Criterio ideal PD |
|---------|--------------------|--------------------|
| Tiempo de respuesta p95 | ≤ NFR × 1.2 | ≤ NFR |
| Throughput | ≥ NFR × 0.8 | ≥ NFR |
| Error rate bajo carga | < 0.1% | < 0.01% |
| Memory growth en 1h | < 10% de baseline | < 5% |

### Criterio 5: PO / Usuario beta aprueba inicio de Transition

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Demo a PO con todos los UC Must Have | Acta o email de confirmación | Demo no realizada |
| PO aprueba explícitamente | Sign-off del PO | "El PO asistió a la demo" sin sign-off |
| Usuarios beta identificados | Lista de usuarios beta con disponibilidad confirmada | Sin usuarios beta confirmados |
| Entorno beta preparado | Entorno staging aprobado para beta | Usarán producción directamente |

---

## Feature complete checklist por tipo de UC

### UC de tipo transaccional (crear / modificar / eliminar)

- [ ] Flujo de creación completo con validación de inputs
- [ ] Flujo de modificación con manejo de conflictos (si aplica)
- [ ] Flujo de eliminación con confirmación y manejo de dependencias
- [ ] Flujos de excepción: input inválido, recurso no encontrado, error de sistema
- [ ] Auditoría / log de operaciones (si requerido)

### UC de tipo consulta / reporte

- [ ] Filtros requeridos implementados
- [ ] Paginación o manejo de grandes volúmenes
- [ ] Performance con volumen real de datos
- [ ] Exportación (si requerida en el UC)

### UC de tipo integración con sistema externo

- [ ] Flujo nominal: datos enviados y recibidos correctamente
- [ ] Manejo de timeout del sistema externo
- [ ] Manejo de respuesta de error del sistema externo
- [ ] Retry logic (si requerido)
- [ ] Idempotencia (si aplica)

### UC de tipo seguridad / autenticación

- [ ] Autenticación funcional con todos los providers (si hay más de uno)
- [ ] Autorización correcta por rol
- [ ] Manejo de sesión expirada
- [ ] Manejo de credenciales inválidas
- [ ] Logging de intentos fallidos

---

## Test coverage thresholds para IOC

| Tipo de test | Cobertura mínima IOC | Notas |
|-------------|---------------------|-------|
| Unit tests | ≥ 70% de cobertura de líneas | En domain / business logic |
| Integration tests | Todos los UC Must Have | End-to-end para cada UC |
| Performance tests | Todos los paths críticos | En entorno staging |
| Security tests | OWASP Top 10 básico | Al menos SQLi, XSS, auth bypass |

> Estos son umbrales mínimos — ajustar al tipo de sistema (sistema crítico de salud necesita más).

---

## Checklist de concurrencia — ¿quiénes deben aprobar el IOC?

| Rol | Aprueba | Criterios que valida |
|-----|---------|---------------------|
| **Product Owner** | Obligatorio | Funcionalidad Must Have, demo review |
| **QA Lead** | Obligatorio | Defect status, test coverage |
| **Arquitecto / Tech Lead** | Obligatorio | Deuda técnica, performance, calidad de código |
| **Project Manager** | Obligatorio | Plan de Transition, cronograma |
| **Usuario beta representativo** | Recomendado | Usabilidad, flujos de negocio |

---

## Señales de IOC fallido (post-hoc)

| Señal en Transition | Causa probable en Construction |
|--------------------|-------------------------------|
| Beta users no pueden usar el sistema | UC Must Have incompletos o buggy |
| Severity 1 en producción el primer día | Severity 1 no resueltos o no detectados en staging |
| Performance falla con usuarios reales | Tests de performance solo en localhost |
| PO rechaza features después del deploy | Demo no fue con usuarios reales |
| Deuda técnica bloquea primeras correcciones | Deuda no documentada ni comunicada |
