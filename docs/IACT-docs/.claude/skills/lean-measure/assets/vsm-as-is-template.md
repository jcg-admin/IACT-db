# VSM As-Is — Template de artefacto

```yml
created_at: [timestamp]
project: [nombre del proyecto]
work_package: [wp-id]
phase: lean:measure
author: [nombre]
status: Borrador
```

---

## Información del flujo de valor

| Campo | Valor |
|-------|-------|
| **Nombre del flujo de valor** | [Nombre del proceso — ej: "Proceso de aprobación de facturas"] |
| **Familia de producto/servicio** | [Qué produce el proceso para el cliente] |
| **Punto de inicio (supplier)** | [Quién o qué inicia el proceso] |
| **Punto de fin (customer)** | [Quién recibe el output final] |
| **Fecha del Gemba** | [YYYY-MM-DD] |
| **Observadores** | [Nombres del equipo que realizó el Gemba] |

---

## Takt Time — ritmo del cliente

```
Tiempo disponible por período: [X minutos/día o semana]
Demanda del cliente por período: [N unidades/día o semana]

Takt Time = [X] / [N] = [Z] minutos/unidad

Interpretación: el proceso debe completar 1 [unidad] cada [Z] minutos para satisfacer la demanda.
```

---

## VSM As-Is — Mapa del proceso actual

> Dibujar el VSM aquí. Usar el texto a continuación como representación textual si no hay herramienta de diagramas disponible.

```
PROVEEDOR                                                        CLIENTE
[Nombre]                                                         [Nombre]
   |                                                                |
   ↓                                                                ↑
[PASO 1]──▽──[PASO 2]──▽──[PASO 3]──▽──[PASO 4]──▽──[PASO 5]─────→
 CT:Xmin    CT:Xmin     CT:Xmin     CT:Xmin     CT:Xmin
 Op: N      Op: N       Op: N       Op: N       Op: N
 Up: X%     Up: X%      Up: X%      Up: X%      Up: X%

▽ WIP:N    ▽ WIP:N     ▽ WIP:N     ▽ WIP:N

─────────────────────── TIMELINE ───────────────────────────────────
[CT:Xm][Esp:Xm][CT:Xm][Esp:Xm][CT:Xm][Esp:Xm][CT:Xm][Esp:Xm][CT:Xm]
  VA     NVA     VA     NVA     VA     NVA     VA     NVA     VA
```

**Leyenda:**
- `▽` = Inventario/WIP entre pasos
- `→` = Flujo push
- `○→` = Flujo pull (Kanban)
- `CT` = Cycle Time observado
- `Op` = Número de operadores
- `Up` = Uptime del paso
- `Esp` = Tiempo de espera (NVA)

---

## Datos por paso de proceso

### Paso 1 — [Nombre del paso]

| Campo | Valor |
|-------|-------|
| Cycle Time (CT) promedio | [X min] — basado en [N] observaciones |
| CT mínimo | [X min] |
| CT máximo | [X min] |
| Número de operadores | [N] |
| Uptime | [X%] |
| Setup time (si aplica) | [X min] |
| Tipo de flujo: push o pull | Push / Pull |

### Paso 2 — [Nombre del paso]

| Campo | Valor |
|-------|-------|
| Cycle Time (CT) promedio | [X min] |
| CT mínimo | [X min] |
| CT máximo | [X min] |
| Número de operadores | [N] |
| Uptime | [X%] |
| Setup time (si aplica) | [X min] |
| Tipo de flujo | Push / Pull |

### Paso 3 — [Nombre del paso]
*(repetir para cada paso del proceso)*

---

## Inventario/WIP entre pasos

| Entre pasos | WIP actual (items) | Tiempo de espera promedio | Tipo de waste |
|-------------|-------------------|--------------------------|--------------|
| [Paso 1] → [Paso 2] | [N items] | [X horas/días] | Inventory / Waiting |
| [Paso 2] → [Paso 3] | [N items] | [X horas/días] | Inventory / Waiting |
| [Paso 3] → [Paso 4] | [N items] | [X horas/días] | Inventory / Waiting |

---

## Flujo de información

| Señal de información | Tipo | Frecuencia | Receptor |
|---------------------|------|-----------|---------|
| [Cómo el proceso sabe qué producir] | Push (forecast) / Pull (señal real) | [Diario/semanal/por demanda] | [Quién recibe] |
| [Orden del cliente] | | | |
| [Señal de reabastecimiento] | | | |

---

## Timeline VA/NVA — resumen del lead time

| Segmento | Duración | VA / NVA | Notas |
|----------|----------|---------|-------|
| Paso 1 — [Nombre] | [X min] | VA | |
| Espera 1→2 | [X horas] | NVA | Waste: Waiting / Inventory |
| Paso 2 — [Nombre] | [X min] | VA | |
| Espera 2→3 | [X horas] | NVA | |
| Paso 3 — [Nombre] | [X min] | VA / NVA-N / NVA-P | |
| *(continuar)* | | | |

---

## Métricas de flujo — estado actual (Baseline)

| Métrica | Valor As-Is | Objetivo To-Be | Gap |
|---------|------------|----------------|-----|
| **Lead Time total** | [X días/horas] | [Y días/horas] | [Z%] |
| **VA Time total** | [X min] | — | — |
| **Process Efficiency** | [X%] = VA Time / Lead Time | [Y%] | [+Z pp] |
| **WIP total en proceso** | [N items] | [N' items] | [Z items] |
| **Takt Time** | [X min/unidad] | [Mismo — driven by demand] | — |
| **CT del cuello de botella** | [X min — Paso N] | [≤ Takt Time] | [Z min] |
| **% tiempo en espera** | [X%] | [Y%] | [Z pp] |

---

## TIMWOOD Checklist sobre el VSM

| Waste | ¿Identificado? | Ubicación en el VSM | Magnitud estimada |
|-------|---------------|--------------------|--------------------|
| T — Transportation | Sí / No | [Entre pasos X y Y] | [N handoffs] |
| I — Inventory | Sí / No | [Buffer entre X y Y] | [N items, X horas] |
| M — Motion | Sí / No | [Paso X] | [N búsquedas/turno] |
| W — Waiting | Sí / No | [Espera entre X e Y] | [X% del lead time] |
| O — Overproduction | Sí / No | [Paso X] | [N unidades extra] |
| O — Overprocessing | Sí / No | [Paso X] | [N pasos innecesarios] |
| D — Defects | Sí / No | [Paso X / salida] | [X% tasa de reproceso] |

**Wastes dominantes para lean:analyze:** [Top 2-3 con mayor impacto en Lead Time]

---

## Observaciones Gemba — notas de campo

| Observación | Paso asociado | Waste relacionado |
|-------------|--------------|------------------|
| [Qué se vio en la observación directa] | [Paso N] | [TIMWOOD type] |
| | | |
| | | |

---

## Validación del mapa

| Criterio de validación | Estado |
|-----------------------|--------|
| VSM construido con observación Gemba (no desde reuniones) | ✅ / ❌ |
| Cycle Times basados en mínimo 5 observaciones por paso | ✅ / ❌ |
| Takt Time calculado con datos reales de demanda | ✅ / ❌ |
| Timeline VA/NVA completo con todos los tiempos de espera | ✅ / ❌ |
| Process Efficiency calculado | ✅ / ❌ |
| WIP/inventario contado físicamente entre pasos | ✅ / ❌ |
| Flujo de información mapeado (push vs pull) | ✅ / ❌ |
