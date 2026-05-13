# Action Planning — PDCA:Plan

Guías para construir el plan de acción del paso Plan: objetivos SMART, diseño de acciones y seguimiento.

---

## Objetivos SMART — guía de construcción

| Criterio | Descripción | Check de calidad |
|----------|-------------|-----------------|
| **S**pecífico | Nombra la métrica exacta y el proceso/sistema | ¿Se puede señalar en un dashboard o log? |
| **M**edible | Tiene valor numérico de baseline y target | ¿Se puede calcular el % de mejora? |
| **A**lcanzable | El equipo tiene control sobre las variables | ¿Puede el equipo ejecutar las acciones sin depender de terceros no confirmados? |
| **R**elevante | Conecta la métrica con un impacto de negocio | ¿El sponsor firmaría esto como importante? |
| **T**emporal | Tiene fecha de corte para medir el Check | ¿Es suficiente tiempo para que los cambios surtan efecto? |

**Ejemplos:**

| ❌ Objetivo débil | ✅ Objetivo SMART |
|-------------------|------------------|
| "Mejorar la velocidad de la API" | "Reducir p95 latencia /orders de 2.1s a <800ms para 2026-05-01 sin incrementar costo de infraestructura" |
| "Reducir errores en producción" | "Reducir tasa de error 5xx de 0.8% a <0.1% en los próximos 30 días, medido en Datadog" |
| "Mejorar satisfacción del cliente" | "Incrementar NPS de 32 a ≥45 en la encuesta post-servicio del Q2 2026" |

**Trampa del objetivo compuesto:** un objetivo con dos métricas ("reducir latencia Y reducir costo") dificulta el Check. Si la latencia mejora pero el costo no, ¿el ciclo fue exitoso? Definir un objetivo primario y listar los secundarios como restricciones ("sin degradar X").

---

## Diseño de acciones

Cada acción del plan debe ser atómica, asignable y verificable:

| Campo | Descripción | Señal de calidad |
|-------|-------------|-----------------|
| **Acción** | Verbo + objeto + contexto | "Agregar índice compuesto en orders(user_id, created_at)" — no "mejorar base de datos" |
| **Responsable** | Persona específica (no "el equipo") | Nombre o rol único; si es compartido, definir coordinador |
| **Fecha** | Fecha de completitud, no de inicio | Permite priorizar; si hay dependencias, listar el orden |
| **Recursos** | Qué necesita para ejecutar | Tiempo estimado, acceso, herramientas, aprobaciones |
| **Criterio de éxito** | Cómo saber que la acción está terminada | Observable y binario: "sí/no está hecho", no "avanzado" |

**Plantilla de acción completa:**
```
Acción:    Agregar índice compuesto en tabla orders(user_id, created_at)
Responsable: María García (DBA)
Fecha:     2026-04-25
Recursos:  Acceso write a DB prod, ventana de mantenimiento de 30 min
Éxito:     EXPLAIN del query principal muestra "Index Scan" en lugar de "Seq Scan"
```

---

## Secuenciación y dependencias

Cuando hay varias acciones, identificar el orden correcto:

1. **Acciones paralelas:** se pueden ejecutar simultáneamente (sin dependencia entre sí)
2. **Acciones secuenciales:** B requiere que A esté completa
3. **Acciones bloqueantes:** si no se puede completar, el Plan no puede avanzar

**Formato mínimo de DAG:**
```
[A: Diagnóstico de queries] → [B: Crear índice] → [C: Verificar en staging] → [D: Deploy a prod]
                              ↑
[E: Backup pre-cambio] ──────┘  (E es prereq de B)
```

---

## Gantt mínimo

Para planes con más de 3 acciones o más de 1 semana de duración, un Gantt de texto es suficiente:

```
Semana 1:  [A] Diagnóstico ████████
           [E] Backup      ████
Semana 2:  [B] Índice            ████
           [C] Staging               ████████
Semana 3:  [D] Deploy                        ████
```

**Regla:** el Gantt no necesita ser preciso al día. Su propósito es revelar si el plan es realista dado el tiempo disponible y si hay cuellos de botella.

---

## Señales de un plan débil

| Señal | Problema | Corrección |
|-------|----------|------------|
| Todas las acciones tienen el mismo responsable | Cuello de botella; si esa persona falla, todo falla | Distribuir o designar backup |
| "Fecha: por definir" en más de 1 acción | El plan no es ejecutable aún | No avanzar a Do sin fechas concretas |
| Acciones = soluciones técnicas directas sin validación previa | El Plan saltó análisis de causa | Agregar acción de validación de hipótesis antes de la implementación |
| Criterio de éxito = "está hecho" | No verificable objetivamente | Definir el observable concreto: log, métrica, screenshot |
