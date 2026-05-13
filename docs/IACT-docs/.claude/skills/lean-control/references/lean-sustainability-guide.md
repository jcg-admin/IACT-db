# Lean Sustainability Guide — Sostenibilidad de mejoras Lean

Guía para sostener las mejoras implementadas en Kaizen events: gestión visual, Standard Work, Yokoten, A3 thinking y gestión de desviaciones.

---

## Por qué las mejoras Lean se pierden

La regresión post-Kaizen es el riesgo más común en proyectos Lean. Las causas más frecuentes:

| Causa de regresión | Frecuencia | Cómo prevenirla |
|-------------------|-----------|----------------|
| Sin Standard Work documentado | Alta | Documentar el estándar en el Día 5 del Kaizen; no negociable |
| Sin plan de auditorías 5S | Alta | Definir frecuencia y responsable antes de cerrar el Kaizen |
| Process Owner sin compromiso | Media | Involucrar al Process Owner desde el Día 1 del Kaizen |
| Presión de producción que lleva a saltarse el estándar | Alta | Hacer visible el costo de la regresión en el A3 |
| Personal nuevo no entrenado en el estándar | Media | Incluir el estándar en el onboarding del proceso |
| El estándar es difícil de seguir | Media | Si hay desviaciones sistemáticas, revisar el estándar — puede ser defectuoso |

---

## Standard Work — la base de la sostenibilidad

El Standard Work es el documento que define "cómo se hace el trabajo correctamente" en el proceso mejorado.

### Componentes del Standard Work

**1. Takt Time**
```
Takt Time = [X] minutos/unidad
Interpretación: el proceso debe completar 1 [unidad] cada [X] minutos
```

**2. Secuencia de trabajo estándar**

| Paso | Actividad | Tiempo estándar | Notas críticas |
|------|-----------|----------------|---------------|
| 1 | [Primera actividad del operador] | [X min] | [Punto de calidad, precaución] |
| 2 | [Segunda actividad] | [X min] | |
| 3 | [Tercera actividad] | [X min] | |

**3. WIP estándar**
```
Items en proceso simultáneamente: [N] — este es el WIP límite del proceso mejorado
Lógica: con [N] items en proceso, el lead time objetivo se cumple al Takt Time
```

**4. Puntos de calidad (Jidoka)**

| Punto en el proceso | Qué verificar | Criterio de aceptación | Qué hacer si falla |
|--------------------|--------------|----------------------|-------------------|
| [Paso X] | [Qué se verifica] | [Criterio cuantificable] | [Acción — parar, ajustar, escalar] |

### Cómo publicar y usar el Standard Work

1. **Publicar en el punto de uso** — el estándar debe estar visible donde el trabajo ocurre, no en una carpeta compartida
2. **Formato visual** — diagramas o fotos son más efectivos que texto
3. **Versión controlada** — incluir fecha de última actualización y quién lo aprobó
4. **Entrenamiento de nuevos miembros** — el Standard Work es el documento base para el onboarding

---

## Gestión Visual — hacer el estado del proceso visible

La gestión visual elimina la necesidad de preguntar "¿cómo vamos?" — el estado del proceso es visible a primera vista.

### Jerarquía de controles visuales

**Nivel 1 — Estado del proceso en tiempo real**
- Tablero de producción: plan vs real por turno/día
- Tablero Kanban: qué está en proceso, qué está bloqueado, qué está terminado
- Gráfica de Lead Time: puntos por item completado vs línea de objetivo

**Nivel 2 — Estado del estándar**
- Fotografía del estado objetivo 5S publicada en el área
- Standard Work visible en el punto de uso
- WIP limits marcados visualmente en el tablero Kanban

**Nivel 3 — Estado de las mejoras (tendencia)**
- Gráfica de Control de Lead Time o CT (últimas 4 semanas)
- Score 5S histórico
- % de cumplimiento del plan vs real

### Protocolo de gestión visual diaria

```
Inicio del turno/día (15 minutos):
1. Revisar tablero Kanban — ¿hay items bloqueados?
2. Revisar tablero de producción — ¿el plan de ayer se cumplió?
3. Identificar desviaciones del día anterior — ¿qué pasó?
4. Definir foco del día — ¿qué waste está activo?

Fin del turno/día (10 minutos):
1. Actualizar tablero de producción (plan vs real)
2. Documentar desviaciones en log
3. Confirmar que el área está en estado 5S
```

---

## A3 Thinking — gestión y comunicación de mejoras

El A3 (hoja de papel A3) es el vehículo de comunicación Lean para mejoras, problemas y decisiones.

### Cuándo usar A3

| Situación | Tipo de A3 | Sección clave |
|-----------|-----------|--------------|
| Cierre de Kaizen event | A3 de resultados | Baseline vs resultados, acciones pendientes |
| Problema o desviación recurrente | A3 de problema | Análisis de causa raíz + contramedidas |
| Propuesta de mejora | A3 de propuesta | Análisis de situación + opciones + recomendación |
| Revisión de sostenibilidad (lean:control) | A3 de revisión | Tendencia de métricas + plan de sostenibilidad |

### A3 de revisión de sostenibilidad — estructura

```
┌──────────────────────────┬──────────────────────────────────┐
│ 1. CONTEXTO              │ 5. RESULTADOS ACTUALES           │
│ [Proceso y proyecto]     │ [Métricas As-Is vs To-Be vs Hoy] │
│ [Goal Statement]         │ [Score 5S histórico]             │
├──────────────────────────┤ [Tendencia del lead time]        │
│ 2. ESTADO ACTUAL         │                                  │
│ [Métricas baseline]      ├──────────────────────────────────┤
│ [VSM As-Is resumido]     │ 6. ANÁLISIS DE DESVIACIONES      │
│                          │ [Si hay gap: ¿por qué?]          │
├──────────────────────────┤ [Log de desviaciones recientes]  │
│ 3. OBJETIVO              │                                  │
│ [Goal Statement]         ├──────────────────────────────────┤
│ [Métricas To-Be]         │ 7. PLAN DE SOSTENIBILIDAD        │
│                          │ [Frecuencia de auditorías]       │
├──────────────────────────┤ [Responsables de control]        │
│ 4. RESUMEN DE KAIZENS    │ [Próximo hito de revisión]       │
│ [Mejoras implementadas]  │ [Yokoten si aplica]              │
│ [Herramientas usadas]    │                                  │
└──────────────────────────┴──────────────────────────────────┘
```

---

## Yokoten — despliegue horizontal de mejoras

Yokoten significa "propagar horizontalmente" — el mecanismo Lean para que los aprendizajes de un proceso beneficien a otros.

### Proceso de Yokoten

**Paso 1: Identificar candidatos**
- ¿Qué otros procesos en la organización tienen el mismo tipo de waste?
- ¿El Standard Work desarrollado es aplicable con adaptaciones menores?
- ¿El mismo equipo opera múltiples procesos similares?

**Paso 2: Presentar el aprendizaje**

| Elemento de la presentación | Contenido |
|---------------------------|-----------|
| Problema original | Waste que se eliminó + magnitud |
| Solución implementada | Herramienta Lean usada + cómo se implementó |
| Resultados | Antes vs después con datos |
| Transferibilidad | Cómo adaptar al proceso receptor |
| Recursos requeridos | Tiempo estimado para replicar |

**Paso 3: Adaptar, no copiar**
- El Standard Work del proceso original es una referencia, no una plantilla directa
- El proceso receptor puede tener restricciones o variaciones que requieren ajustes
- El Process Owner del proceso receptor debe estar convencido de la relevancia antes de iniciar

**Paso 4: Nuevo Kaizen event en el proceso receptor**
- Si el waste se confirma en el proceso receptor, agendar un Kaizen event específico
- El equipo del Kaizen original puede participar como soporte (no como responsables)

---

## Gestión de desviaciones — protocolo de respuesta

### Clasificación de desviaciones

| Tipo | Descripción | Respuesta |
|------|-------------|-----------|
| **Ocasional** | Desviación puntual sin patrón; el equipo la corrige solo | Registrar en log; sin acción formal |
| **Recurrente** | Misma desviación aparece 3+ veces | Análisis 5 Whys de la regresión; acción correctiva formal |
| **Sistémica** | El proceso opera consistentemente fuera del estándar | Mini-Kaizen event; revisar si el estándar es defectuoso |
| **Regresión total** | El proceso regresó al estado As-Is | Escalar al Sponsor; Kaizen event de refuerzo |

### Log de desviaciones — guía de uso

El log de desviaciones debe ser:
- **Simple**: una línea por desviación; sin formularios complejos
- **Visible**: accesible para el equipo operacional, no solo para el Lean Champion
- **Accionable**: cada entrada tiene un responsable y una fecha límite
- **Revisado semanalmente**: en la reunión de stand-up del equipo

### Señal de estándar defectuoso

Si las desviaciones son sistemáticas y el equipo no las puede corregir, puede ser que el estándar sea difícil de seguir:

| Señal | Interpretación | Acción |
|-------|---------------|--------|
| > 50% del equipo no sigue el paso X | El paso X no es claro o es innecesariamente complejo | Revisar y simplificar el paso X |
| Desviaciones aumentan cuando hay carga alta | El estándar requiere demasiado tiempo para el Takt Time | Rebalancear o eliminar NVA del proceso |
| Solo el personal experimentado sigue el estándar | El estándar no está bien documentado visualmente | Mejorar el soporte visual del Standard Work |
