# Elicitation Techniques — Guía de referencia

> Reference for rm:elicitation. Catálogo de 7 técnicas con protocolos, ventajas, limitaciones y output.

---

## Selección de técnica — árbol de decisión

```
¿Los stakeholders están disponibles para interacción directa?
├── Sí → ¿El proceso existe actualmente?
│         ├── Sí → Observación directa (más confiable que declaraciones)
│         └── No → ¿Muchos stakeholders similares?
│                  ├── Sí → Workshop + Encuesta de validación
│                  └── No → Entrevistas individuales
└── No → ¿Hay documentación del proceso actual?
          ├── Sí → Análisis documental
          └── No → Prototipo + Cuestionario asincrónico
```

---

## 1. Entrevista directa

**Cuando usar:** Stakeholders clave con conocimiento profundo; necesidades complejas que requieren exploración.

**Protocolo de ejecución:**

| Fase | Actividad | Duración |
|------|-----------|----------|
| Preparación | Revisar contexto del stakeholder; preparar 10-15 preguntas abiertas | 30-60 min |
| Apertura | Presentar objetivo; confirmar disponibilidad de tiempo | 5 min |
| Exploración | Preguntas abiertas → profundización → "¿por qué?" | 30-45 min |
| Cierre | Resumir hallazgos; confirmar comprensión; próximos pasos | 10 min |
| Post-sesión | Transcribir notas en máximo 24h | 30-60 min |

**Preguntas guía tipo:**
- "¿Cuál es el mayor problema que tiene hoy con [proceso]?"
- "¿Qué debería poder hacer que hoy no puede?"
- "¿Qué es lo más importante para usted en este sistema?"
- "¿Qué pasa cuando [evento crítico]?"
- "¿Hay algo que no mencioné y que cree importante?"

**Output:** Notas de entrevista + lista de necesidades candidatas
**Ventajas:** Máxima profundidad; permite follow-up inmediato; captura contexto no verbal
**Limitaciones:** Costosa en tiempo; escala mal con > 10 stakeholders; depende de disponibilidad
**Tamaño de muestra:** 3-8 stakeholders por rol representativo

---

## 2. Workshop / Focus Group

**Cuando usar:** Múltiples stakeholders con perspectivas complementarias; alineación temprana deseada; exploración de prioridades conflictivas.

**Protocolo de ejecución:**

| Fase | Actividad | Duración |
|------|-----------|----------|
| Preparación | Definir agenda; seleccionar 6-10 participantes; preparar facilitador + escribano | 2-4h |
| Contexto | Presentar objetivo del workshop y reglas | 15 min |
| Generación | Brainstorming individual (post-its) → agrupar → discutir | 45-60 min |
| Priorización | Votación de necesidades (dot voting / MoSCoW en vivo) | 30 min |
| Validación | Confirmación de entendimiento común; gaps identificados | 15 min |

**Técnicas dentro del workshop:**
- **Brainstorming con post-its** — silencioso primero, luego compartir
- **Role storming** — cada participante habla desde el rol de usuario final
- **Negative brainstorming** — "¿qué debe evitar hacer el sistema?"
- **Dot voting** — cada participante tiene 5-10 "votos" para marcar prioridades

**Output:** Necesidades priorizadas + consenso visible + conflictos expuestos
**Ventajas:** Alineación temprana; eficiencia con múltiples stakeholders simultáneos
**Limitaciones:** Stakeholders dominantes pueden silenciar a otros; necesita facilitador neutro; requiere disponibilidad simultánea
**Tamaño:** 5-10 participantes (máximo 12 antes de que la dinámica se degrade)

---

## 3. Observación directa (Gemba)

**Cuando usar:** Procesos operacionales existentes; cuando lo que "dicen los usuarios" difiere de lo que "hacen los usuarios".

**Protocolo de ejecución:**

| Variante | Cuándo usar | Nivel de participación |
|----------|-------------|----------------------|
| **Pasiva** | Proceso de alta velocidad o rutinario | Solo observar — no interactuar |
| **Activa** | Proceso complejo o poco frecuente | Observar + preguntas en tiempo real |
| **Shadowing** | Proceso de conocimiento distribuido en el tiempo | Seguir al usuario durante su jornada |

**Protocolo pasivo/activo:**
1. Solicitar permiso explícito del stakeholder y su supervisor
2. No interrumpir el flujo del trabajo — observar
3. Registrar: acciones, herramientas usadas, workarounds, excepciones, frustraciones
4. Al terminar: preguntar "¿esto es lo que hace siempre? ¿hay excepciones?"

**Template de notas de observación:**
```
Actor: [nombre o rol]  |  Proceso: [nombre]  |  Fecha/Hora: [timestamp]
Objetivo del proceso: [qué intenta lograr el actor]

Acción observada | Herramienta/Sistema | Workaround | Frustración observada
[A1]             | [sistema]           | [sí/no]    | [descripción]
```

**Output:** Descripción fiel del proceso real (vs proceso documentado)
**Ventajas:** Revela necesidades implícitas y workarounds no articulados; más confiable que declaraciones
**Limitaciones:** Solo aplica a procesos existentes; el observado puede cambiar su comportamiento (efecto Hawthorne); no captura requisitos de nuevas funcionalidades
**Duración:** 1-4h por sesión; repetir en diferentes condiciones (turnos, carga de trabajo)

---

## 4. Encuesta / Cuestionario

**Cuando usar:** Base de stakeholders grande (> 15); validar hipótesis de elicitación directa; priorizar entre opciones ya identificadas.

**Diseño del cuestionario:**

| Tipo de pregunta | Cuándo usar | Ejemplo |
|-----------------|-------------|---------|
| **Likert 1-5** | Medir importancia o satisfacción | "¿Qué tan importante es X para usted? 1=Sin importancia, 5=Crítico" |
| **NPS (0-10)** | Medir satisfacción global | "¿Recomendarías el proceso actual a un colega?" |
| **Opción múltiple** | Categorizar necesidades | "¿Cuál es su principal dificultad hoy? A/B/C/D" |
| **Ranking** | Priorizar entre opciones | "Ordene estas funcionalidades por importancia (1=más importante)" |
| **Abierta** | Capturar lo inesperado | "¿Hay algo más que quisiera que el sistema hiciera?" |

**Reglas de diseño:**
- Máximo 15 preguntas (tasa de abandono aumenta con cada pregunta adicional)
- Una sola idea por pregunta
- Evitar preguntas leading: "¿Está de acuerdo con que X es importante?" → ya asume que lo es
- Incluir siempre una pregunta abierta al final

**Output:** Datos cuantitativos + tendencias de priorización
**Ventajas:** Escala a muchos stakeholders; anónimo → respuestas más honestas
**Limitaciones:** No permite follow-up; preguntas mal diseñadas dan datos inútiles; no captura contexto; respuesta sesgada si los no-respondentes son sistemáticamente diferentes
**Tasa de respuesta esperada:** 30-60% para encuestas internas; 10-20% para externas

---

## 5. Prototipo (Elicitación por reacción)

**Cuando usar:** Stakeholders con dificultad para articular necesidades abstractas; sistema nuevo sin análogo existente.

**Tipos de prototipo para elicitación:**

| Tipo | Fidelidad | Costo | Cuándo usar |
|------|-----------|-------|-------------|
| **Wireframe / boceto en papel** | Muy baja | Mínimo | Primera sesión; conceptos radicalmente nuevos |
| **Mockup estático** | Baja-Media | Bajo | Validar flujos de navegación y estructura |
| **Prototipo clickable** | Media | Medio | Validar flujos completos sin código real |
| **Prototipo funcional (spike)** | Alta | Alto | Validar NFR (performance, integraciones) |

**Protocolo de sesión con prototipo:**
1. Presentar contexto: "Este es un borrador — el objetivo es obtener tu feedback, no mostrarte el producto final"
2. Pedir al stakeholder que piense en voz alta mientras navega
3. NO guiar — observar dónde se confunde, dónde se detiene
4. Al terminar: preguntas abiertas → "¿Qué agregarías? ¿Qué quitarías? ¿Qué te confundió?"

**Output:** Necesidades implícitas reveladas por reacción; confirmación o refutación de supuestos
**Ventajas:** Elicita necesidades que el stakeholder no puede articular verbalmente; detecta malentendidos temprano
**Limitaciones:** Costo de creación; riesgo de que el stakeholder se "enamore" del prototipo y pierda perspectiva crítica; no reemplaza la elicitación de necesidades de negocio

---

## 6. Análisis documental

**Cuando usar:** Hay documentación del proceso actual (manuales, SOPs, reportes, tickets de soporte, logs).

**Tipos de documentos a analizar:**

| Tipo de documento | Qué buscar | Señales de necesidades implícitas |
|------------------|-----------|----------------------------------|
| **SOPs / Manuales de proceso** | Pasos actuales, reglas de negocio explícitas | Workarounds documentados; pasos marcados como "en revisión" |
| **Tickets de soporte / Quejas** | Problemas recurrentes | Top-10 categorías de tickets = candidatos a requisitos |
| **Reportes y dashboards** | Métricas seguidas actualmente | Lo que se mide = lo que importa al negocio |
| **Contratos / SLAs** | Obligaciones formales | Requisitos de performance y disponibilidad no negociables |
| **Sistemas existentes** | Funcionalidad actual | Qué se usa vs qué no se usa |

**Protocolo:**
1. Recopilar y catalogar los documentos disponibles
2. Revisar buscando: reglas de negocio, excepciones, constraints, datos manejados
3. Identificar inconsistencias entre documentos (señal de ambigüedad o proceso no documentado)
4. Crear lista de preguntas para confirmar con stakeholders (el documento puede estar desactualizado)

**Output:** Requisitos candidatos extraídos de fuentes secundarias; base para las entrevistas
**Ventajas:** No requiere disponibilidad de stakeholders; captura reglas de negocio formales
**Limitaciones:** Los documentos pueden estar desactualizados; no captura el proceso real (vs el documentado); no revela necesidades no satisfechas

---

## 7. Análisis de sistemas análogos / Benchmarking

**Cuando usar:** El sistema no existe en la organización pero existen soluciones en el mercado o en otras organizaciones.

**Protocolo:**
1. Identificar 3-5 sistemas análogos (competidores, sistemas similares en otras industrias)
2. Analizar funcionalidades disponibles
3. Categorizar: funcionalidades estándar (presentes en todos) vs diferenciadoras
4. Presentar a stakeholders para clasificar como Must Have / Should Have / Could Have

**Output:** Catálogo de funcionalidades de referencia como punto de partida para requisitos
**Ventajas:** Acelera la elicitación; establece expectativas de mercado
**Limitaciones:** Riesgo de copiar sin adaptar al contexto específico; los stakeholders pueden pedir todo lo que ven; no reemplaza el entendimiento de las necesidades propias

---

## Combinación de técnicas — patrones recomendados

| Contexto del proyecto | Combinación recomendada |
|----------------------|-------------------------|
| Sistema nuevo, stakeholders disponibles | Entrevistas → Workshop → Prototipo |
| Reemplazo de sistema existente | Análisis documental → Observación → Entrevistas |
| Muchos usuarios geográficamente dispersos | Entrevistas (muestra) → Encuesta → Workshop virtual |
| Proceso complejo con muchas excepciones | Observación → Entrevistas focalizadas en excepciones |
| Regulación o compliance obligatorio | Análisis documental → Entrevistas con legal/compliance |
