# Lean Tools Guide — DMAIC:Improve

Catálogo de herramientas Lean para eliminar waste de proceso y flujo. Incluye tipo de waste que resuelve, cuándo aplicar y cómo implementar.

---

## Los 7 desperdicios (MUDA) — referencia rápida

| # | Desperdicio | Síntoma típico | Herramienta principal |
|---|------------|----------------|----------------------|
| 1 | **Sobreproducción** | WIP acumulado, producción antes de que sea necesario | Kanban, Heijunka |
| 2 | **Espera** | Tiempo idle entre pasos, colas | Balanceo de línea, SMED |
| 3 | **Transporte** | Mover materiales/información sin necesidad | Layout optimization, Value Stream redesign |
| 4 | **Sobreprocesamiento** | Pasos que no agregan valor para el cliente | Eliminación de actividades NVA |
| 5 | **Inventario** | WIP excesivo, materiales sin usar | Kanban, Pull system |
| 6 | **Movimiento** | Operadores buscando herramientas, datos | 5S, workplace organization |
| 7 | **Defectos / Reproceso** | Retrabajo, inspección excesiva | Jidoka, Poka-yoke, 5S |

> **MUDA 8 (no oficial):** Talento no aprovechado — habilidades del equipo no utilizadas. Se resuelve con empowerment y sistemas de sugerencias.

---

## 5S — Clasificar, Ordenar, Limpiar, Estandarizar, Sostener

**Tipo de waste que resuelve:** Movimiento (búsquedas), Defectos (entorno caótico), Espera (herramientas no disponibles)

### Las 5 fases

| Fase | Japonés | Descripción | Pregunta guía |
|------|---------|-------------|--------------|
| **S1 — Clasificar** | Seiri | Separar lo necesario de lo innecesario | ¿Se ha usado esto en los últimos 30 días? |
| **S2 — Ordenar** | Seiton | Un lugar para cada cosa, cada cosa en su lugar | ¿Se puede encontrar esto en menos de 30 segundos? |
| **S3 — Limpiar** | Seiso | Limpiar e inspeccionar mientras se limpia | ¿La limpieza revela problemas de equipo o proceso? |
| **S4 — Estandarizar** | Seiketsu | Hacer que los estados anteriores sean el estándar | ¿Cómo hacemos que sea imposible desorganizarse? |
| **S5 — Sostener** | Shitsuke | Mantener la disciplina con auditorías y hábitos | ¿Cómo verificamos que se mantiene el estándar? |

### Cómo aplicar en un área de trabajo

1. **Delimitar el área** (física o digital — aplica a carpetas, wikis, tableros también)
2. **S1:** Auditar todo — usar etiquetas rojas ("Red Tag") para items no necesarios; decidir: eliminar / relocalizar / mantener
3. **S2:** Para lo que queda, asignar ubicación fija y marcarla visualmente (etiquetas, contornos, colores)
4. **S3:** Limpiar el área completamente; documentar anomalías encontradas durante la limpieza
5. **S4:** Fotografiar el estado objetivo; crear checklist de auditoría 5S
6. **S5:** Auditoría semanal/mensual; asignar responsable de área

**Tiempo estimado de implementación:** 1-2 semanas para un área física de trabajo; 1-3 días para workspace digital.

---

## Kanban — Control visual del flujo de trabajo

**Tipo de waste que resuelve:** Sobreproducción (WIP excesivo), Espera (cuellos de botella visibles)

### Principios fundamentales

| Principio | Descripción |
|-----------|-------------|
| **Visualizar el trabajo** | Todo el trabajo en progreso es visible en el tablero |
| **Limitar el WIP** | Cada columna tiene un límite máximo de items simultáneos |
| **Gestionar el flujo** | El objetivo es maximizar el throughput, no la utilización individual |
| **Pull, no push** | El siguiente paso "jala" el trabajo cuando tiene capacidad |

### Estructura básica de un tablero Kanban

```
┌──────────────┬──────────────┬──────────────┬──────────────┐
│   BACKLOG    │  EN PROCESO  │  EN REVISIÓN │   TERMINADO  │
│              │   (WIP: 3)   │   (WIP: 2)   │              │
├──────────────┼──────────────┼──────────────┼──────────────┤
│ [Item A]     │ [Item D] ◆   │ [Item G]     │ [Item J] ✓   │
│ [Item B]     │ [Item E] ◆   │ [Item H]     │ [Item K] ✓   │
│ [Item C]     │ [Item F]     │              │              │
│ ...          │              │              │              │
└──────────────┴──────────────┴──────────────┴──────────────┘
◆ = bloqueado    WIP: 3 = máximo 3 items simultáneos
```

### Cómo definir el límite WIP

**Método 1 — Little's Law:** WIP = Throughput × Lead Time
- Si quiero Lead Time de 5 días y el equipo hace 2 items/día → WIP = 10

**Método 2 — Empírico:** Observar el nivel de WIP actual, reducir 20%, medir impacto en Lead Time

**Señal de WIP mal calibrado:** Si el límite se viola constantemente → el límite es demasiado bajo o hay un cuello de botella upstream que necesita resolverse.

---

## SMED — Single-Minute Exchange of Die

**Tipo de waste que resuelve:** Espera (tiempos de setup, cambios de formato, configuración)

### Principio central

```
Actividades internas → Solo se pueden hacer con la máquina/proceso PARADO
Actividades externas → Se pueden hacer mientras la máquina/proceso está CORRIENDO
```

**Objetivo SMED:** Convertir la mayor cantidad posible de actividades internas en externas.

### Las 3 fases de SMED

| Fase | Qué hacer | Cómo |
|------|-----------|------|
| **Fase 1 — Observar y documentar** | Registrar todas las actividades del setup actual con cronómetro | Video + stopwatch; separar en tabla interna vs externa |
| **Fase 2 — Convertir internas en externas** | Identificar qué actividades internas se pueden preparar mientras el proceso corre | Preguntar: ¿por qué no podemos hacerlo antes de que pare? |
| **Fase 3 — Reducir tiempo de actividades internas** | Para las que quedan como internas, reducir su duración | Estandarizar, pre-posicionar, herramientas especiales, paralelizar |

**Meta:** Reducir el tiempo total de setup a menos de 10 minutos (la "S" de Single-Minute es aspiracional — meta < 10 minutos).

---

## Jidoka — Autonomación (detección automática de defectos)

**Tipo de waste que resuelve:** Defectos que pasan desapercibidos, inspección al final del proceso

### Concepto

Jidoka significa que el proceso puede detectar automáticamente cuando algo no está bien y:
1. Parar el proceso inmediatamente (o alertar)
2. Señalar el problema visualmente (Andon)
3. Permitir que humanos investiguen y corrijan la causa raíz

### Niveles de implementación

| Nivel | Descripción | Ejemplo |
|-------|-------------|---------|
| **1 — Detección manual** | El operador detecta el problema y para | Checklist de verificación en cada paso |
| **2 — Alerta automática** | Sistema detecta y alerta; humano decide parar | Monitor de métricas con umbral de alerta |
| **3 — Parada automática** | Sistema detecta y para automáticamente | CI/CD que falla el build si tests fallan |
| **4 — Poka-yoke** | El diseño hace imposible el error | Formulario que no permite guardar sin campo obligatorio |

---

## Heijunka — Nivelación de la producción

**Tipo de waste que resuelve:** Demanda variable que genera cuellos de botella y WIP variable

### Principio

```
Sin Heijunka: Lunes 200 unidades → Martes 50 unidades → Miércoles 400 unidades
Con Heijunka: Lunes 217 unidades → Martes 217 unidades → Miércoles 217 unidades
```

**Objetivo:** Distribuir el volumen (y la variedad) de trabajo uniformemente en el tiempo.

### Cuándo es aplicable

| Situación | ¿Heijunka aplica? |
|-----------|------------------|
| Demanda del cliente es variable (picos y valles) | ✅ Sí — nivelar la producción interna |
| Variedad de productos/servicios con tiempos de ciclo diferentes | ✅ Sí — mezclar variedad uniformemente |
| Proceso de software con sprints irregulares | ✅ Sí — nivelar el backlog por capacidad real |
| Demanda genuinamente impredecible (emergencias) | ❌ No — Heijunka requiere demanda planificable |

---

## Eliminación de MUDA — actividades NVA

### Clasificación de actividades

| Tipo | Descripción | Ejemplo | Acción |
|------|-------------|---------|--------|
| **VA (Value-Added)** | El cliente pagaría por esto; transforma el producto/servicio | Escribir código, fabricar la pieza | Optimizar, no eliminar |
| **NVA Necesaria** | No agrega valor al cliente pero es necesaria (regulatoria, técnica) | Pruebas de seguridad, aprobaciones legales | Reducir tiempo/costo si posible |
| **NVA Pura** | No agrega valor y se puede eliminar | Reuniones sin agenda, reportes sin audiencia, doble registro de datos | Eliminar inmediatamente |

### Proceso de eliminación de NVA pura

1. Mapear todas las actividades del proceso (usar VSM o swim lane)
2. Clasificar cada actividad: VA / NVA Necesaria / NVA Pura
3. Para cada NVA Pura: preguntar *"¿Por qué existe esta actividad?"*
4. Si no hay razón válida → eliminar
5. Medir el tiempo liberado y verificar que el proceso sigue funcionando sin esa actividad
