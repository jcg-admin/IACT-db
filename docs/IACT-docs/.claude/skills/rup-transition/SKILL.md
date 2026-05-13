---
name: rup-transition
description: "Use when deploying the system to end users in RUP. rup:transition — deploy to production, conduct user acceptance, resolve critical defects, reach PD milestone for formal product release."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["RUP transition", "PD milestone", "product release RUP", "UAT user acceptance", "beta deployment"]
updated_at: 2026-04-17 00:00:00
---

# /rup-transition — RUP: Transition

> *"Transition is not just deployment — it's the transfer of ownership from the project team to the users and operations team. The product release is a milestone, not the end."*

Ejecuta la fase **Transition** de RUP. Despliega el sistema a usuarios reales, conduce la aceptación del usuario, resuelve defectos identificados post-beta, y obtiene el milestone **PD (Product Release)** para el cierre formal del proyecto.

**THYROX Stage:** Stage 11 TRACK/EVALUATE / Stage 12 STANDARDIZE.

**Milestone:** PD — Product Release.

---

## Pre-condición

Requiere: `{wp}/rup-construction.md` con:
- IOC alcanzado (funcionalidad beta lista, Severity 1 = 0)
- Deuda técnica documentada y acotada
- Performance cumpliendo NFR en staging

---

## Cuándo usar este paso

- Cuando el IOC de Construction está alcanzado
- Para cada ciclo de corrección post-beta (nueva iteración de Transition)
- Cuando los usuarios beta identificaron defectos críticos que requieren un nuevo beta antes del release final

## Cuándo NO usar este paso

- Sin IOC alcanzado — Transition con defectos críticos pendientes garantiza una experiencia de usuario negativa que daña la adopción
- Si el sistema ya está en producción y aceptado — PD fue alcanzado; iniciar el Stage siguiente THYROX

---

## Tabla de intensidad de disciplinas en Transition

| Disciplina | Intensidad en Transition | Foco principal |
|-----------|-------------------------|----------------|
| Business Modeling | Nula | Dominio ya modelado |
| Requirements | Baja | Solo cambios críticos encontrados en beta |
| Analysis & Design | Baja | Correcciones puntuales de defectos |
| Implementation | Media | Bug fixes, ajustes post-beta |
| Test | **Alta** | UAT, regression testing, performance en producción |
| Deployment | **Alta** | Release management, rollout plan |
| Config & Change Mgmt | **Alta** | Change freeze, hotfix process |
| Project Management | Media | Seguimiento de defectos, comunicación con stakeholders |
| Environment | Media | Preparación del entorno de producción |

---

## Actividades

### 1. Preparar el deployment

Antes de desplegar a producción o al entorno beta:

| Elemento | Contenido | Criterio de completitud |
|----------|-----------|------------------------|
| **Deployment Plan** | Pasos de instalación, configuración, rollback | Probado en staging por alguien distinto al que lo escribió |
| **Release Notes** | Nuevas features, defectos corregidos, breaking changes, instrucciones de migración | Revisado por el PO o sponsor |
| **Rollback Plan** | Cómo revertir si el deployment falla | Tiempo de rollback estimado y probado |
| **Communication Plan** | A quién notificar, cuándo, con qué mensaje | Stakeholders + usuarios + soporte informados con anticipación |
| **Support documentation** | FAQs, guías de usuario, runbooks de operaciones | Disponible antes del deployment |

### 2. Beta release y User Acceptance Testing (UAT)

El beta testing con usuarios reales es el corazón de Transition:

| Actividad | Descripción | Artefacto |
|-----------|-------------|-----------|
| **Selección de usuarios beta** | Representativos del usuario real — no solo el equipo de desarrollo | Lista de usuarios beta con roles |
| **Plan de UAT** | Scenarios de prueba basados en los UC críticos del Vision Document | UAT Plan con casos por UC |
| **Ejecución de UAT** | Usuarios ejecutan los scenarios y reportan defectos | UAT Results con defectos encontrados |
| **Clasificación de defectos** | Severity 1 (crítico), 2 (mayor), 3 (menor), 4 (cosmético) | Defect log con prioridad |
| **Feedback de usabilidad** | Observar a los usuarios usando el sistema — no solo preguntar | Notas de observación + grabaciones si aplica |

**Severidad de defectos:**

| Severity | Definición | Acción en Transition |
|----------|-----------|---------------------|
| **1 — Critical** | Sistema inusable; pérdida de datos; funcionalidad crítica rota | Corregir antes del PD — no negociable |
| **2 — Major** | Feature importante no funciona; workaround muy costoso | Corregir si es posible antes del PD; documentar si se difiere |
| **3 — Minor** | Feature funciona pero con limitaciones; workaround existe | Puede deferirse a release posterior |
| **4 — Cosmetic** | Estético o de UX menor | Diferir a release posterior |

**Priorización intra-severidad — cuando hay múltiples defectos del mismo nivel:**

| Criterio de priorización | Descripción | Peso |
|--------------------------|-------------|------|
| **Frecuencia de impacto** | ¿Cuántos usuarios o flujos afecta? (alto = más usuarios afectados) | Alto |
| **Bloqueo de UC crítico** | ¿Bloquea un UC Must Have del Vision Document? | Alto |
| **Costo de corrección** | ¿Qué tan complejo es corregir? (menor costo → antes) | Medio |
| **Disponibilidad de workaround** | ¿Hay forma alternativa de completar el flujo? (sin workaround → antes) | Medio |
| **Risk de regresión** | ¿La corrección puede introducir nuevos defectos? (alto risk → más tarde) | Bajo |

> **Regla:** Dentro de Severity 1 y Severity 2, priorizar por frecuencia de impacto × bloqueo de UC crítico. No corregir Severity 2 antes de que todos los Severity 1 estén cerrados.

### 3. Training y transferencia de conocimiento

| Audiencia | Contenido | Formato |
|-----------|-----------|---------|
| **Usuarios finales** | Cómo usar el sistema para sus tareas principales | Guía de usuario + sesión de training |
| **Equipo de operaciones** | Cómo mantener, monitorear y responder a incidentes | Runbook + sesión técnica |
| **Equipo de soporte** | Preguntas frecuentes, problemas conocidos, escalación | FAQ + troubleshooting guide |
| **Sponsor / negocio** | Qué entregó el proyecto vs lo prometido en el business case | Reporte de entrega |

### 4. Lecciones aprendidas del proyecto RUP completo

Al alcanzar el PD, documentar lecciones por fase y por disciplina:

| Dimensión | Preguntas |
|-----------|-----------|
| **Inception** | ¿La visión fue correcta? ¿El business case fue realista? ¿Los riesgos identificados fueron los correctos? |
| **Elaboration** | ¿El Architecture Prototype probó los riesgos correctos? ¿El SAD fue útil durante Construction? |
| **Construction** | ¿El plan de iteraciones fue realista? ¿La deuda técnica fue manejada bien? ¿La velocidad fue consistente? |
| **Transition** | ¿El sistema fue bien recibido por los usuarios? ¿El deployment fue sin problemas? ¿El UAT reveló surpresas? |
| **Proceso RUP** | ¿Cuáles disciplinas generaron más valor? ¿Qué se hubiera podido simplificar? |

### 5. Cierre formal del proyecto

| Acción | Descripción |
|--------|-------------|
| **Product Acceptance Sign-off** | Documento formal donde el sponsor/cliente acepta el sistema entregado |
| **Archivado de artefactos** | Vision Document, SAD, Use Case Model, Risk List final, UAT Results |
| **Release del equipo** | Miembros del equipo asignados a otros proyectos |
| **Post-implementation review** | 30-60 días después del deployment: ¿el sistema cumple el business case? |

---

## Criterio de milestone PD — ¿cerrar o nueva iteración?

**Alcanzar PD (todos los siguientes deben cumplirse):**
1. Sistema desplegado en producción (o entorno objetivo final)
2. Defectos Severity 1 = 0 en producción
3. Usuarios finales aceptaron formalmente (Product Acceptance Sign-off)
4. Training completado para usuarios y equipo de operaciones
5. Documentación completa y entregada

**Nueva iteración de Transition (cualquiera de los siguientes):**
- Ciclo de correcciones post-beta con defectos Severity 1 o 2 significativos
- Nueva beta requerida antes del release final (UAT reveló problemas mayores)
- Stakeholders rechazan el Product Acceptance Sign-off con justificación

---

## Artefacto esperado

`{wp}/rup-transition.md` — usar template: [transition-report-template.md](./assets/transition-report-template.md)

---

## Red Flags — señales de Transition mal ejecutada

- **Transition como segundo proyecto de correcciones** — si Transition se extiende más de 20% del esfuerzo total del proyecto, los defectos son demasiados y Construction no fue completada correctamente
- **UAT sin usuarios reales** — *"el equipo de QA hizo el UAT"* no es UAT; los usuarios finales deben usar el sistema
- **PD sin Product Acceptance Sign-off formal** — *"el cliente dijo que estaba bien por email"* no es aceptación formal del sistema
- **Training pospuesto post-deployment** — usuarios que no saben usar el sistema en el primer día generan una primera impresión negativa difícil de revertir
- **Lecciones aprendidas omitidas por presión de cierre** — las lecciones aprendidas son el activo más valioso para el próximo proyecto RUP; no omitirlas
- **Defectos Severity 2 acumulados sin priorizar** — si hay muchos Severity 2 diferidos, la experiencia del usuario en producción será degradada; planificar una primera release de mantenimiento

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: rup:transition
flow: rup
rup_phase: transition
rup_iteration: 1
```

**Al COMPLETAR** (PD alcanzado):
```yaml
methodology_step: rup:transition  # completado → RUP cerrado
flow: rup
rup_phase: transition
rup_iteration: [N]
```

## Siguiente paso

- PD alcanzado → RUP completado; iniciar Stage siguiente THYROX (TRACK/EVALUATE o STANDARDIZE)
- PD no alcanzado → nueva iteración de `rup:transition` con lecciones documentadas

---

## Limitaciones

- La aceptación de usuarios no garantiza el éxito a largo plazo — monitorear métricas de adopción y satisfacción 30-90 días después del deployment
- Defectos encontrados post-deployment en producción (no en staging) revelan limitaciones del entorno de prueba — mejorar la paridad staging/producción para el próximo proyecto
- El período post-PD de soporte inmediato (hypercare) no está cubierto en este skill — planificarlo como actividad de operaciones separada

---

## Reference Files

### Assets
- [transition-report-template.md](./assets/transition-report-template.md) — Template completo: plan de deployment, UAT results, defect log, training, lecciones aprendidas RUP completo, Product Acceptance Sign-off, checklist PD

### References
- [pd-criteria.md](./references/pd-criteria.md) — Criterios de evaluación PD: sistema en producción, Severity 1=0, Product Acceptance Sign-off, training completo, user acceptance criteria, límites de tiempo para Transition
