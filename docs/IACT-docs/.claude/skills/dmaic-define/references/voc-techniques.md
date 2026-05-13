# VOC Techniques — DMAIC:Define

Catálogo de 6 técnicas para recopilar la Voz del Cliente (VOC) y convertirla a CTQs medibles.

---

## Conversión VOC → CTQ

La conversión no es automática — el VOC es ambiguo; los CTQs deben ser específicos y medibles.

```
VOC (qué dice el cliente)
    ↓
Necesidad (qué necesita realmente — el por qué detrás del VOC)
    ↓
CTQ (cómo se mide — métrica observable con especificación)
```

### Tabla de conversión VOC → Necesidad → CTQ

| VOC (declaración del cliente) | Necesidad subyacente | CTQ (métrica medible) | Especificación |
|-------------------------------|---------------------|----------------------|----------------|
| *"Los pedidos llegan tarde"* | Entrega puntual | % pedidos en fecha prometida | ≥ 95% |
| *"Nunca sé en qué estado está mi pedido"* | Visibilidad del estado | % pedidos con tracking actualizado ≤ 4h | ≥ 98% |
| *"El producto llega dañado"* | Integridad del producto | % pedidos sin daño visible | ≥ 99.5% |
| *"El proceso de aprobación es muy lento"* | Velocidad de aprobación | Tiempo ciclo aprobación (días) | ≤ 2 días hábiles |
| *"Los errores en facturas son frecuentes"* | Precisión de facturación | % facturas sin error | ≥ 99% |

### Trampas comunes en la conversión

| Error | Ejemplo | Corrección |
|-------|---------|------------|
| CTQ sin unidad medible | "Alta calidad" | Definir qué se mide: tasa de defectos, score NPS, % dentro de spec |
| CTQ que es una solución | "Implementar sistema automatizado" | Reformular como métrica del proceso: "tiempo de procesamiento ≤ X" |
| VOC de una sola fuente | Entrevista a 1 cliente clave | Validar con múltiples fuentes antes de declarar CTQ |
| Necesidades latentes ignoradas | Solo capturar quejas explícitas | Usar Gemba y observación directa para descubrir necesidades no articuladas |

---

## Las 6 técnicas VOC

### 1. Entrevistas directas

**Cuándo usar:** Siempre que sea posible. Mayor profundidad y capacidad de seguimiento.

**Cómo ejecutar:**
- Preguntas abiertas (no cerradas): *"¿Qué es más importante para usted?"*, *"¿Cuándo se siente insatisfecho?"*, *"¿Puede describir un ejemplo reciente?"*
- Evitar preguntas que guían la respuesta: *"¿Le gustaría recibir sus pedidos más rápido?"* (respuesta obvia = sí)
- Documentar citas textuales — la conversión a CTQ ocurre después, no durante la entrevista
- Muestra mínima recomendada: 5-8 entrevistas por segmento de cliente para saturación de temas

**Output:** Transcripciones o notas con citas textuales + análisis temático de hallazgos comunes.

**Limitaciones:** Tiempo intensivo; puede tener sesgo de selección (solo clientes que aceptan participar); el cliente puede decir lo que cree que el entrevistador quiere escuchar.

---

### 2. Encuestas y cuestionarios

**Cuándo usar:** Base de clientes grande; validar hipótesis de CTQs con datos cuantitativos; priorizar entre múltiples CTQs candidatos.

**Cómo ejecutar:**
- Estructura recomendada: preguntas de importancia (¿qué tan importante es X para usted?) + preguntas de satisfacción (¿qué tan satisfecho está con el desempeño actual?)
- Escala Likert 1-5 o NPS
- Regla de oro: preguntar sobre comportamientos pasados, no sobre intenciones futuras (*"¿Cuántas veces llamó a soporte el mes pasado?"* > *"¿Llamaría si tuviera un problema?"*)
- Muestra mínima: ≥ 30 para inferencia estadística básica; ≥ 100 para segmentación por subgrupos

**Output:** Distribución de importancia × satisfacción por atributo; identificación de CTQs con alta importancia / baja satisfacción (zona de oportunidad).

**Limitaciones:** No captura las razones detrás de los puntajes; diseño deficiente contamina resultados; tasa de respuesta baja puede generar sesgo de no-respuesta.

---

### 3. Análisis de quejas y reclamos

**Cuándo usar:** Datos históricos disponibles; punto de partida rápido antes de técnicas primarias.

**Cómo ejecutar:**
1. Exportar tickets, emails, llamadas de soporte del período de análisis
2. Categorizar por tipo de problema (usar categorías mutuamente excluyentes y exhaustivas)
3. Cuantificar frecuencia por categoría
4. Calcular % acumulado → aplicar Pareto para identificar los tipos más frecuentes
5. Convertir los 3-5 tipos más frecuentes a CTQs candidatos

**Output:** Pareto de tipos de queja; CTQs candidatos con frecuencia base.

**Limitaciones:** Solo representa a clientes que se quejaron (iceberg de insatisfacción); las categorías del sistema de tickets pueden no reflejar la necesidad real del cliente; no sustituto del VOC directo.

---

### 4. Gemba — observación directa

**Cuándo usar:** Procesos operacionales donde el comportamiento real difiere del declarado; cuando los clientes no pueden articular sus necesidades.

**Cómo ejecutar:**
- Ir *donde* el cliente usa el producto/servicio — no solo revisar reportes o dashboards
- Observar sin intervenir ni guiar: el objetivo es ver el comportamiento natural
- Documentar: qué hace el cliente, cuándo se frustra, qué busca, qué preguntas hace, qué da por sentado
- Tomar fotos o video (con autorización)
- Debriefing inmediato después de la observación

**Output:** Lista de comportamientos observados; frustraciones detectadas; hipótesis de necesidades latentes.

**Limitaciones:** Tiempo intensivo; el observador puede alterar el comportamiento observado (efecto Hawthorne); requiere acceso al proceso real.

---

### 5. Focus groups

**Cuándo usar:** Explorar percepciones y actitudes antes de una encuesta masiva; entender el lenguaje del cliente para diseñar instrumentos de medición.

**Cómo ejecutar:**
- 6-8 participantes por sesión (menos no genera suficiente diversidad; más es inmanejable)
- Moderador neutral — no debe defender el producto ni guiar respuestas
- Guía de discusión estructurada: de preguntas generales a específicas
- Registrar dinámicas grupales (quién influye a quién) además del contenido
- No usar como sustituto de datos cuantitativos — el focus group genera hipótesis, no valida

**Output:** Percepciones comunes; lenguaje del cliente; temas emergentes para investigar con encuestas.

**Limitaciones:** Sesgo de liderazgo (un participante dominante puede sesgar al grupo); no representativo estadísticamente; costoso de ejecutar correctamente.

---

### 6. Datos de soporte y sistemas internos

**Cuándo usar:** Datos ya recopilados por la organización; punto de partida rápido; complemento a VOC primario.

**Cómo ejecutar:**
- Tickets de soporte, NPS histórico, registros de devoluciones, auditorías de calidad
- Analizar tendencias temporales: ¿el problema aumenta / disminuye / es estacional?
- Cruzar con datos de negocio: ¿los clientes con más quejas tienen mayor churn?
- Identificar segmentos: ¿algunos grupos de clientes tienen más problemas que otros?

**Output:** Baseline cuantitativo del problema antes de salir a campo; priorización inicial de CTQs.

**Limitaciones:** Datos del pasado — pueden no reflejar la situación actual; las categorías internas pueden no coincidir con las necesidades reales del cliente; no captura necesidades no reportadas.

---

## Criterios de calidad del VOC recopilado

Antes de convertir VOC a CTQs, verificar:

| Criterio | Pregunta de verificación | ¿Cumple? |
|----------|--------------------------|---------|
| **Múltiples fuentes** | ¿Se usó más de una técnica o segmento? | ✅ / ❌ |
| **Datos directos** | ¿Hay al menos una técnica de VOC primario (entrevistas, encuestas, Gemba)? | ✅ / ❌ |
| **Muestra suficiente** | ¿La muestra cubre variedad de segmentos y contextos? | ✅ / ❌ |
| **Necesidades, no soluciones** | ¿Los hallazgos describen lo que el cliente necesita, no lo que pide? | ✅ / ❌ |
| **Cuantificado** | ¿Se puede priorizar por frecuencia o impacto? | ✅ / ❌ |

Si algún criterio no se cumple, documentar la brecha y planificar recolección adicional en Measure.
