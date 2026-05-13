# Team Management — Guía de referencia

> Reference for pm:executing. 5 técnicas de resolución de conflictos PMBOK, gestión de equipos, escalación de issues.

---

## 5 Técnicas de resolución de conflictos (PMBOK)

### Técnica 1: Collaborating / Problem Solving (Win-Win)

**Cuándo usar:** Cuando el tiempo lo permite y la relación a largo plazo importa; conflictos sobre soluciones técnicas; equipos de alta performance.

**Proceso:**
1. Identificar los intereses reales de cada parte (no las posiciones)
2. Generar opciones que satisfagan los intereses de ambas partes
3. Evaluar opciones con criterios objetivos
4. Acordar solución

**Resultado:** Ambas partes satisfechas. Solución sostenible.

**No usar cuando:** Urgencia extrema o conflicto de valores incompatibles.

---

### Técnica 2: Compromising (Lose-Lose partial)

**Cuándo usar:** Cuando ambas partes tienen poder equivalente; cuando no hay solución perfecta; cuando la velocidad importa más que la optimización.

**Proceso:** Cada parte cede algo. El resultado es aceptable para ambas pero no ideal para ninguna.

**Resultado:** Acuerdo rápido. Ninguna parte completamente satisfecha.

**Señal de abuso:** Si el equipo siempre compromete, las decisiones son mediocres acumuladas.

---

### Técnica 3: Accommodating / Smoothing (Lose-Win)

**Cuándo usar:** Cuando la relación es más importante que el punto de disputa; cuando una parte está claramente equivocada pero conceder no afecta el proyecto; cuando se necesita capital político para conflictos futuros.

**Proceso:** Una parte cede por completo al otro punto de vista.

**Resultado:** Rápido. La parte que cede puede quedar con resentimiento si se abusa.

**Señal de abuso:** Una persona siempre cede → riesgo de burnout o salida del equipo.

---

### Técnica 4: Forcing / Directing (Win-Lose)

**Cuándo usar:** Emergencia (safety, regulatorio); cuando una parte tiene autoridad formal y el tiempo no permite deliberación; cuando las otras técnicas fallaron.

**Proceso:** La persona con autoridad toma la decisión unilateralmente.

**Resultado:** Rápido. Puede generar resentimiento. Daña la colaboración si se usa frecuentemente.

**Regla del PM:** Usar como último recurso. Documentar el motivo de la decisión directiva.

---

### Técnica 5: Avoiding / Withdrawing (Lose-Lose)

**Cuándo usar:** Cuando el conflicto es trivial y se resolverá solo; cuando ambas partes necesitan tiempo para calmarse; cuando el PM no tiene información suficiente.

**Proceso:** Posponer o retirarse del conflicto sin resolverlo.

**Resultado:** Ninguna acción. El conflicto puede escalar si no se resuelve.

**Señal de abuso:** Conflictos no resueltos que reaparecen repetidamente.

---

## Selector de técnica por contexto

| Contexto | Técnica recomendada |
|----------|-------------------|
| Decisión técnica (front vs back, arquitectura) | Collaborating → si no resuelve en 2 sesiones, escalate |
| Deadline urgente, conflicto menor | Forcing (PM decide) |
| Conflicto interpersonal leve | Accommodating o Avoiding (temporal) |
| Prioridades del backlog | Compromising (si stakeholders iguales) → Sponsor si no |
| Conflicto de alcance (scope) | Collaborating → CCB si no resuelve |
| Conflicto de recursos (quién hace qué) | RACI → PM decide si ambiguo |

---

## Escalation path — cuándo escalar al sponsor

| Situación | Acción del PM |
|-----------|--------------|
| Issue no resuelto en 2 semanas | Escalar al sponsor con opciones de solución |
| CR con impacto en scope/presupuesto > 10% | CCB + aprobación de sponsor |
| Conflicto entre stakeholders de alto poder | Escalar a sponsor para arbitraje |
| Risk materializado con impacto crítico | Notificación inmediata al sponsor |
| Miembro clave del equipo en riesgo de salida | Escalar a manager de línea + sponsor |

---

## Issue Log — gestión efectiva

| Campo | Propósito | Valores |
|-------|-----------|---------|
| **Issue ID** | Identificación única | ISS-NNN |
| **Descripción** | Qué ocurre y cómo impacta al proyecto | Texto |
| **Fecha de apertura** | Cuándo se detectó | YYYY-MM-DD |
| **Asignado a** | Quién es responsable de resolverlo | Nombre |
| **Prioridad** | Urgencia | Alta / Media / Baja |
| **Estado** | Dónde está en el pipeline | Abierto / En progreso / En escalación / Cerrado |
| **Fecha objetivo** | Cuándo debe estar resuelto | YYYY-MM-DD |
| **Resolución** | Cómo se resolvió (solo si cerrado) | Texto |

**Regla de prioridad:**
- **Alta:** Bloquea el critical path o compromete un milestone en < 1 semana
- **Media:** Impacta a un miembro del equipo o un deliverable no crítico
- **Baja:** Molestia o mejora de proceso que no bloquea trabajo

---

## QA vs QC — distinción operativa

| Aspecto | Quality Assurance (QA) | Quality Control (QC) |
|---------|----------------------|---------------------|
| Enfoque | Proceso | Producto |
| Objetivo | Prevenir defectos | Detectar defectos |
| Cuándo | Durante el proyecto (paralelo) | Sobre deliverables completados |
| Responsable | PM + equipo | QA specialist / testers |
| Output | Auditoría de proceso + recomendaciones | Defect log + métricas |

**QA en Executing:**
- Auditar si el proceso de desarrollo sigue los estándares definidos en Planning
- Verificar que los change requests pasan por el CCB
- Confirmar que la documentación se actualiza cuando cambia el código

**QC en Executing:**
- Testing de cada deliverable antes de aceptación
- Revisión de código (code review)
- Inspección de documentos entregables

---

## Scope Creep — señales y control

### Señales de scope creep

| Señal | Causa probable | Acción |
|-------|---------------|--------|
| Trabajo "pequeño" que se hace sin CR | Cultura de "es solo un cambio minor" | Recordatorio de proceso CCB; umbral claro de qué requiere CR |
| El equipo trabaja en features no planeadas | Stakeholders contactan directamente al equipo | Redirigir al PM; comunicar el plan de proyecto |
| El schedule se extiende sin cambio formal | Scope creep acumulado | Auditoría de scope; CR retroactivo |
| "Ya que estamos, añadimos X" frecuente | Oportunismo | Backlog para versión futura; formalizar con CR |

### Umbral de change request

| Cambio | Requiere CR? | Quién aprueba |
|--------|-------------|--------------|
| Corrección de bug en deliverable acordado | No | PM (documentar en issue log) |
| Nueva feature | Sí | CCB (Sponsor si afecta scope) |
| Cambio de diseño sin impacto en schedule/cost | Sí (minor) | PM |
| Cambio con impacto > 5% schedule o costo | Sí (mayor) | Sponsor |
| Cambio de scope significativo | Sí (crítico) | Sponsor + re-baseline |
