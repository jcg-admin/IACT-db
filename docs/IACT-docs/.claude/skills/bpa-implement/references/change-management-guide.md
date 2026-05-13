# Change Management Guide — BPA:Implement

Cómo comunicar cambios de proceso, ejecutar el plan de training, gestionar resistencia y planificar el rollback.

---

## Por qué el change management es parte del BPA

Un proceso rediseñado técnicamente correcto puede fallar en implementación por:
- El equipo no entiende por qué cambió el proceso
- El equipo no fue entrenado en el nuevo flujo
- El equipo no tiene a quién consultar cuando encuentra un caso raro
- Los líderes no modelan el nuevo comportamiento

El change management no es un "nice to have" — es la diferencia entre un proceso que el equipo adopta y un documento que nadie sigue.

---

## Framework de comunicación del cambio

### Estructura del mensaje de cambio

Para cualquier cambio de proceso, el mensaje debe responder estas 4 preguntas en orden:

| Pregunta | Contenido | Error común |
|----------|-----------|-------------|
| **¿Qué cambia?** | Descripción concreta del cambio — qué pasos desaparecen, qué pasos nuevos hay | Describir solo el resultado final sin el cambio específico |
| **¿Por qué cambia?** | El problema que resolvía el As-Is y cómo el To-Be lo mejora | Omitir el "por qué" → el equipo lo percibe como capricho gerencial |
| **¿Qué no cambia?** | Las partes del proceso que se mantienen igual | No decirlo → el equipo asume que todo cambió y entra en modo de incertidumbre total |
| **¿Qué necesito hacer yo?** | Instrucciones concretas para el ejecutor: cuándo empieza, dónde está el SOP, a quién preguntar | Dejar al equipo adivinando cómo participar en el cambio |

### Canales de comunicación por audiencia

| Audiencia | Canal recomendado | Frecuencia | Mensaje clave |
|-----------|------------------|-----------|--------------|
| **Equipo ejecutor** | Reunión presencial/virtual + email de seguimiento | 1 semana antes del Go-Live + recordatorio 1 día antes | Qué cambia, training, canal de soporte |
| **Management** | Briefing ejecutivo | 2 semanas antes del Go-Live | Métricas del piloto, riesgos, fecha de Go-Live |
| **Clientes / Usuarios externos** | Email personalizado o nota en portal | 1 semana antes si el proceso afecta la experiencia del cliente | Qué cambia para ellos, qué beneficio reciben |
| **Soporte / Helpdesk** | Sesión de briefing | 3 días antes del Go-Live | Qué preguntas recibirán, cómo responder, a quién escalar |

### Plantilla de comunicación — email al equipo

```
Asunto: Actualización importante: [Nombre del proceso] cambia el [fecha]

Hola equipo,

A partir del [fecha de Go-Live], vamos a operar [nombre del proceso] de una manera diferente.

QUÉ CAMBIA:
- [Cambio 1: descripción concreta]
- [Cambio 2: descripción concreta]
- [Cambio 3: descripción concreta]

POR QUÉ CAMBIA:
[Problema que resolvía el proceso antiguo: ej. "El proceso actual tarda en promedio 8 días; 
el nuevo proceso reduce esto a 2-3 días eliminando las aprobaciones en cadena que 
detectaban 0 errores en el último año."]

QUÉ NO CAMBIA:
- [Lo que permanece igual]

LO QUE NECESITO DE TI:
1. Asistir al training el [fecha] a las [hora]
2. Leer el SOP: [link]
3. Usar el nuevo proceso para TODAS las solicitudes a partir del [fecha]

Si tienes dudas: [canal de soporte — ej. canal #proceso-credito en Slack o email a nombre@empresa.com]

[Firma del Process Owner / Manager]
```

---

## Plan de Training

### Principios del training efectivo

1. **El "por qué" antes del "cómo"** — El equipo adopta mejor cuando entiende el problema que resuelve el cambio
2. **Práctica, no solo presentación** — Una sesión teórica sin ejercicios prácticos se olvida en 48h
3. **Casos reales del contexto propio** — Usar ejemplos del proceso real del equipo, no genéricos
4. **Soporte post-training** — El entrenamiento no termina con la sesión; continúa con soporte durante las primeras semanas

### Estructura del training

| Sección | Contenido | Tiempo |
|---------|-----------|--------|
| **Contexto** | Por qué cambió el proceso — problema en As-Is, beneficio en To-Be | 10-15 min |
| **Walkthrough del To-Be** | Recorrer el nuevo mapa paso a paso | 20-30 min |
| **Demostración** | El facilitador ejecuta el proceso con un caso real de ejemplo | 15 min |
| **Práctica guiada** | El equipo ejecuta 1-2 casos de ejemplo con soporte del facilitador | 20-30 min |
| **Excepciones comunes** | Los 3-5 casos especiales más frecuentes | 10 min |
| **Q&A** | Espacio abierto de preguntas | 15 min |
| **Recursos disponibles** | Dónde está el SOP, quién es el punto de contacto | 5 min |

### Job Aid — guía de 1 página por rol

Para cada rol que ejecuta el proceso, crear una guía de 1 página:

```
ROL: [nombre del rol]
PROCESO: [nombre del proceso]

MIS PASOS:
[ ] Paso X → [instrucción de 1 línea]
[ ] Paso Y → [instrucción de 1 línea]
[ ] Paso Z → [instrucción de 1 línea]

DECISIONES QUE TOMO:
Si [condición A] → [acción A]
Si [condición B] → [acción B]

CUANDO ALGO NO ENCAJA: [contacto y canal de escalada]
SOP completo: [link]
```

---

## Gestión de resistencia al cambio

### Tipos de resistencia y cómo abordarlos

| Tipo de resistencia | Señal | Abordaje |
|---------------------|-------|---------|
| **Resistencia por falta de información** | "No entiendo por qué cambia esto" | Comunicar el "por qué" claramente; repetir el contexto si es necesario |
| **Resistencia por pérdida de control** | "Antes yo decidía, ahora el sistema decide" | Validar que el rol sigue siendo valioso; explicar cómo el cambio les beneficia a ellos |
| **Resistencia por carga adicional de adaptación** | "Ya tengo mucho trabajo, ahora tengo que aprender esto también" | Reconocer la carga; ofrecer soporte directo durante las primeras semanas |
| **Resistencia de influenciador negativo** | Un miembro del equipo que expresa resistencia activa y genera dudas en otros | Conversación 1:1 con el manager; involucrar al influenciador en el proceso de mejora si es posible |
| **Resistencia legítima** | "Esto no va a funcionar porque [razón técnica válida]" | Escuchar y evaluar; ajustar el diseño si la resistencia señala un problema real |

**Señal de alerta:** Si la resistencia es generalizada (> 30% del equipo expresa dudas), considerar pausar el Go-Live y hacer una sesión adicional de Q&A antes de continuar.

### Modelo ADKAR para cambio individual

Asegurarse de que cada ejecutor tenga:
- **A**wareness — sabe que el proceso cambia y por qué
- **D**esire — quiere ejecutar el nuevo proceso (o al menos entiende que debe hacerlo)
- **K**nowledge — sabe cómo ejecutar el nuevo proceso
- **A**bility — puede ejecutarlo correctamente (ha practicado)
- **R**einforcement — recibe feedback positivo cuando lo hace bien

---

## Plan de Rollback

### Cuándo activar el rollback

El rollback es el plan para regresar al proceso As-Is si el To-Be falla durante el piloto.

**Criterios de activación de rollback:**

| Criterio | Umbral de activación |
|----------|---------------------|
| Tiempo de ciclo To-Be > As-Is | Si después de 2 semanas, el To-Be es más lento que el As-Is |
| Tasa de error > 2× la baseline As-Is | Si los errores se multiplican al implementar el nuevo proceso |
| Escaladas al Process Owner > N/semana | Si el equipo necesita intervención frecuente para casos que deberían ser rutinarios |
| Sistema crítico no disponible | Si una automatización clave del To-Be no está funcionando |

### Elementos del plan de rollback

| Elemento | Descripción |
|----------|-------------|
| **Quién decide el rollback** | Nombre y cargo del responsable de tomar la decisión |
| **Cómo se comunica** | Email + reunión de equipo el mismo día de la decisión |
| **Restaurar el proceso As-Is** | Pasos concretos: re-activar formularios antiguos, redirigir solicitudes, restablecer accesos |
| **Qué pasa con los datos del piloto** | Cómo manejar las solicitudes en proceso al momento del rollback |
| **Qué se aprende** | Documentar las causas del rollback para el rediseño en la siguiente iteración |

### Template de plan de rollback

```
PLAN DE ROLLBACK — [Nombre del proceso]

Decisor: [nombre + cargo]
Período de validez: [desde Go-Live hasta fecha X]

Criterios de activación:
- [ ] Tiempo de ciclo To-Be > As-Is por más de 2 semanas
- [ ] Tasa de error > [umbral]
- [ ] [Criterio específico del proceso]

Pasos de rollback:
1. [Paso concreto — ej: notificar al equipo dentro de las 4 horas siguientes a la decisión]
2. [Paso — ej: restaurar acceso al formulario As-Is en SharePoint]
3. [Paso — ej: redirigir solicitudes recibidas por el canal To-Be al canal As-Is]
4. [Paso — ej: registrar qué solicitudes están en proceso y asignarlas manualmente]
5. [Paso — ej: documentar las causas del rollback en el WP]

Duración máxima del rollback antes de segunda iteración: [X semanas]
```

---

## Métricas de adopción post Go-Live

Además de las métricas de proceso (tiempo de ciclo, tasa de error), medir la adopción:

| Métrica de adopción | Cómo medir | Objetivo |
|--------------------|-----------|---------| 
| **% de casos ejecutados con el nuevo proceso** | Auditoría de sistema o muestra | ≥ 90% en semana 4 post Go-Live |
| **N° de escaladas por proceso no claro** | Registro del Process Owner | < 3/semana en semana 2 |
| **Satisfacción del equipo ejecutor** | Encuesta corta (3 preguntas) en semana 4 | Score ≥ 3.5/5 |
| **Consultas al SOP** | Analíticas de documento si aplica | Tendencia a la baja (indica internalización) |
