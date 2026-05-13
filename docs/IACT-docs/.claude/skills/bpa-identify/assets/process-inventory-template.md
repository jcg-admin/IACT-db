# Process Inventory — Template

```yml
created_at: [timestamp]
project: [nombre del proyecto]
work_package: [wp-id]
phase: bpa:identify
author: [nombre]
status: Borrador
```

---

## Contexto del relevamiento

| Campo | Valor |
|-------|-------|
| **Área / dominio** | [nombre del área o unidad de negocio] |
| **Período de relevamiento** | [YYYY-MM-DD a YYYY-MM-DD] |
| **Facilitador** | [nombre] |
| **Fuentes consultadas** | [lista de stakeholders y documentos] |

---

## Inventario de procesos

| # | Process Name | Owner | Frecuencia | Volumen/día | Pain Level (1-5) | Impacto Estratégico (1-5) | Priority Score |
|---|-------------|-------|-----------|------------|-----------------|--------------------------|---------------|
| 1 | [Nombre proceso] | [Nombre] | Diaria / Semanal / Mensual | [N transacciones] | [1-5] | [1-5] | [calculado] |
| 2 | [Nombre proceso] | [Nombre] | | | | | |
| 3 | [Nombre proceso] | [Nombre] | | | | | |
| 4 | [Nombre proceso] | [Nombre] | | | | | |
| 5 | [Nombre proceso] | [Nombre] | | | | | |

**Fórmula Priority Score:**
```
Priority Score = (Frecuencia_norm × 0.2) + (Volumen_norm × 0.2) + (Pain Level × 0.3) + (Impacto Estratégico × 0.3)
```

*Ver normalización y criterios completos: [process-prioritization.md](../references/process-prioritization.md)*

---

## Pain Level — justificación por proceso

| Proceso | Pain Level | Evidencia / Fuente |
|---------|-----------|-------------------|
| [Nombre proceso] | [1-5] | [Cita textual de entrevista / dato de sistema] |

---

## Resultado de priorización

| Priority Score | Procesos |
|---------------|---------|
| **Alta (≥ 4.0)** | [lista] |
| **Media (2.5–3.9)** | [lista] |
| **Baja (< 2.5)** | [lista] |

---

## Proceso seleccionado para análisis

| Campo | Descripción |
|-------|-------------|
| **Nombre del proceso** | [nombre oficial] |
| **Owner** | [nombre + cargo] |
| **Motivo de selección** | [por qué este proceso y no otro] |
| **Priority Score** | [valor] |
| **Trigger** | [¿qué evento inicia el proceso?] |
| **Output final** | [¿qué produce el proceso cuando termina?] |
| **Cliente del output** | [¿quién recibe y usa el output?] |
| **Límite inicial (start)** | [primera actividad del proceso] |
| **Límite final (end)** | [última actividad del proceso] |
| **Out of scope** | [qué procesos relacionados NO están incluidos] |

---

## Validación con stakeholders

| Stakeholder | Rol | Fecha revisión | Aprobación | Comentarios |
|-------------|-----|---------------|-----------|-------------|
| [nombre] | Process Owner | [YYYY-MM-DD] | ✅ / ❌ Pendiente | [notas] |
| [nombre] | Management | [YYYY-MM-DD] | ✅ / ❌ Pendiente | [notas] |

---

## Procesos para próximos ciclos

*Procesos con score medio que se analizarán en iteraciones futuras:*

| Proceso | Score | Fecha estimada de análisis |
|---------|-------|--------------------------|
| [nombre] | [score] | [trimestre/año] |
