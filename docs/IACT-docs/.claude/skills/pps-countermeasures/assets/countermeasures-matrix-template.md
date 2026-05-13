# Countermeasures Matrix — PS8 Step 5

> Template de la Matriz de Contramedidas y Action Plan.
> Completar en pps:countermeasures antes de avanzar a pps:implement.

---

## Información general

| Campo | Valor |
|-------|-------|
| **Proyecto / WP** | [nombre del WP] |
| **Causa raíz principal** | [de pps:analyze] |
| **Facilitador** | [nombre] |
| **Fecha** | [YYYY-MM-DD] |
| **Aprobado por** | [dueño del proceso o sponsor] |

---

## Sección 1 — Causas raíz a atender

Lista de causas raíz confirmadas en pps:analyze:

| # | Causa raíz | Confirmada con | Impacto en el problema |
|---|-----------|----------------|----------------------|
| CR-1 | [descripción de la causa raíz] | [dato/evidencia] | [% de los casos o descripción de impacto] |
| CR-2 | [descripción de la causa raíz] | [dato/evidencia] | [% de los casos o descripción de impacto] |

---

## Sección 2 — Generación de contramedidas

Para cada causa raíz, listar todas las opciones consideradas (antes de evaluar):

### CR-1: [descripción de causa raíz]

| Opción | Descripción | Tipo | Nivel de intervención |
|--------|-------------|------|----------------------|
| CM-1A | [descripción específica de la contramedida] | Preventiva | Eliminación / Sustitución / Control de ingeniería / Administrativo / Señalización |
| CM-1B | [descripción específica de la contramedida] | Correctiva | Eliminación / Sustitución / Control de ingeniería / Administrativo / Señalización |
| CM-1C | [descripción específica de la contramedida] | Detectiva | Eliminación / Sustitución / Control de ingeniería / Administrativo / Señalización |

### CR-2: [descripción de causa raíz]

| Opción | Descripción | Tipo | Nivel de intervención |
|--------|-------------|------|----------------------|
| CM-2A | [descripción específica de la contramedida] | Preventiva | [nivel] |
| CM-2B | [descripción específica de la contramedida] | Correctiva | [nivel] |

---

## Sección 3 — Evaluación de contramedidas

Evaluar cada opción con puntaje 1-5 por criterio:

| Contramedida | CR que atiende | Impacto (1-5) | Factibilidad (1-5) | Velocidad (1-5) | Costo (1-5) | Total | Seleccionar |
|-------------|---------------|--------------|-------------------|----------------|------------|-------|-------------|
| CM-1A | CR-1 | | | | | | ✅ / ❌ |
| CM-1B | CR-1 | | | | | | ✅ / ❌ |
| CM-1C | CR-1 | | | | | | ✅ / ❌ |
| CM-2A | CR-2 | | | | | | ✅ / ❌ |
| CM-2B | CR-2 | | | | | | ✅ / ❌ |

**Escala de evaluación:**

| Criterio | 1 | 3 | 5 |
|----------|---|---|---|
| **Impacto** | Marginal — no resuelve la causa raíz | Parcial — reduce el problema pero no lo elimina | Alto — cierra completamente la brecha con el target |
| **Factibilidad** | Requiere recursos fuera del control del equipo | Requiere coordinación con otras áreas | Completamente en control del equipo |
| **Velocidad** | Más de 3 meses para implementar | 1-3 meses | Menos de 1 mes / esta semana |
| **Costo** | Inversión significativa (>$X o >Y personas) | Moderado | Prácticamente sin costo adicional |

---

## Sección 4 — Action Plan

Contramedidas seleccionadas con responsables, deadlines y métricas de verificación:

| # | CM | Causa raíz atendida | Descripción específica | Responsable | Deadline | Métrica de verificación | Estado |
|---|----|--------------------|----------------------|-------------|----------|------------------------|--------|
| 1 | [CM-ID] | CR-[N] | [qué exactamente se va a hacer] | [nombre — 1 persona] | [YYYY-MM-DD] | [cómo verificar que funcionó] | Pendiente |
| 2 | [CM-ID] | CR-[N] | [qué exactamente se va a hacer] | [nombre — 1 persona] | [YYYY-MM-DD] | [cómo verificar que funcionó] | Pendiente |
| 3 | [CM-ID] | CR-[N] | [qué exactamente se va a hacer] | [nombre — 1 persona] | [YYYY-MM-DD] | [cómo verificar que funcionó] | Pendiente |

**Secuencia / Dependencias:**

[Si alguna contramedida debe ejecutarse antes de otra, documentar la secuencia aquí]

```
CM-1 → CM-2 (CM-2 depende de que CM-1 esté completa)
CM-3 puede ejecutarse en paralelo con CM-1
```

---

## Sección 5 — Cobertura de causas raíz

Verificar que todas las causas raíz confirmadas tienen al menos una contramedida:

| Causa raíz | Contramedida(s) seleccionada(s) | ¿Cubierta? |
|-----------|--------------------------------|-----------|
| CR-1 | CM-[N] | ✅ / ❌ |
| CR-2 | CM-[N] | ✅ / ❌ |

**¿Hay causas raíz sin contramedida?**
- [ ] No — todas las causas raíz están cubiertas
- [ ] Sí — [causa raíz N] queda sin atender por [razón: fuera de alcance / sin recursos / decisión deliberada]
  - Documentar como deuda de proceso para el siguiente ciclo

---

## Sección 6 — Justificación de selección

[¿Por qué se seleccionaron estas contramedidas? Qué alternativas se descartaron y por qué]

[Referencia a la evaluación de factibilidad/impacto si aplica]

---

## Sección 7 — Aprobación

| Campo | Valor |
|-------|-------|
| **Aprobado por** | [dueño del proceso o sponsor] |
| **Fecha** | [YYYY-MM-DD] |
| **Comentarios** | [observaciones del aprobador si aplica] |

**Siguiente paso:** pps:implement — ejecutar el Action Plan y registrar el progreso en el Implementation Log.
