# As-Is Process Map — Template

```yml
created_at: [timestamp]
project: [nombre del proyecto]
work_package: [wp-id]
phase: bpa:map
author: [nombre]
status: Borrador
```

---

## Información del proceso

| Campo | Valor |
|-------|-------|
| **Nombre del proceso** | [nombre oficial] |
| **Process Owner** | [nombre + cargo] |
| **Versión del mapa** | 1.0 |
| **Fecha de mapeo** | [YYYY-MM-DD] |
| **Participantes de la sesión** | [lista de personas presentes] |
| **Trigger** | [evento que inicia el proceso] |
| **Output final** | [producto del proceso al terminar] |
| **Tiempo de ciclo total (As-Is)** | [estimado: X horas / X días] |

---

## Swimlanes — actores del proceso

| # | Actor / Swimlane | Descripción del rol en el proceso |
|---|-----------------|----------------------------------|
| 1 | [Actor 1] | [qué hace en el proceso] |
| 2 | [Actor 2] | [qué hace en el proceso] |
| 3 | [Actor 3] | [qué hace en el proceso] |
| 4 | [Sistema / Herramienta] | [qué pasos ejecuta automáticamente] |

---

## Mapa As-Is — flujo nominal

*Representación textual del mapa (complementar con diagrama visual en herramienta dedicada)*

| Step | Actor | Nombre de la actividad | Inputs | Outputs | Tiempo | Decision / Gateway |
|------|-------|----------------------|--------|---------|--------|-------------------|
| 1 | [Actor 1] | [Verbo + objeto] | [qué necesita] | [qué produce] | [X min/h] | — |
| 2 | [Actor 2] | [Verbo + objeto] | [output del step 1] | [qué produce] | [X min/h] | ¿[pregunta de decisión]? |
| 2a | [Actor 2] | [Camino SÍ] | — | — | — | → continúa a step 3 |
| 2b | [Actor 1] | [Camino NO] | — | — | — | → regresa a step 1 |
| 3 | [Actor 3] | [Verbo + objeto] | [inputs] | [outputs] | [X min/h] | — |
| 4 | [Sistema] | [Acción automática] | [inputs] | [outputs] | [X min/h] | — |
| 5 | [Actor 2] | [Paso final] | [inputs] | [Output final del proceso] | [X min/h] | — |

*Notación BPMN usada:*
- **●** Evento inicio (trigger)
- **[ ]** Tarea / actividad
- **◆** Gateway / decisión (Sí/No o múltiples caminos)
- **⊗** Evento fin

*Ver guía BPMN completa: [bpmn-guide.md](../references/bpmn-guide.md)*

---

## Variantes y excepciones

| Variante / Excepción | Trigger | Diferencia con el flujo nominal | Frecuencia estimada |
|---------------------|---------|--------------------------------|-------------------|
| [Nombre de la variante] | [¿cuándo ocurre?] | [qué pasos cambian] | [% de casos o N/mes] |
| [Excepción / Error] | [¿cuándo ocurre?] | [cómo se maneja] | [% de casos] |

---

## Workarounds documentados

*Pasos que el equipo ejecuta en la práctica pero que no están en el procedimiento oficial:*

| Workaround | Actor | Por qué existe | Frecuencia |
|-----------|-------|----------------|-----------|
| [Descripción del workaround] | [quién lo hace] | [por qué el proceso oficial no funciona ahí] | [N/semana o % de casos] |

---

## Datos de tiempo — resumen

| Segmento del proceso | Tiempo de tarea | Tiempo de espera | Tiempo de ciclo parcial |
|---------------------|----------------|-----------------|------------------------|
| [Steps 1-2] | [X h] | [X h] | [X h] |
| [Steps 3-4] | [X h] | [X h] | [X h] |
| [Step 5] | [X h] | [X h] | [X h] |
| **Total** | **[X h]** | **[X h]** | **[X h]** |

---

## Sistemas y herramientas usados

| Sistema / Herramienta | Steps involucrados | Tipo de uso |
|----------------------|-------------------|------------|
| [Nombre del sistema] | [step N, step M] | Entrada de datos / Consulta / Notificación automática |

---

## Observaciones del mapeo

*Hallazgos importantes detectados durante la sesión de mapeo (sin analizar aún — el análisis ocurre en bpa:analyze):*

- [Observación 1: ej. "El step 3 tiene un tiempo de espera de 3-8 días por falta de información en la solicitud inicial"]
- [Observación 2: ej. "El workaround de email manual en step 4 ocurre en el 60% de los casos"]

---

## Validación del mapa

| Validador | Rol | Fecha | Estado | Comentarios |
|-----------|-----|-------|--------|-------------|
| [nombre] | Process Owner | [YYYY-MM-DD] | ✅ Aprobado / ❌ Pendiente | [notas] |
| [nombre] | Ejecutor del proceso | [YYYY-MM-DD] | ✅ Aprobado / ❌ Pendiente | [notas] |
| [nombre] | Ejecutor del proceso | [YYYY-MM-DD] | ✅ Aprobado / ❌ Pendiente | [notas] |
