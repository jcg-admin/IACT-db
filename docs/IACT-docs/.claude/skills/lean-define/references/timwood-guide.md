# TIMWOOD Guide — Los 8 Desperdicios Lean

Guía de referencia para identificar, diagnosticar y priorizar los 8 tipos de desperdicio (MUDA) en procesos de manufactura y servicios.

---

## Los 8 desperdicios TIMWOOD

### T — Transportation (Transporte innecesario)

**Definición:** Mover materiales, productos, datos o información más de lo necesario para completar el proceso.

**Síntomas:**
- Documentos que pasan por múltiples áreas antes de ser procesados
- Doble registro del mismo dato en diferentes sistemas
- Materiales que viajan largas distancias entre pasos consecutivos
- Handoffs frecuentes entre equipos para una misma tarea
- Emails de "reenvío" con información que debería estar en un solo lugar

**Causas raíz comunes:**
- Layout de proceso no orientado al flujo
- Sistemas de información desconectados (data silos)
- Departamentos organizados por función, no por flujo de valor
- Falta de estándar de entrega entre pasos

**Herramientas de mejora principales:** Rediseño del layout, VSM To-Be con flujo continuo, integración de sistemas

---

### I — Inventory (Inventario excesivo)

**Definición:** Acumular más trabajo en progreso (WIP), materiales o información de lo que el siguiente paso puede procesar inmediatamente.

**Síntomas:**
- Colas visibles de items esperando procesamiento
- Materiales comprados con anticipación a la demanda real
- Backlog de tickets/solicitudes que crece sin resolverse
- Reportes generados pero no revisados oportunamente
- Trabajo "casi terminado" acumulado antes de una aprobación

**Causas raíz comunes:**
- Sistema push (producir según forecast) en lugar de pull (producir según demanda real)
- Sin límites WIP en el proceso
- Lotes de producción grandes en lugar de flujo pieza a pieza
- Incertidumbre sobre la demanda que lleva a sobreproducir

**Herramientas de mejora principales:** Kanban, Pull system, reducción de tamaño de lote

---

### M — Motion (Movimiento innecesario)

**Definición:** Movimientos innecesarios de personas (no de materiales — ese es Transportation) durante la realización del trabajo.

**Síntomas:**
- Operadores que buscan herramientas o materiales frecuentemente
- Navegación entre múltiples sistemas para completar una tarea
- Desplazamientos físicos para buscar información o aprobaciones
- Clicks/pasos extra en sistemas por diseño de interfaz deficiente
- Operadores alejados de los materiales que necesitan

**Causas raíz comunes:**
- Falta de organización del espacio de trabajo (sin 5S)
- Información dispersa en múltiples sistemas
- Layout de trabajo no ergonómico o no orientado al flujo
- Herramientas en ubicaciones no estándar

**Herramientas de mejora principales:** 5S, organización del espacio de trabajo, optimización de layout

---

### W — Waiting (Espera)

**Definición:** Tiempo en que el proceso o las personas están idle esperando el siguiente paso, una aprobación, información o un equipo.

**Síntomas:**
- Aprobaciones que tardan días cuando podrían tardar horas
- Operadores idle esperando que un equipo termine su ciclo
- Dependencias entre equipos que crean bloqueos frecuentes
- Reuniones de coordinación frecuentes para resolver dependencias
- El cuello de botella del VSM tiene CT > Takt Time

**Causas raíz comunes:**
- Sin señal visual de que hay trabajo pendiente
- Proceso sin pull system (no hay señal de cuándo producir)
- Cuello de botella no identificado ni balanceado
- Setup times largos que crean esperas
- Aprobaciones seriales en lugar de paralelas

**Herramientas de mejora principales:** Balanceo de línea al Takt Time, Kanban, SMED, Andon

---

### O — Overproduction (Sobreproducción)

**Definición:** Producir más, más rápido o antes de lo que el cliente o el siguiente paso necesita.

**Síntomas:**
- Reportes generados que nadie lee
- Features de software no solicitados ni usados
- Lotes de producción mucho mayores que la demanda inmediata
- Comunicaciones enviadas antes de que el receptor pueda actuar sobre ellas
- "Trabajo preventivo" que no reduce riesgo real

**Causas raíz comunes:**
- Proceso orientado a maximizar utilización de recursos en lugar de flujo
- Sin visibilidad de la demanda real del cliente
- Incentivos por volumen producido (no por valor entregado)
- Miedo a la escasez que lleva a producir de más

**Herramientas de mejora principales:** Pull system, Heijunka (nivelación), Kanban, reducción de batch size

---

### O — Overprocessing (Sobreprocesamiento)

**Definición:** Aplicar más procesamiento del que el cliente necesita o valora. Hacer más de lo requerido.

**Síntomas:**
- Pasos de revisión/aprobación redundantes
- Formularios con campos que nadie usa
- Software con features que el usuario final nunca usa
- Documentación más detallada de lo que el lector necesita
- Actividades realizadas "siempre así" sin razón documentada

**Causas raíz comunes:**
- Definición de valor no alineada con el cliente real
- Procesos nunca revisados desde su creación
- Cultura de "mejor prevenir" sin análisis de valor real
- Sin VOC que defina qué es suficiente

**Herramientas de mejora principales:** Eliminación de actividades NVA, simplificación de estándares, VOC para redefinir "suficiente"

---

### D — Defects (Defectos y reproceso)

**Definición:** Producir items, documentos o servicios que no cumplen los requisitos y requieren corrección, descarte o retrabajo.

**Síntomas:**
- Pasos de inspección/verificación visibles en el proceso
- % de reproceso > 5%
- Clientes que devuelven items o reportan errores frecuentemente
- Retrabajo predecible y aceptado como "normal"
- Doble verificación sistemática (indica falta de confianza en el proceso)

**Causas raíz comunes:**
- Sin estándares de calidad en el punto de producción
- Inspección al final del proceso (demasiado tarde para prevenir)
- Inputs de baja calidad del proceso upstream
- Falta de Poka-yoke en pasos críticos
- Presión por velocidad que compromete la calidad

**Herramientas de mejora principales:** Jidoka, Poka-yoke, Standard Work, 5S para entorno controlado

---

### T* — Talent no aprovechado (MUDA 8 — extendido)

**Definición:** Habilidades, conocimiento y experiencia del equipo que no son utilizadas por el proceso o la organización.

**Síntomas:**
- Operadores con ideas de mejora que nunca se implementan
- Personas haciendo tareas muy por debajo de su capacidad
- Ausencia de sistema de sugerencias o el sistema existe pero nadie usa
- Expertos en proceso excluidos de decisiones sobre el proceso
- Alta rotación en áreas con trabajo repetitivo sin enriquecimiento

**Causas raíz comunes:**
- Cultura de gestión top-down sin participación del equipo operacional
- Falta de sistema de sugerencias funcional
- Incentivos que no reconocen las contribuciones de mejora
- Sin tiempo asignado para actividades de mejora (solo producción)

**Herramientas de mejora principales:** Sistemas de sugerencias Kaizen, empowerment del equipo, rotación de roles

---

## Matriz de priorización de desperdicios

Al identificar múltiples wastes, priorizar según:

| Criterio | Peso | Descripción |
|----------|------|-------------|
| Impacto en Lead Time | 40% | ¿Qué % del LT se eliminaría? |
| Impacto en Costo | 30% | ¿Cuánto $ se ahorraría anualmente? |
| Esfuerzo de eliminación | 20% | ¿Cuánto tiempo/recursos requiere? (invertido — menos esfuerzo = mejor score) |
| Riesgo de no actuar | 10% | ¿Qué pasa si este waste persiste? |

**Regla práctica:** atacar primero los wastes de alta visibilidad y alta frecuencia — son los que el equipo puede ver y eliminar con mayor confianza.

---

## Diferencia clave: TIMWOOD en Lean vs Sigma Lean

| Aspecto | Lean puro | Lean Six Sigma |
|---------|-----------|----------------|
| Enfoque de análisis | Identificar y eliminar wastes visible | Eliminar wastes + reducir variación estadística |
| Herramienta principal | VSM + Kaizen | VSM + DMAIC + herramientas estadísticas |
| Cuándo usar TIMWOOD solo | Wastes son visibles y cuantificables sin estadística | — |
| Cuándo combinar con DMAIC | Defectos con variación estadística compleja | Cuando la causa raíz requiere análisis de variación |
