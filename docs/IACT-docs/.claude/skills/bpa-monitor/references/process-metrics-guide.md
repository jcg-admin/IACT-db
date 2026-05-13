# Process Metrics Guide — BPA:Monitor

Cómo definir KPIs de proceso, calcular baseline, establecer umbrales de alerta y configurar ciclos de revisión.

---

## Principios de métricas de proceso

### Los 5 criterios de un buen KPI de proceso

| Criterio | Descripción | Pregunta de validación |
|----------|-------------|----------------------|
| **Relevante** | Ligado a una brecha del Gap Analysis o al objetivo del proceso | ¿Esta métrica refleja algo que el cliente o el negocio valora? |
| **Medible** | Fuente de datos concreta y disponible | ¿Tenemos los datos ahora o podemos obtenerlos? |
| **Accionable** | Cuando el KPI se desvía, hay algo que hacer | ¿Qué haríamos diferente si este KPI está fuera del umbral? |
| **Con dueño** | Una persona responsable de actualizar y actuar | ¿Quién es responsable de este KPI? |
| **Oportuno** | Frecuencia de medición que permite actuar antes de que el problema se agrave | ¿Con qué frecuencia necesitamos saber el estado? |

---

## Tipos de métricas de proceso

### Métricas de tiempo

Las métricas de tiempo son las más fundamentales — reflejan directamente el desempeño del proceso.

| Métrica | Definición | Cómo calcular | Cuándo usar |
|---------|------------|--------------|-------------|
| **Tiempo de ciclo total** | Tiempo desde el trigger hasta el output final | Timestamp fin − Timestamp inicio | Siempre — es la métrica más importante |
| **Tiempo de tarea** | Tiempo activo trabajando en el proceso (sin esperas) | Suma de tiempos de actividad VA + BVA | Cuando se quiere medir la eficiencia real del trabajo |
| **Tiempo de espera** | Tiempo entre actividades — en cola, esperando | Tiempo de ciclo − Tiempo de tarea | Cuando las esperas son el problema principal |
| **Tiempo de respuesta** | Desde que el cliente solicita hasta que recibe respuesta inicial | Timestamp primera respuesta − Timestamp solicitud | En procesos orientados al cliente externo |
| **Variabilidad del ciclo** | Desviación estándar del tiempo de ciclo | Calcular SD sobre muestra de instancias | Cuando la consistencia es tan importante como el promedio |

**Cómo calcular el baseline de tiempo:**
```
Baseline = Media del tiempo de ciclo de las últimas N instancias As-Is
N recomendado: mínimo 30 instancias para estabilidad estadística
Si N < 30: usar como estimación con rango ± 30%
```

**Cómo establecer el target de tiempo:**
```
Target = Baseline × (1 - % mejora esperada del Gap Analysis)
Ejemplo: Baseline = 8 días, Gap Analysis proyecta 60% reducción → Target = 3.2 días
```

---

### Métricas de calidad

| Métrica | Definición | Cómo calcular | Cuándo usar |
|---------|------------|--------------|-------------|
| **Tasa de error** | % de instancias con al menos un error | (N instancias con error / N total) × 100 | Cuando los errores son el problema principal |
| **Tasa de retrabajo** | % de instancias que requieren repetir al menos un paso | (N con retrabajo / N total) × 100 | Cuando el retrabajo es la fuente de demora |
| **First Time Right (FTR)** | % de instancias completadas correctamente a la primera | (N completadas sin error / N total) × 100 | Complementario a tasa de error; más positivo |
| **Tasa de excepción** | % de instancias que salen del flujo nominal | (N excepciones / N total) × 100 | Cuando las excepciones son costosas o de alto riesgo |
| **Tasa de escalada** | % de instancias escaladas a un nivel superior | (N escaladas / N total) × 100 | Cuando las escaladas son señal de complejidad o error |

---

### Métricas de eficiencia

| Métrica | Definición | Cómo calcular |
|---------|------------|--------------|
| **Costo por transacción** | Costo total del proceso / N instancias | (Horas persona × costo hora + costos directos) / N |
| **Throughput** | N instancias procesadas por unidad de tiempo | N instancias / período (día, semana, mes) |
| **Utilización de recursos** | % del tiempo de un recurso usado en el proceso | Horas activas / Horas disponibles × 100 |

---

### Métricas de satisfacción

| Métrica | Definición | Cómo medir |
|---------|------------|-----------|
| **Satisfacción del ejecutor** | Cómo evalúa el equipo ejecutor el proceso | Encuesta mensual de 3-5 preguntas, escala 1-5 |
| **NPS del proceso** | ¿Recomendarías este proceso si dependiera de ti? | Escala 0-10; NPS = % promotores − % detractores |
| **Satisfacción del cliente** | Cómo evalúa el cliente el resultado del proceso | Encuesta o NPS al cliente externo post-interacción |

---

## Cómo definir umbrales de alerta

Los umbrales de alerta determinan cuándo el KPI requiere acción:

### Método 1 — Basado en el Gap (recomendado)

```
Umbral verde (en target): KPI ≤ Target × 1.1  (10% de tolerancia sobre el target)
Umbral amarillo (riesgo): Target × 1.1 < KPI ≤ Baseline × 0.8
Umbral rojo (crítico):    KPI > Baseline × 0.8  (más cercano al As-Is que al To-Be)
```

**Ejemplo:**
- Baseline As-Is: 8 días
- Target To-Be: 3 días

| Umbral | Rango | Acción |
|--------|-------|--------|
| Verde | ≤ 3.3 días | Ninguna |
| Amarillo | 3.4 – 6.4 días | Monitorear + investigar tendencia |
| Rojo | ≥ 6.5 días | Escalada inmediata al Process Owner |

### Método 2 — Basado en percentiles (cuando hay alta variabilidad)

Usar el percentil 80 de las últimas N mediciones como umbral:
```
Umbral amarillo = P80 de las mediciones de las últimas 4 semanas
Umbral rojo = P95 de las mediciones de las últimas 4 semanas
```

---

## Cadencia de revisión

### Revisión semanal (operacional)

**Objetivo:** Detectar incidentes y desviaciones puntuales rápidamente.
**Contenido:** Estado de KPIs clave, alertas activas, incidents de la semana.
**Audiencia:** Process Owner + equipo ejecutor (15-20 minutos).
**Trigger de acción:** KPI en umbral amarillo por 2+ semanas → escalada a análisis.

### Revisión mensual (táctica)

**Objetivo:** Evaluar tendencias y decidir ajustes.
**Contenido:** Tendencias de 4 semanas, comparación vs. baseline, desviaciones persistentes.
**Audiencia:** Process Owner + manager del área (30-45 minutos).
**Trigger de acción:** KPI en rojo por 2+ semanas → análisis de causa raíz y plan de acción.

### Revisión trimestral (estratégica)

**Objetivo:** Evaluar si el proceso alcanzó los objetivos del ciclo BPA y si se necesita un nuevo ciclo.
**Contenido:** Comparación completa As-Is vs. To-Be, lecciones aprendidas, oportunidades identificadas.
**Audiencia:** Process Owner + sponsor + management (60 minutos).
**Trigger de acción:** Identificar si se inicia un nuevo ciclo BPA (identify → map → analyze → design → implement).

---

## Cómo interpretar tendencias

| Patrón | Interpretación | Acción |
|--------|---------------|--------|
| KPI mejora sostenidamente hacia el target | El proceso To-Be está funcionando como se esperaba | Continuar monitoreando; celebrar con el equipo |
| KPI estable en el target | El proceso está estabilizado | Reducir frecuencia de revisión; próxima revisión trimestral |
| KPI oscila pero permanece en zona verde | Variabilidad normal | Monitorear; si persiste, investigar fuente de variabilidad |
| KPI empeora gradualmente (semana a semana) | Degradación del proceso — posible workaround o erosión del SOP | Observación directa del proceso; revisar si el equipo sigue el SOP |
| KPI mejora y luego vuelve al As-Is | El cambio fue temporal (ej: esfuerzo extra inicial) | Investigar si el cambio se institucionalizó realmente |
| KPI empeora abruptamente | Incidente externo o cambio no planificado | Identificar el incidente; ajustar si es sistémico |

---

## Fuentes de datos comunes

| Tipo de proceso | Fuente de datos típica | Métrica |
|----------------|----------------------|---------|
| Proceso de aprobación | Sistema workflow (JIRA, ServiceNow) | Tiempo de ciclo por ticket |
| Proceso transaccional | ERP / CRM | Tiempo entre estados, tasa de rechazo |
| Proceso de atención al cliente | CRM, sistema de tickets | Tiempo de resolución, tasa de escalada |
| Proceso manual sin sistema | Registro manual semanal, muestreo | Estimación de tiempo de ciclo |
| Proceso con múltiples sistemas | Log aggregation o medición manual de puntos de control | Tiempo entre sistemas |

**Para procesos sin datos automatizados:**
Crear un registro manual simple:

| Fecha inicio | Fecha fin | Actor principal | ¿Tuvo excepción? | ¿Retrabajo? |
|-------------|----------|----------------|-----------------|------------|
| [timestamp] | [timestamp] | [nombre] | Sí/No | Sí/No |

Actualizar semanalmente con una muestra aleatoria de 5-10 instancias.
