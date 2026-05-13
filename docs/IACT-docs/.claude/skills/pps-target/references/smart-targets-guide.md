# Guía de Targets SMART — PS8

> Referencia para la definición de objetivos medibles en el Step 3 de Toyota TBP.

---

## ¿Por qué SMART en TBP?

Toyota TBP requiere targets explícitos y medibles por una razón fundamental: si no se puede medir el éxito, no se puede confirmar que las contramedidas funcionaron. Un target vago permite declarar éxito de forma subjetiva, lo que invalida el aprendizaje del ciclo de mejora.

El target también protege contra el **sesgo post-hoc**: sin target pre-definido, hay tendencia a ajustar la definición de éxito según los resultados obtenidos.

---

## SMART — criterios y verificación

### S — Específico (Specific)

El target debe nombrar exactamente qué métrica cambia y en qué dirección.

| Específico | No específico |
|-----------|--------------|
| "% de pedidos entregados a tiempo" | "la satisfacción del cliente" |
| "tiempo promedio de resolución de tickets (horas)" | "el rendimiento del equipo" |
| "tasa de defectos por 1000 unidades" | "la calidad del proceso" |

### M — Medible (Measurable)

Debe existir un método concreto para medir la métrica.

Preguntas de verificación:
- ¿De dónde vienen los datos? (sistema, herramienta, proceso manual)
- ¿Cómo se calcula exactamente la métrica?
- ¿Quién tiene acceso a los datos?
- ¿Con qué frecuencia se pueden obtener?

### A — Alcanzable (Achievable)

El target debe ser ambicioso pero posible dado el contexto real.

**Fuentes de referencia para alcanzabilidad:**
- Benchmarks de la industria (qué logran organizaciones similares)
- Historial propio de mejoras pasadas
- Análisis de capacidad del proceso actual
- Opinión de expertos con experiencia en mejoras similares

**Señales de target no alcanzable:**
- Requiere tecnología que no existe o no está disponible
- Requiere recursos que están explícitamente fuera de alcance
- Ninguna organización similar lo ha logrado en el mismo plazo

**Señales de target demasiado fácil:**
- Se puede lograr sin cambiar nada significativo
- Ya ocurre en algunos períodos o condiciones
- No requiere resolver el problema de fondo

### R — Relevante (Relevant)

El target debe conectar con un objetivo del negocio o de la organización.

Trazabilidad: Problema → Target → Objetivo de negocio

Ejemplo:
```
Problema: 23% de deploys fallan en health check
Target: Reducir a <5% en 3 meses
Objetivo de negocio: Reducir tiempo de inactividad no planificado (SLA con cliente)
```

### T — Temporal (Time-bound)

Debe tener una fecha específica de cumplimiento.

| Temporal | No temporal |
|---------|------------|
| "para el 2026-07-01" | "pronto" |
| "en las próximas 8 semanas" | "en el corto plazo" |
| "antes del cierre del Q2 2026" | "eventualmente" |

---

## Ejemplos de targets SMART vs no-SMART

| No-SMART | SMART equivalente |
|---------|-----------------|
| "Mejorar la calidad" | "Reducir la tasa de defectos de 3.2% a menos de 0.8% para 2026-08-01, medido en el sistema QA, sin incrementar el tiempo de ciclo por encima de 4.5 días" |
| "Reducir incidentes" | "Reducir los incidentes Sev-1 de 8/mes a 2/mes para 2026-06-30, medido en el sistema de incident management, sin degradar el MTTR por encima de 45 minutos" |
| "Acelerar el proceso" | "Reducir el tiempo de aprobación de órdenes de compra de 5.2 días a 2 días para 2026-07-15, medido en el ERP, sin incrementar el % de órdenes con errores por encima del 2%" |

---

## Validación de alcanzabilidad — benchmarking

**Cómo encontrar benchmarks:**
1. Informes de industria (Gartner, Forrester, estudios sectoriales)
2. Proyectos similares dentro de la organización (historial de mejoras)
3. Publicaciones de casos de mejora en metodologías similares (Lean, Six Sigma)
4. Consulta con expertos del dominio

**Preguntas de benchmarking:**
- "¿Qué porcentaje de reducción es razonable en un proyecto de 3 meses?"
- "¿Organizaciones similares han logrado resultados comparables? ¿En cuánto tiempo?"
- "¿El estado actual del proceso permite esta mejora, o requiere primero inversión en infraestructura?"

---

## El período de confirmación sostenida

Un target alcanzado una sola vez puede ser un pico de variación, no mejora real. El período de confirmación sostenida asegura que la mejora es estable:

| Tipo de proceso | Período de confirmación recomendado |
|----------------|-------------------------------------|
| Procesos con alta variabilidad diaria | 4 semanas consecutivas dentro del target |
| Procesos semanales/mensuales | 3 ciclos consecutivos dentro del target |
| Procesos de baja frecuencia | Definir criterio específico según ciclo |

> El período de confirmación se define en pps:target y se verifica en pps:evaluate.
