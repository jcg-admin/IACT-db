# Elicitation Techniques — Guía de Técnicas BABOK

## Selector de técnicas por contexto

| Contexto | Técnica recomendada | Razón |
|---------|--------------------|----|
| Explorar dominio desconocido con pocos stakeholders clave | Entrevistas | Máxima profundidad; flexible |
| Alinear múltiples stakeholders con perspectivas diferentes | Taller JAD | Resuelve conflictos en tiempo real |
| Entender proceso como se ejecuta realmente (no como se dice) | Shadowing | Captura comportamiento real vs declarado |
| Recopilar datos de muchos stakeholders en paralelo | Encuestas | Escala; cuantificable |
| Generar opciones o identificar requisitos en grupo | Brainstorming | Alta participación; muchas ideas |
| Explorar percepciones y actitudes sobre un cambio | Focus Group | Perspectivas diversas; debate |
| Entender estado actual cuando hay documentación existente | Análisis de documentos | No requiere tiempo de stakeholders |

---

## 1. Entrevistas individuales

**Cuándo usar:** Explorar en profundidad con stakeholders de alta influencia o con conocimiento especializado.

| Fase | Actividades |
|------|-------------|
| **Preparación** | Definir objetivos de la entrevista; preparar guía de preguntas; enviar agenda al entrevistado con 2 días de anticipación |
| **Apertura** | Explicar propósito; confirmar que se puede tomar notas; encuadrar que buscamos entender su perspectiva |
| **Desarrollo** | Seguir guía pero ser flexible; profundizar con "¿puede darme un ejemplo?"; capturar textual cuando sea importante |
| **Cierre** | Resumir los 3-5 hallazgos clave; confirmar con el entrevistado; definir cómo se confirmará el resumen |
| **Follow-up** | Enviar resumen en < 48h con pregunta de confirmación: "¿Capturé correctamente tu perspectiva?" |

**Preguntas de apertura efectivas:**
- "¿Puede describirme cómo funciona [proceso] hoy, paso a paso?"
- "¿Cuáles son los problemas más frecuentes que encuentra en [área]?"
- "¿Qué haría diferente si tuviera pleno control sobre [proceso]?"

**Preguntas de profundización:**
- "¿Puede darme un ejemplo concreto de eso?"
- "¿Con qué frecuencia ocurre eso? ¿Qué impacto tiene?"
- "¿Qué pasa cuando ese paso falla?"

**Preguntas que evitar:**
| Tipo | Ejemplo | Por qué evitar | Alternativa |
|------|---------|---------------|------------|
| Sugestiva | "¿No cree que sería mejor automatizar esto?" | Sesga la respuesta | "¿Cómo preferiría gestionar este proceso?" |
| Técnica prematura | "¿Prefiere un dashboard o reportes?" | Invita a hablar de solución antes de entender el problema | "¿Cómo usa hoy la información de X?" |
| Cerrada | "¿El proceso funciona bien?" | Respuesta sí/no; sin insight | "Descríbame el proceso desde el inicio" |
| Doble barril | "¿Prefiere velocidad o calidad?" | Introduce dilema falso | Preguntar por cada dimensión separada |

---

## 2. Talleres JAD (Joint Application Design)

**Cuándo usar:** Alinear 3-8 stakeholders con perspectivas diferentes; resolver conflictos; obtener consenso en tiempo real.

| Fase del taller | Actividades | Duración típica |
|----------------|-------------|-----------------|
| **Preparación** | Definir objetivo concreto; invitar al facilitador; preparar materials (pizarras, post-its, plantillas); enviar pre-reading | 1-3 días antes |
| **Apertura** | Establecer reglas (respeto, celulares, parking lot); confirmar objetivo y agenda; rompehielo si los participantes no se conocen | 15-20 min |
| **Trabajo principal** | Facilitar con técnicas visuales: mapas de proceso, affinity diagrams, dot voting | 2-4 horas |
| **Resolución de conflictos** | Anotar puntos de desacuerdo en parking lot; resolver los que se puedan en el taller; escalar los demás | Variable |
| **Cierre** | Confirmar acuerdos verbalmente; asignar responsables de follow-up; definir próximos pasos | 20-30 min |
| **Post-taller** | Enviar minuta con acuerdos y responsables a todos los participantes en < 24h | — |

**Técnicas visuales para talleres:**

| Técnica | Cuándo usar | Instrucción |
|---------|-------------|-------------|
| **Affinity diagram** | Agrupar muchas ideas por categoría | Escribir ideas en post-its; agrupar por similitud; nombrar grupos |
| **Dot voting** | Priorizar rápidamente entre opciones | Cada participante tiene 3 puntos; votar las opciones más importantes |
| **Process mapping** | Entender el flujo de un proceso | Dibujar swimlanes; marcar roles; identificar decision points |
| **Impact/effort matrix** | Priorizar iniciativas o requisitos | Cuadrante 2×2: impacto vs esfuerzo; quick wins en alto impacto / bajo esfuerzo |

**Señales de un taller mal facilitado:**
- Un stakeholder habla el 70% del tiempo — el facilitador debe distribuir la voz
- Los conflictos no se anotan en parking lot — se pierden puntos de desacuerdo
- No hay acuerdos concretos al cierre — el taller fue conversación, no trabajo de BA
- La minuta tarda > 48h en enviarse — los acuerdos se olvidan o se reinterpretan

---

## 3. Observación / Shadowing

**Cuándo usar:** Entender un proceso como se ejecuta en la práctica, no como los usuarios dicen que lo ejecutan.

| Paso | Descripción | Error frecuente |
|------|-------------|-----------------|
| **Solicitar permiso** | Explicar propósito al usuario y a su supervisor; obtener consentimiento explícito | Shadowing sin aviso — altera comportamiento |
| **Observar sin interrumpir** | Solo tomar notas; no sugerir mejoras durante la observación | Interrumpir con "¿por qué no haces X?" interrumpe el flujo natural |
| **Registrar lo que se hace, no lo que se dice** | Los usuarios verbalizan un proceso idealizado; registrar las acciones reales | Transcribir lo que el usuario dice que hace, no lo que hace |
| **Registrar excepciones** | Notar los "esto normalmente no pasa" y "en este caso especial hago X" | Ignorar las excepciones — son donde están los requisitos más importantes |
| **Preguntar al final** | "¿Hay algo que no hizo hoy que normalmente haría?" | No hacer preguntas post-sesión — se pierde contexto crítico |
| **Confirmar observaciones** | Enviar resumen de lo observado al usuario para validación | Interpretar observaciones sin confirmar |

**Qué registrar en una sesión de shadowing:**

| Elemento | Cómo registrarlo |
|----------|-----------------|
| Secuencia de pasos | Numerados; incluir sistemas usados |
| Workarounds | "El usuario exportó a Excel porque el sistema no filtra por X" |
| Interrupciones | "Llamada de 15 min; proceso pausado y reiniciado" |
| Señales de frustración | "El usuario dijo 'siempre me equivoco aquí' — señal de UX deficiente" |
| Herramientas no oficiales | "Usa una hoja Excel propia para llevar control — sistema no lo ofrece" |

---

## 4. Análisis de documentos

**Cuándo usar:** Entender el estado actual cuando existe documentación: manuales de proceso, políticas, reportes, bases de datos.

| Tipo de documento | Qué buscar | Limitación |
|------------------|-----------|-----------|
| **Manual de procedimientos** | Proceso oficial; roles; reglas de negocio | Puede estar desactualizado; no refleja práctica real |
| **Reportes de negocio** | KPIs actuales; tendencias; anomalías | Solo refleja lo que se mide; lo que no se mide no aparece |
| **Tickets / incidentes** | Problemas frecuentes; workarounds; pain points | Sesgo hacia problemas técnicos; no captura fricción no reportada |
| **Emails / decisiones históricas** | Contexto de por qué se hizo X; restricciones implícitas | Difícil de navegar; requiere acceso |
| **Organigramas** | Roles y responsabilidades formales | No refleja la red informal de decisiones |

**Señales de documentación desactualizada:**
- Fecha de actualización > 2 años
- Describe pasos que los usuarios dicen que "ya no se hacen así"
- Hace referencia a sistemas que ya no existen o a roles que cambiaron
- Los usuarios desconocen la existencia del documento

---

## 5. Encuestas y cuestionarios

**Cuándo usar:** Recopilar datos de > 10 stakeholders; cuantificar frecuencia o impacto; validar hipótesis.

**Diseño de preguntas efectivas:**

| Tipo | Ejemplo | Cuándo usar |
|------|---------|-------------|
| **Escala Likert** | "¿Qué tan fácil es usar el proceso actual? 1-5" | Medir percepción; comparar grupos |
| **Selección múltiple** | "¿Cuáles son sus 3 mayores frustraciones con X?" | Priorizar; no limitar a una respuesta |
| **Ranking** | "Ordene estas capacidades por prioridad" | Establecer prioridades relativas |
| **Texto libre** | "¿Qué cambiaría del proceso actual?" | Capturar perspectivas no anticipadas |
| **Frecuencia** | "¿Con qué frecuencia ocurre este problema?" | Cuantificar; priorizar por frecuencia |

**Buenas prácticas:**
- Máximo 10-15 preguntas — encuestas largas tienen baja tasa de respuesta
- Pilotear con 2-3 personas antes de lanzar para detectar preguntas ambiguas
- Incluir una pregunta abierta final: "¿Hay algo importante que no cubrí?"
- Enviar resultados agregados a los respondientes — aumenta participación en el futuro

---

## 6. Focus Groups

**Cuándo usar:** Explorar percepciones y actitudes de un grupo homogéneo (ej: todos son usuarios finales del mismo proceso).

**Tamaño ideal:** 5-8 participantes (menos → poca diversidad; más → difícil de moderar)

**Diferencia con taller JAD:**
- JAD → decisiones y acuerdos (outcome = consenso)
- Focus Group → explorar perspectivas (outcome = insights)

**Riesgo principal: Groupthink**
- Un participante dominante puede suprimir perspectivas minoritarias
- El moderador debe proactivamente invitar a participantes callados
- Técnica: "¿Alguien tiene una perspectiva diferente a lo que acabamos de escuchar?"

---

## 7. Brainstorming

**Cuándo usar:** Generar muchas opciones o identificar requisitos en grupo sin filtros iniciales.

**Reglas del brainstorming efectivo:**
1. Sin crítica durante la generación de ideas — todo se anota
2. Cantidad sobre calidad en la fase generativa
3. Construir sobre las ideas de otros ("sí, y...")
4. Extraños bienvenidos — las ideas "locas" a veces revelan el requisito real

**Proceso:**
1. Calentamiento (5 min): problema en una oración en el pizarrón
2. Generación silenciosa (5 min): cada participante escribe ideas en post-its
3. Compartir en voz alta (10-15 min): cada uno comparte; el facilitador agrupa
4. Dot voting para priorizar (5 min)
5. Discusión sobre las top ideas (15-20 min)

---

## Combinación de técnicas por tipo de proyecto

| Tipo de proyecto | Técnicas recomendadas | Orden sugerido |
|-----------------|----------------------|----------------|
| Sistema nuevo en dominio desconocido | Entrevistas → Shadowing → JAD | Entender → Observar → Alinear |
| Mejora de sistema existente | Análisis de docs → Entrevistas → Encuesta | Contexto → Perspectiva → Validación |
| Proyecto ágil | JAD (sprint 0) → Entrevistas iterativas | Kickoff → Refinement continuo |
| Proyecto regulatorio | Análisis de docs → Entrevistas de compliance → JAD | Norma → Interpretación → Consenso |
