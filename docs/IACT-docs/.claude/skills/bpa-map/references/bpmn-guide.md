# BPMN Guide — BPA:Map

Guía de notación BPMN (Business Process Model and Notation) para mapeo de procesos As-Is y To-Be.

---

## Qué es BPMN y por qué usarlo

BPMN es el estándar internacional (ISO 19510) para representar procesos de negocio de forma visual. Ventajas sobre diagramas ad-hoc:
- **Lenguaje compartido** — todos los actores leen el mismo diagrama
- **Notación inequívoca** — formas específicas para eventos, tareas y decisiones
- **Herramienta-agnóstico** — funciona en Visio, Miro, Lucidchart, draw.io, BPMN.io

---

## Elementos BPMN — referencia rápida

### Events (Eventos) — círculos

Los eventos representan algo que ocurre en el proceso.

| Símbolo | Tipo | Cuándo usar |
|---------|------|-------------|
| ○ (círculo vacío, borde fino) | **Start Event** | Inicio del proceso — qué lo dispara |
| ○ (círculo con mensaje) | **Message Start Event** | El proceso inicia al recibir un mensaje / solicitud |
| ○ (círculo con reloj) | **Timer Start Event** | El proceso inicia en un horario programado |
| ◎ (círculo doble) | **Intermediate Event** | Algo ocurre durante el proceso (espera, señal) |
| ● (círculo con borde grueso) | **End Event** | Fin del proceso |
| ⊗ (círculo con X y borde grueso) | **Error End Event** | El proceso termina en error |

**Regla:** Cada proceso tiene exactamente 1 Start Event. Puede tener múltiples End Events (un happy path y uno para cada excepción).

---

### Tasks (Tareas) — rectángulos

Las tareas representan unidades de trabajo realizadas por un actor.

| Símbolo | Tipo | Cuándo usar |
|---------|------|-------------|
| [ Nombre ] (rectángulo simple) | **User Task** | Trabajo realizado por una persona |
| [ Nombre ] ⚙ | **Service Task** | Trabajo ejecutado automáticamente por un sistema |
| [ Nombre ] ✉ | **Send Task** | Enviar un mensaje / notificación |
| [ Nombre ] ✉ recibir | **Receive Task** | Esperar y recibir un mensaje |
| [ Nombre ] ↺ | **Loop Task** | Tarea que se repite (ej: revisar hasta aprobar) |

**Convención de nomenclatura:** Siempre verbo + objeto en la tarea.
- ✅ "Revisar solicitud de crédito"
- ❌ "Solicitud" (sin verbo)
- ❌ "El ejecutivo comercial revisa la solicitud de crédito del cliente" (demasiado largo — máx. 5 palabras)

---

### Gateways (Decisiones) — rombos

Los gateways representan puntos de bifurcación o convergencia del flujo.

| Símbolo | Tipo | Cuándo usar |
|---------|------|-------------|
| ◆ (rombo vacío) | **Exclusive Gateway (XOR)** | Solo uno de los caminos se toma (Sí/No, Aprobado/Rechazado) |
| ◆ (rombo con +) | **Parallel Gateway (AND)** | Todos los caminos se ejecutan simultáneamente |
| ◆ (rombo con O) | **Inclusive Gateway (OR)** | Uno o más caminos se ejecutan según condición |

**El gateway más común en BPA es el Exclusive (XOR):**
- Pregunta siempre en el rombo: *"¿Aprobado?"*, *"¿Dentro del límite?"*
- Etiquetar cada salida con la condición: "Sí / No", "Aprobado / Rechazado / Pendiente más info"
- NUNCA dejar un gateway sin etiquetar sus salidas

---

### Pools y Lanes (Contenedores) — rectángulos grandes

| Elemento | Descripción | Cuándo usar |
|----------|-------------|-------------|
| **Pool** | Contenedor de todo el proceso (organizacion/empresa) | Cuando el proceso involucra más de una organización |
| **Lane (Swimlane)** | Subdivide el Pool por actor / rol / departamento | Siempre — es la unidad de organización básica del mapa |

**Convenciones de Lanes:**
- El nombre del Lane identifica el actor responsable de las tareas en ese carril
- Las tareas dentro de un Lane son responsabilidad del actor del Lane
- Las flechas que cruzan Lanes representan handoffs (pasos de responsabilidad)
- Los handoffs son puntos de riesgo — donde más frecuentemente aparecen esperas y pérdidas de información

---

### Sequence Flows (Flujos de secuencia) — flechas

| Símbolo | Tipo | Cuándo usar |
|---------|------|-------------|
| → (flecha sólida) | **Sequence Flow** | Conexión entre actividades en el mismo proceso |
| - - → (flecha punteada) | **Message Flow** | Comunicación entre dos Pools distintos |
| - - - → (flecha punteada gris) | **Association** | Vincular un artefacto (anotación, datos) a una tarea |

---

## Patrones BPMN comunes en BPA

### Patrón 1: Aprobación simple

```
[Presentar solicitud] → ◆¿Aprobada?◆ → Sí → [Notificar aprobación] → ●
                                       → No → [Solicitar correcciones] → (regresa a Presentar solicitud)
```

### Patrón 2: Proceso paralelo (AND)

```
[Recibir pedido] → ◆+◆ → [Verificar stock]
                         → [Verificar crédito]
                  ◆+◆ ← (ambos completan) → [Confirmar pedido] → ●
```

### Patrón 3: Escalada por tiempo

```
[Revisar solicitud] → ◎(Timer: 48h sin respuesta) → [Escalar a supervisor] → ...
                    → [Aprobar] → ...
```

---

## Errores comunes en BPMN

| Error | Descripción | Corrección |
|-------|-------------|-----------|
| **Gateway sin salidas etiquetadas** | El rombo tiene flechas sin condición | Etiquetar cada salida con la condición (Sí/No, Aprobado/etc.) |
| **Tarea con nombre ambiguo** | "Procesamiento" sin verbo claro | Usar verbo + objeto: "Procesar formulario de solicitud" |
| **Flujo sin conector de cierre en loop** | El ciclo de revisión no tiene condición de salida | Agregar gateway con condición de salida: "¿Completo?" → Sí/No |
| **Lane sin nombre** | Swimlane anónimo | Siempre nombrar el Lane con el actor responsable |
| **Múltiples Start Events** | El proceso tiene 2 inicios diferentes | Consolidar en 1 Start Event con gateway si hay múltiples triggers |
| **Proceso sin End Event** | El mapa termina sin evento de fin | Agregar End Event; si hay excepciones, agregar Error End Event |
| **Tareas en el nivel del Pool** | Tareas fuera de un Lane | Siempre poner tareas dentro de un Lane específico |

---

## Niveles de fidelidad BPMN en BPA

| Nivel | Cuándo usar | Elementos incluidos |
|-------|-------------|---------------------|
| **Nivel 1 — Descriptivo** | Sesión inicial de mapeo, alignment con stakeholders no técnicos | Start/End Events, Tasks, XOR Gateways, Lanes |
| **Nivel 2 — Analítico** | Análisis As-Is para identificar VA/NVA | Todo el Nivel 1 + tiempos, datos adjuntos, variantes |
| **Nivel 3 — Ejecutable** | Automatización con BPM engine (Camunda, Flowable) | Notación completa BPMN 2.0 con atributos técnicos |

> Para BPA en este framework, el Nivel 2 es suficiente. El Nivel 3 solo si el To-Be incluye automatización con motor BPM.

---

## Herramientas recomendadas

| Herramienta | Tipo | Ideal para |
|-------------|------|-----------|
| **Miro / Mural** | Colaborativo online | Sesiones de mapeo en tiempo real con equipo |
| **draw.io (diagrams.net)** | Desktop / web, gratuito | Diagramas BPMN formales con librería nativa |
| **BPMN.io (bpmn.io)** | Web, open source | BPMN 2.0 puro, exporta a XML estándar |
| **Lucidchart** | Web, pago | Integración con Confluence/Google Docs |
| **Pizarrón físico** | Presencial | Primera sesión de mapeo — mayor velocidad de iteración |

**Recomendación para BPA:** Comenzar en pizarrón físico o Miro (velocidad), luego formalizar en draw.io o BPMN.io (precisión y documentación).
